require 'rake/clean'
require 'haml'
require 'liquid'
require 'fileutils'

RAKEFILE = 'Rakefile'


###############################################################################
#  LessCSS & CoffeeScript

WIDGETS_LESS   = FileList['widgets/**/*.less']
WIDGETS_COFFEE = FileList['widgets/**/*.coffee']

WIDGETS_CSS = WIDGETS_LESS.ext('css')
WIDGETS_JS  = WIDGETS_COFFEE.ext('js')

DEMO_LESS   = FileList['demo/**/*.less']
DEMO_COFFEE = FileList['demo/**/*.coffee']

DEMO_CSS = DEMO_LESS.ext('css')
DEMO_JS  = DEMO_COFFEE.ext('js')

CLOBBER.include(WIDGETS_CSS, WIDGETS_JS, DEMO_CSS, DEMO_JS)

rule '.css' => '.less' do |t|
   puts "  LESS #{t.source}"
   sh 'lessc', t.source, t.name
end

rule '.js' => '.coffee' do |t|
   puts "COFFEE #{t.source}"
   sh 'coffee', '-c', t.source
end


###############################################################################
#  HAML

HAML          = FileList['**/*.haml']
DEMO_HAML     = FileList['demo/demo-*.haml']
NON_DEMO_HAML = HAML - DEMO_HAML

HTML = HAML.ext('html')

CLOBBER.include(HTML)

NON_DEMO_HAML.each do |haml_file|
    html_file = haml_file.ext('html')
    file html_file => [haml_file, RAKEFILE] do |t|
        puts "  HAML #{haml_file}"
        output = Haml::Engine.new(File.read(haml_file)).render
        File.open(html_file, 'w') { |f| f.write output }
    end
end

DEMO_HAML.each do |haml_file|
    html_file = haml_file.ext('html')
    template_file = "demo/layouts/default.html"
    raise StandardError unless haml_file =~ /demo-(.*)\.haml/
    widget_path = $1
    widget_title = $1[0..0].upcase + $1[1..-1]
    css_files = []

    demo_less = File.join(File.dirname(haml_file), File.basename(haml_file, ".haml") + ".less")
    if File.exists? demo_less
        css_files << File.basename(demo_less.ext('css'))
    end

    file html_file => [haml_file, template_file, RAKEFILE] do |t|
        puts "  HAML #{haml_file}"
        output = Haml::Engine.new(File.read(haml_file)).render

        template_body = File.read(template_file)
        output = Liquid::Template.parse(template_body).render 'page' => {
            'title' => "Wi #{widget_title}",
            'stylesheets' => css_files.collect { |file| { 'url' => file }},
        }, 'content' => output.strip

        File.open(html_file, 'w') { |f| f.write output }
    end
end


###############################################################################
#  Images

WIDGETS_IMAGES = FileList['widgets/**/images/wi-*.{png,gif,jpg}']


###############################################################################
#  Versioning

VERSION_FILE = 'VERSION'

def read_version
    File.read(VERSION_FILE).strip
end

def stored_version
    $version ||= read_version
end

def is_dev_version? version
    version =~ /-dev$/
end

def dev_version
    stored_version + "-dev"
end

def release_version
    stored_version
end


###############################################################################
#  Distribution

DIST_DIR = 'dist'

DIST_CSS    = []
DIST_JS     = []
DIST_IMAGES = []
DIST_HTML   = []

VARIANTS = [
    ['iphone', ['webkit']],
    ['desktop', ['webkit', 'moz', 'desktop']],
    ['mockko', ['webkit', 'desktop', 'img']],
]

def filter files, keywords
    files.select do |file|
        if file =~ %r,/\+([\w\d+]+)/,
            conditions = $1.split('+')
            conditions.all? do |cond|
                if cond =~ /^no(.*)$/
                    inverse_cond = $1
                    not keywords.include? inverse_cond
                else
                    keywords.include? cond
                end
            end
        else
            true
        end
    end
end

class Dist < Struct.new(:version, :version_dir, :html, :css, :js, :images, :docs)
    def all
        html + css + js + images + docs
    end
end

def setup_packaging_tasks version
    version_dir ||= File.join(DIST_DIR, "wi-#{version}")
    dist = Dist.new
    dist.version = version
    dist.version_dir = version_dir
    dist.html, dist.css, dist.js, dist.images, dist.docs = [], [], [], [], []

    WIDGETS_IMAGES.each do |source_image|
        target_image = File.join(version_dir, 'images', File.basename(source_image))
        file target_image => source_image do |t|
            puts "    CP #{File.basename(source_image)}"
            FileUtils.mkdir_p File.dirname(target_image)
            FileUtils.cp_r source_image, target_image
        end
        dist.images << target_image
    end

    VARIANTS.each do |variant_name, keywords|
        wi_css = File.join(version_dir, "wi.#{variant_name}.css")
        wi_js  = File.join(version_dir, "wi.#{variant_name}.js")

        variant_css    = filter(WIDGETS_CSS, keywords)
        variant_js     = filter(WIDGETS_JS, keywords)
        variant_images = filter(WIDGETS_IMAGES, keywords)

        file wi_css => variant_css do |t|
            puts "  JOIN #{wi_css}"
            body = variant_css.collect do |n|
                open(n) { |f| f.read }
            end.join("\n")
            FileUtils.mkdir_p File.dirname(t.name)
            open(t.name, 'w') { |f| f.write body }
        end
        dist.css << wi_css

        file wi_js => variant_js do |t|
            puts "  JOIN #{wi_js}"
            body = variant_js.collect do |n|
                open(n) { |f| f.read }
            end.join("\n")
            FileUtils.mkdir_p File.dirname(t.name)
            open(t.name, 'w') { |f| f.write body }
        end
        dist.js << wi_js

        demo_dir = File.join(version_dir, "demo.#{variant_name}")
        (DEMO_CSS + DEMO_JS).each do |source_file|
            target_file = File.join(demo_dir, source_file.sub('demo/', ''))
            file target_file => source_file do
                puts "    CP #{File.basename(source_file)}"
                FileUtils.mkdir_p File.dirname(target_file)
                FileUtils.cp_r source_file, target_file
            end
            dist.html << target_file
        end
        HTML.each do |source_file|
            target_file = File.join(demo_dir, source_file.sub('demo/', ''))
            file target_file => source_file do
                puts "FILTER #{File.basename(source_file)}"
                FileUtils.mkdir_p File.dirname(target_file)
                data = File.read(source_file).
                    gsub(%Q/"wi.css"/, %Q,"../#{File.basename(wi_css)}",).
                    gsub(%Q/"wi.js"/, %Q,"../#{File.basename(wi_js)}",)
                File.open(target_file, 'w') { |f| f.write data }
            end
            dist.html << target_file
        end
    end

    return dist
end

dev_dist     = setup_packaging_tasks(dev_version)
release_dist = setup_packaging_tasks(release_version)

CLOBBER.include(dev_dist.version_dir)

namespace :dev do
    desc "Delete the current development version package (#{dev_dist.version})"
    task :clobber do
        FileUtils.rm_rf dev_dist.version_dir
    end

    desc "Build a development version package"
    task :build => dev_dist.all
end

namespace :release do
    desc "Delete the current release version package (#{release_dist.version})"
    task :clobber do
        FileUtils.rm_rf release_dist.version_dir
    end

    task :must_not_exist do
        fail "#{release_dist.version_dir} already exists, can be deleted using rake release:clobber" if File.exists?(release_dist.version_dir)
    end

    desc "Build a release version package"
    task :build => [:must_not_exist] + release_dist.all

    desc "Publish a release"
    task :publish => [:build] do
        fail "Publishing not implemented yet"
    end
end

desc "Build all HTML, CSS and JavaScript files"
task :compile_all => (HTML + WIDGETS_CSS + WIDGETS_COFFEE + DEMO_CSS + DEMO_COFFEE)

desc "Build all HTML, CSS and JavaScript files, and then package a development version"
task :default => [:compile_all, 'dev:build']

namespace :bump do
    desc "Bump patch version number component (x.x.X)"
    task :patch do
        puts "VERINC #{VERSION_FILE}"
        new_version = stored_version.sub(/\.(\d+)$/) { ".#{$1.to_i + 1}" }
        File.open(VERSION_FILE, 'w') { |f| f.write new_version }
    end
end

desc "Release a public version"
task :release => ['release:build', 'bump:patch']

desc "Continuously watch for changes and rebuild files"
task :watch => [:default] do
    require 'rubygems'
    require 'fssm'

    def rebuild
        sh 'rake'
        puts "    OK"
    rescue
        nil
    end

    begin
        FSSM.monitor(nil, [RAKEFILE, '**/*.coffee', '**/*.haml', '**/*.less', 'demo/layouts/*.html']) do
            update { rebuild }
            delete { rebuild }
            create { rebuild }
        end
    rescue FSSM::CallbackError => e
        Process.exit
    end
end

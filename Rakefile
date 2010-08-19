require 'rake/clean'
require 'haml'
require 'liquid'

RAKEFILE = 'Rakefile'

HAML   = FileList['**/*.haml']
LESS   = FileList['**/*.less']
COFFEE = FileList['**/*.coffee']

HTML = HAML.ext('html')
CSS  = LESS.ext('css')
JS   = COFFEE.ext('js')

COMBINED = ['wi.css', 'wi.js']

CLOBBER.include(HTML, CSS, JS, COMBINED)

DEMO_HAML     = FileList['demo/demo-*.haml']
NON_DEMO_HAML = HAML - DEMO_HAML

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
    less_files = FileList["widgets/#{widget_path}/**/*.less"]
    css_files = less_files.ext('css').to_a

    file html_file => [haml_file, template_file, RAKEFILE] do |t|
        puts "  HAML #{haml_file}"
        output = Haml::Engine.new(File.read(haml_file)).render

        template_body = File.read(template_file)
        output = Liquid::Template.parse(template_body).render 'page' => {
            'title' => "Wi #{widget_title}",
            'stylesheets' => css_files.collect { |file| { 'url' => "../#{file}" }},
        }, 'content' => output.strip

        File.open(html_file, 'w') { |f| f.write output }
    end
end

rule '.css' => '.less' do |t|
   puts "  LESS #{t.source}"
   sh 'lessc', t.source, t.name
end

rule '.js' => '.coffee' do |t|
   puts "COFFEE #{t.source}"
   sh 'coffee', '-c', t.source
end

file 'wi.css' => FileList['widgets/*/*.less'].ext('css') do |t|
  body = t.prerequisites.collect do |n|
    widget_name = File.basename(File.dirname(n))
    open(n) { |f| f.read }.gsub /url\(images/, "url(widgets/#{widget_name}/images"
  end.join("\n")
  open(t.name, 'w') { |f| f.write body }
end

file 'wi.js' => FileList['widgets/*/*.coffee'].ext('js') do |t|
  body = t.prerequisites.collect do |n|
    widget_name = File.basename(File.dirname(n))
    open(n) { |f| f.read }
  end.join("\n")
  open(t.name, 'w') { |f| f.write body }
end

desc "Build all HTML, CSS and JavaScript files"
task :default => (HTML + CSS + JS + COMBINED)

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

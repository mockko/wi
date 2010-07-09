require 'rake/clean'

HAML   = FileList['**/*.haml']
LESS   = FileList['**/*.less']
COFFEE = FileList['**/*.coffee']

HTML = HAML.ext('html')
CSS  = LESS.ext('css')
JS   = COFFEE.ext('js')

CLOBBER.include(HTML, CSS, JS)

rule '.html' => '.haml' do |t|
   puts "  HAML #{t.source}"
   sh 'haml', t.source, t.name
end

rule '.css' => '.less' do |t|
   puts "  LESS #{t.source}"
   sh 'lessc', t.source, t.name
end

rule '.js' => '.coffee' do |t|
   puts "COFFEE #{t.source}"
   sh 'coffee', '-c', t.source, t.name
end

desc "Build all HTML, CSS and JavaScript files"
task :default => (HTML + CSS + JS)

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
	  FSSM.monitor(nil, ['**/*.coffee', '**/*.haml', '**/*.less']) do
	    update { rebuild }
	    delete { rebuild }
	    create { rebuild }
	  end
	rescue FSSM::CallbackError => e
	  Process.exit
	end
end

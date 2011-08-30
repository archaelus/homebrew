require 'formula'
require 'rubygems'
require 'graphviz'

module Homebrew extend self
  def depgraph
    formulae = Formula.all.select do |f|
      keg = HOMEBREW_CELLAR/f
      keg.directory? and not keg.subdirs.empty?
    end
    g = GraphViz.digraph("Dependency graph")
    formulae.each do |f|
      g.add_node(f.to_s)
      f.deps.each do |fg|
        g.add_node(fg.to_s)
        g.add_edge(f.to_s, fg.to_s)
      end
    end
    puts "Writing dependency graph to brewgraph.svg"
    g.output( :svg => "brewgraph.svg", :nothugly => true )
  end
end

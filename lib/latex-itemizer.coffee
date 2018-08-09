{CompositeDisposable} = require 'atom'

module.exports =
  subscriptions: null

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', {
      'latex-itemizer:newline-item'    : => @newline_item()
      'latex-itemizer:newline-itemize' : => @newline_itemize()
    }

  deactivate: ->
    @subscriptions.dispose()

  newline_item: ->
    editor = atom.workspace.getActiveTextEditor()
    view = atom.views.getView editor
    editor.transact =>
      atom.commands.dispatch view, 'editor:newline'
      editor.insertText('\\item ')

  newline_itemize: ->
    editor = atom.workspace.getActiveTextEditor()
    cursor = editor.getLastCursor()
    view = atom.views.getView editor
    editor.transact =>
      atom.commands.dispatch view, 'editor:newline'
      editor.insertText('\\begin{itemize}')
      atom.commands.dispatch view, 'editor:newline'
      editor.insertText('\\item ')
      pos = cursor.getBufferPosition()
      atom.commands.dispatch view, 'editor:newline'
      editor.insertText('\\end{itemize}')
      cursor.setBufferPosition(pos)

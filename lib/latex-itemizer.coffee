{CompositeDisposable} = require 'atom'

module.exports =
  subscriptions: null

  config:
    flag_caption:
      type: 'boolean'
      default: true
      title: 'Include caption'
    flag_label:
      type: 'boolean'
      default: true
      title: 'Include label'
    img_width:
      type: 'number'
      default: 5
      minimum: 0
      title: 'Image width [cm]'
    place_spec:
      type: 'string'
      default: 'htbp'
      title: 'Placement specifier parameter'
      description: '\\begin{figure}[\'\'placement specifier\'\']'

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', {
      'latex-itemizer:newline-item'    : => @newline_item()
      'latex-itemizer:newline-itemize' : => @newline_itemize()
      'latex-itemizer:newline-image' : => @newline_image()
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

  newline_image: ->
    editor = atom.workspace.getActiveTextEditor()
    cursor = editor.getLastCursor()
    view = atom.views.getView(editor)
    place_spec = atom.config.get('latex-itemizer.place_spec')
    img_width = atom.config.get('latex-itemizer.img_width')
    flag_caption = atom.config.get('latex-itemizer.flag_caption')
    flag_label = atom.config.get('latex-itemizer.flag_label')
    editor.transact =>
        atom.commands.dispatch view, 'editor:newline'
        editor.insertText("\\begin{figure}[#{place_spec}]")
        atom.commands.dispatch view, 'editor:newline'
        editor.insertText('\\centering')
        atom.commands.dispatch view, 'editor:newline'
        editor.insertText "\\includegraphics[width=#{img_width}cm]{"
        pos = cursor.getBufferPosition()
        editor.insertText('}')
        if flag_caption
          atom.commands.dispatch view, 'editor:newline'
          editor.insertText('\\caption{}')
        if flag_label
          atom.commands.dispatch view, 'editor:newline'
          editor.insertText('\\label{}')
        atom.commands.dispatch view, 'editor:newline'
        editor.insertText('\\end{figure}')
        cursor.setBufferPosition(pos)

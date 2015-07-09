# define ['react'], (React)->
#   {h1} = React.DOM

#   class Street extends React.Component
#     render: ()->
#       street = this.props.street
#       h1 {}, [street.street1, street.street2].join " and "

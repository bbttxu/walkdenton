define ['react', 'underscore', 'components/intersection'], (React, _, IntersectionComponent)->
  {ul} = React.DOM

  Intersection = React.createFactory IntersectionComponent

  class Intersections extends React.Component
    render: ()->
      ul {}, _.map this.props.streets, (street)->
        Intersection { street: street, key: street.iid }


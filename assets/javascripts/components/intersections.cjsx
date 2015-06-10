# streets.cjsx

define ['react', 'underscore', 'components/intersection'], (React, _, Intersection)->
  Intersections = React.createClass
    render: ()->
      <ul>
        {_.map this.props.streets, (street)->
          <Intersection street={street} key={street.iid}/>
        }
      </ul>

#ifndef QCLSIM_MATERIAL
#define QCLSIM_MATERIAL

#include <boost/ptr_container/ptr_map.hpp>
#include <libxml++/libxml++.h>
class MaterialProperty;

namespace xmlpp {
class Element;
}

namespace Glib {
class ustring;
}

/** Wrapper for XML data for a material */
class Material {
public:
    Material(){}
    Material(const Material *mat);
    Material(xmlpp::Element *elem);
    ~Material();

    const Glib::ustring & get_name() const;
    const Glib::ustring & get_description() const;

    MaterialProperty * get_property(const char    *property_name);
    MaterialProperty * get_property(Glib::ustring &property_name);

    xmlpp::Element * get_elem() const;

private:
    void read_properties_from_xml();

    /// Cached set of material properties
    boost::ptr_map<Glib::ustring, MaterialProperty>   properties;

    xmlpp::Element        *elem;           ///< Underlying XML data
    xmlpp::Node::NodeList  property_nodes; ///< Set of material properties
    Glib::ustring          name;           ///< The name of the material
    Glib::ustring          description;    ///< The description of the material
};

#endif // QCLSIM_MATERIAL
// vim: filetype=cpp:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:fileencoding=utf-8:textwidth=99 :
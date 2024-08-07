// Generated code. Do not modify.

package com.yandex.div2

import org.json.JSONObject

sealed class EnumWithDefaultType : Hashable {
    class WithDefaultCase(val value: WithDefault) : EnumWithDefaultType()
    class WithoutDefaultCase(val value: WithoutDefault) : EnumWithDefaultType()

    private var _propertiesHash: Int? = null 
    private var _hash: Int? = null 

    override fun propertiesHash(): Int {
        _propertiesHash?.let {
            return it
        }
        val propertiesHash = this::class.hashCode() + when(this) {
            is WithDefaultCase -> this.value.propertiesHash()
            is WithoutDefaultCase -> this.value.propertiesHash()
        }
       _propertiesHash = propertiesHash
       return propertiesHash
    }

    override fun hash(): Int {
        _hash?.let {
            return it
        }
        val hash = this::class.hashCode() + when(this) {
            is WithDefaultCase -> this.value.hash()
            is WithoutDefaultCase -> this.value.hash()
        }
       _hash = hash
       return hash
    }

    fun value(): Any {
        return when (this) {
            is WithDefaultCase -> value
            is WithoutDefaultCase -> value
        }
    }

}

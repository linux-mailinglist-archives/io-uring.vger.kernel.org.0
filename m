Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E6823C5F3
	for <lists+io-uring@lfdr.de>; Wed,  5 Aug 2020 08:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgHEGeo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Aug 2020 02:34:44 -0400
Received: from mail-shaon0148.outbound.protection.partner.outlook.cn ([42.159.164.148]:57751
        "EHLO CN01-SHA-obe.outbound.protection.partner.outlook.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726459AbgHEGem (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 5 Aug 2020 02:34:42 -0400
X-Greylist: delayed 939 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Aug 2020 02:34:40 EDT
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EFWtE/L33eB4Dk/RW6nB/CfnA2bYRPSMi9bk0e1cEM5qctwRzUh05nyxj+zU4aCAm27aJP2v7IVxLvADTqivVbr8DzkelpAj4vqBDRqVaD6m5lMgECzLSHkNQFM5v+k3OfHQv6YjCypintm9CfBJh9k5nxjqwDkh21EXolkPthWbJv2QQEMsnNneRBB7OrPpc01e1bjotkA6Jv8zS4Rm0CRcV/o3g7j/Ui6JaV0AHxgFNceUdE5tINc4IjSGTwHp7vQOmpWaMnVa3A7GSSN2vdYF53Xz/hmoWB/Txt/Y1R/tgjXtOBshgliyOJXOGDsH/Tnter25dfjr66PDXu0H3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DEtVfXbbpBJHjNP7MUGpDy8U9SXKK31gvY7x+09Sh4=;
 b=cJWIDwg9TtXo2bybmH8cUFYxrpTqtBCHRaLessyrKRhZWEv33HwEADOzRdfydPqsKve/9CLDoepOVWduUTgPG4ESBv0NQuu7YJZzwEtUNiykkWMvPHN4wUyY8HzGH4K7qltD6lZkKawewsQ0zIGv48gCXnUe4d3TvCM+EHcE5hSIsbb9W/0PgIpM7rzxEbCUvUSMLeE3d0HCtOK9HCLlMkgyOk3ZWTok53Obk3ckcoDAm2N3K2PcTasmRAHbVoNrstq1AGg8K1SLmE0uJSaipV9EXZNd00eZqNJzpGfARhlV2ItnEEKXtlQHHzKpGQOtpaRbaS9Mrk7TwN1Ekjzvnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eoitek.com; dmarc=pass action=none header.from=eoitek.com;
 dkim=pass header.d=eoitek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=eoitek.partner.onmschina.cn; s=selector1-eoitek-partner-onmschina-cn;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DEtVfXbbpBJHjNP7MUGpDy8U9SXKK31gvY7x+09Sh4=;
 b=GI7zw0M/6pB8miDKYeuZJUe68igXY/Zbmq/mB1iTU96eIiLPA83LygUDeulu/VGPJA1QAyX8Ogj98BLvlkZQkmU14s1l07b4V4OJcXgz6AqaYFSoMUG9OE38eQs9TiZ5ULNxcxgbX/u3r2hlpoIIigIf2hJp6lXGLf+afP8EJtU=
Received: from SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn (10.43.110.79) by
 SHXPR01MB0462.CHNPR01.prod.partner.outlook.cn (10.43.109.213) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3239.17; Wed, 5 Aug 2020 06:18:52 +0000
Received: from SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn ([10.43.110.79])
 by SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn ([10.43.110.79]) with mapi
 id 15.20.3239.022; Wed, 5 Aug 2020 06:18:52 +0000
From:   =?utf-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>
CC:     io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH liburing v3 0/2] add support for new timeout feature
Thread-Topic: [PATCH liburing v3 0/2] add support for new timeout feature
Thread-Index: AQHWatiHmsscSDFy6UqrTXhZC+C9iqko+auAgAARNwA=
Date:   Wed, 5 Aug 2020 06:18:52 +0000
Message-ID: <40D59A2A-B9A6-4106-AA81-76A43859C65A@eoitek.com>
References: <3CC9BEDE-0509-4EC7-948C-77746E40B531@eoitek.com>
 <7efabc7f-a649-b0aa-ff3b-7cd6c9f450b7@linux.alibaba.com>
In-Reply-To: <7efabc7f-a649-b0aa-ff3b-7cd6c9f450b7@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=eoitek.com;
x-originating-ip: [180.167.157.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cad9307f-81b3-4830-3db2-08d839076cdf
x-ms-traffictypediagnostic: SHXPR01MB0462:
x-microsoft-antispam-prvs: <SHXPR01MB0462CAB0EDBD0F0AAE7B0CE9944B0@SHXPR01MB0462.CHNPR01.prod.partner.outlook.cn>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ikidB29OU0qkTLSWnL10nNdJk+pQG8qNF0u3VrdqZhCuinUj6EC/9gIV8MF2WkKUPzgVfb7n5MCUF6OnNv9TEgCskXtuDM/gIcdb/TbcbqD+4cfUj4RQh0XotXcoOS/YsEY0kR/uzYjb2+oERA/4X9hkq4ySJN7k8sJqshEZiYRwNksAEUSfjLOTzUEJlAtAN/DXmAo2xvZEhQBbQEVMPOCSaldrf/IVw0M+BLrXibtDjfUSsghgnPfpD5txNTVPK7GCGyEquBTZ5VhXwYNMWRb9j1DRyrg+MtK0w6fktZ6InWzQp46/Zv6ha/hleFSXr+dpRfI3oufLHFq+a473Mw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFTY:;SFS:(366004)(376002)(346002)(328002)(329002)(4326008)(66556008)(76116006)(71200400001)(33656002)(85182001)(66476007)(86362001)(95416001)(2616005)(26005)(6916009)(2906002)(63696004)(64756008)(5660300002)(66946007)(36756003)(508600001)(186003)(8936002)(66446008)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: s7U3cfYDEZMFWdSx/o2jbW2aEWXA7E6/l1ePe2W+IjEF2yRaXAXZxE8BC9tpZzayj9nMWdYU8mJdV+mV3+GyhVsotAYLG77w6CFh7hVVW7t3yvkjoxdMuOwFh2h2o3fxlJj1dZKHLj+A2Dnf6KdtP/c8LZaLnaOBbggBnPZSfK7kz/WdIExjA3LWzjLouQSrQTsiShlG262Tt+mYDJVGrYgIXn2LPbUQGpxYMYAzuWKDzsQ/znZw9qQ6/yNjqortwYHjwTSds8P5lyu4BxQSOffOgGni9YRGRcWsaCQzl1PZpC3QwEN5jd77A5D44W+XRJdYcY/XL+gZ+ojzRvvleiOWfNeRowhdHdntqT1m3cyzqXnPeJKpHxFDMHmSsQ5FjEwIhTPwjCI2907oq+5exJR7JTrRYyCEZnMaPYB4/1/AYE7lOORXLwBk3g7Odqe12ItjYsKEutIoxM8SBDhzl3GbtBhl8PRAsPc0Ih5bVUlWdP4vd+g+WpUe8tJNlJ8seQLZpD5r4DKXQYXShH0ZZvE0Cle93pflqFgq/H72TH2vuL7hepj2pljQcdyVnPxwK5xFH+bHIA1mY+ed8RHOJQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE18C963FD96044CA5995E4DC005AFAF@CHNPR01.prod.partner.outlook.cn>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: eoitek.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SHXPR01MB0640.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-Network-Message-Id: cad9307f-81b3-4830-3db2-08d839076cdf
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2020 06:18:52.6029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e3e4d1ca-338b-4a22-bdef-50f88bbc88d8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HIBV4Ny+P5eBbBvcOMzXdL62Yghw8tyjocFq7ama8Hz5bsjh40bPbKVydOblrqeBDjfcjdhUolG9XCZ0ksXyWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SHXPR01MB0462
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

U29ycnkuIEkgd2FzIHRoaW5raW5nIHRoZSBwb2ludGVyIG9mIGlvX3VyaW5nIHdpbGwgYmUgcGFz
c2VkIHdpdGgNCmlvX3VyaW5nX3NldHVwLiBNeSBmYXVsdC4NCg0KPiAyMDIw5bm0OOaciDXml6Ug
5LiL5Y2IMToxN++8jEppdWZlaSBYdWUgPGppdWZlaS54dWVAbGludXguYWxpYmFiYS5jb20+IOWG
memBk++8mg0KPiANCj4gDQo+IA0KPiBPbiAyMDIwLzgvNSDkuIrljYgxMToyOCwgQ2FydGVyIExp
IOadjumAmua0siB3cm90ZToNCj4+PiBkaWZmIC0tZ2l0IGEvc3JjL2luY2x1ZGUvbGlidXJpbmcu
aCBiL3NyYy9pbmNsdWRlL2xpYnVyaW5nLmgNCj4+PiBpbmRleCAwNTA1YTRmLi44MmMyOTgwIDEw
MDY0NA0KPj4+IC0tLSBhL3NyYy9pbmNsdWRlL2xpYnVyaW5nLmgNCj4+PiArKysgYi9zcmMvaW5j
bHVkZS9saWJ1cmluZy5oDQo+Pj4gQEAgLTU2LDYgKzU2LDkgQEAgc3RydWN0IGlvX3VyaW5nIHsN
Cj4+PiAJc3RydWN0IGlvX3VyaW5nX3NxIHNxOw0KPj4+IAlzdHJ1Y3QgaW9fdXJpbmdfY3EgY3E7
DQo+Pj4gCXVuc2lnbmVkIGZsYWdzOw0KPj4+ICsJdW5zaWduZWQgZmxhZ3NfaW50ZXJuYWw7DQo+
Pj4gKwl1bnNpZ25lZCBmZWF0dXJlczsNCj4+PiArCXVuc2lnbmVkIHBhZFs0XTsNCj4+PiAJaW50
IHJpbmdfZmQ7DQo+Pj4gfTsNCj4+IA0KPj4gV29uJ3QgaXQgYnJlYWsgZXhpc3RpbmcgY29kZSBy
dW5zIG9uIG5ld2VyIGtlcm5lbD8NCj4gDQo+IGlvX3VyaW5nIGlzIGEgc3RydWN0dXJlIHRoYXQg
dXNlZCBpbiB1c2Vyc3BhY2UuIEl0IGJyZWFrcyB0aGUgQVBJDQo+IHdpdGggZXhpc3RpbmcgY29t
cGlsZWQgYXBwbGljYXRpb24uIFNvIEkgaGF2ZSBjaGFuZ2VkIHRoZSBzb25hbWUNCj4gdG8gMi4w
LjcuDQo+IA0KPiBBbmQgZm9yIHN5c2NhbGwgaW9fdXJpbmdfZW50ZXIoKSwgSSBoYXZlIGFkZGVk
IGEgbmV3IGZlYXR1cmUgYml0DQo+IElPUklOR19GRUFUX0dFVEVWRU5UU19USU1FT1VUIGFuZCBp
b191cmluZ19lbnRlcigpIGZsYWcNCj4gSU9SSU5HX0VOVEVSX0dFVEVWRU5UU19USU1FT1VULiBI
ZXJlIGFyZSAzIGNhc2VzIGJlbG93Og0KPiANCj4gMSkgb2xkIGxpYnVyaW5nIDwtPiBuZXcga2Vy
bmVsOiBvbGQgbGlidXJpbmcgY2FuIG5vdCBwYXNzIHRoZSBmbGFnDQo+ICAgSU9SSU5HX0VOVEVS
X0dFVEVWRU5UU19USU1FT1VULCBzbyBuZXcga2VybmVsIHdpbGwgcGFyc2UgdGhlIGFyZ3VtZW50
cw0KPiAgIHRoZSBvcmlnaW5hbCB3YXkuDQo+IA0KPiAyKSBuZXcgbGlidXJpbmcgPC0+IG9sZCBr
ZXJuZWw6IGZlYXR1cmUgSU9SSU5HX0ZFQVRfR0VURVZFTlRTX1RJTUVPVVQNCj4gICBub3Qgc3Vw
cG9ydGVkLCBsaWJ1cmluZyB3aWxsIGRvIHRoaW5ncyBsaWtlIGJlZm9yZS4NCj4gDQo+IDMpIG5l
dyBsaWJ1cmluZyA8LT4gbmV3IGtlcm5lbDogZmVhdHVyZSBJT1JJTkdfRkVBVF9HRVRFVkVOVFNf
VElNRU9VVA0KPiAgIHN1cHBvcnRlZCwgbGlidXJpbmcgcGFzcyB0aGUgbmV3IGFyZ3VtZW50cyB3
aXRoIHRoZSBmbGFnDQo+ICAgSU9SSU5HX0VOVEVSX0dFVEVWRU5UU19USU1FT1VUIHdoaWNoIGhl
bHBzIGtlcm5lbCBwYXJzZSB0aGUgYXJndW1lbnRzDQo+ICAgY29ycmVjdGx5Lg0KPiANCj4gVGhh
bmtzLA0KPiBKaXVmZWkuDQo+IA0KPj4gV29uJ3QgaXQgYnJlYWsgY29kZSBjb21waWxlZCB3aXRo
IG5ldyBsaWJ1cmluZyBidXQgcnVucyBvbiBvbGRlciBrZXJuZWw/DQo+PiANCj4gDQo+PiBJTU8g
SW4gdGhpcyBjYXNlLCBhIG5ldyBzeXNjYWxsIGBpb191cmluZ19zZXR1cDJgIGlzIHJlcXVpcmVk
IGF0IGxlYXN0Lg0KPj4gDQo+PiBSZWdhcmRzLA0KPj4gQ2FydGVyDQoNCg==

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E712393E49
	for <lists+io-uring@lfdr.de>; Fri, 28 May 2021 09:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhE1IA5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 May 2021 04:00:57 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:21989 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232936AbhE1IA4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 May 2021 04:00:56 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-219-eLCskAZIMDikJDdguKFpzA-1; Fri, 28 May 2021 08:59:18 +0100
X-MC-Unique: eLCskAZIMDikJDdguKFpzA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Fri, 28 May 2021 08:59:17 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Fri, 28 May 2021 08:59:17 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Justin Forbes' <jforbes@redhat.com>, Jens Axboe <axboe@kernel.dk>
CC:     "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] io_uring: Remove CONFIG_EXPERT
Thread-Topic: [PATCH] io_uring: Remove CONFIG_EXPERT
Thread-Index: AQHXUxGQwtYNg0KjnUesFiYT/RG7N6r4h1mw
Date:   Fri, 28 May 2021 07:59:17 +0000
Message-ID: <3a358a36cc7840aa9b7deef2a367e241@AcuMS.aculab.com>
References: <20210526223445.317749-1-jforbes@fedoraproject.org>
 <aa130828-03c9-b49b-ab31-1fb83a0349fb@kernel.dk>
 <CAFbkSA1G2ajKQg4eA947dv0Pcmyf-JQbkn8-jYnmUeMAEpfHtw@mail.gmail.com>
 <01c2a63f-23f6-2228-264d-6f3e581e647d@kernel.dk>
 <CAFbkSA2zt5QLBH0S8pcBROCaV3zSw_M-RvaQ-2yccCKgV-_2BQ@mail.gmail.com>
In-Reply-To: <CAFbkSA2zt5QLBH0S8pcBROCaV3zSw_M-RvaQ-2yccCKgV-_2BQ@mail.gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

RnJvbTogSnVzdGluIEZvcmJlcw0KPiBTZW50OiAyNyBNYXkgMjAyMSAxNzowMQ0KPiANCj4gT24g
VGh1LCBNYXkgMjcsIDIwMjEgYXQgOToxOSBBTSBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+
IHdyb3RlOg0KPiA+DQo+ID4gT24gNS8yNy8yMSA4OjEyIEFNLCBKdXN0aW4gRm9yYmVzIHdyb3Rl
Og0KPiA+ID4gT24gVGh1LCBNYXkgMjcsIDIwMjEgYXQgODo0MyBBTSBKZW5zIEF4Ym9lIDxheGJv
ZUBrZXJuZWwuZGs+IHdyb3RlOg0KPiA+ID4+DQo+ID4gPj4gT24gNS8yNi8yMSA0OjM0IFBNLCBK
dXN0aW4gTS4gRm9yYmVzIHdyb3RlOg0KPiA+ID4+PiBXaGlsZSBJT19VUklORyBoYXMgYmVlbiBp
biBmYWlybHkgaGVhdnkgZGV2ZWxvcG1lbnQsIGl0IGlzIGhpZGRlbiBiZWhpbmQNCj4gPiA+Pj4g
Q09ORklHX0VYUEVSVCB3aXRoIGEgZGVmYXVsdCBvZiBvbi4gIEl0IGhhcyBiZWVuIGxvbmcgZW5v
dWdoIG5vdyB0aGF0IEkNCj4gPiA+Pj4gdGhpbmsgd2Ugc2hvdWxkIHJlbW92ZSBFWFBFUlQgYW5k
IGFsbG93IHVzZXJzIGFuZCBkaXN0cm9zIHRvIGRlY2lkZSBob3cNCj4gPiA+Pj4gdGhleSB3YW50
IHRoaXMgY29uZmlnIG9wdGlvbiBzZXQgd2l0aG91dCBqdW1waW5nIHRocm91Z2ggaG9vcHMuDQo+
ID4gPj4NCj4gPiA+PiBUaGUgd2hvbGUgcG9pbnQgb2YgRVhQRVJUIGlzIHRvIGVuc3VyZSB0aGF0
IGl0IGRvZXNuJ3QgZ2V0IHR1cm5lZCBvZmYNCj4gPiA+PiAiYnkgYWNjaWRlbnQiLiBJdCdzIGEg
Y29yZSBmZWF0dXJlLCBhbmQgc29tZXRoaW5nIHRoYXQgbW9yZSBhbmQgbW9yZQ0KPiA+ID4+IGFw
cHMgb3IgbGlicmFyaWVzIGFyZSByZWx5aW5nIG9uLiBJdCdzIG5vdCBzb21ldGhpbmcgSSBpbnRl
bmRlZCB0byBldmVyDQo+ID4gPj4gZ28gYXdheSwganVzdCBsaWtlIGl0IHdvdWxkIG5ldmVyIGdv
IGF3YXkgZm9yIGVnIGZ1dGV4IG9yIGVwb2xsIHN1cHBvcnQuDQo+ID4gPj4NCj4gPiA+DQo+ID4g
PiBJIGFtIG5vdCBhcmd1aW5nIHdpdGggdGhhdCwgSSBkb24ndCBleHBlY3QgaXQgd2lsbCBnbyBh
d2F5LiBJDQo+ID4gPiBjZXJ0YWlubHkgZG8gbm90IGhhdmUgYW4gaXNzdWUgd2l0aCBpdCBkZWZh
dWx0aW5nIHRvIG9uLCBhbmQgSSBkaWRuJ3QNCj4gPiA+IGV2ZW4gc3VibWl0IHRoaXMgd2l0aCBp
bnRlbnRpb24gdG8gdHVybiBpdCBvZmYgZm9yIGRlZmF1bHQgRmVkb3JhLiBJDQo+ID4gPiBkbyB0
aGluayB0aGF0IHRoZXJlIGFyZSBjYXNlcyB3aGVyZSBwZW9wbGUgbWlnaHQgbm90IHdpc2ggaXQg
dHVybmVkIG9uDQo+ID4gPiBhdCB0aGlzIHBvaW50IGluIHRpbWUuIEhpZGluZyBpdCBiZWhpbmQg
RVhQRVJUIG1ha2VzIGl0IG11Y2ggbW9yZQ0KPiA+ID4gZGlmZmljdWx0IHRoYW4gaXQgbmVlZHMg
dG8gYmUuICBUaGVyZSBhcmUgcGxlbnR5IG9mIGNvbmZpZyBvcHRpb25zDQo+ID4gPiB0aGF0IGFy
ZSBsYXJnZWx5IGV4cGVjdGVkIGRlZmF1bHQgYW5kIG5vdCBoaWRkZW4gYmVoaW5kIEVYUEVSVC4N
Cj4gPg0KPiA+IFJpZ2h0IHRoZXJlIGFyZSwgYnV0IG5vdCByZWFsbHkgY29yZSBrZXJuZWwgZmVh
dHVyZXMgbGlrZSB0aGUgb25lcw0KPiA+IEkgbWVudGlvbmVkLiBIZW5jZSBteSBhcmd1bWVudCBm
b3Igd2h5IGl0J3MgY29ycmVjdCBhcy1pcyBhbmQgSQ0KPiA+IGRvbid0IHRoaW5rIGl0IHNob3Vs
ZCBiZSBjaGFuZ2VkLg0KPiA+DQo+IA0KPiBIb25lc3RseSwgdGhpcyBpcyBmYWlyLCBhbmQgSSB1
bmRlcnN0YW5kIHlvdXIgY29uY2VybnMgYmVoaW5kIGl0LiBJDQo+IHRoaW5rIG15IHJlYWwgaXNz
dWUgaXMgdGhhdCB0aGVyZSBpcyBubyBzaW1wbGUgd2F5IHRvIG92ZXJyaWRlIG9uZQ0KPiBFWFBF
UlQgc2V0dGluZyB3aXRob3V0IGhhdmluZyB0byBzZXQgdGhlbSBhbGwuICBJdCB3b3VsZCBiZSBu
aWNlIGlmDQo+IGV4cGVydCB3ZXJlIGEgInZpc2libGUgaWYiIG1lbnUsIHNldHRpbmcgZGVmYXVs
dHMgaWYgbm90IHNlbGVjdGVkLA0KPiB3aGljaCBhbGxvd3MgZGlyZWN0IG92ZXJyaWRlIHdpdGgg
YSBjb25maWcgZmlsZS4gUGVyaGFwcyBJIHdpbGwgdHJ5IHRvDQo+IGZpeCB0aGlzIGluIGtidWls
ZC4NCg0KU29tZW9uZSBtaWdodCB3YW50IHRvIGRpc2FibGUgdGhpbmdzIGxpa2UgSU9fVVJJTkcg
Zm9yIGFuIGVtYmVkZGVkDQpzeXN0ZW0ganVzdCB0byByZW1vdmUgY29kZSB0aGF0IG1pZ2h0IGhh
dmUgcG9zc2libGUgYXR0YWNrIHZlY3RvcnMNCmFuZCBpc24ndCByZXF1aXJlZCBieSB0aGUgc3Vi
c2V0IG9mIGtlcm5lbCBmZWF0dXJlcyB0aGV5IG5lZWQuDQoNCklmIHR1cm5pbmcgb24gJ0VYUEVS
VCcgbWFrZXMgZXh0cmEgY29uZmlnIG9wdGlvbnMgdmlzaWJsZSB0aGlzIGlzIG9rLg0KQnV0IGlm
IHRoYXQgY2hhbmdlcyB0aGUgZGVmYXVsdHMgaXQgZ2V0cyB0byBiZSBhIHJlYWwgUElUQS4NCg0K
CURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBN
b3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAx
Mzk3Mzg2IChXYWxlcykNCg==


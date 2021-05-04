Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE5E37271D
	for <lists+io-uring@lfdr.de>; Tue,  4 May 2021 10:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhEDIXF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 May 2021 04:23:05 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:55910 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230074AbhEDIXE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 May 2021 04:23:04 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-215-aOd_GTZbN5S5WGRdRq-7kA-1; Tue, 04 May 2021 09:22:06 +0100
X-MC-Unique: aOd_GTZbN5S5WGRdRq-7kA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Tue, 4 May 2021 09:22:06 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Tue, 4 May 2021 09:22:06 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Linus Torvalds' <torvalds@linux-foundation.org>,
        Stefan Metzmacher <metze@samba.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Subject: RE: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
Thread-Topic: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
Thread-Index: AQHXQHbTElK5zn4+eUeudkt5GoEV9qrS+gvg
Date:   Tue, 4 May 2021 08:22:05 +0000
Message-ID: <2119eef25fec413099a13763f8d34bc1@AcuMS.aculab.com>
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de>
 <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
 <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com>
 <CALCETrV9bCenqzzaW6Ra18tCvNP-my09decTjmLDVZZAQxR6VA@mail.gmail.com>
 <CAHk-=wgo6XEz3VQ9ntqzWLR3-hm1YXrXUz4_heDs4wcLe9NYvA@mail.gmail.com>
 <d26e3a82-8a2c-7354-d36b-cac945c208c7@kernel.dk>
 <CALCETrWmhquicE2C=G2Hmwfj4VNypXVxY-K3CWOkyMe9Edv88A@mail.gmail.com>
 <CAHk-=wgqK0qUskrzeWXmChErEm32UiOaUmynWdyrjAwNzkDKaw@mail.gmail.com>
 <8735v3jujv.ffs@nanos.tec.linutronix.de>
 <CAHk-=wi4Dyg_Z70J_hJbtFLPQDG+Zx3dP2jB5QrOdZC6W6j4Gw@mail.gmail.com>
 <12710fda-1732-ee55-9ac1-0df9882aa71b@samba.org>
 <CAHk-=wiR7c-UHh_3Rj-EU8=AbURKchnMFJWW7=5EH=qEUDT8wg@mail.gmail.com>
In-Reply-To: <CAHk-=wiR7c-UHh_3Rj-EU8=AbURKchnMFJWW7=5EH=qEUDT8wg@mail.gmail.com>
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

RnJvbTogTGludXMgVG9ydmFsZHMNCj4gU2VudDogMDQgTWF5IDIwMjEgMDA6NDgNCj4gDQo+IE9u
IE1vbiwgTWF5IDMsIDIwMjEgYXQgNDoyNyBQTSBTdGVmYW4gTWV0em1hY2hlciA8bWV0emVAc2Ft
YmEub3JnPiB3cm90ZToNCj4gPg0KPiA+IElmIEkgcmVtZW1iZXIgY29ycmVjdGx5IGdkYiBzaG93
ZWQgYm9ndXMgYWRkcmVzc2VzIGZvciB0aGUgYmFja3RyYWNlcyBvZiB0aGUgaW9fdGhyZWFkcywN
Cj4gPiBhcyBzb21lIHJlZ3Mgd2hlcmUgbm90IGNsZWFyZWQuDQo+IA0KPiBZZWFoLCBzbyB0aGF0
IHBhdGNoIHdpbGwgbWFrZSB0aGUgSU8gdGhyZWFkIGhhdmUgdGhlIHVzZXIgc3RhY2sNCj4gcG9p
bnRlciBwb2ludCB0byB0aGUgb3JpZ2luYWwgdXNlciBzdGFjaywgYnV0IHRoYXQgc3RhY2sgd2ls
bA0KPiBvYnZpb3VzbHkgYmUgdXNlZCBieSB0aGUgb3JpZ2luYWwgdGhyZWFkIHdoaWNoIG1lYW5z
IHRoYXQgaXQgd2lsbA0KPiBjb250YWluIHJhbmRvbSBzdHVmZiBvbiBpdC4NCj4gDQo+IERvaW5n
IGENCj4gDQo+ICAgICAgICAgY2hpbGRyZWdzLT5zcCA9IDA7DQo+IA0KPiBpcyBwcm9iYWJseSBh
IGdvb2QgaWRlYSBmb3IgdGhhdCBQRl9JT19XT1JLRVIgY2FzZSwgc2luY2UgaXQgcmVhbGx5DQo+
IGRvZXNuJ3QgaGF2ZSAtIG9yIG5lZWQgLSBhIHVzZXIgc3RhY2suDQo+IA0KPiBPZiBjb3Vyc2Us
IGl0IGRvZXNuJ3QgcmVhbGx5IGhhdmUgLSBvciBuZWVkIC0gYW55IG9mIHRoZSBvdGhlciB1c2Vy
DQo+IHJlZ2lzdGVycyBlaXRoZXIsIGJ1dCBvbmNlIHlvdSBmaWxsIGluIHRoZSBzZWdtZW50IHN0
dWZmIHRvIG1ha2UgZ2RiDQo+IGhhcHB5LCB5b3UgbWlnaHQgYXMgd2VsbCBmaWxsIGl0IGFsbCBp
biB1c2luZyB0aGUgc2FtZSBjb2RlIHRoYXQgdGhlDQo+IHJlZ3VsYXIgY2FzZSBkb2VzLg0KDQpQ
cmVzdW1hYmx5IGdkYiBjYW4gb25seSByZWFkL3dyaXRlIHRoZSAndXNlcicgcmVnaXN0ZXJzIChu
b3JtYWxseQ0Kc2F2ZWQgb24ga2VybmVsIGVudHJ5KS4NClNpbmNlIHRoZXNlIHdpbGwgbmV2ZXIg
YmUgbG9hZGVkIGl0IHJlYWxseSBkb2Vzbid0IG1hdHRlciAodG8gdGhlDQprZXJuZWwpIHdoYXQg
aXMgcmV0dXJuZWQgdG8gZ2RiIG9yIHdoYXQgZ2RiIHdyaXRlcyBpbnRvIHRoZW0uDQpUaGUgc2Ft
ZSBvdWdodCB0byBiZSB0cnVlIG9mIHRoZSBGUCBzdGF0ZS4NCg0KSWYgZ2RiIHdyaXRlcyB0byBh
biBGUCAoZXRjKSByZWdpc3RlciB0aGUgcHJvY2VzcyBkb2Vzbid0IGN1cnJlbnRseQ0KaGF2ZSAo
ZWcgYW4gQVZYNTEyIHJlZ2lzdGVyKSB0aGVuIHRoYXQgaXMgbm90IHJlYWxseSBkaWZmZXJlbnQg
ZnJvbQ0KZG9pbmcgaXQgdG8gYSBub3JtYWwgcHJvY2Vzcy4NCg0KCURhdmlkDQoNCi0NClJlZ2lz
dGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24g
S2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==


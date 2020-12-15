Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE1C2DAE60
	for <lists+io-uring@lfdr.de>; Tue, 15 Dec 2020 14:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgLON4Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Dec 2020 08:56:24 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:49266 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728772AbgLON4D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Dec 2020 08:56:03 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-256-kyP4j1eZN0iEOkzo-w1qBQ-1; Tue, 15 Dec 2020 13:54:22 +0000
X-MC-Unique: kyP4j1eZN0iEOkzo-w1qBQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 15 Dec 2020 13:54:17 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 15 Dec 2020 13:54:17 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Pavel Begunkov' <asml.silence@gmail.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
CC:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [PATCH v1 2/6] iov_iter: optimise bvec iov_iter_advance()
Thread-Topic: [PATCH v1 2/6] iov_iter: optimise bvec iov_iter_advance()
Thread-Index: AQHW0njgRO60UNrAz0qHNwIRx20dYqn35EKAgAAgPwCAACb+4A==
Date:   Tue, 15 Dec 2020 13:54:16 +0000
Message-ID: <c5f54cb816564f2b96f5d7a0f85fdc4a@AcuMS.aculab.com>
References: <cover.1607976425.git.asml.silence@gmail.com>
 <5c9c22dbeecad883ca29b31896c262a8d2a77132.1607976425.git.asml.silence@gmail.com>
 <262132648a8f4e7a9d1c79003ea74b3f@AcuMS.aculab.com>
 <d151f81e-ec56-59c0-d2a0-ffd4a269fec1@gmail.com>
In-Reply-To: <d151f81e-ec56-59c0-d2a0-ffd4a269fec1@gmail.com>
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

RnJvbTogUGF2ZWwgQmVndW5rb3YNCj4gU2VudDogMTUgRGVjZW1iZXIgMjAyMCAxMToyNA0KPiAN
Cj4gT24gMTUvMTIvMjAyMCAwOTozNywgRGF2aWQgTGFpZ2h0IHdyb3RlOg0KPiA+IEZyb206IFBh
dmVsIEJlZ3Vua292DQo+ID4+IFNlbnQ6IDE1IERlY2VtYmVyIDIwMjAgMDA6MjANCj4gPj4NCj4g
Pj4gaW92X2l0ZXJfYWR2YW5jZSgpIGlzIGhlYXZpbHkgdXNlZCwgYnV0IGltcGxlbWVudGVkIHRo
cm91Z2ggZ2VuZXJpYw0KPiA+PiBpdGVyYXRpb24uIEFzIGJ2ZWNzIGhhdmUgYSBzcGVjaWZpY2Fs
bHkgY3JhZnRlZCBhZHZhbmNlKCkgZnVuY3Rpb24sIGkuZS4NCj4gPj4gYnZlY19pdGVyX2FkdmFu
Y2UoKSwgd2hpY2ggaXMgZmFzdGVyIGFuZCBzbGltbWVyLCB1c2UgaXQgaW5zdGVhZC4NCj4gPj4N
Cj4gPj4gIGxpYi9pb3ZfaXRlci5jIHwgMTkgKysrKysrKysrKysrKysrKysrKw0KPiBbLi4uXQ0K
PiA+PiAgdm9pZCBpb3ZfaXRlcl9hZHZhbmNlKHN0cnVjdCBpb3ZfaXRlciAqaSwgc2l6ZV90IHNp
emUpDQo+ID4+ICB7DQo+ID4+ICAJaWYgKHVubGlrZWx5KGlvdl9pdGVyX2lzX3BpcGUoaSkpKSB7
DQo+ID4+IEBAIC0xMDc3LDYgKzEwOTIsMTAgQEAgdm9pZCBpb3ZfaXRlcl9hZHZhbmNlKHN0cnVj
dCBpb3ZfaXRlciAqaSwgc2l6ZV90IHNpemUpDQo+ID4+ICAJCWktPmNvdW50IC09IHNpemU7DQo+
ID4+ICAJCXJldHVybjsNCj4gPj4gIAl9DQo+ID4+ICsJaWYgKGlvdl9pdGVyX2lzX2J2ZWMoaSkp
IHsNCj4gPj4gKwkJaW92X2l0ZXJfYnZlY19hZHZhbmNlKGksIHNpemUpOw0KPiA+PiArCQlyZXR1
cm47DQo+ID4+ICsJfQ0KPiA+PiAgCWl0ZXJhdGVfYW5kX2FkdmFuY2UoaSwgc2l6ZSwgdiwgMCwg
MCwgMCkNCj4gPj4gIH0NCj4gPg0KPiA+IFRoaXMgc2VlbXMgdG8gYWRkIHlldCBhbm90aGVyIGNv
bXBhcmlzb24gYmVmb3JlIHdoYXQgaXMgcHJvYmFibHkNCj4gPiB0aGUgY29tbW9uIGNhc2Ugb24g
YW4gSU9WRUMgKGllIG5vcm1hbCB1c2Vyc3BhY2UgYnVmZmVyKS4NCj4gDQo+IElmIEFsIGZpbmFs
bHkgdGFrZXMgdGhlIHBhdGNoIGZvciBpb3ZfaXRlcl9pc18qKCkgaGVscGVycyBpdCB3b3VsZA0K
PiBiZSBjb21wbGV0ZWx5IG9wdGltaXNlZCBvdXQuDQoNCkkga25ldyBJIGRpZG4ndCBoYXZlIHRo
YXQgcGF0aCAtIHRoZSBzb3VyY2VzIEkgbG9va2VkIGF0IGFyZW4ndCB0aGF0IG5ldy4NCkRpZG4n
dCBrbm93IGl0cyBzdGF0ZS4NCg0KSW4gYW55IGNhc2UgdGhhdCBqdXN0IHN0b3BzIHRoZSBzYW1l
IHRlc3QgYmVpbmcgZG9uZSB0d2ljZS4NCkluIHN0aWxsIGNoYW5nZXMgdGhlIG9yZGVyIG9mIHRo
ZSB0ZXN0cy4NCg0KVGhlIHRocmVlICd1bmxpa2VseScgY2FzZXMgc2hvdWxkIHJlYWxseSBiZSBp
bnNpZGUgYSBzaW5nbGUNCid1bmxpa2VseScgdGVzdCBmb3IgYWxsIHRocmVlIGJpdHMuDQpUaGVu
IHRoZXJlIGlzIG9ubHkgb25lIG1pcy1wcmVkaWN0YWJsZSBqdW1wIHByaW9yIHRvIHRoZSB1c3Vh
bCBwYXRoLg0KDQpCeSBhZGRpbmcgdGhlIHRlc3QgYmVmb3JlIGl0ZXJhdGVfYW5kX2FkdmFuY2Uo
KSB5b3UgYXJlIChlZmZlY3RpdmVseSkNCm9wdGltaXNpbmcgZm9yIHRoZSBidmVjIChhbmQgZGlz
Y2FyZCkgY2FzZXMuDQpBZGRpbmcgJ3VubGlrZWx5KCknIHdvbid0IG1ha2UgYW55IGRpZmZlcmVu
Y2Ugb24gc29tZSBhcmNoaXRlY3R1cmVzLg0KSUlSQyByZWNlbnQgaW50ZWwgeDg2IGRvbid0IGhh
dmUgYSAnc3RhdGljIHByZWRpY3Rpb24nIGZvciB1bmtub3duDQpicmFuY2hlcyAtIHRoZXkganVz
dCB1c2Ugd2hhdGV2ZXIgaW4gaXMgdGhlIGJyYW5jaCBwcmVkaWN0b3IgdGFibGVzLg0KDQoJRGF2
aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50
IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTcz
ODYgKFdhbGVzKQ0K


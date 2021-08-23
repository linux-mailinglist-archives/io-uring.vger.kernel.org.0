Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074AC3F4AA6
	for <lists+io-uring@lfdr.de>; Mon, 23 Aug 2021 14:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237017AbhHWM3Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Aug 2021 08:29:16 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:57323 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233755AbhHWM3P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Aug 2021 08:29:15 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-59-E63N1zkDM0uJNVkDIPANeg-1; Mon, 23 Aug 2021 13:28:31 +0100
X-MC-Unique: E63N1zkDM0uJNVkDIPANeg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Mon, 23 Aug 2021 13:28:30 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Mon, 23 Aug 2021 13:28:30 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jens Axboe' <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        "Pavel Begunkov" <asml.silence@gmail.com>
CC:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Palash Oswal <oswalpalash@gmail.com>,
        "Sudip Mukherjee" <sudipm.mukherjee@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com" 
        <syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com>
Subject: RE: [PATCH v2 0/2] iter revert problems
Thread-Topic: [PATCH v2 0/2] iter revert problems
Thread-Index: AQHXluI3nOSi+NKXRk6vP8lbPLAAUauBBWNA
Date:   Mon, 23 Aug 2021 12:28:30 +0000
Message-ID: <f1ccbea939f54b779004d1da51a70160@AcuMS.aculab.com>
References: <cover.1628780390.git.asml.silence@gmail.com>
 <3eaf5365-586d-700b-0277-e0889bfeb05d@gmail.com>
 <YSF9UFyLGZQeKbLt@zeniv-ca.linux.org.uk>
 <120e5aac-e056-1158-505b-fda41f1c99a5@kernel.dk>
In-Reply-To: <120e5aac-e056-1158-505b-fda41f1c99a5@kernel.dk>
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

RnJvbTogSmVucyBBeGJvZQ0KPiBTZW50OiAyMiBBdWd1c3QgMjAyMSAwMDoxNA0KPiANCj4gT24g
OC8yMS8yMSA0OjI1IFBNLCBBbCBWaXJvIHdyb3RlOg0KPiA+IE9uIFNhdCwgQXVnIDIxLCAyMDIx
IGF0IDAzOjI0OjI4UE0gKzAxMDAsIFBhdmVsIEJlZ3Vua292IHdyb3RlOg0KPiA+PiBPbiA4LzEy
LzIxIDk6NDAgUE0sIFBhdmVsIEJlZ3Vua292IHdyb3RlOg0KPiA+Pj4gRm9yIHRoZSBidWcgZGVz
Y3JpcHRpb24gc2VlIDIvMi4gQXMgbWVudGlvbmVkIHRoZXJlIHRoZSBjdXJyZW50IHByb2JsZW1z
DQo+ID4+PiBpcyBiZWNhdXNlIG9mIGdlbmVyaWNfd3JpdGVfY2hlY2tzKCksIGJ1dCB0aGVyZSB3
YXMgYWxzbyBhIHNpbWlsYXIgY2FzZQ0KPiA+Pj4gZml4ZWQgaW4gNS4xMiwgd2hpY2ggc2hvdWxk
IGhhdmUgYmVlbiB0cmlnZ2VyYWJsZSBieSBub3JtYWwNCj4gPj4+IHdyaXRlKDIpL3JlYWQoMikg
YW5kIG90aGVycy4NCj4gPj4+DQo+ID4+PiBJdCBtYXkgYmUgYmV0dGVyIHRvIGVuZm9yY2UgcmVl
eHBhbmRzIGFzIGEgbG9uZyB0ZXJtIHNvbHV0aW9uLCBidXQgZm9yDQo+ID4+PiBub3cgdGhpcyBw
YXRjaHNldCBpcyBxdWlja2llciBhbmQgZWFzaWVyIHRvIGJhY2twb3J0Lg0KPiA+Pg0KPiA+PiBX
ZSBuZWVkIHRvIGRvIHNvbWV0aGluZyB3aXRoIHRoaXMsIGhvcGVmdWxseSBzb29uLg0KPiA+DQo+
ID4gSSBzdGlsbCBkb24ndCBsaWtlIHRoYXQgYXBwcm9hY2ggOy0vICBJZiBhbnl0aGluZywgSSB3
b3VsZCByYXRoZXIgZG8NCj4gPiBzb21ldGhpbmcgbGlrZSB0aGlzLCBhbmQgdG8gaGVsbCB3aXRo
IG9uZSBleHRyYSB3b3JkIG9uIHN0YWNrIGluDQo+ID4gc2V2ZXJhbCBmdW5jdGlvbnM7IGF0IGxl
YXN0IHRoYXQgd2F5IHRoZSBzZW1hbnRpY3MgaXMgZWFzeSB0byBkZXNjcmliZS4NCj4gDQo+IFBh
dmVsIHN1Z2dlc3RlZCB0aGlzIHZlcnkgYXBwcm9hY2ggaW5pdGlhbGx5IGFzIHdlbGwgd2hlbiB3
ZSBkaXNjdXNzZWQNCj4gaXQsIGFuZCBpZiB5b3UncmUgZmluZSB3aXRoIHRoZSBleHRyYSBzaXpl
X3QsIGl0IGlzIGJ5IGZhciB0aGUgYmVzdCB3YXkNCj4gdG8gZ2V0IHRoaXMgZG9uZSBhbmQgbm90
IGhhdmUgYSB3b25reS9mcmFnaWxlIEFQSS4NCg0KQWxsICh3ZWxsIG1heWJlIGFsbW9zdCBhbGwp
IHRoZSB1c2VycyBvZiBpb3ZfaXRlciBoYXZlIHRoZQ0Kc2hvcnQgaW92W10gY2FjaGUgYW5kIHRo
ZSBwb2ludGVyIHRvIHRoZSBiaWcgaW92W10gdG8ga2ZyZWUoKQ0KYWxsb2NhdGVkIHRvZ2V0aGVy
IHdpdGggdGhlIGlvdl9pdGVyIHN0cnVjdHVyZSBpdHNlbGYuDQpUaGVzZSBhcmUgYWxtb3N0IGFs
d2F5cyBvbiBzdGFjay4NCg0KUHV0dGluZyB0aGUgd2hvbGUgbG90IHRvZ2V0aGVyIGluIGEgc2lu
Z2xlIHN0cnVjdHVyZSB3b3VsZA0KbWFrZSB0aGUgY2FsbCBzZXF1ZW5jZXMgYSBsb3QgbGVzcyBj
b21wbGV4IGFuZCB3b3VsZG4ndCB1c2UNCmFueSBtb3JlIHN0YWNrL2RhdGEgaXMgYWxtb3N0IGFs
bCB0aGUgY2FzZXMuDQoNCkl0IHdvdWxkIGFsc28gbWVhbiB0aGF0IHRoZSAnaXRlcicgY29kZSBj
b3VsZCBhbHdheXMgaGF2ZSBhIHBvaW50ZXINCnRvIHRoZSBiYXNlIG9mIHRoZSBvcmlnaW5hbCBp
b3ZbXSBsaXN0Lg0KVGhlIGxhY2sgb2Ygd2hpY2ggaXMgcHJvYmFibHkgbWFrZXMgdGhlICdyZXZl
cnQnIGNvZGUgaGFyZD8NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lk
ZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0K
UmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==


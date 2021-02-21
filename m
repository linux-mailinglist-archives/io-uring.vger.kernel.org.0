Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E59320D35
	for <lists+io-uring@lfdr.de>; Sun, 21 Feb 2021 20:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbhBUTkJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Feb 2021 14:40:09 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:38809 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230174AbhBUTkI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Feb 2021 14:40:08 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-212-qxf1crOUMJuZHCnF-243zg-1; Sun, 21 Feb 2021 19:38:26 +0000
X-MC-Unique: qxf1crOUMJuZHCnF-243zg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sun, 21 Feb 2021 19:38:26 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sun, 21 Feb 2021 19:38:26 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jens Axboe' <axboe@kernel.dk>,
        'Lennert Buytenhek' <buytenh@wantstofly.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     Matthew Wilcox <willy@infradead.org>
Subject: RE: [PATCH v3 0/2] io_uring: add support for IORING_OP_GETDENTS
Thread-Topic: [PATCH v3 0/2] io_uring: add support for IORING_OP_GETDENTS
Thread-Index: AQHXBfFRAjVxpRid2k+E4G2FbTp65qphUAowgAAQsQCAAaBWMA==
Date:   Sun, 21 Feb 2021 19:38:26 +0000
Message-ID: <b2227a95338f4d949442970f990205fa@AcuMS.aculab.com>
References: <20210218122640.GA334506@wantstofly.org>
 <247d154f2ba549b88a77daf29ec1791f@AcuMS.aculab.com>
 <28a71bb1-0aac-c166-ade7-93665811d441@kernel.dk>
In-Reply-To: <28a71bb1-0aac-c166-ade7-93665811d441@kernel.dk>
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

RnJvbTogSmVucyBBeGJvZQ0KPiBTZW50OiAyMCBGZWJydWFyeSAyMDIxIDE4OjI5DQo+IA0KPiBP
biAyLzIwLzIxIDEwOjQ0IEFNLCBEYXZpZCBMYWlnaHQgd3JvdGU6DQo+ID4gRnJvbTogTGVubmVy
dCBCdXl0ZW5oZWsNCj4gPj4gU2VudDogMTggRmVicnVhcnkgMjAyMSAxMjoyNw0KPiA+Pg0KPiA+
PiBUaGVzZSBwYXRjaGVzIGFkZCBzdXBwb3J0IGZvciBJT1JJTkdfT1BfR0VUREVOVFMsIHdoaWNo
IGlzIGEgbmV3IGlvX3VyaW5nDQo+ID4+IG9wY29kZSB0aGF0IG1vcmUgb3IgbGVzcyBkb2VzIGFu
IGxzZWVrKHNxZS0+ZmQsIHNxZS0+b2ZmLCBTRUVLX1NFVCkNCj4gPj4gZm9sbG93ZWQgYnkgYSBn
ZXRkZW50czY0KHNxZS0+ZmQsICh2b2lkICopc3FlLT5hZGRyLCBzcWUtPmxlbikuDQo+ID4+DQo+
ID4+IEEgZHVtYiB0ZXN0IHByb2dyYW0gZm9yIElPUklOR19PUF9HRVRERU5UUyBpcyBhdmFpbGFi
bGUgaGVyZToNCj4gPj4NCj4gPj4gCWh0dHBzOi8va3JhdXRib3gud2FudHN0b2ZseS5vcmcvfmJ1
eXRlbmgvdXJpbmdmaW5kLXYyLmMNCj4gPj4NCj4gPj4gVGhpcyB0ZXN0IHByb2dyYW0gZG9lcyBz
b21ldGhpbmcgYWxvbmcgdGhlIGxpbmVzIG9mIHdoYXQgZmluZCgxKSBkb2VzOg0KPiA+PiBpdCBz
Y2FucyByZWN1cnNpdmVseSB0aHJvdWdoIGEgZGlyZWN0b3J5IHRyZWUgYW5kIHByaW50cyB0aGUg
bmFtZXMgb2YNCj4gPj4gYWxsIGRpcmVjdG9yaWVzIGFuZCBmaWxlcyBpdCBlbmNvdW50ZXJzIGFs
b25nIHRoZSB3YXkgLS0gYnV0IHRoZW4gdXNpbmcNCj4gPj4gaW9fdXJpbmcuICAoVGhlIGlvX3Vy
aW5nIHZlcnNpb24gcHJpbnRzIHRoZSBuYW1lcyBvZiBlbmNvdW50ZXJlZCBmaWxlcyBhbmQNCj4g
Pj4gZGlyZWN0b3JpZXMgaW4gYW4gb3JkZXIgdGhhdCdzIGRldGVybWluZWQgYnkgU1FFIGNvbXBs
ZXRpb24gb3JkZXIsIHdoaWNoDQo+ID4+IGlzIHNvbWV3aGF0IG5vbmRldGVybWluaXN0aWMgYW5k
IGxpa2VseSB0byBkaWZmZXIgYmV0d2VlbiBydW5zLikNCj4gPj4NCj4gPj4gT24gYSBkaXJlY3Rv
cnkgdHJlZSB3aXRoIDE0LW9kZCBtaWxsaW9uIGZpbGVzIGluIGl0IHRoYXQncyBvbiBhDQo+ID4+
IHNpeC1kcml2ZSAoc3Bpbm5pbmcgZGlzaykgYnRyZnMgcmFpZCwgZmluZCgxKSB0YWtlczoNCj4g
Pj4NCj4gPj4gCSMgZWNobyAzID4gL3Byb2Mvc3lzL3ZtL2Ryb3BfY2FjaGVzDQo+ID4+IAkjIHRp
bWUgZmluZCAvbW50L3JlcG8gPiAvZGV2L251bGwNCj4gPj4NCj4gPj4gCXJlYWwgICAgMjRtNy44
MTVzDQo+ID4+IAl1c2VyICAgIDBtMTUuMDE1cw0KPiA+PiAJc3lzICAgICAwbTQ4LjM0MHMNCj4g
Pj4gCSMNCj4gPj4NCj4gPj4gQW5kIHRoZSBpb191cmluZyB2ZXJzaW9uIHRha2VzOg0KPiA+Pg0K
PiA+PiAJIyBlY2hvIDMgPiAvcHJvYy9zeXMvdm0vZHJvcF9jYWNoZXMNCj4gPj4gCSMgdGltZSAu
L3VyaW5nZmluZCAvbW50L3JlcG8gPiAvZGV2L251bGwNCj4gPj4NCj4gPj4gCXJlYWwgICAgMTBt
MjkuMDY0cw0KPiA+PiAJdXNlciAgICAwbTQuMzQ3cw0KPiA+PiAJc3lzICAgICAwbTEuNjc3cw0K
PiA+PiAJIw0KPiA+DQo+ID4gV2hpbGUgdGhlcmUgbWF5IGJlIHVzZXMgZm9yIElPUklOR19PUF9H
RVRERU5UUyBhcmUgeW91IHN1cmUgeW91cg0KPiA+IHRlc3QgaXMgY29tcGFyaW5nIGxpa2Ugd2l0
aCBsaWtlPw0KPiA+IFRoZSB1bmRlcmx5aW5nIHdvcmsgaGFzIHRvIGJlIGRvbmUgaW4gZWl0aGVy
IGNhc2UsIHNvIHlvdSBhcmUNCj4gPiBzd2FwcGluZyBzeXN0ZW0gY2FsbHMgZm9yIGNvZGUgY29t
cGxleGl0eS4NCj4gDQo+IFdoYXQgY29tcGxleGl0eT8NCg0KRXZhbiBhZGRpbmcgY29tbWFuZHMg
dG8gYSBsaXN0IHRvIGV4ZWN1dGUgbGF0ZXIgaXMgJ2NvbXBsZXhpdHknLg0KQXMgaW4gYWRkaW5n
IG1vcmUgY3B1IGN5Y2xlcy4NCg0KPiA+IEkgc3VzcGVjdCB0aGF0IGZpbmQgaXMgYWN0dWFsbHkg
ZG9pbmcgYSBzdGF0KCkgY2FsbCBvbiBldmVyeQ0KPiA+IGRpcmVjdG9yeSBlbnRyeSBhbmQgdGhh
dCB5b3VyIGlvX3VyaW5nIGV4YW1wbGUgaXMganVzdCBiZWxpZXZpbmcNCj4gPiB0aGUgJ2RpcmVj
dG9yeScgZmxhZyByZXR1cm5lZCBpbiB0aGUgZGlyZWN0b3J5IGVudHJ5IGZvciBtb3N0DQo+ID4g
bW9kZXJuIGZpbGVzeXN0ZW1zLg0KPiANCj4gV2hpbGUgdGhhdCBtYXkgYmUgdHJ1ZSAoZmluZCBk
b2luZyBzdGF0IGFzIHdlbGwpLCB0aGUgcnVudGltZSBpcw0KPiBjbGVhcmx5IGRvbWluYXRlZCBi
eSBJTy4gQWRkaW5nIGEgc3RhdCBvbiB0b3Agd291bGQgYmUgYW4gZXh0cmENCj4gY29weSwgYnV0
IG5vIGV4dHJhIElPLg0KDQpJJ2QgZXhwZWN0IHN0YXQoKSB0byByZXF1aXJlIHRoZSBkaXNrIGlu
b2RlIGJlIHJlYWQgaW50byBtZW1vcnkuDQpnZXRkZW50cygpIG9ubHkgcmVxdWlyZXMgdGhlIGRh
dGEgb2YgdGhlIGRpcmVjdG9yeSBiZSByZWFkLg0KU28gY2FsbGluZyBzdGF0KCkgcmVxdWlyZXMg
YSBsb3QgbW9yZSBJTy4NCg0KVGhlIG90aGVyIHRoaW5nIEkganVzdCByZWFsaXNlcyBpcyB0aGF0
IHRoZSAnc3lzdGVtIHRpbWUnDQpvdXRwdXQgZnJvbSB0aW1lIGlzIGNvbXBsZXRlbHkgbWVhbmlu
Z2xlc3MgZm9yIHRoZSBpb191cmluZyBjYXNlLg0KQWxsIHRoYXQgcHJvY2Vzc2luZyBpcyBkb25l
IGJ5IGEga2VybmVsIHRocmVhZCBhbmQgSSBkb3VidA0KaXMgcmUtYXR0cmlidXRlZCB0byB0aGUg
dXNlciBwcm9jZXNzLg0KDQo+ID4gSWYgeW91IHdyaXRlIGEgcHJvZ3JhbSB0aGF0IGRvZXMgb3Bl
bmF0KCksIHJlYWRkaXIoKSwgY2xvc2UoKQ0KPiA+IGZvciBlYWNoIGRpcmVjdG9yeSBhbmQgd2l0
aCBhIGxvbmcgZW5vdWdoIGJ1ZmZlciAobW9zdGx5KSBkbw0KPiA+IG9uZSByZWFkZGlyKCkgcGVy
IGRpcmVjdG9yeSB5b3UnbGwgZ2V0IGEgbXVjaCBiZXR0ZXIgY29tcGFyaXNvbi4NCj4gPg0KPiA+
IFlvdSBjb3VsZCBldmVuIHdyaXRlIGEgcHJvZ3JhbSB3aXRoIDIgdGhyZWFkcywgb25lIGRvZXMg
YWxsIHRoZQ0KPiA+IG9wZW4vcmVhZGRpci9jbG9zZSBzeXN0ZW0gY2FsbHMgYW5kIHRoZSBvdGhl
ciBkb2VzIHRoZSBwcmludGluZw0KPiA+IGFuZCBnZW5lcmF0aW5nIHRoZSBsaXN0IG9mIGRpcmVj
dG9yaWVzIHRvIHByb2Nlc3MuDQo+ID4gVGhhdCBzaG91bGQgZ2V0IHRoZSBlcXVpdmFsZW50IG92
ZXJsYXBwaW5nIHRoYXQgaW9fdXJpbmcgZ2l2ZXMNCj4gPiB3aXRob3V0IG11Y2ggb2YgdGhlIGNv
bXBsZXhpdHkuDQo+IA0KPiBCdXQgdGhpcyBpcyB3aGF0IHRha2UgdGhlIG1vc3Qgb2ZmZW5zZSB0
byAtIGl0J3MgX3RyaXZpYWxfIHRvDQo+IHdyaXRlIHRoYXQgcHJvZ3JhbSB3aXRoIGlvX3VyaW5n
LCBlc3BlY2lhbGx5IGNvbXBhcmVkIHRvIG1hbmFnaW5nDQo+IHRocmVhZHMuIFRocmVhZHMgYXJl
IGNlcnRhaW5seSBhIG1vcmUga25vd24gcGFyYWRpZ20gYXQgdGhpcyBwb2ludCwNCj4gYnV0IGFu
IGlvX3VyaW5nIHN1Ym1pdCArIHJlYXAgbG9vcCBpcyBkZWZpbml0ZWx5IG5vdCAibXVjaCBvZiB0
aGUNCj4gY29tcGxleGl0eSIuIElmIHlvdSdyZSByZWZlcnJpbmcgdG8gdGhlIGtlcm5lbCBjaGFu
Z2UgaXRzZWxmLCB0aGF0J3MNCj4gdHJpdmlhbCwgYXMgdGhlIGRpZmZzdGF0IHNob3dzLg0KDQpJ
J3ZlIGxvb2tlZCBhdCB0aGUga2VybmVsIGNvZGUgaW4gaW9fdXJpbmcuYy4NCk1ha2VzIG1lIHB1
bGwgbXkgaGFpciBvdXQgKHdoYXQncyBsZWZ0IG9mIGl0IC0gbW9zdGx5IGJlYXJkKS4NCkFwYXJ0
IGZyb20gc2F2aW5nIHN5c3RlbSBjYWxsIGNvc3RzIEkgZG9uJ3QgYWN0dWFsbHkgdW5kZXJzdGFu
ZCB3aHkNCml0IGlzbid0IGEgdXNlcnNwYWNlIGxpYnJhcnk/DQoNCkFueXdheSwgSSB0aG91Z2h0
IHRoZSBwb2ludCBvZiBpb191cmluZyB3YXMgdG8gYXR0ZW1wdCB0byBpbXBsZW1lbnQNCmFzeW5j
aHJvbm91cyBJTyBvbiBhIHVuaXggc3lzdGVtLg0KSWYgeW91IHdhbnQgYXN5bmMgSU8geW91IG5l
ZWQgdG8gZ28gYmFjayB0byB0aGUgbWlkIDE5NzBzIGFuZCBwaWNrDQp0aGUgYW5jZXN0b3JzIG9m
IFJTTS8xMU0gcmF0aGVyIHRoYW4gdGhvc2Ugb2YgSyZSJ3MgdW5peC4NClRoYXQgbGVhZHMgeW91
IHRvIFVsdHJpeCBhbmQgdGhlbiBXaW5kb3dzIE5ULg0KDQpBbmQgeWVzLCBJIGhhdmUgd3JpdHRl
biBjb2RlIHRoYXQgZGlkIGFzeW5jIElPIHVuZGVyIFJTTS8xMU0uDQoNCglEYXZpZA0KDQotDQpS
ZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWls
dG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMp
DQo=


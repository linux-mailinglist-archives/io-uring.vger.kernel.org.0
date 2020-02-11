Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 574F5158D5D
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 12:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgBKLQp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Feb 2020 06:16:45 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:26140 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727994AbgBKLQp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Feb 2020 06:16:45 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-23-PgiBXMjfOvS6uoYNOFN1Uw-1; Tue, 11 Feb 2020 11:16:41 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 11 Feb 2020 11:16:40 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 11 Feb 2020 11:16:40 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Pavel Begunkov' <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] io_uring: fix iovec leaks
Thread-Topic: [PATCH] io_uring: fix iovec leaks
Thread-Index: AQHV3emh7zgsynhUKk2BR9GeKazohKgVyZ8AgAAQxACAAAIkUA==
Date:   Tue, 11 Feb 2020 11:16:40 +0000
Message-ID: <0d61cafdb0b040ac8bb3542b6022d0fc@AcuMS.aculab.com>
References: <03aa734fcea29805635689cc2f1aa648f23b5cd3.1581102250.git.asml.silence@gmail.com>
 <1255e56851a54c8c805695f1160bec9f@AcuMS.aculab.com>
 <045f6c04-a6d8-146c-75f3-2c0d65e482d6@gmail.com>
In-Reply-To: <045f6c04-a6d8-146c-75f3-2c0d65e482d6@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: PgiBXMjfOvS6uoYNOFN1Uw-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

RnJvbTogUGF2ZWwgQmVndW5rb3YNCj4gU2VudDogMTEgRmVicnVhcnkgMjAyMCAxMTowNQ0KPiBP
biAyLzExLzIwMjAgMTowNyBQTSwgRGF2aWQgTGFpZ2h0IHdyb3RlOg0KPiA+IEZyb206IFBhdmVs
IEJlZ3Vua292DQo+ID4+IFNlbnQ6IDA3IEZlYnJ1YXJ5IDIwMjAgMTk6MDUNCj4gPj4gQWxsb2Nh
dGVkIGlvdmVjIGlzIGZyZWVkIG9ubHkgaW4gaW9fe3JlYWQsd3JpdGUsc2VuZCxyZWN2KSgpLCBh
bmQganVzdA0KPiA+PiBsZWF2ZXMgaXQgaWYgYW4gZXJyb3Igb2NjdXJlZC4gVGhlcmUgYXJlIHBs
ZW50eSBvZiBzdWNoIGNhc2VzOg0KPiA+PiAtIGNhbmNlbGxhdGlvbiBvZiBub24taGVhZCByZXF1
ZXN0cw0KPiA+PiAtIGZhaWwgZ3JhYmJpbmcgZmlsZXMgaW4gX19pb19xdWV1ZV9zcWUoKQ0KPiA+
PiAtIHNldCBSRVFfRl9OT1dBSVQgYW5kIHJldHVybmluZyBpbiBfX2lvX3F1ZXVlX3NxZSgpDQo+
ID4+IC0gZXRjLg0KPiA+Pg0KPiA+PiBBZGQgUkVRX0ZfTkVFRF9DTEVBTlVQLCB3aGljaCB3aWxs
IGZvcmNlIHN1Y2ggcmVxdWVzdHMgd2l0aCBjdXN0b20NCj4gPj4gYWxsb2NhdGVkIHJlc291cnNl
cyBnbyB0aHJvdWdoIGNsZWFudXAgaGFuZGxlcnMgb24gcHV0Lg0KPiA+DQo+ID4gVGhpcyBsb29r
cyBob3JyaWJseSBmcmFnaWxlLg0KPiANCj4gV2VsbCwgbm90IGFzIGhvcnJpYmxlIGFzIGl0IG1h
eSBhcHBlYXIgLS0gc2V0IHRoZSBmbGFnLCB3aGVuZXZlciB5b3UNCj4gd2FudCB0aGUgY29ycmVz
cG9uZGluZyBkZXN0cnVjdG9yIHRvIGJlIGNhbGxlZCwgYW5kIGNsZWFyIGl0IHdoZW4gaXMgbm90
DQo+IG5lZWRlZCBhbnltb3JlLg0KPiANCj4gSSdkIGxvdmUgdG8gaGF2ZSBzb21ldGhpbmcgYmV0
dGVyLCBtYXliZSBldmVuIHNvbWV0aGluZyBtb3JlIGludHJ1c2l2ZQ0KPiBmb3ItbmV4dCwgYnV0
IHRoYXQgc2hvdWxkbid0IGh1cnQgdGhlIGhvdCBwYXRoLiBBbnkgaWRlYXM/DQoNCkdpdmVuIGFs
bCB0aGUgJ2N1ZCBjaGV3aW5nJyB0aGF0IGhhcHBlbnMgaW4gY29kZSBwYXRocw0KbGlrZSB0aGUg
b25lIHRoYXQgcmVhZCBpb3YgZnJvbSB1c2Vyc3BhY2UganVzdCBhZGRpbmc6DQoNCglpZiAodW5s
aWtlbHkoZm9vLT5wdHIpKQ0KCQlrZnJlZShmb28tPnB0cik7DQoNCmJlZm9yZSAnZm9vJyBnb2Vz
IG91dCBvZiBzY29wZSAob3IgaXMgcmV1c2VkKSBpcyBwcm9iYWJseQ0Kbm90IG1lYXN1cmFibGUu
DQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9h
ZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBO
bzogMTM5NzM4NiAoV2FsZXMpDQo=


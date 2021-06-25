Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD813B3E4B
	for <lists+io-uring@lfdr.de>; Fri, 25 Jun 2021 10:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbhFYIRh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Jun 2021 04:17:37 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:30558 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229474AbhFYIRg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Jun 2021 04:17:36 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-42-I7doZoJKNZWecWq3x0a12w-1; Fri, 25 Jun 2021 09:15:10 +0100
X-MC-Unique: I7doZoJKNZWecWq3x0a12w-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 25 Jun
 2021 09:15:10 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Fri, 25 Jun 2021 09:15:10 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jens Axboe' <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4] io_uring: reduce latency by reissueing the operation
Thread-Topic: [PATCH v4] io_uring: reduce latency by reissueing the operation
Thread-Index: AQHXaVtl2q0tMJQtUkiOWyGROZvBO6skYO6g
Date:   Fri, 25 Jun 2021 08:15:10 +0000
Message-ID: <c85e28df251d4c66a511dc157b795b13@AcuMS.aculab.com>
References: <9e8441419bb1b8f3c3fcc607b2713efecdef2136.1624364038.git.olivier@trillion01.com>
 <16c91f57-9b6f-8837-94af-f096d697f5fb@kernel.dk>
In-Reply-To: <16c91f57-9b6f-8837-94af-f096d697f5fb@kernel.dk>
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

RnJvbTogSmVucyBBeGJvZQ0KPiBTZW50OiAyNSBKdW5lIDIwMjEgMDE6NDUNCj4gDQo+IE9uIDYv
MjIvMjEgNjoxNyBBTSwgT2xpdmllciBMYW5nbG9pcyB3cm90ZToNCj4gPiBJdCBpcyBxdWl0ZSBm
cmVxdWVudCB0aGF0IHdoZW4gYW4gb3BlcmF0aW9uIGZhaWxzIGFuZCByZXR1cm5zIEVBR0FJTiwN
Cj4gPiB0aGUgZGF0YSBiZWNvbWVzIGF2YWlsYWJsZSBiZXR3ZWVuIHRoYXQgZmFpbHVyZSBhbmQg
dGhlIGNhbGwgdG8NCj4gPiB2ZnNfcG9sbCgpIGRvbmUgYnkgaW9fYXJtX3BvbGxfaGFuZGxlcigp
Lg0KPiA+DQo+ID4gRGV0ZWN0aW5nIHRoZSBzaXR1YXRpb24gYW5kIHJlaXNzdWluZyB0aGUgb3Bl
cmF0aW9uIGlzIG11Y2ggZmFzdGVyDQo+ID4gdGhhbiBnb2luZyBhaGVhZCBhbmQgcHVzaCB0aGUg
b3BlcmF0aW9uIHRvIHRoZSBpby13cS4NCj4gPg0KPiA+IFBlcmZvcm1hbmNlIGltcHJvdmVtZW50
IHRlc3RpbmcgaGFzIGJlZW4gcGVyZm9ybWVkIHdpdGg6DQo+ID4gU2luZ2xlIHRocmVhZCwgMSBU
Q1AgY29ubmVjdGlvbiByZWNlaXZpbmcgYSA1IE1icHMgc3RyZWFtLCBubyBzcXBvbGwuDQo+ID4N
Cj4gPiA0IG1lYXN1cmVtZW50cyBoYXZlIGJlZW4gdGFrZW46DQo+ID4gMS4gVGhlIHRpbWUgaXQg
dGFrZXMgdG8gcHJvY2VzcyBhIHJlYWQgcmVxdWVzdCB3aGVuIGRhdGEgaXMgYWxyZWFkeSBhdmFp
bGFibGUNCj4gPiAyLiBUaGUgdGltZSBpdCB0YWtlcyB0byBwcm9jZXNzIGJ5IGNhbGxpbmcgdHdp
Y2UgaW9faXNzdWVfc3FlKCkgYWZ0ZXIgdmZzX3BvbGwoKSBpbmRpY2F0ZWQgdGhhdCBkYXRhDQo+
IHdhcyBhdmFpbGFibGUNCj4gPiAzLiBUaGUgdGltZSBpdCB0YWtlcyB0byBleGVjdXRlIGlvX3F1
ZXVlX2FzeW5jX3dvcmsoKQ0KPiA+IDQuIFRoZSB0aW1lIGl0IHRha2VzIHRvIGNvbXBsZXRlIGEg
cmVhZCByZXF1ZXN0IGFzeW5jaHJvbm91c2x5DQo+ID4NCj4gPiAyLjI1JSBvZiBhbGwgdGhlIHJl
YWQgb3BlcmF0aW9ucyBkaWQgdXNlIHRoZSBuZXcgcGF0aC4NCg0KSG93IG11Y2ggc2xvd2VyIGlz
IGl0IHdoZW4gdGhlIGRhdGEgdG8gY29tcGxldGUgdGhlIHJlYWQgaXNuJ3QNCmF2YWlsYWJsZT8N
Cg0KSSBzdXNwZWN0IHRoZXJlIGFyZSBkaWZmZXJlbnQgd29ya2Zsb3dzIHdoZXJlIHRoYXQgaXMg
YWxtb3N0DQphbHdheXMgdHJ1ZS4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBM
YWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBU
LCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==


Return-Path: <io-uring+bounces-195-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E3C98012C2
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 19:31:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3372281F47
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 18:31:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3206D5101A;
	Fri,  1 Dec 2023 18:30:31 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0047BC1
	for <io-uring@vger.kernel.org>; Fri,  1 Dec 2023 10:30:22 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-64-l9Pbyyc5NbCVu4Mqkqv9Yg-1; Fri, 01 Dec 2023 18:30:13 +0000
X-MC-Unique: l9Pbyyc5NbCVu4Mqkqv9Yg-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 1 Dec
 2023 18:30:05 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Fri, 1 Dec 2023 18:30:05 +0000
From: David Laight <David.Laight@ACULAB.COM>
To: 'Jann Horn' <jannh@google.com>, Jens Axboe <axboe@kernel.dk>, "Pavel
 Begunkov" <asml.silence@gmail.com>, io-uring <io-uring@vger.kernel.org>
CC: kernel list <linux-kernel@vger.kernel.org>, Peter Zijlstra
	<peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon
	<will@kernel.org>, Waiman Long <longman@redhat.com>
Subject: RE: io_uring: incorrect assumption about mutex behavior on unlock?
Thread-Topic: io_uring: incorrect assumption about mutex behavior on unlock?
Thread-Index: AQHaJHVMNn8At2QRcESH/qhfYed73LCUvC/Q
Date: Fri, 1 Dec 2023 18:30:05 +0000
Message-ID: <811a97651e144b83a35fd7eb713aeeae@AcuMS.aculab.com>
References: <CAG48ez3xSoYb+45f1RLtktROJrpiDQ1otNvdR+YLQf7m+Krj5Q@mail.gmail.com>
In-Reply-To: <CAG48ez3xSoYb+45f1RLtktROJrpiDQ1otNvdR+YLQf7m+Krj5Q@mail.gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64

RnJvbTogSmFubiBIb3JuDQo+IFNlbnQ6IDAxIERlY2VtYmVyIDIwMjMgMTY6NDENCj4gDQo+IG11
dGV4X3VubG9jaygpIGhhcyBhIGRpZmZlcmVudCBBUEkgY29udHJhY3QgY29tcGFyZWQgdG8gc3Bp
bl91bmxvY2soKS4NCj4gc3Bpbl91bmxvY2soKSBjYW4gYmUgdXNlZCB0byByZWxlYXNlIG93bmVy
c2hpcCBvZiBhbiBvYmplY3QsIHNvIHRoYXQNCj4gYXMgc29vbiBhcyB0aGUgc3BpbmxvY2sgaXMg
dW5sb2NrZWQsIGFub3RoZXIgdGFzayBpcyBhbGxvd2VkIHRvIGZyZWUNCj4gdGhlIG9iamVjdCBj
b250YWluaW5nIHRoZSBzcGlubG9jay4NCj4gbXV0ZXhfdW5sb2NrKCkgZG9lcyBub3Qgc3VwcG9y
dCB0aGlzIGtpbmQgb2YgdXNhZ2U6IFRoZSBjYWxsZXIgb2YNCj4gbXV0ZXhfdW5sb2NrKCkgbXVz
dCBlbnN1cmUgdGhhdCB0aGUgbXV0ZXggc3RheXMgYWxpdmUgdW50aWwNCj4gbXV0ZXhfdW5sb2Nr
KCkgaGFzIHJldHVybmVkLg0KDQpUaGUgcHJvYmxlbSBzZXF1ZW5jZSBtaWdodCBiZToNCglUaHJl
YWQgQQkJVGhyZWFkIEINCgltdXRleF9sb2NrKCkNCgkJCQljb2RlIHRvIHN0b3AgbXV0ZXggYmVp
bmcgcmVxdWVzdGVkDQoJCQkJLi4uDQoJCQkJbXV0ZXhfbG9jaygpIC0gc2xlZXBzDQoJbXV0ZXhf
dW5sb2NrKCkuLi4NCgkJV2FpdGVycyB3b2tlbi4uLg0KCQlpc3IgYW5kL29yIHByZS1lbXB0ZWQN
CgkJCQktIHdha2VzIHVwDQoJCQkJbXV0ZXhfdW5sb2NrKCkNCgkJCQlmcmVlKCkNCgkJLi4uIG1v
cmUga2VybmVsIGNvZGUgYWNjZXNzIHRoZSBtdXRleA0KCQlCT09PTQ0KDQpXaGF0IGhhcHBlbnMg
aW4gYSBQUkVFTVBUX1JUIGtlcm5lbCB3aGVyZSBtb3N0IG9mIHRoZSBzcGluX3VubG9jaygpDQpn
ZXQgcmVwbGFjZWQgYnkgbXV0ZXhfdW5sb2NrKCkuDQpTZWVtcyBsaWtlIHRoZXkgY2FuIHBvdGVu
dGlhbGx5IGFjY2VzcyBhIGZyZWVkIG11dGV4Pw0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBB
ZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMs
IE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K



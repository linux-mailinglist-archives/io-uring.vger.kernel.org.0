Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2A43A5DF2
	for <lists+io-uring@lfdr.de>; Mon, 14 Jun 2021 09:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbhFNH4I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Jun 2021 03:56:08 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:49808 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232536AbhFNH4G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Jun 2021 03:56:06 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mtapsc-1-JvShZJ_LMNqZy9EC7CzP_Q-1; Mon, 14 Jun 2021 08:54:01 +0100
X-MC-Unique: JvShZJ_LMNqZy9EC7CzP_Q-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 14 Jun
 2021 08:54:00 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Mon, 14 Jun 2021 08:54:00 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Victor Stewart' <v@nametag.social>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>
Subject: RE: io_uring: BPF controlled I/O
Thread-Topic: io_uring: BPF controlled I/O
Thread-Index: AQHXW85OPTAHTIrwlU6lTLNP07tyDqsTLD+g
Date:   Mon, 14 Jun 2021 07:54:00 +0000
Message-ID: <2d4e188665c5425296f2da0e96c744af@AcuMS.aculab.com>
References: <23168ac0-0f05-3cd7-90dc-08855dd275b2@gmail.com>
 <CAM1kxwjHrf74u5OLB=acP2fBy+cPG4NNxa-51O35caY4VKdkkg@mail.gmail.com>
In-Reply-To: <CAM1kxwjHrf74u5OLB=acP2fBy+cPG4NNxa-51O35caY4VKdkkg@mail.gmail.com>
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

RnJvbTogVmljdG9yIFN0ZXdhcnQNCj4gU2VudDogMDcgSnVuZSAyMDIxIDE5OjUxDQouLi4NCj4g
Y29pbmNpZGVudGFsbHkgaSdtIHRvc3NpbmcgYXJvdW5kIGluIG15IG1pbmQgYXQgdGhlIG1vbWVu
dCBhbiBpZGVhIGZvcg0KPiBvZmZsb2FkaW5nDQo+IHRoZSBQSU5HL1BPTkcgb2YgYSBRVUlDIHNl
cnZlci9jbGllbnQgaW50byB0aGUga2VybmVsIHZpYSBlQlBGLg0KPiANCj4gcHJvYmxlbSBiZWlu
ZywgYmVpbmcgdGhhdCBRVUlDIGlzIHVzZXJzcGFjZSBydW4gdHJhbnNwb3J0IGFuZCB0aGF0IE5B
VC1lZCBVRFANCj4gbWFwcGluZ3MgY2FuJ3QgYmUgZXhwZWN0ZWQgdG8gc3RheSBvcGVuIGxvbmdl
ciB0aGFuIDMwIHNlY29uZHMsIFFVSUMNCj4gYXBwbGljYXRpb25zDQo+IGJhcmUgYSBsYXJnZSBj
b3N0IG9mIGNvbnRleHQgc3dpdGNoaW5nIHdha2UtdXAgdG8gY29uZHVjdCBjb25uZWN0aW9uIGxp
ZmV0aW1lDQo+IG1haW50ZW5hbmNlLi4uIGVzcGVjaWFsbHkgd2hlbiBtYW5hZ2luZyBhIGxhcmdl
IG51bWJlciBvZiBtb3N0bHkgaWRsZSBsb25nIGxpdmVkDQo+IGNvbm5lY3Rpb25zLiBzbyBvZmZs
b2FkaW5nIHRoaXMgbWFpbnRlbmFuY2Ugc2VydmljZSBpbnRvIHRoZSBrZXJuZWwNCj4gd291bGQg
YmUgYSBncmVhdA0KPiBlZmZpY2llbmN5IGJvb24uDQo+IA0KPiB0aGUgbWFpbiBpbXBlZGltZW50
IGlzIHRoYXQgYWNjZXNzIHRvIHRoZSBrZXJuZWwgY3J5cHRvIGxpYnJhcmllcw0KPiBpc24ndCBj
dXJyZW50bHkgcG9zc2libGUNCj4gZnJvbSBlQlBGLiB0aGF0IHNhaWQsIGNvbm5lY3Rpb24gd2lk
ZSBjcnlwdG8gb2ZmbG9hZCBpbnRvIHRoZSBOSUMgaXMgYQ0KPiBmcmVxdWVudGx5IG1lbnRpb25l
ZA0KPiBzdWJqZWN0IGluIFFVSUMgY2lyY2xlcywgc28gb25lIGNvdWxkIGFyZ3VlIGJldHRlciB0
byBhbGxvY2F0ZSB0aGUNCj4gdGltZSB0byBOSUMgY3J5cHRvIG9mZmxvYWQNCj4gYW5kIHRoZW4g
c2ltcGx5IGNvbmR1Y3QgdGhpcyBQSU5HL1BPTkcgb2ZmbG9hZCBpbiBwbGFpbiB0ZXh0Lg0KDQpI
bW1tbS4uLiBhIGdvb2QgZXhhbXBsZSBvZiBob3cgbm90IHRvIHR5cGUgZW1haWxzLg0KDQpUaG91
Z2h0LCBkb2VzIHRoZSBVRFAgdHggbmVlZGVkIHRvIGtlZXAgdGhlIE5BVCB0YWJsZXMgYWN0aXZl
DQpuZWVkIHRvIGJlIGVuY3J5cHRlZD8NCkEgc2luZ2xlIGJ5dGUgVURQIHBhY2tldCB3b3VsZCBk
byB0aGUgdHJpY2suDQpZb3UganVzdCBuZWVkIHNvbWV0aGluZyB0aGUgcmVtb3RlIHN5c3RlbSBp
cyBkZXNpZ25lZCB0byBpZ25vcmUuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3Mg
TGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQ
VCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=


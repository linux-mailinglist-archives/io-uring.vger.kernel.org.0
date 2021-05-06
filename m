Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1BE43751D6
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 11:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234283AbhEFJyz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 May 2021 05:54:55 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:45309 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231194AbhEFJyz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 May 2021 05:54:55 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-138-SkAPRRxqPq-oJXvQAjJ0Rg-1; Thu, 06 May 2021 10:53:55 +0100
X-MC-Unique: SkAPRRxqPq-oJXvQAjJ0Rg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Thu, 6 May 2021 10:53:53 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Thu, 6 May 2021 10:53:53 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Andy Lutomirski' <luto@kernel.org>,
        'Simon Marchi' <simon.marchi@polymtl.ca>
CC:     'Stefan Metzmacher' <metze@samba.org>,
        'Borislav Petkov' <bp@alien8.de>,
        'Peter Zijlstra' <peterz@infradead.org>,
        'Linus Torvalds' <torvalds@linux-foundation.org>,
        'Thomas Gleixner' <tglx@linutronix.de>,
        'Jens Axboe' <axboe@kernel.dk>,
        'Linux Kernel Mailing List' <linux-kernel@vger.kernel.org>,
        'io-uring' <io-uring@vger.kernel.org>,
        "'the arch/x86 maintainers'" <x86@kernel.org>,
        "'linux-toolchains@vger.kernel.org'" 
        <linux-toolchains@vger.kernel.org>
Subject: RE: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
Thread-Topic: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
Thread-Index: AQHXQfuSElK5zn4+eUeudkt5GoEV9qrWNZZwgAABpwA=
Date:   Thu, 6 May 2021 09:53:53 +0000
Message-ID: <d75fe3d7c898497e803658e0053c2701@AcuMS.aculab.com>
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de>
 <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
 <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com>
 <YJEIOx7GVyZ+36zJ@hirez.programming.kicks-ass.net> <YJFptPyDtow//5LU@zn.tnic>
 <044d0bad-6888-a211-e1d3-159a4aeed52d@polymtl.ca>
 <932d65e1-5a8f-c86a-8673-34f0e006c27f@samba.org>
 <30e248aa-534d-37ff-2954-a70a454391fc@polymtl.ca>
 <CALCETrUF5M+Qw+RfY8subR7nzmpMyFsE3NHSAPoMVWMz6_hr-w@mail.gmail.com>
 <f6f7e559d6454f56a009190649bc745a@AcuMS.aculab.com>
In-Reply-To: <f6f7e559d6454f56a009190649bc745a@AcuMS.aculab.com>
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

PiA+IChUbyBhdm9pZCBjb25mdXNpb24sIHRoaXMgaXMgbm90IGEgdW5pdmVyc2FsIHByb3BlcnR5
IG9mIExpbnV4LiAgYXJtNjQNCj4gPiBhbmQgYXJtMzIgdGFza3Mgb24gYW4gYXJtNjQgTGludXgg
aG9zdCBhcmUgZGlmZmVyZW50IGFuZCBjYW5ub3QNCj4gPiBhcmJpdHJhcmlseSBzd2l0Y2ggbW9k
ZXMuKQ0KPiANCj4gQWx0aG91Z2ggdGhlcmUgYXJlIHBhdGNoZXMgbHVya2luZyB0byBjaGFuZ2Ug
dGhhdC4NCj4gKG5vdCBmcm9tIG1lKS4NCg0KQWN0dWFsbHkgdGhleSBtYXkgYmUganVzdCB0byBh
bGxvdyA2NGJpdCB0YXNrcyBtYWtlIDMyYml0IHN5c3RlbSBjYWxscy4NClRoZSBjb2RlIGlzIGFs
bW9zdCBjZXJ0YWlubHkgc3RpbGwgNTRiaXQuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFk
ZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywg
TUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=


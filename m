Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589B6330C03
	for <lists+io-uring@lfdr.de>; Mon,  8 Mar 2021 12:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbhCHLM3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Mar 2021 06:12:29 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:24170 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231494AbhCHLMW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Mar 2021 06:12:22 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-112-KNB_LER4Oqm6bhVHwCpAlw-1; Mon, 08 Mar 2021 11:11:13 +0000
X-MC-Unique: KNB_LER4Oqm6bhVHwCpAlw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 8 Mar 2021 11:11:13 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 8 Mar 2021 11:11:13 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Stefan Metzmacher' <metze@samba.org>,
        =?utf-8?B?QW5kcsOpIEFsbWVpZGE=?= <andrealmeid@collabora.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Darren Hart" <dvhart@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC:     "kernel@collabora.com" <kernel@collabora.com>,
        "krisman@collabora.com" <krisman@collabora.com>,
        "pgriffais@valvesoftware.com" <pgriffais@valvesoftware.com>,
        "z.figura12@gmail.com" <z.figura12@gmail.com>,
        "joel@joelfernandes.org" <joel@joelfernandes.org>,
        "malteskarupke@fastmail.fm" <malteskarupke@fastmail.fm>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "fweimer@redhat.com" <fweimer@redhat.com>,
        "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "acme@kernel.org" <acme@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        io-uring <io-uring@vger.kernel.org>
Subject: RE: [RFC PATCH v2 00/13] Add futex2 syscall
Thread-Topic: [RFC PATCH v2 00/13] Add futex2 syscall
Thread-Index: AQHXE0YJHACUUxYyXUab2jknvqbfD6p571Lw
Date:   Mon, 8 Mar 2021 11:11:13 +0000
Message-ID: <f594f043f5c7440d8e3534e9a14c97c4@AcuMS.aculab.com>
References: <20210304004219.134051-1-andrealmeid@collabora.com>
 <ecbed98e-882a-0c0e-d4e1-bd33960f3674@samba.org>
In-Reply-To: <ecbed98e-882a-0c0e-d4e1-bd33960f3674@samba.org>
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

RnJvbTogU3RlZmFuIE1ldHptYWNoZXINCj4gU2VudDogMDcgTWFyY2ggMjAyMSAxMTozNQ0KPiAN
Cj4gSGkgQW5kcsOpLA0KPiA+ICAqKiBUaGUgd2FpdCBvbiBtdWx0aXBsZSBwcm9ibGVtDQo+ID4N
Cj4gPiAgVGhlIHVzZSBjYXNlIGxpZXMgaW4gdGhlIFdpbmUgaW1wbGVtZW50YXRpb24gb2YgdGhl
IFdpbmRvd3MgTlQgaW50ZXJmYWNlDQo+ID4gIFdhaXRNdWx0aXBsZU9iamVjdHMuIFRoaXMgV2lu
ZG93cyBBUEkgZnVuY3Rpb24gYWxsb3dzIGEgdGhyZWFkIHRvIHNsZWVwDQo+ID4gIHdhaXRpbmcg
b24gdGhlIGZpcnN0IG9mIGEgc2V0IG9mIGV2ZW50IHNvdXJjZXMgKG11dGV4ZXMsIHRpbWVycywg
c2lnbmFsLA0KPiA+ICBjb25zb2xlIGlucHV0LCBldGMpIHRvIHNpZ25hbC4NCg0KVGhleSBhcmUg
YWxsIGV2ZW50cy4NCllvdSBjYW4gb25seSB3YWl0IG9uIGVpdGhlciBldmVudHMgb3Igc29ja2V0
cyAodXNpbmcgc2VsZWN0KS4NClRoZXJlIGlzIGEgc29ja2V0IGFwaSB0byBzaWduYWwgYW4gZXZl
bnQgd2hlbiBkYXRhIGFycml2ZXMgKGV0YykuDQpUaGVyZSBpcyBhbHNvIHRoZSBpbnNhbmUgKHRo
ZXNlIGRheXMpIHJlc3RyaWN0aW9uIG9mIDY0IGV2ZW50cy4NCg0KPiBXaXRoIHRoYXQgaW4gbWlu
ZCB3b3VsZCBpdCBiZSBnb29kIHRvIGhhdmUgc29tZSBpbnRlcmFjdGlvbiB3aXRoIGVwb2xsIChh
bmQgc2ltaWxhciBjYWxscyk/DQoNCk9yIGhvb2sgc29tZXRoaW5nIHVwIHNvIHRoYXQgcG9sbHdh
a2V1cCBjYW4ga2ljayBhIGZ1dGV4IGFzIHdlbGwNCmFzIHdha2luZyB1cCBwb2xsKCkgYW5kIGFk
ZGluZyBhbiBldmVudCB0byBlcG9sbCgpLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRy
ZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1L
MSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K


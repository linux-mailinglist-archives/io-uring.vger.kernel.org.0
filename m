Return-Path: <io-uring+bounces-1878-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 913138C3322
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 20:25:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C21D11C20D0B
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 18:25:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA8601C698;
	Sat, 11 May 2024 18:25:46 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159E41CA9E
	for <io-uring@vger.kernel.org>; Sat, 11 May 2024 18:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.58.86.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715451946; cv=none; b=Te4oYg34085t37icb+Oi9jQNjhpl1f6J8n6HTrr6uXLcy3snETcd3FCOctIXXSlepqO75kxFXQqDouFv6+9TuSBBb5pZaexUi4ZCZjmZpOf1F8ughe59T1addZHEOXsN92idkuAuTyHRR4ST+Seo4zq36fP8kNG9Yh7dDRXc3yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715451946; c=relaxed/simple;
	bh=SQkRJ+POEYNpmaLKC5bXQukzr7BtcJy8mua2DhWEbtA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=aacA3K/sDwHXiOQQKYFdfRu5sCKtg9FsXY8Q/uPn3tG+lEeSXMGMqg+5sQBExfaDHo7dQqwZezmeD+qwP+iFH45sKeksgRCNesNKyjniCKVBa3RxlGrhYDcD+QH4txHJfuBXt9Dh/gxi1c9+C1lZc74mTkr4ePGY/S8KWvhA7nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM; spf=pass smtp.mailfrom=aculab.com; arc=none smtp.client-ip=185.58.86.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aculab.com
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-7-hlD-hTv5PSKv4xd1znQCwQ-1; Sat, 11 May 2024 19:25:35 +0100
X-MC-Unique: hlD-hTv5PSKv4xd1znQCwQ-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sat, 11 May
 2024 19:25:02 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Sat, 11 May 2024 19:25:02 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: 'Christian Brauner' <brauner@kernel.org>, Daniel Vetter <daniel@ffwll.ch>
CC: =?utf-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <ckoenig.leichtzumerken@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro
	<viro@zeniv.linux.org.uk>, "keescook@chromium.org" <keescook@chromium.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>, "christian.koenig@amd.com"
	<christian.koenig@amd.com>, "dri-devel@lists.freedesktop.org"
	<dri-devel@lists.freedesktop.org>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "jack@suse.cz" <jack@suse.cz>,
	"laura@labbott.name" <laura@labbott.name>, "linaro-mm-sig@lists.linaro.org"
	<linaro-mm-sig@lists.linaro.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-media@vger.kernel.org"
	<linux-media@vger.kernel.org>, "minhquangbui99@gmail.com"
	<minhquangbui99@gmail.com>, "sumit.semwal@linaro.org"
	<sumit.semwal@linaro.org>,
	"syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com"
	<syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com>,
	"syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>
Subject: RE: [Linaro-mm-sig] Re: [PATCH] epoll: try to be a _bit_ better about
 file lifetimes
Thread-Topic: [Linaro-mm-sig] Re: [PATCH] epoll: try to be a _bit_ better
 about file lifetimes
Thread-Index: AQHaosiO/bmWtIycWUWbxqLWgzPstbGSV1Yw
Date: Sat, 11 May 2024 18:25:02 +0000
Message-ID: <b3e869996b554b57bf59a66cc10ac810@AcuMS.aculab.com>
References: <202405031110.6F47982593@keescook>
 <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV>
 <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240504-wohngebiet-restwert-6c3c94fddbdd@brauner>
 <CAHk-=wj_Fu1FkMFrjivQ=MGkwkKXZBuh0f4BEhcZHD5WCvHesw@mail.gmail.com>
 <CAHk-=wj6XL9MGCd_nUzRj6SaKeN0TsyTTZDFpGdW34R+zMZaSg@mail.gmail.com>
 <b1728d20-047c-4e28-8458-bf3206a1c97c@gmail.com>
 <20240508-risse-fehlpass-895202f594fd@brauner>
 <ZjueITUy0K8TP1WO@phenom.ffwll.local>
 <20240510-duzen-uhrmacher-141c9331f1bf@brauner>
In-Reply-To: <20240510-duzen-uhrmacher-141c9331f1bf@brauner>
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

RnJvbTogQ2hyaXN0aWFuIEJyYXVuZXINCj4gU2VudDogMTAgTWF5IDIwMjQgMTE6NTUNCj4gDQo+
ID4gRm9yIHRoZSB1YXBpIGlzc3VlIHlvdSBkZXNjcmliZSBiZWxvdyBteSB0YWtlIHdvdWxkIGJl
IHRoYXQgd2Ugc2hvdWxkIGp1c3QNCj4gPiB0cnksIGFuZCBob3BlIHRoYXQgZXZlcnlvbmUncyBi
ZWVuIGR1dGlmdWxseSB1c2luZyBPX0NMT0VYRUMuIEJ1dCBtYXliZQ0KPiA+IEknbSBiaWFzZWQg
ZnJvbSB0aGUgZ3B1IHdvcmxkLCB3aGVyZSB3ZSd2ZSBiZWVuIGhhbW1lcmluZyBpdCBpbiB0aGF0
DQo+ID4gIk9fQ0xPRVhFQyBvciBidXN0IiBtYW50cmEgc2luY2Ugd2VsbCBvdmVyIGEgZGVjYWRl
LiBSZWFsbHkgdGhlIG9ubHkgdmFsaWQNCj4gDQo+IE9oLCB3ZSdyZSB2ZXJ5IG11Y2ggb24gdGhl
IHNhbWUgcGFnZS4gQWxsIG5ldyBmaWxlIGRlc2NyaXB0b3IgdHlwZXMgdGhhdA0KPiBJJ3ZlIGFk
ZGVkIG92ZXIgdGhlIHllYXJzIGFyZSBPX0NMT0VYRUMgYnkgZGVmYXVsdC4gSU9XLCB5b3UgbmVl
ZCB0bw0KPiByZW1vdmUgT19DTE9FWEVDIGV4cGxpY2l0bHkgKHNlZSBwaWRmZCBhcyBhbiBleGFt
cGxlKS4gQW5kIGltaG8sIGFueSBuZXcNCj4gZmQgdHlwZSB0aGF0J3MgYWRkZWQgc2hvdWxkIGp1
c3QgYmUgT19DTE9FWEVDIGJ5IGRlZmF1bHQuDQoNCkZvciBmZCBhIHNoZWxsIHJlZGlyZWN0IGNy
ZWF0ZXMgeW91IG1heSB3YW50IHNvIGJlIGFibGUgdG8gc2F5DQondGhpcyBmZCB3aWxsIGhhdmUg
T19DTE9FWEVDIHNldCBhZnRlciB0aGUgbmV4dCBleGVjJy4NCkFsc28gKHBvc3NpYmx5KSBhIGZs
YWcgdGhhdCBjYW4ndCBiZSBjbGVhcmVkIG9uY2Ugc2V0IGFuZCB0aGF0DQpnZXRzIGtlcHQgYnkg
ZHVwKCkgZXRjLg0KQnV0IG1heWJlIHRoYXQgaXMgZXhjZXNzaXZlPw0KDQpJJ3ZlIGNlcnRhaW5s
eSB1c2VkOg0KIyBpcCBuZXRucyBleGVjIG5zIGNvbW1hbmQgMzwvc3lzL2NsYXNzL25ldA0KaW4g
b3JkZXIgdG8gYmUgYWJsZSB0byAoZWFzaWx5KSByZWFkIHN0YXR1cyBmb3IgaW50ZXJmYWNlcyBp
biB0aGUNCmRlZmF1bHQgbmFtZXNwYWNlIGFuZCBhIHNwZWNpZmljIG5hbWVzcGFjZS4NClRoZSB3
b3VsZCBiZSBoYXJkIGlmIHRoZSBPX0NMT0VYRUMgZmxhZyBoYWQgZ290IHNldCBieSBkZWZhdWx0
Lg0KKEVzcGVjaWFsbHkgd2l0aG91dCBhIHNoZWxsIGJ1aWx0aW4gdG8gY2xlYXIgaXQuKQ0KDQoJ
RGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1v
dW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEz
OTczODYgKFdhbGVzKQ0K



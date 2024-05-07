Return-Path: <io-uring+bounces-1816-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 545288BEE84
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 23:03:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0813C286075
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 21:03:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23FF971B3B;
	Tue,  7 May 2024 21:03:24 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F7E58AB8
	for <io-uring@vger.kernel.org>; Tue,  7 May 2024 21:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.58.85.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715115804; cv=none; b=dzwMUgId4nohFciGzSlFwDDyq0JJqUPMTSwm8HnwPhqe9yOLGny7djx1XszLwPBQ62HTKAc3N61UNccJ2qX2RIIxa6aHJxOU0F1l4EmH1DXy4dVeCBZT0pW/C1ewo5rY5bVlZmY6a1E5FFhO1gQXpQktbIw9Bb3WHtPjriGwJeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715115804; c=relaxed/simple;
	bh=3rX9T5lNLNXBgcO0+M3qrprf2vCsbTOm/nlDTBm/9Cg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=tYEYQaRd1S2eiy+pFfPKAmCKpfH7YXudr00xWlvvSXDPORUc9jQPQxhNa/11bX8uKRmafXClwT7BXz/2cGP7yAuKvfZ04mnTvArnaLCovvDhEIfdqifwa6vlt57eDT6tVzMtx5EccoljzwD/PseQ+uR/F1ESfJXCKlhJAyOAyc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM; spf=pass smtp.mailfrom=aculab.com; arc=none smtp.client-ip=185.58.85.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aculab.com
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-48-bRehh-PWPia-pmBo6oqoQQ-1; Tue, 07 May 2024 22:03:13 +0100
X-MC-Unique: bRehh-PWPia-pmBo6oqoQQ-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 7 May
 2024 22:02:42 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Tue, 7 May 2024 22:02:42 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: 'Christian Brauner' <brauner@kernel.org>, Linus Torvalds
	<torvalds@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, "keescook@chromium.org"
	<keescook@chromium.org>, "axboe@kernel.dk" <axboe@kernel.dk>,
	"christian.koenig@amd.com" <christian.koenig@amd.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, "jack@suse.cz"
	<jack@suse.cz>, "laura@labbott.name" <laura@labbott.name>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"minhquangbui99@gmail.com" <minhquangbui99@gmail.com>,
	"sumit.semwal@linaro.org" <sumit.semwal@linaro.org>,
	"syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com"
	<syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com>,
	"syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>
Subject: RE: [PATCH] epoll: try to be a _bit_ better about file lifetimes
Thread-Topic: [PATCH] epoll: try to be a _bit_ better about file lifetimes
Thread-Index: AQHan5G+Cj1Mu87oOkmAjOj4WUTDELGMO/+w
Date: Tue, 7 May 2024 21:02:41 +0000
Message-ID: <052a735f433348b48a53b3d15183398a@AcuMS.aculab.com>
References: <202405031110.6F47982593@keescook>
 <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV>
 <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240504-wohngebiet-restwert-6c3c94fddbdd@brauner>
 <CAHk-=wj_Fu1FkMFrjivQ=MGkwkKXZBuh0f4BEhcZHD5WCvHesw@mail.gmail.com>
 <CAHk-=wirxPSQgRV1u7t4qS1t4ED7w7OeehdUSC-LYZXspqa49w@mail.gmail.com>
 <20240505-gelehnt-anfahren-8250b487da2c@brauner>
 <CAHk-=wgMzzfPwKc=8yBdXwSkxoZMZroTCiLZTYESYD3BC_7rhQ@mail.gmail.com>
 <20240506-injizieren-administration-f5900157566a@brauner>
In-Reply-To: <20240506-injizieren-administration-f5900157566a@brauner>
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

RnJvbTogQ2hyaXN0aWFuIEJyYXVuZXINCj4gU2VudDogMDYgTWF5IDIwMjQgMDk6NDUNCj4gDQo+
ID4gVGhlIGZhY3QgaXMsIGl0J3Mgbm90IGRtYS1idWYgdGhhdCBpcyB2aW9sYXRpbmcgYW55IHJ1
bGVzLiBJdCdzIGVwb2xsLg0KPiANCj4gSSBhZ3JlZSB0aGF0IGVwb2xsKCkgbm90IHRha2luZyBh
IHJlZmVyZW5jZSBvbiB0aGUgZmlsZSBpcyBhdCBsZWFzdA0KPiB1bmV4cGVjdGVkIGFuZCBjb250
cmFkaWN0cyB0aGUgdXN1YWwgY29kZSBwYXR0ZXJucyBmb3IgdGhlIHNha2Ugb2YNCj4gcGVyZm9y
bWFuY2UgYW5kIHRoYXQgaXQgdmVyeSBsaWtlbHkgaXMgdGhlIGNhc2UgdGhhdCBtb3N0IGNhbGxl
cnMgb2YNCj4gZl9vcC0+cG9sbCgpIGRvbid0IGtub3cgdGhpcy4NCj4gDQo+IE5vdGUsIEkgY2xl
YXJ5IHdyb3RlIHVwdGhyZWFkIHRoYXQgSSdtIG9rIHRvIGRvIGl0IGxpa2UgeW91IHN1Z2dlc3Rl
ZA0KPiBidXQgcmFpc2VkIHR3byBjb25jZXJucyBhKSB0aGVyZSdzIGN1cnJlbnRseSBvbmx5IG9u
ZSBpbnN0YW5jZSBvZg0KPiBwcm9sb25nZWQgQGZpbGUgbGlmZXRpbWUgaW4gZl9vcC0+cG9sbCgp
IGFmYWljdCBhbmQgYikgdGhhdCB0aGVyZSdzDQo+IHBvc3NpYmx5IGdvaW5nIHRvIGJlIHNvbWUg
cGVyZm9ybWFuY2UgaW1wYWN0IG9uIGVwb2xsKCkuDQo+IA0KPiBTbyBpdCdzIGF0IGxlYXN0IHdv
cnRoIGRpc2N1c3Npbmcgd2hhdCdzIG1vcmUgaW1wb3J0YW50IGJlY2F1c2UgZXBvbGwoKQ0KPiBp
cyB2ZXJ5IHdpZGVseSB1c2VkIGFuZCBpdCdzIG5vdCB0aGF0IHdlIGhhdmVuJ3QgZmF2b3JlZCBw
ZXJmb3JtYW5jZQ0KPiBiZWZvcmUuDQo+IA0KPiBCdXQgeW91J3ZlIGFscmVhZHkgc2FpZCB0aGF0
IHlvdSBhcmVuJ3QgY29uY2VybmVkIHdpdGggcGVyZm9ybWFuY2Ugb24NCj4gZXBvbGwoKSB1cHRo
cmVhZC4gU28gYWZhaWN0IHRoZW4gdGhlcmUncyByZWFsbHkgbm90IGEgbG90IG1vcmUgdG8NCj4g
ZGlzY3VzcyBvdGhlciB0aGFuIHRha2UgdGhlIHBhdGNoIGFuZCBzZWUgd2hldGhlciB3ZSBnZXQg
YW55IGNvbXBsYWludHMuDQoNClN1cmVseSB0aGVyZSBpc24ndCBhIHByb2JsZW0gd2l0aCBlcG9s
bCBob2xkaW5nIGEgcmVmZXJlbmNlIHRvIHRoZSBmaWxlDQpzdHJ1Y3R1cmUgLSBpdCBpc24ndCBy
ZWFsbHkgYW55IGRpZmZlcmVudCB0byBhIGR1cCgpLg0KDQonQWxsJyB0aGF0IG5lZWRzIHRvIGhh
cHBlbiBpcyB0aGF0IHRoZSAnbWFnaWMnIHRoYXQgbWFrZXMgZXBvbGwoKSByZW1vdmUNCmZpbGVz
IG9uIHRoZSBsYXN0IGZwdXQgaGFwcGVuIHdoZW4gdGhlIGNsb3NlIGlzIGRvbmUuDQpJJ20gc3Vy
ZSB0aGVyZSBhcmUgaG9ycmlkIGxvY2tpbmcgaXNzdWVzIGl0IHRoYXQgY29kZSAoc2VwYXJhdGUg
ZnJvbQ0KaXQgY2FsbGluZyAtPnBvbGwoKSBhZnRlciAtPnJlbGVhc2UoKSkgZWcgaWYgeW91IGNh
bGwgY2xvc2UoKSBjb25jdXJyZW50bHkNCndpdGggRVBPTExfQ1RMX0FERC4NCg0KSSdtIG5vdCBh
dCBhbGwgc3VyZSBpdCB3b3VsZCBoYXZlIG1hdHRlcmVkIGlmIGVwb2xsIGtlcHQgdGhlIGZpbGUg
b3Blbi4NCkJ1dCBpdCBjYW4ndCBkbyB0aGF0IGJlY2F1c2UgaXQgaXMgZG9jdW1lbnRlZCBub3Qg
dG8uDQpBcyB3ZWxsIGFzIHBvbGwvc2VsZWN0IGhvbGRpbmcgYSByZWZlcmVuY2UgdG8gYWxsIHRo
ZWlyIGZkIGZvciB0aGUgZHVyYXRpb24NCm9mIHRoZSBzeXN0ZW0gY2FsbCwgYSBzdWNjZXNzZnVs
IG1tYXAoKSBob2xkcyBhIHJlZmVyZW5jZSB1bnRpbCB0aGUgcGFnZXMNCmFyZSBhbGwgdW5tYXBw
ZWQgLSB1c3VhbGx5IGJ5IHByb2Nlc3MgZXhpdC4NCg0KV2UgKGRheWpvYikgaGF2ZSBjb2RlIHRo
YXQgdXNlcyBlcG9sbCgpIHRvIG1vbml0b3IgbGFyZ2UgbnVtYmVycyBvZiBVRFANCnNvY2tldHMu
IEkgd2FzIGRvaW5nIHNvbWUgdGVzdHMgKHRyeWluZyB0bykgcmVjZWl2ZSBSVFAgKGF1ZGlvKSBk
YXRhDQpjb25jdXJyZW50bHkgb24gMTAwMDAgc29ja2V0cyB3aXRoIHR5cGljYWxseSBvbmUgcGFj
a2V0IGV2ZXJ5IDIwbXMuDQpUaGVyZSBhcmUgMTAwMDAgYXNzb2NpYXRlZCBSQ1RQIHNvY2tldHMg
dGhhdCBhcmUgdXN1YWxseSBpZGxlLg0KQSBtb3JlIG5vcm1hbCBsaW1pdCB3b3VsZCBiZSAxMDAw
IFJUUCBzb2NrZXRzLg0KQWxsIHRoZSBkYXRhIG5lZWRzIHRvIGdvIGludG8gYSBzaW5nbGUgKG11
bHRpdGhyZWFkZWQpIHByb2Nlc3MuDQpKdXN0IGdldHRpbmcgYWxsIHRoZSBwYWNrZXRzIHF1ZXVl
ZCBvbiB0aGUgc29ja2V0cyB3YXMgbm9uLXRyaXZpYWwuDQplcG9sbCBpcyBhYm91dCB0aGUgb25s
eSB3YXkgdG8gYWN0dWFsbHkgcmVhZCB0aGUgZGF0YS4NCihUaGF0IG5lZWRlZCBtdWx0aXBsZSBl
cG9sbCBmZCBzbyBlYWNoIHRocmVhZCBjb3VsZCBwcm9jZXNzIGFsbA0KdGhlIGV2ZW50cyBmcm9t
IG9uZSBlcG9sbCBmZCB0aGVuIGxvb2sgZm9yIGFub3RoZXIgdW5wcm9jZXNzZWQgZmQuKQ0KDQoJ
RGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1v
dW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEz
OTczODYgKFdhbGVzKQ0K



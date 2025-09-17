Return-Path: <io-uring+bounces-9828-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 94D8FB8001E
	for <lists+io-uring@lfdr.de>; Wed, 17 Sep 2025 16:32:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 968283A515A
	for <lists+io-uring@lfdr.de>; Wed, 17 Sep 2025 14:28:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 467CD2D47F9;
	Wed, 17 Sep 2025 14:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=alibaba-inc.com header.i=@alibaba-inc.com header.b="hkdy3MvY"
X-Original-To: io-uring@vger.kernel.org
Received: from out0-204.mail.aliyun.com (out0-204.mail.aliyun.com [140.205.0.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6482D46A4
	for <io-uring@vger.kernel.org>; Wed, 17 Sep 2025 14:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.205.0.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758119301; cv=none; b=T8AAhXNPRptv3a6S29qORhqaSZaalPpc9R0UK4IKeStRWuI/1whpbvF4N2fA4jf0WB82CtvAXFu+qrv3J4cl3ozUz3l3O49F64EVlIjerA1UrM1I8woh8jfipBpV/M20bqH8LLWVv0/B7EEAB+P2gvV/jXp6YGl13300HTzP/g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758119301; c=relaxed/simple;
	bh=X/T5AB6W0jHSXJpHzWikw29ouW57j4h0HTqfFZPLnko=;
	h=Date:From:To:Cc:Message-ID:Subject:MIME-Version:References:
	 In-Reply-To:Content-Type; b=KEY7/bDpaNtAP4zhNIOhQwKKTwbX189aooy6W3DxWBjnBsA76oWIFi3j5zjgZa7/bUDmf5bXpkwO6+3IAHXMxoz/WVzwE6qdIcQ9eEGi5wYiEX23ni1Unwck2iO7FjjawZhVUERjKfBjFQa9JPHFUxH6MCR89VKNkHNquH84U4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=alibaba-inc.com; spf=pass smtp.mailfrom=alibaba-inc.com; dkim=pass (1024-bit key) header.d=alibaba-inc.com header.i=@alibaba-inc.com header.b=hkdy3MvY; arc=none smtp.client-ip=140.205.0.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=alibaba-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alibaba-inc.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=alibaba-inc.com; s=default;
	t=1758119295; h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type;
	bh=X/T5AB6W0jHSXJpHzWikw29ouW57j4h0HTqfFZPLnko=;
	b=hkdy3MvYxrnNJ+k6tfCMX6dEuDMRSgd5DzrWAiYcT4VCVFbAcNVp60Q/ueKMOpcW3uKuynD26z7EO7i0ZW7bR90FbZPmlbQImkfcjojcMhDAyPBKAeVbRypKf8gWW7xuTYPOloRAAZyzrYl6CGXw6NlWqn/3ObEQbCjI+wa2xhY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037071049;MF=chao.shi@alibaba-inc.com;NM=1;PH=DW;RN=3;SR=0;TI=W4_0.2.3_v5ForWebDing_2137C8B0_1758103023696_o7001c135n;
Received: from WS-web (chao.shi@alibaba-inc.com[W4_0.2.3_v5ForWebDing_2137C8B0_1758103023696_o7001c135n] cluster:ay29) at Wed, 17 Sep 2025 22:28:15 +0800
Date: Wed, 17 Sep 2025 22:28:15 +0800
From: "=?UTF-8?B?55+z6LaF?=" <chao.shi@alibaba-inc.com>
To: "David Wei" <dw@davidwei.uk>,
  "io-uring" <io-uring@vger.kernel.org>
Cc: "=?UTF-8?B?5bit5rC46Z2SKOW4reiogCk=?=" <yongqing.xyq@alibaba-inc.com>
Reply-To: "=?UTF-8?B?55+z6LaF?=" <chao.shi@alibaba-inc.com>
Message-ID: <4d8f2e3b-2e70-47e7-86f5-104ffb3d19a6.chao.shi@alibaba-inc.com>
Subject: =?UTF-8?B?5Zue5aSN77yaSG93IHRvIHVzZSBpb3VyaW5nIHpjcnggd2l0aCBOSUMgdGVhbWluZz8=?=
X-Mailer: [Alimail-Mailagent revision 49][W4_0.2.3][v5ForWebDing][Chrome]
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
x-aliyun-im-through: {"version":"v1.0"}
References: <efed6a43-6ba6-4093-adb8-d08e8e4d2352.chao.shi@alibaba-inc.com>,<a0782edd-0987-492d-90b1-547485276398@davidwei.uk>
x-aliyun-mail-creator: W4_0.2.3_v5ForWebDing_QvNTW96aWxsYS81LjAgKE1hY2ludG9zaDsgSW50ZWwgTWFjIE9TIFggMTBfMTVfNykgQXBwbGVXZWJLaXQvNTM3LjM2IChLSFRNTCwgbGlrZSBHZWNrbykgQ2hyb21lLzE0MC4wLjAuMCBTYWZhcmkvNTM3LjM2La
In-Reply-To: <a0782edd-0987-492d-90b1-547485276398@davidwei.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64

SGkgRGF2aWQsCgpUaGFua3MgZm9yIHlvdXIgcmVwbHkuCgpJIHRlc3RlZCB5b3VyIGFwcHJvYWNo
IChTT19JTkNPTUlOR19OQVBJX0lEIGFmdGVyIGNvbm5lY3Rpb24gZ2V0cyBhY2NlcHRlZCkgYW5k
IGl0IGJhc2ljYWxseSB3b3Jrcy4gIFRoZXJlIGlzIHN0aWxsIGxlZnQgYSBzdWJ0bGUgaXNzdWUs
IHRoYXQgdGhlIGNvbm5lY3Rpb24gbWF5IHNpbGVudGx5IG1pZ3JhdGUgZnJvbSBvbmUgTklDIHBv
cnQgdG8gYW5vdGhlci7CoCBJdCdzIE9LIGZvciBzaG9ydC1saXZlZCBjb25uZWN0aW9ucy4gIEZv
ciBsb25nLWxpdmVkIGNvbm5lY3Rpb25zLCBJIHRoaW5rIHdlIGhhdmUgdG8gcGVyaW9kaWNhbGx5
IGNhbGxzIGdldG9wdChTT19JTkNPTUlOR19OQVBJX0lEKSB0byBkZXRlY3Qgd2hldGhlciBvciBu
b3QgdGhlIGNvbm5lY3Rpb24gaXMgYXQgdGhlIGNvcnJlY3QgcG9ydC4gIEJ5IHRoZSB3YXksIGlz
IHRoZXJlIGEgZmxhZyBpbiBTUUUgdG8gaW5kaWNhdGUgd2hldGhlciB6ZXJvIGNvcHkgaXMgdXNl
ZD8gIAoKSSdtIG5vdCBhbiBleHBlcnQgb24gYm9uZGluZyBlaXRoZXIuwqAgSSBhc2tlZCBuZXR3
b3JrIG9wcyBndXkgKGNjJ2VkIGJ5IHRoaXMgbWFpbCkgYW5kwqBoZXJlIGFyZSBhbnN3ZXJzIHRv
IHlvdXIgcXVlc3Rpb25zLsKgCgo+PsKgQ2FuIGl0IGJlIGd1YXJhbnRlZWQgdGhhdMKgcGFja2V0
cyBiZWxvbmdpbmcgdG8gYSBzaW5nbGUgY29ubmVjdGlvbiAoYXMgZGVmaW5lZCBieSBpdHMgNS10
dXBsZSnCoGFsd2F5cyBnbyB0byB0aGUgc2FtZSBwb3J0PwpOby4gSW4gbW9zdCBjYXNlcywgcGFj
a2V0cyBvZiBhIHNpbmdsZSBjb25uZWN0aW9uIGRvIGdvIGludG8gdGhlIHNhbWUgcG9ydCwgYnV0
IGl0IGlzIG5vdCBndWFyYW50ZWVkLiBJbiBhIHJhcmUgY2FzZSwgd2hlcmUgc3dpdGNoZXMgYXJl
IGRvd24sIHRoZSBwYWNrZXRzIG1heSBtb3ZlIHRvIGFub3RoZXIgcG9ydC4KClRoaW5rIG9mIHRo
aXMgZXhhbXBsZToKCiBldGgwIC0tLS0gc3cxYSAtLS0gc3cyYSAtLS0gc3czYSAtLS0gZXRoMApo
b3N0MSAgICAgICAgICAgIFggICAgICAgIFggICAgICAgICAgIGhvc3QyCiBldGgxIC0tLS0gc3cx
YiAtLS0gc3cyYiAtLS0gc3czYiAtLS0gZXRoMQoKKFNlZSBodHRwczovL2dpc3QuZ2l0aHViLmNv
bS9zdGVwaW50by9jZDIzODAzZTIxZGExZDAxMDBlOGIzOTQxMzA4Y2E4ZiBpbiBjYXNlIHRoZSBh
Ym92ZSBBU0NJSSBkaWFncmFtIGlzIG5vdCByZW5kZXJlZCBjb3JyZWN0bHkuKQoKZXRoMCBhbmQg
ZXRoMSBhcmUgTklDIHBvcnRzIG9mIGhvc3RzLiAgc3cxYSwgMWIsIDNhIGFuZCAzYyBhcmUgVG9S
IHN3aXRjaGVzLiAgc3cyYSBhbmQgMmIgYXJlIGFnZ3JlZ2F0aW9uIHN3aXRjaGVzLiAgSWYgYW55
IGNhYmxlcyAoZm9yIGV4YW1wbGUgaG9zdDEncyBldGgwIC0tLSBzdzFhLCBzdzFhIC0tLSBzdzJh
KSBhcmUgYnJva2VuLCB0aGUgVENQIGNvbm5lY3Rpb24ga2VlcHMgZ29vZCwgYnV0IG1heSBzd2l0
Y2ggdG8gYW5vdGhlciBwb3J0IGF0IGhvc3QyIHNpZGUuCgo+PsKgQ2FuIHRoaXMgYmVoYXZpb3Vy
IGJlIGRpc2FibGVkIHN1Y2ggdGhhdCB0aGXCoHNhbWUgNS10dXBsZSBpcyBhbHdheXMgaGFzaGVk
IHRvIHRoZSBzYW1lIHBvcnQsIGFuZCB0aGVuIGhhc2hlZCB0byB0aGXCoHNhbWUgcnggcXVldWU/
Ck5vLsKgIFRoaXMgaXMgYSBiZWhhdmlvciBvbiBzd2l0Y2ggYW5kIGdvb2QgZm9yIGZhaWx1cmUg
dG9sZXJhbmNlIG9mIHN3aXRjaGVzLiAgU2VlIGFib3ZlIGV4YW1wbGUuCgotLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0K5Y+R
5Lu25Lq677yaRGF2aWQgV2VpIDxkd0BkYXZpZHdlaS51az4K5Y+R6YCB5pe26Ze077yaMjAyNeW5
tDnmnIgxNuaXpSjlkajkuowpIDA0OjI4CuaUtuS7tuS6uu+8miLnn7PotoUiPGNoYW8uc2hpQGFs
aWJhYmEtaW5jLmNvbT47ICJpby11cmluZyI8aW8tdXJpbmdAdmdlci5rZXJuZWwub3JnPgrkuLvj
gIDpopjvvJpSZTogSG93IHRvIHVzZSBpb3VyaW5nIHpjcnggd2l0aCBOSUMgdGVhbWluZz8KCgpP
biAyMDI1LTA5LTEwIDIwOjQ2LCBDaGFvIFNoaSB3cm90ZToKPiBIZWxsbywKPiAKPiBJJ20gcnVu
bmluZyBpbnRvIGEgaXNzdWUgd2hlbiB1c2luZyBpb3VyaW5nIHpjcnggd2l0aCBOSUMgdGVhbWlu
Zy4KPiBJJ20gZ2xhZCBpZiBhbnlvbmUgY2FuIGhlbHAuCj4gCj4gSSB3cm90ZSBhIHByb2dyYW0g
dGhhdCB1c2VzIGlvdXJpbmctemNyeCB0byByZWNlaXZlIFRDUCBwYWNrZXRzLiBUaGUKPiBwcm9n
cmFtIHdvcmtzIHdlbGwgd2hlbiBvbmx5IGEgc2luZ2xlIG5ldCBpbnRlcmZhY2UgaXMgdXAgKGJ5
IG1hbnVhbGx5Cj4gYGlmY29uZmlnIGRvd25gIHRoZSBvdGhlciBpbnRlcmZhY2UpLiBUaGUgc2Vy
dmVyIHVzZXMgQnJvYWRjb20gUDIxMDBHCj4gRHVhbC1Qb3J0IDEwMEcgTklDLCBhbmQgaXMgY29u
ZmlndXJlZCBsaW5rIGFnZ3JlZ2F0aW9uIHdpdGggdGVhbWluZy4KPiBUZWFtaW5nIHdvcmtzIGF0
IEwyLCBpLmUuIFRDUCBwYWNrZXRzIChvZiBzaW5nbGUgb3IgbXVsdGlwbGUKPiBjb25uZWN0aW9u
cykgbWF5IGNvbWUgZnJvbSBhcmJpdHJhcnkgcG9ydC4gSSdtIHVzaW5nIGtlcm5lbCA2LjE2LjQu
CgpIaSBDaGFvLiBJJ20gbm90IGZhbWlsaWFyIHdpdGggTklDIGJvbmRpbmcuIENhbiBpdCBiZSBn
dWFyYW50ZWVkIHRoYXQKcGFja2V0cyBiZWxvbmdpbmcgdG8gYSBzaW5nbGUgY29ubmVjdGlvbiAo
YXMgZGVmaW5lZCBieSBpdHMgNS10dXBsZSkKYWx3YXlzIGdvIHRvIHRoZSBzYW1lIHBvcnQ/Cgo+
IAo+IFRvIGlsbHVzdHJhdGUgdGhpcyBpc3N1ZSwgY29uc2lkZXIgdGhlIGJlbG93aW5nIGV4YW1w
bGU6Cj4gCj4gVGhlIHNlcnZlciBwcm9ncmFtIHJlZ2lzdGVyZWQgKip0d28qKiB6Y3J4IElGUXMg
KDIgZGF0YSBidWZmZXJzIGFuZCAyCj4gcmVmaWxsIHJpbmdzKSwgb25lIGZvciBlYWNoIE5JQyBw
b3J0LiBJdCBhY2NlcHRzIGFuIGluY29taW5nIFRDUAo+IGNvbm5lY3Rpb24uwqAgVGhlIHNlcnZl
ciByZWNlaXZlcyBwYWNrZXRzIGZyb20gdGhhdCBjb25uZWN0aW9uLCBieQo+IHN1Ym1pdGluZyBS
RUNWX1pDIHNxZXMuIEhlcmUgY29tZXMgdGhlIHByb2JsZW0uwqAgVGhlIGZpZWxkCj4gYHpjcnhf
aWZxX2lkeGAgb2Ygc3FlIGlzIHVzZWQgdG8gc3BlY2lmeSB3aGljaCBJRlEgd2lsbCBiZSB1c2Vk
Lgo+IEhvd2V2ZXIsIHdoaWNoIElGUSB0byB1c2UgaXMgbm90IGtub3duIGJlZm9yZSBwYWNrZXRz
IGFyZSByZWNlaXZlZC4gSWYKPiBgemNyeF9pZnFfaWR4YCBzcGVjaWZpZXMgdGhlIHdyb25nIElG
USwgdGhlIGtlcm5lbCB3aWxsIGZhbGxiYWNrIHRvCj4gY29weWluZy7CoCBJbiBhIHJhcmUgYnV0
IHBvc3NpYmxlIHNpdHVhdGlvbiwgcGFja2V0cyBvZiBhIHNpbmdsZSBUQ1AKPiBjb25uZWN0aW9u
IG1heSByZWNlaXZlZCBmcm9tIGJvdGggcG9ydHMuCgpIb3cgY2FuIHRoaXMgYmUgcG9zc2libGU/
IENhbiB0aGlzIGJlaGF2aW91ciBiZSBkaXNhYmxlZCBzdWNoIHRoYXQgdGhlCnNhbWUgNS10dXBs
ZSBpcyBhbHdheXMgaGFzaGVkIHRvIHRoZSBzYW1lIHBvcnQsIGFuZCB0aGVuIGhhc2hlZCB0byB0
aGUKc2FtZSByeCBxdWV1ZT8KClRoaXMgc291bmRzIHNpbWlsYXIgdG8gYSBzaW5nbGUgTklDIGJ1
dCBtdWx0aXBsZSBpZnFzLCBvbmUgcGVyIHJ4IHF1ZXVlLAppbiBhbiBSU1MgY29udHh0LiBJIHVz
ZSBTT19JTkNPTUlOR19OQVBJX0lEIGF0IGNvbm5lY3Rpb24gYWNjZXB0IHRpbWUgdG8KZGV0ZXJt
aW5lIHdoaWNoIGlmcSB0byBwcm9jZXNzIHRoZSBzb2NrZXQgb24gdG8gYXZvaWQgY29weSBmYWxs
YmFjay4KCj4gCj4gSSdtIGxvb2tpbmcgZm9yd2FyZCBpZiBhbnlvbmUgY2FuIGhlbHAuwqAgSSdt
IG5ldyBoZXJlLCBzbyBjb3JyZWN0IG1lCj4gaWYgSSBhbSB3cm9uZy4KCgo=


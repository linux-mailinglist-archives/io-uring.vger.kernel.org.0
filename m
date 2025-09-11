Return-Path: <io-uring+bounces-9728-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 86FECB52752
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 05:47:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF41F188C886
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 03:47:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35E81329F03;
	Thu, 11 Sep 2025 03:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=alibaba-inc.com header.i=@alibaba-inc.com header.b="rQ616qH1"
X-Original-To: io-uring@vger.kernel.org
Received: from out0-201.mail.aliyun.com (out0-201.mail.aliyun.com [140.205.0.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2702C329F20
	for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 03:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.205.0.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757562424; cv=none; b=seJ4LI+SSm8rI3PXHLSujR25kEMcZ2R/biR9+DG3zKtEJOrsKhtX0IeWloJAsAzo0lZIMnt1tMqUV5V8XODImb3Re9Yg9QiiuwgVbDqFg/nDdJr3Ril6kOQQiyEef9WlTMzZjl1T3/hSn9cv5RtARQdqgl70bjommZcscGG9x8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757562424; c=relaxed/simple;
	bh=LJTFZxmwIZJ0tlJcKotfjQqDBupr6dQUCNnq9iCx5xg=;
	h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type; b=XmM45C0LwqZbTgBYmwv7j8CN5yOBswYMziJkJ5ISAzv7Qa+MW2SzOLW5+xyIrXiLGC76VLyzUXHP64U6QkCvRljepizgAcjEUhG/zO51CpngEcWySxps0rPNVf2CjSCHtf/ONPorBoDIsBdQBegGly5oylP33oT0oemUwJnZMe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=alibaba-inc.com; spf=pass smtp.mailfrom=alibaba-inc.com; dkim=pass (1024-bit key) header.d=alibaba-inc.com header.i=@alibaba-inc.com header.b=rQ616qH1; arc=none smtp.client-ip=140.205.0.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=alibaba-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alibaba-inc.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=alibaba-inc.com; s=default;
	t=1757562418; h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type;
	bh=LJTFZxmwIZJ0tlJcKotfjQqDBupr6dQUCNnq9iCx5xg=;
	b=rQ616qH1D9XhCew0n0AcEqlFy+WkPEhGRVIHm6ZNQHYRJDqz/YFSGrEux1DbgQUQHO5ek/MsXxo6N78TZHUhIhmIAokycrqkK5GeRjCdWyT3NRWrPsNxs8NAbCjI2+3BJfkL3R6lUmXgxLamYTZh7CS0Y60C7xNZ2S0gARjSvC0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033065129056;MF=chao.shi@alibaba-inc.com;NM=1;PH=DW;RN=1;SR=0;TI=W4_0.2.3_v5ForWebDing_212DC53C_1757559841811_o7001c199;
Received: from WS-web (chao.shi@alibaba-inc.com[W4_0.2.3_v5ForWebDing_212DC53C_1757559841811_o7001c199] cluster:ay29) at Thu, 11 Sep 2025 11:46:58 +0800
Date: Thu, 11 Sep 2025 11:46:58 +0800
From: "Chao Shi" <chao.shi@alibaba-inc.com>
To: "io-uring" <io-uring@vger.kernel.org>
Reply-To: "Chao Shi" <chao.shi@alibaba-inc.com>
Message-ID: <efed6a43-6ba6-4093-adb8-d08e8e4d2352.chao.shi@alibaba-inc.com>
Subject: =?UTF-8?B?SG93IHRvIHVzZSBpb3VyaW5nIHpjcnggd2l0aCBOSUMgdGVhbWluZz8=?=
X-Mailer: [Alimail-Mailagent revision 976][W4_0.2.3][v5ForWebDing][Chrome]
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
x-aliyun-im-through: {"version":"v1.0"}
x-aliyun-mail-creator: W4_0.2.3_v5ForWebDing_QvNTW96aWxsYS81LjAgKE1hY2ludG9zaDsgSW50ZWwgTWFjIE9TIFggMTBfMTVfNykgQXBwbGVXZWJLaXQvNTM3LjM2IChLSFRNTCwgbGlrZSBHZWNrbykgQ2hyb21lLzEzOS4wLjAuMCBTYWZhcmkvNTM3LjM2La
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64

SGVsbG8sCgpJJ20gcnVubmluZyBpbnRvIGEgaXNzdWUgd2hlbiB1c2luZyBpb3VyaW5nIHpjcngg
d2l0aCBOSUMgdGVhbWluZy4gIEknbSBnbGFkIGlmIGFueW9uZSBjYW4gaGVscC4KCkkgd3JvdGUg
YSBwcm9ncmFtIHRoYXQgdXNlcyBpb3VyaW5nLXpjcnggdG8gcmVjZWl2ZSBUQ1AgcGFja2V0cy7C
oFRoZSBwcm9ncmFtIHdvcmtzIHdlbGwgd2hlbiBvbmx5IGEgc2luZ2xlIG5ldCBpbnRlcmZhY2Ug
aXMgdXAgKGJ5IG1hbnVhbGx5IGBpZmNvbmZpZyBkb3duYCB0aGUgb3RoZXIgaW50ZXJmYWNlKS4g
VGhlIHNlcnZlciB1c2VzIEJyb2FkY29tIFAyMTAwRyBEdWFsLVBvcnQgMTAwRyBOSUMsIGFuZCBp
cyBjb25maWd1cmVkIGxpbmsgYWdncmVnYXRpb24gd2l0aCB0ZWFtaW5nLiAgVGVhbWluZyB3b3Jr
cyBhdCBMMiwgaS5lLiBUQ1AgcGFja2V0cyAob2Ygc2luZ2xlIG9yIG11bHRpcGxlIGNvbm5lY3Rp
b25zKSBtYXkgY29tZSBmcm9tIGFyYml0cmFyeSBwb3J0LiBJJ20gdXNpbmcga2VybmVsIDYuMTYu
NC4KClRvIGlsbHVzdHJhdGUgdGhpcyBpc3N1ZSwgY29uc2lkZXIgdGhlIGJlbG93aW5nIGV4YW1w
bGU6CgpUaGUgc2VydmVyIHByb2dyYW0gcmVnaXN0ZXJlZCAqKnR3byoqIHpjcnggSUZRcyAoMiBk
YXRhIGJ1ZmZlcnMgYW5kIDIgcmVmaWxsIHJpbmdzKSwgb25lIGZvciBlYWNoIE5JQyBwb3J0LiBJ
dCBhY2NlcHRzIGFuIGluY29taW5nIFRDUCBjb25uZWN0aW9uLiAgVGhlIHNlcnZlciByZWNlaXZl
cyBwYWNrZXRzIGZyb20gdGhhdCBjb25uZWN0aW9uLCBieSBzdWJtaXRpbmcgUkVDVl9aQyBzcWVz
LiBIZXJlIGNvbWVzIHRoZSBwcm9ibGVtLiAgVGhlIGZpZWxkIGB6Y3J4X2lmcV9pZHhgIG9mIHNx
ZSBpcyB1c2VkIHRvIHNwZWNpZnkgd2hpY2ggSUZRIHdpbGwgYmUgdXNlZC4gIEhvd2V2ZXIsIHdo
aWNoIElGUSB0byB1c2UgaXMgbm90IGtub3duIGJlZm9yZSBwYWNrZXRzIGFyZSByZWNlaXZlZC4g
SWYgYHpjcnhfaWZxX2lkeGAgc3BlY2lmaWVzIHRoZSB3cm9uZyBJRlEsIHRoZSBrZXJuZWwgd2ls
bCBmYWxsYmFjayB0byBjb3B5aW5nLiAgSW4gYSByYXJlIGJ1dCBwb3NzaWJsZSBzaXR1YXRpb24s
IHBhY2tldHMgb2YgYSBzaW5nbGUgVENQIGNvbm5lY3Rpb24gbWF5IHJlY2VpdmVkIGZyb20gYm90
aCBwb3J0cy4KCkknbSBsb29raW5nIGZvcndhcmQgaWYgYW55b25lIGNhbiBoZWxwLiAgSSdtIG5l
dyBoZXJlLCBzbyBjb3JyZWN0IG1lIGlmIEkgYW0gd3JvbmcuCg==


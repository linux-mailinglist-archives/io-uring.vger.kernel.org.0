Return-Path: <io-uring+bounces-13018-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6GdrHJq12GnnhAgAu9opvQ
	(envelope-from <io-uring+bounces-13018-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 10 Apr 2026 10:32:26 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F6BB3D4201
	for <lists+io-uring@lfdr.de>; Fri, 10 Apr 2026 10:32:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7EAAB300638A
	for <lists+io-uring@lfdr.de>; Fri, 10 Apr 2026 08:24:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97C5D37AA99;
	Fri, 10 Apr 2026 08:24:30 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [52.229.168.213])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C87202F4A14;
	Fri, 10 Apr 2026 08:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.229.168.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775809470; cv=none; b=hEShr6eZMCYfI01lUujPTQzjaTijVcnupiic3394C8a5MwOLf6jFjvsi3hPeDvk3FNYG+GY+v2Q7EbVzLS1dS6Ij68PapyDZ8SOd4B19kL9087s6a4kdx9nlV6YaiMAS5//FO3IAXQ616gf6swMbE5fm2eEwLU+Xha5O4Mru//I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775809470; c=relaxed/simple;
	bh=W0rMeT/mLNXuqpYvxDYVysBJCZRXRDnT1tiUZoTFNsA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=L8sDPj6ECh54p4AI8B2UA3BaDbBvWurbEDvVAEGveVnkh3a+cQhTrakBHYBwWvQ+EXrHU/C2tImdScVBaCSu1iJFM13L58mO7VX20VJCOe0ckiT8ckdpdPnljjztCfG5zP1NKLg97iM76CWHMWSva5l5Rwxl9JUYxmsFUWqlxJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=52.229.168.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.162.196.130])
	by mtasvr (Coremail) with SMTP id _____wC36ACus9hp+AQ_AA--.475S3;
	Fri, 10 Apr 2026 16:24:15 +0800 (CST)
Received: from l1zao$zju.edu.cn ( [10.162.196.130] ) by
 ajax-webmail-mail-app4 (Coremail) ; Fri, 10 Apr 2026 16:24:14 +0800
 (GMT+08:00)
Date: Fri, 10 Apr 2026 16:24:14 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: =?UTF-8?B?56ug5oC/6LS6?= <l1zao@zju.edu.cn>
To: "Jens Axboe" <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] io_uring: fix null-ptr-deref in io_uring_poll
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2024.3-cmXT6 build
 20250620(94335109) Copyright (c) 2002-2026 www.mailtech.cn zju.edu.cn
In-Reply-To: <37b606c2-8b76-4034-9a3e-a088ec4cf546@kernel.dk>
References: <20260409145525.36194-1-l1zao@zju.edu.cn>
 <aae302b8-3f67-4331-8cf9-2784dcf25a91@kernel.dk>
 <37b606c2-8b76-4034-9a3e-a088ec4cf546@kernel.dk>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <5b869707.c56b.19d767de04c.Coremail.l1zao@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:zi_KCgDnyzSus9hp2jxVAA--.33009W
X-CM-SenderInfo: qrsujiasvsq6lmxovvfxof0/1tbiAgsQDmnWr4xJ2gABsZ
X-CM-DELIVERINFO: =?B?87t+zAXKKxbFmtjJiESix3B1w3vHnlJbTzpjBiDNiSV1FaPW3jUfstcnhS8dxCjcBC
	0yFKH3ygm4bEgXo4P+SCNlVx3Gg0FoLlo9TjMCSGQOqLE+5PnC6mVeDmFJCBl5frDQl/bs
	BWpDmERtS7DpxIp7t9QMx+WG7B5u+LmHyn6WlRABRpQv7wDsPJ0ANGvsp1+nxg==
X-Coremail-Antispam: 1Uk129KBj93XoW7AryUArW3CFy8Kr4fXrWDtrc_yoW8WryDpF
	yUKa4j9Fykurs7A3Wqqw45uasFk3ykArZrXry8C34ayFnFvFnakr4jgry5uF1Utr17C34U
	XF40q39Yvw4UA3XCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPlb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Cr1j6rxdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7xvr2IYc2Ij64
	vIr40E4x8a64kEw24lFcxC0VAYjxAxZF0Ew4CEw7xC0wACY4xI67k04243AVC20s07MxAI
	w28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr
	4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUXVWUAwCIc40Y0x0EwIxG
	rwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8Jw
	CI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2
	z280aVCY1x0267AKxVWUJVW8JwCE64xvF2IEb7IF0Fy7YxBIdaVFxhVjvjDU0xZFpf9x07
	jeXd8UUUUU=
X-Spamd-Result: default: False [0.64 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13018-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[zju.edu.cn];
	FORGED_SENDER_MAILLIST(0.00)[];
	HAS_X_PRIO_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[l1zao@zju.edu.cn,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	TAGGED_RCPT(0.00)[io-uring];
	R_DKIM_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:email]
X-Rspamd-Queue-Id: 1F6BB3D4201
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

SSByYW4gaXQgb24gbGludXggdjYuMTguCgpBbnl3YXksIHRoYW5rcyBmb3IgcmV2aWV3aW5nIHRo
ZSBwYXRjaC4KCkJlc3QgcmVnYXJkcywKSGFvY2hlbmcgWXUKCj4gCj4gT24gNC85LzI2IDk6Mjgg
QU0sIEplbnMgQXhib2Ugd3JvdGU6Cj4gPiBPbiA0LzkvMjYgODo1NSBBTSwgbDF6YW9Aemp1LmVk
dS5jbiB3cm90ZToKPiA+PiBGcm9tOiBIYW9jaGVuZyBZdSA8bDF6YW9Aemp1LmVkdS5jbj4KPiA+
Pgo+ID4+IEEgZ2VuZXJhbCBwcm90ZWN0aW9uIGZhdWx0IGluIGlvX3VyaW5nX3BvbGwgaXMgcmVw
b3J0ZWQgYnkgYQo+ID4+IG1vZGlmaWVkIFN5emthbGxlci1iYXNlZCBrZXJuZWwgZnV6emluZyB0
b29sIHdlIGRldmVsb3BlZC4gVGhlCj4gPj4gY3Jhc2ggb2NjdXJzIGR1ZSB0byBLQVNBTjogbnVs
bC1wdHItZGVyZWYuCj4gPj4KPiA+PiBUaGlzIGlzc3VlIGlzIGxpa2VseSBjYXVzZWQgYnkgYSBy
YWNlIGNvbmRpdGlvbiBiZXR3ZWVuIAo+ID4+IGBpb191cmluZ19yZWdpc3RlcmAgYW5kIGBwb2xs
YC4gU3BlY2lmaWNhbGx5LCBpbiAKPiA+PiBpb191cmluZy9yZWdpc3Rlci5jL2lvX3JlZ2lzdGVy
X3Jlc2l6ZV9yaW5ncygpLCBjdHgtPnJpbmdzIGlzIAo+ID4+IHNldCB0byBOVUxMLiBBbHRob3Vn
aCB0aGlzIHN0ZXAgaXMgcHJvdGVjdGVkIGJ5IGEgbXV0ZXggbG9jayAKPiA+PiBhbmQgYSBzcGlu
IGxvY2ssIGlvX3VyaW5nL2lvX3VyaW5nLmMvaW9fdXJpbmdfcG9sbCgpIGNhbGxzIAo+ID4+IGlv
X3NxcmluZ19mdWxsIGFuZCBfX2lvX2NxcmluZ19ldmVudHNfdXNlciB3aXRob3V0IGhvbGRpbmcg
dGhlIAo+ID4+IGxvY2ssIGluIHdoaWNoIGN0eC0+cmluZ3MgaXMgYWNjZXNzZWQuCj4gPj4KPiA+
PiBUbyBmaXggdGhpcyB2dWxuZXJhYmlsaXR5LCBJIG1vdmVkIHRoZSB0d28gZnVuY3Rpb24gY2Fs
bHMgaW4KPiA+PiBpb191cmluZ19wb2xsKCkgdGhhdCBtaWdodCBhY2Nlc3MgY3R4LT5yaW5ncyB1
bmRlciB0aGUgcHJvdGVjdGlvbgo+ID4+IG9mIHNwaW5fbG9jaygmY3R4LT5jb21wbGV0aW9uX2xv
Y2spLgo+ID4gCj4gPiBGaXhlZCBhIG1vbnRoIGFnbywgd2hhdCB0cmVlIGFyZSB5b3UgcnVubmlu
Zz8KPiA+IAo+ID4gIGNvbW1pdCA5NjE4OTA4MDI2NWU2YmI1ZGRlM2E0YWZiYWY5NDdhZjQ5M2Uz
ZjgyCj4gPiBBdXRob3I6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4KPiA+IERhdGU6ICAg
TW9uIE1hciA5IDE0OjIxOjM3IDIwMjYgLTA2MDAKPiA+IAo+ID4gICAgIGlvX3VyaW5nOiBlbnN1
cmUgY3R4LT5yaW5ncyBpcyBzdGFibGUgZm9yIHRhc2sgd29yayBmbGFncyBtYW5pcHVsYXRpb24K
PiAKPiBBY3R1YWxseSB0aGUgcG9sbCBwYXJ0IGlzIHRoaXMgb25lOgo+IAo+IGNvbW1pdCA2MWEx
MWNmNDgxMjcyNmFjZWFlZTE3Yzk2NDMyZTFjMDhmNmVkNmNiCj4gQXV0aG9yOiBKZW5zIEF4Ym9l
IDxheGJvZUBrZXJuZWwuZGs+Cj4gRGF0ZTogICBUdWUgTWFyIDMxIDA3OjA3OjQ3IDIwMjYgLTA2
MDAKPiAKPiAgICAgaW9fdXJpbmc6IHByb3RlY3QgcmVtYWluaW5nIGxvY2tsZXNzIGN0eC0+cmlu
Z3MgYWNjZXNzZXMgd2l0aCBSQ1UKPiAKPiB3aGljaCBpcyBhbHNvIHVwc3RyZWFtLgo+IAo+IC0t
IAo+IEplbnMgQXhib2UK



Return-Path: <io-uring+bounces-12496-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MIf7KU07pGlnawUAu9opvQ
	(envelope-from <io-uring+bounces-12496-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 01 Mar 2026 14:12:45 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 686241CFCF3
	for <lists+io-uring@lfdr.de>; Sun, 01 Mar 2026 14:12:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C407D3015844
	for <lists+io-uring@lfdr.de>; Sun,  1 Mar 2026 13:12:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A19932470F;
	Sun,  1 Mar 2026 13:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="WqDDl/JT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81EF324B23
	for <io-uring@vger.kernel.org>; Sun,  1 Mar 2026 13:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772370761; cv=none; b=n2fMUzLuppAPeK3qrXm/YHCp/rIWTlJ+9wjwE8go6dQzyL5Tnh2/MU45Zl3Y0p+vq8u1R8LE9qxZ6dQbo+TEELNcTmEcAvJhQDkE7+aVbII5maC5qRZOo/1n5fWSOWzl2p3tMG9iBaYn+1Gq3HfEPaia47ko8krybTdJZKD7Qkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772370761; c=relaxed/simple;
	bh=+KSNJ0Z158ochU2WYHGJfd+lrKFTM9Qpzy+3P8pJDLM=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=Mv2IQECY2hczUNIKDs98DOi6oyWfMwSAcLpzDgJivT77ktgoujsayJQSHYHLYu813w/xkY/RAxqj7iA2Y3yNAfIcnsvS11lzKj4NjcDdF4hwwGkOKJ21cKqad3XVklRTI1Xtw2KxB7UfxzEs5GsvJIytCEyZmlW80DDuTfxE4lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=WqDDl/JT; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7d4cb7e10efso4361352a34.0
        for <io-uring@vger.kernel.org>; Sun, 01 Mar 2026 05:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772370757; x=1772975557; darn=vger.kernel.org;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YVBcEfgQbbQ5ttlrS6xsIbgPyhOo8Qm45et5gOa7pcQ=;
        b=WqDDl/JTVmfnqkdt+0Iwp9fKqzmpHsxjuewGY/fBNYnUGWjL9ZjnZM+PWR6PnqcmsW
         lhvfAUtw16ul1g4qP+na/QlqYcflsJO4sGG5HQrs85JvSHRs9S04Hpr4iHuXTnflMTeS
         GE7WPMhauYlZbqZUZV/vGeT79NnpN4CZjkzZlW9FhqQf+y6FKA7hAvS5y3jBwwPz1Ga8
         I3sL2Kw5ASCqlwGPrLvzmv3uLUC/f4X8Aixfb0vV2dduCc/TatiSW3y/AEeJPy4KcMi2
         WCPM7Blx38KhCpQYovJc9kNCe5GmOZcv3orGsjMeR0hXOnWEaNpg4Etzg7FvTzrm9Fao
         9h7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772370757; x=1772975557;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YVBcEfgQbbQ5ttlrS6xsIbgPyhOo8Qm45et5gOa7pcQ=;
        b=f7K4KDAZQ4+ceJf7DM6SnDWB+t4EXVaG/SNMxYRl2Spk2rTWGz9joEYErIS8CT91dW
         zLIV7NzNLoHy2NsCz6ETo3On1jldd61ZNP0I2Ubg3a0LOdSnM/yKY0+GkMO1SkXIzkwp
         e6YQRYxnSbCDYsW/8XJg1t/nzqBf4vtyFq+yxd2olHGbruh2FziQmfqx+oliE099ATR/
         LekigkM95vV0JNfKYaw8seyIFL93YpssIpQfY2tBkzVmtwdDquc/Xf2UY0FzPj2tqvhA
         P3B+hpnASRo3wOaK2UXMrDgpGaFVB7jp7Imeu0wP3437FqTpOFiX1aODO1CeUZ7hbhcj
         hDQg==
X-Forwarded-Encrypted: i=1; AJvYcCXsI4RqdPzNOfmQQ7p/QP97vveuCTNZq38/n/ruPBeGNbVDwHmKzCyKYiX8D8WRM/EJ3Ys+3ZkfpQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzfzFtMZwLtnq1CTMFrQ4uETz/82lJKmdJZPKo7A1s/bEZxW2CZ
	qXohxjC9U8aUszO9Z1h22XusLq3SZ7dYAV2x+A4mxyLBerIBW7IIhIfu19hpEv8RLuc=
X-Gm-Gg: ATEYQzytje1JXDwDDVVmb5uPHITZ0Qz0U0abOQtX4OiK+5uI4Bd8G3MjhE2PMtPjbGk
	SZFNQEoPsGbEWM91KSTXP54VCd/Qp3rgNNC1QJhfEQ6NCvv85wyCjb5ZzLErUS3lqFkDUtZP1NN
	q4tNQpcscePk0xVUxmjXTKZZqQYw76ExgYV3nkQm9aYnqhDJIinugK+tWoqonkh+MPew5jitz2i
	R3yfiNQUpLk7VRaGxVWpMDDRhSLWFp4lNTaQOEdZO5TX3/DDndyr1iwIp91Bu/yrb0fMKr3K7EG
	ZIwaNjb6t7/6W6s6UAA88z6jFIed0ZikgXq64/LYfF+JJXxe9OT9VyXCsga/vNzo5WKN1cFrXcA
	gmduZ61IS28Fh61OCVvudtMe/NEiVHXQTWWVjTtZ5NCfbqQ2TU7aSKauzCRLlPEjLvh5vO1NB64
	JG7pnmS+tb+FgqAbPuv7Peam0ms2C5sKKTpl7Ka4fsqMhrgKEBftIQZYNozMy2RLY5j9zu8xeB9
	4Zx1C4FGQ==
X-Received: by 2002:a05:6830:81cb:b0:7cf:da7d:607c with SMTP id 46e09a7af769-7d591bda652mr5429586a34.20.1772370756937;
        Sun, 01 Mar 2026 05:12:36 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d5866541e5sm8646979a34.20.2026.03.01.05.12.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2026 05:12:35 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------UdsguNf0sUs20yNVjqVH6ax5"
Message-ID: <b83dc35f-37aa-4b2c-9ef2-aa189ded8448@kernel.dk>
Date: Sun, 1 Mar 2026 06:12:34 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: FAILED: Patch "io_uring/cmd_net: fix too strict requirement on
 ioctl" failed to apply to 6.12-stable tree
To: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org, ast@fiberby.net
Cc: Gabriel Krisman Bertazi <krisman@suse.de>, io-uring@vger.kernel.org
References: <20260301012914.1686902-1-sashal@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260301012914.1686902-1-sashal@kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.56 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain,text/x-patch];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12496-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+,1:+,2:+];
	HAS_ATTACHMENT(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.de:email,kernel.dk:mid,kernel.dk:email]
X-Rspamd-Queue-Id: 686241CFCF3
X-Rspamd-Action: no action

This is a multi-part message in MIME format.
--------------UdsguNf0sUs20yNVjqVH6ax5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/28/26 6:29 PM, Sasha Levin wrote:
> The patch below does not apply to the 6.12-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here's a backport of this one.

-- 
Jens Axboe

--------------UdsguNf0sUs20yNVjqVH6ax5
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-cmd_net-fix-too-strict-requirement-on-ioctl.patch"
Content-Disposition: attachment;
 filename*0="0001-io_uring-cmd_net-fix-too-strict-requirement-on-ioctl.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSAyYjc2NDJjMGMxODM1NGNhYzRiZjAxODVjODcwYmYxZmM1Mzc0ZDk3IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/QXNiaj1DMz1COHJuPTIwU2xvdGg9
MjBUPUMzPUI4bm5lc2VuPz0gPGFzdEBmaWJlcmJ5Lm5ldD4KRGF0ZTogTW9uLCAxNiBGZWIg
MjAyNiAxMDoyNzoxOCArMDAwMApTdWJqZWN0OiBbUEFUQ0hdIGlvX3VyaW5nL2NtZF9uZXQ6
IGZpeCB0b28gc3RyaWN0IHJlcXVpcmVtZW50IG9uIGlvY3RsCk1JTUUtVmVyc2lvbjogMS4w
CkNvbnRlbnQtVHlwZTogdGV4dC9wbGFpbjsgY2hhcnNldD1VVEYtOApDb250ZW50LVRyYW5z
ZmVyLUVuY29kaW5nOiA4Yml0CgpDb21taXQgNjAwYjY2NWI5MDM3MzNiZDYwMzM0ZTg2MDMx
YjE1N2NjODIzZWU1NSB1cHN0cmVhbS4KCkF0dGVtcHRpbmcgU09DS0VUX1VSSU5HX09QX1NF
VFNPQ0tPUFQgb24gYW4gQUZfTkVUTElOSyBzb2NrZXQgcmVzdWx0ZWQKaW4gYW4gLUVPUE5P
VFNVUFAsIGFzIEFGX05FVExJTksgZG9lc24ndCBoYXZlIGFuIGlvY3RsIGluIGl0cyBzdHJ1
Y3QKcHJvdG8sIGJ1dCBvbmx5IGluIHN0cnVjdCBwcm90b19vcHMuCgpQcmlvciB0byB0aGUg
YmxhbWVkIGNvbW1pdCwgaW9fdXJpbmdfY21kX3NvY2soKSBvbmx5IGhhZCB0d28gY21kX29w
Cm9wZXJhdGlvbnMsIGJvdGggcmVxdWlyaW5nIGlvY3RsLCB0aHVzIHRoZSBjaGVjayB3YXMg
d2FycmFudGVkLgoKU2luY2UgdGhlbiwgNCBuZXcgY21kX29wIG9wZXJhdGlvbnMgaGF2ZSBi
ZWVuIGFkZGVkLCBub25lIG9mIHdoaWNoCmRlcGVuZCBvbiBpb2N0bC4gVGhpcyBwYXRjaCBt
b3ZlcyB0aGUgaW9jdGwgY2hlY2ssIHNvIGl0IG9ubHkgYXBwbGllcwp0byB0aGUgb3JpZ2lu
YWwgb3BlcmF0aW9ucy4KCkFGQUlDVCwgdGhlIGlvY3RsIHJlcXVpcmVtZW50IHdhcyB1bmlu
dGVudGlvbmFsLCBhbmQgaXQgd2Fzbid0CnZpc2libGUgaW4gdGhlIGJsYW1lZCBwYXRjaCB3
aXRoaW4gMyBsaW5lcyBvZiBjb250ZXh0LgoKQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcK
Rml4ZXM6IGE1ZDJmOTlhZmY2YiAoImlvX3VyaW5nL2NtZDogSW50cm9kdWNlIFNPQ0tFVF9V
UklOR19PUF9HRVRTT0NLT1BUIikKU2lnbmVkLW9mZi1ieTogQXNiasO4cm4gU2xvdGggVMO4
bm5lc2VuIDxhc3RAZmliZXJieS5uZXQ+ClJldmlld2VkLWJ5OiBHYWJyaWVsIEtyaXNtYW4g
QmVydGF6aSA8a3Jpc21hbkBzdXNlLmRlPgpTaWduZWQtb2ZmLWJ5OiBKZW5zIEF4Ym9lIDxh
eGJvZUBrZXJuZWwuZGs+Ci0tLQogaW9fdXJpbmcvdXJpbmdfY21kLmMgfCA5ICsrKysrKy0t
LQogMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9pb191cmluZy91cmluZ19jbWQuYyBiL2lvX3VyaW5nL3VyaW5nX2NtZC5j
CmluZGV4IGY5Mjc4NDRjOGFkYS4uZTVkMGNjOGE4YTU2IDEwMDY0NAotLS0gYS9pb191cmlu
Zy91cmluZ19jbWQuYworKysgYi9pb191cmluZy91cmluZ19jbWQuYwpAQCAtMzM4LDE2ICsz
MzgsMTkgQEAgaW50IGlvX3VyaW5nX2NtZF9zb2NrKHN0cnVjdCBpb191cmluZ19jbWQgKmNt
ZCwgdW5zaWduZWQgaW50IGlzc3VlX2ZsYWdzKQogCXN0cnVjdCBwcm90byAqcHJvdCA9IFJF
QURfT05DRShzay0+c2tfcHJvdCk7CiAJaW50IHJldCwgYXJnID0gMDsKIAotCWlmICghcHJv
dCB8fCAhcHJvdC0+aW9jdGwpCi0JCXJldHVybiAtRU9QTk9UU1VQUDsKLQogCXN3aXRjaCAo
Y21kLT5jbWRfb3ApIHsKIAljYXNlIFNPQ0tFVF9VUklOR19PUF9TSU9DSU5ROgorCQlpZiAo
IXByb3QgfHwgIXByb3QtPmlvY3RsKQorCQkJcmV0dXJuIC1FT1BOT1RTVVBQOworCiAJCXJl
dCA9IHByb3QtPmlvY3RsKHNrLCBTSU9DSU5RLCAmYXJnKTsKIAkJaWYgKHJldCkKIAkJCXJl
dHVybiByZXQ7CiAJCXJldHVybiBhcmc7CiAJY2FzZSBTT0NLRVRfVVJJTkdfT1BfU0lPQ09V
VFE6CisJCWlmICghcHJvdCB8fCAhcHJvdC0+aW9jdGwpCisJCQlyZXR1cm4gLUVPUE5PVFNV
UFA7CisKIAkJcmV0ID0gcHJvdC0+aW9jdGwoc2ssIFNJT0NPVVRRLCAmYXJnKTsKIAkJaWYg
KHJldCkKIAkJCXJldHVybiByZXQ7Ci0tIAoyLjUxLjAKCg==

--------------UdsguNf0sUs20yNVjqVH6ax5--


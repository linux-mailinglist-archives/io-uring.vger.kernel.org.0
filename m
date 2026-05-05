Return-Path: <io-uring+bounces-13241-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YBO1DnTy+WmcFQMAu9opvQ
	(envelope-from <io-uring+bounces-13241-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 05 May 2026 15:36:52 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B7304CE9EC
	for <lists+io-uring@lfdr.de>; Tue, 05 May 2026 15:36:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4A690307298A
	for <lists+io-uring@lfdr.de>; Tue,  5 May 2026 13:26:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A3ED47ECD9;
	Tue,  5 May 2026 13:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="IbB7DYaU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774641DF27D
	for <io-uring@vger.kernel.org>; Tue,  5 May 2026 13:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777987567; cv=none; b=G3nhcr7AjpAmfF/9xzhpslzYDyAScppiNkJHypwAy4T5rkQ7x3pVYyZGiB6gN2F8VaHi1MDXpzmyZPsj0Cc2SBXHtG7RopJCjqbxOOKXdB8IVFFpbldXgHJHRIxzaGwL8cnv6L/G/ZEJuOnz/fsgoF3IoL7czZcIVFhcPqegQy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777987567; c=relaxed/simple;
	bh=CCWlFnRO2hx3OcU+KlxBVkMbLYA51b+uha0hia8YesU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cx30t6f1Vg5Fbj5ic/iUiQsMjDkSglvisRcb1bfwoW0jALUKBppm+SmtfdgT/QLPPx7l3Mc1g8UDRP+4p5RG22wQ87qiDGT19Vpv/lImz4ax6xDc3Wca91Xo+JMkXIsCrI8S3RpMK6lxWUd1zMgnm8tmdyazGzdtVySu/pc1dOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=IbB7DYaU; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-488a9033b2cso46687635e9.2
        for <io-uring@vger.kernel.org>; Tue, 05 May 2026 06:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777987563; x=1778592363; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JsGdq+z3OX4rV79rHe9euKuNqkDPhBzg5djS5kcqzvw=;
        b=IbB7DYaUHFvXT7K4fMDskCh1h8UFri6aEaOXq+SiOp5nsGwNfWgoccZJ5z98gM5PzW
         md+M3Zy+JFW4o9wbHxnEA2bP6FMGIG5Nd1qnEeIdwi1sQLUQkDhNUdz1fxtpxkBtfWCQ
         BkqSuudxycXolr8+LamxIdChEPsPKEIeeTDQvCTa0J/8gEIAPeQwb9D5fPEZTG9QAVUO
         Lw5U6hpN0OAKTdCtE/JNRArLzLbRR9KulgWpNZkQDAIoqOhib7Iar2nX/Y0TKtb14iY2
         Fw1G4/DPOcr6sXeE911e5zCeYZZKOhXVFqJSgfieubmReFWwDLAwPFArxMVHZCue0MNR
         deMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777987563; x=1778592363;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JsGdq+z3OX4rV79rHe9euKuNqkDPhBzg5djS5kcqzvw=;
        b=O5ZypH8FR9Satb8Ab1XYeTw9jDMKLJo/uWQwb0MtuL241bqcar0zxYbWdEYwHj9FJY
         ifR+gs+djt/SGTbAZ0lGpNaERcA+ed0wvv14EzqSgeFCx87VDJ7BaNeUX3BoFunwhh1l
         H+rCkCWHtreWV7jEk5BkggKoKiXrV22NWGmrDvHL5ZuS6hxy5MNG3lvnSagnb42pWbV3
         8HvkNKeoFXt1IPFMoY9/XKbOMYFR29DrhI5ubdXNO4giZErBUKGzrQBpvSDWp+OVIZaM
         ZRNS10sJtklovBdptvTSFCS8K441TCj5yM2d1CB4ZI/k/C4h/QrK5+a5CsVM7FmqrvjL
         7iaA==
X-Forwarded-Encrypted: i=1; AFNElJ/Ucj8kqYxFn/qTsbM2FzIt/zEshebJ1lcy1AmEoKPougLZIgLeTy5GXdXwPmqcn2SfXbQd4ngMvA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5POMHVi6twL66KRRPCXJRoLbT9oQ/3cg0bQcC2/j0U+sdYKod
	UMxsp8ybh+e5pmLxzHmSsyjVnSgpGrhgGs3XjazL226kob+SRk9OliccXAF2dosvHcGPo7Jj/8w
	cjMmV5P0=
X-Gm-Gg: AeBDievftltf+nPaI4nY9tYtLahJXtHz6V6Oe1WnSy94n7+mjrRDUoNM22B5T+Ytl4J
	AAp+2k+/2iBoJ4TO5h9gUlMBEr+epuSzXS5hoWc+XLeeESfUN7nD5vN+FZNB/NDGF7Hyq/nWdS+
	WMNIH8CzzPdtMNaZY2bQe5Cix+h+xsAMJOTfyD8OVVZtE2VbIaR7qzz1+WZL05/uyVhJEFyDEO9
	E8MnhLHnrNEajE1QkxDScwD90xb5Ky4S7UrH6WauX6IMWqhF+azXF2weezUkueQX+bnKa/2GHuW
	sYcv8x5mH/cE2khoovxOI3VoinwFqFXjHhsMKiQ436uxgJKpnqGT544KBHo64qlIoetrGuG9ObE
	wEeEq+3pyF7CEuxtSsGzy12URZiRL7utjXDHuystFORLF69brxktLUVnC8XRVSIHE9v3ZofvVKB
	+lPZjzHalHQyaNNnb3vdZsXIcTGUKnzZI/pFKOuTHx4vpMlLkXONRtZEy9Qs02+r313LnEK3IrO
	kSVvOcKRMhhCzLKh83a
X-Received: by 2002:a05:600c:83c3:b0:488:c078:bfda with SMTP id 5b1f17b1804b1-48a986713e7mr239380435e9.26.1777987562680;
        Tue, 05 May 2026 06:26:02 -0700 (PDT)
Received: from [10.211.9.173] ([213.147.98.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48d149f1a77sm20026225e9.4.2026.05.05.06.26.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 06:26:01 -0700 (PDT)
Message-ID: <4c976ffe-ae16-4804-9b75-50ffb7288d11@kernel.dk>
Date: Tue, 5 May 2026 07:26:00 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: remove registered buffer 1GB limit
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@meta.com>,
 io-uring <io-uring@vger.kernel.org>
Cc: Andres Freund <andres@anarazel.de>
References: <6de5d329-9162-4992-85cb-f946f2d5c0b1@kernel.dk>
 <3a19966b-229b-495b-966a-5018fc615a8a@kernel.dk>
 <0965a131-ccaf-40d5-a207-9d41c837b278@meta.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0965a131-ccaf-40d5-a207-9d41c837b278@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3B7304CE9EC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-13241-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[anarazel.de:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel.dk:mid,kernel.dk:email]

On 5/5/26 7:23 AM, Cl?ment L?ger wrote:
> On 5/5/26 12:09, Jens Axboe wrote:
>> > On 5/5/26 1:39 AM, Jens Axboe wrote:
>>> There's no real reason to have a limit, as the memory is accounted by
>>> the lockmem limits anyway, if any exist. io_pin_pages() will still
>>> restrict the maximum allowed limit per buffer, which is INT_MAX
>>> number of pages. For a 4kb page size system, the limit is 8TB.
>>>
>>> Reported-by: Andres Freund <andres@anarazel.de>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> Forgot that I had a prep patch for this one... The branch is here:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=io_uring-reg-buffers
>>
>> and notably the patch before this one is below, which bumps the ->len
>> size of the io_mapped_ubuf. I'll send this out as a proper series later
>> this week, this is 7.2 material obviously.
>>
>> commit 381e736515173a1fb78d2a86983d3ebfcf263597
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Mon May 4 05:40:16 2026 -0600
>>
>>      io_uring/rsrc: bump struct io_mapped_ubuf length field to size_t
>>           In preparation for supporting bigger individual buffers, bump the length
>>      field to a full 8-bytes with size_t rather than an unsigned int.
>>           Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
>> index c2d3e45544bb..f0ff4bd01b6d 100644
>> --- a/io_uring/fdinfo.c
>> +++ b/io_uring/fdinfo.c
>> @@ -223,7 +223,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
>>           if (ctx->buf_table.nodes[i])
>>               buf = ctx->buf_table.nodes[i]->buf;
>>           if (buf)
>> -            seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf, buf->len);
>> +            seq_printf(m, "%5u: 0x%llx/%zu\n", i, buf->ubuf, buf->len);
>>           else
>>               seq_printf(m, "%5u: <none>\n", i);
>>       }
>> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
>> index 44e3386f7c1c..03521b50926c 100644
>> --- a/io_uring/rsrc.h
>> +++ b/io_uring/rsrc.h
>> @@ -34,15 +34,15 @@ enum {
>>     struct io_mapped_ubuf {
>>       u64        ubuf;
>> -    unsigned int    len;
>> +    size_t        len;
>>       unsigned int    nr_bvecs;
>>       unsigned int    folio_shift;
>>       refcount_t    refs;
>> +    u8        flags;
>> +    u8        dir;
>>       unsigned long    acct_pages;
>>       void        (*release)(void *);
>>       void        *priv;
>> -    u8        flags;
>> -    u8        dir;
> 
> Hi Jens,
> 
> This seems like an unrelated change.

Hmm, how so? It's required for removing the 1GB restriction, as it bumps
buf->len from a 32-bit unsigned to a 64-bit size_t.

Oh you mean moving flags and dir? That's just so it packs better,
changing int would leave a 4-byte gap. Might as well move flags and dir
near the 4b refcount_t to avoid bloating the struct.

-- 
Jens Axboe


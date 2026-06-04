Return-Path: <io-uring+bounces-13610-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id xDUjAvjWIWrcPQEAu9opvQ
	(envelope-from <io-uring+bounces-13610-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 04 Jun 2026 21:50:16 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 373D4643048
	for <lists+io-uring@lfdr.de>; Thu, 04 Jun 2026 21:50:15 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=FdqKwkxH;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13610-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13610-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A775230393A6
	for <lists+io-uring@lfdr.de>; Thu,  4 Jun 2026 19:43:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39E5B3C0605;
	Thu,  4 Jun 2026 19:43:27 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E744130F803
	for <io-uring@vger.kernel.org>; Thu,  4 Jun 2026 19:43:24 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780602207; cv=none; b=hqR0rzubOi1bdj0o/QEZsJHplkEg5yuLmzMd3JphPDePP6E9AokA13RrrMZeh5w0ByBfm9Xw+LUOHT9LjhT8ybJkNyIPjWH6MEI5cBtYPcNInDfy1UIubtc4aSCRgk+jCE2VKYceglTstTCFDEgm3OL4TTZVJCwzNos1pdGdzHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780602207; c=relaxed/simple;
	bh=5cst9hOxap94TT6a1z/SWPqtlqKXlE4nPsUEE3L8V2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Pc5x/JFlExZZtKZItP9Lk4pMYqz2b3VDiHWOUu+iT1KOx5j0JZaFfYTOpje+hD9pThN3JF0yt086tl1BUioUkjbOcM86V7Uk7MFCpKJb5SUIYlbo9UsNlFfj3q3h6xn4nCsifsAKujlp1cYQyX6FyNQy/XAFlb6ZquHwQU6Nj4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=FdqKwkxH; arc=none smtp.client-ip=209.85.210.48
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7e6b5c374e5so1227627a34.0
        for <io-uring@vger.kernel.org>; Thu, 04 Jun 2026 12:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1780602204; x=1781207004; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aoOld0oqr2k1jy6hke59gfEt7LQBnZxAeq3NQJFsXR4=;
        b=FdqKwkxH4aAU1cVuGviP7JKd57gy+PdlxNdLo6pj+8Y/A+6NIebmF1CKXHdY1xvuCQ
         0F4JfQVbETRROMGVVovxJYiYhuaoJ1jONP1H0Nm8t8LO5TTAF+BmHI0dPJlioVlE6vjU
         UUePYzYSLEtPrJD5jCgJDRjD+nQqwPxtAzjgdPpyQ99Td/R7f4m1o46fXmHCqhlQ48vk
         0Ax6nKafUGQLaUHWFyf+wYGEas86i7QUfbkmEjVuzERB7y7lFms3XVIZORQe6BvrNcqD
         1FDNCNDURC+BhhcEZ5pThGktyBHhOQxVx76lGBZ7Sa7TQU8qbhcfvBaL7TQVgJ3moHY8
         SDdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780602204; x=1781207004;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aoOld0oqr2k1jy6hke59gfEt7LQBnZxAeq3NQJFsXR4=;
        b=e0jIMVQT8rVWrDHJQeLcmYW/l6J7IAy4RVar6M5LY3EFyDDfyUZDytPSPJsLa6x31+
         Zj30Ww5K32+TcdcPMdYuCIcMGZfenEgOgsfNHPWGhAeAvefQlb1JxQAPoLzvXrdifpIb
         VaVq2vCSsZpRAotKUVKNs5OiPY4mxjRmLW3GlqEUQg/lsgJ1OH5aHPy5lk7krwlcBHWr
         qRieKhveIPywTxdY3elNS1691UDNIN8PDIAGse48BrmQIsWE+Yi+zHvzSBsJ0+OKxYAX
         bdnkbtPpXoqzgISy10YFKr3PhaoSpS3gKb2ZcLalgTrlPtNEDYs8RLgsnBZ+Nsj8HI9V
         iuqA==
X-Forwarded-Encrypted: i=1; AFNElJ/PIu7bSYoYf+wkWrG8uFsVHjiPBtz4sO+m5UwjrQLW/ceXg/4wyTxbScQR56tEw47NtIapEiJ7Ug==@vger.kernel.org
X-Gm-Message-State: AOJu0YxJ1QwRJKmJyfsjNiS/chVy6xML73BOhG+m3SGTxD6hrfvs2Zuo
	hW2eC2yfLZBCne9asFvgYTTniKbkeMTcaMMQYfFzhmA7SsQdUz+KeWZgNJcIXktk0GI=
X-Gm-Gg: Acq92OE9zeiMgiCLr6lTrWO5N/oakYwOFutZEJabnt1+mzxLfxsVM0glV+yUs745+xq
	A4021eHXZMiNZI0Q913/6ruGE9hXvP1Jlj2JynVlDjVPJdyxpAnX3GwbpnpPFvUxzK9DQ+IdtyS
	O2eqdhgsRZ/XrH1ucgxL4y8pVLlK3n526HAHNqXeyol39ncIRwVgYEzj2JdTzRScMgUieNSVChw
	hubyUDe50l/DAYaB107Z7A21QXLgN9v2FXCIL5QZO9bku934fTjQbbvoRX1lONfs57akZSALx0O
	rPX+eXDSsP/VlR0n0LAva2K06pzsDyqIsSSx9lSYhZ1PELGMdxmVKyeNbA/I5EOT34piLaPV4Ck
	nRQBxaJLHZT89/3B2ZB3WoGf0iCkTVd8zVXKSYVMPm6/kajNNmPymtPo8eEf72EQkbrejwR43dk
	P5fK5C9gHlCnBvqDOHcDq60RwzrfLcBJ68ZDNeCT3qM5nXnQ5UcrPQazB1Un73LNJU9OrLH9ka6
	TJqnCsvawdk7l2+fpzN
X-Received: by 2002:a05:6830:6688:b0:7e6:50c4:e954 with SMTP id 46e09a7af769-7e70cfb15f8mr11171a34.11.1780602203785;
        Thu, 04 Jun 2026 12:43:23 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e6e78e7f9csm4538287a34.17.2026.06.04.12.43.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 12:43:23 -0700 (PDT)
Message-ID: <c0a40699-f609-4b30-9fd5-16053cf91248@kernel.dk>
Date: Thu, 4 Jun 2026 13:43:22 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/net: inherit IORING_CQE_F_BUF_MORE across bundle
 recv retries
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@meta.com>,
 io-uring@vger.kernel.org
References: <20260604160715.2482972-1-cleger@meta.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260604160715.2482972-1-cleger@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13610-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:cleger@meta.com,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 373D4643048

On 6/4/26 10:07 AM, Cl?ment L?ger wrote:
> When a bundle recv retries inside io_recv_finish(), the merge logic
> OR the saved cflags from the previous iteration with the cflags
> returned by the new iteration:
>   cflags = req->cqe.flags | (cflags & CQE_F_MASK);
> 
> Bits listed in CQE_F_MASK are inherited from the new iteration, and
> all other bits (notably IORING_CQE_F_BUFFER and the buffer ID) come
> from the saved cflags. Before this change CQE_F_MASK covered only
> IORING_CQE_F_SOCK_NONEMPTY and IORING_CQE_F_MORE.
> 
> When using provided buffer rings (IOU_PBUF_RING_INC) with incremental
> mode, and bundle recv, io_kbuf_inc_commit() can leave the head ring
> entry partially consumed, __io_put_kbufs() then sets
> IORING_CQE_F_BUF_MORE on the returned cflags so userspace knows the
> buffer ID will be reused for subsequent completions.
> 
> Because IORING_CQE_F_BUF_MORE was not in CQE_F_MASK, the merge above
> silently dropped it whenever the final retry iteration partially consumed
> the buffer, and the subsequent req->cqe.flags = cflags & ~CQE_F_MASK
> save would have left a stale IORING_CQE_F_BUF_MORE in the carried-over
> cflags had one been present. Userspace would then wrongfully advance it
> ring head past an entry the kernel still uses.
> 
> Add IORING_CQE_F_BUF_MORE to CQE_F_MASK so it is both inherited from
> the new iteration into the user-visible CQE and stripped from the
> saved cflags between iterations.

Looks good!

> A test available in
> https://github.com/clementleger/liburing/tree/bug_f_buf_more allows to
> validate this fix.

Can you send in the test case separately for liburing?

> 
> Signed-off-by: Cl?ment L?ger <cleger@meta.com>
> Assisted-by: Claude:claude-opus-4.6

I'll add a:

Cc: stable@vger.kernel.org
Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer consumption")

-- 
Jens Axboe


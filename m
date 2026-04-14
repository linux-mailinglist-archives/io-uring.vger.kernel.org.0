Return-Path: <io-uring+bounces-13037-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sA46LyAm3mmMoAkAu9opvQ
	(envelope-from <io-uring+bounces-13037-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2026 13:33:52 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DBD43F964F
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2026 13:33:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D4A6B301A15F
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2026 11:32:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1D513D34AC;
	Tue, 14 Apr 2026 11:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kbpRFxTR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AFA35B658
	for <io-uring@vger.kernel.org>; Tue, 14 Apr 2026 11:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776166324; cv=none; b=Atde8zkd0aIHs1jbLmKQez4B5rpfZoNYH/wLsO9LrO7a+WIdazHBvngxBhoUkBSpEgTTJwx4+5feM/TadmHCShEH721Rq0YuzaFoXM1ru+7qy+TemcxcHpP8DbDtyQwUrIyCbYbIYnQB8Olabk45e3xPsihZjzIURW7bPl/WbHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776166324; c=relaxed/simple;
	bh=SsMD+r72mcimopA5LH45oU32yvR6BTbNxjBd+qnMEB8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fMiYwj3CHTJVEFsYVdliSvjXEvDOGIV4YBIkdaCZLKlBEPaRNLEdaU02HiaQ+IQOQvpFbvMKttQkJiJhm+LJipAM/viOfBu9IaQQqK+7tK1Vs5wP6+89n1GMC76VAm6QBteCqiJ+LWheWm/1wxMdbpYTmF4Mny3MaPhku9GlgP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kbpRFxTR; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-488a88aeec9so73465735e9.2
        for <io-uring@vger.kernel.org>; Tue, 14 Apr 2026 04:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776166321; x=1776771121; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2aKBKyCBt7Lss1EfQZ51sb16vrvlu7rmxSn0zkeC3yo=;
        b=kbpRFxTRcvafuNPotloLCIbYdk+8tT8IWBTmEzl/GJuIB0KrSn7Myov8Y2AKNThSe7
         XILbobV1sQC0gDP/SQPjfQ4NFu4xxb2Xqw2Xc19qoD3BtF9qUF+8+LhGmyu7lFmETbpM
         JuN6ZaTj1vF/cgvuvVWx88ad8EadUpcYAH/sY+/feywfHxO7gVntkn2gQ9kv95cRF7VM
         lEFYieFFx7YOVLdjPwVzlYR4d2DGbVdyPa9TUBaQDAGjZ4/vexzekbbmLlhPAir1re7Z
         c9jJ7bkWODz2YCcdPMkH7hBw/pQIvNKfAUf6Th3T8/lTkcFRacEaC/XKxIE3b1LoGGNQ
         EdwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776166321; x=1776771121;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2aKBKyCBt7Lss1EfQZ51sb16vrvlu7rmxSn0zkeC3yo=;
        b=ovU1Z4FYVd4ZfNwhKHwz9HE6Qti0XO5nLKfbFFnG+DYd321C7XjT5W2hv7canRzKZY
         lnuW5Y0SC0EN5KtbOZFpj6I6GrhPucf8srsFXUveBvQI+39PsdqPCWGAaMxjCjst7w1L
         H0JaC4M49nVzHsVp5rjBuM7+8n7cDEY0CuHa2UU0skkIFh9T7LGGyegA52m7CnUm4F0T
         Wpj+pFqwf0/F5MzrQuvFCmVmd0erjuSYgPbbmtbco+50/JDh46PeX2Ci/JZO9XNSmLd3
         Gq9JcJfXJWm8e13ZaZaSMV1vJli3nukj547VBTxuQ3Zm6KYVmsO3WT3sUNylEGBmVup+
         pIgw==
X-Gm-Message-State: AOJu0YzkXUTEkV606QNrJWmW+z5ywaN7Io7O18Hb+iAJ//kDIA1LfLCi
	tAQP6ccfG1bTu3S4B1kPNNUAJ/j5GR6NNC0FGxRqm0hIsDuz0sGbz4ZtR55BGw==
X-Gm-Gg: AeBDiesxUTsbPIt72gTqkFqMg9WxSWUxsNdptc579kg6S0xeS81YMbzkiyhESaZGRtP
	SDgCrfaYMCk2aZ7O7K3/GCED60hsgyt15uoIZWqB0hQDv4slVwlT0+9mCL3+W9DY9iZkZSuWbg3
	EnY2qXMMOB5hLxexEbIGyMaUweXcAQIs6gNK/53grcLdwLHYZ8sJf2qIIcgth8zBapr0TDJpx5A
	/PIqILF/ewZMET7xZmd5JDwnjk/OzM/b9cswmqd4bi2fOAVU4B34ozvcJMIAqZeh9a1sNTH2VIt
	3EBYQSsnoI80+UmbWHh5zjqk7nardDG9yikmo99g5WbLmB4E+XP2dDvpALZydr1AQeNfnv3IyxI
	I0WCbN426CBpO961iIIE7v1jpueI0W3eLEshZLrgFy6fvVL0KfzEgZxh0yIAHX5V/B+JZobSehw
	ynOGstW0qitgKgmABZTzWOamBaQ6TGC9EnCIMp/9f2Nu+CD327qBLTnt+9El+2F/jJ/uJjkmNIy
	iFVD9gN3JpFHs6vI2hD4FWZBMRUAWBHPdRMMfx8L7JXZip9N8XafHUIdkMrBvp8rZ1hsdqlIzqv
	P8T5dC5kJqn2
X-Received: by 2002:a05:600c:a11c:b0:485:303b:c50a with SMTP id 5b1f17b1804b1-488d6804721mr176123825e9.13.1776166321079;
        Tue, 14 Apr 2026 04:32:01 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488ede15694sm71217325e9.3.2026.04.14.04.32.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 04:32:00 -0700 (PDT)
Message-ID: <2f7a77ea-dcfe-4fdd-bd18-e7e48a8ec073@gmail.com>
Date: Tue, 14 Apr 2026 12:32:09 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 1/1] tests: fix zcrx tests
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk
References: <35996dec32a78ce0c93dff43197b52cadc2696ea.1776003410.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <35996dec32a78ce0c93dff43197b52cadc2696ea.1776003410.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-13037-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3DBD43F964F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/12/26 15:17, Pavel Begunkov wrote:
> zcrx.c is broken and clearly nobody is running it, do a complete
> rewrite. It covers most of the cases it was supposed to check,
> especially around invalid parameters, but also adds tests for different
> control commands like rq flush and export. It relies on ZCRX_REG_NODEV
> and doesn't require real hardware. It can get !NODEV support later, but
> at least it allows to exercise most of paths on any machine.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   src/include/liburing/io_uring.h |    6 +
>   test/zcrx.c                     | 1561 ++++++++++++++++++-------------
>   2 files changed, 913 insertions(+), 654 deletions(-)
> 
> diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
> index 1e58bc72..983aa265 100644
> --- a/src/include/liburing/io_uring.h
> +++ b/src/include/liburing/io_uring.h
> @@ -1054,6 +1054,12 @@ struct io_uring_zcrx_area_reg {
>   
>   enum zcrx_reg_flags {
>   	ZCRX_REG_IMPORT	= 1,
> +	/*
> +	 * Register a zcrx instance without a net device. All data will be
> +	 * copied. The refill queue entries might not be automatically
> +	 * consumed and need to be flushed, see ZCRX_CTRL_FLUSH_RQ.
> +	 */
> +	ZCRX_REG_NODEV		= 2,
>   };
>   
>   enum zcrx_features {
> diff --git a/test/zcrx.c b/test/zcrx.c
> index 572e1185..04add8ce 100644
> --- a/test/zcrx.c
> +++ b/test/zcrx.c
> @@ -1,6 +1,6 @@
>   /* SPDX-License-Identifier: MIT */
>   /*
> - * Simple test case showing using send and recv through io_uring
> + * Zero copy receive tests
>    */
>   #include <errno.h>
>   #include <stdio.h>
> @@ -17,69 +17,111 @@
>   #include "liburing.h"
>   #include "helpers.h"

It also needs:

#include <linux/mman.h>

I'll resend later unless you can add it while applying.

-- 
Pavel Begunkov



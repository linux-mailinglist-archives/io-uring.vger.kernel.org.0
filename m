Return-Path: <io-uring+bounces-9124-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9015DB2E569
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 21:02:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 753035E339D
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 19:02:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 188D27261A;
	Wed, 20 Aug 2025 19:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G0lnax2J"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673E836CDEB
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 19:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755716520; cv=none; b=BxRMQH7TMCy0ZshQNX+FYeIDMATDxJxBrzb7Gl31rc5bs3Enq8uErYcleGcCcsosQ0mQKV4K+wV/lVjQHeNcvXdaRrqfOdNNgSqvAZR7+Y+OSnb4jUZeQG64hky/0E1ZnPdv9u8HZZG5CslQGWlrSp1RQcqvPTBU6OvwU60/Xb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755716520; c=relaxed/simple;
	bh=i47iCctchtlrh3e41eNK2qg3GhB3MyzTU4FDF8P7698=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=UCuEERCSJh5nT4wyNDGC9NVbuRpv2n0JCKh71QHgFWgGdRnS50xo3LseGQHQxWxFcPyizbg5Gp153ldmBGbMKh0FH9DNwsUv6KgZx5plELCzI6l2O+5ZGhoOBwTgJYuhOgqa6ZCWoCWAa7VgpYUWNNTSErrW14L0CxU7sx8kYho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G0lnax2J; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-afcb78c77ebso31904866b.1
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 12:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755716516; x=1756321316; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fmbsDUaL83LvU96dgRnLmAZF0W/V0nVeMClUZM7O+Ck=;
        b=G0lnax2Jex0BqsrRvBu6T9ogaGWdHf/gt0gCG2xtFOBsGIohP0Uu2sl3GuBq26J+AM
         Fxa7PdmnZez3uRMAJS3WCIF6+ECC+MKRD/if6HRJxQ4jVUPnjIhc0KaRaEs5gfSZs5qZ
         JyXqmmXfsr5Gv6QMt6fzX/W8GJ5yL3yPS97yzrp9G+vk7rax+olWQfw88OxdFPgbV9mM
         1J3p/IB00b+tsO3VzrwXFDbhOMeJ3ns8Hye/K6hZbYyb5/H1h6WJrZNCPMha3oMAj4Xf
         7njLY0m+jBGhRGCUdnwkIb/Nsq2AGC5rPQz1BnwvyBzIzwaaxm/l83b6HRgd2xeJZmr4
         tmYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755716516; x=1756321316;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fmbsDUaL83LvU96dgRnLmAZF0W/V0nVeMClUZM7O+Ck=;
        b=VpEpUnuUvtAnKlh8CBz5r/plzHy7AMyh+3cIcLecOcsv6hImFyl1+E0MrASGyphgoL
         QxLJxt/ETWZVEYAneSDHVOussHDCmyXeIGCKeK8l1QCZDPkPXmwhQvbIZYO5cGtZHWR3
         64YgCMIpD8hfSCgoeW8vawLRU/N/Gff63sSlTSN+0UXUmJz0pJxK0Thh6S74bhO8tc0L
         tZsujgH3CdIex4ERox4RFJKMlS9lg9k/bwyB0qjvOMDu4bHgxh1JlPK2cXKgi90aZxWf
         UKuhZiQyvE7w37HdSJdFqFEUNNa1DK9O3uaX6N8CBhOFUl1RA6e0MKvhP2z3G/PABG6+
         hr8A==
X-Forwarded-Encrypted: i=1; AJvYcCWo10xVN/Gtvni1gvBXNopgQqKj7tWsQdwedfRk8lw7oWiqOBwLkA6IQO2UquWfxX2Wd9Qv9707zA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8qpyR2XYuX7bYLoNYpI/5ZUQnd/mDnXCrBrqIV5Oy3EBzLVld
	U4gNYV6XNlQWChV8f10va29dtknq769q3MudYJ2ulovyG39ZGGGcDtphq0W33A==
X-Gm-Gg: ASbGncvEyYmZrjJtimgpuhWyEeIiEqbaPwOh0uFvfPO3Bx09T5QttiSGPFJIz5psHOZ
	brJEhcPtoldlfv7vb0YL96Q3qzoQrD6Y7xWTbMLb0qKuQx62BH3frMK+h+z7KBOxJh6jM8skToS
	AgYEtvFCKTChGeCDQRgh7nzxcArbkUcYcMuoovJ3JIXm2XECgT9zt/cLY9C2yLUXSco4z81ECK2
	d2ubgDJEt4r71UN5aThCK8kCJa67KfL/OJKnXqfHSuxuYKeZs99FVxO0aTQsh1QkAmH9yVIIVaY
	VENcj+hwrI3ycNnEURIyXSruJPiBqLwdFog5eaJ+9XWtmEik6Z+LQ/HUamGfBfM+lZMW5ZZpzsf
	43NfR03ey6KNHwpGEDjZ3bUYKqtHbkUbWnxp/UwOOULQ=
X-Google-Smtp-Source: AGHT+IFucqQJRaSmPaBw1LFlTlGw2EvBUaFnLDdwpBJVheaKBKfaTvwkeaYtsvElaw53VJYHsGp1dA==
X-Received: by 2002:a17:907:94ce:b0:afd:d9e4:51e9 with SMTP id a640c23a62f3a-afdf025834amr314939466b.65.1755716516437;
        Wed, 20 Aug 2025 12:01:56 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.133.113])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afded35547esm225253966b.50.2025.08.20.12.01.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Aug 2025 12:01:55 -0700 (PDT)
Message-ID: <4889b8bb-5f50-46a9-8cbc-b00013dc8dff@gmail.com>
Date: Wed, 20 Aug 2025 20:03:05 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/zctx: check chained notif contexts
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <fd527d8638203fe0f1c5ff06ff2e1d8fd68f831b.1755179962.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <fd527d8638203fe0f1c5ff06ff2e1d8fd68f831b.1755179962.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/25 15:40, Pavel Begunkov wrote:
> Send zc only links ubuf_info for requests coming from the same context.
> There are some ambiguous syz reports, so let's check the assumption on
> notification completion.

This one would be great to have to hopefully start tackling
the syzbot report.


> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/notif.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/io_uring/notif.c b/io_uring/notif.c
> index 9a6f6e92d742..8c92e9cde2c6 100644
> --- a/io_uring/notif.c
> +++ b/io_uring/notif.c
> @@ -14,10 +14,15 @@ static const struct ubuf_info_ops io_ubuf_ops;
>   static void io_notif_tw_complete(struct io_kiocb *notif, io_tw_token_t tw)
>   {
>   	struct io_notif_data *nd = io_notif_to_data(notif);
> +	struct io_ring_ctx *ctx = notif->ctx;
> +
> +	lockdep_assert_held(&ctx->uring_lock);
>   
>   	do {
>   		notif = cmd_to_io_kiocb(nd);
>   
> +		if (WARN_ON_ONCE(ctx != notif->ctx))
> +			return;
>   		lockdep_assert(refcount_read(&nd->uarg.refcnt) == 0);
>   
>   		if (unlikely(nd->zc_report) && (nd->zc_copied || !nd->zc_used))

-- 
Pavel Begunkov



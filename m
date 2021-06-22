Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008863B0F13
	for <lists+io-uring@lfdr.de>; Tue, 22 Jun 2021 22:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhFVVBG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 17:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhFVVBF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 17:01:05 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF3AC061574;
        Tue, 22 Jun 2021 13:58:48 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id l18-20020a1ced120000b029014c1adff1edso2624213wmh.4;
        Tue, 22 Jun 2021 13:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6jHGy9hLjOpE8MKb9arulD/So2xoWxY8Pk/5qNqlwmg=;
        b=k24XzHvyVCEVHLQQkR11sf0rgnk+X6J/BG2oEoJ2cMimQv6dbgsqQJYKL7Zbt9i/S9
         fXmDkaT4/EssoHMue2f36HUgHWyKm+ZqPEyCVFjCttTNvnhLbMhcKlon8oWqAI0XxXER
         PF7xQrMS7mMvK4wvBU6p3F/MPcc31oRZW7jEbUHk0ALnF9si2o9SatdxVpKt/uRVt+Ne
         y9+XCkVJBo/ZhoY3LjMZq1wCz3KQKh02pHNM/1ZkKcrT4LUETqdrnUBprEwkJ0+vL9Dh
         OQAom9f8ekZ5QDEJNbdoGJFNk0uVKDSsiclXfRCnHrED7yjW2CL5NUZ0AcXgAg6NvjKw
         HLug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6jHGy9hLjOpE8MKb9arulD/So2xoWxY8Pk/5qNqlwmg=;
        b=OZzIwtHVMiu9xiTUB3wGv2kw5SjrxxDfwUmvQ/1yDg8qH1CrICYJlrtF6R99txRulx
         p9BvUUYvueh8hzXRVRXIX0bLyoDKBe41VZT/Rtn4sJDw1Lr7m1RzBTFgxqJ2ccEBvBJS
         gpn+mYTqjq9LqFFETRngjJsjQlUbsenIO0H/bQvMtzi0BCipTyBXRQjNJLlM9CUFfvge
         buCw918L0HoPPcJhdV9GTkdLCy1WBqUNEMrSAN7oUz3Sn8LHCTIiwe2UuipVcztDOmzU
         WTzkkPo+x4WeNxbEgcd+fFEs2kpmt+1U3mxyZMRaRC7M7MUkOBND90WZY38+OvtUqS3N
         uFJA==
X-Gm-Message-State: AOAM531Ya4LUgrCBtQCppbmxb+BZeNt8iUUEmHMij5X4Hm2HEFIeriud
        MhvnNDh5842cpIGDWeAm9PobrrRgqYGnLXbZ
X-Google-Smtp-Source: ABdhPJySV6KwpvbNc3jcqxn1AacRlD+KJFAdtp15YF1PHtlXawD/IReR8zVwDzA5HKRKvLlNMUtICg==
X-Received: by 2002:a7b:c097:: with SMTP id r23mr6505032wmh.63.1624395526790;
        Tue, 22 Jun 2021 13:58:46 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id n4sm521048wrw.21.2021.06.22.13.58.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 13:58:46 -0700 (PDT)
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1624387080.git.olivier@trillion01.com>
 <c05f957a5b5675a0b401e211065e08255014232c.1624387080.git.olivier@trillion01.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 2/2] io_uring: Create define to modify a SQPOLL parameter
Message-ID: <985f8f73-ad30-855c-39d5-1d3841b43c10@gmail.com>
Date:   Tue, 22 Jun 2021 21:58:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <c05f957a5b5675a0b401e211065e08255014232c.1624387080.git.olivier@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/22/21 7:45 PM, Olivier Langlois wrote:
> The magic number used to cap the number of entries extracted from an
> io_uring instance SQ before moving to the other instances is an
> interesting parameter to experiment with.

Not particularly related to this patch, but the problem with this
capping is that there is no reliable way to do request linking
using shared sqpoll. It may break a link in half (or in N parts for
long links) and submit them separately and in parallel.


> A define has been created to make it easy to change its value from a
> single location.
> 
> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>  fs/io_uring.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 02f789e07d4c..3f271bd7726b 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -89,6 +89,7 @@
>  
>  #define IORING_MAX_ENTRIES	32768
>  #define IORING_MAX_CQ_ENTRIES	(2 * IORING_MAX_ENTRIES)
> +#define IORING_SQPOLL_CAP_ENTRIES_VALUE 8
>  
>  /*
>   * Shift of 9 is 512 entries, or exactly one page on 64-bit archs
> @@ -6797,8 +6798,8 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
>  
>  	to_submit = io_sqring_entries(ctx);
>  	/* if we're handling multiple rings, cap submit size for fairness */
> -	if (cap_entries && to_submit > 8)
> -		to_submit = 8;
> +	if (cap_entries && to_submit > IORING_SQPOLL_CAP_ENTRIES_VALUE)
> +		to_submit = IORING_SQPOLL_CAP_ENTRIES_VALUE;
>  
>  	if (!list_empty(&ctx->iopoll_list) || to_submit) {
>  		unsigned nr_events = 0;
> 

-- 
Pavel Begunkov

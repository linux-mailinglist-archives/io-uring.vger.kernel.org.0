Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9895E7CBD
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 16:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiIWOUA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 10:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232541AbiIWOTz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 10:19:55 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084A43CBF4
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 07:19:53 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id z191so10376038iof.10
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 07:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=vJdPLuiaUnDVSp/FmdWJL98lZHTloleHb71fP6J/26Y=;
        b=0a9LHPmpr71OHdsNQuvckgjquErQqDvUb3i/i+7Em0VzX8MX0C2/ridQJKOg8euTHU
         xBKAu6mFEmcSzpJ8GcjuqZ0AQHmaTrCa5L/f8kS6l9keXdGbRKDEWIGWQI54/Jbzp+gW
         QIup2QTPpyBfku1JhgfzmpDXsSKZy7ctoeKsc4+4055bzgvUTBZR4sHelFhl8viT6t9U
         MXb1JJgOmb8KdQWG3aN8uuj8VsrL9kX4E3Pb4USBHt4BdkNoymCUtZQIMKiPI/T8daQY
         cv6n9iGKRCk8VPdlbhhM02xfEdVkZLgvDUWiwJ7Kznp3InMVWNKwajsrld88AOYbpzhu
         CVrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=vJdPLuiaUnDVSp/FmdWJL98lZHTloleHb71fP6J/26Y=;
        b=eMmjwlrHN0xnHuVF6PMFlEOp4YurnsIhcvWVI3IbiXw5uuHtPXwEkshf/Mtz3Y0P/U
         kWkKT+gtQBAkqYjocMJ04P2zka90+CAYejsOOoqodGRNTxrJLniT8ZfC9L84k7++QhSp
         FVfa/RL9xn3fpBnLf5rHcomOnphoNXRZxXX80MZDhXaQQIhLrbUcw97ERf0Enqzy5ZGx
         gK2rSwjWrZmvUNViiAPjT0p0fEMpBseygGmebM/aVXzIn+727pKaI2wxfBBBNh+7+PKI
         BWq4D+QNCIgNg45IZPV7xnZHDUF06FJS2ZPD/1eA7m4EGISsYd3VDu6cCw9+SWC4G4A6
         Xdbw==
X-Gm-Message-State: ACrzQf2k0KCtYhj5JiRsEcYzOH4SWRGbKen6SbhCnmZ1nhjVjZEiCywI
        cZQ4TgOJFYGPmK91teibdYaayHyMyhAneg==
X-Google-Smtp-Source: AMsMyM50JIZLXvZZbpNvyRLeo9aP0tB8sPx9La3ciEbrbFnJvKyc2S3Fl/W5dtwHCwlT9tvPEyyoSA==
X-Received: by 2002:a05:6638:1305:b0:35a:6a4e:9e57 with SMTP id r5-20020a056638130500b0035a6a4e9e57mr4814276jad.126.1663942792010;
        Fri, 23 Sep 2022 07:19:52 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q4-20020a02a984000000b0034e9ceed07csm3444327jam.88.2022.09.23.07.19.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 07:19:51 -0700 (PDT)
Message-ID: <30718187-8558-4b32-b8d1-5c1f4f322d4f@kernel.dk>
Date:   Fri, 23 Sep 2022 08:19:49 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH for-next] io_uring: fix CQE reordering
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Dylan Yudaken <dylany@fb.com>
References: <ec3bc55687b0768bbe20fb62d7d06cfced7d7e70.1663892031.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ec3bc55687b0768bbe20fb62d7d06cfced7d7e70.1663892031.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/23/22 7:53 AM, Pavel Begunkov wrote:
> Overflowing CQEs may result in reordeing, which is buggy in case of
> links, F_MORE and so.
> 
> Reported-by: Dylan Yudaken <dylany@fb.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/io_uring.c | 12 ++++++++++--
>  io_uring/io_uring.h | 12 +++++++++---
>  2 files changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index f359e24b46c3..62d1f55fde55 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -609,7 +609,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
>  
>  	io_cq_lock(ctx);
>  	while (!list_empty(&ctx->cq_overflow_list)) {
> -		struct io_uring_cqe *cqe = io_get_cqe(ctx);
> +		struct io_uring_cqe *cqe = io_get_cqe_overflow(ctx, true);
>  		struct io_overflow_cqe *ocqe;
>  
>  		if (!cqe && !force)
> @@ -736,12 +736,19 @@ bool io_req_cqe_overflow(struct io_kiocb *req)
>   * control dependency is enough as we're using WRITE_ONCE to
>   * fill the cq entry
>   */
> -struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx)
> +struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow)
>  {
>  	struct io_rings *rings = ctx->rings;
>  	unsigned int off = ctx->cached_cq_tail & (ctx->cq_entries - 1);
>  	unsigned int free, queued, len;
>  
> +	/*
> +	 * Posting into the CQ when there are pending overflowed CQEs may break
> +	 * ordering guarantees, which will affect links, F_MORE users and more.
> +	 * Force overflow the completion.
> +	 */
> +	if (!overflow && (ctx->check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT)))
> +		return NULL;

Rather than pass this bool around for the hot path, why not add a helper
for the case where 'overflow' isn't known? That can leave the regular
io_get_cqe() avoiding this altogether.

-- 
Jens Axboe



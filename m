Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC09B3B237A
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 00:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhFWWSH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Jun 2021 18:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhFWWSB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Jun 2021 18:18:01 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23D2C061766;
        Wed, 23 Jun 2021 15:14:45 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id l12so3591994wrt.3;
        Wed, 23 Jun 2021 15:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=jby64o0v7EYHfux9Oun1hrQ36e6m6gcFy0/ViVpUCHI=;
        b=mi8kKh/V9M9TalRkKjVOQmcdPCEsO3frZoHqQUZoWjyM/nEtVNQVGyzB5sX76auBPL
         L/X/Q4fk3rt4ehqgQhdb1Uzh7+82hbYYCnw6Co4zv2qe5SqeHj4KhmAbs+lbmAidm/gd
         2MEqD9D4gdpi0re/PlPmMJ4Dke1nINeUTFRqRA4QzMkcgzDKAZ5Khr+OSgDWY8QmHFM9
         jFYOBw6NB0npn43RXlkdOb8J+NK1coP2XQzXDgQ5EwqS/NYp8Fxef8g1PVPTb1W0nneM
         p8qjZ3klf8/l9PnOtyVLihSwIRkFyhZh4XNtcrBgc6qygNyEFifNpAZYz+C9OTuBqMOz
         MMqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jby64o0v7EYHfux9Oun1hrQ36e6m6gcFy0/ViVpUCHI=;
        b=UsNKhFo2Kd9R6X2Gz+6D8ZUoTgvEzJsZNZfhgSi8WBaXGG1Xac2CuitVGAWZ/qN4ql
         uKwRBvf6yN1YXW98RDeXNzWDIWWW6A6TckkefNYdaYjRaqaM8QlfIici70WSRL4Kn1c3
         VM5SOfXWsKeOt4ORU8IqrGU1nkvBxyES9NzFjTooH/BZ9bi3BLGC9vOwCVthL7FC0os9
         1nZRRJqIXawLVyTOZ0PtWIDAos53og25KiBKODciqlBVYy2zy2q/4TSux0naIa0CLhtz
         vHA3fBZgQIGjtUSKONhWTYDcKswM/YSV7zZB+2Ir9TbmKyvHOK11GcNdNjeeodlVof79
         Xp6w==
X-Gm-Message-State: AOAM532RikNDQ+AG4WZndT7eGvJgymkl5YAwbhqxG3Hq9IuZzovi0ykw
        uzkzHRmxT5PSzwzTZqzT0/DG0jPUs1jiRuQI
X-Google-Smtp-Source: ABdhPJxKjMWxHo02CoRmQzrgqDTgUJpyICa/HIjCWO4FILUke108zmzpLBO8U5Up39+nIOJfGnKASA==
X-Received: by 2002:a05:6000:1281:: with SMTP id f1mr380435wrx.137.1624486484332;
        Wed, 23 Jun 2021 15:14:44 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id f19sm1031916wmc.16.2021.06.23.15.14.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 15:14:43 -0700 (PDT)
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1624473200.git.olivier@trillion01.com>
 <b401640063e77ad3e9f921e09c9b3ac10a8bb923.1624473200.git.olivier@trillion01.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v2 2/2] io_uring: Create define to modify a SQPOLL
 parameter
Message-ID: <b8b77ef8-6908-6446-5245-5dbd8fa7cfd7@gmail.com>
Date:   Wed, 23 Jun 2021 23:14:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <b401640063e77ad3e9f921e09c9b3ac10a8bb923.1624473200.git.olivier@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/23/21 7:50 PM, Olivier Langlois wrote:
> The magic number used to cap the number of entries extracted from an
> io_uring instance SQ before moving to the other instances is an
> interesting parameter to experiment with.
> 
> A define has been created to make it easy to change its value from a
> single location.

It's better to send fixes separately from other improvements,
because the process a bit different for them, go into different
branches and so on.

Jens, any chance you can pick as is (at least 1/2)?

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
 
> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>  fs/io_uring.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 7c545fa66f31..e7997f9bf879 100644
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

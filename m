Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D877C33103A
	for <lists+io-uring@lfdr.de>; Mon,  8 Mar 2021 14:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhCHN6S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Mar 2021 08:58:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbhCHN6K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Mar 2021 08:58:10 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44A5C06174A
        for <io-uring@vger.kernel.org>; Mon,  8 Mar 2021 05:58:09 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id r15-20020a05600c35cfb029010e639ca09eso3862145wmq.1
        for <io-uring@vger.kernel.org>; Mon, 08 Mar 2021 05:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=me5xFWGMI6afgrjnphd8PCgaHVc2kVBN03lIiFif22U=;
        b=e1RTZXLMuTlitY7X/+kGzNpBoX3KQJMGCx700UlliiCYpi9bgmngsihn+nKu+43w6r
         WgpQg2fq1X5BWgsgEXAKCM2Up6qVbOcHUB06ElSaQdXXmtZ6NkyVvbP2HmnsAh/uJYhd
         22wh8+tqQ1ALGgM5PEpzW+GOh/xsGFiB/3YYTIQrM6UPoci72MJWKGYLlZs8ubc9BUV+
         BiYBzAay0SXCdEtFE36OIfhBzYwW412PjqEvwn/Few/L4TLKu5VOLu4XT4tQVy3S2qQW
         dgg1V76TYZmEScJdZW/d+LgbbvryibnSFDVBJ114hlzOYjzx/pPbsmrP0gpvNQjEXBSk
         eX7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=me5xFWGMI6afgrjnphd8PCgaHVc2kVBN03lIiFif22U=;
        b=VOZFthSKYJqgUmhOVM5qo3Hi/R3VgXhFLEQ4QtGXcG1EcodlJi2/UZ4u8J3JWwrlHO
         S0lXSjlUDv1cFaYez7Sql9MJ3ipWW5XP0m1M+GJEvx4w+5JdL8KDNwifXOkBoTKmNoE5
         F8/LZVgrZt4TWGq5VKHUfyjXqISlgXtC/svSW38rmX7iBcDd6p3zpe8Zyo+slx1Uzf1m
         qJJ8bHA6/VZT+UTuM9rwYEg83jL2lkXBkSqbIqAHMtRDwBKbZUEb3iX/B24eSIGjlP8J
         Os95sXHMs+sbXzO3kEEBBX3mDDpwoFRg7hKZkfllnhCQr6VmA9IucFlhJ9bbXeZlxHpj
         tQcw==
X-Gm-Message-State: AOAM531LbqnffMSaEMjJkUjs3XFCv/F0fWOY045PBPNvyG3C2baw7qwQ
        KMKqDYg08yOB/+50TSaVE5M=
X-Google-Smtp-Source: ABdhPJx+SG26XnTndjafM4VDeeznWJWdc5Ln+Q65nk2EKQ8DTa3KXg9bJMOjz6r96XFeGWIIU6UqjA==
X-Received: by 2002:a1c:dd44:: with SMTP id u65mr22448980wmg.87.1615211888678;
        Mon, 08 Mar 2021 05:58:08 -0800 (PST)
Received: from [192.168.8.118] ([148.252.132.144])
        by smtp.gmail.com with ESMTPSA id i26sm21241542wmb.18.2021.03.08.05.58.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 05:58:08 -0800 (PST)
Subject: Re: [PATCH 1/2] io_uring: fix UAF for personality_idr
To:     Matthew Wilcox <willy@infradead.org>
Cc:     yangerkun <yangerkun@huawei.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org, yi.zhang@huawei.com
References: <20210308065903.2228332-1-yangerkun@huawei.com>
 <e4b79f4d-c777-103d-e87e-d72dc49cb440@gmail.com>
 <20210308132001.GA3479805@casper.infradead.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <787b9f90-71c7-83dd-3826-0d7172be185a@gmail.com>
Date:   Mon, 8 Mar 2021 13:54:14 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210308132001.GA3479805@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 08/03/2021 13:20, Matthew Wilcox wrote:
> On Mon, Mar 08, 2021 at 10:46:37AM +0000, Pavel Begunkov wrote:
>> Matthew, any chance you remember whether idr_for_each tolerates
>> idr_remove() from within the callback? Nothing else is happening in
>> parallel.
> 
> No, that's not allowed.  The design of the IDR is that you would free
> the thing being pointed to and then call idr_destroy() afterwards to

Gotcha, thanks!

> free the IDR's data structures.  But this should use an XArray anyway.
> Compile-tested only.

Yeah, I remember this patch, looks good but 1 comments below.
Anyway, I'll rebase and resend it shortly for convenience.

[...]
> @@ -9532,14 +9531,16 @@ static int io_probe(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
>  static int io_register_personality(struct io_ring_ctx *ctx)
>  {
>  	const struct cred *creds;
> +	u32 id;
>  	int ret;
>  
>  	creds = get_current_cred();
>  
> -	ret = idr_alloc_cyclic(&ctx->personality_idr, (void *) creds, 1,
> -				USHRT_MAX, GFP_KERNEL);
> -	if (ret < 0)
> -		put_cred(creds);
> +	ret = xa_alloc_cyclic(&ctx->personalities, &id, (void *)creds,
> +			XA_LIMIT(0, USHRT_MAX), &ctx->pers_next, GFP_KERNEL);

ids are >=1, because 0 is kind of a reserved value for io_uring, so I guess

XA_LIMIT(1, USHRT_MAX)

> +	if (!ret)
> +		return id;
> +	put_cred(creds);
>  	return ret;
>  }
>  
> 

-- 
Pavel Begunkov

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B8F3A8049
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 15:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhFONiN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 09:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231615AbhFONiG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 09:38:06 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEEAC061574;
        Tue, 15 Jun 2021 06:36:00 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id z8so18381726wrp.12;
        Tue, 15 Jun 2021 06:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1ETlHjLF4DNWkPBtZCHd24Q+TUjKL0nGJVODuHjOW7g=;
        b=Co418qMT6oHFJRT2fESErSI8KQJgJnFO7h8Ad5E7jXdhni9/CSu0aQc1joPdaRF9Ig
         /JIobPIRfBZm+iZ00gfiPmUkE9TOhvJrqJLZKBPEvmS8Q0S2XioqJXUuuAYRrpDE7+Lz
         FRezBhpiVn0vHyfCnBSbR/FMkd90RQy8r3dg/r90lA3pat73IN73ZMn1LCrIxfE/Yiue
         Yf0rnkaW8bYHIaxWvLiuocA75dz9R/ME0ob206JPws7sym3h/f4h1+MLv7/pw3UZY/Ez
         0GS/vPnnEAh0WC8kPJbu9HB4CnHevGtfb2OIvkrxomvv5uooDH3akodk8HeVQCh7VJvC
         Jr/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1ETlHjLF4DNWkPBtZCHd24Q+TUjKL0nGJVODuHjOW7g=;
        b=E0E3OPFe/BpvOVrFymR9aq0ptsko5PdRIqVnqrOQ1kc7VqazxYKWThMZdfmonosXSo
         JTBr7/GFSVRmrm7rhsb6vDU4Q/5RJbqYEKQiU7X6nM+LELQGLnUIMZhYCruuUxlgCaZ/
         Hv/zasHdAb6mdtXq0Q207loai99bSZv9A6fqNttkKUWBloI/UrvHXo3zNDB9iU4BagD2
         Q7JNvyGPJG2fg3yKul/SKXiXgiyWLrAkypNOZfRwx3mwQNa6ssw5g5l1+1VD9DdnqleW
         1DzLuUxH6Ir6LkqwkhH0aqXUJHMZFMS3H3bJOsrm1t8vDRoG516caKbN/OeJSzJmvnLs
         V5Fw==
X-Gm-Message-State: AOAM5313ZnFuLd2MSgm7RZiQnKYZxN6Zcf6LRFGUynScMBsuvvyHdUvm
        68qSBCOmk+D+j92RxHIfd+FdOWB6T+kg5ZaB
X-Google-Smtp-Source: ABdhPJx8zxygOh6GxQN2YJa+wUMci86P6bk/R5GVT+J0BnL9Se1gJex26K/Z8VGp10qPlFfCzCbxLw==
X-Received: by 2002:adf:dd0f:: with SMTP id a15mr19414169wrm.321.1623764158577;
        Tue, 15 Jun 2021 06:35:58 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id c12sm1728554wrw.46.2021.06.15.06.35.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 06:35:58 -0700 (PDT)
Subject: Re: [PATCH][next][V2] io_uring: Fix incorrect sizeof operator for
 copy_from_user call
To:     Colin King <colin.king@canonical.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210615130011.57387-1-colin.king@canonical.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <b6790793-c6ab-5d41-d483-3f978557e904@gmail.com>
Date:   Tue, 15 Jun 2021 14:35:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210615130011.57387-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/21 2:00 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Static analysis is warning that the sizeof being used is should be
> of *data->tags[i] and not data->tags[i]. Although these are the same
> size on 64 bit systems it is not a portable assumption to assume
> this is true for all cases.  Fix this by using a temporary pointer
> tag_slot to make the code a clearer.
> 
> Addresses-Coverity: ("Sizeof not portable")
> Fixes: d878c81610e1 ("io_uring: hide rsrc tag copy into generic helpers")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> ---
> V2: Use temp variable tag_slot, this makes code clearer as suggested by
>     Pavel Begunkov.
> ---
>  fs/io_uring.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index d665c9419ad3..7538d0878ff5 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7230,8 +7230,10 @@ static int io_rsrc_data_alloc(struct io_ring_ctx *ctx, rsrc_put_fn *do_put,
>  	if (utags) {
>  		ret = -EFAULT;
>  		for (i = 0; i < nr; i++) {
> -			if (copy_from_user(io_get_tag_slot(data, i), &utags[i],
> -					   sizeof(data->tags[i])))
> +			u64 *tag_slot = io_get_tag_slot(data, i);
> +
> +			if (copy_from_user(tag_slot, &utags[i],
> +					   sizeof(*tag_slot)))
>  				goto fail;
>  		}
>  	}
> 

-- 
Pavel Begunkov

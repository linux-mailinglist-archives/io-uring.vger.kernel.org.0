Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA6423378A
	for <lists+io-uring@lfdr.de>; Thu, 30 Jul 2020 19:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgG3RSS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 13:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbgG3RSS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 13:18:18 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362D5C061574
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 10:18:18 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id c16so11304736ils.8
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 10:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=PRAlIxJL6kdByMYLy2CpXPtIHGv4Am7InAfUNFaSCwc=;
        b=vGtwhvPp3QMygJeLIwXFrrn5ePs4L6qB/J1G7q1OrUE6HkwEI1QplgUcj8xEpkxqdH
         FNnk7Vq0oVI8lI0wmUp+oE1AaB3jNQ5TN/YWaCxoMvkypcya3C7x5sxM7jabFoKtdIIx
         T4UFLc3W6a0bAsfwW4tgmKgKwFPGTReFVNielYv0VRdHpNwU4s/EJTtBMKfbGsGf2k5t
         Pp4Y9bfi7xxo9ypi/A4c6NnHfLeK9bezMdq9tbN1GDAXi0hS+btUls5jIOx3/+qp/4fJ
         giQ+2QoHEvymx4cMKA3IuKALzJ+vB4EbO9K6gsaRV8jpZDGXCHk1IXlkT42OEL6T4oBg
         Fm8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PRAlIxJL6kdByMYLy2CpXPtIHGv4Am7InAfUNFaSCwc=;
        b=j7hrYjgYtO7PpJjRExFLwLfPh1fglP5fB9ByncEuJlxAxkDu098z3tjZtFuyl0HXrs
         Ncpt9S1O2Q1iXJKwV30fgkgEHZnQyuetFZl35PyyURMBLFm+kr9ta6/dEHQGUyP2zxiO
         Gk8MYBhQqZV39vRcxgtvCZrvCpSzQldK3irUwSCaf8KjxrSlqlUlj3l0FS0RZ7kIAEm+
         vpOWpgFzLL0nAMSZnRj3oo7/2nWkROzDvgvUEDPLnezSu+RmiAtieP7DjeUuW3nGtoG3
         y9EAoj3CEwAyA5HLSb9TuWwDsJkoecXCEwEiabconF3KltKi+Gyh8kBzPyKQaJnhS3RF
         VPmA==
X-Gm-Message-State: AOAM530pclYXc21aM6YB/NhWmO9YiFytLtlFPKu6relQybwUy4terCx4
        ATmgo/ohw00efo+YXPhXZoo1P4WiAVM=
X-Google-Smtp-Source: ABdhPJzJVjb0gHSDUh4yVqHKc/Z0VhxCcpbgzgFI694ONyXH7qvIWmMM3N7SIWYABehIkouGVPXnHA==
X-Received: by 2002:a05:6e02:52a:: with SMTP id h10mr21745759ils.259.1596129497201;
        Thu, 30 Jul 2020 10:18:17 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a18sm2338825ilp.52.2020.07.30.10.18.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 10:18:16 -0700 (PDT)
Subject: Re: [PATCH 3/6] io_uring: fix racy overflow count reporting
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1596123376.git.asml.silence@gmail.com>
 <ba9c998d27e8e75467b09d8a2716cf6618b7cd93.1596123376.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d2347d32-7651-b34b-a7ca-5993b49a2147@kernel.dk>
Date:   Thu, 30 Jul 2020 11:18:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ba9c998d27e8e75467b09d8a2716cf6618b7cd93.1596123376.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/30/20 9:43 AM, Pavel Begunkov wrote:
> All ->cq_overflow modifications should be under completion_lock,
> otherwise it can report a wrong number to the userspace. Fix it in
> io_uring_cancel_files().
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 11f4ab87e08f..6e2322525da6 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7847,10 +7847,9 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>  				clear_bit(0, &ctx->cq_check_overflow);
>  				ctx->rings->sq_flags &= ~IORING_SQ_CQ_OVERFLOW;
>  			}
> -			spin_unlock_irq(&ctx->completion_lock);
> -
>  			WRITE_ONCE(ctx->rings->cq_overflow,
>  				atomic_inc_return(&ctx->cached_cq_overflow));
> +			spin_unlock_irq(&ctx->completion_lock);

Torn writes? Not sure I see what the issue here, can you expand?

-- 
Jens Axboe


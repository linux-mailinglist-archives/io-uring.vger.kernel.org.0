Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56CC3135B9A
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2020 15:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731781AbgAIOpT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jan 2020 09:45:19 -0500
Received: from mail-pf1-f170.google.com ([209.85.210.170]:33423 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729054AbgAIOpT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jan 2020 09:45:19 -0500
Received: by mail-pf1-f170.google.com with SMTP id z16so3495253pfk.0
        for <io-uring@vger.kernel.org>; Thu, 09 Jan 2020 06:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ihdnO7F7ysK1h4t9fR5f51Q46ZrlnqpcMQzBIrLIaRI=;
        b=WyBib6BTem1fWb3CqRUSh2GW6ZWkI5y+zsUGlGVnyHveTK+HU7EH7vh1GYVNpJiREk
         DdaS4ebLISRCv2Dfv2YUgKNSHA9z4USmp8KQSFqkmMRfjfDF3Pj4RNb35kJnHMFFHWxR
         dAIl7OdjbfLPMg8ViVrYgZ4MQoHqL8FC9TfbZP9wmrBxAxI+Pb2DaHGSmjLLFSWuKwRH
         uP9h98J3mL95cbPPrUnCjyB/UJ8k+EL6A8oKmpOmJHvXhkN3tyuCuQdpxs4vT18Wft/V
         Zt3JXY2z5Qbh2HiJaupmB3Uq38le5W/BOh1W2iGDpD34eRU8s/Oghs0XmpiseZjqSKvD
         G0Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ihdnO7F7ysK1h4t9fR5f51Q46ZrlnqpcMQzBIrLIaRI=;
        b=oKnn76eEoJc7hLSxew6zPXsYb/HnhtHgQAws3QAxvHfqT+8r6s5nEcUgzpizHiywGn
         LhiYA/hDptdivUfFP0fuq0mEFYwZglKYDFoQpj3QEKkh9kQkPZmeblQ/PvuOLpVyfRE4
         kvEGOnF5pvD15pkbn7hn2A/eI/6t5mN+/SSrVOHz8xlDhhLUpg7zxkf7JrlpZ+jUeRZI
         tY7pc3TqG4aym8+y9roZgDMEVOlMRPQKGbTpY/SD6jOtatewsjwJXY72L3xbYQfpubpn
         cLE85jT/mN3gmPj4waLEpq0SSyiP6KysCtk+qw5png98/EkS9JHucXcFLVe9anLmHtyl
         DYrg==
X-Gm-Message-State: APjAAAX4wWRXWFYXt1ErDEjdSqOYDEqHORzwIYNQYI2SK8o5G8PAEYF2
        jkWtRxRACAEaigt4/8D6hMI4tFmrMjE=
X-Google-Smtp-Source: APXvYqzQqCU2xo001lRjilM3JaQEFqZixGaMDatfOnGtsSAWJpvjIp5vmrfxrsdf4UJvdzuqyOLYrQ==
X-Received: by 2002:a63:89c2:: with SMTP id v185mr11271354pgd.135.1578581118265;
        Thu, 09 Jan 2020 06:45:18 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id y6sm7943465pgc.10.2020.01.09.06.45.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 06:45:17 -0800 (PST)
Subject: Re: [RFC] Check if file_data is initialized
To:     Dmitrii Dolgov <9erthalion6@gmail.com>, io-uring@vger.kernel.org
References: <20200109131750.30468-1-9erthalion6@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c5db5cf5-4c31-af3d-57ac-fe025093b779@kernel.dk>
Date:   Thu, 9 Jan 2020 07:45:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200109131750.30468-1-9erthalion6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/9/20 6:17 AM, Dmitrii Dolgov wrote:
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index c770c2c0eb52..c5e69dfc0221 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1232,7 +1232,8 @@ static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
>  do_free:
>  	kmem_cache_free_bulk(req_cachep, rb->to_free, rb->reqs);
>  	percpu_ref_put_many(&ctx->refs, rb->to_free);
> -	percpu_ref_put_many(&ctx->file_data->refs, rb->to_free);
> +	if (ctx->file_data)
> +		percpu_ref_put_many(&ctx->file_data->refs, rb->to_free);
>  	rb->to_free = rb->need_iter = 0;
>  }

Can you check with just the two ref_put lines swapped? Ala:

	percpu_ref_put_many(&ctx->file_data->refs, rb->to_free);
  	percpu_ref_put_many(&ctx->refs, rb->to_free);

-- 
Jens Axboe


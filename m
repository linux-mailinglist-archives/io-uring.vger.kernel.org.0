Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFAD2DC28F
	for <lists+io-uring@lfdr.de>; Wed, 16 Dec 2020 15:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbgLPO5j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Dec 2020 09:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbgLPO5j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Dec 2020 09:57:39 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA7EC06179C
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 06:56:57 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id 3so2726842wmg.4
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 06:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Hpq2NwMWPf2E4TIE+LHUMuHeWD1kX1Iotyq5C1/b65Q=;
        b=ClJyhjiBhel3kBFRYSBeXujbqhStRibgc2VTeXyrvHi4ggGGxLYi99F+U5cW54Xedr
         0Rfd/hXn0n3uToyPIcePZZjHxT2QMwlLJFvhN78/J8KR5kQe4Uo4WpSVvWMhcoEvI8Wj
         mBAm7fOSu+0Jl426w/FnWGnBOByq6wP2YoMXbgUlL2fwZDAUeo0Q3yas/Pd89QP0NTZ1
         VKymCFTf2LF5m1/vujOMKRuBMassUAjQnX7zor0J2RuuKQ1empnodH3F9hvkOcRCQ4GU
         FDf9+VIYfeMoBB28Qkribd7QAwgyZ/GvUX4ZX6tGxXca9eD4z+yXfIO94Ir9jCNbNcp1
         Z3Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Hpq2NwMWPf2E4TIE+LHUMuHeWD1kX1Iotyq5C1/b65Q=;
        b=p9RZwA1tnvafhRQ7hB8dOq7PtQwVxE9AOfotjxm092oHzamdLy6lp+5baSg+y22oVX
         Nsc5ZSOtPMS8Tisbwla86RzgpcjZLDGMtojSUOpHxa57lf8326kdczWOuAl9t70ABtP3
         /6nbNZzBfqAg2ax0nqkw+3mSZluAqBAw1zM4x6ANGoZ5PlwNsPavr9iIyFNFkXVKxwjU
         flgLN4e/Wb80pngUU81vyTIfTRCpVvNmDC7jldDdmX81oFn5Utr+Rb1h7joACFo3B6CY
         O0DZIaVTO44aVuZYHDk5N/xfp6VuFfqBWYHHIeown6Aaet8J1w6h4p/EuclRSerQF68F
         Kl0w==
X-Gm-Message-State: AOAM530oSmn7lxgI8SVC1Vfwb3bUBYqxL4gA3eKSTp63dfetO6F8DSts
        0zfpXJBOdOS3YwPckg2uMBMgq7FvqwNaWg==
X-Google-Smtp-Source: ABdhPJxU6FcUE+cPC3hrDeHgPJtHiCzP8vMlgUtLQfe617+PLjIbfulla553t4tWgJouuJm+uv5tKA==
X-Received: by 2002:a1c:e3c4:: with SMTP id a187mr3756615wmh.58.1608130615922;
        Wed, 16 Dec 2020 06:56:55 -0800 (PST)
Received: from [192.168.8.128] ([185.69.144.225])
        by smtp.gmail.com with ESMTPSA id u7sm1798586wmu.47.2020.12.16.06.56.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 06:56:55 -0800 (PST)
Subject: Re: [PATCH v2 06/13] io_uring: generalize fixed_file_ref_node
 functionality
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1607379352-68109-7-git-send-email-bijan.mottahedeh@oracle.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <99458b93-b1b1-76f7-c190-953a01fa45dc@gmail.com>
Date:   Wed, 16 Dec 2020 14:53:35 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1607379352-68109-7-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/12/2020 22:15, Bijan Mottahedeh wrote:
> Split alloc_fixed_file_ref_node into resource generic/specific parts,
> rename destroy_fixed_file_ref_node, and factor out fixed_file_ref_node
> switching, to be be leveraged by fixed buffers.
> 
> Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
> ---
>  fs/io_uring.c | 34 +++++++++++++++++++++++++---------
>  1 file changed, 25 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 1ed63bc..126237e 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7672,7 +7672,7 @@ static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
>  		queue_delayed_work(system_wq, &ctx->rsrc_put_work, delay);
>  }
>  
> -static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
> +static struct fixed_rsrc_ref_node *alloc_fixed_rsrc_ref_node(
>  			struct io_ring_ctx *ctx)
>  {
>  	struct fixed_rsrc_ref_node *ref_node;
> @@ -7688,13 +7688,22 @@ static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
>  	}
>  	INIT_LIST_HEAD(&ref_node->node);
>  	INIT_LIST_HEAD(&ref_node->rsrc_list);
> +	ref_node->done = false;
> +	return ref_node;
> +}
> +
> +static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
> +			struct io_ring_ctx *ctx)
> +{
> +	struct fixed_rsrc_ref_node *ref_node;
> +
> +	ref_node = alloc_fixed_rsrc_ref_node(ctx);

if (!ref_node)
	return NULL;

>  	ref_node->rsrc_data = ctx->file_data;
>  	ref_node->rsrc_put = io_ring_file_put;
> -	ref_node->done = false;
>  	return ref_node;
>  }
>  
> -static void destroy_fixed_file_ref_node(struct fixed_rsrc_ref_node *ref_node)
> +static void destroy_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node)
>  {
>  	percpu_ref_exit(&ref_node->refs);
>  	kfree(ref_node);
> @@ -7870,6 +7879,17 @@ static inline int io_queue_file_removal(struct fixed_rsrc_data *data,
>  	return io_queue_rsrc_removal(data, (void *)file);
>  }
>  
> +static void switch_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node,
> +				       struct fixed_rsrc_data *data,
> +				       struct io_ring_ctx *ctx)
> +{
> +	percpu_ref_kill(&data->node->refs);
> +	spin_lock_bh(&ctx->rsrc_ref_lock);
> +	list_add_tail(&ref_node->node, &ctx->rsrc_ref_list);
> +	data->node = ref_node;
> +	spin_unlock_bh(&ctx->rsrc_ref_lock);
> +}
> +
>  static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>  				 struct io_uring_files_update *up,
>  				 unsigned nr_args)
> @@ -7946,14 +7966,10 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>  	}
>  
>  	if (needs_switch) {
> -		percpu_ref_kill(&data->node->refs);
> -		spin_lock_bh(&ctx->rsrc_ref_lock);
> -		list_add_tail(&ref_node->node, &ctx->rsrc_ref_list);
> -		data->node = ref_node;
> -		spin_unlock_bh(&ctx->rsrc_ref_lock);
> +		switch_fixed_rsrc_ref_node(ref_node, data, ctx);
>  		percpu_ref_get(&ctx->file_data->refs);
>  	} else
> -		destroy_fixed_file_ref_node(ref_node);
> +		destroy_fixed_rsrc_ref_node(ref_node);
>  
>  	return done ? done : err;
>  }
> 

-- 
Pavel Begunkov

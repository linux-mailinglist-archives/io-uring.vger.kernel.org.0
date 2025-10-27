Return-Path: <io-uring+bounces-10233-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B34AC0D473
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 12:51:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9261D19A7909
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 11:49:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CFF72FFDFA;
	Mon, 27 Oct 2025 11:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GLHlXzjB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD341D90DF
	for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 11:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761565678; cv=none; b=Ef82zZcdN0DOZvKs8Y6zebEteNrC0QS8i5H1iOTiJjDGGiBWnpjrhaCO7wyB8NLJxCSvCwi8e1L9XWw/W+z6Q/TN6t8f9QrP+U4hQe+R2xZfGlGrwPBM83pjlKyag2ohuEGuMHBlbBRF9WgXyqA10xbY3QjewXb5g+VD/vxmfCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761565678; c=relaxed/simple;
	bh=U9SNMx+fV+Va8o/LukhMQZHECepGfJmsPoivgTCQKFg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=VI4CZMu0dyKDfl4bF8+JfGLWl3VfvUixVTlj7NWhdfov8iH5ixu+6lRm/3UYIC8P8dCPXj4RRjxAc9TEvuSuFNV/tGDpwmrMj5AbcAJi2NEeYU2Ga9+Xoub13IyJlYKA8r1GvWnafuioNa/j6s/xLdURsQvahV+kYKgGkOKPBmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GLHlXzjB; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4711b95226dso56074625e9.0
        for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 04:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761565675; x=1762170475; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZWa46kCiP/0KhlYyyl/8q2vhghsnL07ZEKG4lLnpBpg=;
        b=GLHlXzjBIPx7UnNdTuy+VeVrFcd6LOFkXVGzJWJOc6VIUUE3Nu/m/c41Zrqq+4v9lq
         Ua4ElspusDr3CQyV7aM+LYyO1SdLaTfBWyWPkni1AnT4Wld/zIbjJpkMH8+NrMM0fBMF
         4gql1UZJpuV30brQK4Y32BBYOsWX7cSU7RRIBxDdOumY/Efh877anEtDjTB1z//otlfC
         vzslgcwH3vPhEXh5Gd4F1Q/jh/dOe5GgFhoVm6PrDCSu/RzNIL9IdeGJR+Ltb1nXlLKR
         5gyBfZww28GMmEQWoYYbprpYdzVvU7uY8Z0YUmHy7ANYRRA4SwlqD6pFGNqWY4Pp44xu
         LoJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761565675; x=1762170475;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZWa46kCiP/0KhlYyyl/8q2vhghsnL07ZEKG4lLnpBpg=;
        b=jjJfT76mw+Buo88yicokpqm3X/BXfZKeV8GllXC6C3qM60KJ1bt9O6jXmlRo/Yt/D3
         DV8pRjiCRQbzxImC9HWDAT3qWZToIjJ4NXb8VvSm2aB5+BarW04dI3SQMoqhyKktrR79
         dvx4tMDMtpAtXCbbO1rHPE4Ho48N/XW95AFR2gyVIQ0Kv/UAMDzacPKVSerapTG/1tQD
         oiienaXdj6f8JeLj6awvh+3VDtCyssch/Gxv/GwIzsD1r6/ohyhtuvmmw6c5vdQ5dUHm
         ro96TqrWJV89QirTYZOR0D4UO8Q5LWw5xFe80X4Bj0URa/BfcbX6ekc8EthF9RTI3KsH
         6D4g==
X-Forwarded-Encrypted: i=1; AJvYcCVRP7JSEkhU0kWM7AcCFPjghVrsmNymouVh7o3oi6dOTrLf+3yGR8p2jMcq92c2ancMrJkm5rGCdQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwWh4oeqboZOIwUicOSmyPJZyDOXWPS+CXGswjVUu3Q3O6OEemz
	eUoifKZFv3RnRNYhA3zhKnCM0GChPqUl1dnjwbSM2Gqb90uzClMwpYVH
X-Gm-Gg: ASbGncv4hZCIQvSjB8WDcNtXucG1zdhTddjS+FrYmc0Xzn2L2iF5PadPQXbdU3imLyO
	LdwvmWknB3My2plbNx4pf48o9Utnao1gXoqeTptMoJ3BLIFzKijnR965uhwVPwk2nVTEdtYH4bT
	+NK2+L/+5H3yiSDNmSyLCEWzvZybbl3TAfjmTjTsY4xvHRtJxOKMsDPi9phaEOUkUeYKpCOBO6B
	TOTY07iTScGx3xWdj7L0RhTLQFaI1uzDboYXcbxze0pgnRt1/EtNfQkZby/w12lrlNGP+RGQLbS
	dZfU5pyY5x+IaxJdTLGuIq3OY0tj/QKszzQgLL85w1MkNFz7UFnmG/I87Y0u5ytv2XKs6HN8Cmb
	P8XK6ZjSMTdnSwYcxCtCadp4ZicpEiWm6sndqZpMNxib9CDAey9KU+2r3u8rHjeJakEjgKdaEG9
	Na8YDskSjLZ4yagbWIdaXo3oGh44pcDuJa9VUgGxmhPBw=
X-Google-Smtp-Source: AGHT+IFuKsBzi+0bBlURymc3hSXFC5LQaTmO0O5eBsOEF/yGhEgbbdb0jNBilwg3MuycxW+6wEs8PA==
X-Received: by 2002:a05:600c:8410:b0:477:b83:7d1 with SMTP id 5b1f17b1804b1-4770b830926mr43938765e9.40.1761565675133;
        Mon, 27 Oct 2025 04:47:55 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:6fd4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952d3532sm14259036f8f.20.2025.10.27.04.47.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 04:47:54 -0700 (PDT)
Message-ID: <60f630cf-0057-4675-afcd-2b4e46430a44@gmail.com>
Date: Mon, 27 Oct 2025 11:47:51 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] io_uring/zcrx: share an ifq between rings
From: Pavel Begunkov <asml.silence@gmail.com>
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20251026173434.3669748-1-dw@davidwei.uk>
 <20251026173434.3669748-4-dw@davidwei.uk>
 <309cb5ce-b19a-47b8-ba82-e75f69fe5bb3@gmail.com>
Content-Language: en-US
In-Reply-To: <309cb5ce-b19a-47b8-ba82-e75f69fe5bb3@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/27/25 10:20, Pavel Begunkov wrote:
> On 10/26/25 17:34, David Wei wrote:
>> Add a way to share an ifq from a src ring that is real i.e. bound to a
>> HW RX queue with other rings. This is done by passing a new flag
>> IORING_ZCRX_IFQ_REG_SHARE in the registration struct
>> io_uring_zcrx_ifq_reg, alongside the fd of the src ring and the ifq id
>> to be shared.
>>
>> To prevent the src ring or ifq from being cleaned up or freed while
>> there are still shared ifqs, take the appropriate refs on the src ring
>> (ctx->refs) and src ifq (ifq->refs).
>>
>> Signed-off-by: David Wei <dw@davidwei.uk>
>> ---
>>   include/uapi/linux/io_uring.h |  4 ++
>>   io_uring/zcrx.c               | 74 ++++++++++++++++++++++++++++++++++-
>>   2 files changed, 76 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index 04797a9b76bc..4da4552a4215 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -1063,6 +1063,10 @@ struct io_uring_zcrx_area_reg {
>>       __u64    __resv2[2];
>>   };
>> +enum io_uring_zcrx_ifq_reg_flags {
>> +    IORING_ZCRX_IFQ_REG_SHARE    = 1,
>> +};
>> +
>>   /*
>>    * Argument for IORING_REGISTER_ZCRX_IFQ
>>    */
>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>> index 569cc0338acb..7418c959390a 100644
>> --- a/io_uring/zcrx.c
>> +++ b/io_uring/zcrx.c
>> @@ -22,10 +22,10 @@
>>   #include <uapi/linux/io_uring.h>
>>   #include "io_uring.h"
>> -#include "kbuf.h"
>>   #include "memmap.h"
>>   #include "zcrx.h"
>>   #include "rsrc.h"
>> +#include "register.h"
>>   #define IO_ZCRX_AREA_SUPPORTED_FLAGS    (IORING_ZCRX_AREA_DMABUF)
>> @@ -541,6 +541,67 @@ struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ctx,
>>       return ifq ? &ifq->region : NULL;
>>   }
>> +static int io_share_zcrx_ifq(struct io_ring_ctx *ctx,
>> +                 struct io_uring_zcrx_ifq_reg __user *arg,
>> +                 struct io_uring_zcrx_ifq_reg *reg)
>> +{
>> +    struct io_ring_ctx *src_ctx;
>> +    struct io_zcrx_ifq *src_ifq;
>> +    struct file *file;
>> +    int src_fd, ret;
>> +    u32 src_id, id;
>> +
>> +    src_fd = reg->if_idx;
>> +    src_id = reg->if_rxq;
>> +
>> +    file = io_uring_register_get_file(src_fd, false);
>> +    if (IS_ERR(file))
>> +        return PTR_ERR(file);
>> +
>> +    src_ctx = file->private_data;
>> +    if (src_ctx == ctx)
>> +        return -EBADFD;
>> +
>> +    mutex_unlock(&ctx->uring_lock);
>> +    io_lock_two_rings(ctx, src_ctx);
>> +
>> +    ret = -EINVAL;
>> +    src_ifq = xa_load(&src_ctx->zcrx_ctxs, src_id);
>> +    if (!src_ifq)
>> +        goto err_unlock;
>> +
>> +    percpu_ref_get(&src_ctx->refs);
>> +    refcount_inc(&src_ifq->refs);
>> +
>> +    scoped_guard(mutex, &ctx->mmap_lock) {
>> +        ret = xa_alloc(&ctx->zcrx_ctxs, &id, NULL, xa_limit_31b, GFP_KERNEL);
>> +        if (ret)
>> +            goto err_unlock;
>> +
>> +        ret = -ENOMEM;
>> +        if (xa_store(&ctx->zcrx_ctxs, id, src_ifq, GFP_KERNEL)) {
>> +            xa_erase(&ctx->zcrx_ctxs, id);
>> +            goto err_unlock;
>> +        }
> 
> It's just xa_alloc(..., src_ifq, ...);
> 
>> +    }
>> +
>> +    reg->zcrx_id = id;
>> +    if (copy_to_user(arg, reg, sizeof(*reg))) {
>> +        ret = -EFAULT;
>> +        goto err;
>> +    }
> 
> Better to do that before publishing zcrx into ctx->zcrx_ctxs
> 
>> +    mutex_unlock(&src_ctx->uring_lock);
>> +    fput(file);
>> +    return 0;
>> +err:
>> +    scoped_guard(mutex, &ctx->mmap_lock)
>> +        xa_erase(&ctx->zcrx_ctxs, id);
>> +err_unlock:
>> +    mutex_unlock(&src_ctx->uring_lock);
>> +    fput(file);
>> +    return ret;
>> +}
>> +
>>   int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
>>                 struct io_uring_zcrx_ifq_reg __user *arg)
>>   {
>> @@ -566,6 +627,8 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
>>           return -EINVAL;
>>       if (copy_from_user(&reg, arg, sizeof(reg)))
>>           return -EFAULT;
>> +    if (reg.flags & IORING_ZCRX_IFQ_REG_SHARE)
>> +        return io_share_zcrx_ifq(ctx, arg, &reg);
>>       if (copy_from_user(&rd, u64_to_user_ptr(reg.region_ptr), sizeof(rd)))
>>           return -EFAULT;
>>       if (!mem_is_zero(&reg.__resv, sizeof(reg.__resv)) ||
>> @@ -663,7 +726,7 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
>>               if (ifq)
>>                   xa_erase(&ctx->zcrx_ctxs, id);
>>           }
>> -        if (!ifq)
>> +        if (!ifq || ctx != ifq->ctx)
>>               break;
>>           io_zcrx_ifq_free(ifq);
>>       }
>> @@ -734,6 +797,13 @@ void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
>>           if (xa_get_mark(&ctx->zcrx_ctxs, index, XA_MARK_0))
>>               continue;
>> +        /*
>> +         * Only shared ifqs want to put ctx->refs on the owning ifq
>> +         * ring. This matches the get in io_share_zcrx_ifq().
>> +         */
>> +        if (ctx != ifq->ctx)
>> +            percpu_ref_put(&ifq->ctx->refs);
> 
> After you put this and ifq->refs below down, the zcrx object can get
> destroyed, but this ctx might still have requests using the object.
> Waiting on ctx refs would ensure requests are killed, but that'd
> create a cycle.

Another concerning part is long term cross ctx referencing,
which is even worse than pp locking it up. I mentioned
that it'd be great to reverse the refcounting relation,
but that'd also need additional ground work to break
dependencies.

> 
>> +
>>           /* Safe to clean up from any ring. */
>>           if (refcount_dec_and_test(&ifq->refs)) {
>>               io_zcrx_scrub(ifq);
> 

-- 
Pavel Begunkov



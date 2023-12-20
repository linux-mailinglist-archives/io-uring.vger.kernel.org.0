Return-Path: <io-uring+bounces-326-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A37498194F4
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 01:09:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0ADCEB22F04
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 00:09:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18D6923A4;
	Wed, 20 Dec 2023 00:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XzWaWIOL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9821FC9;
	Wed, 20 Dec 2023 00:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-553dc379809so51316a12.0;
        Tue, 19 Dec 2023 16:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703030954; x=1703635754; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wKuz/aOP9ywQDUYbzZm1chkeDVYYJSO+EMnUmdl7HN4=;
        b=XzWaWIOL9m5v6reBhKbeXZQ1jxkOmFnRX7UpLlPhqaGVnMfMOBZeOK9brXUjDl3Mld
         /JDu0ATVUCNyHhMGYdVMQireP1chG9SGcng/MADK4O59XSje3OuWxQcWo1gEN6Ke/XYo
         y+0BWL6f+B1f8TkCEuh6X57wGBcT4fhegkJUn3lAWjgGC1E2V1F8QTdPICsmjCvRv17r
         zwQxDo1PGo/K/ILnyYOjLhpEjIAYeZVLLnmbO79lLWpMYQjkLF0DDQrG5fwX8RSqHzMG
         YjpJT9wqPGaYkqkwm/ops9BtGnpdYASn+3GrGZHMcPvk7qyT6TpyGZLF/bpfEHfmsh2W
         dRkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703030954; x=1703635754;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wKuz/aOP9ywQDUYbzZm1chkeDVYYJSO+EMnUmdl7HN4=;
        b=gaHraXgjvcyLngF33yis0xOwC7/nYjlhDVXj7aRJQWHJDZz41exavtXfJqatwGElf5
         M+MUn0nqSAMbXuKwtZZAv16DK/gX7nPOl49vstJNeRXgnLZZv7FL9Gq7Br8TBfgMk3Wb
         QEbBA3MsLVUheDs4waD30qLJ6EBW1+GAGOGZtqEgG7kmhonG2m0hpgSql6QZTMdXgNq5
         y0uN8Ns/5XPYnE2tmVWH2ZZ8nMS0VLYXFfs36GnSzpw1OyseYOf5HRSuNYCaiWLwp8A5
         w+E53vgjtspYbhJI/rkdxKqz+Z+LM9a7IbC9ox1Nz1vg3xdHgzXNFbR05aju2Qgd6kzc
         yQ2g==
X-Gm-Message-State: AOJu0YxZ1e3CdMHFX/F27Z3/Gl0e0AAgdEXg1RvlANnyMx+82uQla7ve
	MaQW1Sv0gkR7uBMI5nuz3kw=
X-Google-Smtp-Source: AGHT+IE0G2yZ2IeunFWFpQccuueX64mIkPbkZGPwOb8cUCs6IjPoUXntqh1xYI6G5jypIyCp+chBmw==
X-Received: by 2002:a17:906:1054:b0:a26:8683:bc6c with SMTP id j20-20020a170906105400b00a268683bc6cmr573597ejj.36.1703030954570;
        Tue, 19 Dec 2023 16:09:14 -0800 (PST)
Received: from [192.168.8.100] ([85.255.233.166])
        by smtp.gmail.com with ESMTPSA id by16-20020a170906a2d000b00a234491b96asm3880252ejb.63.2023.12.19.16.09.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Dec 2023 16:09:14 -0800 (PST)
Message-ID: <e8e6e898-f69b-44c3-897b-a130b55175f1@gmail.com>
Date: Wed, 20 Dec 2023 00:04:13 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 14/20] net: page pool: add io_uring memory provider
Content-Language: en-US
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20231219210357.4029713-1-dw@davidwei.uk>
 <20231219210357.4029713-15-dw@davidwei.uk>
 <CAHS8izP0-BtwxJpO3A_th+XAgpVokz4FGFct9RCRFBrK4YiLNQ@mail.gmail.com>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izP0-BtwxJpO3A_th+XAgpVokz4FGFct9RCRFBrK4YiLNQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/19/23 23:39, Mina Almasry wrote:
> On Tue, Dec 19, 2023 at 1:04 PM David Wei <dw@davidwei.uk> wrote:
>>
>> From: Pavel Begunkov <asml.silence@gmail.com>
>>
>> Allow creating a special io_uring pp memory providers, which will be for
>> implementing io_uring zerocopy receive.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> Signed-off-by: David Wei <dw@davidwei.uk>
> 
> For your non-RFC versions, I think maybe you want to do a patch by
> patch make W=1. I suspect this patch would build fail, because the
> next patch adds the io_uring_pp_zc_ops. You're likely skipping this
> step because this is an RFC, which is fine.

Hmm? io_uring_pp_zc_ops is added is Patch 13, used in Patch 14.
Compiles well.


>> ---
>>   include/net/page_pool/types.h | 1 +
>>   net/core/page_pool.c          | 6 ++++++
>>   2 files changed, 7 insertions(+)
>>
>> diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
>> index fd846cac9fb6..f54ee759e362 100644
>> --- a/include/net/page_pool/types.h
>> +++ b/include/net/page_pool/types.h
>> @@ -129,6 +129,7 @@ struct mem_provider;
>>   enum pp_memory_provider_type {
>>          __PP_MP_NONE, /* Use system allocator directly */
>>          PP_MP_DMABUF_DEVMEM, /* dmabuf devmem provider */
>> +       PP_MP_IOU_ZCRX, /* io_uring zerocopy receive provider */
>>   };
>>
>>   struct pp_memory_provider_ops {
>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>> index 9e3073d61a97..ebf5ff009d9d 100644
>> --- a/net/core/page_pool.c
>> +++ b/net/core/page_pool.c
>> @@ -21,6 +21,7 @@
>>   #include <linux/ethtool.h>
>>   #include <linux/netdevice.h>
>>   #include <linux/genalloc.h>
>> +#include <linux/io_uring/net.h>
>>
>>   #include <trace/events/page_pool.h>
>>
>> @@ -242,6 +243,11 @@ static int page_pool_init(struct page_pool *pool,
>>          case PP_MP_DMABUF_DEVMEM:
>>                  pool->mp_ops = &dmabuf_devmem_ops;
>>                  break;
>> +#if defined(CONFIG_IO_URING)
>> +       case PP_MP_IOU_ZCRX:
>> +               pool->mp_ops = &io_uring_pp_zc_ops;
>> +               break;
>> +#endif
>>          default:
>>                  err = -EINVAL;
>>                  goto free_ptr_ring;
>> --
>> 2.39.3
>>
> 
> 
> --
> Thanks,
> Mina

-- 
Pavel Begunkov


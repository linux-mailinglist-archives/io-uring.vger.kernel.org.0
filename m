Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5D9787567
	for <lists+io-uring@lfdr.de>; Thu, 24 Aug 2023 18:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242560AbjHXQbf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Aug 2023 12:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242605AbjHXQbW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Aug 2023 12:31:22 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4F519A4
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 09:31:17 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-99bfcf4c814so908293066b.0
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 09:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692894676; x=1693499476;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3oCtJCmTYpNYDwHB76WPExfg4gwTPGX7JtSkXIFuTWU=;
        b=TBRU5mzJLchfE/2a4Q8rbvIOrIvzM8HLekaPcFV2HUMGfZsgob5QTZwyNHtJhFtIUj
         Vz/sODTSFDnPJHUJkeS0FmV3JlXe1mLK+BbzFoLjtICNkhEsJWzZktUqvOjOYCJQWu2U
         XTMgiL/FQhxotH5+4BogT4BdD0AioTnzcQofejjGMV4lM+63qQHAEFusaJglhnGhh/Y/
         ExQNjGDy+SgOYydTtzfi5GAHmrGIIhfSCV9Eeum9dhD0s1DgGmMbB+XBT0rp6wfIz/tz
         gu9JtrE2DYz/5sPscFuTmd9PfTpr6LaD4EeViIeNk5QE2gW1sUeM28xa3nRbyRZsmPEA
         mMJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692894676; x=1693499476;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3oCtJCmTYpNYDwHB76WPExfg4gwTPGX7JtSkXIFuTWU=;
        b=ghDmznctvWc02QNVtoMm+Mj1auZN5J65sG3ohA9PIfZuNhQ3QaEw5OGwhKz1GyRKZC
         BzokdHPC9bNlklVFt402xDT13fcV8CDoMovWHrEhedUJkAekgXo+VnWWMxwWzoIdqRu5
         PPHnqnueRm5k4gXhkbfAmxq2FRTW2afN96kTMcVoXOY3DZHUpy4b0gstV2Sp1QhQIFze
         EnzyknQCWbSGv70q5s9wBFNyrqrJ7Aycw3p70N2gyhTzJSKuO/jA0/yXELaTcE3v7thd
         D+dmJWI0iwFhLe6hsAaf8uIsNyCryFIqHk2sS+CkFZH7BSenOL9MSXlvEL+ePFFhhVo+
         MCIQ==
X-Gm-Message-State: AOJu0Yw38HGJLUGAUVVuMXpVe293L3ZtxPAKFj8haMXSo6L7V8Av9Y9i
        CyOFG9+dHt3VFG6iBehWOm0JNyITMas=
X-Google-Smtp-Source: AGHT+IEKDNuLSJR+S4WnlmrBW85Hwwr4M/E9k9j0ep+2gJIHmWG4ZXpvGmWBtSE++6Xg8Xeu4oAsUQ==
X-Received: by 2002:a17:906:1dd:b0:9a0:9558:82a3 with SMTP id 29-20020a17090601dd00b009a0955882a3mr14255690ejj.58.1692894675304;
        Thu, 24 Aug 2023 09:31:15 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.140.69])
        by smtp.gmail.com with ESMTPSA id bs9-20020a170906d1c900b0099bcd1fa5b0sm11090447ejb.192.2023.08.24.09.31.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Aug 2023 09:31:15 -0700 (PDT)
Message-ID: <b36af67b-5160-c9c8-aa70-669da4f1d797@gmail.com>
Date:   Thu, 24 Aug 2023 17:28:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/16] io_uring: cqe init hardening
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1692119257.git.asml.silence@gmail.com>
 <731ecc625e6e67900ebe8c821b3d3647850e0bea.1692119257.git.asml.silence@gmail.com>
 <2ef18cd5-c8a6-4a5e-8b9c-139604d6d51a@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <2ef18cd5-c8a6-4a5e-8b9c-139604d6d51a@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/19/23 16:03, Jens Axboe wrote:
> On 8/15/23 11:31 AM, Pavel Begunkov wrote:
>> io_kiocb::cqe stores the completion info which we'll memcpy to
>> userspace, and we rely on callbacks and other later steps to populate
>> it with right values. We have never had problems with that, but it would
>> still be safer to zero it on allocation.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   io_uring/io_uring.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index e189158ebbdd..4d27655be3a6 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -1056,7 +1056,7 @@ static void io_preinit_req(struct io_kiocb *req, struct io_ring_ctx *ctx)
>>   	req->link = NULL;
>>   	req->async_data = NULL;
>>   	/* not necessary, but safer to zero */
>> -	req->cqe.res = 0;
>> +	memset(&req->cqe, 0, sizeof(req->cqe));
>>   }
>>   
>>   static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
> 
> I think this is a good idea, but I wonder if we should open-clear it
> instead. I've had cases in the past where that's more efficient than
> calling memset.

I don't think it ever happens for 16 byte memcpy, and in either
case it's a cache refill, quite a slow path. I believe memcpy is
better here.

-- 
Pavel Begunkov

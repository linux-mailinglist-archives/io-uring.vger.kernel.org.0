Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD44781A49
	for <lists+io-uring@lfdr.de>; Sat, 19 Aug 2023 17:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbjHSPDI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Aug 2023 11:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233680AbjHSPDI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Aug 2023 11:03:08 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5ADCC
        for <io-uring@vger.kernel.org>; Sat, 19 Aug 2023 08:03:06 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id 5614622812f47-3a3ee866e00so283136b6e.0
        for <io-uring@vger.kernel.org>; Sat, 19 Aug 2023 08:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1692457386; x=1693062186;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MAY997fXoyPSFCZfMAgmSLmy9nyfpk76PaxqbrKjKVA=;
        b=AnA+NswH+Hxx637ZtabdWGpdXY0ATQN1Vr4AfVZbXeKtqITcyiHBR6L+JksUvnZ+54
         35x7etgRwC/Lux43m5LevkJClmRcVblAOMYJSG3XL/ezdJGpcdK5PT298iUDfKvRzceg
         sq1ajH1mznmEB8/9FYc39HierO+Kj1QJU/0aOoGpBat5bpNv6DDy1vcUarQ6UeJC8+rl
         JulU+9vUFF6+g4RpYfgYNK3si0tIOaJBFfxL7dvGl2X+zsQcMbiXCg3AsA+p9WSOnAsT
         DcAMcpc7No2LRxC7nG655gLfth4iZ15yXE+E8A4mIqzmySQrZ6fiTfUMvBAmGv0ouyg1
         tSDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692457386; x=1693062186;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MAY997fXoyPSFCZfMAgmSLmy9nyfpk76PaxqbrKjKVA=;
        b=lBBUMN2QUNesF+4u5Fpgdr25u9juR0atna+7foUx1xcsqIw/jDLW5dpbgJhkAqjASH
         uOpNr534BFEojO7nBHkTWELPWcMRVp7sCirPcLhXOMSIOEAe2yPDyEC/hto6KaCTnA6d
         sFKK3DdFCOGIS6DuYNVIP9YFHTVXlk0KmMm3TthHig9gr1WTBwYiuWKEjGmcpgqTijtS
         y1j/ZRxTqTrS5CaOyXDCcYeNWtcsA+b997DKsVVl/dsVZ5Rz6VZkeRXH4hxprG/QOLAG
         lh6BaepCzOww8Z4JpXhn+646695nuKJ9C+BL0Xd8lyKjuwlgYAthtcKe09Y682qAOsKF
         y2MQ==
X-Gm-Message-State: AOJu0YyhMWumI7+pd3q5FqpYWKAHouXxq2Wh1bD7TewyxcBNaGxU4N3k
        tCXw2uJeUsjOvUoM1hG99tPOf7PJV6V/oHjhRHA=
X-Google-Smtp-Source: AGHT+IHbZnsjISFKjSVqcJiLw/qqImjY9/15+jwlsHEgxnTDt8LgbXtxYmUxabaMxPg5Gr14ewKp7Q==
X-Received: by 2002:a05:6808:30a7:b0:3a7:2eb4:ce04 with SMTP id bl39-20020a05680830a700b003a72eb4ce04mr3243014oib.5.1692457386037;
        Sat, 19 Aug 2023 08:03:06 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id bu30-20020a63295e000000b0056456fff676sm3410406pgb.66.2023.08.19.08.03.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Aug 2023 08:03:05 -0700 (PDT)
Message-ID: <2ef18cd5-c8a6-4a5e-8b9c-139604d6d51a@kernel.dk>
Date:   Sat, 19 Aug 2023 09:03:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/16] io_uring: cqe init hardening
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1692119257.git.asml.silence@gmail.com>
 <731ecc625e6e67900ebe8c821b3d3647850e0bea.1692119257.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <731ecc625e6e67900ebe8c821b3d3647850e0bea.1692119257.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/15/23 11:31 AM, Pavel Begunkov wrote:
> io_kiocb::cqe stores the completion info which we'll memcpy to
> userspace, and we rely on callbacks and other later steps to populate
> it with right values. We have never had problems with that, but it would
> still be safer to zero it on allocation.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index e189158ebbdd..4d27655be3a6 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1056,7 +1056,7 @@ static void io_preinit_req(struct io_kiocb *req, struct io_ring_ctx *ctx)
>  	req->link = NULL;
>  	req->async_data = NULL;
>  	/* not necessary, but safer to zero */
> -	req->cqe.res = 0;
> +	memset(&req->cqe, 0, sizeof(req->cqe));
>  }
>  
>  static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,

I think this is a good idea, but I wonder if we should open-clear it
instead. I've had cases in the past where that's more efficient than
calling memset.

-- 
Jens Axboe


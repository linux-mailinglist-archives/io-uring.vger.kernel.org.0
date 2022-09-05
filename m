Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA8EB5AD1B4
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 13:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236202AbiIELmm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 07:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238141AbiIELml (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 07:42:41 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5115D5C34C;
        Mon,  5 Sep 2022 04:42:39 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id u9so16546366ejy.5;
        Mon, 05 Sep 2022 04:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Vllfxcnhs9OfIM3TW4UNvTfKmafbGxf3KdCROHXKN8A=;
        b=ZmvWAAJ7c4+BHEsjiaprB7htjTLDbMlry2Z/c+ExPQyAIiLlgIVRrI0MvElSRbVtqg
         nQpcHsWOTiWfyit/prQK21kqFBahi4hmrPY7sD1a1ATX1uDrqifs5DhLWUrSdWJr5815
         RS736w0rTdZJO5soxkdOqRqMJpPBEBUhnRWL3A9pHKqYDLWn3nZNFiD7LH6SqyLNTqE8
         sl+guaEVd8LMTl0w3jqjNQfsD9/pvelEBJ5W5u0iKULu3+uZw9uYqh3gv2SqIrjTbfF5
         z/0SQgkmLOiCj8kRv3FIfiiaaOXFudSkyU+rtO1lXoBKbRV6njNAY4gLXqzuYLV7ZEgm
         v5ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Vllfxcnhs9OfIM3TW4UNvTfKmafbGxf3KdCROHXKN8A=;
        b=uOGE4L1wgh7V7JIzLPo/2PX/vyaVG99rrOCf2ogBq+GuO7TNVwVlJjDWkcfmegTCEV
         OQnWGv+1JnIlrGz3VPlk/fxKnWy7htB3o63ADfXmBd8a7IGkIDYUWKxmIRaw8qowV4dW
         wNjxScIpOP81Rk9oGl0WtpyTqUqvWel4N6ZQPsOefVbOphLpLwTkSIObZpXJqUTMCvwl
         VIYsrxM/ZcDnPCZGRz9hYiSTj4Ivu9CwVpjGvyjPonVne5P/kTFRMYs6GESji9IjSMPB
         ktwYPhs7VZzuurJtCepiNqKrB+Pu0oeI4DZCV4JmetdhES4gHpiAdbXCWircdh2lf6yh
         LovA==
X-Gm-Message-State: ACgBeo2/bzuqGCorp456DUzLI3EaPALKaknAtamBmBRNW85GF4LNqRjF
        OkZ67nriS5gRGlaUIqp9wsISIxxh9RU=
X-Google-Smtp-Source: AA6agR7kngSpBTnmierD9JfvVK7jS1367pXPg5TONv6zLkBmoFPToyz+AARL0661stTFZakhyd/G6Q==
X-Received: by 2002:a17:907:72cd:b0:741:905e:9150 with SMTP id du13-20020a17090772cd00b00741905e9150mr25290026ejc.88.1662378157758;
        Mon, 05 Sep 2022 04:42:37 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:a118])
        by smtp.gmail.com with ESMTPSA id i19-20020a50fc13000000b00446639c01easm6323449edr.44.2022.09.05.04.42.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Sep 2022 04:42:37 -0700 (PDT)
Message-ID: <e55fa28e-6f9c-dcb4-3406-95dfbea8387a@gmail.com>
Date:   Mon, 5 Sep 2022 12:41:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] io_uring/notif: Remove the unused function
 io_notif_complete()
Content-Language: en-US
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
References: <20220905020436.51894-1-jiapeng.chong@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220905020436.51894-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/5/22 03:04, Jiapeng Chong wrote:
> The function io_notif_complete() is defined in the notif.c file, but not
> called elsewhere, so delete this unused function.

Yep, forgot to kill it, LGTM

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>


> io_uring/notif.c:24:20: warning: unused function 'io_notif_complete' [-Wunused-function].
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2047
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>   io_uring/notif.c | 8 --------
>   1 file changed, 8 deletions(-)
> 
> diff --git a/io_uring/notif.c b/io_uring/notif.c
> index 96f076b175e0..1a7abd7e5ca5 100644
> --- a/io_uring/notif.c
> +++ b/io_uring/notif.c
> @@ -21,14 +21,6 @@ static void __io_notif_complete_tw(struct io_kiocb *notif, bool *locked)
>   	io_req_task_complete(notif, locked);
>   }
>   
> -static inline void io_notif_complete(struct io_kiocb *notif)
> -	__must_hold(&notif->ctx->uring_lock)
> -{
> -	bool locked = true;
> -
> -	__io_notif_complete_tw(notif, &locked);
> -}
> -
>   static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
>   					  struct ubuf_info *uarg,
>   					  bool success)

-- 
Pavel Begunkov

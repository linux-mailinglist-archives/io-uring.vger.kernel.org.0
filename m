Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986F977642B
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 17:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjHIPkU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 11:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbjHIPkU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 11:40:20 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E10211F
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 08:40:19 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-99bcc0adab4so1002408766b.2
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 08:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691595618; x=1692200418;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H2FB45Wu159Pl/DJ+j0gdFnq7DdaxRPxrpG6Bl6Tr8M=;
        b=eeKoiIB8+Bifi1Stlwt3arOtdno3w4ORUAppHR9Zi27Yr2cytwWf7YwPdg8IZSxUZo
         NDA/FVsKEhuadBu93hEviLa+EtmpUwM1SIYIMQMERzUsHuLbLe87xLItGUTRq52egu3M
         E/fuQcCTe7oXX/uDIjQLj60fcSjc9NmbFylkLwiq1mWTGjUKzIK26SBwLZ5LoNK6Rtib
         JpToIB2oeszXifRvdxcHKoBG2uadL5rK/lU4hTsnXSBV8XEbgfjUfBEp4kMgyfwrHCmD
         sQcHpdfA5s5MiGvvJVt16qwO77azM2MbuvzxLj+njar/g8GXrmHqR+KbTwTHxG+Vu7z0
         BZVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691595618; x=1692200418;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H2FB45Wu159Pl/DJ+j0gdFnq7DdaxRPxrpG6Bl6Tr8M=;
        b=YYoKuI/HR+Uxxsqbz0tvHpS8U8zg+7ydJUyyqLZCnTZiDneathLCLaLQXeNOajW6fp
         FWQY9RjfQveveWygDpkBwTAh9NRQd4M3nKlN67Z3RgHrOBzTdTx/IPxx9i9JyG5MWHT1
         w/+vsKVcVxgtew+uyymCA0zsJrXAIR+fU71MvZVuT0n+ZpXBwIsfd1gjZc4O8ruHjX00
         6Q+2+Zd8QMTY+AJG42sV+xWoGcZsTIYUy/s0u5m9pG78IP8RyHNQCQpNywuHMBfL7/ou
         RkksYKEkVEXE2pHfAs5kQ9UUEQxgdlITeVPDF59z/KdXIOkV+bjeS3LMDfE6ItmRmyES
         PxWQ==
X-Gm-Message-State: AOJu0Yzy3sH3fFp6pZdgKFFSrPy6uZ6/e1OGrdh47VuGi6hQATWXOpnH
        IZdlMsaKPiPRu1LWVavzU+tdGc48E74=
X-Google-Smtp-Source: AGHT+IGDbaAkH9CQI1XvPraTnzw5Vc8Kqo/+Pg7N0LeT0lvTKxtCEm7oEtvDYHFy+5nTnKLtZSwFlg==
X-Received: by 2002:a17:907:788e:b0:99c:6671:66fa with SMTP id ku14-20020a170907788e00b0099c667166famr2379788ejc.51.1691595617639;
        Wed, 09 Aug 2023 08:40:17 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:c27f])
        by smtp.gmail.com with ESMTPSA id a3-20020a170906368300b00989027eb30asm8210188ejc.158.2023.08.09.08.40.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 08:40:17 -0700 (PDT)
Message-ID: <b2b63fdc-d683-aaa1-8938-01665f99713a@gmail.com>
Date:   Wed, 9 Aug 2023 16:38:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: break iopolling on signal
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <eeba551e82cad12af30c3220125eb6cb244cc94c.1691594339.git.asml.silence@gmail.com>
 <8d0fcef6-605c-4f67-8fc6-01065eedf725@kernel.dk>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8d0fcef6-605c-4f67-8fc6-01065eedf725@kernel.dk>
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

On 8/9/23 16:30, Jens Axboe wrote:
> On 8/9/23 9:20 AM, Pavel Begunkov wrote:
>> Don't keep spinning iopoll with a signal set. It'll eventually return
>> back, e.g. by virtue of need_resched(), but it's not a nice user
>> experience.
> 
> I wonder if we shouldn't clean it up a bit while at it, the ret clearing
> is kind of odd and only used in that one loop? Makes the break
> conditions easier to read too, and makes it clear that we're returning
> 0/-error rather than zero-or-positive/-error as well.

We can, but if we're backporting, which I suggest, let's better keep
it simple and do all that as a follow up.

fwiw, this function was responsible for initial uring_lock locking
back in the day I believe, that's why it is how it is.


> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 8681bde70716..ec575f663a82 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1637,7 +1637,6 @@ static __cold void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
>   static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
>   {
>   	unsigned int nr_events = 0;
> -	int ret = 0;
>   	unsigned long check_cq;
>   
>   	if (!io_allowed_run_tw(ctx))
> @@ -1663,6 +1662,8 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
>   		return 0;
>   
>   	do {
> +		int ret = 0;
> +
>   		/*
>   		 * If a submit got punted to a workqueue, we can have the
>   		 * application entering polling for a command before it gets
> @@ -1692,12 +1693,16 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
>   		}
>   		ret = io_do_iopoll(ctx, !min);
>   		if (ret < 0)
> -			break;
> +			return ret;
>   		nr_events += ret;
> -		ret = 0;
> -	} while (nr_events < min && !need_resched());
>   
> -	return ret;
> +		if (task_sigpending(current))
> +			return -EINTR;
> +		if (need_resched())
> +			break;
> +	} while (nr_events < min);
> +
> +	return 0;
>   }
>   
>   void io_req_task_complete(struct io_kiocb *req, struct io_tw_state *ts)
> 

-- 
Pavel Begunkov

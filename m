Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4185F6FF5
	for <lists+io-uring@lfdr.de>; Thu,  6 Oct 2022 23:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbiJFVLK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Oct 2022 17:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbiJFVLJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Oct 2022 17:11:09 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D680B0B20
        for <io-uring@vger.kernel.org>; Thu,  6 Oct 2022 14:11:05 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id n12so4484948wrp.10
        for <io-uring@vger.kernel.org>; Thu, 06 Oct 2022 14:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N/DPlaVrpsGh5oyLs678x6eB1BviOeqoUCvIpXR+lpA=;
        b=qkQLJeu67zJNTF/9odLdmmoQ/x7SvRkqxtAzu9FAlk9VbK1B9V6lBHcScg2810Z18r
         jYa7jfX0jM6rU2xOheyGUqWMWMhkZVCRP/dgL3xvj2Pe+NSs1NfFHdGYbNSo6ebjaz0f
         ADgEPEFAPv3L2ObaxlBN/5THphpD0NKEMBa9frYuBk/L2nHxhpdRwI92jRij4z3y2uWr
         5RtWEGmFxE4nb1JxxNBypDTRdg7X92QyaAvT5M/riIq3WIHanUG06PNHHf0fie0aG40V
         SgSRV3gUxFri8eSqg6QzavTiO882n+6AaIuuSL11F66BfHPT7Jh9PFDA39cG76uyjez9
         39eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N/DPlaVrpsGh5oyLs678x6eB1BviOeqoUCvIpXR+lpA=;
        b=GTbTTtpS+4OgMC5kGVUqya0v5WwdFLOZ6wlnlq+hssGoK1W63Motsln6SUPNkzIvRO
         dCqXTICl00sAcJp71TBAG3jHC9dWI+30vZOgiAol4Cj5Xt0q3FkUEocx7d0AmGUuK+1e
         cWEkSr8xuiLCnunpGPetVgyNAFfKfI4/ytfS7CIxQHvOPzxkw8ZZFPx9j9hhOPE/vZ7x
         lYWR1a9BSxCrHwH05wNBjcdKBvibuvHkxvkxDfgp+ypztqW2+SedT/QF1iBig+9hRh7W
         dEOAPV+T54bNx+w/U6ud//gRDUxgZG0F+y8mfva0a96WH/rzNNPK1JTLzUiuA7TaNEUv
         T2Tw==
X-Gm-Message-State: ACrzQf3/xzktR49FzZXIl2zNoCV5vlFn/1hHKmf1m2Gw7f0h4PN+RT6i
        IgaAt+j/TZktGCE+OAd8qmw=
X-Google-Smtp-Source: AMsMyM7hOtav4iAA/cgxejYPfrGbKmIawAeBUP4A4v3mfwZTxzvn8qSQMxbNmpFIi73pxPVqwVid5g==
X-Received: by 2002:a05:6000:1861:b0:22a:bb41:886d with SMTP id d1-20020a056000186100b0022abb41886dmr1127465wri.661.1665090663945;
        Thu, 06 Oct 2022 14:11:03 -0700 (PDT)
Received: from [192.168.8.100] (94.196.209.4.threembb.co.uk. [94.196.209.4])
        by smtp.gmail.com with ESMTPSA id p17-20020a5d4591000000b0022e32f4c06asm384369wrq.11.2022.10.06.14.11.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Oct 2022 14:11:03 -0700 (PDT)
Message-ID: <dce342ce-644c-5bcf-3d18-c313cd21887f@gmail.com>
Date:   Thu, 6 Oct 2022 22:09:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 1/1] io_uring: optimise locking for local tw with
 submit_wait
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Dylan Yudaken <dylany@fb.com>
References: <281fc79d98b5d91fe4778c5137a17a2ab4693e5c.1665088876.git.asml.silence@gmail.com>
 <0dbacebb-48bc-4254-6ad5-c00e6d54de8b@kernel.dk>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0dbacebb-48bc-4254-6ad5-c00e6d54de8b@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/6/22 21:59, Jens Axboe wrote:
> On 10/6/22 2:42 PM, Pavel Begunkov wrote:
>> Running local task_work requires taking uring_lock, for submit + wait we
>> can try to run them right after submit while we still hold the lock and
>> save one lock/unlokc pair. The optimisation was implemented in the first
>> local tw patches but got dropped for simplicity.
>>
>> Suggested-by: Dylan Yudaken <dylany@fb.com>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   io_uring/io_uring.c | 12 ++++++++++--
>>   io_uring/io_uring.h |  7 +++++++
>>   2 files changed, 17 insertions(+), 2 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 355fc1f3083d..b092473eca1d 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -3224,8 +3224,16 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>>   			mutex_unlock(&ctx->uring_lock);
>>   			goto out;
>>   		}
>> -		if ((flags & IORING_ENTER_GETEVENTS) && ctx->syscall_iopoll)
>> -			goto iopoll_locked;
>> +		if (flags & IORING_ENTER_GETEVENTS) {
>> +			if (ctx->syscall_iopoll)
>> +				goto iopoll_locked;
>> +			/*
>> +			 * Ignore errors, we'll soon call io_cqring_wait() and
>> +			 * it should handle ownership problems if any.
>> +			 */
>> +			if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
>> +				(void)io_run_local_work_locked(ctx);
>> +		}
>>   		mutex_unlock(&ctx->uring_lock);
>>   	}
>>   
>> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
>> index e733d31f31d2..8504bc1f3839 100644
>> --- a/io_uring/io_uring.h
>> +++ b/io_uring/io_uring.h
>> @@ -275,6 +275,13 @@ static inline int io_run_task_work_ctx(struct io_ring_ctx *ctx)
>>   	return ret;
>>   }
>>   
>> +static inline int io_run_local_work_locked(struct io_ring_ctx *ctx)
>> +{
>> +	if (llist_empty(&ctx->work_llist))
>> +		return 0;
>> +	return __io_run_local_work(ctx, true);
>> +}
> 
> Do you have pending patches that also use this? If not, maybe we
> should just keep it in io_uring.c? If you do, then this looks fine
> to me rather than needing to shuffle it later.

No, I don't. I'd argue it's better as a helper because at least it
hides always confusing bool argument, and we'd also need to replace
a similar one in io_iopoll_check(). Add we can stick must_hold there
for even more clarity. But ultimately I don't care much.

-- 
Pavel Begunkov

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1E78665E40
	for <lists+io-uring@lfdr.de>; Wed, 11 Jan 2023 15:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbjAKOqN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Jan 2023 09:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbjAKOqL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Jan 2023 09:46:11 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E868A634B
        for <io-uring@vger.kernel.org>; Wed, 11 Jan 2023 06:46:09 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id jo4so37412724ejb.7
        for <io-uring@vger.kernel.org>; Wed, 11 Jan 2023 06:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d5VK5KaCGPX13Iha5pZaFLsVEphZZLsA28Nqq+aJbT8=;
        b=K1jpb8jguKA13lHwElFdw8xycFxUGVVKSkz/U7OLyqKKfDM7l2HJx1mKpIM51yaP0B
         6ASs8vHF3I1Pq5idrBlbDZQ1EM7Kn5d45ya2Y7F6j2va5ZrGNG/JqzSOCWx9UFbdKdGg
         QOVZTirg9V9WOZj7nqrdIGXUKPdu1SWtpZu/FFiZTiH8ZrGLRHuCgphpBbI2C5f6rrKr
         T/tJqfgq8hKztOzvp4zUcqzB0HvI6Quu0Dmw7y73B8LJ4wzNBG4c0oSvcAvXB/D/wX5y
         DYnvcpPT8ffIxxBxIUx3jJuftFHDyu9ATF14Cu9IuDByJM7bcgZrF0VVLj5rfKsPmOMa
         mlGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d5VK5KaCGPX13Iha5pZaFLsVEphZZLsA28Nqq+aJbT8=;
        b=O+99ILb2O+BHEeuQuY+9iWFBy95r6fulEhFQply/xxcJU9F93nPBczIklWMrPXs+Bh
         j9oappZh1rDCNSWH5hf79OIZzUUc+o2QNuUByZOlDJbckfabxEYawC90TOa1oR4eAH+C
         2tzfrHkqMvfGhoyYcKdAy5QUvnRW4uFi3IQ2l8zV7BuBidE7ZphrtVfNSotDi433JCQM
         2K5Hp4/vPoQcNXSZC9G4rxZ00sqarhitewMp4OFndh+jMOzMlSj5FUUw6kjKPFwdTvH/
         hTB8xP71LICbAquk0GD5Z8ckEp13WEYJ6t5yo9Psj1ATLwxnRp3nEO0ONDdhIUaubCSv
         Wqmg==
X-Gm-Message-State: AFqh2ko6h0bnbIyxO5XODozodjxtux0R1ac6DShKSTLHrqJsjmZ7OKB4
        J07yP3C5FgywlPe6ZdO9gmxPcL/i/pQ=
X-Google-Smtp-Source: AMrXdXs7QiKWJl9dZid99ouJKJIuI2onGHsgVXqzyP7M+rp1fVSxQdRAJuMmowmdvrn0+o8S8EWWTA==
X-Received: by 2002:a17:907:7f8a:b0:7c0:e4b7:517e with SMTP id qk10-20020a1709077f8a00b007c0e4b7517emr86373177ejc.16.1673448368345;
        Wed, 11 Jan 2023 06:46:08 -0800 (PST)
Received: from [192.168.8.100] (188.31.114.68.threembb.co.uk. [188.31.114.68])
        by smtp.gmail.com with ESMTPSA id v27-20020a17090606db00b0081d2d9a0b45sm6218072ejb.186.2023.01.11.06.46.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 06:46:07 -0800 (PST)
Message-ID: <16fc0544-5f1c-a246-61be-da8b5aa7375d@gmail.com>
Date:   Wed, 11 Jan 2023 14:44:44 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2] io_uring: fix CQ waiting timeout handling
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <f7bffddd71b08f28a877d44d37ac953ddb01590d.1672915663.git.asml.silence@gmail.com>
 <3ed001f3-a33c-cc69-be47-d5318de5ddcd@linux.alibaba.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3ed001f3-a33c-cc69-be47-d5318de5ddcd@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/11/23 06:39, Xiaoguang Wang wrote:
> hello,
> 
>>   	/*
>> @@ -2564,7 +2564,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>>   		}
>>   		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
>>   						TASK_INTERRUPTIBLE);
>> -		ret = io_cqring_wait_schedule(ctx, &iowq, timeout);
>> +		ret = io_cqring_wait_schedule(ctx, &iowq, &timeout);
>>   		if (__io_cqring_events_user(ctx) >= min_events)
>>   			break;
>>   		cond_resched();
> Does this bug result in any real issues?
> io_cqring_wait_schedule() calls schedule_hrtimeout(), but seems that
> schedule_hrtimeout() and its child functions don't modify timeout or expires
> at all, so I wonder how this patch works. Thanks.

Looked it up, you're right, I guess passing a pointer and one example
using it this way convinced me that it should be the case. Even more
interesting that as there is only HRTIMER_MODE_ABS and no relative
modes as before (IIRC) it wasn't a bug in the first place. Thanks
for taking a look

-- 
Pavel Begunkov

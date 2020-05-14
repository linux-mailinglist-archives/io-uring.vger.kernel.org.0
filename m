Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28B11D35A2
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2020 17:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgENPxY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 May 2020 11:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgENPxX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 May 2020 11:53:23 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4960C061A0C
        for <io-uring@vger.kernel.org>; Thu, 14 May 2020 08:53:23 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t9so12736271pjw.0
        for <io-uring@vger.kernel.org>; Thu, 14 May 2020 08:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TUnOuWpDZrQI3eDMwaRbY1bk7jojEaJugTM4T/ybTj4=;
        b=Tit7wRwiXxxjsRQgnFp4MOgdGdSGEMwuP8p7grSZuopaO8UN80w4QvZPtRwntbQrbV
         yI2p5t9ArHbMdon7jj6TIq/CBZSM2/iCCihNNJH7Mz0uvYTMJQ3cV/f62jo91MG3e+kq
         goKhrbgrnSH8sdBcENtK3ZHmHgXmgL8Jooog/O9TIvlqO79RIfUZ7HM6hLgFbcnS4jo3
         WX0nH0K2718dPU9OQb2aAlFLnHTIRCQmIHyfA8XSJy0oCd0ueK78L3MZ4Xik1vy+Xdd3
         YZVN1mZyXbNwLaplbI4nQ4AEuxgDALAwFF/KL40gfChE2kdaNmOd42QiNNZjVMTSPyUA
         80FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TUnOuWpDZrQI3eDMwaRbY1bk7jojEaJugTM4T/ybTj4=;
        b=M3dyd3rXKVwpwJoYUdZWf31x2iZPp1DAE1cp9W4VCo3R9NE0F57k0MSwkxMO6Ncvwc
         CqUN4ln4rAIgYaF3R7SbOcsz1jEC28rfsz1cMK7xUI7ncXIiLsbxqRYKHpJ45pVQ+mr3
         ru0Yx/NCpcffuiLQCkjzxVQ1jsCEXjffZnT2crOYRD3F6OqpXrW5Is3Tu3+vBYjFEX5s
         D3osikDvcHRmpaVkSw5kY9DUvSriN8bV1hGMasw7HYMKMQcffpqnFuyI+0c6kRYV5dJt
         0XjtWVWZvN+H0YAbolGen/578Q/hW9JK3Qc/L7b795iYUGXexs3tkCR0usTmKQ8uVGn+
         KWqw==
X-Gm-Message-State: AGi0PuaCCaKCjR4Q1mcX+XxIl+3vg8z1TuXh7NDNpzRgFbplPPV8oQMe
        MxehXSqCJquxwC85kl14UMnCHw==
X-Google-Smtp-Source: APiQypLVwllUTXQ1/Y/sPPtT0zA+jgxZzBoRbuepFmIiKnMBAa7PZ1NwnOpOyXiPbmo1Kxqkaw0QUQ==
X-Received: by 2002:a17:90b:3018:: with SMTP id hg24mr40352004pjb.130.1589471603082;
        Thu, 14 May 2020 08:53:23 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:85e7:ddeb:bb07:3741? ([2605:e000:100e:8c61:85e7:ddeb:bb07:3741])
        by smtp.gmail.com with ESMTPSA id a2sm2595876pfl.28.2020.05.14.08.53.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2020 08:53:22 -0700 (PDT)
Subject: Re: [PATCH RFC} io_uring: io_kiocb alloc cache
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     joseph qi <joseph.qi@linux.alibaba.com>,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>
References: <492bb956-a670-8730-a35f-1d878c27175f@kernel.dk>
 <dc5a0caf-0ba4-bfd7-4b6e-cbcb3e6fde10@linux.alibaba.com>
 <70602a13-f6c9-e8a8-1035-6f148ba2d6d7@kernel.dk>
 <a68bbc0a-5bd7-06b6-1616-2704512228b8@kernel.dk>
 <0ec1b33d-893f-1b10-128e-f8a8950b0384@gmail.com>
 <a2b5e500-316d-dc06-1a25-72aaf67ac227@kernel.dk>
 <d6206c24-8b4d-37d3-56bd-eac752151de9@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b7e7eb5e-cbea-0c59-38b1-1043b5352e4d@kernel.dk>
Date:   Thu, 14 May 2020 09:53:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <d6206c24-8b4d-37d3-56bd-eac752151de9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/14/20 9:37 AM, Pavel Begunkov wrote:
> 
> 
> On 14/05/2020 18:15, Jens Axboe wrote:
>> On 5/14/20 8:53 AM, Pavel Begunkov wrote:
>>> On 14/05/2020 17:33, Jens Axboe wrote:
>>>> On 5/14/20 8:22 AM, Jens Axboe wrote:
>>>>>> I still use my previous io_uring_nop_stress tool to evaluate the improvement
>>>>>> in a physical machine. Memory 250GB and cpu is "Intel(R) Xeon(R) CPU E5-2682 v4 @ 2.50GHz".
>>>>>> Before this patch:
>>>>>> $sudo taskset -c 60 ./io_uring_nop_stress -r 300
>>>>>> total ios: 1608773840
>>>>>> IOPS:      5362579
>>>>>>
>>>>>> With this patch:
>>>>>> sudo taskset -c 60 ./io_uring_nop_stress -r 300
>>>>>> total ios: 1676910736
>>>>>> IOPS:      5589702
>>>>>> About 4.2% improvement.
>>>>>
>>>>> That's not bad. Can you try the patch from Pekka as well, just to see if
>>>>> that helps for you?
>>>>>
>>>>> I also had another idea... We basically have two types of request life
>>>>> times:
>>>>>
>>>>> 1) io_kiocb can get queued up internally
>>>>> 2) io_kiocb completes inline
>>>>>
>>>>> For the latter, it's totally feasible to just have the io_kiocb on
>>>>> stack. The downside is if we need to go the slower path, then we need to
>>>>> alloc an io_kiocb then and copy it. But maybe that's OK... I'll play
>>>>> with it.
>>>
>>> Does it differ from having one pre-allocated req? Like fallback_req,
>>> but without atomics and returned only under uring_mutex (i.e. in
>>> __io_queue_sqe()). Putting aside its usefulness, at least it will have
>>> a chance to work with reads/writes.
>>
>> But then you need atomics. I actually think the bigger win here is not
>> having to use atomic refcounts for this particular part, since we know
>> the request can't get shared.
> 
> Don't think we need, see:
> 
> struct ctx {
> 	/* protected by uring_mtx */
> 	struct req *cache_req;
> }
> 
> __io_queue_sqe()
> {
> 	ret = issue_inline(req);
> 	if (completed(ret)) {
> 		// don't need req anymore, return it
> 		ctx->cache_req = req;
> 	} else if (need_async) {
> 		// still under uring_mtx, just replenish the cache
> 		// alloc()+memcpy() here for on-stack
> 		ctx->cache_req = alloc_req();
> 		punt(req);
> 	}
> 
> 	// restored it in any case
> 	assert(ctx->cache_req != NULL);
> }
> 
> submit_sqes() __holds(uring_mtx)
> {
> 	while (...) {
> 		// already holding the mutex, no need for sync here
> 		// also, there is always a req there
> 		req = ctx->cache_req;
> 		ctx->cache_req = NULL;
> 		...
> 	}
> }

Hmm yes good point, it should work pretty easily, barring the use cases
that do IRQ complete. But that was also a special case with the other
cache.

> BTW, there will be a lot of problems to make either work properly with
> IORING_FEAT_SUBMIT_STABLE.

How so? Once the request is setup, any state should be retained there.

-- 
Jens Axboe


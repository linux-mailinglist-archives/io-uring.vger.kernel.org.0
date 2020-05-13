Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84BCF1D1992
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2020 17:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388928AbgEMPge (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 May 2020 11:36:34 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:33374 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729546AbgEMPge (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 May 2020 11:36:34 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R321e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07484;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0TySBP-3_1589384191;
Received: from 192.168.124.10(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TySBP-3_1589384191)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 13 May 2020 23:36:32 +0800
Subject: Re: [RFC PATCH] io_uring: don't submit sqes when ctx->refs is dying
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200513123754.25189-1-xiaoguang.wang@linux.alibaba.com>
 <89e8a0b4-bc18-49c8-5628-93eb403622e2@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <1a5e92d0-02c7-44d9-07e5-50c0ca77b800@linux.alibaba.com>
Date:   Wed, 13 May 2020 23:36:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <89e8a0b4-bc18-49c8-5628-93eb403622e2@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 5/13/20 6:37 AM, Xiaoguang Wang wrote:
>> When IORING_SETUP_SQPOLL is enabled, io_ring_ctx_wait_and_kill() will wait
>> for sq thread to idle by busy loop:
>>      while (ctx->sqo_thread && !wq_has_sleeper(&ctx->sqo_wait))
>>          cond_resched();
>> Above codes are not friendly, indeed I think this busy loop will introduce a
>> cpu burst in current cpu, though it maybe short.
>>
>> In this patch, if ctx->refs is dying, we forbids sq_thread from submitting
>> sqes anymore, just discard leftover sqes.
> 
> I don't think this really changes anything. What happens if:
> 
>> @@ -6051,7 +6053,8 @@ static int io_sq_thread(void *data)
>>   		}
>>   
>>   		mutex_lock(&ctx->uring_lock);
>> -		ret = io_submit_sqes(ctx, to_submit, NULL, -1, true);
>> +		if (likely(!percpu_ref_is_dying(&ctx->refs)))
>> +			ret = io_submit_sqes(ctx, to_submit, NULL, -1, true);
>>   		mutex_unlock(&ctx->uring_lock);
>>   		timeout = jiffies + ctx->sq_thread_idle;
> 
> You check for dying here, but that could change basically while you're
> checking it. So you're still submitting sqes with a ref that's going
> away. You've only reduced the window, you haven't eliminated it.
Look at codes, we call percpu_ref_kill() under uring_lock, so isn't it safe
to check the refs' dying status? Thanks.

Regards,
Xiaouang Wang


> 

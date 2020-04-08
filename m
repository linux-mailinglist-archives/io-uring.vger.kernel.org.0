Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 487AA1A1B88
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 07:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgDHFao (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 01:30:44 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:40317 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726469AbgDHFao (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 01:30:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01355;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0TuxpXTJ_1586323835;
Received: from 30.5.115.28(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TuxpXTJ_1586323835)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 08 Apr 2020 13:30:36 +0800
Subject: Re: [PATCH] io_uring:IORING_SETUP_SQPOLL don't need to enter
 io_cqring_wait
To:     Jens Axboe <axboe@kernel.dk>, wu860403@gmail.com,
        io-uring@vger.kernel.org
Cc:     Liming Wu <19092205@suning.com>
References: <1586249075-14649-1-git-send-email-wu860403@gmail.com>
 <b50140b3-d5a7-ed5e-434c-6bf004a4869d@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <9b723bb3-83a0-d3c5-5e11-68fa3ba46401@linux.alibaba.com>
Date:   Wed, 8 Apr 2020 13:30:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <b50140b3-d5a7-ed5e-434c-6bf004a4869d@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 4/7/20 1:44 AM, wu860403@gmail.com wrote:
>> From: Liming Wu <19092205@suning.com>
>>
>> When SETUP_IOPOLL and SETUP_SQPOLL are both enabled, app don't
>> need to enter io_cqring_wait too. If I misunderstand, please give
>> me some advise.
> 
> The logic should be as follows:
> 
> flags			method
> ---------------------------------------------
> 0			io_cqring_wait()
> IOPOLL			io_iopoll_check()
> IOPOLL | SQPOLL		io_cqring_wait()
> SQPOLL			io_cqring_wait()
> 
> The reasoning being that we do want to enter cqring_wait() for SQPOLL,
> as the application may want to wait for completions. Even with IOPOLL
> set. As far as I can tell, the current code is correct, as long as we
> know SQPOLL will always poll for events for us.
Yes, agree.

Regards,
Xiaoguang Wang

> 
> So I'm curious why you think your patch is needed? Leaving it below and
> CC'ing Xiaoguang, who made the most recent change, so he can comment.
> 
>> Signed-off-by Liming Wu <19092205@suning.com>
>> ---
>>   io_uring.c | 11 ++++++-----
>>   1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/io_uring.c b/io_uring.c
>> index b12d33b..36e884f 100644
>> --- a/io_uring.c
>> +++ b/io_uring.c
>> @@ -7418,11 +7418,12 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>>   		 * polling again, they can rely on io_sq_thread to do polling
>>   		 * work, which can reduce cpu usage and uring_lock contention.
>>   		 */
>> -		if (ctx->flags & IORING_SETUP_IOPOLL &&
>> -		    !(ctx->flags & IORING_SETUP_SQPOLL)) {
>> -			ret = io_iopoll_check(ctx, &nr_events, min_complete);
>> -		} else {
>> -			ret = io_cqring_wait(ctx, min_complete, sig, sigsz);
>> +		if (!(ctx->flags & IORING_SETUP_SQPOLL)) {
>> +		    if (ctx->flags & IORING_SETUP_IOPOLL) {
>> +		    	ret = io_iopoll_check(ctx, &nr_events, min_complete);
>> +		    } else {
>> +		    	ret = io_cqring_wait(ctx, min_complete, sig, sigsz);
>> +		    }
>>   		}
>>   	}
>>   
>>
> 
> 

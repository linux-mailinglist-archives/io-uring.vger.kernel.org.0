Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCAA2A2A43
	for <lists+io-uring@lfdr.de>; Mon,  2 Nov 2020 13:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbgKBMBv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Nov 2020 07:01:51 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:36767 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728288AbgKBMBv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Nov 2020 07:01:51 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UDxhPir_1604318506;
Received: from 30.225.32.193(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UDxhPir_1604318506)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 02 Nov 2020 20:01:46 +0800
Subject: Re: [PATCH 2/2] io_uring: support multiple rings to share same poll
 thread by specifying same cpu
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, joseph.qi@linux.alibaba.com
References: <20201020082345.19628-1-xiaoguang.wang@linux.alibaba.com>
 <20201020082345.19628-3-xiaoguang.wang@linux.alibaba.com>
 <4498ad10-c203-99c8-092d-aa1b936cd6b4@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <172a877f-e182-e9f9-5ff3-a8f7dfa5d6dd@linux.alibaba.com>
Date:   Mon, 2 Nov 2020 20:00:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <4498ad10-c203-99c8-092d-aa1b936cd6b4@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 10/20/20 2:23 AM, Xiaoguang Wang wrote:
>> We have already supported multiple rings to share one same poll thread
>> by passing IORING_SETUP_ATTACH_WQ, but it's not that convenient to use.
>> IORING_SETUP_ATTACH_WQ needs users to ensure that a parent ring instance
>> has already existed, that means it will require app to regulate the
>> creation oder between uring instances.
>>
>> Currently we can make this a bit simpler, for those rings which will
>> have SQPOLL enabled and are willing to be bound to one same cpu, add a
>> capability that these rings can share one poll thread by specifying
>> a new IORING_SETUP_SQPOLL_PERCPU flag, then we have 3 cases
>>    1, IORING_SETUP_ATTACH_WQ: if user specifies this flag, we'll always
>> try to attach this ring to an existing ring's corresponding poll thread,
>> no matter whether IORING_SETUP_SQ_AFF or IORING_SETUP_SQPOLL_PERCPU is
>> set.
>>    2, IORING_SETUP_SQ_AFF and IORING_SETUP_SQPOLL_PERCPU are both enabled,
>> for this case, we'll create a single poll thread to be shared by these
>> rings, and this poll thread is bound to a fixed cpu.
>>    3, for any other cases, we'll just create one new poll thread for the
>> corresponding ring.
>>
>> And for case 2, don't need to regulate creation oder of multiple uring
>> instances, we use a mutex to synchronize creation, for example, say five
>> rings which all have IORING_SETUP_SQ_AFF & IORING_SETUP_SQPOLL_PERCPU
>> enabled, and are willing to be bound same cpu, one ring that gets the
>> mutex lock will create one poll thread, the other four rings will just
>> attach themselves the previous created poll thread once they get lock
>> successfully.
>>
>> To implement above function, define a percpu io_sq_data array:
>>      static struct io_sq_data __percpu *percpu_sqd;
>> When IORING_SETUP_SQ_AFF and IORING_SETUP_SQPOLL_PERCPU are both enabled,
>> we will use struct io_uring_params' sq_thread_cpu to locate corresponding
>> sqd, and use this sqd to save poll thread info.
> 
> Do you have any test results?
> 
> Not quite clear to me, but if IORING_SETUP_SQPOLL_PERCPU is set, I think
> it should always imply IORING_SETUP_ATTACH_WQ in the sense that it would
> not make sense to have more than one poller thread that's bound to a
> single CPU, for example.
> 
>> @@ -6814,8 +6819,17 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
>>   	return 0;
>>   }
>>   
>> -static void io_put_sq_data(struct io_sq_data *sqd)
>> +static void io_put_sq_data(struct io_ring_ctx *ctx, struct io_sq_data *sqd)
>>   {
>> +	int percpu_sqd = 0;
>> +
>> +	if ((ctx->flags & IORING_SETUP_SQ_AFF) &&
>> +	    (ctx->flags & IORING_SETUP_SQPOLL_PERCPU))
>> +		percpu_sqd = 1;
>> +
>> +	if (percpu_sqd)
>> +		mutex_lock(&sqd->percpu_sq_lock);
>> +
>>   	if (refcount_dec_and_test(&sqd->refs)) {
>>   		/*
>>   		 * The park is a bit of a work-around, without it we get
> 
> For this, and the setup, you should make it dynamic. Hence don't
> allocate the percpu data etc until someone asks for it, and when the
> last user of it goes away, it should go away as well.
> 
> That would make the handling of it identical to what we currently have,
> and no need to special case any of this like you do above.
I had thought I could improve codes according to your suggestions, but seems that
it couldn't do that. For the percpu sqd, I need to use a global mutex to serialize
the io_uring instance creation order. Once a task gets this lock, if there isn't sqd
bound to specified cpu, it'll allocate sqd data, create poll thread, and both operations
need to be atomic, so I need to handle percpu sqd a little specially.

Regards,
Xiaoguang Wang


> 
> 

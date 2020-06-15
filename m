Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88AF1F9DDD
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2020 18:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729966AbgFOQvy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Jun 2020 12:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729772AbgFOQvy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Jun 2020 12:51:54 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8791C061A0E
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2020 09:51:53 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id k6so2072715pll.9
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2020 09:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bI9knqin4SVEz2sO25WZuXzvqF1z3bbauAb12n97a60=;
        b=x6NjyQzxF6NhQcLXz+p+O9OboL0ReHVuraXiGaL/7OiBLyvMThIgvBjxNeR84CLqIx
         tTGmKoXGxbYzSzmJpR0KHsmk/UPEu/l2iHzPclK5d+HJNF+P5UoM9lLGpzvcgjV9VK6+
         MeWPXHgThWYnRhSdHQDg8BDBaionpIfQmNX/nDUfnfnFbY8UaU+FISDlS+DCIoYzCd7i
         /81wZM6ZUZUAfJQujSq+SP4F5SFU+jZVN4JOMaitzD2tQ+qFh54OE7Ph7GeGhYMg79Es
         kU4zSdMAyUY5MilTQsOev6tStAAFpfJQkneHCveF7kkzcyvycqu1JFJ4fk7QvFgeL+3p
         31Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bI9knqin4SVEz2sO25WZuXzvqF1z3bbauAb12n97a60=;
        b=e9+SDDPd2mVEDDZ7CRFDLejzeh8y7ypcOXJ/0fR+UXOPBU07GDoAC7McmqmKUQxmVL
         nKbdVck3T4XsFZlGILM5k6ZoBq/tWBHanBRNCn2BowgYDzVdBJ45POuaq3E2zFzqDkzs
         YG6A1d0KehxVK/ftl6YNr30mBsxHNe3QjpbADYaf+PpbcaqfMDBAzYmsN+3Ic4ZDAHxu
         94IuRT491bFAqh9+DQaCdmjlldFfCZuaxN9Bxr72N9DVL/4vbtxOS0mbbuYS6HTSQxm8
         dcLacvAovK/UFDLzmGCmK+7GAvjEBVosuArUr/CVoDfeBdIy6wXguR8/C9YoUF0vtXzJ
         siRg==
X-Gm-Message-State: AOAM533XAG+o8svdXSJysy/yajjJuocv88mmX7d6TorUOPNj8Wk9mUWj
        7yImK8xZrR/96uZ488lgbMl1XHDq5tWJAQ==
X-Google-Smtp-Source: ABdhPJxIBl3IK8ib/V5xcVPOFGPb7buZThMSIad0MXhi3FwJ6k6FRWlHMRhIWm0nHEs2VZMkXqFV3A==
X-Received: by 2002:a17:90a:1546:: with SMTP id y6mr258495pja.92.1592239912263;
        Mon, 15 Jun 2020 09:51:52 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id m22sm15378675pfk.216.2020.06.15.09.51.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2020 09:51:51 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: add memory barrier to synchronize
 io_kiocb's result and iopoll_completed
From:   Jens Axboe <axboe@kernel.dk>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200615092450.3241-1-xiaoguang.wang@linux.alibaba.com>
 <20200615092450.3241-3-xiaoguang.wang@linux.alibaba.com>
 <a11acc23-1ad6-2281-4712-e78e46f414d7@kernel.dk>
 <e47dd9c1-60a6-8365-6754-88437cf828f5@linux.alibaba.com>
 <97cfe28d-cbbe-680a-2f4f-8794d4f90728@kernel.dk>
 <d37647d3-da74-7c30-94c8-f18d0afcd958@linux.alibaba.com>
 <2d6f383f-a033-fe30-f4cb-e5b9439dbbac@kernel.dk>
Message-ID: <c529d919-e70c-3e79-77c8-b5cb7ffead4d@kernel.dk>
Date:   Mon, 15 Jun 2020 10:51:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <2d6f383f-a033-fe30-f4cb-e5b9439dbbac@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/20 9:35 AM, Jens Axboe wrote:
> On 6/15/20 9:32 AM, Xiaoguang Wang wrote:
>> hi,
>>
>>> On 6/15/20 8:48 AM, Xiaoguang Wang wrote:
>>>> hi,
>>>>
>>>>> On 6/15/20 3:24 AM, Xiaoguang Wang wrote:
>>>>>> In io_complete_rw_iopoll(), stores to io_kiocb's result and iopoll
>>>>>> completed are two independent store operations, to ensure that once
>>>>>> iopoll_completed is ture and then req->result must been perceived by
>>>>>> the cpu executing io_do_iopoll(), proper memory barrier should be used.
>>>>>>
>>>>>> And in io_do_iopoll(), we check whether req->result is EAGAIN, if it is,
>>>>>> we'll need to issue this io request using io-wq again. In order to just
>>>>>> issue a single smp_rmb() on the completion side, move the re-submit work
>>>>>> to io_iopoll_complete().
>>>>>
>>>>> Did you actually test this one?
>>>> I only run test cases in liburing/test in a vm.
>>>>
>>>>>
>>>>>> @@ -1736,11 +1748,20 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
>>>>>>    {
>>>>>>    	struct req_batch rb;
>>>>>>    	struct io_kiocb *req;
>>>>>> +	LIST_HEAD(again);
>>>>>> +
>>>>>> +	/* order with ->result store in io_complete_rw_iopoll() */
>>>>>> +	smp_rmb();
>>>>>>    
>>>>>>    	rb.to_free = rb.need_iter = 0;
>>>>>>    	while (!list_empty(done)) {
>>>>>>    		int cflags = 0;
>>>>>>    
>>>>>> +		if (READ_ONCE(req->result) == -EAGAIN) {
>>>>>> +			req->iopoll_completed = 0;
>>>>>> +			list_move_tail(&req->list, &again);
>>>>>> +			continue;
>>>>>> +		}
>>>>>>    		req = list_first_entry(done, struct io_kiocb, list);
>>>>>>    		list_del(&req->list);
>>>>>>    
>>>>>
>>>>> You're using 'req' here before you initialize it...
>>>> Sorry, next time when I submit patches, I'll construct test cases which
>>>> will cover my codes changes.
>>>
>>> I'm surprised the compiler didn't complain, or that the regular testing
>>> didn't barf on it.
>> I'm also surprised, will try to find the reason.
>> And indeed the iopoll test case failed, but below command displayed nothing:
>> [lege@localhost test]$ sudo ./iopoll
>> Then I considered this test case pass wrongly.
>>
>> dmesg show errors:
>> [  127.806945] ==================================================================
>> [  127.806983] BUG: KASAN: use-after-free in io_iopoll_complete+0xbb/0x980
>> [  127.806989] Read of size 4 at addr ffff8886e3e98808 by task io_uring-sq/1643
>>
>> [  127.806999] CPU: 16 PID: 1643 Comm: io_uring-sq Not tainted 5.7.0+ #501
>> [  127.807013] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.1-0-g0551a4be2c-prebuilt.qemu-project.org 04/01/2014
>> [  127.807021] Call Trace:
>> [  127.807040]  dump_stack+0x75/0xa0
>> [  127.807047]  ? io_iopoll_complete+0xbb/0x980
>> [  127.807062]  print_address_description.constprop.6+0x1a/0x220
>> [  127.807086]  ? _raw_write_lock_irqsave+0xd0/0xd0
>> [  127.807092]  ? io_free_req_many.part.79+0x208/0x2a0
>> [  127.807107]  ? __rcu_read_unlock+0x37/0x200
>> [  127.807112]  ? io_iopoll_complete+0xbb/0x980
>> [  127.807117]  ? io_iopoll_complete+0xbb/0x980
>> [  127.807122]  kasan_report.cold.9+0x1f/0x42
>> [  127.807128]  ? io_iopoll_complete+0xbb/0x980
>> [  127.807133]  io_iopoll_complete+0xbb/0x980
>> [  127.807138]  ? io_timeout_fn+0x140/0x140
>> [  127.807150]  ? __switch_to+0x2e9/0x5a0
>> [  127.807157]  io_iopoll_getevents+0x287/0x310
>> [  127.807163]  ? io_iopoll_complete+0x980/0x980
>> [  127.807172]  ? finish_wait+0xcb/0xf0
>> [  127.807179]  io_sq_thread+0x1c1/0x600
>> [  127.807185]  ? __ia32_sys_io_uring_enter+0x450/0x450
>> [  127.807194]  ? preempt_count_add+0x77/0xd0
>> [  127.807200]  ? _raw_spin_lock_irqsave+0x84/0xd0
>> [  127.807206]  ? _raw_write_lock_irqsave+0xd0/0xd0
>> [  127.807210]  ? finish_wait+0xf0/0xf0
>> [  127.807215]  ? preempt_count_sub+0x18/0xc0
>> [  127.807224]  ? __kthread_parkme+0xaf/0xd0
>> [  127.807231]  ? __ia32_sys_io_uring_enter+0x450/0x450
>> [  127.807235]  kthread+0x1e4/0x210
>> [  127.807241]  ? kthread_create_on_node+0xa0/0xa0
>> [  127.807246]  ret_from_fork+0x22/0x30
> 
> There you go, so it did fail, just didn't register as a failure. I should
> probably add a dmesg check for the liburing tests, and fail a test if
> we trigger a WARNING or BUG condition. I'll look into that.

I pushed a commit to liburing so that it should now catch dmesg
errors logged while running a test.

-- 
Jens Axboe


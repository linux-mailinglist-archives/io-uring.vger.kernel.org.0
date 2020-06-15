Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453101F9AC9
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2020 16:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730476AbgFOOsp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Jun 2020 10:48:45 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:33989 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730461AbgFOOso (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Jun 2020 10:48:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U.hwhoR_1592232517;
Received: from 30.8.168.89(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U.hwhoR_1592232517)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 15 Jun 2020 22:48:37 +0800
Subject: Re: [PATCH 2/2] io_uring: add memory barrier to synchronize
 io_kiocb's result and iopoll_completed
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200615092450.3241-1-xiaoguang.wang@linux.alibaba.com>
 <20200615092450.3241-3-xiaoguang.wang@linux.alibaba.com>
 <a11acc23-1ad6-2281-4712-e78e46f414d7@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <e47dd9c1-60a6-8365-6754-88437cf828f5@linux.alibaba.com>
Date:   Mon, 15 Jun 2020 22:48:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <a11acc23-1ad6-2281-4712-e78e46f414d7@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 6/15/20 3:24 AM, Xiaoguang Wang wrote:
>> In io_complete_rw_iopoll(), stores to io_kiocb's result and iopoll
>> completed are two independent store operations, to ensure that once
>> iopoll_completed is ture and then req->result must been perceived by
>> the cpu executing io_do_iopoll(), proper memory barrier should be used.
>>
>> And in io_do_iopoll(), we check whether req->result is EAGAIN, if it is,
>> we'll need to issue this io request using io-wq again. In order to just
>> issue a single smp_rmb() on the completion side, move the re-submit work
>> to io_iopoll_complete().
> 
> Did you actually test this one?
I only run test cases in liburing/test in a vm.

> 
>> @@ -1736,11 +1748,20 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
>>   {
>>   	struct req_batch rb;
>>   	struct io_kiocb *req;
>> +	LIST_HEAD(again);
>> +
>> +	/* order with ->result store in io_complete_rw_iopoll() */
>> +	smp_rmb();
>>   
>>   	rb.to_free = rb.need_iter = 0;
>>   	while (!list_empty(done)) {
>>   		int cflags = 0;
>>   
>> +		if (READ_ONCE(req->result) == -EAGAIN) {
>> +			req->iopoll_completed = 0;
>> +			list_move_tail(&req->list, &again);
>> +			continue;
>> +		}
>>   		req = list_first_entry(done, struct io_kiocb, list);
>>   		list_del(&req->list);
>>   
> 
> You're using 'req' here before you initialize it...
Sorry, next time when I submit patches, I'll construct test cases which
will cover my codes changes.

Regards,
Xiaoguang Wang
> 

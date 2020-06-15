Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C671F8C36
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2020 04:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgFOCKx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 Jun 2020 22:10:53 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:60436 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727971AbgFOCKw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 Jun 2020 22:10:52 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07488;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U.YAv86_1592187040;
Received: from 30.225.32.157(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U.YAv86_1592187040)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 15 Jun 2020 10:10:40 +0800
Subject: Re: Does need memory barrier to synchronize req->result with
 req->iopoll_completed
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Cc:     joseph qi <joseph.qi@linux.alibaba.com>
References: <dc28ff4f-37cf-03cb-039e-f93fefef8b96@linux.alibaba.com>
 <fdbe0ddc-7fa8-f7df-2e49-bfcea00673d0@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <6042d795-e652-f9f7-9c45-472209838717@linux.alibaba.com>
Date:   Mon, 15 Jun 2020 10:10:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <fdbe0ddc-7fa8-f7df-2e49-bfcea00673d0@kernel.dk>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 6/14/20 8:10 AM, Xiaoguang Wang wrote:
>> hi,
>>
>> I have taken some further thoughts about previous IPOLL race fix patch,
>> if io_complete_rw_iopoll() is called in interrupt context, "req->result = res"
>> and "WRITE_ONCE(req->iopoll_completed, 1);" are independent store operations.
>> So in io_do_iopoll(), if iopoll_completed is ture, can we make sure that
>> req->result has already been perceived by the cpu executing io_do_iopoll()?
> 
> Good point, I think if we do something like the below, we should be
> totally safe against an IRQ completion. Since we batch the completions,
> we can get by with just a single smp_rmb() on the completion side.
Yes, agree.
And thanks for confirming this issue, I'll make a formal patch with proper commit log.

Regards,
Xiaoguang Wang
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 155f3d830ddb..74c2a4709b63 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1736,6 +1736,9 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
>   	struct req_batch rb;
>   	struct io_kiocb *req;
>   
> +	/* order with ->result store in io_complete_rw_iopoll() */
> +	smp_rmb();
> +
>   	rb.to_free = rb.need_iter = 0;
>   	while (!list_empty(done)) {
>   		int cflags = 0;
> @@ -1976,6 +1979,8 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
>   	if (res != req->result)
>   		req_set_fail_links(req);
>   	req->result = res;
> +	/* order with io_poll_complete() checking ->result */
> +	smp_wmb();
>   	if (res != -EAGAIN)
>   		WRITE_ONCE(req->iopoll_completed, 1);
>   }
> 

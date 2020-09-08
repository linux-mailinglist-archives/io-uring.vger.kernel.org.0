Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF562608A4
	for <lists+io-uring@lfdr.de>; Tue,  8 Sep 2020 04:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgIHC2a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Sep 2020 22:28:30 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:54414 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728158AbgIHC21 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Sep 2020 22:28:27 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0U8GcnkH_1599532104;
Received: from 30.225.32.193(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U8GcnkH_1599532104)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Sep 2020 10:28:25 +0800
Subject: Re: [PATCH 8/8] io_uring: enable IORING_SETUP_ATTACH_WQ to attach to
 SQPOLL thread too
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20200903022053.912968-1-axboe@kernel.dk>
 <20200903022053.912968-9-axboe@kernel.dk>
 <c6562c28-7631-d593-d3e5-cde158337337@linux.alibaba.com>
 <13bd91f7-9eef-cc38-d892-d28e5d068421@kernel.dk>
 <c9cde576-3e5a-15b1-6f54-d0f474e25394@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <2ceaf1af-fcb7-32eb-1289-45caf00ada3c@linux.alibaba.com>
Date:   Tue, 8 Sep 2020 10:28:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <c9cde576-3e5a-15b1-6f54-d0f474e25394@kernel.dk>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi£¬

> On 9/7/20 10:14 AM, Jens Axboe wrote:
>> On 9/7/20 2:56 AM, Xiaoguang Wang wrote:
>>> 3. When it's appropriate to set ctx's IORING_SQ_NEED_WAKEUP flag? In
>>> your current implementation, if a ctx is marked as SQT_IDLE, this ctx
>>> will be set IORING_SQ_NEED_WAKEUP flag, but if other ctxes have work
>>> to do, then io_sq_thread is still running and does not need to be
>>> waken up, then a later wakeup form userspace is unnecessary. I think
>>> it maybe appropriate to set IORING_SQ_NEED_WAKEUP when all ctxes have
>>> no work to do, you can have a look at my attached codes:)
>>
>> That's a good point, any chance I can get you to submit a patch to fix
>> that up?
> 
> Something like this?
Yes, thanks, I'll prepare a patch soon.

Regards,
Xiaoguang Wang

> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 4bd18e01ae89..80913973337a 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6747,8 +6747,6 @@ static enum sq_ret __io_sq_thread(struct io_ring_ctx *ctx,
>   			goto again;
>   		}
>   
> -		io_ring_set_wakeup_flag(ctx);
> -
>   		to_submit = io_sqring_entries(ctx);
>   		if (!to_submit || ret == -EBUSY)
>   			return SQT_IDLE;
> @@ -6825,6 +6823,8 @@ static int io_sq_thread(void *data)
>   			io_run_task_work();
>   			cond_resched();
>   		} else if (ret == SQT_IDLE) {
> +			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
> +				io_ring_set_wakeup_flag(ctx);
>   			schedule();
>   			start_jiffies = jiffies;
>   		}
> 

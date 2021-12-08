Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B2D46CCF2
	for <lists+io-uring@lfdr.de>; Wed,  8 Dec 2021 06:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbhLHF1W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Dec 2021 00:27:22 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:51192 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232454AbhLHF1V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Dec 2021 00:27:21 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uzqte9n_1638941028;
Received: from 30.226.12.31(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uzqte9n_1638941028)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 08 Dec 2021 13:23:48 +0800
Subject: Re: [PATCH 5/5] io_uring: batch completion in prior_task_list
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211207093951.247840-1-haoxu@linux.alibaba.com>
 <20211207093951.247840-6-haoxu@linux.alibaba.com>
 <1fcdb967-03f0-bdd3-2127-9d678d40aff2@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <57392ee1-92b8-b5ab-59cd-991a441d1959@linux.alibaba.com>
Date:   Wed, 8 Dec 2021 13:23:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1fcdb967-03f0-bdd3-2127-9d678d40aff2@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


在 2021/12/8 上午5:59, Jens Axboe 写道:
> On 12/7/21 2:39 AM, Hao Xu wrote:
>> In previous patches, we have already gathered some tw with
>> io_req_task_complete() as callback in prior_task_list, let's complete
>> them in batch while we cannot grab uring lock. In this way, we batch
>> the req_complete_post path.
>>
>> Tested-by: Pavel Begunkov <asml.silence@gmail.com>
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>
>> Hi Pavel,
>> May I add the above Test-by tag here?
> When you fold in Pavel's fixed, please also address the below.
>
>>   fs/io_uring.c | 70 +++++++++++++++++++++++++++++++++++++++++++--------
>>   1 file changed, 60 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 21738ed7521e..f224f8df77a1 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -2225,6 +2225,49 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, bool *locked)
>>   	percpu_ref_put(&ctx->refs);
>>   }
>>   
>> +static inline void ctx_commit_and_unlock(struct io_ring_ctx *ctx)
>> +{
>> +	io_commit_cqring(ctx);
>> +	spin_unlock(&ctx->completion_lock);
>> +	io_cqring_ev_posted(ctx);
>> +}
>> +
>> +static void handle_prior_tw_list(struct io_wq_work_node *node, struct io_ring_ctx **ctx,
>> +				 bool *uring_locked, bool *compl_locked)
>> +{
> Please wrap at 80 lines. And let's name this one 'handle_prev_tw_list'
> instead.
Gotcha.
>

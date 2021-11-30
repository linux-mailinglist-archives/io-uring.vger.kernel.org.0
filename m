Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E755462B1C
	for <lists+io-uring@lfdr.de>; Tue, 30 Nov 2021 04:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237919AbhK3Dfm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Nov 2021 22:35:42 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:47519 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237918AbhK3Dfm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Nov 2021 22:35:42 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UypgLW3_1638243140;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UypgLW3_1638243140)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 30 Nov 2021 11:32:21 +0800
Subject: Re: [PATCH 3/9] io-wq: update check condition for lock
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211124044648.142416-1-haoxu@linux.alibaba.com>
 <20211124044648.142416-4-haoxu@linux.alibaba.com>
 <6905b2e7-bd27-fb74-da64-ed02123e427d@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <24bcfe64-6e39-2312-1030-4468a901074b@linux.alibaba.com>
Date:   Tue, 30 Nov 2021 11:32:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <6905b2e7-bd27-fb74-da64-ed02123e427d@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/11/25 下午10:47, Pavel Begunkov 写道:
> On 11/24/21 04:46, Hao Xu wrote:
>> Update sparse check since we changed the lock.
> 
> Shouldn't it be a part of one of the previous patches?
Sure, that would be better.
> 
>>
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   fs/io-wq.c | 5 +----
>>   1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>> index 26ccc04797b7..443c34d9b326 100644
>> --- a/fs/io-wq.c
>> +++ b/fs/io-wq.c
>> @@ -378,7 +378,6 @@ static bool io_queue_worker_create(struct 
>> io_worker *worker,
>>   }
>>   static void io_wqe_dec_running(struct io_worker *worker)
>> -    __must_hold(wqe->lock)
>>   {
>>       struct io_wqe_acct *acct = io_wqe_get_acct(worker);
>>       struct io_wqe *wqe = worker->wqe;
>> @@ -449,7 +448,7 @@ static void io_wait_on_hash(struct io_wqe *wqe, 
>> unsigned int hash)
>>   static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
>>                          struct io_worker *worker)
>> -    __must_hold(wqe->lock)
>> +    __must_hold(acct->lock)
>>   {
>>       struct io_wq_work_node *node, *prev;
>>       struct io_wq_work *work, *tail;
>> @@ -523,7 +522,6 @@ static void io_assign_current_work(struct 
>> io_worker *worker,
>>   static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work 
>> *work);
>>   static void io_worker_handle_work(struct io_worker *worker)
>> -    __releases(wqe->lock)
>>   {
>>       struct io_wqe_acct *acct = io_wqe_get_acct(worker);
>>       struct io_wqe *wqe = worker->wqe;
>> @@ -986,7 +984,6 @@ static inline void io_wqe_remove_pending(struct 
>> io_wqe *wqe,
>>   static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
>>                       struct io_wqe_acct *acct,
>>                       struct io_cb_cancel_data *match)
>> -    __releases(wqe->lock)
>>   {
>>       struct io_wq_work_node *node, *prev;
>>       struct io_wq_work *work;
>>
> 


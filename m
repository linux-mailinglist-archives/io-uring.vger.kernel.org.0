Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21EC445D59B
	for <lists+io-uring@lfdr.de>; Thu, 25 Nov 2021 08:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235369AbhKYHlM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Nov 2021 02:41:12 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:58289 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236895AbhKYHjK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Nov 2021 02:39:10 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R311e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UyFCpOp_1637825758;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UyFCpOp_1637825758)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 25 Nov 2021 15:35:58 +0800
Subject: Re: [PATCH v2 3/4] io_uring: don't spinlock when not posting CQEs
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1636559119.git.asml.silence@gmail.com>
 <8d4b4a08bca022cbe19af00266407116775b3e4d.1636559119.git.asml.silence@gmail.com>
 <19624295-224b-cbbc-7f63-17d4d5a9d1b9@linux.alibaba.com>
Message-ID: <25c32b99-a00a-e628-70d5-7155e23b6c9a@linux.alibaba.com>
Date:   Thu, 25 Nov 2021 15:35:57 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <19624295-224b-cbbc-7f63-17d4d5a9d1b9@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/11/25 上午11:48, Hao Xu 写道:
> 在 2021/11/10 下午11:49, Pavel Begunkov 写道:
>> When no of queued for the batch completion requests need to post an CQE,
>> see IOSQE_CQE_SKIP_SUCCESS, avoid grabbing ->completion_lock and other
>> commit/post.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   fs/io_uring.c | 26 +++++++++++++++++---------
>>   1 file changed, 17 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 22572cfd6864..0c0ea3bbb50a 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -321,6 +321,7 @@ struct io_submit_state {
>>       bool            plug_started;
>>       bool            need_plug;
>> +    bool            flush_cqes;
>>       unsigned short        submit_nr;
>>       struct blk_plug        plug;
>>   };
>> @@ -1525,8 +1526,11 @@ static void io_prep_async_link(struct io_kiocb 
>> *req)
>>   static inline void io_req_add_compl_list(struct io_kiocb *req)
>>   {
>> +    struct io_ring_ctx *ctx = req->ctx;
>>       struct io_submit_state *state = &req->ctx->submit_state;
>> +    if (!(req->flags & REQ_F_CQE_SKIP))
>> +        ctx->submit_state.flush_cqes = true;
> Should we init it to false in submit_state_start()?
Never mind, I saw it in __io_submit_flush_completions() so there is no
problem..

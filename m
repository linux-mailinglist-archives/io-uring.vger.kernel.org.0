Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930B345E68F
	for <lists+io-uring@lfdr.de>; Fri, 26 Nov 2021 04:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344441AbhKZDfI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Nov 2021 22:35:08 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:48114 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358024AbhKZDdI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Nov 2021 22:33:08 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UyJie9m_1637897393;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UyJie9m_1637897393)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 26 Nov 2021 11:29:54 +0800
Subject: Re: [PATCH 1/2] io_uring: fix no lock protection for ctx->cq_extra
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211125092103.224502-1-haoxu@linux.alibaba.com>
 <20211125092103.224502-2-haoxu@linux.alibaba.com>
 <a8d30a0a-c623-67b8-e8a8-29cfaeca7975@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <ef86f3cc-71f7-730b-2ca9-369933f24660@linux.alibaba.com>
Date:   Fri, 26 Nov 2021 11:29:53 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <a8d30a0a-c623-67b8-e8a8-29cfaeca7975@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/11/25 下午10:30, Pavel Begunkov 写道:
> On 11/25/21 09:21, Hao Xu wrote:
>> ctx->cq_extra should be protected by completion lock so that the
>> req_need_defer() does the right check.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   fs/io_uring.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index f666a0e7f5e8..ae9534382b26 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -6537,12 +6537,15 @@ static __cold void io_drain_req(struct 
>> io_kiocb *req)
>>       u32 seq = io_get_sequence(req);
>>       /* Still need defer if there is pending req in defer list. */
>> +    spin_lock(&ctx->completion_lock);
>>       if (!req_need_defer(req, seq) && 
>> list_empty_careful(&ctx->defer_list)) {
>> +        spin_unlock(&ctx->completion_lock);
> 
> I haven't checked the sync assumptions, but it was as this since
> the very beginning, so curious if you see any hangs or other
> problems?
No, I just go over it in my mind: cq_extra and cached_cq_tail are both
updated in one completion_lock critical section, lacking of lock may
cause wrong values of cq_extra and cached_cq_tail and thus
req_need_defer() return wrong result. For example, req_need_defer() see
the updated cached_cq_tail but has the old cq_extra value. This is
possible since io_rsrc_put_work() runs in system-worker.
The result of lacking of lock is the drain request may be delayed a
little bit more or less time.
There is also a cq_extra-- in io_get_sqe(), which is the hot path, so
I incline to not touch it.
> 
> In any case, as drain is pushed to slow path, I'm all for
> simplifying synchronisation here.

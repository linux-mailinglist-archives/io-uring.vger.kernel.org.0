Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D50C45D75A
	for <lists+io-uring@lfdr.de>; Thu, 25 Nov 2021 10:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354183AbhKYJlE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Nov 2021 04:41:04 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:40993 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345599AbhKYJjD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Nov 2021 04:39:03 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UyFpmVl_1637832950;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UyFpmVl_1637832950)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 25 Nov 2021 17:35:51 +0800
Subject: Re: [PATCH v2 0/4] allow to skip CQE posting
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1636559119.git.asml.silence@gmail.com>
 <239ab9cc-e53c-f8aa-6bbf-816dfac73f32@kernel.dk>
 <153a9c03-6fae-d821-c18b-9ea1bb7c62d5@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <9cf9a4a2-bdca-d955-23f5-f77bf0315fb2@linux.alibaba.com>
Date:   Thu, 25 Nov 2021 17:35:50 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <153a9c03-6fae-d821-c18b-9ea1bb7c62d5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/11/11 上午12:42, Pavel Begunkov 写道:
> On 11/10/21 16:14, Jens Axboe wrote:
>> On 11/10/21 8:49 AM, Pavel Begunkov wrote:
>>> It's expensive enough to post an CQE, and there are other
>>> reasons to want to ignore them, e.g. for link handling and
>>> it may just be more convenient for the userspace.
>>>
>>> Try to cover most of the use cases with one flag. The overhead
>>> is one "if (cqe->flags & IOSQE_CQE_SKIP_SUCCESS)" check per
>>> requests and a bit bloated req_set_fail(), should be bearable.
>>
>> I like the idea, one thing I'm struggling with is I think a normal use
>> case of this would be fast IO where we still need to know if a
>> completion event has happened, we just don't need to know the details of
>> it since we already know what those details would be if it ends up in
>> success.
>>
>> How about having a skip counter? That would supposedly also allow drain
>> to work, and it could be mapped with the other cq parts to allow the app
>> to see it as well.
> 
> It doesn't go through expensive io_cqring_ev_posted(), so the userspace
> can't really wait on it. It can do some linking tricks to alleviate that,
> but I don't see any new capabilities from the current approach.
> 
> Also the locking is a problem, I was thinking about it, mainly hoping
> that I can adjust cq_extra and leave draining, but it didn't appear
> great to me. AFAIK, it's either an atomic, beating the purpose of the
> thing.
For drain requests, we just need to adjust cq_extra:
if (!skip) fill_cqe;
else       cq_extra--;
cq_extra is already protected by completion_lock
Do I miss something?
> 
> Another option is to split it in two, one counter is kept under
> ->uring_lock and another under ->completion_lock. But it'll be messy,
> shifting flushing part of draining to a work-queue for mutex locking,
> adding yet another bunch of counters that hard to maintain and so.
> 
> And __io_submit_flush_completions() would also need to go through
> the request list one extra time to do the accounting, wouldn't
> want to grow massively inlined io_req_complete_state().
> 


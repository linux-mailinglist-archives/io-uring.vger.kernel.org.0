Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C499358069
	for <lists+io-uring@lfdr.de>; Thu,  8 Apr 2021 12:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbhDHKRT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Apr 2021 06:17:19 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:34572 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229686AbhDHKRR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Apr 2021 06:17:17 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UUtWRnT_1617877011;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UUtWRnT_1617877011)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 08 Apr 2021 18:16:52 +0800
Subject: Re: [PATCH 5.13 v2] io_uring: maintain drain requests' logic
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1617794605-35748-1-git-send-email-haoxu@linux.alibaba.com>
 <00898a9b-d2f2-1108-b9d9-2d6acea6e713@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <32f812e1-c044-d4b3-d26f-3721e4611a1d@linux.alibaba.com>
Date:   Thu, 8 Apr 2021 18:16:51 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <00898a9b-d2f2-1108-b9d9-2d6acea6e713@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/4/7 下午11:49, Jens Axboe 写道:
> On 4/7/21 5:23 AM, Hao Xu wrote:
>> more tests comming, send this out first for comments.
>>
>> Hao Xu (3):
>>    io_uring: add IOSQE_MULTI_CQES/REQ_F_MULTI_CQES for multishot requests
>>    io_uring: maintain drain logic for multishot requests
>>    io_uring: use REQ_F_MULTI_CQES for multipoll IORING_OP_ADD
>>
>>   fs/io_uring.c                 | 34 +++++++++++++++++++++++++++++-----
>>   include/uapi/linux/io_uring.h |  8 +++-----
>>   2 files changed, 32 insertions(+), 10 deletions(-)
> 
> Let's do the simple cq_extra first. I don't see a huge need to add an
> IOSQE flag for this, probably best to just keep this on a per opcode
> basis for now, which also then limits the code path to just touching
> poll for now, as nothing else supports multishot CQEs at this point.
> 
gotcha.
a small issue here:
   sqe-->sqe(link)-->sqe(link)-->sqe(link, multishot)-->sqe(drain)

in the above case, assume the first 3 single-shot reqs have completed.
then I think the drian request won't be issued now unless the multishot 
request in the linkchain has been issued. The trick is: a multishot req
in a linkchain consumes cached_sq_head when io_get_sqe(), which means it
is counted in seq, but we will deduct the sqe when it is issued if we
want to do the job per opcode not in the main code path.
before the multishot req issued:
       all_sqes(4) - multishot_sqes(0) == all_cqes(3) - multishot_cqes(0)
after the multishot req issued:
       all_sqes(4) - multishot_sqes(1) == all_cqes(3) - multishot_cqes(0)


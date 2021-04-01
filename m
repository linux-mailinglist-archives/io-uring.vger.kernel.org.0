Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E0F350FA9
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 08:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbhDAG6k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 02:58:40 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:54428 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232310AbhDAG6J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 02:58:09 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UU2kHby_1617260286;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UU2kHby_1617260286)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 01 Apr 2021 14:58:06 +0800
Subject: Re: [PATCH for-5.13] io_uring: maintain drain requests' logic
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1617181262-66724-1-git-send-email-haoxu@linux.alibaba.com>
 <e3a5582b-7704-9bf5-f78b-23b0fe73e721@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <35ed1280-0648-78e1-2e23-2729f94da620@linux.alibaba.com>
Date:   Thu, 1 Apr 2021 14:58:06 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <e3a5582b-7704-9bf5-f78b-23b0fe73e721@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/3/31 下午11:36, Jens Axboe 写道:
> On 3/31/21 3:01 AM, Hao Xu wrote:
>> Now that we have multishot poll requests, one sqe can emit multiple
>> cqes. given below example:
>>      sqe0(multishot poll)-->sqe1-->sqe2(drain req)
>> sqe2 is designed to issue after sqe0 and sqe1 completed, but since sqe0
>> is a multishot poll request, sqe2 may be issued after sqe0's event
>> triggered twice before sqe1 completed. This isn't what users leverage
>> drain requests for.
>> Here a simple solution is to ignore all multishot poll cqes, which means
>> drain requests  won't wait those request to be done.
> 
> Good point, we need to do something here... Looks simple enough to me,
> though I'd probably prefer if we rename 'multishot_cqes' to
> 'persistent_sqes' or something like that. It's likely not the last
> user of having 1:M mappings between sqe and cqe, so might as well
> try and name it a bit more appropriately.
> 
persistent_sqes makes sense to me.


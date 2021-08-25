Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB96D3F792F
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 17:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbhHYPjh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Aug 2021 11:39:37 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:40459 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232625AbhHYPjh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Aug 2021 11:39:37 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UlsgCvf_1629905929;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UlsgCvf_1629905929)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 25 Aug 2021 23:38:49 +0800
Subject: Re: [PATCH] io_uring: don't free request to slab
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210825114003.231641-1-haoxu@linux.alibaba.com>
 <03767556-ac49-b550-6e73-3b00b3b66753@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <2157392c-5bdc-c5bd-cce9-c9c8ac1fe165@linux.alibaba.com>
Date:   Wed, 25 Aug 2021 23:38:49 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <03767556-ac49-b550-6e73-3b00b3b66753@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/8/25 下午9:28, Pavel Begunkov 写道:
> On 8/25/21 12:40 PM, Hao Xu wrote:
>> It's not neccessary to free the request back to slab when we fail to
>> get sqe, just update state->free_reqs pointer.
> 
> It's a bit hackish because depends on the request being drawn
> from the array in a particular way. How about returning it
It seems a req is always allocated from state->reqs, so it should be
ok? I actually didn't understand 'hackish' here, do you mean
io_submit_sqes() shouldn't move state->free_reqs which is req caches'
internal implementation?
> into state->free_list. That thing is as cold as it can get,
> only buggy apps can hit it.
> 

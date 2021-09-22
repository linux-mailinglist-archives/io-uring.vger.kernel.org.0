Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC366414E92
	for <lists+io-uring@lfdr.de>; Wed, 22 Sep 2021 19:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236774AbhIVRDS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Sep 2021 13:03:18 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:51497 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236705AbhIVRDR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Sep 2021 13:03:17 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UpFgF2u_1632330105;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UpFgF2u_1632330105)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 23 Sep 2021 01:01:46 +0800
Subject: Re: [RFC 3/3] io_uring: try to batch poll request completion
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com
References: <20210922123417.2844-1-xiaoguang.wang@linux.alibaba.com>
 <20210922123417.2844-4-xiaoguang.wang@linux.alibaba.com>
 <5c8ef28e-7130-1e63-3e61-060a56226c32@linux.alibaba.com>
Message-ID: <2007b0f9-ddf7-44c7-7ef0-5cef5ff3d09b@linux.alibaba.com>
Date:   Thu, 23 Sep 2021 01:01:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <5c8ef28e-7130-1e63-3e61-060a56226c32@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/23 上午1:00, Hao Xu 写道:
> 在 2021/9/22 下午8:34, Xiaoguang Wang 写道:
>> For an echo-server based on io_uring's IORING_POLL_ADD_MULTI feature,
>> only poll request are completed in task work, normal read/write
>> requests are issued when user app sees cqes on corresponding poll
>> requests, and they will mostly read/write data successfully, which
>> don't need task work. So at least for echo-server model, batching
>> poll request completion properly will give benefits.
>>
>> Currently don't find any appropriate place to store batched poll
>> requests, put them in struct io_submit_state temporarily, which I
>> think it'll need rework in future.
>>
>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> We may need flush completion when io_submit_end as well, there may be
> situations where pure poll reqs are sparse. For instance, users may
> just use pure poll to do accept, and fast poll for read/write,
I mean in persistent connection model.
> send/recv, latency for pure poll reqs may amplify.


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241903EB211
	for <lists+io-uring@lfdr.de>; Fri, 13 Aug 2021 09:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239501AbhHMH7D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Aug 2021 03:59:03 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:31866 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234844AbhHMH7D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Aug 2021 03:59:03 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UisBCrI_1628841504;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UisBCrI_1628841504)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 13 Aug 2021 15:58:25 +0800
Subject: Re: [PATCH for-5.15 0/3] small code clean
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210812041436.101503-1-haoxu@linux.alibaba.com>
 <577c70e9-e40d-c3df-2072-e0bcfe5f75dc@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <1d285d12-e40a-9472-bc78-9cb630c6595a@linux.alibaba.com>
Date:   Fri, 13 Aug 2021 15:58:24 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <577c70e9-e40d-c3df-2072-e0bcfe5f75dc@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/8/13 上午1:28, Jens Axboe 写道:
> On 8/11/21 10:14 PM, Hao Xu wrote:
>> Some small code clean.
>>
>> Hao Xu (3):
>>    io_uring: extract io_uring_files_cancel() in io_uring_task_cancel()
>>    io_uring: remove files pointer in cancellation functions
>>    io_uring: code clean for completion_lock in io_arm_poll_handler()
>>
>>   fs/io_uring.c            | 15 ++++++---------
>>   include/linux/io_uring.h |  9 +++++----
>>   kernel/exit.c            |  2 +-
>>   3 files changed, 12 insertions(+), 14 deletions(-)
> 
> This looks good, except 3/3 which I think was rebased and then not
> re-tested after doing so... That's a black mark.
> 
Actually I re-tested it after rebasing code and addressing the conflict
But the liburing tests results seems all good. Anyway, I'll check the
code more carefully when resolving conflict.
> Anyway, v2 looks fine, applied for 5.15.
> 


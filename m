Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A233F43193A
	for <lists+io-uring@lfdr.de>; Mon, 18 Oct 2021 14:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbhJRMht (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Oct 2021 08:37:49 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:50996 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229581AbhJRMht (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Oct 2021 08:37:49 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UsiHvPk_1634560536;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UsiHvPk_1634560536)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 18 Oct 2021 20:35:36 +0800
Subject: Re: [PATCH v2 0/2] async hybrid for pollable requests
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211018112923.16874-1-haoxu@linux.alibaba.com>
 <7a0d4182-6e08-99b9-ffca-483023f7a15f@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <55f9a560-e7f7-d37a-b0d5-a9327fc912c9@linux.alibaba.com>
Date:   Mon, 18 Oct 2021 20:35:36 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <7a0d4182-6e08-99b9-ffca-483023f7a15f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/10/18 下午8:31, Pavel Begunkov 写道:
> On 10/18/21 11:29, Hao Xu wrote:
>> 1/2 is a prep patch. 2/2 is the main one.
>> The good thing: see commit message.
>> the side effect: for normal io-worker path, added two if and two local
>> variables. for FORCE_ASYNC path, added three if and several dereferences
>>
>> I think it is fine since the io-worker path is not the fast path, and
>> the benefit of this patchset is worth it.
> 
> We don't care about overhead in iowq, but would be better to get rid
> of the in_worker in io_read(). See comments to 1/2.
> 
> Btw, you told that it performs better comparing to normal
> IOSQE_ASYNC. I'm confused, didn't we agree that it can be
> merged into IOSQE_ASYNC without extra flags?
I said 'better than the old logic IOSQE_ASYNC logic for pollable cases'..
> 
>>
>> Btw, we need to tweak the io-cancel.c a bit, not a big problem.
>> liburing tests will come later.
>>
>> v1-->v2:
>>   - split logic of force_nonblock
>>   - tweak added code in io_wq_submit_work to reduce overhead
>>   from Pavel's commments.
>>
>> Hao Xu (2):
>>    io_uring: split logic of force_nonblock
>>    io_uring: implement async hybrid mode for pollable requests
>>
>>   fs/io_uring.c                 | 85 ++++++++++++++++++++++++++---------
>>   include/uapi/linux/io_uring.h |  4 +-
>>   2 files changed, 66 insertions(+), 23 deletions(-)
>>
> 


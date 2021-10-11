Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E55428577
	for <lists+io-uring@lfdr.de>; Mon, 11 Oct 2021 05:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbhJKDKd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Oct 2021 23:10:33 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:49899 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231966AbhJKDKc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Oct 2021 23:10:32 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R511e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UrJjz2-_1633921711;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UrJjz2-_1633921711)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 11 Oct 2021 11:08:32 +0800
Subject: Re: [PATCH for-5.16 0/2] async hybrid, a new way for pollable
 requests
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211008123642.229338-1-haoxu@linux.alibaba.com>
 <57f4b76d-6148-98e2-3550-8fde5a4638f7@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <c0602c8a-d08d-7a0d-0639-ac2ca8d836b1@linux.alibaba.com>
Date:   Mon, 11 Oct 2021 11:08:31 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <57f4b76d-6148-98e2-3550-8fde5a4638f7@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/10/9 下午8:51, Pavel Begunkov 写道:
> On 10/8/21 13:36, Hao Xu wrote:
>> this is a new feature for pollable requests, see detail in commit
>> message.
> 
> It really sounds we should do it as a part of IOSQE_ASYNC, so
> what are the cons and compromises?
I wrote the pros and cons here:
https://github.com/axboe/liburing/issues/426#issuecomment-939221300

> 
>> Hao Xu (2):
>>    io_uring: add IOSQE_ASYNC_HYBRID flag for pollable requests
> 
> btw, it doesn't make sense to split it into two patches
Hmm, I thought we should make adding a new flag as a separate patch.
Could you give me more hints about the considerration here?
> 
>>    io_uring: implementation of IOSQE_ASYNC_HYBRID logic
>>
>>   fs/io_uring.c                 | 48 +++++++++++++++++++++++++++++++----
>>   include/uapi/linux/io_uring.h |  4 ++-
>>   2 files changed, 46 insertions(+), 6 deletions(-)
>>
> 


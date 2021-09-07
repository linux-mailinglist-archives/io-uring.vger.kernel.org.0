Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E584402264
	for <lists+io-uring@lfdr.de>; Tue,  7 Sep 2021 05:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbhIGDEC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Sep 2021 23:04:02 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:57915 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229797AbhIGDEC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Sep 2021 23:04:02 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UnY7Q0G_1630983774;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UnY7Q0G_1630983774)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 07 Sep 2021 11:02:55 +0800
Subject: Re: [PATCH] io_uring: fix bug of wrong BUILD_BUG_ON check
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210906151208.206851-1-haoxu@linux.alibaba.com>
 <f3857fde-7b3d-3d4f-9248-18a5387b8f79@gmail.com>
 <702b94b7-bd2f-f89c-b835-3345b8fcaa4a@linux.alibaba.com>
 <af3ee4c6-86bc-e8b0-227e-a109c75ae12d@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <5a6a6277-a69d-ad50-a7c5-f3474d1a38c8@linux.alibaba.com>
Date:   Tue, 7 Sep 2021 11:02:54 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <af3ee4c6-86bc-e8b0-227e-a109c75ae12d@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/7 上午3:15, Pavel Begunkov 写道:
> On 9/6/21 6:03 PM, Hao Xu wrote:
>> 在 2021/9/6 下午11:22, Pavel Begunkov 写道:
>>> On 9/6/21 4:12 PM, Hao Xu wrote:
>>>> Some check should be large than not equal or large than.
>>>>
>>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>>> ---
>>>>    fs/io_uring.c | 6 +++---
>>>>    1 file changed, 3 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index 2bde732a1183..3a833037af43 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -10637,13 +10637,13 @@ static int __init io_uring_init(void)
>>>>                 sizeof(struct io_uring_rsrc_update2));
>>>>          /* ->buf_index is u16 */
>>>> -    BUILD_BUG_ON(IORING_MAX_REG_BUFFERS >= (1u << 16));
>>>> +    BUILD_BUG_ON(IORING_MAX_REG_BUFFERS > (1u << 16));
>>>>          /* should fit into one byte */
>>>> -    BUILD_BUG_ON(SQE_VALID_FLAGS >= (1 << 8));
>>>> +    BUILD_BUG_ON(SQE_VALID_FLAGS > (1 << 8));
>>>
>>> 0xff = 255 is the largest number fitting in u8,
>>> 1<<8 = 256.
>>>
>>> let SQE_VALID_FLAGS = 256,
>>> (256 > (1<<8)) == (256 > 256) == false,  even though it can't
>>> be represented by u8.
>> Isn't SQE_VALID_FLAGS = 256 a valid value for it?
> 
> SQE_VALID_FLAGS is a "bitwise OR" combination of valid flags, so
> can't be go beyond 0xff
I see, don't know why I mix it with __REQ_F_LAST_BIT in my mind..
> 
>>>
>>>
>>>>        BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
>>>> -    BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
>>>> +    BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(int));
>>>>          req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
>>>>                    SLAB_ACCOUNT);
>>>>
>>>
>>
> 


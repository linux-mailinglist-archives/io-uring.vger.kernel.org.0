Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6657343FFB8
	for <lists+io-uring@lfdr.de>; Fri, 29 Oct 2021 17:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhJ2Pmw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Oct 2021 11:42:52 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:58900 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229826AbhJ2Pmu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Oct 2021 11:42:50 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UuANcqs_1635522019;
Received: from 192.168.31.215(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UuANcqs_1635522019)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 29 Oct 2021 23:40:20 +0800
Subject: Re: [PATCH liburing] io-cancel: add check for -ECANCELED
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211019092352.29782-1-haoxu@linux.alibaba.com>
 <ed9793a5-92e8-f5d9-3a33-d263bf5e760e@linux.alibaba.com>
 <172d0e03-4560-a686-82cd-f6cd6d12da6c@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <34fdf4c7-d60a-95f1-5d61-400e7bae2257@linux.alibaba.com>
Date:   Fri, 29 Oct 2021 23:40:19 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <172d0e03-4560-a686-82cd-f6cd6d12da6c@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/10/29 下午9:57, Pavel Begunkov 写道:
> On 10/29/21 13:27, Hao Xu wrote:
>> ping this one since test/io-cancel will be broken
>> if the async hybrid logic merges to 5.16
>> 在 2021/10/19 下午5:23, Hao Xu 写道:
>>> The req to be async cancelled will most likely return -ECANCELED after
>>> cancellation with the new async bybrid optimization applied. And -EINTR
>>> is impossible to be returned anymore since we won't be in INTERRUPTABLE
>>> sleep when reading, so remove it.
>>>
>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>> ---
>>>   test/io-cancel.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/test/io-cancel.c b/test/io-cancel.c
>>> index b5b443dc467b..c761e126be0c 100644
>>> --- a/test/io-cancel.c
>>> +++ b/test/io-cancel.c
>>> @@ -341,7 +341,7 @@ static int test_cancel_req_across_fork(void)
>>>                   fprintf(stderr, "wait_cqe=%d\n", ret);
>>>                   return 1;
>>>               }
>>> -            if ((cqe->user_data == 1 && cqe->res != -EINTR) ||
>>> +            if ((cqe->user_data == 1 && cqe->res != -ECANCELED) ||
> 
> cqe->res != -ECANCELED && cqe->res != -EINTR?
> 
> First backward compatibility, and in case internals or the test
> changes.
Ah, I see. Thanks Pavel.
> 
>>>                   (cqe->user_data == 2 && cqe->res != -EALREADY && 
>>> cqe->res)) {
>>>                   fprintf(stderr, "%i %i\n", (int)cqe->user_data, 
>>> cqe->res);
>>>                   exit(1);
>>>
>>
> 


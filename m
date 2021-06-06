Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8308239CF72
	for <lists+io-uring@lfdr.de>; Sun,  6 Jun 2021 16:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbhFFOKH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Jun 2021 10:10:07 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:38990 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230003AbhFFOKG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Jun 2021 10:10:06 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R871e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UbSrMv5_1622988495;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UbSrMv5_1622988495)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 06 Jun 2021 22:08:15 +0800
Subject: Re: Question about poll_multi_file
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <e90a3bdd-d60c-9b82-e711-c7a0b4f32c09@linux.alibaba.com>
 <f2fa9534-e07c-fd18-759e-b3ca99b714a7@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <4c341c96-8d66-eae3-ba4a-e1655ee463a8@linux.alibaba.com>
Date:   Sun, 6 Jun 2021 22:08:14 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <f2fa9534-e07c-fd18-759e-b3ca99b714a7@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/6/4 上午2:01, Jens Axboe 写道:
> On 6/3/21 6:53 AM, Hao Xu wrote:
>> Hi Jens,
>> I've a question about poll_multi_file in io_do_iopoll().
>> It keeps spinning in f_op->iopoll() if poll_multi_file is
>> true (and we're under the requested amount). But in my
>> understanding, reqs may be in different hardware queues
>> for blk-mq device even in this situation.
>> Should we consider the hardware queue number as well? Some
>> thing like below:
> 
> That looks reasonable to me - do you have any performance
> numbers to go with it?

Not very easy for me to construct a good case. I'm trying to
mock the below situation:
manully control uring reqs to go to 2 hardware queues, like:
    hw_queue0     hw_queue1
    heavy_req     simple_req
    heavy_req     simple_req
      ...            ...

heavy_req is some request that needs more time to complete,
while simple_req takes less time. And make the io_do_iopoll()
alway first spin on hw_queue0.
any ideas?

Thanks,
Hao
> 


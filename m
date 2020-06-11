Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8301F6AD4
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2020 17:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbgFKPUv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Jun 2020 11:20:51 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:34268 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728437AbgFKPUu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Jun 2020 11:20:50 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U.HbYpp_1591888843;
Received: from 30.39.248.235(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U.HbYpp_1591888843)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 11 Jun 2020 23:20:44 +0800
Subject: Re: [PATCH] io_uring: fix io_kiocb.flags modification race in IOPOLL
 mode
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, joseph.qi@linux.alibaba.com
References: <20200611092510.2963-1-xiaoguang.wang@linux.alibaba.com>
 <d0543873-7e78-62af-67fa-fa5ae9ed4e0f@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <3b5f1d1a-0a39-c277-6460-f35da4600200@linux.alibaba.com>
Date:   Thu, 11 Jun 2020 23:20:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <d0543873-7e78-62af-67fa-fa5ae9ed4e0f@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 6/11/20 3:25 AM, Xiaoguang Wang wrote:
>> While testing io_uring in arm, we found sometimes io_sq_thread() keeps
>> polling io requests even though there are not inflight io requests in
>> block layer. After some investigations, found a possible race about
>> io_kiocb.flags, see below race codes:
>>    1) in the end of io_write() or io_read()
>>      req->flags &= ~REQ_F_NEED_CLEANUP;
>>      kfree(iovec);
>>      return ret;
>>
>>    2) in io_complete_rw_iopoll()
>>      if (res != -EAGAIN)
>>          req->flags |= REQ_F_IOPOLL_COMPLETED;
>>
>> In IOPOLL mode, io requests still maybe completed by interrupt, then
>> above codes are not safe, concurrent modifications to req->flags, which
>> is not protected by lock or is not atomic modifications. I also had
>> disassemble io_complete_rw_iopoll() in arm:
>>     req->flags |= REQ_F_IOPOLL_COMPLETED;
>>     0xffff000008387b18 <+76>:    ldr     w0, [x19,#104]
>>     0xffff000008387b1c <+80>:    orr     w0, w0, #0x1000
>>     0xffff000008387b20 <+84>:    str     w0, [x19,#104]
>>
>> Seems that the "req->flags |= REQ_F_IOPOLL_COMPLETED;" is  load and
>> modification, two instructions, which obviously is not atomic.
>>
>> To fix this issue, add a new iopoll_completed in io_kiocb to indicate
>> whether io request is completed.
> 
> Long term, I want to ensure that IOPOLL irq completions are illegal, it
> should not be enabled (or possible) if the driver doesn't do pure polled
> completions.
Yes, agree.

> 
> Short term, I think your fix is fine, but should be turned into using
> READ_ONCE/WRITE_ONCE for the reading/setting of ->iopoll_completed.
> Can you resend it with that?
OK, I'll prepare one now.

Regards,
Xiaoguang Wang

> 

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D87B1A37AA
	for <lists+io-uring@lfdr.de>; Thu,  9 Apr 2020 18:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgDIQBz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Apr 2020 12:01:55 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:54112 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727736AbgDIQBz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Apr 2020 12:01:55 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R671e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07484;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0Tv3ZS4q_1586448104;
Received: from 30.39.148.30(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Tv3ZS4q_1586448104)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 10 Apr 2020 00:01:45 +0800
Subject: Re: [PATCH] io_uring: set error code to be ENOMEM when
 io_alloc_async_ctx() fails
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200409024820.2135-1-xiaoguang.wang@linux.alibaba.com>
 <3561b6eb-46df-e5b7-d9ae-0462d07e7722@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <5329b498-c2a2-26d0-0e21-c91db9c8c68f@linux.alibaba.com>
Date:   Fri, 10 Apr 2020 00:01:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <3561b6eb-46df-e5b7-d9ae-0462d07e7722@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 4/8/20 7:48 PM, Xiaoguang Wang wrote:
>> We should return ENOMEM for memory allocation failures, fix this
>> issue for io_alloc_async_ctx() calls.
> 
> It's not uncommon to have out-of-memory turn into -EAGAIN for the
> application for runtime allocations, indicating that the application
> could feasibly try again and hope for a better outcome (maybe after
> freeing memory).
OK, i see, thanks.

> 
> The error code is also documented as such in the io_uring_enter.2
> man page.
Yeah, I checked it just now, and I should read the man page carefully again :)

Regards,
Xiaoguang Wang

> 

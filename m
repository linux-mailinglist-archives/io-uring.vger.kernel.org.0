Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545994441F5
	for <lists+io-uring@lfdr.de>; Wed,  3 Nov 2021 13:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhKCM4Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Nov 2021 08:56:25 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:57813 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230282AbhKCM4Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Nov 2021 08:56:24 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UuvDVMD_1635944026;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UuvDVMD_1635944026)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Nov 2021 20:53:46 +0800
Subject: Re: [RFC] io-wq: decouple work_list protection from the big wqe->lock
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211031104945.224024-1-haoxu@linux.alibaba.com>
 <153b3bed-7aea-d4bb-1e5b-ffe11e8aabc1@linux.alibaba.com>
 <3c633538-7469-dc8c-561f-9fed7bfa699e@linux.alibaba.com>
 <ef805eea-7e90-9782-d59c-dff349d17490@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <fe248454-00c6-1800-1dda-a5441573d10d@linux.alibaba.com>
Date:   Wed, 3 Nov 2021 20:53:46 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <ef805eea-7e90-9782-d59c-dff349d17490@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/11/3 下午8:22, Jens Axboe 写道:
> On 11/3/21 6:17 AM, Hao Xu wrote:
>> ping this one.
> 
> I'll take a look at it, we do have some locking concerns here that would
> be nice to alleviate. But given that the patch came in right before the
> merge window, probably too late for 5.16 and I put it on the backburner
> a bit to tend to other items that were more pressing.
> 
Gotcha. Thanks, Jens.


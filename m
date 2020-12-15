Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AA02DA85B
	for <lists+io-uring@lfdr.de>; Tue, 15 Dec 2020 08:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgLOHAl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Dec 2020 02:00:41 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:18985 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726289AbgLOHAl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Dec 2020 02:00:41 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UIi2izO_1608015588;
Received: from 30.225.32.197(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UIi2izO_1608015588)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 15 Dec 2020 14:59:48 +0800
Subject: Re: Lockdep warning on io_file_data_ref_zero() with 5.10-rc5
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Nadav Amit <nadav.amit@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
References: <C3012989-5B09-4A88-B271-542C1ED91ABE@gmail.com>
 <c16232dd-5841-6e87-bbd0-0c18f0fc982b@gmail.com>
 <13baf2c4-a403-41fc-87ca-6f5cb7999692@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <e9f232a9-f28e-a987-c971-d8185c0060f5@linux.alibaba.com>
Date:   Tue, 15 Dec 2020 14:58:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <13baf2c4-a403-41fc-87ca-6f5cb7999692@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 11/28/20 5:13 PM, Pavel Begunkov wrote:
>> On 28/11/2020 23:59, Nadav Amit wrote:
>>> Hello Pavel,
>>>
>>> I got the following lockdep splat while rebasing my work on 5.10-rc5 on the
>>> kernel (based on 5.10-rc5+).
>>>
>>> I did not actually confirm that the problem is triggered without my changes,
>>> as my iouring workload requires some kernel changes (not iouring changes),
>>> yet IMHO it seems pretty clear that this is a result of your commit
>>> e297822b20e7f ("io_uring: order refnode recycling”), that acquires a lock in
>>> io_file_data_ref_zero() inside a softirq context.
>>
>> Yeah, that's true. It was already reported by syzkaller and fixed by Jens, but
>> queued for 5.11. Thanks for letting know anyway!
>>
>> https://lore.kernel.org/io-uring/948d2d3b-5f36-034d-28e6-7490343a5b59@kernel.dk/T/#t
>>
>>
>> Jens, I think it's for the best to add it for 5.10, at least so that lockdep
>> doesn't complain.
> 
> Yeah maybe, though it's "just" a lockdep issue, it can't trigger any
> deadlocks. I'd rather just keep it in 5.11 and ensure it goes to stable.
> This isn't new in this series.
Sorry, I'm not familiar with lockdep implementation, here I wonder why you say
it can't trigger any deadlocks, looking at that the syzbot report, seems that
the deadlock may happen.

And I also wonder whether spin lock bh variants are enough, normal ios are
completed in interrupt context,
==> io_complete_rw
====> __io_complete_rw
======> io_complete_rw_common
========> __io_req_complete
==========> io_put_req
============> io_free_req
==============> __io_free_req
================> io_dismantle_req
==================> io_put_file
====================> percpu_ref_put(req->fixed_file_refs);
                       if we drop the last reference here,
                       io_file_data_ref_zero() will be called,
                       then we'll call spin_lock(&data->lock);
                       in interrupt context.

Should we use spin lock irq variants?

Regards,
Xiaoguang Wang

> 

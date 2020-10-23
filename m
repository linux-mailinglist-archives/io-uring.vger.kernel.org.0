Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7EB42968D0
	for <lists+io-uring@lfdr.de>; Fri, 23 Oct 2020 05:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369330AbgJWDeh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 23:34:37 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:56351 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S368871AbgJWDeg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 23:34:36 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UCthlsO_1603424074;
Received: from 30.225.32.192(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UCthlsO_1603424074)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 23 Oct 2020 11:34:35 +0800
Subject: Re: [PATCH for-5.10] io_uring: remove req cancel in ->flush()
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <21aca47e03c82a06e4ea1140b328a86d04d1f422.1603122023.git.asml.silence@gmail.com>
 <13c73e10-040f-9a0b-5396-b3f2a0c301b0@linux.alibaba.com>
 <97c154a6-1020-d5b0-7ff4-9777b6df13c7@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <18fecee1-05a4-ca49-0530-73790f584d7e@linux.alibaba.com>
Date:   Fri, 23 Oct 2020 11:33:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <97c154a6-1020-d5b0-7ff4-9777b6df13c7@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 22/10/2020 07:42, Xiaoguang Wang wrote:
>>> Every close(io_uring) causes cancellation of all inflight requests
>>> carrying ->files. That's not nice but was neccessary up until recently.
>>> Now task->files removal is handled in the core code, so that part of
>>> flush can be removed.
>> I don't catch up with newest io_uring codes yet, but have one question about
>> the initial implementation "io_uring: io_uring: add support for async work
>> inheriting files": https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fcb323cc53e29d9cc696d606bb42736b32dd9825
>> There was such comments:
>> +static int io_grab_files(struct io_ring_ctx *ctx, struct io_kiocb *req)
>> +{
>> +       int ret = -EBADF;
>> +
>> +       rcu_read_lock();
>> +       spin_lock_irq(&ctx->inflight_lock);
>> +       /*
>> +        * We use the f_ops->flush() handler to ensure that we can flush
>> +        * out work accessing these files if the fd is closed. Check if
>> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> I wonder why we only need to flush reqs specifically when they access current->files, are there
>> any special reasons?
> We could have taken a reference to ->files, so it doesn't get freed
> while a request is using it, but that creates a circular dependency.
> 
> IIUC, because if there are ->files refs io_uring won't be closed on exit,
> but io_uring would be holding ->files refs.
> 
> So, it was working without taking ->files references (i.e. weak refs)
> on the basis that the files won't be destroyed until the task itself is
> gone, and we can *kind of* intercept when task is exiting by ->flush()
> and cancel all requests with ->files there.
Now I see :) will help me to understand current codes better.
Really thanks for your explanations.

Regards,
Xiaoguang Wang
> 

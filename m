Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB22829AD70
	for <lists+io-uring@lfdr.de>; Tue, 27 Oct 2020 14:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752295AbgJ0Nfs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Oct 2020 09:35:48 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:53614 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752282AbgJ0Nfs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Oct 2020 09:35:48 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UDNENH4_1603805745;
Received: from 30.225.32.190(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UDNENH4_1603805745)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 27 Oct 2020 21:35:45 +0800
Subject: Re: [PATCH 0/2] improve SQPOLL handling
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        joseph.qi@linux.alibaba.com
References: <20201020082345.19628-1-xiaoguang.wang@linux.alibaba.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <9b0ee22a-1dc3-932e-d2a7-360ff463e04d@linux.alibaba.com>
Date:   Tue, 27 Oct 2020 21:34:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201020082345.19628-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hello,

This is a gentle ping.

Regards,
Xiaogaung Wang

> The first patch tries to improve various issues in current implementation:
>    The prepare_to_wait() usage in __io_sq_thread() is weird. If multiple ctxs
> share one same poll thread, one ctx will put poll thread in TASK_INTERRUPTIBLE,
> but if other ctxs have work to do, we don't need to change task's stat at all.
> I think only if all ctxs don't have work to do, we can do it.
>    We use round-robin strategy to make multiple ctxs share one same poll thread,
> but there are various condition in __io_sq_thread(), which seems complicated and
> may affect round-robin strategy.
>    In io_sq_thread(), we always call io_sq_thread_drop_mm() when we complete a
> round of ctxs iteration, which maybe inefficient.
> 
> The second patch adds a IORING_SETUP_SQPOLL_PERCPU flag, for those rings which
> have SQPOLL enabled and are willing to be bound to one same cpu, hence share
> one same poll thread, add a capability that these rings can share one poll thread
> by specifying a new IORING_SETUP_SQPOLL_PERCPU flag. FIO tool can integrate this
> feature easily, so we can test multiple rings to share same poll thread easily.
> 
> Xiaoguang Wang (2):
>    io_uring: refactor io_sq_thread() handling
>    io_uring: support multiple rings to share same poll thread by
>      specifying same cpu
> 
>   fs/io_uring.c                 | 307 ++++++++++++++++++++--------------
>   include/uapi/linux/io_uring.h |   1 +
>   2 files changed, 181 insertions(+), 127 deletions(-)
> 

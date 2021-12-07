Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2D246B9EB
	for <lists+io-uring@lfdr.de>; Tue,  7 Dec 2021 12:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235471AbhLGLVn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Dec 2021 06:21:43 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:56421 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235563AbhLGLVk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Dec 2021 06:21:40 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UzmqVOa_1638875888;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UzmqVOa_1638875888)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 07 Dec 2021 19:18:09 +0800
Subject: Re: [PATCH v7 0/5] task optimization
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211207093951.247840-1-haoxu@linux.alibaba.com>
Message-ID: <fa831488-4a6a-78fc-fd24-581ae1b5b436@linux.alibaba.com>
Date:   Tue, 7 Dec 2021 19:18:08 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211207093951.247840-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/12/7 下午5:39, Hao Xu 写道:
> v4->v5
> - change the implementation of merge_wq_list
> 
> v5->v6
> - change the logic of handling prior task list to:
>    1) grabbed uring_lock: leverage the inline completion infra
>    2) otherwise: batch __req_complete_post() calls to save
>       completion_lock operations.
> 
> v6->v7
> - add Pavel's fix of wrong spin unlock
> - remove a patch and rebase work
> 
> Hao Xu (5):
>    io-wq: add helper to merge two wq_lists
>    io_uring: add a priority tw list for irq completion work
>    io_uring: add helper for task work execution code
>    io_uring: split io_req_complete_post() and add a helper
>    io_uring: batch completion in prior_task_list
> 
>   fs/io-wq.h    |  22 ++++++++
>   fs/io_uring.c | 142 ++++++++++++++++++++++++++++++++++++--------------
>   2 files changed, 126 insertions(+), 38 deletions(-)
> 
typo: the subject should be task work optimization..


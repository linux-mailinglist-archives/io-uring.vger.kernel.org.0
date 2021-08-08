Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429883E39E2
	for <lists+io-uring@lfdr.de>; Sun,  8 Aug 2021 12:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhHHKbr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 Aug 2021 06:31:47 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:60885 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229613AbhHHKbr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 Aug 2021 06:31:47 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R311e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UiIWvzl_1628418686;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UiIWvzl_1628418686)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 08 Aug 2021 18:31:26 +0800
Subject: Re: [PATCH v2 0/3] code clean and nr_worker fixes
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210808101247.189083-1-haoxu@linux.alibaba.com>
Message-ID: <3a386470-6e85-c1e9-86f7-edadb8d4ddb9@linux.alibaba.com>
Date:   Sun, 8 Aug 2021 18:31:26 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210808101247.189083-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/8/8 下午6:12, Hao Xu 写道:
Since the old patches have been merged, I'll resend fixes based on the
new code baseline. Please ignore this patchset.
> v1-->v2
>    - fix bug of creating io-wokers unconditionally
>    - fix bug of no nr_running and worker_ref decrementing when fails
>    - fix bug of setting IO_WORKER_BOUND_FIXED incorrectly.
> 
> Hao Xu (3):
>    io-wq: fix no lock protection of acct->nr_worker
>    io-wq: fix lack of acct->nr_workers < acct->max_workers judgement
>    io-wq: fix IO_WORKER_F_FIXED issue in create_io_worker()
> 
>   fs/io-wq.c | 52 ++++++++++++++++++++++++++++++++++++++++++----------
>   1 file changed, 42 insertions(+), 10 deletions(-)
> 


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935BD3F507B
	for <lists+io-uring@lfdr.de>; Mon, 23 Aug 2021 20:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhHWSmD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Aug 2021 14:42:03 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:42754 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229883AbhHWSmD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Aug 2021 14:42:03 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R411e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UlQlpAX_1629744078;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UlQlpAX_1629744078)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 24 Aug 2021 02:41:19 +0800
Subject: Re: [PATCH 2/2] io_uring: add irq completion work to the head of
 task_list
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210823183648.163361-1-haoxu@linux.alibaba.com>
 <20210823183648.163361-3-haoxu@linux.alibaba.com>
Message-ID: <0520539b-d366-1912-49a2-9e6126e4df1d@linux.alibaba.com>
Date:   Tue, 24 Aug 2021 02:41:18 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210823183648.163361-3-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/8/24 上午2:36, Hao Xu 写道:
> Now we have a lot of task_work users, some are just to complete a req
> and generate a cqe. Let's put the work at the head position of the
> task_list, so that it can be handled quickly and thus to reduce
> avg req latency. an explanatory case:
> 
> origin timeline:
>      submit_sqe-->irq-->add completion task_work
>      -->run heavy work0~n-->run completion task_work
> now timeline:
>      submit_sqe-->irq-->add completion task_work
>      -->run completion task_work-->run heavy work0~n
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
sorry, sent this old version by mistake, will send latest version later.
the latest one is to add high priority task_work to the front of
task_list in the time order, not the reverse order.

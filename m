Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1DF43CED5
	for <lists+io-uring@lfdr.de>; Wed, 27 Oct 2021 18:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235698AbhJ0Ql6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Oct 2021 12:41:58 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:43075 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233805AbhJ0Ql6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Oct 2021 12:41:58 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R471e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Utv94jR_1635352770;
Received: from 192.168.31.215(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Utv94jR_1635352770)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 28 Oct 2021 00:39:30 +0800
Subject: Re: [PATCH for-5.16 v3 0/8] task work optimization
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211027140216.20008-1-haoxu@linux.alibaba.com>
Message-ID: <c1708cfc-aa9b-bf9a-06b1-dac9ecae5f01@linux.alibaba.com>
Date:   Thu, 28 Oct 2021 00:39:30 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211027140216.20008-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/10/27 下午10:02, Hao Xu 写道:
> Tested this patchset by manually replace __io_queue_sqe() in
> io_queue_sqe() by io_req_task_queue() to construct 'heavy' task works.
> Then test with fio:
> 
> ioengine=io_uring
> sqpoll=1
> thread=1
> bs=4k
> direct=1
> rw=randread
> time_based=1
> runtime=600
> randrepeat=0
> group_reporting=1
> filename=/dev/nvme0n1
> 
> 2/8 set unlimited priority_task_list, 8/8 set a limitation of
> 1/3 * (len_prority_list + len_normal_list), data below:
>     depth     no 8/8   include 8/8      before this patchset
>      1        7.05         7.82              7.10
>      2        8.47         8.48              8.60
>      4        10.42        9.99              10.42
>      8        13.78        13.13             13.22
>      16       27.41        27.92             24.33
>      32       49.40        46.16             53.08
>      64       102.53       105.68            103.36
>      128      196.98       202.76            205.61
>      256      372.99       375.61            414.88
>      512      747.23       763.95            791.30
>      1024     1472.59      1527.46           1538.72
>      2048     3153.49      3129.22           3329.01
>      4096     6387.86      5899.74           6682.54
>      8192     12150.25     12433.59          12774.14
>      16384    23085.58     24342.84          26044.71
> 
The data in the previous v2 version seems not right, I may miss
something at that time.
> It seems 2/8 is better, haven't tried other choices other than 1/3,
> still put 8/8 here for people's further thoughts.
> 
> Hao Xu (8):
>    io-wq: add helper to merge two wq_lists
>    io_uring: add a priority tw list for irq completion work
>    io_uring: add helper for task work execution code
>    io_uring: split io_req_complete_post() and add a helper
>    io_uring: move up io_put_kbuf() and io_put_rw_kbuf()
>    io_uring: add nr_ctx to record the number of ctx in a task
>    io_uring: batch completion in prior_task_list
>    io_uring: add limited number of TWs to priority task list
> 
>   fs/io-wq.h    |  21 +++++++
>   fs/io_uring.c | 168 +++++++++++++++++++++++++++++++++++---------------
>   2 files changed, 138 insertions(+), 51 deletions(-)
> 


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E951F239DCF
	for <lists+io-uring@lfdr.de>; Mon,  3 Aug 2020 05:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgHCDQT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 2 Aug 2020 23:16:19 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:44814 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725863AbgHCDQT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 2 Aug 2020 23:16:19 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07425;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0U4WbRYc_1596424572;
Received: from ali-186590e05fa3.local(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0U4WbRYc_1596424572)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 03 Aug 2020 11:16:13 +0800
Subject: Re: [PATCH liburing 1/2] io_uring_enter: add timeout support
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
References: <1596017415-39101-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <1596017415-39101-2-git-send-email-jiufei.xue@linux.alibaba.com>
 <0f6cdf31-fbec-d447-989d-969bb936838a@kernel.dk>
 <0002bd2c-1375-2b95-fe98-41ee0895141e@linux.alibaba.com>
 <252c29a9-9fb4-a61f-6899-129fd04db4a0@kernel.dk>
 <cc7dab04-9f19-5918-b1e6-e3d17bd0762f@linux.alibaba.com>
 <e542502e-7f8c-2dd2-053b-6e78d49b1f6a@kernel.dk>
 <ec69d835-ddca-88bc-a97e-8f0d4d621bda@linux.alibaba.com>
 <253b4df7-a35b-4d49-8cdc-c6fa24446bf9@kernel.dk>
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
Message-ID: <fccac1a9-17b6-28ac-728d-3c6975111671@linux.alibaba.com>
Date:   Mon, 3 Aug 2020 11:16:12 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <253b4df7-a35b-4d49-8cdc-c6fa24446bf9@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

On 2020/7/31 上午11:57, Jens Axboe wrote:
> Then why not just make the sqe-less timeout path flush existing requests,
> if it needs to? Seems a lot simpler than adding odd x2 variants, which
> won't really be clear.
> 
Flushing the requests will access and modify the head of submit queue, that
may race with the submit thread. I think the reap thread should not touch
the submit queue when IORING_FEAT_GETEVENTS_TIMEOUT is supported.

> Chances are, if it's called with sq entries pending, the caller likely
> wants those submitted. Either the caller was aware and relying on that
> behavior, or the caller is simply buggy and has a case where it doesn't
> submit IO before waiting for completions.
>

That is not true when the SQ/CQ handling are split in two different threads.
The reaping thread is not aware of the submit queue. It should only wait for
completion of the requests, such as below:

submitting_thread:                   reaping_thread:

io_uring_get_sqe()
io_uring_prep_nop()     
                                 io_uring_wait_cqe_timeout2()
io_uring_submit()
                                 woken if requests are completed or timeout


And if the SQ/CQ handling are in the same thread, applications should use the
old API if they do not want to submit the request themselves.

io_uring_get_sqe
io_uring_prep_nop
io_uring_wait_cqe_timeout

> Hence I really don't think that's a big deal, and even arguably the right
> thing to do.

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE982037FE
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2020 15:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbgFVN3O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Jun 2020 09:29:14 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:60642 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728164AbgFVN3O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Jun 2020 09:29:14 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R971e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01358;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U0PAyjI_1592832550;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0U0PAyjI_1592832550)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 22 Jun 2020 21:29:10 +0800
Date:   Mon, 22 Jun 2020 21:29:10 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     io-uring <io-uring@vger.kernel.org>
Cc:     axboe@kernel.dk, Dust.li@linux.alibaba.com
Subject: [RFC] io_commit_cqring __io_cqring_fill_event take up too much cpu
Message-ID: <20200622132910.GA99461@e02h04398.eu6sqa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,
I found a problem, and I think it is necessary to solve it. But the change
may be relatively large, so I would like to ask you and everyone for your
opinions. Or everyone has other ideas about this issue:

Problem description:
===================
I found that in the sq thread mode, the CPU used by io_commit_cqring and
__io_cqring_fill_event accounts for a relatively large amount. The reason is
because a large number of calls to smp_store_release and WRITE_ONCE.
These two functions are relatively slow, and we need to call smp_store_release
every time we submit a cqe. This large number of calls has caused this
problem to become very prominent.

My test environment is in qemu, using io_uring to accept a large number of
udp packets in sq thread mode, the speed is 800000pps. I submitted 100 sqes
to recv udp packet at the beginning of the application, and every time I
received a cqe, I submitted another sqe. The perf top result of sq thread is
as follows:



17.97% [kernel] [k] copy_user_generic_unrolled
13.92% [kernel] [k] io_commit_cqring
11.04% [kernel] [k] __io_cqring_fill_event
10.33% [kernel] [k] udp_recvmsg
  5.94% [kernel] [k] skb_release_data
  4.31% [kernel] [k] udp_rmem_release
  2.68% [kernel] [k] __check_object_size
  2.24% [kernel] [k] __slab_free
  2.22% [kernel] [k] _raw_spin_lock_bh
  2.21% [kernel] [k] kmem_cache_free
  2.13% [kernel] [k] free_pcppages_bulk
  1.83% [kernel] [k] io_submit_sqes
  1.38% [kernel] [k] page_frag_free
  1.31% [kernel] [k] inet_recvmsg



It can be seen that io_commit_cqring and __io_cqring_fill_event account
for 24.96%. This is too much. In general, the proportion of syscall may not
be so high, so we must solve this problem.


Solution:
=================
I consider that when the nr of an io_submit_sqes is too large, we don't call
io_cqring_add_event directly, we can put the completed req in the queue, and
then call __io_cqring_fill_event for each req then call once io_commit_cqring
at the end of the io_submit_sqes function. In this way my local simple test
looks good.


Thanks for your feedback,
Xuan Zhuo



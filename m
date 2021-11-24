Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D4C45B39B
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 05:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbhKXEuF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Nov 2021 23:50:05 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:54610 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229588AbhKXEuF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Nov 2021 23:50:05 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uy45oE2_1637729208;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uy45oE2_1637729208)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 24 Nov 2021 12:46:54 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [RFC 0/9] fixed worker: a new way to handle io works
Date:   Wed, 24 Nov 2021 12:46:39 +0800
Message-Id: <20211124044648.142416-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is big contension in current io-wq implementation. Introduce a new
type io-worker called fixed-worker to solve this problem. it is also a
new way to handle works. In this new system, works are dispatched to
different private queues rather than a long shared queue.

Detail introduction and data in 7/9.

To be done: 1) the hash optimization isn't applied yet
            2) user interface
            3) cannot ensure linear order for works of same reg file
               writing since we now have multiple work lists.
            4) code clean

Sent this for suggestions.

The test program used in this patchset:
// nop_test.c
// remove some error handling, variable definition, header files etc.
typedef long long ll;
ll usecs(struct timeval tv) {
    return tv.tv_sec*(ll)1000*1000+tv.tv_usec;
}

static int test_single_nop(struct io_uring *ring, int depth)
{
    for (i=0; i<depth; i++) {
        sqe = io_uring_get_sqe(ring);
        io_uring_prep_nop(sqe);
        sqe->flags |= IOSQE_ASYNC;
    }
    ret = io_uring_submit(ring);
    for(i=0; i<depth; i++) {
        ret = io_uring_wait_cqe(ring, &cqe);
        io_uring_cqe_seen(ring, cqe);
    }
    return 0;
}

int main(int argc, char *argv[])
{
    ll delta;
    struct io_uring ring;
    int ret, l, loop=4000000, depth = 10;
    struct timeval tv_begin, tv_end;
    struct timezone tz;

    ret = io_uring_queue_init(10010, &ring, 0);
    if (ret) {
        fprintf(stderr, "ring setup failed: %d\n", ret);
        return 1;
    }
    l = loop;
    gettimeofday(&tv_begin, &tz);
    while(loop--)
        test_single_nop(&ring, depth);
    gettimeofday(&tv_end, &tz);
    delta =  usecs(tv_end) - usecs(tv_begin);
    printf("time spent: %lld usecs\n", delta);
    printf("IOPS: %lld\n", (ll)l * depth * 1000000 / delta);

    return 0;
}


Hao Xu (9):
  io-wq: decouple work_list protection from the big wqe->lock
  io-wq: reduce acct->lock crossing functions lock/unlock
  io-wq: update check condition for lock
  io-wq: use IO_WQ_ACCT_NR rather than hardcoded number
  io-wq: move hash wait entry to io_wqe_acct
  io-wq: add infra data structure for fix workers
  io-wq: implement fixed worker logic
  io-wq: batch the handling of fixed worker private works
  io-wq: small optimization for __io_worker_busy()

 fs/io-wq.c | 415 ++++++++++++++++++++++++++++++++++++++---------------
 fs/io-wq.h |   5 +
 2 files changed, 308 insertions(+), 112 deletions(-)

-- 
2.24.4


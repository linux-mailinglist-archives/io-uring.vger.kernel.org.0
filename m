Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 362EA5277B8
	for <lists+io-uring@lfdr.de>; Sun, 15 May 2022 15:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236829AbiEONMn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 May 2022 09:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236816AbiEONMl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 May 2022 09:12:41 -0400
Received: from pv50p00im-ztdg10022001.me.com (pv50p00im-ztdg10022001.me.com [17.58.6.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00C5DF67
        for <io-uring@vger.kernel.org>; Sun, 15 May 2022 06:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1652620360;
        bh=8WCTQZrjQTHjtpMv8jpcGjGxVWoNWwtMq4gMe7Q1X7Q=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=1TlY2I5KMU/HfNwHcdAS8VLQzSEtWtJN83XuyYG1HmQoacw24N9ruZb/J3kPcbsAD
         t5/OH4TmfmBEbNXbAZFdD8ABf2P1v/cRQ61Ba8IePdQ41Uoa7ufkMSMqkGzRSZw167
         oDF65t9SyT/onEuKYKVWosDlfTwzg0H6HI6n06gMYEU1PL4UPkOnh5FfUVatsDx71Z
         E6cE07dZvPNf4s2gyxWM4pHgT7UJMuWZQxS73Xi1rm4DjYZb1BTHaxD6rDxuP/6kIE
         ONHx0fYpzK32b3vYmON4s67spisB3AMgSx++OZDvBWKov8HwIDsW9MSc9hrEcaLGU7
         fO9X+k47cvhHA==
Received: from localhost.localdomain (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10022001.me.com (Postfix) with ESMTPSA id 151863E1F19;
        Sun, 15 May 2022 13:12:37 +0000 (UTC)
From:   Hao Xu <haoxu.linux@icloud.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v4 00/11] fixed worker
Date:   Sun, 15 May 2022 21:12:19 +0800
Message-Id: <20220515131230.155267-1-haoxu.linux@icloud.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-15_07:2022-05-13,2022-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=958 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2205150069
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

This is the second version of fixed worker implementation.
Wrote a nop test program to test it, 3 fixed-workers VS 3 normal workers.
normal workers:
./run_nop_wqe.sh nop_wqe_normal 200000 100 3 1-3
        time spent: 10464397 usecs      IOPS: 1911242
        time spent: 9610976 usecs       IOPS: 2080954
        time spent: 9807361 usecs       IOPS: 2039284

fixed workers:
./run_nop_wqe.sh nop_wqe_fixed 200000 100 3 1-3
        time spent: 17314274 usecs      IOPS: 1155116
        time spent: 17016942 usecs      IOPS: 1175299
        time spent: 17908684 usecs      IOPS: 1116776

About 2x improvement. From perf result, almost no acct->lock contension.
Test program: https://github.com/HowHsu/liburing/tree/fixed_worker
liburing/test/nop_wqe.c

v3->v4:
 - make work in fixed worker's private worfixed worker
 - tweak the io_wqe_acct struct to make it clearer


Hao Xu (11):
  io-wq: add a worker flag for individual exit
  io-wq: change argument of create_io_worker() for convienence
  io-wq: add infra data structure for fixed workers
  io-wq: tweak io_get_acct()
  io-wq: fixed worker initialization
  io-wq: fixed worker exit
  io-wq: implement fixed worker logic
  io-wq: batch the handling of fixed worker private works
  io_uring: add register fixed worker interface
  io-wq: add an work list for fixed worker
  io_uring: cancel works in exec work list for fixed worker

 fs/io-wq.c                    | 481 ++++++++++++++++++++++++++++++----
 fs/io-wq.h                    |   8 +
 fs/io_uring.c                 |  71 +++++
 include/uapi/linux/io_uring.h |  11 +
 4 files changed, 525 insertions(+), 46 deletions(-)


base-commit: fa5da31df51f8f581ec1776e613c1bcabbe9559f
-- 
2.25.1


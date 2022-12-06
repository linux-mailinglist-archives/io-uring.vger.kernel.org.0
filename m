Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B39FE643FF4
	for <lists+io-uring@lfdr.de>; Tue,  6 Dec 2022 10:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiLFJjC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 04:39:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234156AbiLFJi7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 04:38:59 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAAC1AD99;
        Tue,  6 Dec 2022 01:38:57 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B68NiHI017013;
        Tue, 6 Dec 2022 09:38:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=h+xqY3ap6uUHi01HvJo5PCdAUlQP/OuCOPGu3xuefWk=;
 b=U6bRebwq0a09eqoYyMUBMzvDDuwlnT3h2M5neEXXJTjqnJUyjSZL82rFrVrIJGNRuFuw
 mY51NhaY9FsGHfoY22j9HVv4THWFsxhfi4Bnd1jhww8Wx0ODlHbxJaHkNzyTxWUhTzZq
 eza7QQfbD7WwT/nK3cfckhC5vH7baAwGYnZKmMiDFSbR3h6RvEUzFDRlQA7t1qpaHtTV
 b57TX+gTY7VlaIDq9c0+McWcVhvm/FtkV/xauiQIG9zoaCVlx0PsUJVJxK0c70KERHFp
 r20RA8VJ6vPT2zPCfHA336k4/37bA7JcksXw/pWU1Ex3OhqolgmqXGbs8L7dIFFVm/uV /g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7ybgpmat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 09:38:55 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B67VZf2031092;
        Tue, 6 Dec 2022 09:38:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m8ua0ahce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 09:38:47 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B69clcE006666;
        Tue, 6 Dec 2022 09:38:47 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3m8ua0ahc9-1;
        Tue, 06 Dec 2022 09:38:47 +0000
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     harshit.m.mogalapalli@oracle.com, harshit.m.mogalapalli@gmail.com,
        vegard.nossum@oracle.com, george.kennedy@oracle.com,
        darren.kenny@oracle.com, syzkaller <syzkaller@googlegroups.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: Fix a null-ptr-deref in io_tctx_exit_cb()
Date:   Tue,  6 Dec 2022 01:38:32 -0800
Message-Id: <20221206093833.3812138-1-harshit.m.mogalapalli@oracle.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_05,2022-12-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=901 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212060079
X-Proofpoint-ORIG-GUID: pYNp8N-3mGfidp7miOcVNRWjSqIG7PZh
X-Proofpoint-GUID: pYNp8N-3mGfidp7miOcVNRWjSqIG7PZh
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Syzkaller reports a NULL deref bug as follows:

 BUG: KASAN: null-ptr-deref in io_tctx_exit_cb+0x53/0xd3
 Read of size 4 at addr 0000000000000138 by task file1/1955

 CPU: 1 PID: 1955 Comm: file1 Not tainted 6.1.0-rc7-00103-gef4d3ea40565 #75
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
 Call Trace:
  <TASK>
  dump_stack_lvl+0xcd/0x134
  ? io_tctx_exit_cb+0x53/0xd3
  kasan_report+0xbb/0x1f0
  ? io_tctx_exit_cb+0x53/0xd3
  kasan_check_range+0x140/0x190
  io_tctx_exit_cb+0x53/0xd3
  task_work_run+0x164/0x250
  ? task_work_cancel+0x30/0x30
  get_signal+0x1c3/0x2440
  ? lock_downgrade+0x6e0/0x6e0
  ? lock_downgrade+0x6e0/0x6e0
  ? exit_signals+0x8b0/0x8b0
  ? do_raw_read_unlock+0x3b/0x70
  ? do_raw_spin_unlock+0x50/0x230
  arch_do_signal_or_restart+0x82/0x2470
  ? kmem_cache_free+0x260/0x4b0
  ? putname+0xfe/0x140
  ? get_sigframe_size+0x10/0x10
  ? do_execveat_common.isra.0+0x226/0x710
  ? lockdep_hardirqs_on+0x79/0x100
  ? putname+0xfe/0x140
  ? do_execveat_common.isra.0+0x238/0x710
  exit_to_user_mode_prepare+0x15f/0x250
  syscall_exit_to_user_mode+0x19/0x50
  do_syscall_64+0x42/0xb0
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
 RIP: 0023:0x0
 Code: Unable to access opcode bytes at 0xffffffffffffffd6.
 RSP: 002b:00000000fffb7790 EFLAGS: 00000200 ORIG_RAX: 000000000000000b
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
 RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
 R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
  </TASK>
 Kernel panic - not syncing: panic_on_warn set ...

Add a NULL check on tctx to prevent this.

Fixes: d56d938b4bef ("io_uring: do ctx initiated file note removal")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
---
Could not find the root cause of this.
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8840cf3e20f2..20f7d8655b50 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2708,7 +2708,7 @@ static __cold void io_tctx_exit_cb(struct callback_head *cb)
 	 * When @in_idle, we're in cancellation and it's racy to remove the
 	 * node. It'll be removed by the end of cancellation, just ignore it.
 	 */
-	if (!atomic_read(&tctx->in_idle))
+	if (tctx && !atomic_read(&tctx->in_idle))
 		io_uring_del_tctx_node((unsigned long)work->ctx);
 	complete(&work->completion);
 }
-- 
2.38.1


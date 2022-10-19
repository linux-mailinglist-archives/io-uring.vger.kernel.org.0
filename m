Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01FFD604E41
	for <lists+io-uring@lfdr.de>; Wed, 19 Oct 2022 19:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiJSRMf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Oct 2022 13:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiJSRMe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Oct 2022 13:12:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5911C19C9;
        Wed, 19 Oct 2022 10:12:33 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JGnuGu003161;
        Wed, 19 Oct 2022 17:12:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=9+6DkXbVc2UcQKAgPXBH88iNfcHzIH1zQo7sOPvAnqo=;
 b=hIX40z7/5PP4LZC7jlB0YIiOIlp4OazY76uDRC3woSVlNS4JMj/G+STls3lGzxl4i+10
 jjjntWIvlt64yWptVFDkvptQHhZUDVScyycKmIppmgtsropgMtNLcRriMjUAMnJuE7qw
 qL8OC5O8eE0aZsnlfvtimiMjG5HbqzzXqo4S58pdXD8r4/9nkE49mGuJKLzIMiNjp4Cj
 ChaqhlVlW6bIvVEFNReMB3mVQGGvcHebtBWgPuZpLAdVQz5XIyqmzJEt8ZlW7aBzFSn+
 oK5K58mIQe/zRXfdnkc0b58xwwIeAbdhCgFg745CKb8BeezjmzSDhiey5v2Hbc+UcQU6 xg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k99ntetas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 17:12:30 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29JGA1gf040515;
        Wed, 19 Oct 2022 17:12:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hu7xukx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 17:12:29 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29JHCToN030014;
        Wed, 19 Oct 2022 17:12:29 GMT
Received: from ca-dev110.us.oracle.com (ca-dev110.us.oracle.com [10.129.136.45])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3k8hu7xuk8-1;
        Wed, 19 Oct 2022 17:12:29 +0000
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     vegard.nossum@oracle.com, harshit.m.mogalapalli@gmail.com,
        harshit.m.mogalapalli@oracle.com,
        syzkaller <syzkaller@googlegroups.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/msg_ring: Fix NULL pointer dereference in io_msg_send_fd()
Date:   Wed, 19 Oct 2022 10:12:18 -0700
Message-Id: <20221019171218.1337614-1-harshit.m.mogalapalli@oracle.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_10,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=829
 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210190097
X-Proofpoint-ORIG-GUID: AKVqXiDS9XCt4XX4eCt2ClYOrHEqshge
X-Proofpoint-GUID: AKVqXiDS9XCt4XX4eCt2ClYOrHEqshge
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

Syzkaller produced the below call trace:

 BUG: KASAN: null-ptr-deref in io_msg_ring+0x3cb/0x9f0
 Write of size 8 at addr 0000000000000070 by task repro/16399

 CPU: 0 PID: 16399 Comm: repro Not tainted 6.1.0-rc1 #28
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7
 Call Trace:
  <TASK>
  dump_stack_lvl+0xcd/0x134
  ? io_msg_ring+0x3cb/0x9f0
  kasan_report+0xbc/0xf0
  ? io_msg_ring+0x3cb/0x9f0
  kasan_check_range+0x140/0x190
  io_msg_ring+0x3cb/0x9f0
  ? io_msg_ring_prep+0x300/0x300
  io_issue_sqe+0x698/0xca0
  io_submit_sqes+0x92f/0x1c30
  __do_sys_io_uring_enter+0xae4/0x24b0
....
 RIP: 0033:0x7f2eaf8f8289
 RSP: 002b:00007fff40939718 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
 RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2eaf8f8289
 RDX: 0000000000000000 RSI: 0000000000006f71 RDI: 0000000000000004
 RBP: 00007fff409397a0 R08: 0000000000000000 R09: 0000000000000039
 R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004006d0
 R13: 00007fff40939880 R14: 0000000000000000 R15: 0000000000000000
  </TASK>
 Kernel panic - not syncing: panic_on_warn set ...

We don't have a NULL check on file_ptr in io_msg_send_fd() function,
so when file_ptr is NUL src_file is also NULL and get_file()
dereferences a NULL pointer and leads to above crash.

Add a NULL check to fix this issue.

Fixes: e6130eba8a84 ("io_uring: add support for passing fixed file descriptors")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
---
I am not completely sure whether to place the NULL check on file_ptr
which i did in this case as file_ptr is NULL, or the masked src_file.

Similar checks are present in other files, io_uring/filetable.c has NULL
check before masking and io_uring/cancel.c has NULL check after masking
with FFS_MASK.
---
 io_uring/msg_ring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 4a7e5d030c78..90d2fc6fd80e 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -95,6 +95,9 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 
 	msg->src_fd = array_index_nospec(msg->src_fd, ctx->nr_user_files);
 	file_ptr = io_fixed_file_slot(&ctx->file_table, msg->src_fd)->file_ptr;
+	if (!file_ptr)
+		goto out_unlock;
+
 	src_file = (struct file *) (file_ptr & FFS_MASK);
 	get_file(src_file);
 
-- 
2.37.1


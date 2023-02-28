Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA39D6A5275
	for <lists+io-uring@lfdr.de>; Tue, 28 Feb 2023 05:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjB1EzG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Feb 2023 23:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjB1EzF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Feb 2023 23:55:05 -0500
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F799EC4
        for <io-uring@vger.kernel.org>; Mon, 27 Feb 2023 20:55:03 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0Vchb1Cz_1677560099;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Vchb1Cz_1677560099)
          by smtp.aliyun-inc.com;
          Tue, 28 Feb 2023 12:55:00 +0800
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        Heming Zhao <heming.zhao@suse.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] io_uring: fix fget leak when fs don't support nowait buffered read
Date:   Tue, 28 Feb 2023 12:54:59 +0800
Message-Id: <20230228045459.13524-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Heming reported a BUG when using io_uring doing link-cp on ocfs2. [1]

Do the following steps can reproduce this BUG:
mount -t ocfs2 /dev/vdc /mnt/ocfs2
cp testfile /mnt/ocfs2/
./link-cp /mnt/ocfs2/testfile /mnt/ocfs2/testfile.1
umount /mnt/ocfs2

Then umount will fail, and it outputs:
umount: /mnt/ocfs2: target is busy.

While tracing umount, it blames mnt_get_count() not return as expected.
Do a deep investigation for fget()/fput() on related code flow, I've
finally found that fget() leaks since ocfs2 doesn't support nowait
buffered read.

io_issue_sqe
|-io_assign_file  // do fget() first
  |-io_read
  |-io_iter_do_read
    |-ocfs2_file_read_iter  // return -EOPNOTSUPP
  |-kiocb_done
    |-io_rw_done
      |-__io_complete_rw_common  // set REQ_F_REISSUE
    |-io_resubmit_prep
      |-io_req_prep_async  // override req->file, leak happens

This was introduced by commit a196c78b5443 in v5.18. Fix it by don't
re-assign req->file if it has already been assigned.

[1] https://lore.kernel.org/ocfs2-devel/ab580a75-91c8-d68a-3455-40361be1bfa8@linux.alibaba.com/T/#t

Fixes: a196c78b5443 ("io_uring: assign non-fixed early for async work")
Cc: <stable@vger.kernel.org>
Reported-by: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1df68da89f99..7ad3b8af2a4b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1777,7 +1777,7 @@ int io_req_prep_async(struct io_kiocb *req)
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 
 	/* assign early for deferred execution for non-fixed file */
-	if (def->needs_file && !(req->flags & REQ_F_FIXED_FILE))
+	if (def->needs_file && !(req->flags & REQ_F_FIXED_FILE) && !req->file)
 		req->file = io_file_get_normal(req, req->cqe.fd);
 	if (!cdef->prep_async)
 		return 0;
-- 
2.24.4


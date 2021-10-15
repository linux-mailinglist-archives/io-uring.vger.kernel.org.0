Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF91042F7BC
	for <lists+io-uring@lfdr.de>; Fri, 15 Oct 2021 18:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236932AbhJOQMT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Oct 2021 12:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241135AbhJOQMP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Oct 2021 12:12:15 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E868C061766
        for <io-uring@vger.kernel.org>; Fri, 15 Oct 2021 09:10:08 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id p21so2940708wmq.1
        for <io-uring@vger.kernel.org>; Fri, 15 Oct 2021 09:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a0t4IVlY+ryyUPc6c+jJeobcTRT/70i7E/UozvtJPGQ=;
        b=nE6OHvchJtLeS+dMkASMy6N9i8snBNhct6r9f+cIo7qDp3Dxe5vBvIFZQCkgHX4CM/
         T5TPlheVCMJgBoIUdiITN3zGZ+yqa8fy8tdtOBbAijm/wFFikh+4DRdup0OdB1e7jEDo
         4LdmigOgQrmaKvD6orRDrCtfbBYCwDj/O8stdW4QSkjTupJnTnhMGumQ8rH9NaK5IIGM
         34z/r6/wRVXf3EUhiTsoHdSLpGMvXXMHXaLI2bRqA6v86mRQL5IfbYl87TL3nGKbnVEH
         nO/Pim6xFaf7uLvJm8Ct9g06NLmNggtuax7ND/LiFRsOD6bzGKCPRrMvnN7T7QTyrI1g
         FAqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a0t4IVlY+ryyUPc6c+jJeobcTRT/70i7E/UozvtJPGQ=;
        b=FomfD9/2qRFNV5ajmk2GrMzZWUPFxgE2r9fny1Hcv+DWd/sKbXsOo3SBSiW5D0myup
         mXgBxtJQ1FBX4E3hzCS7/y8/CBUa7LAXf4neHn4MbevHPJZUcEu7hQJTDpg4iDa38kua
         rXTTr5yrQZzuXqtLxsIZgH8bwOlOZSmOTieyiOqPAAGXU+CX0Jg3N/xqhBxd1AR0Gv5m
         7kdfnrh2MMZ/jVk2LR8hKgrQxcrs6zQO8zox4t4wudOQ4VK7RT9hJ2Jrr89Qth5qUknJ
         YXWnRBwoWE7/UUnOP6pFCybBJU8tL+6IyaMN8ewre+dXWgzXwPDc4nnqiG+yRnaKDC2z
         s03Q==
X-Gm-Message-State: AOAM530KaaVD21hlYOtSlofbTMUEVM0e1oPB/MDQ4a7SfISi4tiNwrFf
        SUtAtiScYp5KwQ9HbaXHTaJlb8O9RRg=
X-Google-Smtp-Source: ABdhPJzcM96X0/mvs0GJKsAt63OhkE3dnepcqy1y+KZ89p+n++yVnJ7NWGwNCV0u1mYtBUDYmpxHDQ==
X-Received: by 2002:a05:600c:4ece:: with SMTP id g14mr13588911wmq.95.1634314206874;
        Fri, 15 Oct 2021 09:10:06 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.218])
        by smtp.gmail.com with ESMTPSA id c15sm5282811wrs.19.2021.10.15.09.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 09:10:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 3/8] io_uring: optimise io_import_iovec fixed path
Date:   Fri, 15 Oct 2021 17:09:13 +0100
Message-Id: <3cc48dd0c4f1a37c4ce9aab5784281a2d83ad8be.1634314022.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1634314022.git.asml.silence@gmail.com>
References: <cover.1634314022.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Delay loading req->rw.{addr,len} in io_import_iovec until it's really
needed, so removing extra loads for the fixed path, which doesn't use
them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9fdbdf1cdb78..f354f4ae4f8c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3162,9 +3162,9 @@ static int __io_import_iovec(int rw, struct io_kiocb *req, struct iovec **iovec,
 			     struct io_rw_state *s, unsigned int issue_flags)
 {
 	struct iov_iter *iter = &s->iter;
-	void __user *buf = u64_to_user_ptr(req->rw.addr);
-	size_t sqe_len = req->rw.len;
 	u8 opcode = req->opcode;
+	void __user *buf;
+	size_t sqe_len;
 	ssize_t ret;
 
 	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
@@ -3173,9 +3173,12 @@ static int __io_import_iovec(int rw, struct io_kiocb *req, struct iovec **iovec,
 	}
 
 	/* buffer index only valid with fixed read/write, or buffer select  */
-	if (req->buf_index && !(req->flags & REQ_F_BUFFER_SELECT))
+	if (unlikely(req->buf_index && !(req->flags & REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
 
+	buf = u64_to_user_ptr(req->rw.addr);
+	sqe_len = req->rw.len;
+
 	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE) {
 		if (req->flags & REQ_F_BUFFER_SELECT) {
 			buf = io_rw_buffer_select(req, &sqe_len, issue_flags);
-- 
2.33.0


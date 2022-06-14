Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10E4954B6D7
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 18:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347101AbiFNQwf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 12:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349615AbiFNQwR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 12:52:17 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8061E457A9
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 09:51:57 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id h19so8844249wrc.12
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 09:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bdzE6kD1GBFl1XGKjpswHYcRidedSz5ejhHaeditgVk=;
        b=jtzm1EkDYZIU1R+0PhqXYiBpuNwYpKmeN566VoYnPk7CGxBOiDRdyLKfdzR4/gnA/f
         VBKSUYqw6B7NPnvesCG8yj2NMoRUF5NOIA0S9byxJQDfNm63pTd0/FrMpnluQPpCdySE
         LUKwUYaTv47FviqDofz8Ia1kmEGGMxgbI11k3l2wTRJY0bricmOggAyNjwf8wlGIzV0t
         RmpyVYAT1Ch4kKnzm1MIUQQA+6r0hnKMvDGi3u8PyqQsmIere7Kd8Yl+Q8q8W9eXhRuX
         zF6e0lhj2NLfuQrgED1LaUehZH4SZ/8fdUxOgYpidpCNahwgt2AVMqK/jJoByzGwxweS
         +SYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bdzE6kD1GBFl1XGKjpswHYcRidedSz5ejhHaeditgVk=;
        b=YKIlyfxg22kucEeYYisY5gOMbWvEELDpUc7POkFPwrc7gbFIvqvoNGTBswaz+aHEcX
         ZREqUhHug6OQnATkem7UK45hrzPLLF8RjSYzbjaZAq+6b924lRfiWB5HFSimqeeFfckH
         FBUULgjS//50XnNcmisGH2bnXGlufBcaSqYV1uwu7EwZ+HUtQhRSJTYaFn7AskiPXxYW
         SZPs4oADrpWTSKjdJLYAzPIT6rnD1Fu9D2NkY1u8nLX0Uwgjcy7rApZWEmHktpTHfPFQ
         IWU3tRggXxshdOgHh6tztKvo+I8izfU+RiFreEQljDDEapzquOQQrTcIGv09zsy8s2Ik
         GSqA==
X-Gm-Message-State: AJIora98EPuc7Xf3fKhiAhP6C3meQC98zunY3e1qM/wpHS51RFe/g0FG
        aSlgVNh9ahSr+Hpiwe9mb0wVPbavnJFozg==
X-Google-Smtp-Source: AGRyM1sXMVxSRs/zDzigCIDe9va6XkkMZd6qNwhHFx3HtwY4RngXQqV4Vj8tvccaqWE1oSqHQVWFuA==
X-Received: by 2002:a05:6000:2cd:b0:216:2dc5:f454 with SMTP id o13-20020a05600002cd00b002162dc5f454mr5768403wry.626.1655225515720;
        Tue, 14 Jun 2022 09:51:55 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id z16-20020adfec90000000b0020cff559b1dsm12648966wrn.47.2022.06.14.09.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 09:51:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5.19 3/3] io_uring: remove IORING_CLOSE_FD_AND_FILE_SLOT
Date:   Tue, 14 Jun 2022 17:51:18 +0100
Message-Id: <837c745019b3795941eee4fcfd7de697886d645b.1655224415.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655224415.git.asml.silence@gmail.com>
References: <cover.1655224415.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This partially reverts a7c41b4687f5902af70cd559806990930c8a307b

Even though IORING_CLOSE_FD_AND_FILE_SLOT might save cycles for some
users, but it tries to do two things at a time and it's not clear how to
handle errors and what to return in a single result field when one part
fails and another completes well. Kill it for now.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 12 +++---------
 include/uapi/linux/io_uring.h |  6 ------
 2 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1b95c6750a81..1b0b6099e717 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -576,7 +576,6 @@ struct io_close {
 	struct file			*file;
 	int				fd;
 	u32				file_slot;
-	u32				flags;
 };
 
 struct io_timeout_data {
@@ -5966,18 +5965,14 @@ static int io_statx(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	if (sqe->off || sqe->addr || sqe->len || sqe->buf_index)
+	if (sqe->off || sqe->addr || sqe->len || sqe->rw_flags || sqe->buf_index)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
 		return -EBADF;
 
 	req->close.fd = READ_ONCE(sqe->fd);
 	req->close.file_slot = READ_ONCE(sqe->file_index);
-	req->close.flags = READ_ONCE(sqe->close_flags);
-	if (req->close.flags & ~IORING_CLOSE_FD_AND_FILE_SLOT)
-		return -EINVAL;
-	if (!(req->close.flags & IORING_CLOSE_FD_AND_FILE_SLOT) &&
-	    req->close.file_slot && req->close.fd)
+	if (req->close.file_slot && req->close.fd)
 		return -EINVAL;
 
 	return 0;
@@ -5993,8 +5988,7 @@ static int io_close(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (req->close.file_slot) {
 		ret = io_close_fixed(req, issue_flags);
-		if (ret || !(req->close.flags & IORING_CLOSE_FD_AND_FILE_SLOT))
-			goto err;
+		goto err;
 	}
 
 	spin_lock(&files->file_lock);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 776e0278f9dd..53e7dae92e42 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -47,7 +47,6 @@ struct io_uring_sqe {
 		__u32		unlink_flags;
 		__u32		hardlink_flags;
 		__u32		xattr_flags;
-		__u32		close_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -259,11 +258,6 @@ enum io_uring_op {
  */
 #define IORING_ACCEPT_MULTISHOT	(1U << 0)
 
-/*
- * close flags, store in sqe->close_flags
- */
-#define IORING_CLOSE_FD_AND_FILE_SLOT	(1U << 0)
-
 /*
  * IO completion data structure (Completion Queue Entry)
  */
-- 
2.36.1


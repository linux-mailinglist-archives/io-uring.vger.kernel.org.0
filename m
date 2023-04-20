Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745FD6E9BB6
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 20:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbjDTScj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Apr 2023 14:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbjDTSc0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Apr 2023 14:32:26 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2666593
        for <io-uring@vger.kernel.org>; Thu, 20 Apr 2023 11:31:43 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id e9e14a558f8ab-32ae537c23fso433015ab.0
        for <io-uring@vger.kernel.org>; Thu, 20 Apr 2023 11:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682015502; x=1684607502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CIhm8cASOrWnJLy6xy/3Pw/k0HvrxOfMqwE58FM2FGI=;
        b=ydsKB+MIAcvo5LLfER7OSV9ZwhOlt/2oig5jUrPcDmMc3j92k82j7PT1Bxzww0a8KJ
         NFcq2Mmurx2cBqDPcjsNkIhjwA9TwqYBJ5Ns87vcqrMbCRITbhSi1ZAmqoAb9dP54lIu
         icLn+I1REhaXLiaEFUsw37o3+nZkNYo8EuWbaVlQ3ZDR61kc6ZG+SpLbCPX5Ev1WJIou
         YUrNXbl2qV+rm2i5NFHLirECdZCmcefguMIffpvqUmPKydnGzjWoSlcUt3PdJbgiFigw
         cudYV+CUn4pCH8fnCOrfv39NcuiEg8ItF2/lab5KtzekMTYszhjL0kirADfyayRGIZHi
         p+7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682015502; x=1684607502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CIhm8cASOrWnJLy6xy/3Pw/k0HvrxOfMqwE58FM2FGI=;
        b=Nw87X27MELdmAGjWfRRB0eRceUJ4CawpD7jqdO0uAXjDTj20kccrrQ2f9CjWBR1JZl
         yCEHvZZl6yyZerwaU41VOs06A90xKOdiFR1EKVeDlsOMJpr73HsU51HR8GSDU5kU6TDP
         lKxJkRLSEFcLkCZYPtRgO6QSvHpbqPU1zOXhQSVjw0KSCdr4xwzVdG3hdm8CTlfhlFmq
         Q7W5Ho1H1rR7Un8rRQUMi9kkJalvMpJmoytqrw5JwAoWpz7NvXj2SnwcQ6VLMWfKlGd9
         As85cUdNdcx6LiJ3LWcLkaKv2Rx7nG60YbzzIVXvd/Q7xZNHVCBrb6GqS4dFWhIKpPxx
         hvBg==
X-Gm-Message-State: AAQBX9dfxQqxKNs9q6YiG3wnG2a/7jGOZu/6QbBoku+m6+txdwXyfqTi
        YsTlBvQYaNyBBDdyblXiCY1r07qMgfvTqnNKloc=
X-Google-Smtp-Source: AKy350aZs0gHNFI8aJab0sv7HM0zB1sSD71zDVdLZHqdvl2svnKNp47P+w2hOgO7nvpE9w25Ag15vg==
X-Received: by 2002:a92:c56c:0:b0:32b:4518:d122 with SMTP id b12-20020a92c56c000000b0032b4518d122mr1660650ilj.3.1682015501871;
        Thu, 20 Apr 2023 11:31:41 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id dl36-20020a05663827a400b003c4e02148e5sm659132jab.53.2023.04.20.11.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 11:31:41 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: mark opcodes that always need io-wq punt
Date:   Thu, 20 Apr 2023 12:31:35 -0600
Message-Id: <20230420183135.119618-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420183135.119618-1-axboe@kernel.dk>
References: <20230420183135.119618-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add an opdef bit for them, and set it for the opcodes where we always
need io-wq punt. With that done, exclude them from the file_can_poll()
check in terms of whether or not we need to punt them if any of the
NO_OFFLOAD flags are set.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c |  2 +-
 io_uring/opdef.c    | 22 ++++++++++++++++++++--
 io_uring/opdef.h    |  2 ++
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index fee3e461e149..420cfd35ebc6 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1948,7 +1948,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 		return -EBADF;
 
 	if (issue_flags & IO_URING_F_NO_OFFLOAD &&
-	    (!req->file || !file_can_poll(req->file)))
+	    (!req->file || !file_can_poll(req->file) || def->always_iowq))
 		issue_flags &= ~IO_URING_F_NONBLOCK;
 
 	if (unlikely((req->flags & REQ_F_CREDS) && req->creds != current_cred()))
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index cca7c5b55208..686d46001622 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -82,6 +82,7 @@ const struct io_issue_def io_issue_defs[] = {
 	[IORING_OP_FSYNC] = {
 		.needs_file		= 1,
 		.audit_skip		= 1,
+		.always_iowq		= 1,
 		.prep			= io_fsync_prep,
 		.issue			= io_fsync,
 	},
@@ -125,6 +126,7 @@ const struct io_issue_def io_issue_defs[] = {
 	[IORING_OP_SYNC_FILE_RANGE] = {
 		.needs_file		= 1,
 		.audit_skip		= 1,
+		.always_iowq		= 1,
 		.prep			= io_sfr_prep,
 		.issue			= io_sync_file_range,
 	},
@@ -202,6 +204,7 @@ const struct io_issue_def io_issue_defs[] = {
 	},
 	[IORING_OP_FALLOCATE] = {
 		.needs_file		= 1,
+		.always_iowq		= 1,
 		.prep			= io_fallocate_prep,
 		.issue			= io_fallocate,
 	},
@@ -221,6 +224,7 @@ const struct io_issue_def io_issue_defs[] = {
 	},
 	[IORING_OP_STATX] = {
 		.audit_skip		= 1,
+		.always_iowq		= 1,
 		.prep			= io_statx_prep,
 		.issue			= io_statx,
 	},
@@ -253,11 +257,13 @@ const struct io_issue_def io_issue_defs[] = {
 	[IORING_OP_FADVISE] = {
 		.needs_file		= 1,
 		.audit_skip		= 1,
+		.always_iowq		= 1,
 		.prep			= io_fadvise_prep,
 		.issue			= io_fadvise,
 	},
 	[IORING_OP_MADVISE] = {
 		.audit_skip		= 1,
+		.always_iowq		= 1,
 		.prep			= io_madvise_prep,
 		.issue			= io_madvise,
 	},
@@ -308,6 +314,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.audit_skip		= 1,
+		.always_iowq		= 1,
 		.prep			= io_splice_prep,
 		.issue			= io_splice,
 	},
@@ -328,11 +335,13 @@ const struct io_issue_def io_issue_defs[] = {
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.audit_skip		= 1,
+		.always_iowq		= 1,
 		.prep			= io_tee_prep,
 		.issue			= io_tee,
 	},
 	[IORING_OP_SHUTDOWN] = {
 		.needs_file		= 1,
+		.always_iowq		= 1,
 #if defined(CONFIG_NET)
 		.prep			= io_shutdown_prep,
 		.issue			= io_shutdown,
@@ -343,22 +352,27 @@ const struct io_issue_def io_issue_defs[] = {
 	[IORING_OP_RENAMEAT] = {
 		.prep			= io_renameat_prep,
 		.issue			= io_renameat,
+		.always_iowq		= 1,
 	},
 	[IORING_OP_UNLINKAT] = {
 		.prep			= io_unlinkat_prep,
 		.issue			= io_unlinkat,
+		.always_iowq		= 1,
 	},
 	[IORING_OP_MKDIRAT] = {
 		.prep			= io_mkdirat_prep,
 		.issue			= io_mkdirat,
+		.always_iowq		= 1,
 	},
 	[IORING_OP_SYMLINKAT] = {
 		.prep			= io_symlinkat_prep,
 		.issue			= io_symlinkat,
+		.always_iowq		= 1,
 	},
 	[IORING_OP_LINKAT] = {
 		.prep			= io_linkat_prep,
 		.issue			= io_linkat,
+		.always_iowq		= 1,
 	},
 	[IORING_OP_MSG_RING] = {
 		.needs_file		= 1,
@@ -367,20 +381,24 @@ const struct io_issue_def io_issue_defs[] = {
 		.issue			= io_msg_ring,
 	},
 	[IORING_OP_FSETXATTR] = {
-		.needs_file = 1,
+		.needs_file		= 1,
+		.always_iowq		= 1,
 		.prep			= io_fsetxattr_prep,
 		.issue			= io_fsetxattr,
 	},
 	[IORING_OP_SETXATTR] = {
+		.always_iowq		= 1,
 		.prep			= io_setxattr_prep,
 		.issue			= io_setxattr,
 	},
 	[IORING_OP_FGETXATTR] = {
-		.needs_file = 1,
+		.needs_file		= 1,
+		.always_iowq		= 1,
 		.prep			= io_fgetxattr_prep,
 		.issue			= io_fgetxattr,
 	},
 	[IORING_OP_GETXATTR] = {
+		.always_iowq		= 1,
 		.prep			= io_getxattr_prep,
 		.issue			= io_getxattr,
 	},
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index c22c8696e749..657a831249ff 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -29,6 +29,8 @@ struct io_issue_def {
 	unsigned		iopoll_queue : 1;
 	/* opcode specific path will handle ->async_data allocation if needed */
 	unsigned		manual_alloc : 1;
+	/* op always needs io-wq offload */
+	unsigned		always_iowq : 1;
 
 	int (*issue)(struct io_kiocb *, unsigned int);
 	int (*prep)(struct io_kiocb *, const struct io_uring_sqe *);
-- 
2.39.2


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9A7F6E7F96
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 18:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233546AbjDSQ0E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 12:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233542AbjDSQ0C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 12:26:02 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E6430DC
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 09:26:01 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-63b78525ac5so17334b3a.0
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 09:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681921561; x=1684513561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jnh79NqHUAliOqaj/jfm7JDhwlum7MQ336y4gZPZSHY=;
        b=0yVf4y/6qSbPTM7TmQPv6K/czm+yefNdVFXHRyEGD16Qn943yzz2bz0F+4+l7QGg4w
         Pdb3Z1QxECfMSYoOsmwSn/HUJWqHbFi/2tsWLSZE7VewSzYQcbA0goqzv/unxs7VEg69
         omWI2Y82cT4iz6TFG0aEdH5x/FcfFLQZKu4hIINK6adIYo0oU7bHuU7VYmSRzjp0Q5hk
         CE+5pfdmUBxgMmxZ9F6xD/hvIAcDnePZzTJDBp2FP4W8l1bXtqxdgWvVA5sIM9TRkHFU
         M6HIj6AsKEy6hLOMOxTbPwR0YSKXUig8ATVTmQAnIiy+/5LjkaeRpsxpOrLqToox3BDg
         Tv7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681921561; x=1684513561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jnh79NqHUAliOqaj/jfm7JDhwlum7MQ336y4gZPZSHY=;
        b=QSPDxMADudlmHfiq4fkjr1fjGdEblP7PdCI4Zfg3gNZ6me5VK+pSCQUvhM0BOaj+TW
         ZyMYa9oF86+scdcGpqs/PBJofQVtQFY7mdFN93Gh42enA7JDoSrVyc11HdHxQ6zKkEsE
         3CcpnCjqRedG/jOYscY52ZFEinAfO8MFt39W7uKuDeXlvPuNgZNsXaX+cz3/soBMxbLP
         e77U44nlbDKFYkonNj362ja06oOx9i3Dg3R9ZlJ9mYdWM2pr1ZXBkp1O3dJTMs4gFVPd
         kmySUmJJ/59qmb8TkI7PZz3TUjFdkPKli01V8adKed8H0rQPk3usJzyphq8lfk5pTg/p
         qhLw==
X-Gm-Message-State: AAQBX9djJtV5aowXvgSB8esCrxTrFKN760go+euVQuRiP8RS/E3LYHe7
        qKNxVBmOsZlQC05aB8mpicvQPzfaPxIaWp4g2jE=
X-Google-Smtp-Source: AKy350YpHTjRr5gEzEmRhnUS2x9uLUSjUBRVYX1Cqzs7BHuzIQKPgLDB7G4F/31OaT4BGxcIWiM7/w==
X-Received: by 2002:a05:6a00:1c9e:b0:63d:344c:f123 with SMTP id y30-20020a056a001c9e00b0063d344cf123mr6887508pfw.1.1681921560840;
        Wed, 19 Apr 2023 09:26:00 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k19-20020aa790d3000000b0063d2cd02d69sm4531334pfk.54.2023.04.19.09.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 09:26:00 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     luhongfei@vivo.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/6] io_uring: mark opcodes that always need io-wq punt
Date:   Wed, 19 Apr 2023 10:25:52 -0600
Message-Id: <20230419162552.576489-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230419162552.576489-1-axboe@kernel.dk>
References: <20230419162552.576489-1-axboe@kernel.dk>
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
index 04770b06de16..91045270b665 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1948,7 +1948,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 		return -EBADF;
 
 	if (req->flags & REQ_F_NO_OFFLOAD &&
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


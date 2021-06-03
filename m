Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB583999B2
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 07:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhFCFUu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 01:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhFCFUt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 01:20:49 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C41C06175F;
        Wed,  2 Jun 2021 22:18:58 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id l1so7302432ejb.6;
        Wed, 02 Jun 2021 22:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WqosZyHugw2yjt+Q+BMFX3mViYVJ9n0QC9Nc//NKvHo=;
        b=Ljl8d2GCRZEYzx1kK63gw6VSQJAbx2+dkwYrLHM3Z017+aNDNDCdp2uq5DLemx2atd
         nWQ3ShTsw+Zf9vhxTD32Dkx2/95wKlhk8vTxtHsEkjQs/U4Xh47RDbHa7Usgs12XUa2/
         E6TaH2xJ4vjPGgCe31PeustIJxyCHwf7CSqZB3wJwio+HuMU3FiyBR/5j4hXQOBydLoc
         vZyqX2mbQH1Em9AqZUaVPtQn2YNjQKyDOA7+c4hhmADa/st5+5gm7JFByazhff72ch5m
         gg24pKEVbASYW2eywo4+4ZemLxIN0COZBDGhKdP7bZB41UH/T5buSD+AcqD91miCz0Gx
         utZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WqosZyHugw2yjt+Q+BMFX3mViYVJ9n0QC9Nc//NKvHo=;
        b=oLMeuAtiUP3d3Op5q05f4X8V0iC0hsZgvadnIulfBfLm/0xIHdzv87F/EX6EqYkgE0
         txcUKytyZdG5bLPJ1Z60THgbqeSLD5LJkuIUqh1i7p+h5TlBT6NZYvp8iDh7mo89G4ls
         Q1zMJF/LxkxqOoXO6SUsOK2tVa83oWGFF63Y8ixXHRzANrMh1qy9IhdgkyfCbFBFEvaY
         f4aj+vDoXMoMcYxSFRoy41qN8pWxomvxi2qNA6YpCSd6eUz3h1xaoV0DMzr1rCSLF2fe
         /7QQzeSZh2eVkrlc367QtoCRihcxlh2hrxg1OU9NS7tNbkPIPmofNFatqr2M8pkKL1du
         8NtQ==
X-Gm-Message-State: AOAM530w82hLkT0s4ejlVVP297VuZIORjOnJGHPPONnt0k+HuejhRv9q
        o8dMn83OT3v5I2DQJUQUpvlI6gpoe/AuRw==
X-Google-Smtp-Source: ABdhPJyfR2OyoKaUczcQ+iSunDexWVJ5ma5+lHK8LnR1Lo9U0MlmeZDfThHNSzahFREr2IQyOXhnqA==
X-Received: by 2002:a17:906:d150:: with SMTP id br16mr16255211ejb.190.1622697537440;
        Wed, 02 Jun 2021 22:18:57 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id f7sm963668ejz.95.2021.06.02.22.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 22:18:57 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v5 02/10] io_uring: add support for IORING_OP_MKDIRAT
Date:   Thu,  3 Jun 2021 12:18:28 +0700
Message-Id: <20210603051836.2614535-3-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603051836.2614535-1-dkadashev@gmail.com>
References: <20210603051836.2614535-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_OP_MKDIRAT behaves like mkdirat(2) and takes the same flags
and arguments.

Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/io_uring.c                 | 55 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 56 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a1ca6badff36..8ab4eb559520 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -665,6 +665,13 @@ struct io_unlink {
 	struct filename			*filename;
 };
 
+struct io_mkdir {
+	struct file			*file;
+	int				dfd;
+	umode_t				mode;
+	struct filename			*filename;
+};
+
 struct io_completion {
 	struct file			*file;
 	struct list_head		list;
@@ -809,6 +816,7 @@ struct io_kiocb {
 		struct io_shutdown	shutdown;
 		struct io_rename	rename;
 		struct io_unlink	unlink;
+		struct io_mkdir		mkdir;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -1021,6 +1029,7 @@ static const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_RENAMEAT] = {},
 	[IORING_OP_UNLINKAT] = {},
+	[IORING_OP_MKDIRAT] = {},
 };
 
 static bool io_disarm_next(struct io_kiocb *req);
@@ -3530,6 +3539,44 @@ static int io_unlinkat(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+static int io_mkdirat_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe)
+{
+	struct io_mkdir *mkd = &req->mkdir;
+	const char __user *fname;
+
+	if (unlikely(req->flags & REQ_F_FIXED_FILE))
+		return -EBADF;
+
+	mkd->dfd = READ_ONCE(sqe->fd);
+	mkd->mode = READ_ONCE(sqe->len);
+
+	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	mkd->filename = getname(fname);
+	if (IS_ERR(mkd->filename))
+		return PTR_ERR(mkd->filename);
+
+	req->flags |= REQ_F_NEED_CLEANUP;
+	return 0;
+}
+
+static int io_mkdirat(struct io_kiocb *req, int issue_flags)
+{
+	struct io_mkdir *mkd = &req->mkdir;
+	int ret;
+
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+	ret = do_mkdirat(mkd->dfd, mkd->filename, mkd->mode);
+
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_req_complete(req, ret);
+	return 0;
+}
+
 static int io_shutdown_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
 {
@@ -5936,6 +5983,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_renameat_prep(req, sqe);
 	case IORING_OP_UNLINKAT:
 		return io_unlinkat_prep(req, sqe);
+	case IORING_OP_MKDIRAT:
+		return io_mkdirat_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6077,6 +6126,9 @@ static void io_clean_op(struct io_kiocb *req)
 		case IORING_OP_UNLINKAT:
 			putname(req->unlink.filename);
 			break;
+		case IORING_OP_MKDIRAT:
+			putname(req->mkdir.filename);
+			break;
 		}
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 	}
@@ -6203,6 +6255,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_UNLINKAT:
 		ret = io_unlinkat(req, issue_flags);
 		break;
+	case IORING_OP_MKDIRAT:
+		ret = io_mkdirat(req, issue_flags);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index e1ae46683301..bf9d720d371f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -137,6 +137,7 @@ enum {
 	IORING_OP_SHUTDOWN,
 	IORING_OP_RENAMEAT,
 	IORING_OP_UNLINKAT,
+	IORING_OP_MKDIRAT,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.30.2


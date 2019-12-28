Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDE6012BEAF
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2019 20:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfL1TV2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Dec 2019 14:21:28 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44448 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbfL1TV2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Dec 2019 14:21:28 -0500
Received: by mail-pl1-f195.google.com with SMTP id az3so13051688plb.11
        for <io-uring@vger.kernel.org>; Sat, 28 Dec 2019 11:21:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V36n3S5wXw+oamd/CQBjoG72TNdBOk0fIg6oE1eh6/E=;
        b=yJRhO0bBFtCgCYdpxZpOcz9Z5maca40g+Pmp8nICjJcpgNN3GKBz7akIFIPS74oUg8
         gwQe8QVXScNgCwrhNfh3kNMzfj9u9r2z+/TunzSumqc/qM6nvtFPhrUPLKH5yZ+osWrP
         7uRKhE1OtSatr4UgSpvYYdXtKN52xFNKaN2piTnhd5G7FMv2mg8IAgchIKCLyI1B8gjB
         Zkc6BnKsqg32bfdN5an/o0LIB58tCwYOWbf8kjyW8YCif/pbfbAt3npeB2znjmxkz8nc
         JdU2f7xY9QXaeAYEZ98DC2Cruk7zzQFPvwRqiejrhGM48NavIIIx4I109bbXJTCNn/Hd
         xNrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V36n3S5wXw+oamd/CQBjoG72TNdBOk0fIg6oE1eh6/E=;
        b=Fs656tZ22cg0GMzB/PiA12Xvq1YPhUV5qRe89l+McnZ00RFNiua1FKNjLaNOB5tX+2
         mk5QtvXGQDqPftTDPYLkXallNmUBjUBAUOETdaDcmYqtWKl6gLFufszIJ4nA6kMtZk9U
         gg1j34s+apAeSUQYudHpmhklXqB6DGzvUPHmHT+zD2nGKz8O0aa4b3E2xOaDqNwmN2rX
         7xa0G7keyxo3F5GjakS+RIdseLbBOo0vKjTy7zUUaDGEXd/FPM3vpMicLUeku0hojVnN
         FGDBi/g2g2drGYKJjOYHCixB8TSOVAgnGDI7Zq5kzRZlARGhc7ljLNaVG+V4HAS00l0Q
         Hmiw==
X-Gm-Message-State: APjAAAXxMVkRy3Pe3UQXp19MzHo9LoNluXyWEzpHiSMR1jjHJ284Bd54
        G2HElLth9iegya1f2/ZyWbrvz4W/kTdGcg==
X-Google-Smtp-Source: APXvYqx2DSylW72dbe38kNCDKo6cTsWMMTgD/pNSrwsClLvp4ta8UTpA4/581w1lQ1IdGwMAfYni/Q==
X-Received: by 2002:a17:902:ba97:: with SMTP id k23mr58727873pls.343.1577560887374;
        Sat, 28 Dec 2019 11:21:27 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id z30sm47067902pfq.154.2019.12.28.11.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2019 11:21:26 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/9] io_uring: add IORING_OP_FADVISE
Date:   Sat, 28 Dec 2019 12:21:16 -0700
Message-Id: <20191228192118.4005-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191228192118.4005-1-axboe@kernel.dk>
References: <20191228192118.4005-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds support for doing fadvise through io_uring. We assume that
WILLNEED doesn't block, but that DONTNEED may block.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 61 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  2 ++
 2 files changed, 63 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b24fcb4272be..8d99b9c5a568 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -72,6 +72,7 @@
 #include <linux/highmem.h>
 #include <linux/namei.h>
 #include <linux/fsnotify.h>
+#include <linux/fadvise.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -400,6 +401,13 @@ struct io_files_update {
 	u32				offset;
 };
 
+struct io_fadvise {
+	struct file			*file;
+	u64				offset;
+	u32				len;
+	u32				advice;
+};
+
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
@@ -452,6 +460,7 @@ struct io_kiocb {
 		struct io_open		open;
 		struct io_close		close;
 		struct io_files_update	files_update;
+		struct io_fadvise	fadvise;
 	};
 
 	struct io_async_ctx		*io;
@@ -669,6 +678,10 @@ static const struct io_op_def io_op_defs[IORING_OP_LAST] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 	},
+	{
+		/* IORING_OP_FADVISE */
+		.needs_file		= 1,
+	},
 };
 
 static void io_wq_submit_work(struct io_wq_work **workptr);
@@ -2433,6 +2446,43 @@ static int io_openat(struct io_kiocb *req, struct io_kiocb **nxt,
 	return 0;
 }
 
+static int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+#if defined(CONFIG_ADVISE_SYSCALLS)
+	if (sqe->ioprio || sqe->buf_index || sqe->addr)
+		return -EINVAL;
+
+	req->fadvise.offset = READ_ONCE(sqe->off);
+	req->fadvise.len = READ_ONCE(sqe->len);
+	req->fadvise.advice = READ_ONCE(sqe->fadvise_advice);
+	return 0;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
+
+static int io_fadvise(struct io_kiocb *req, struct io_kiocb **nxt,
+		      bool force_nonblock)
+{
+#if defined(CONFIG_ADVISE_SYSCALLS)
+	struct io_fadvise *fa = &req->fadvise;
+	int ret;
+
+	/* DONTNEED may block, others _should_ not */
+	if (fa->advice == POSIX_FADV_DONTNEED && force_nonblock)
+		return -EAGAIN;
+
+	ret = vfs_fadvise(req->file, fa->offset, fa->len, fa->advice);
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_cqring_add_event(req, ret);
+	io_put_req_find_next(req, nxt);
+	return 0;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
+
 static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	unsigned lookup_flags;
@@ -3722,6 +3772,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	case IORING_OP_STATX:
 		ret = io_statx_prep(req, sqe);
 		break;
+	case IORING_OP_FADVISE:
+		ret = io_fadvise_prep(req, sqe);
+		break;
 	default:
 		printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
 				req->opcode);
@@ -3918,6 +3971,14 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		}
 		ret = io_statx(req, nxt, force_nonblock);
 		break;
+	case IORING_OP_FADVISE:
+		if (sqe) {
+			ret = io_fadvise_prep(req, sqe);
+			if (ret)
+				break;
+		}
+		ret = io_fadvise(req, nxt, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 80f892628e66..f87d8fb42916 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -36,6 +36,7 @@ struct io_uring_sqe {
 		__u32		cancel_flags;
 		__u32		open_flags;
 		__u32		statx_flags;
+		__u32		fadvise_advice;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	union {
@@ -86,6 +87,7 @@ enum {
 	IORING_OP_STATX,
 	IORING_OP_READ,
 	IORING_OP_WRITE,
+	IORING_OP_FADVISE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.24.1


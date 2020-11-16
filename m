Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE6E2B3C3D
	for <lists+io-uring@lfdr.de>; Mon, 16 Nov 2020 05:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgKPEqs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Nov 2020 23:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726431AbgKPEqs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Nov 2020 23:46:48 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0036AC0613CF;
        Sun, 15 Nov 2020 20:46:47 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id s9so18600164ljo.11;
        Sun, 15 Nov 2020 20:46:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HAgiP+hNE9bnfUbQCsMJCLQYCDs2zp5i3DlpcOV9mMs=;
        b=AmfDQRRSgWaRtL8B2fp+hO/H+/VRQOS43v76tLKc/3ZMB7+3j/MNBcoeRdGTeR3Mvn
         qnckZWoIFYfHoeFQj9aFk+C5op6LNCzgPYXpIgKu9SsTSNn2bdlLHQ9JQdOaMaP/GysL
         LihhzzorfkAcMRJidUP2DTA9FGopg/mguwyMH9LkZcMMFSrhJBVUV4H7JEqa3mHYoNBT
         2bvbUcNAG+hvjQybhWmcaOK92dlIgF/A6XfCbzf9Iuo/ba5kJzlIL7w4kCqNJ5xlhE/F
         bUG1k/ljUrHIq3p8wCclolgBNL0WSYaFEesNDgx0EexeW45IHbjvysGWKnlQ+n4BoMW3
         QN2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HAgiP+hNE9bnfUbQCsMJCLQYCDs2zp5i3DlpcOV9mMs=;
        b=IZTJTapjTFhEl9vuR3cHd866+3nzz8v38SYERSNz3TVIKC+Gud4iV2LG9uokt6mafu
         bW5s/nDPcuE6sn8DLFTEuXikULTnJP+rFryPBf1UvagEUUCaw9EvIlFqQjVGOdnPShPq
         Zj6ne5e0lzC4QB9iz+8lUe8ljQhXc0KTmmt5QQPz8nMoF8XYKoiSZRJIKZcuSZVCLWi5
         tVKKrzsJ9q25d59szptlAd4Tp6wk9rEdWmTlYKfQiwPYCExQUaJWbEfmw47T62JEVs0E
         wCy3kOY7Q5hLnDPHtGBRTg5Twoh5jbnUiyphaBSek2k6LaaztMl0ZFZL76AZYqTafv5T
         DAzA==
X-Gm-Message-State: AOAM5328DSgMUaf/mS3N/8r/DFozRJI2cDre/YwKyZ+YfIkbr+tbTs1k
        iBPyRaxYhzodP2+9i3ySr/nVImLuDxcQlA==
X-Google-Smtp-Source: ABdhPJxe0uG7neDafoOCTPoHQKI/QZKq1ybgTT3sMY5lq95XT/KxoQXQvzntwGM1ILUuGOvmE36xdg==
X-Received: by 2002:a2e:701a:: with SMTP id l26mr6589992ljc.378.1605502006254;
        Sun, 15 Nov 2020 20:46:46 -0800 (PST)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id d7sm2572781lji.114.2020.11.15.20.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 20:46:45 -0800 (PST)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH 2/2] io_uring: add support for IORING_OP_MKDIRAT
Date:   Mon, 16 Nov 2020 11:45:29 +0700
Message-Id: <20201116044529.1028783-3-dkadashev@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116044529.1028783-1-dkadashev@gmail.com>
References: <20201116044529.1028783-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_OP_MKDIRAT behaves like mkdirat(2) and takes the same flags
and arguments.

Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/io_uring.c                 | 58 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 59 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 365a583033c5..0848b6c18fa6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -565,6 +565,13 @@ struct io_unlink {
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
@@ -692,6 +699,7 @@ struct io_kiocb {
 		struct io_shutdown	shutdown;
 		struct io_rename	rename;
 		struct io_unlink	unlink;
+		struct io_mkdir		mkdir;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -979,6 +987,10 @@ static const struct io_op_def io_op_defs[] = {
 		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_FILES |
 						IO_WQ_WORK_FS | IO_WQ_WORK_BLKCG,
 	},
+	[IORING_OP_MKDIRAT] = {
+		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_FILES |
+						IO_WQ_WORK_FS | IO_WQ_WORK_BLKCG,
+	},
 };
 
 enum io_mem_account {
@@ -3745,6 +3757,44 @@ static int io_unlinkat(struct io_kiocb *req, bool force_nonblock)
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
+static int io_mkdirat(struct io_kiocb *req, bool force_nonblock)
+{
+	struct io_mkdir *mkd = &req->mkdir;
+	int ret;
+
+	if (force_nonblock)
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
@@ -5956,6 +6006,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_renameat_prep(req, sqe);
 	case IORING_OP_UNLINKAT:
 		return io_unlinkat_prep(req, sqe);
+	case IORING_OP_MKDIRAT:
+		return io_mkdirat_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6099,6 +6151,9 @@ static void __io_clean_op(struct io_kiocb *req)
 		case IORING_OP_UNLINKAT:
 			putname(req->unlink.filename);
 			break;
+		case IORING_OP_MKDIRAT:
+			putname(req->mkdir.filename);
+			break;
 		}
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 	}
@@ -6214,6 +6269,9 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
 	case IORING_OP_UNLINKAT:
 		ret = io_unlinkat(req, force_nonblock);
 		break;
+	case IORING_OP_MKDIRAT:
+		ret = io_mkdirat(req, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6bb8229de892..bc256eab7809 100644
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
2.28.0


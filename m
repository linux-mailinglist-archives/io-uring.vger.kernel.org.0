Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9D21371AF
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2020 16:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728394AbgAJPrq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jan 2020 10:47:46 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:51341 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728413AbgAJPrq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jan 2020 10:47:46 -0500
Received: by mail-pj1-f66.google.com with SMTP id j11so1132549pjs.1
        for <io-uring@vger.kernel.org>; Fri, 10 Jan 2020 07:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k3hcL14cRfWpNhjA9GrayF/a85Yp0t4ZRzKs/aJScxA=;
        b=YfbEpVdyQ8r69dkfHiyx8pNVRgJyyyxs/BW7Sne8I0MWpE+ZH/3LI+IIhNcdvTbWhx
         KSMIHgttHCz96FPsAxgL/QbOtfsREZJayQvhPkoBZlEdA+nmSTZZfSk6eiNRi6Hp/PcE
         xQwJfmkN/jjA4W7kM6glJeeYxZ+LayDE5s6w593Lmjyp05+9qLL8ezVrwQd3PWnVDL6p
         osUO2qXIT0BxoLkwIuT3EREoLh3B7wMPjelMre6AgqLWyOtgL4hp7do3WmkLW1Dlaa4T
         VozdJbVkbLFpbiQX0NNexgmYxNFNe0YsTvIK1R8ylMZC15w9UIzkBEbpfKLHgPJl0d1i
         HC2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k3hcL14cRfWpNhjA9GrayF/a85Yp0t4ZRzKs/aJScxA=;
        b=hAVS0sjN50X1zTFmIkKf3QD9g8zuYCTACC0p/V6fdOwEORfjCO+Mt/faoX/CseOSyS
         tKkVBv+07mpBgtB/FUF+FD7wgmjLumZQWw6ghE642pACdbzmwxjdQ+aOA8Aziv/uxime
         lJTeRD5hQDZgZN3yZI0XOjcr8Pj1Jx3WWW97ta341SaF6s8Muz025TcRUArgH+8CV/d5
         2Rz+hF8Vgn04400978mfELW5qlxKqJ6SBEjFyQoX2ncmKncf1MHw3wK6tV/H2m/RCHrm
         4eIb8BvKAa8r4NBfAnbrZ2apZMe0iczbuQ/3XHNJ9prL9HkdgChXSCryOIhDulDtP5DZ
         iJ3g==
X-Gm-Message-State: APjAAAVSb1e4hBRYtKZZLa8ihkK237f+nWgnJQCV9YCdsY1YcBNTycBZ
        4PM1LP8kUaqfH/i8D56KuEKaq/CDuTw=
X-Google-Smtp-Source: APXvYqwtn2rd/HxYQ0miac7cSCHXh89mwRHywjJWx66WM1fjvHF+LOmqhvfTiq9mfW5y+k3hqxqXfQ==
X-Received: by 2002:a17:902:c693:: with SMTP id r19mr5306318plx.25.1578671265337;
        Fri, 10 Jan 2020 07:47:45 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id 3sm3489520pfi.13.2020.01.10.07.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 07:47:44 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: add IORING_OP_MADVISE
Date:   Fri, 10 Jan 2020 08:47:39 -0700
Message-Id: <20200110154739.2119-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110154739.2119-1-axboe@kernel.dk>
References: <20200110154739.2119-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds support for doing madvise(2) through io_uring. We assume that
any operation can block, and hence punt everything async. This could be
improved, but hard to make bullet proof. The async punt ensures it's
safe.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 56 ++++++++++++++++++++++++++++++++++-
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0b200a7d4ae0..378f97cc2bf2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -403,7 +403,10 @@ struct io_files_update {
 
 struct io_fadvise {
 	struct file			*file;
-	u64				offset;
+	union {
+		u64			offset;
+		u64			addr;
+	};
 	u32				len;
 	u32				advice;
 };
@@ -682,6 +685,10 @@ static const struct io_op_def io_op_defs[] = {
 		/* IORING_OP_FADVISE */
 		.needs_file		= 1,
 	},
+	{
+		/* IORING_OP_MADVISE */
+		.needs_mm		= 1,
+	},
 };
 
 static void io_wq_submit_work(struct io_wq_work **workptr);
@@ -2448,6 +2455,42 @@ static int io_openat(struct io_kiocb *req, struct io_kiocb **nxt,
 	return 0;
 }
 
+static int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+#if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
+	if (sqe->ioprio || sqe->buf_index || sqe->off)
+		return -EINVAL;
+
+	req->fadvise.addr = READ_ONCE(sqe->addr);
+	req->fadvise.len = READ_ONCE(sqe->len);
+	req->fadvise.advice = READ_ONCE(sqe->fadvise_advice);
+	return 0;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
+
+static int io_madvise(struct io_kiocb *req, struct io_kiocb **nxt,
+		      bool force_nonblock)
+{
+#if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
+	struct io_fadvise *fa = &req->fadvise;
+	int ret;
+
+	if (force_nonblock)
+		return -EAGAIN;
+
+	ret = do_madvise(fa->addr, fa->len, fa->advice);
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
 static int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	if (sqe->ioprio || sqe->buf_index || sqe->addr)
@@ -3769,6 +3812,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	case IORING_OP_FADVISE:
 		ret = io_fadvise_prep(req, sqe);
 		break;
+	case IORING_OP_MADVISE:
+		ret = io_madvise_prep(req, sqe);
+		break;
 	default:
 		printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
 				req->opcode);
@@ -3973,6 +4019,14 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		}
 		ret = io_fadvise(req, nxt, force_nonblock);
 		break;
+	case IORING_OP_MADVISE:
+		if (sqe) {
+			ret = io_madvise_prep(req, sqe);
+			if (ret)
+				break;
+		}
+		ret = io_madvise(req, nxt, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index f87d8fb42916..7cb6fe0fccd7 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -88,6 +88,7 @@ enum {
 	IORING_OP_READ,
 	IORING_OP_WRITE,
 	IORING_OP_FADVISE,
+	IORING_OP_MADVISE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.24.1


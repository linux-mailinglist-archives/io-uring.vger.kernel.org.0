Return-Path: <io-uring+bounces-10462-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 78005C43319
	for <lists+io-uring@lfdr.de>; Sat, 08 Nov 2025 19:14:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 170223AF53A
	for <lists+io-uring@lfdr.de>; Sat,  8 Nov 2025 18:14:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E79C4244687;
	Sat,  8 Nov 2025 18:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="oIXl+kPh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DA5275105
	for <io-uring@vger.kernel.org>; Sat,  8 Nov 2025 18:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762625673; cv=none; b=J7RRwuZ9Jtiu3DocA1y04A1REUc2HwdsgSP2hw4ns/oE1f2pF83Ar8YWYnqyG+HMUciCjRzRZp6/QoRxYpTbbGhtBnWJmIpU16xzwjIY9jAIvvuqP8psjl4GXKHGO9dz/Tc2OWqDXj9rRP+oMx9wxPVqkL15tIS5PxV4w2B/dzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762625673; c=relaxed/simple;
	bh=NpKeeE2nQ++gHctbM7rkzILdwPrFw8BCPHn+timglZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlXNy+a+tltirz1CKbaAYFsMp76g4MSRsAi38pAry1Q9AEGWckKWU9lB7fyC59NXtJ/i/5LFOXu5Q6t1UOyI26GKPQ8dRWdpqRmSCYj9jMLIWqSX7GdrSO27xz3Q8mzPVnli0tUUpqsX9QmiRL7PVYB9OEBlIvN5nyPvEgt/vGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=oIXl+kPh; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7c6da5e3353so1346066a34.3
        for <io-uring@vger.kernel.org>; Sat, 08 Nov 2025 10:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1762625671; x=1763230471; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6OQ9odTgpnyfazzzTd3vM0/6IWjocmSLgfNhuZQ8I0c=;
        b=oIXl+kPh44gAoTp5dn7EwlqNR9t8OOu6m7XkKgYNpG0grNdsIXRQrN4nZ651WHLZmx
         BF8yVHutEsCGAHptDKr55bQ4wPTER1EbxDKhk9QyLk4QxRhriMGE/5efbADrqKH80kQb
         aU4y0ylplHfaTui5lazv4QmPHiMNfGb094TFgn+9lngSVlCzy/qVxdDRSnSvzXKNNIh6
         P7NHq4HOUU0FmoFZcS1Tyjvt5SbVVVRQ2cTDp2JdQxy5g81S+Pvw+pfGAFhTdV8HEXtF
         hqlIATq+0yMpLS/IblZhPcG7sgC1KId8XQ3iQEi1sftb3lXCptUIEFPio2FTOIfuyb3Q
         ZBsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762625671; x=1763230471;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6OQ9odTgpnyfazzzTd3vM0/6IWjocmSLgfNhuZQ8I0c=;
        b=UE3hFubzETSFEcUCNjI5Q6IuVFzZXsETJDrOc2GcDDokCqJ9+q97jZnWuG1Z4Y6FnF
         Ou4KVfvjLfzyC898kyVtCmY0xlulEftvZbV5VXCdgAsHIu1PGk3djON4eJtQ7o/1JbF6
         SuA+/RsGcN2vPDWdTXciBPgD2pOgt7+NqKBoBQq/5psiFGvVLnZVso/MZWdxMiSvdpri
         s/PCvkrC6HI1DbpeT8QpwWt1uYlt7CgHkmijy/7VponjZmVqlj8K4vx32KSJhPxpnlpv
         jHDeJhYLSySgxWNyY0eSzCvw2/6O+4d6oicWH2o6XMU8nQvuhOw/ppDsGrEjpDEfkvcZ
         V28w==
X-Gm-Message-State: AOJu0Yz4v9N/EqJVpH/2S96YtYdVNgKCbB2ZSg9dgqshc98jG4gMx0ur
	PvYL7M966JRnfr7M2PyIietaDKVNpQ8aZd4uc/+cDyStjXuCUtUbYfyAd73NRh+2y5RIOU9ufqL
	WzeS/
X-Gm-Gg: ASbGncs2QlhbMhaI5lwe5KxVkIGYoLv0YpYIycTBueTmKPRbjZ/dFq1XMSFBWJcVmVi
	9qkW5ow4rpNlKa8wtyyzlBKGzwGZdxZmTubCHwOKOEnS87Ve+fxvbTWxvmVRpcU8xOLlhdtodA2
	ALMkEm5GEK0JaegypMpt29M8d0Lg/nK89CnOsCSZvWeJKFMEcxWab/G7gHLARhuQ7JeW88Lfxrj
	L5PpDWb1wkCVxtKEuTkDkTYagHhkKAJw8bsXHk7BufOHIOd29dWNkocG8jLkAnMmXtxzMAm6P7N
	8Nuzs4rnvhYFCoqZqdSj/Un/ANTrzrzSXcXSCW1D3VBmgVjdB9z92NpvEMlZJ0jWqv5IqWZQiS4
	YXtGPzZnLZZj7+s9e/GPlRsYrMCBOHHob+47fWAqPpmf1kqhk3AYy3g133dtF2c34GKFkpCgwX3
	fuhXZVnkCKxPEoYL3lB89QA93Zb8gv
X-Google-Smtp-Source: AGHT+IFsh+Qg5E6P1X8JZ5tyAVM0HasUTGorphxM4FbP57ILlcbAOvMNqB3F6O/O+ajHfLiPKvUtvg==
X-Received: by 2002:a05:6830:438d:b0:7c6:e92f:41df with SMTP id 46e09a7af769-7c6fd734015mr2290603a34.12.1762625671428;
        Sat, 08 Nov 2025 10:14:31 -0800 (PST)
Received: from localhost ([2a03:2880:12ff:7::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c6f1132123sm3281379a34.29.2025.11.08.10.14.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Nov 2025 10:14:31 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v6 3/5] io_uring/zcrx: export zcrx via a file
Date: Sat,  8 Nov 2025 10:14:21 -0800
Message-ID: <20251108181423.3518005-4-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251108181423.3518005-1-dw@davidwei.uk>
References: <20251108181423.3518005-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

Add an option to wrap a zcrx instance into a file and expose it to the
user space. Currently, users can't do anything meaningful with the file,
but it'll be used in a next patch to import it into another io_uring
instance. It's implemented as a new op called ZCRX_CTRL_EXPORT for the
IORING_REGISTER_ZCRX_CTRL registration opcode.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/zcrx.c               | 59 +++++++++++++++++++++++++++++++----
 2 files changed, 54 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 190657d8307d..f5dae95bc0a8 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -1087,6 +1087,7 @@ struct io_uring_zcrx_ifq_reg {
 
 enum zcrx_ctrl_op {
 	ZCRX_CTRL_FLUSH_RQ,
+	ZCRX_CTRL_EXPORT,
 
 	__ZCRX_CTRL_LAST,
 };
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 48eabcc05873..3fba3bbff570 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -8,6 +8,7 @@
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/skbuff_ref.h>
+#include <linux/anon_inodes.h>
 
 #include <net/page_pool/helpers.h>
 #include <net/page_pool/memory_provider.h>
@@ -586,6 +587,15 @@ static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
 	}
 }
 
+static void zcrx_unregister(struct io_zcrx_ifq *ifq)
+{
+	if (refcount_dec_and_test(&ifq->user_refs)) {
+		io_close_queue(ifq);
+		io_zcrx_scrub(ifq);
+	}
+	io_put_zcrx_ifq(ifq);
+}
+
 struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ctx,
 					    unsigned int id)
 {
@@ -596,6 +606,46 @@ struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ctx,
 	return ifq ? &ifq->region : NULL;
 }
 
+static int zcrx_box_release(struct inode *inode, struct file *file)
+{
+	struct io_zcrx_ifq *ifq = file->private_data;
+
+	zcrx_unregister(ifq);
+	return 0;
+}
+
+static const struct file_operations zcrx_box_fops = {
+	.owner		= THIS_MODULE,
+	.release	= zcrx_box_release,
+};
+
+static int export_zcrx(struct io_ring_ctx *ctx, struct io_zcrx_ifq *ifq,
+		       struct zcrx_ctrl *ctrl)
+{
+	struct file *file;
+	int fd = -1;
+
+	if (!mem_is_zero(&ctrl->resv, sizeof(ctrl->resv)))
+		return -EINVAL;
+	fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0)
+		return fd;
+
+	refcount_inc(&ifq->refs);
+	refcount_inc(&ifq->user_refs);
+
+	file = anon_inode_create_getfile("[zcrx]", &zcrx_box_fops,
+					 ifq, O_CLOEXEC, NULL);
+	if (IS_ERR(file)) {
+		put_unused_fd(fd);
+		zcrx_unregister(ifq);
+		return PTR_ERR(file);
+	}
+
+	fd_install(fd, file);
+	return fd;
+}
+
 int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			  struct io_uring_zcrx_ifq_reg __user *arg)
 {
@@ -742,12 +792,7 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 		}
 		if (!ifq)
 			break;
-
-		if (refcount_dec_and_test(&ifq->user_refs)) {
-			io_close_queue(ifq);
-			io_zcrx_scrub(ifq);
-		}
-		io_put_zcrx_ifq(ifq);
+		zcrx_unregister(ifq);
 	}
 
 	xa_destroy(&ctx->zcrx_ctxs);
@@ -1025,6 +1070,8 @@ int io_zcrx_ctrl(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 	switch (ctrl.op) {
 	case ZCRX_CTRL_FLUSH_RQ:
 		return zcrx_flush_rq(ctx, zcrx, &ctrl);
+	case ZCRX_CTRL_EXPORT:
+		return export_zcrx(ctx, zcrx, &ctrl);
 	}
 
 	return -EOPNOTSUPP;
-- 
2.47.3



Return-Path: <io-uring+bounces-10354-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id CA967C2E71F
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 00:42:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C4C15344CA0
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 23:42:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00BFD30103C;
	Mon,  3 Nov 2025 23:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="ZZQE/iMJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5547231AF1F
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 23:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762213296; cv=none; b=V78EhEd+1GfyOKTb2h1kn8M02WtydYju3wXtbkw2vG8LvN1F6giqjNmAffTq66bpa4lldoULAGFWp9QX6vIwIIuPCs4SnIS0S8JkfV5lO/fS/8d1sqEt4VWw0Gi4izdafVFiPQLm7JSaZ8ZwqZyvRwmR6GTZ+YjaXSP8xuuhrjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762213296; c=relaxed/simple;
	bh=KStsLfzpB8gMgQ7SDD7DJDihOdk/xU23RPP82OSDjRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXdU7HvlQGOyhkUbDAq+uyGxvopxtlaWL61uEmSQ96YTi141YhodGUsFw7ez+zheCT8VGy/dq1M/HaSvqjeBsIv8NFWo5XplQv1KA54LO55Cc/5bJ6fKySJvyIGWr8nPKFZB0QjfxMGW8Jsl+lDhWI0N4OW2qt62WPhQpiX9C3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=ZZQE/iMJ; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-44f9815f385so705227b6e.3
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 15:41:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1762213293; x=1762818093; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+XslsaIYawI/PpUa6cz14h8QIH/+9A+1TecY91qw6vk=;
        b=ZZQE/iMJue8ofGE0Deq8y7qBkBw1+UCt+TJYdYKknyFn3MggjVkb4yXDlAq/Idh285
         /aQxB7Xf1MMJJTPaSnERTdv4FCEueWpBF9Hr0c81LI1GcRj4q9jEJCChL14rnJxNjkq2
         P0NKFU1+JIM3IEbd+B2Ae/8PUclZqw3bNnHCvcPebv13wPgH2WtHGSMTR6SMG+yeMdpR
         42S3uSjaODjPSCWCJaBP0L08BcaTeXj16dPGDGbz1Mw0GWCv+2kqBveX12iP9UeH4jAn
         wFlL5EPYZXyLA7UBaGGWYVEATinZ/VBGY7qtWp2WkDFAMApIOCbceoLygU3aLiyFFGKG
         PmYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762213293; x=1762818093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+XslsaIYawI/PpUa6cz14h8QIH/+9A+1TecY91qw6vk=;
        b=nkHruhkivyb77VKw3hxsToNgvXdPShGo1a60PUYs3Jb29+xx0fjbx2LnYU7+gB4Hjq
         ADmvGYJjyoxOu+44C2qgk8VgZg8gIdGZoSzLil2Vybg45XcFaWZCwV3/D+TBg/dB1603
         usTh9NbY4n8L9jYbaSbRIvKmQPWnTBa1OJBI3MnLT20qDiisFfa+1iDAUuZpKrvbIy//
         1OtsTrj695runZ18ybATB+x05J7xEnUVKY6vQ6V9EsblzhyD44hAAaBtUdBstkGV4qeI
         i4t7ZBR/Nze8mX12RejOk38wceHMXgs6tObi28oDtNv13H7aQrVjFIKCN5d6bXfPHcJN
         7lqA==
X-Gm-Message-State: AOJu0YzEhDoLR/IHFb3A64jVM8wTj3VKWrOYGHa6zUXcu2TQgSEGLYsm
	yesHdRbQGjtFJJVgASKfZNZJmZM2hN6umSJKncvtkt+2iiT0M4fQRH1FNJ/ZIbY3PvhUbWGU93G
	94lWu
X-Gm-Gg: ASbGncvlI0IxPeafa+izuSs5qqJG7deXMbCacfiDjAHUsHSUi8Zwq4bUWLOh+nVo78i
	3P+zMwQ5ONMAKAJ9mnPP9GwZLLXMhODHkFKzqYnpzImb1Uw4Lw55CiEqYWQAwW2xeEVWO6iXvWg
	rmjFIXt2S/CbPJ/M/wT7NnORdGN3Ez9CwYAljoVUvnqvaGQSr9J5owC7D9UeyL6tl5KS0sePBfI
	DsLoEne2EimSk6Lry3TCQW9NFlWx7DNg9APQzgP9FR8gxyReU0un7wac00NIBmPg58nKkxgUtfC
	qXjAoS8G4RtywKuQRvWt5cMNTMCIF9yIJnF+4snjIW229HnGwHXVsvoCfheHIz/EcufI+wbllKr
	TD187CqsYNi0H8tgKIBu18DikEditlOrEoFdVJHrXejLGSTTfvKi4qWyMLVbM+05Dmu8fPOR7Iu
	3ltkYZXPpvOQH5Zm8CEbctqO/52nyhKQ==
X-Google-Smtp-Source: AGHT+IEGB6H0E4w914Q3fkIgrP4gvIiaB/kQK+IOH/g2k1XjGGMsfwlH/Gu+ctt0eQxDZ+9C1xbL3A==
X-Received: by 2002:a05:6808:178c:b0:43b:977d:cc91 with SMTP id 5614622812f47-44f95df8ea1mr5719262b6e.3.1762213293426;
        Mon, 03 Nov 2025 15:41:33 -0800 (PST)
Received: from localhost ([2a03:2880:12ff:71::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-44fde2810dcsm121156b6e.4.2025.11.03.15.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 15:41:32 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v4 11/12] io_uring/zcrx: export zcrx via a file
Date: Mon,  3 Nov 2025 15:41:09 -0800
Message-ID: <20251103234110.127790-12-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251103234110.127790-1-dw@davidwei.uk>
References: <20251103234110.127790-1-dw@davidwei.uk>
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
 include/uapi/linux/io_uring.h |  2 ++
 io_uring/zcrx.c               | 62 +++++++++++++++++++++++++++++++----
 2 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 8b4935b983e7..34bd32402902 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -1082,6 +1082,8 @@ struct io_uring_zcrx_ifq_reg {
 };
 
 enum zcrx_ctrl_op {
+	ZCRX_CTRL_EXPORT,
+
 	__ZCRX_CTRL_LAST,
 };
 
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index e9981478bcf6..17ce49536f41 100644
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
 int io_zcrx_ctrl(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 {
 	struct zcrx_ctrl ctrl;
@@ -612,6 +662,11 @@ int io_zcrx_ctrl(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 	if (!ifq)
 		return -ENXIO;
 
+	switch (ctrl.op) {
+	case ZCRX_CTRL_EXPORT:
+		return export_zcrx(ctx, ifq, &ctrl);
+	}
+
 	return -EINVAL;
 }
 
@@ -757,12 +812,7 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
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
-- 
2.47.3



Return-Path: <io-uring+bounces-1960-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 027998CEC93
	for <lists+io-uring@lfdr.de>; Sat, 25 May 2024 01:05:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 931EF1F22627
	for <lists+io-uring@lfdr.de>; Fri, 24 May 2024 23:05:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C61922CA5;
	Fri, 24 May 2024 23:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ShBbjrC0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F4E84FB3
	for <io-uring@vger.kernel.org>; Fri, 24 May 2024 23:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716591913; cv=none; b=pjbMMJT3Bv+YRl+GFgMYGnnSW3KBuQlAegf2M0oMcgwXEHEkBftwMc2xeD84Kv/xLuPf1WGoPCP2rJxB7q+kzCt2vbQVdID9MgiolpVVRkqk4NyONvO6+329Mbjb+MqbUPFZER2HK8FWaY1fw93so1khcG03Zdhsy1cAoN0Wc9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716591913; c=relaxed/simple;
	bh=5h1TIwk485xzuo65BPvZ2GQeWf4HXjNF6I31wjce8EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSwzegMQYdGcQBum48EUPfJPpHd0ZnluyUil4TNaapjHVfDKcmas3OHHpuFuoeCT7WQN7uM9URb9jdV9Owq8sXksi4UdosmQS6ejnPcuz7vauZw+KtegYiAXP6+O4n/SJAYeHyOvfhd3VRrW70e4cDQcEdhkagOJtTRBzzG4n8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ShBbjrC0; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2bf8a874296so8260a91.2
        for <io-uring@vger.kernel.org>; Fri, 24 May 2024 16:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716591909; x=1717196709; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iYXbRi7M2c1HqxvzjiKFqL80MUJ6pePfMWM0r/nvfyU=;
        b=ShBbjrC0F6omhbjsEuFZ1000RlDejtYdkJIMa9dkDl4Kd+R6IGx3fT5m353t7waXMj
         yaeWqeDu9bRRdmlsw0WhfbjMWxJVGEyJP2qZzcveYVEpaAUp+GaHijSp0OEekEFPreYf
         g9eGMjpUFNBK3H5xOdbeifu+zSgF68k3vK+avxuTdQN4xT+pYF2GJmVOqVQHxVox0XDp
         RuXgq26jQ67MlhJakG54jW5vw9+EMtX//YgTZ5tNl5/CmkCZ/Vm52SRhZhVxirWO7Lgk
         H9D/a2DCRBDkWoNNp31inJJ0INu8yVnHV+a8Jz2MTT9V/Rx90H22SWw//VG8kOU+jdxJ
         fpKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716591909; x=1717196709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iYXbRi7M2c1HqxvzjiKFqL80MUJ6pePfMWM0r/nvfyU=;
        b=gPnteg/Uqqm/zq8mw+XFe330BE/fvKqSdFQoKVNkcJ9N5r4GXezUICP25z5r30hfcr
         Z3Usju+iOnHyXJ3nXwvusdNTlbFk2xErqdub6aL/SAdrNwsU5pXfiRFgOTwgJ71dV6ke
         0Fv/Ans+uF6G/JtARbmZDlTyAqfeFsGtrDcL19SKojAksG2rXFQLhOIa1XpQRw679YhR
         c8YE/JmZ3vlnBo6zoQKQ52ZY+mv05gWQAZisW8zIaYHbG6AABLjoCDDCZVDMXusWlhRu
         QmcEFG4foQGr9nv7DtV+tGszwm1nNeK04AGZx5JvH6njzEqLQOzIabM7IFmYSVGjj1hc
         CxKw==
X-Gm-Message-State: AOJu0YyCTE4FZKtb5oDuafEoeoQIJ376NMM5Ow0j2ZtuvwOtECfw3Fwc
	+oXSRegu318vaqPf/1o6Zma/Hhfj8yKzqlv1BIVJf2wwA4MBCS5fxT42oEHGAr5XA8e7GL8T3pL
	M
X-Google-Smtp-Source: AGHT+IHD0vyii1QhUAlW8nJGnfNGqF63b9R1oYz8Q/Q2N1zLqKGbf5F2a4HkoD5D7KvT12+e1Zitvg==
X-Received: by 2002:a17:902:f688:b0:1f3:358:cc30 with SMTP id d9443c01a7336-1f4486d1fbamr40538705ad.2.1716591909372;
        Fri, 24 May 2024 16:05:09 -0700 (PDT)
Received: from localhost.localdomain ([2620:10d:c090:400::5:7713])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f44c7c59besm19147625ad.106.2024.05.24.16.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 16:05:08 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring/msg_ring: split fd installing into a helper
Date: Fri, 24 May 2024 16:58:46 -0600
Message-ID: <20240524230501.20178-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240524230501.20178-1-axboe@kernel.dk>
References: <20240524230501.20178-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No functional changes in this patch, just in preparation for needing to
complete the fd install with the ctx lock already held.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/msg_ring.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 81c4a9d43729..feff2b0822cf 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -173,25 +173,23 @@ static struct file *io_msg_grab_file(struct io_kiocb *req, unsigned int issue_fl
 	return file;
 }
 
-static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flags)
+static int __io_msg_install_complete(struct io_kiocb *req)
 {
 	struct io_ring_ctx *target_ctx = req->file->private_data;
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
 	struct file *src_file = msg->src_file;
 	int ret;
 
-	if (unlikely(io_double_lock_ctx(target_ctx, issue_flags)))
-		return -EAGAIN;
-
 	ret = __io_fixed_fd_install(target_ctx, src_file, msg->dst_fd);
 	if (ret < 0)
-		goto out_unlock;
+		return ret;
 
 	msg->src_file = NULL;
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 
 	if (msg->flags & IORING_MSG_RING_CQE_SKIP)
-		goto out_unlock;
+		return ret;
+
 	/*
 	 * If this fails, the target still received the file descriptor but
 	 * wasn't notified of the fact. This means that if this request
@@ -199,8 +197,20 @@ static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flag
 	 * later IORING_OP_MSG_RING delivers the message.
 	 */
 	if (!io_post_aux_cqe(target_ctx, msg->user_data, ret, 0))
-		ret = -EOVERFLOW;
-out_unlock:
+		return -EOVERFLOW;
+
+	return ret;
+}
+
+static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_ring_ctx *target_ctx = req->file->private_data;
+	int ret;
+
+	if (unlikely(io_double_lock_ctx(target_ctx, issue_flags)))
+		return -EAGAIN;
+
+	ret = __io_msg_install_complete(req);
 	io_double_unlock_ctx(target_ctx);
 	return ret;
 }
-- 
2.43.0



Return-Path: <io-uring+bounces-3879-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 66FFC9A95F0
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 04:04:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC4881F23C4B
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 02:04:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBF6112C81F;
	Tue, 22 Oct 2024 02:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QCyjyLSo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EB8126C14
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 02:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729562677; cv=none; b=unR9P2sLfDRuanXHcO7YeVmJLmVs0nWqkqJKp5Drt+aytvC/XoAr+5abG27qUl8XgwkA8lDZn2wAfmkzODYOQMtP6tGuFlKLh3sNj+3F9EbP2f3/AxMpZzISQPjAIZocpbXy/TMoeoZPF0/jCbfmkzb8e8Cnjg1dWRaG+NDxoPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729562677; c=relaxed/simple;
	bh=oDiF+iJtDAqOQFD3zFbOwHq1eNByLNSUH9pNke+Mbqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOpzIPsFMT4fspFiO01VO7+9OFSov5izTQju8RSXZ/MwTTu+FwlUapBMkvSRSpsox8eW1wkh/U3hLEikF6t7G/VxeW+zbo7lRqrn6g6sMXQtWEPsg7f8E4c4iZeDNu9PFtZq8AnnDZlL5Hz5l5E67a0M9TrvS91G9Pup5NkabMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QCyjyLSo; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-71e5a62031aso3534463b3a.1
        for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 19:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729562674; x=1730167474; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q7q/V2BhkWsb+BFpGXBB0cov0CmL9fUYlsdRBSuHeDA=;
        b=QCyjyLSo9SuXwmCfO6zDJVTOsWG1X2UeREkGRjYkvBggBImEQbQPSu6iipv5x6KGB2
         sjGpY9lkivLwJj45TD+abW5Pj0+fryYPin34gkJxKAYdKIbNlHDChYuXV/jbhtfXiwEs
         vg3gEjRL1G5hVhHqo5UrHbu54jbT/Lhd6U91ES57FUiKCj2xHAcjjtHk6/U/dUjMJYcz
         uqhfp4zeHkAxc+Ondfpxg3YuNAx1UTL3W6Vpo8b7xN+AePBlpbDiH5Co4axBXNBrXu6d
         xeH2JstAvqds1kWHMYG7BheZQA7z0JUlYIFB19va99LnuToNuSY5Pf2t957mRDsvOcC8
         zYDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729562674; x=1730167474;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q7q/V2BhkWsb+BFpGXBB0cov0CmL9fUYlsdRBSuHeDA=;
        b=YImVTby9iSY2yPb1q1vvLmHUH9WguCw/LbXlmpw+7211TAXv9igBuvGPly/oXt1ps4
         UKctp09aMyaFSb6KcucGLG5yf4AgkdOidODyyNYIN+Na1W+G85moEDkoKlUlk9E9D/lA
         VUW4khqBB+rbPo2jTwUHJZOAWKma8FWbS3G3oTIdSzNuSuUDA562I+BFYHu7O/6s8XAh
         PQ9gf5iEN7sX4OEKDg9cjAb3wGKqwPyACGNCdfl29964NxZfs9wHzGCu60DUDvoMSXZu
         L9BHXBIAMOGWsjGAOErOU9hVxg2ezVKqmpbOzKr/GQGyDYfSwIwNeB68HsQkHuS/j1Yb
         xUzg==
X-Gm-Message-State: AOJu0YwHSBg+pp6ETOg4XLeDEMjsVz80A1E6RsHP0Symmr/85MmiP8O2
	8jIS+iKdizDLmzziFZG13h9r5cRGuUWAXw/i438c2wYhLTBFDJ17F3ux+/DRjgyG8igsURraoAj
	6
X-Google-Smtp-Source: AGHT+IHH5WeaeaMGkW+lNW+ChYdE0rSmNCMtMorsY0gVu3JofWHzKzMBmjdykQSgXTltGJ3ZUDc3Hg==
X-Received: by 2002:a05:6a20:bb28:b0:1d9:3456:b71e with SMTP id adf61e73a8af0-1d93456ba08mr12754907637.12.1729562673746;
        Mon, 21 Oct 2024 19:04:33 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7eaeab58820sm3845534a12.52.2024.10.21.19.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 19:04:32 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring/rw: get rid of using req->imu
Date: Mon, 21 Oct 2024 20:03:21 -0600
Message-ID: <20241022020426.819298-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241022020426.819298-1-axboe@kernel.dk>
References: <20241022020426.819298-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's assigned in the same function that it's being used, get rid of
it. A local variable will do just fine.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rw.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 80ae3c2ebb70..c633365aa37d 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -330,6 +330,7 @@ static int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_mapped_ubuf *imu;
 	struct io_async_rw *io;
 	u16 index;
 	int ret;
@@ -341,11 +342,11 @@ static int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	if (unlikely(req->buf_index >= ctx->nr_user_bufs))
 		return -EFAULT;
 	index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
-	req->imu = ctx->user_bufs[index];
+	imu = ctx->user_bufs[index];
 	io_req_set_rsrc_node(req, ctx, 0);
 
 	io = req->async_data;
-	ret = io_import_fixed(ddir, &io->iter, req->imu, rw->addr, rw->len);
+	ret = io_import_fixed(ddir, &io->iter, imu, rw->addr, rw->len);
 	iov_iter_save_state(&io->iter, &io->iter_state);
 	return ret;
 }
-- 
2.45.2



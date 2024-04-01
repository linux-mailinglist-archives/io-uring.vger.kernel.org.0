Return-Path: <io-uring+bounces-1354-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B2012894494
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 19:58:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27CE01F2260D
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 17:58:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFC5D3FE55;
	Mon,  1 Apr 2024 17:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CLR7+q86"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DD91DFF4
	for <io-uring@vger.kernel.org>; Mon,  1 Apr 2024 17:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711994287; cv=none; b=b/b+YDwXdusl3E+z5942Uy1CaHjeOszN00IBC8lGRLOY2u+yzh2f034mLkIBkdz/in8/SOU2VrgBWyFy/q3ef2jhiCYxxHBK8W9rKcHglzqRivZtadMDiBPeLuCKPHHQytCSqId2n3HAbHTsJLHtmkkHjlBfnGdisG1uaieN+BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711994287; c=relaxed/simple;
	bh=p+by8qnt3vRwSfJkn/Rx2UAomMYo5ZJkoY72IusQtuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hb90qq8W/pLGdM1JD6E9EaPntk5HmR6MWJt7VLtGTMTaFskIp/SateVFlPjeQIE5yGkcNxG4HZH1UX6IIyG2V45Fe7Jx8kNWKjc3PU7XR4z3fbqsyQXaalEiUn2fGe8VTMtdm2jRfQrbiyffUbINjECP+zI9+VaTPreOc5rXO88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CLR7+q86; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3688f1b7848so2659585ab.0
        for <io-uring@vger.kernel.org>; Mon, 01 Apr 2024 10:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711994285; x=1712599085; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pxrSNfhsIJIJZKE+A4tpFbWe3kLSB5byX5X0AqK8SPI=;
        b=CLR7+q86o9SMrZw4QZFgo6Gc2Hh2kX0PHsgjDE3psnS7Ny3OvEmCQbzC4e0hlkXPQU
         OaFzeYYbTWb/YGil02OqztnjrtFo78jD6ol4Q70WGOx4mUeTi/idlxqfQvSc9wBKIIPB
         EptaNgn7sh58xA8WY2gAkSRo4hbmZYkJA+HRPwKKtdZC+oiv+HVBbYneF+q4BbWgg1Eg
         phca1HMv9yXjUiOIt6Co35ukk5aw/yDozlP0jtC7M7Qsk9aDk1fXbuMFaaZ7vN3VptcO
         Jhd+cz0hweqOb+QHxhOP/Req/juj+SOnKpH74wtvHRJwyB15qo3C+hAfgyZjfvdLk+Jt
         undg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711994285; x=1712599085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pxrSNfhsIJIJZKE+A4tpFbWe3kLSB5byX5X0AqK8SPI=;
        b=A09AbUjcTLr3AJyVQETbPaq/VtKoExYJZGmepzddrpZ+OZC1lsZatYUXIzP94zhunB
         vSNsAJUTWxUpo/TAgNFMVAE/sk3WC9v3udvu3bFtqxggPabmmkq2tUDebO3WvFTD0fc5
         Z0+VlCStk6eUPcRKM91aPR9MEhDRDPKcSrVdiVWAXAgVWSI7RxKPAXxDnx7chSRIUX8V
         WocXuRHRa59byKmtvafbEx0JdErBZgZFKqJSKwFwr8H6YoiQsqsmhpusUyc9kYtJ71da
         CaTer2xU6S2rlQA2RqKJHhAEq2/7WT/6z9LocqIC8/znHwhWptcGILBlR698GEAcvwgf
         R8Iw==
X-Gm-Message-State: AOJu0YxZuF6hOjRhjDW0yJK7QUL8uLF1kpeNYHd+IA81KqWCuqXvxUlm
	jdf/m5ZwOlU7aCS+iru9GonclztSWSevFtuzu18bG9bsEvHtC4OaG9P1IhgBbs38mtvH+i+ZYOd
	8
X-Google-Smtp-Source: AGHT+IFk7h5riHCabBxlvon1g3aJvyLDA3V4/A6avvM1sCi3tD9rn2Vzn2WYBUD/8CaBvHiTt7zkVw==
X-Received: by 2002:a6b:7d0c:0:b0:7d0:3f6b:6af9 with SMTP id c12-20020a6b7d0c000000b007d03f6b6af9mr9639907ioq.0.1711994284850;
        Mon, 01 Apr 2024 10:58:04 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ge9-20020a056638680900b0047730da740dsm2685669jab.49.2024.04.01.10.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Apr 2024 10:58:03 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring/msg_ring: split fd installing into a helper
Date: Mon,  1 Apr 2024 11:56:28 -0600
Message-ID: <20240401175757.1054072-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240401175757.1054072-1-axboe@kernel.dk>
References: <20240401175757.1054072-1-axboe@kernel.dk>
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
index d1f66a40b4b4..9023b39fecef 100644
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



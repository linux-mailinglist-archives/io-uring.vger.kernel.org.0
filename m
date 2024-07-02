Return-Path: <io-uring+bounces-2409-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AFA9923F25
	for <lists+io-uring@lfdr.de>; Tue,  2 Jul 2024 15:39:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6878285D6D
	for <lists+io-uring@lfdr.de>; Tue,  2 Jul 2024 13:39:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 397071B4C56;
	Tue,  2 Jul 2024 13:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NBxjrV4y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3361B4C4C
	for <io-uring@vger.kernel.org>; Tue,  2 Jul 2024 13:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719927491; cv=none; b=DKIBYSIzgGDBD7LD8uf7DKOLODMLVj/Yg//rg+iukJ3DHIet799PJiWQ1yo+vIrEkEGZuGaItbrHxr49LSEvLCFu78XjOcYTuH+fN5UKTmcnlBnUPU1AVv1PBfpa6KBof409cwfQq6kIdhSDkMHph24PU/yfGFJPuxaFeIRNcKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719927491; c=relaxed/simple;
	bh=sAhJhMlP8IAhZu4EufPAZXQa8xfb20SUAL7UH/pqkp0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N+MwoZBVx1FuxiyuIYc4DK5uCRmjdzEeNfUpOhj5SfecFsxBHM3hSYudBtBPFjFXGtxU2KETex+cyZaGlxYTMDjIzq3Ne4OH6PGYZNFSrDQ2ibEp+oF218RXLrXRRclk9IGn92IuF3Qcu4K96pvBf09UNXvkozBonUEo/0QSguA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NBxjrV4y; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2eabd22d3f4so41847901fa.1
        for <io-uring@vger.kernel.org>; Tue, 02 Jul 2024 06:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719927487; x=1720532287; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Qhl4rL5HuQgmVeRN44FZcY9g54BbTwHhrCY3xCEItHw=;
        b=NBxjrV4yeVKNgWbUQ8fMrfGaRrsvIO8P8ADnTtRZz7i0MiSPI0JYBJQFhH0uvco14u
         UZy7qvuR1Vv8gGZNiLheb/uGV3Dxti5WCq3ZJY9+DE1yCezlpwj7jCQFzTYvywhROAmw
         9pj5PJJls0gmFjVr8Ki1ZPgDJtDlC9hT5k0ZbnRyY4NwdIWQUYepnICR7TsfvyUFwb+s
         zhn6suTJNuj+xO9e6hrS+wBshruj4UyCnNF0/36k6puRrlIMOsSmPBUlc/7giLgjW5jF
         8vKkTCPsUjwNZvcmsR3Y17HEebJKYKSiJMvDrVo7FXZjt8/AInA9PsBgKL+JZeE3aYJS
         1PHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719927487; x=1720532287;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qhl4rL5HuQgmVeRN44FZcY9g54BbTwHhrCY3xCEItHw=;
        b=OGzf5XigxQ3y9LIgnVLzXezFLRaS3/c9q6Yc5NIQUgH4bAzv59j/4+Htnv+8tvPjAA
         yEVdsTQGqt1rYV0fkPnejJq6FEDzMaPRkp4K6oww7OI0ewB97LYQLeC4x04sX1cgKDV0
         +IhTlvmd8MFq/Ntev10+zt7MGx/T+lXYFSBRqiis8W1GkLKYU4eevDtMGtvy4yReRn2Z
         XXRIa05CgXRK29Bpr2fEKy5V4whiJISBsgJ+zcDnWyj4OluxnoIrCpspKDPxCGSi9mz9
         bQYtidRBVDBJS+tEEd4hEs+hJRccQXi49hOvyxbm3zmY86p30Ndf85h2by0TDwdeOSKe
         R4zQ==
X-Gm-Message-State: AOJu0YwGevgmr2i1XSoZu+5ElSdXXJPn5YJ07wzIaUbKpEyslNdFHyPe
	ca0QjSBDqtIAJps/3HXkhKk3+4L/91NgEKvUhdBrnAfe+a127xn+RlSuaA==
X-Google-Smtp-Source: AGHT+IEvy/LwKEVJlrB5ZSa+bnIUXe8Xz8dkRIOsJyEU/esijLuLdjK7s50MJro6hdBBPdX1TYLA7Q==
X-Received: by 2002:a2e:bc84:0:b0:2ee:699b:463 with SMTP id 38308e7fff4ca-2ee699b057fmr43677041fa.46.1719927487127;
        Tue, 02 Jul 2024 06:38:07 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.146.204])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4256af37828sm204833335e9.9.2024.07.02.06.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 06:38:06 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	syzbot+f7f9c893345c5c615d34@syzkaller.appspotmail.com
Subject: [PATCH 1/1] io_uring/msg_ring: fix overflow posting
Date: Tue,  2 Jul 2024 14:38:11 +0100
Message-ID: <c7350d07fefe8cce32b50f57665edbb6355ea8c1.1719927398.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The caller of io_cqring_event_overflow() should be holding the
completion_lock, which is violated by io_msg_tw_complete. There
is only one caller of io_add_aux_cqe(), so just add locking there
for now.

WARNING: CPU: 0 PID: 5145 at io_uring/io_uring.c:703 io_cqring_event_overflow+0x442/0x660 io_uring/io_uring.c:703
RIP: 0010:io_cqring_event_overflow+0x442/0x660 io_uring/io_uring.c:703
 <TASK>
 __io_post_aux_cqe io_uring/io_uring.c:816 [inline]
 io_add_aux_cqe+0x27c/0x320 io_uring/io_uring.c:837
 io_msg_tw_complete+0x9d/0x4d0 io_uring/msg_ring.c:78
 io_fallback_req_func+0xce/0x1c0 io_uring/io_uring.c:256
 process_one_work kernel/workqueue.c:3224 [inline]
 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3305
 worker_thread+0x86d/0xd40 kernel/workqueue.c:3383
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:144
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

Fixes: f33096a3c99c0 ("io_uring: add io_add_aux_cqe() helper")
Reported-by: syzbot+f7f9c893345c5c615d34@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7ed1e009aaec..42139bb85fff 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -834,7 +834,11 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
  */
 void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 {
-	__io_post_aux_cqe(ctx, user_data, res, cflags);
+	if (!io_fill_cqe_aux(ctx, user_data, res, cflags)) {
+		spin_lock(&ctx->completion_lock);
+		io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
+		spin_unlock(&ctx->completion_lock);
+	}
 	ctx->submit_state.cq_flush = true;
 }
 
-- 
2.44.0



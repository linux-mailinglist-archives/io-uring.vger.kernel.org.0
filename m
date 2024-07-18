Return-Path: <io-uring+bounces-2527-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87E459351F8
	for <lists+io-uring@lfdr.de>; Thu, 18 Jul 2024 21:00:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B537B1C20C8F
	for <lists+io-uring@lfdr.de>; Thu, 18 Jul 2024 19:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89C9543AB4;
	Thu, 18 Jul 2024 19:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q5vwy1yf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293DC43172
	for <io-uring@vger.kernel.org>; Thu, 18 Jul 2024 19:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721329240; cv=none; b=GRAvdRoW303/Tbm3WffLAhnRmrcp8UsxHdoZ4UhyaPRtCQFCfuLY7WEOTkhDuQuEVpteA54TGVik6owiIY03G8q11fPBsRISxAqczPpSuXaQ7z3gz39sDnj03x9X13IqDjAV7GxcRuUEPak/We8ZfxAPX4sq/KoxqO5OkW74rEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721329240; c=relaxed/simple;
	bh=pfwBMSoIF7hRjnhR87XMcW+hAo3BKkh8Yb1UlDGs7oM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PYHkBextxESGD3dVz6M63wxHnef7Dh7l0S9iaHhsd4InfZWWNHK4WUx2Rzl2sb2ImFjlltl9eO9a9qU2/S9aOFdfJPtYtSW889BaBENILTxIKzrYoqiVUODzanBom48VeUYjuZfyhjaTJKyRMjSZKNwZaG4rcA5qjOcpBiqJ4ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q5vwy1yf; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-70b1808dee9so128854b3a.2
        for <io-uring@vger.kernel.org>; Thu, 18 Jul 2024 12:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721329238; x=1721934038; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PH4CPqkdlU7Ong2MyLEx6DzQ90oWG7y6TrgGwORBb94=;
        b=Q5vwy1yfcIinMfsaluHrkoc0leNdY9mMBioWzfKXIHxJx7bj8DrU4xf5AUWb4WYPWn
         4mbLCePmdtt5sNHl8UChnSgL5LE7m4QjFdCtZkmkhrLHvsP7Bz3VZ5ixXFLXbCoWejw5
         sD1F29NwptOe5Z8dLlovSVx/JYO/m2fmT6v0/mal1VFwqaDADFDd6+tdlB+ySVZAiz7C
         hWzC4TcGGPFOID9Wq8tzom4sERGI0Od7GgEKc+VFB+5YTwpVuqdJDR7EOS0fNdVC7jfa
         NhQzt+YqEYOVjl5WCx9ofx17aeSEQsXbU6BhwETJHq8dcK/SUwIXKLa52XgFk4z6zflv
         vBXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721329238; x=1721934038;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PH4CPqkdlU7Ong2MyLEx6DzQ90oWG7y6TrgGwORBb94=;
        b=qj6xZsuxzxIdZz/EASzrrfAMsZJVadh5yjE/K/XrKl4JpHRps5uwmraAm68jwklGEU
         IVPBqFBIcSYDueut+b+y7W+jJTVJ11RvnWONv5N9+8s220/ZaMeKT0boQ5EJ43cif5sy
         wz53oyyYxUxAvG+XNt20o6qgGJOhkZELtqYCyWjuXp+s2FRjD3k62myfHgt07qc3Nd9C
         knMAjXxLFyDiG/RfSIne2u8lfrUkHAfqU0pEOI5SImOv8+HcAHdRNdFOKmppAbGU2zha
         +G6b9r0NEh+XDBq2cy8srje2YUlZkGfWCC/XtubDEpRrWdfII5463ap7y+4ZAORQcjoG
         Axzw==
X-Gm-Message-State: AOJu0Yxp/1I3DCjZgBLQg89krARowuB9QuC7FSaF29Fo8Pm2w2vxG3Oe
	vnRBdnGHDQw4OwyXQFVNFn8UN2rBBmZ1bhgG/3O+qt/H915bzznbBywT681C
X-Google-Smtp-Source: AGHT+IH/xyOX8HvO5zWL4kAc2mMzc2re4Nu4va9kcuRFKsWcA35/ykKkWDbxkzFGycBsC/fWLjcEOQ==
X-Received: by 2002:a05:6a20:729b:b0:1c0:f2a5:c8dc with SMTP id adf61e73a8af0-1c3fdddaf8dmr6988236637.50.1721329236980;
        Thu, 18 Jul 2024 12:00:36 -0700 (PDT)
Received: from 127.0.0.1localhost ([192.55.60.1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70cfc7fc40bsm153984b3a.100.2024.07.18.12.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 12:00:36 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	syzbot+2074b1a3d447915c6f1c@syzkaller.appspotmail.com
Subject: [PATCH 1/1] io_uring: fix error pbuf checking
Date: Thu, 18 Jul 2024 20:00:53 +0100
Message-ID: <c5f9df20560bd9830401e8e48abc029e7cfd9f5e.1721329239.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syz reports a problem, which boils down to NULL vs IS_ERR inconsistent
error handling in io_alloc_pbuf_ring().

KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
RIP: 0010:__io_remove_buffers+0xac/0x700 io_uring/kbuf.c:341
Call Trace:
 <TASK>
 io_put_bl io_uring/kbuf.c:378 [inline]
 io_destroy_buffers+0x14e/0x490 io_uring/kbuf.c:392
 io_ring_ctx_free+0xa00/0x1070 io_uring/io_uring.c:2613
 io_ring_exit_work+0x80f/0x8a0 io_uring/io_uring.c:2844
 process_one_work kernel/workqueue.c:3231 [inline]
 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3312
 worker_thread+0x86d/0xd40 kernel/workqueue.c:3390
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Cc: stable@vger.kernel.org
Reported-by: syzbot+2074b1a3d447915c6f1c@syzkaller.appspotmail.com
Fixes: 87585b05757dc ("io_uring/kbuf: use vm_insert_pages() for mmap'ed pbuf ring")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/kbuf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index d2945c9c812b..c95dc1736dd9 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -657,8 +657,10 @@ static int io_alloc_pbuf_ring(struct io_ring_ctx *ctx,
 	ring_size = reg->ring_entries * sizeof(struct io_uring_buf_ring);
 
 	bl->buf_ring = io_pages_map(&bl->buf_pages, &bl->buf_nr_pages, ring_size);
-	if (!bl->buf_ring)
+	if (IS_ERR(bl->buf_ring)) {
+		bl->buf_ring = NULL;
 		return -ENOMEM;
+	}
 
 	bl->is_buf_ring = 1;
 	bl->is_mmap = 1;
-- 
2.44.0



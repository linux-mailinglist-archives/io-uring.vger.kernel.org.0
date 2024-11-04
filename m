Return-Path: <io-uring+bounces-4424-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 999CC9BB9E8
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 17:12:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51B731F22717
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 16:12:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1C5F1C07F3;
	Mon,  4 Nov 2024 16:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bPZV4Fd5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C44E1B393D;
	Mon,  4 Nov 2024 16:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730736728; cv=none; b=gWKJ4V3TKf3Ize9eHtgXkDMBI1GuzMNC52Kj3ZvB34/5YC4AoIAKB61+MdVNKTK3zU679TAE7oVGAmikNfoQbH0jUbK1KQCC6yb6z6Q73SkY+S0o1qDtRW9CxOw4+KAAh8/nhGEMpJKvdbrMRqiRpLIDkuXE+Zpi8kvMum0kK94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730736728; c=relaxed/simple;
	bh=vPRwe90zHahHOOj0Z2Qh+3WOfaePnL2PTtvbs7zA2M8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C+GG7Et7M0/W9BoG5jviDL5Qo0RhWVVZrBUBbVghz8o2CRxlh2J6zFVMFhbYVnhQyi+5lTw4mZW3TvGn034878K3MflM/zQjKTlgG83CjEcgf/VAH0o+xK1K7MvagTzHiLr+GC453ulHWRC0GlatwaY7o8QQTY7w0ZwoJSvoIAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bPZV4Fd5; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a9eaaab29bcso111887566b.2;
        Mon, 04 Nov 2024 08:12:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730736724; x=1731341524; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=e/5b8ihx5vuRnwO1en4w28K6JwXaOVMpIi0lr9UaU58=;
        b=bPZV4Fd5tII7vFXOCW3Y0GsTCeP25GhthmiEn7+b4Pbk2FaATtG0/g+8HBkwGYTxzD
         bpoWnBHtjomacJojXWRjd23Oh7b5Vftko8xXx3ntXYpIdN8tqx+7VxiUZzY8BpB5tMmm
         nX0rZpS660GuAPNCKtcWY+xyk62s37LPfmDmXc34kSpL+qIpZ48/F019pYE9YL70HpK2
         mIQQzA1W6isuyf+sXBp4OBrqmSB0U2QvWlGXmZZcUTODQP5nd2a7emLaUNclVnndHyPh
         O2eHhP3Xsd4o9b7PJxKOCVTIBurdUsK0heuh/95BvyHXEPmjWL20j3+3mKncRB/aH8vH
         fP5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730736724; x=1731341524;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e/5b8ihx5vuRnwO1en4w28K6JwXaOVMpIi0lr9UaU58=;
        b=qE+kqXqGdCxboP24YMVLw8/NCKnH73j0wEDJXnP9MqbXigz+tKMTvHtQSWOGi+cKko
         JGpHOlY2g+SoBUQ82pKAL5bO/1QBluoauYa+Dil7dJhf1MBZrdewJCfcs8IHK8lP3hRs
         KrewP8WXesgn3C023x13IO7Zj9gKFs6/7KfowA+kF9mepq4eqP6UtY8aJTPWyU9UqoDX
         aVnK0usGs9Bx1uOsQM4dnxbsko+u4IqjRinRxHIoW5R2QOIApNRV0bkciv2h6H1pIgPd
         aIemy7cZUtbA3mkKAOPuj7uZNL6oHxd0YRjUeye9oqeRb0QyyFClaF+RmF9qtAgeEhOj
         2tuA==
X-Forwarded-Encrypted: i=1; AJvYcCUAUmxgJQoV7Gqghfrwl8kohqDW7mI5HIvZX5eZ6V9P9n+OtHG0GCp6GWNj6MVsEmbzW/hN3oPYa5PRkw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxB3o6zRfGFjH7/wgdQ/djRnpWvxZtpBlp9761pcUZs+Q2fTSiL
	iY9IrVXHwp1OHC509HRfHwSS3BPaajt6/aIQMisQyWENtz5b3KjSS9NsKw==
X-Google-Smtp-Source: AGHT+IFB7u+BFwqO1pg0HGy/EQuPa6tUq16WBgDsMOF3rH+L9Pv6arPDwilF40PC4gAAX+UMLHuYvQ==
X-Received: by 2002:a17:907:868a:b0:a99:e745:d47f with SMTP id a640c23a62f3a-a9e508e50a5mr1533875166b.21.1730736723945;
        Mon, 04 Nov 2024 08:12:03 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e565f75e7sm576594566b.142.2024.11.04.08.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2024 08:12:03 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	maharmstone@fb.com,
	linux-btrfs@vger.kernel.org
Subject: [PATCH] io_uring/cmd: let cmds to know about dying task
Date: Mon,  4 Nov 2024 16:12:04 +0000
Message-ID: <55888b6a644b4fc490849832fd5c5e5bfed523ef.1730687879.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the taks that submitted a request is dying, a task work for that
request might get run by a kernel thread or even worse by a half
dismantled task. We can't just cancel the task work without running the
callback as the cmd might need to do some clean up, so pass a flag
instead. If set, it's not safe to access any task resources and the
callback is expected to cancel the cmd ASAP.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Made a bit fancier to avoid conflicts. Mark, as before I'd suggest you
to take it and send together with the fix.

 include/linux/io_uring_types.h | 1 +
 io_uring/uring_cmd.c           | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index ad5001102c86..bfdf9cbceda9 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -37,6 +37,7 @@ enum io_uring_cmd_flags {
 	/* set when uring wants to cancel a previously issued command */
 	IO_URING_F_CANCEL		= (1 << 11),
 	IO_URING_F_COMPAT		= (1 << 12),
+	IO_URING_F_TASK_DEAD		= (1 << 13),
 };
 
 struct io_wq_work_node {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 40b8b777ba12..f0113548ec92 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -119,9 +119,13 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
 static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	unsigned int flags = IO_URING_F_COMPLETE_DEFER;
+
+	if (current->flags & (PF_EXITING | PF_KTHREAD))
+		flags |= IO_URING_F_TASK_DEAD;
 
 	/* task_work executor checks the deffered list completion */
-	ioucmd->task_work_cb(ioucmd, IO_URING_F_COMPLETE_DEFER);
+	ioucmd->task_work_cb(ioucmd, flags);
 }
 
 void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
-- 
2.46.0



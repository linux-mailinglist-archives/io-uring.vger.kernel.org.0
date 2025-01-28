Return-Path: <io-uring+bounces-6158-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 29F81A20B6D
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 14:40:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 79BCD1663D3
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 13:40:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58D211A83E8;
	Tue, 28 Jan 2025 13:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="SIP3kCqd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7881B412B
	for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 13:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738071587; cv=none; b=syI5U2HcDu6iK4BPU7vYcLTyI8gKHVUnHDvzovoB3JLGPSBGEONBYaT9FtXwtFqBmMoxIPwg+BTEJcteOzrps5D4oKwPegXLC4JFXEOjHUyltAE8sCVuoLbEkoUj/xx0ojvRBYgYABsLPFsdAt9Rr0q6eJTe6y7Uv5Z66qcHvk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738071587; c=relaxed/simple;
	bh=rxwS0rDFX14c0VMUZBaTjErpG3AmBNovvucJwZOZofA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDy0ZrA+xLQ3E/mogutmQXaqIfJ53AFM+I2wsyz0JEEGFU9nbfO16UQlroqVol7BBb2V04+g9lHAn7NnSB6zErCWtiF6P7FSryIvTT/kFiQeaP/6afUVsz67ZG5EqUYaSkq9O8zQ+wLZ3JInuRFbn2lRI0LDYdVEf8a1TLM83AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=SIP3kCqd; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-436281c8a38so39670675e9.3
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 05:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1738071583; x=1738676383; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=96TZy8b5BW2zVkT896YXvpQRJfRndGqutQhUtIiN6/o=;
        b=SIP3kCqdEaMZT+247qyJh425UPNTX6nRNn7qlEDLoq7ykLkxWKiw1/qrUWW/vLXY9M
         7KgfdjNoKDvvrPgQ6D6quMyxB5BXqTdfAvw+e1JVuOjV6aLXoB70lquYjZQTC2GB9pp9
         YbS186soaYrRoNiqV6WfJOWrVn45Ebj8IJxDVoG/WrHUVuMx/MmfGLNYjsOdUj2VQQJi
         vLm7K4slVbb8KWRoDvVHzu03lMPyzy9PTNG2sLYpxoVKP4+Mqr/lOQWmkoHcDa0TPubC
         k7XAiLWlpeIfR+IYdSAVTSd0Df4oHRsX9gnx4/bOdwQjWRhulgXjVedbCFh/x21/NkSb
         1A4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738071583; x=1738676383;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=96TZy8b5BW2zVkT896YXvpQRJfRndGqutQhUtIiN6/o=;
        b=VWY/Y9MdEX8mhEKGPToLtnkvFqyFtHGUm5tkQKT38VT1XvpjRk5FbZu3Xm4vM4+ZbT
         scsyG8h53h/GIgRz0uqogrqYlbwmVQyH19RSN3T/FMEye9oC/G/7GTrFzZ2q9y323etL
         oX0D22EI8WqCPN/jsknt/ohvplOdF/POWLibnZBkoPlTMarnKWwtd+br/EvmR35eEzP4
         UiKmOOkXaJq8t1UWth585mAbDtjq6yudyAqQ8lRFq84h/pu9+Fs3Cq5WqoRWrvXIthmx
         4phfLD6U6t9id5z1MIjetG6hIj0+giVaxQSomLVDHDiU6cPhmXQuhbPv+rJBrkZVngR9
         +2OA==
X-Forwarded-Encrypted: i=1; AJvYcCWNhF8Dj0L5jswkd49EXBnd56nc2XYfkuJL2BzDHJjqcZ8IyeAo1HMNuRfJF9BvOwmqWQaf+PFQsg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwctU7LhLtVO5xl175uWLJWxmyWMyB5s7YDzLOtMw43ibVwo0d+
	lvWwJHWORb9OyGjkuqpbXi4+aowSvZFrh1MG4rbTc2Ud/7FAXb+fHjdJ5NaomJg=
X-Gm-Gg: ASbGncvsIZ+bbUuSoqK43Ml4NfrWtOjFR+ne9rZJDfDh6xYr4e2bjTEIOWtBcDs42I9
	+/XjKXvKk0jBCkb/gmvgqyIZjm0q5AUAIJ1igIkc96veHT+UclwkOHqPOPxsjdtNkNuF6L353H2
	mBu97N7joDe6mdQ+YGdzSQjqOi9L80MGGLgm+KDE+O32erF1cuNQ/WHQE4IeiICKlMaT34VFp3D
	QL1+ivGH/8nyXt7UFwjppXKmrNJDFkTFBFUN7u7l6jfv+3ohUV9FPzzrUhO88CxVtYAbCXdc2Al
	uzJJElh32V4OOwODP8BSZwVLTC6nmnj1hLHJi/oFvWT8Nrj9eJUzDaLJVIETuar781MlhbELash
	tlTbKjvEIFewluVc=
X-Google-Smtp-Source: AGHT+IFHR2TSaCX4qA/N4aKyPqiprXuE+wstO94ZvTs6BcxDNv4grOj/aPxscmSz1+8YtYt8k2Ju/g==
X-Received: by 2002:a05:6000:18ab:b0:38a:88a0:2234 with SMTP id ffacd0b85a97d-38bf5655328mr34750312f8f.4.1738071583546;
        Tue, 28 Jan 2025 05:39:43 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f2b6900023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f2b:6900:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1bb02dsm14160780f8f.70.2025.01.28.05.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 05:39:43 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 8/8] io_uring: skip redundant poll wakeups
Date: Tue, 28 Jan 2025 14:39:27 +0100
Message-ID: <20250128133927.3989681-9-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250128133927.3989681-1-max.kellermann@ionos.com>
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Using io_uring with epoll is very expensive because every completion
leads to a __wake_up() call, most of which are unnecessary because the
polling process has already been woken up but has not had a chance to
process the completions.  During this time, wq_has_sleeper() still
returns true, therefore this check is not enough.

Perf diff for a HTTP server pushing a static file with splice() into
the TCP socket:

    37.91%     -2.00%  [kernel.kallsyms]     [k] queued_spin_lock_slowpath
     1.69%     -1.67%  [kernel.kallsyms]     [k] ep_poll_callback
     0.95%     +1.64%  [kernel.kallsyms]     [k] io_wq_free_work
     0.88%     -0.35%  [kernel.kallsyms]     [k] _raw_spin_lock_irqsave
     1.66%     +0.28%  [kernel.kallsyms]     [k] io_worker_handle_work
     1.14%     +0.18%  [kernel.kallsyms]     [k] _raw_spin_lock
     0.24%     -0.17%  [kernel.kallsyms]     [k] __wake_up

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 include/linux/io_uring_types.h | 10 ++++++++++
 io_uring/io_uring.c            |  4 ++++
 io_uring/io_uring.h            |  2 +-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 623d8e798a11..01514cb76095 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -384,6 +384,16 @@ struct io_ring_ctx {
 	struct wait_queue_head		poll_wq;
 	struct io_restriction		restrictions;
 
+	/**
+	 * Non-zero if a process is waiting for #poll_wq and reset to
+	 * zero when #poll_wq is woken up.  This is supposed to
+	 * eliminate redundant wakeup calls.  Only checking
+	 * wq_has_sleeper() is not enough because it will return true
+	 * until the sleeper has actually woken up and has been
+	 * scheduled.
+	 */
+	atomic_t poll_wq_waiting;
+
 	u32			pers_next;
 	struct xarray		personalities;
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 137c2066c5a3..b65efd07e9f0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2760,6 +2760,7 @@ static __cold void io_activate_pollwq_cb(struct callback_head *cb)
 	 * Wake ups for some events between start of polling and activation
 	 * might've been lost due to loose synchronisation.
 	 */
+	atomic_set_release(&ctx->poll_wq_waiting, 0);
 	wake_up_all(&ctx->poll_wq);
 	percpu_ref_put(&ctx->refs);
 }
@@ -2793,6 +2794,9 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 
 	if (unlikely(!ctx->poll_activated))
 		io_activate_pollwq(ctx);
+
+	atomic_set(&ctx->poll_wq_waiting, 1);
+
 	/*
 	 * provides mb() which pairs with barrier from wq_has_sleeper
 	 * call in io_commit_cqring
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index f65e3f3ede51..186cee066f9f 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -287,7 +287,7 @@ static inline void io_commit_cqring(struct io_ring_ctx *ctx)
 
 static inline void io_poll_wq_wake(struct io_ring_ctx *ctx)
 {
-	if (wq_has_sleeper(&ctx->poll_wq))
+	if (wq_has_sleeper(&ctx->poll_wq) && atomic_xchg_release(&ctx->poll_wq_waiting, 0) > 0)
 		__wake_up(&ctx->poll_wq, TASK_NORMAL, 0,
 				poll_to_key(EPOLL_URING_WAKE | EPOLLIN));
 }
-- 
2.45.2



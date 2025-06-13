Return-Path: <io-uring+bounces-8338-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02E47AD947B
	for <lists+io-uring@lfdr.de>; Fri, 13 Jun 2025 20:32:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A542C1E4961
	for <lists+io-uring@lfdr.de>; Fri, 13 Jun 2025 18:32:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEC84238179;
	Fri, 13 Jun 2025 18:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Isuf67+R"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE004236A8B;
	Fri, 13 Jun 2025 18:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749839493; cv=none; b=F7mQsNzVbqef2wBdcc7YXR9/nRcml+CcN79LVXtJ/dyHOfws3mtSllOuaY/nd+QwOcpKowrJHvWIq4RZY+dFKfF2sfqxwwj27LXrx3FsCGvcF/0WvDvzPrwcWM94pjfEsDjda7ALBAaSximvYnozz0+y05WKT8LdR48WQZRCJUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749839493; c=relaxed/simple;
	bh=eMUl/jO2IVLo6EW2JY+EPAcCS4TRrMK9eFzvDVA1m+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGR6A3+2HIDiKdqqXlEm+XX7px+MIqULkaYMkEUAdBLi97yLsPSG55jqHfLdwBlEx2n167qx1+simMl6W/RKZVec0tQX3bw+sn7gE/PHDIPZ18YJ1VkVaXSI4ArPOg14oV5zZiAxfU2muQPgKQsGfmnougdEHvZk/xUO2BETKQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Isuf67+R; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-adb47e0644dso419318666b.0;
        Fri, 13 Jun 2025 11:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749839489; x=1750444289; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m8eHglNY3BYuvhpWh6vTwMM9gZVFRkTRv6U8o7bWvz4=;
        b=Isuf67+RniYEkCFRP+vlVgyNHh//ydqRDrbnlk0njWd1yPMx1RgJnin4SVHaFgYwu7
         ImPRQc9hB3F4xFl29bCB9YUvPwXWz1/Y7o4NtcQIqJr275oiWvZfWkWqKo5dBsfKTU5t
         tdhl6WGRX2qBxiKgNFjM58TUczvIwigFdnEfEMnJ9/qotD0jtmfbvZp8MABinYskwUU7
         0/H3IM6bOAOj2qTZg+t/x6Sq2rEzadd/TOckrfkBks65U137zuY6FOh+IdEt5oe006Vt
         NlMiMKQzg9b6EYhp2QqbnLOlg/5tIafIwrWWtG044OG5FENnE657sRH5X4HPd3kucBlh
         KwmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749839489; x=1750444289;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m8eHglNY3BYuvhpWh6vTwMM9gZVFRkTRv6U8o7bWvz4=;
        b=kYzhGA7ZJJdQMKPYBcZXlQ0ugtSHpJda+zHHWbPPCcmL2M5TvIAI5bT7R2t5Z4m7xM
         P4TC0riUkdE/nvQzU937drYB1v+9sKWXBAP0QHsJYxT96Sc674B7EKZYBIp/jr8hybJ6
         iRhfs2obnYLWESdtsno9PMUqtJlTTBAyxpafVJjPGfQOoOJAD2zs1H8763aK/CIXsVR0
         OQkKcbn+cnpD12ryFSAmsl/rWkVRuBixzTOXOoad7Uyj5M6MZzO10ca/gM4dIr3jjmHd
         1SxBLJcDaJOnNDlODcFv+0fCVEOsdgU6O1zq0a5LZR3D8mI7NwdRtOjf6CIvymuh1LAv
         Rogg==
X-Forwarded-Encrypted: i=1; AJvYcCX0IQ9IYS4aS+eJ8FN0ag+Bh8uF7+PetBLu+Pbprb3216y1Czxo9HJ9MRQg8bO7+nlgnYWhH+E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzD2hQYOnlO2cnk5LyvJs1TK3eWiQl4gqmGvTdhb802EFPGyYf3
	Ti0rIDredZPbcvcs/JhqBuY07JZZLwPXh+QlbQvlqjfyYXMvIkICKKIPaGgl3A==
X-Gm-Gg: ASbGncvLDcDVNrZaBJ+lmQVjnqnMm8pmCcjDqoOdhW2K9LP9CMiTj7kBjLmisCXFPWM
	haGPywT2WR2MOwz6Ro3qF+I0E4H0MONdpplTfnkB9dxvtqaBc2Am6/5GShlrTwZ5F5VHMHoZZtG
	yuCE/YCT3zzFio+yYfAjStNv9AZPRoeuTb/Qj6B7HBTVYAupdPwqASMTnV/SjXdMk2nBAU1nxPV
	1gZejGFyM3o0KGJNbDjGcs0EY6QL//vQErUtZLiiUoXHnELuPRjJ176D861WyQgWyXF//TSRxYo
	lAPhzbB0XXANRTkULEerjfJ8+a03bKW7lYSDGKZ1NQRngEL0D/k+NPYmv04/zrXJ3FYyBurvMA=
	=
X-Google-Smtp-Source: AGHT+IFExsLG3+fDNtemycT0Ie6KRePdGrNigXwu+9VBG0p41iagp3qlXQKE+8AYRBN7c845lL+MXw==
X-Received: by 2002:a17:907:788:b0:ad8:91e4:a931 with SMTP id a640c23a62f3a-adf9f89f4femr73140566b.26.1749839488713;
        Fri, 13 Jun 2025 11:31:28 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.48])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adf688970a1sm54772466b.175.2025.06.13.11.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 11:31:27 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jason Xing <kerneljasonxing@gmail.com>
Subject: [PATCH v4 4/5] io_uring: add mshot helper for posting CQE32
Date: Fri, 13 Jun 2025 19:32:26 +0100
Message-ID: <c595a2393f1fdcdeaefef6097274ba0c16246c4d.1749839083.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1749839083.git.asml.silence@gmail.com>
References: <cover.1749839083.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a helper for posting 32 byte CQEs in a multishot mode and add a cmd
helper on top. As it specifically works with requests, the helper ignore
the passed in cqe->user_data and sets it to the one stored in the
request.

The command helper is only valid with multishot requests.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c  | 40 ++++++++++++++++++++++++++++++++++++++++
 io_uring/io_uring.h  |  1 +
 io_uring/uring_cmd.c | 11 +++++++++++
 io_uring/uring_cmd.h |  4 ++++
 4 files changed, 56 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 98a701fc56cc..4352cf209450 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -793,6 +793,21 @@ bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow)
 	return true;
 }
 
+static bool io_fill_cqe_aux32(struct io_ring_ctx *ctx,
+			      struct io_uring_cqe src_cqe[2])
+{
+	struct io_uring_cqe *cqe;
+
+	if (WARN_ON_ONCE(!(ctx->flags & IORING_SETUP_CQE32)))
+		return false;
+	if (unlikely(!io_get_cqe(ctx, &cqe)))
+		return false;
+
+	memcpy(cqe, src_cqe, 2 * sizeof(*cqe));
+	trace_io_uring_complete(ctx, NULL, cqe);
+	return true;
+}
+
 static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
 			      u32 cflags)
 {
@@ -904,6 +919,31 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 	return posted;
 }
 
+/*
+ * A helper for multishot requests posting additional CQEs.
+ * Should only be used from a task_work including IO_URING_F_MULTISHOT.
+ */
+bool io_req_post_cqe32(struct io_kiocb *req, struct io_uring_cqe cqe[2])
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	bool posted;
+
+	lockdep_assert(!io_wq_current_is_worker());
+	lockdep_assert_held(&ctx->uring_lock);
+
+	cqe[0].user_data = req->cqe.user_data;
+	if (!ctx->lockless_cq) {
+		spin_lock(&ctx->completion_lock);
+		posted = io_fill_cqe_aux32(ctx, cqe);
+		spin_unlock(&ctx->completion_lock);
+	} else {
+		posted = io_fill_cqe_aux32(ctx, cqe);
+	}
+
+	ctx->submit_state.cq_flush = true;
+	return posted;
+}
+
 static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index d59c12277d58..1263af818c47 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -81,6 +81,7 @@ void io_req_defer_failed(struct io_kiocb *req, s32 res);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
 void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
 bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags);
+bool io_req_post_cqe32(struct io_kiocb *req, struct io_uring_cqe src_cqe[2]);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
 
 void io_req_track_inflight(struct io_kiocb *req);
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 02cec6231831..b228b84a510f 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -328,3 +328,14 @@ int io_cmd_poll_multishot(struct io_uring_cmd *cmd,
 	ret = io_arm_apoll(req, issue_flags, mask);
 	return ret == IO_APOLL_OK ? -EIOCBQUEUED : -ECANCELED;
 }
+
+bool io_uring_cmd_post_mshot_cqe32(struct io_uring_cmd *cmd,
+				   unsigned int issue_flags,
+				   struct io_uring_cqe cqe[2])
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
+
+	if (WARN_ON_ONCE(!(issue_flags & IO_URING_F_MULTISHOT)))
+		return false;
+	return io_req_post_cqe32(req, cqe);
+}
diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
index 50a6ccb831df..9e11da10ecab 100644
--- a/io_uring/uring_cmd.h
+++ b/io_uring/uring_cmd.h
@@ -17,6 +17,10 @@ void io_uring_cmd_cleanup(struct io_kiocb *req);
 bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
 				   struct io_uring_task *tctx, bool cancel_all);
 
+bool io_uring_cmd_post_mshot_cqe32(struct io_uring_cmd *cmd,
+				   unsigned int issue_flags,
+				   struct io_uring_cqe cqe[2]);
+
 void io_cmd_cache_free(const void *entry);
 
 int io_cmd_poll_multishot(struct io_uring_cmd *cmd,
-- 
2.49.0



Return-Path: <io-uring+bounces-8204-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C6389ACDA1C
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 10:42:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B0A07AABE9
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 08:40:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BADE828C2D0;
	Wed,  4 Jun 2025 08:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ItCtRcsN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F303019C54B;
	Wed,  4 Jun 2025 08:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749026490; cv=none; b=h7szyLk2uYn9E01hhNxjf5urouKID3RnedKIq0s5BRAITghy1gKGp3IhcYDZmUvgx3luSb+MyalI2uyQ0YYvK6ot82yrAClrmvIZ2tLO6/A1dMwOTagJPe+Defzlz/Q55c/HaAE+TO16lcrVAymhkoePxHGDK+Xs2vxI8djmYEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749026490; c=relaxed/simple;
	bh=Jjjo60WITY9GtZmvz8RE7uP2zNvDt+TkJqvuQdBjyZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JeUFBuBx/qiAyQ+9+NxNEvHglZ132S5iA51ItNN6x+J8+eI9Nz0eYivCOEdausEpuMB6bYKSKAmBMKuSclZjAQGwMaQ0vwJ1dRZC27uElM76sc81gaqe75WgLv5qyzzBuhujqT9HBy2+5VwAELJtCvQ8RyJZWkcOrFmZOL+mp2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ItCtRcsN; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-606fdbd20afso573063a12.1;
        Wed, 04 Jun 2025 01:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749026487; x=1749631287; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aD7+pJreiHwF0tkKY4KqPuG7e7WnlVtmgmXqmSRVJZA=;
        b=ItCtRcsN91o02/t9MEeD/WwGtqostTjK9PRafVjHZo4pVJ0+2JnFEyzsgVIp1c7kPu
         5qXxl+hAYryK53tpSgGMyYPJFTghYG33uLmL1QSqgAONwpRIjgUike1oJsol1sYP4oOJ
         8RG4M9aBgazryeg5rBTe76L+m1H5/EYx+l7gusKJZv6kwvakTum4zZiqu9pnkJ9xh34O
         jW0fpimD/9OUC104idwBmFUXweB669mMjffW4x2pOUuHLy+ZzWbuZ6u6n63k1l5SVLCO
         Q7VU/obQeXcoijYWLvUujhtR8yH4EWzffUGEMn+EVbvGagJ30a6knMkYPP+WNm8s59Rc
         Pk2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749026487; x=1749631287;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aD7+pJreiHwF0tkKY4KqPuG7e7WnlVtmgmXqmSRVJZA=;
        b=fsnsHyK9n1yWkgTnLIV3DEbeGAcxlBgHrfu311fN66MJ3Ld9KlLdMa7OwNzVFyj60V
         c6/cypl8QzJc++qu3aH+1LM9Oa2tT95kAdXkJ6oDpd8XxZjO13NgVMZIEZbkao3OsFxT
         dMP0xihCdvW3BMB2J4tyZscdz6sCt+xGmodd4mBJXZDU53DPOMD4liaC8RqzO8pmVqw2
         yWed+5hKFFl107bq0NO3McMZJ1AJZoQ3zTXhsYohN5QsX06xrzpchj+kPxeailWjK7kh
         JPhq5yTVjEs5W9L54j7+h/l0SBqTr0UgoMV0d52vXZIuwirFKh05wEN7sRIq2iYijgAz
         3C9A==
X-Forwarded-Encrypted: i=1; AJvYcCXHgv2/Kg17ckuprMpcY6Vt9gixGaUEwDgOw1G71+aiFihj9mfFuvZMpysXDqb3mvZlaIVPIAQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvGhIXAY0a1RU7v3eNWFcxOJTMP1bYjcVYv4HyD82Z9jL20PsU
	vHkvs78vLPt1pGE2MMgn1OcozCFJm/FnuX8zEdfiGtQeOtEoqsxvLIp8B4nOVg==
X-Gm-Gg: ASbGncsPIajvLiVBO+KKRrKTYYzqpVz9fISuwm5arNauWid1ZmA9MpZ/AgTy6mDf6zz
	KDA2vTq+fnAiHKsQr1BBF5J1NNRpsERQemUikcx4SRJrk8GRX/0eaxFMBEq+0QhFIJnZhChTiUM
	OCiwNlT5p6hVnS8UaM9zVwA8KurX3f0VyMS33itzB4urxtgueqo9WDdufofx8mvdxKHoDoUuj7O
	3ZVHbMffTA5KUHg0cE+QvlzkFhXCb+Xo4jdHz8zrAXl4KJYamsxd7DllHP1NcI+ZRhPfh1dSbyS
	Me83v96dUrtvSPf3urEP1OhAJ87FN6N5ji0=
X-Google-Smtp-Source: AGHT+IEKywrsot3r1ubXgmpT6kcY7zyuyTpHxYspHeKWHvHcVLmZ4STFPhGxy8FhRF6CKFxM9SlrLA==
X-Received: by 2002:a17:906:6a16:b0:ad8:9466:3344 with SMTP id a640c23a62f3a-addf8fb0af8mr157189166b.43.1749026486474;
        Wed, 04 Jun 2025 01:41:26 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b3d1])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-606f3ace23bsm544261a12.12.2025.06.04.01.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 01:41:25 -0700 (PDT)
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
	Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH v2 2/5] io_uring/poll: introduce io_arm_apoll()
Date: Wed,  4 Jun 2025 09:42:28 +0100
Message-ID: <959e9230cc9c0a11e8ffda604ddec27e27a71573.1749026421.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1749026421.git.asml.silence@gmail.com>
References: <cover.1749026421.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation to allowing commands to do file polling, add a helper
that takes the desired poll event mask and arms it for polling. We won't
be able to use io_arm_poll_handler() with IORING_OP_URING_CMD as it
tries to infer the mask from the opcode data, and we can't unify it
across all commands.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 44 +++++++++++++++++++++++++++-----------------
 io_uring/poll.h |  1 +
 2 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 0526062e2f81..c7e9fb34563d 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -669,33 +669,18 @@ static struct async_poll *io_req_alloc_apoll(struct io_kiocb *req,
 	return apoll;
 }
 
-int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
+int io_arm_apoll(struct io_kiocb *req, unsigned issue_flags, __poll_t mask)
 {
-	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
-	__poll_t mask = POLLPRI | POLLERR | EPOLLET;
 	int ret;
 
-	if (!def->pollin && !def->pollout)
-		return IO_APOLL_ABORTED;
+	mask |= EPOLLET;
 	if (!io_file_can_poll(req))
 		return IO_APOLL_ABORTED;
 	if (!(req->flags & REQ_F_APOLL_MULTISHOT))
 		mask |= EPOLLONESHOT;
 
-	if (def->pollin) {
-		mask |= EPOLLIN | EPOLLRDNORM;
-
-		/* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
-		if (req->flags & REQ_F_CLEAR_POLLIN)
-			mask &= ~EPOLLIN;
-	} else {
-		mask |= EPOLLOUT | EPOLLWRNORM;
-	}
-	if (def->poll_exclusive)
-		mask |= EPOLLEXCLUSIVE;
-
 	apoll = io_req_alloc_apoll(req, issue_flags);
 	if (!apoll)
 		return IO_APOLL_ABORTED;
@@ -712,6 +697,31 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	return IO_APOLL_OK;
 }
 
+int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
+{
+	const struct io_issue_def *def = &io_issue_defs[req->opcode];
+	__poll_t mask = POLLPRI | POLLERR;
+
+	if (!def->pollin && !def->pollout)
+		return IO_APOLL_ABORTED;
+	if (!io_file_can_poll(req))
+		return IO_APOLL_ABORTED;
+
+	if (def->pollin) {
+		mask |= EPOLLIN | EPOLLRDNORM;
+
+		/* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
+		if (req->flags & REQ_F_CLEAR_POLLIN)
+			mask &= ~EPOLLIN;
+	} else {
+		mask |= EPOLLOUT | EPOLLWRNORM;
+	}
+	if (def->poll_exclusive)
+		mask |= EPOLLEXCLUSIVE;
+
+	return io_arm_apoll(req, issue_flags, mask);
+}
+
 /*
  * Returns true if we found and killed one or more poll requests
  */
diff --git a/io_uring/poll.h b/io_uring/poll.h
index 27e2db2ed4ae..c8438286dfa0 100644
--- a/io_uring/poll.h
+++ b/io_uring/poll.h
@@ -41,6 +41,7 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags);
 struct io_cancel_data;
 int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 		   unsigned issue_flags);
+int io_arm_apoll(struct io_kiocb *req, unsigned issue_flags, __poll_t mask);
 int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags);
 bool io_poll_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 			bool cancel_all);
-- 
2.49.0



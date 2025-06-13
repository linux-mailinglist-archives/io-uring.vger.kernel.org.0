Return-Path: <io-uring+bounces-8336-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86A1BAD9474
	for <lists+io-uring@lfdr.de>; Fri, 13 Jun 2025 20:31:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EB5E3B46CB
	for <lists+io-uring@lfdr.de>; Fri, 13 Jun 2025 18:31:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15D93232369;
	Fri, 13 Jun 2025 18:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ItKMXN6U"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373C0230D14;
	Fri, 13 Jun 2025 18:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749839487; cv=none; b=AbLrxTc1IHaZuNGcMXZN573csaxZxOihIvONg8iOcijmKUxvPQnI/+mD8+d1Fy18Y5yhaP6TFBlq4e33UKdLc2rUfrW2xJGr8ln5/UApnfg2Cw8747pDbFWWa+EtroeKUdnCAIRMJt0n0BUq11GHGW9qa7L5IWqCVt3Ch0G3ACc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749839487; c=relaxed/simple;
	bh=Jjjo60WITY9GtZmvz8RE7uP2zNvDt+TkJqvuQdBjyZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CoJ2KknqPbH5X3tvYhINQIRgE0e2eAblzBqlfHG/4n/exCK1855k1HXOIq1gkT0cTZRwxjFOH9mqhsaLryvs+V8cfPuup6K3CGuCibf1/v0Gj4berc9sXAoud+Z/ZtOrj+yrfHdydYJLLgBOkyZkfTNZ/fhH3gYvuGmD9byLCAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ItKMXN6U; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-604f26055c6so6593649a12.1;
        Fri, 13 Jun 2025 11:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749839483; x=1750444283; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aD7+pJreiHwF0tkKY4KqPuG7e7WnlVtmgmXqmSRVJZA=;
        b=ItKMXN6UEm3sGnHelkFM2dMnCg19aQVxcVKzorEr+hDFTWDOu3+VmrbJjJqXPs+zs7
         QkQBj1FZuqFw3pHA/qWmadr+vZA7knz5Dy9KwqDN/EWiB57Z83O82v2phcMtc2RERiD1
         RD200XSA6ZGK6xN9aSvy9A1nBUIsbdsJnm5IhyLx10jWIGoasG/xBPz4T+2ly3XmlgM0
         942WfQOIGfEfgeR85OpgMNf26E1bkA0eesnBigJAQsSNo2BsXNqTqCj2Cul0hflWNA+r
         Tsec+6+K1aE0OoqRcS/Ecgd2pETRNvGxpsdgBgiyVxlgj2lVs8y2nZFNkoHMuBUtKih/
         W7vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749839483; x=1750444283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aD7+pJreiHwF0tkKY4KqPuG7e7WnlVtmgmXqmSRVJZA=;
        b=UMdJAsOcRbV5lEd2ugRGX5+c1vAuhI0SPQJgoIvrNijupc+Wzn9C1+Pgm3MTw7wv2R
         2ns5wSWiTNIWndFdxDYqqG0GqsY+0jmJZdQmQ/nE3nLzj3htEMCoA0l7QQs9hzYt839t
         H0MzzT5xPxk+VH/67vE76bRJqMa3rVYjPXHZ8H+0SnzaQk5ctLBK15WFKbkjLD+L9wmu
         GbV1ftkXFV0ccDGtVW4zAFuY0kefgkg6geRl/5R70ndtu6MhxycocBd5/BffsjCn0aXy
         Z+0ouZVvy9H6Y1N03ikfXBuPP3qDGtz+Ali+ApEoEYUSQRvIGCRoH8YqAWX+/zupv6VB
         7Oug==
X-Forwarded-Encrypted: i=1; AJvYcCWCQ63tcP/vCAneBBIE1wO1YfEvMZxCc5GDVgBwSaKGi+JO+VQGuy73iF1DrjT5BcpTiXC1x0I=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLiB+d21IYluY0/3izSO1VoovYbDR7fK8N8dJHvqQWFC1hK/rZ
	ImE9l365fIwhv5r2NlZ7ZirKGCsmZ2pLvlpAnEaqmbtb2b2nvILuObZ4yCOcyw==
X-Gm-Gg: ASbGncuD2/063532+n4/goXNnh4bQ31aDiJl2A1OdKQbcsNh7qj4s++8s0Ul/1WpRRM
	We5VRHLQ4eBLnWeQSY8roHIxF+EjM3iBahee4TxIDIvOZuKT0EvF3UiyOkZcQxYne6svmZl47ke
	y80TZLHZTrEI82VQ6ObwD66/h17Zy5uK4p92dNR+Fl8RTkBUa8k0c8KP8pFfO2TGxJGhSknBNdb
	QPydPmYBg46Oi6bS9kGI/tZ3Do/Ob93tHN3DHa+jkKsxAnR4z71xPFvi8+Luibkm3ziQKHucDGP
	zIl3W6YGCwIWa6GCdBoaSDlbVBOxOZi9LFAO15Umgkwvt9f8oWW10WDvkhe8ktGzKlIAuEZqaQ=
	=
X-Google-Smtp-Source: AGHT+IEcDDOQoZx8NlZDP80XuHDh3pvZwtx29Zy3FyMGkdIRPnb+dhTaAKdE/f6tBiDClOntPsrxkw==
X-Received: by 2002:a17:907:d9f:b0:ace:d587:2f3b with SMTP id a640c23a62f3a-adf9eab36fcmr66983866b.22.1749839483076;
        Fri, 13 Jun 2025 11:31:23 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.48])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adf688970a1sm54772466b.175.2025.06.13.11.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 11:31:22 -0700 (PDT)
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
Subject: [PATCH v4 2/5] io_uring/poll: introduce io_arm_apoll()
Date: Fri, 13 Jun 2025 19:32:24 +0100
Message-ID: <98a324d24d94ee3c3064e2de06de64461b12372c.1749839083.git.asml.silence@gmail.com>
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



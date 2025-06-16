Return-Path: <io-uring+bounces-8357-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE4ABADAC3A
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 11:45:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 633F2172026
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 09:45:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB337274660;
	Mon, 16 Jun 2025 09:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VlP9N4F+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0328F4A;
	Mon, 16 Jun 2025 09:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750067130; cv=none; b=FSrdYJcoIT0+L5nfqbqMRAKjU9479ma75Ft8NVkbIHle+58Q5GwP6C5eybhAUvxMG8QHHDPDRy5wWtXqigMO2JpD2VlPhDQHx5l29/T2eRrONqGK5akXyeWIR9q8VnH5nnY6QyX66jLL1A/60yo7PAphoLSk03eYoTZS41vFtsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750067130; c=relaxed/simple;
	bh=Jjjo60WITY9GtZmvz8RE7uP2zNvDt+TkJqvuQdBjyZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWnkIuxJogu3vDTlvgLQr2iWdRSnrQIWbu868SPg/b3o1l0mytYEP0abBb6m1ttJU4dilgUXIpkLpZLtq/wmaYzgDS7veSiJerlN5Xxd/LgI3n/XjQ5fcUT3SR6Ed7agJ3ob1WYqBfi0t5ax+dhvnpiTJUSwdQJt1eAbq92HTgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VlP9N4F+; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ade30256175so835978266b.1;
        Mon, 16 Jun 2025 02:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750067127; x=1750671927; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aD7+pJreiHwF0tkKY4KqPuG7e7WnlVtmgmXqmSRVJZA=;
        b=VlP9N4F+9pB6Aujc8o+sDWJLGHho8Z/63dCQE4hJ2vphvZ9i36exQ78s7FpofOHl2a
         Y26ynMV3LwsFqoRnGHm8gEbJNJ2VM8fT+j21mHONv1AsV9UwkwmUdRYRj+DNt5bcVc7i
         LqXWD0L6xYhD91BFjizCerfNN5oSUWpY8XI3hcthQjXlaUB3oaj6+tov4AbJbEKuRjvU
         D1NmcSSsyqSZr3QBiOGrFldgXTUE/zgGjYuJk6KFBKjIqOugENkPEmd9eDKgBvP6INTF
         6CFcjp577goCnEOUZgwcABtdqTZVf4UkSbR9A8KR7J+DVrAG5vZAYapIcGxoTq70VK8w
         8c9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750067127; x=1750671927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aD7+pJreiHwF0tkKY4KqPuG7e7WnlVtmgmXqmSRVJZA=;
        b=TkRtx2zETsL2nWyYq6yNyNRe74hieU2s1LMOU9fkSADtduPsLPtUbploJepfiPr9sz
         8kGwbdd2BlvwbYlyK7oMs65MIQ805gRZcUdTJrD0+P5JA6+TzSsf552M8LE7lAIyYyf0
         +dUYAGSVo1kXC0weXTRLyVN0S+5qCpv4GPcSG71cwIIeZbIWgL8+Jwnv44FbMryyFiB9
         WnXojWkzvdELaXFmMq3fAUqPr+4A1oURJFvfQuerIWxdwq4nUOKeBta2DhK8eROwbHaN
         R9QiltXuCZVM5CpSXncdigk/3VL7WSQD79AO1FBl2q3bHVtH0Du2xNqpTbpVEsraCPl+
         nOXA==
X-Forwarded-Encrypted: i=1; AJvYcCVJI8O0rd7n830mGiPb51IbeYgvCKe1CJMf0/JstixspoamlSgyM5hsD9ctyx+o1Doy9crvAG8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJXVHieb1asThejOeW4zyIJlFWSkzwpVt2F7GbQJHieuDlbdK1
	CigondJUsZUO7dgqTlmPZgQZg78SCLn2tSowXvWGWJ4i+cDAxK3L+NmYIOS5WQ==
X-Gm-Gg: ASbGncu33KGZOaRI6N5skc6UhFEworPXvT9JIrgTO3GmLCJNdwJCLaVpKn5J2CM9ggT
	LxgC1pRKbyNVUwvPVQ2mdnOvXA21WC4MP7RSOsbiSAESZUixpCX8pOTZhfvqnriwhrZIyUDc5JR
	5+kyf9sUhjiW3nte0mCrTjrsHVTxAd0+yKiQXKmTJDF7Hn+JhuVZAnJd2AqD89NpiBIWYpbeV9W
	x97H5pmcYOXi71JZebYHXq2/0s7kJ5wsMFpg/eR7G+2BIm4nsOSyw3S7qf23OYPzTrGxgdusDAJ
	zNIF4hxEyvRiJxu5vVPZAzk+NF/MGqRP1eSMwk/ocUWqSw==
X-Google-Smtp-Source: AGHT+IHykhQQxoMiX9eHz+kfP19B7s8I7Ekhevw3qg1xNANG3H2W+pTJjBw94jwd5bHC1jhmz0+LuA==
X-Received: by 2002:a17:906:c103:b0:ad8:a41a:3cba with SMTP id a640c23a62f3a-adfad43c58fmr968410666b.43.1750067126798;
        Mon, 16 Jun 2025 02:45:26 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a3c1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adec8159393sm629363266b.15.2025.06.16.02.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 02:45:25 -0700 (PDT)
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
Subject: [PATCH v5 2/5] io_uring/poll: introduce io_arm_apoll()
Date: Mon, 16 Jun 2025 10:46:26 +0100
Message-ID: <7ee5633f2dc45fd15243f1a60965f7e30e1c48e8.1750065793.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750065793.git.asml.silence@gmail.com>
References: <cover.1750065793.git.asml.silence@gmail.com>
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



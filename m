Return-Path: <io-uring+bounces-8313-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4B72AD6BBC
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 11:09:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D50423AF5FF
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 09:08:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1EB322CBEC;
	Thu, 12 Jun 2025 09:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mEaZHSEe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41EC226D02;
	Thu, 12 Jun 2025 09:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749719314; cv=none; b=hNFyF8M5fUR08xcanxOrv51Zn/1ovXvDh2ukGTN05PuUw0osnRRcbf+l//2BBZEBNTABkLIbyjDH+444L/f44O8ZZYZzg2r9lMSOWe4ZyuUMETFAheQ+FrnIYLqEV1M11LPHEBPJ5kiix5vk5YKGq8rOoY12WP88d5j7gViqNLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749719314; c=relaxed/simple;
	bh=Jjjo60WITY9GtZmvz8RE7uP2zNvDt+TkJqvuQdBjyZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3jFJZzYfAwLloYyb5Qc7vRjGW9bqmZRasAMljXawKVt1/BQBTuLlYS1+wlS2Krv22mOiJiWw4MJPeDtn38rMEcQSZVQX7EqQCrnVRkB/iBDNG5dUiyfQl2hIxbL67l97zEovU9Zuab0Li9x7hJkjx/SyduF0Sj48af1C6qh2Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mEaZHSEe; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-adeaa4f3d07so122115766b.0;
        Thu, 12 Jun 2025 02:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749719311; x=1750324111; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aD7+pJreiHwF0tkKY4KqPuG7e7WnlVtmgmXqmSRVJZA=;
        b=mEaZHSEeOYMx1ITeDgrxTgQBSUS+c5dbuNY2bMBoriwXEd3a+3jWdoz/5LLtWjpzcg
         mHJYoRtbuebiAfADyhvabE8FFZm/1wNq25BQhcFMqwzEI3Ld5D1hjKoN/WVe0S2tiz6J
         /5yrTfYk6KBDHksdeBngXUG0tUqE7pzD/bKeoYyRKG7NQC8YfAdUdUObwxLZFRAI37uV
         MCJMsra/CBAHK2cS35nad3XwbYDXq0wsbu+aW7sIiX77AJdsuAHM4V55YzRqjiDogq/R
         B2Uw8qLZyYJ4TGB+zs9NZUiEl2/n2gcNLX+m/621NwvL7xyt9iOCpDu20qHLeIP3LLTt
         ZMqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749719311; x=1750324111;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aD7+pJreiHwF0tkKY4KqPuG7e7WnlVtmgmXqmSRVJZA=;
        b=c2GlTyroUFconIK+rr5V5G8Um8P/+1F4K9+mPEJJZPCsSepUMEO8zY7eaoibAAlGYd
         0HgHOnb/1ZPfo38oIIaDUhIac0Ml4z88+B+ywMMZUtsz0fLJfcJiHMCB9jltjntr0neX
         z2w2e4nSo+A4A57KV5QzPeFMPSJFXsBs+DbHN6UqCi4eGUoOYYnpejjHzkRUKnpk5pWO
         OLGtrnaB26kdjDKaV8ybk5yq54jTN7KpsRq3L4J1JFouewzLTSoH4Qw2pXX7iSHPaz7L
         KmWkBt/wh7jz2TKRwrmr3/4YhWnudXONDkNeqzxKgoGtws83JjqFBgSXN6v5ICzAgjV2
         lTwA==
X-Forwarded-Encrypted: i=1; AJvYcCXWeL135QKWD/QyZh0NNbE7rS7DJZQHvEB4x9tjrUjo/hA6MawxY5Yer5xdBNgdrjSAieSjbGU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzS4jxdQnxlXHL3jSlRTXDMjjHfz/zU7uhI2jzlRdBLEG4RE7ML
	Dn0MyhItig0ZT9b5+slyGixfkJvmRsTGlN/e4IfjBqr0dxEhD9HevDvvR60FNA==
X-Gm-Gg: ASbGnctDpATXj5nFsllIQje7kiOVviGRQMz12iFLyeg3M8n7MTPS5gwa7lkcpAJU9L7
	/MY1WfsM84wizLPbb+E2aDTb/g0RdDxHuYh8a/DDi8RF+73YtWggWj9meC7mG32r2qcfzpzXi6k
	MCXeeqZkQJhSVkEXk93C74FE1I+NUidCWNhEy3H6KsT9WRYgQOXyiVcsMdl5K03ATEh2Ir0I3w6
	qAJHyTb2O1P23CU1O7dVJxA0l/e5cTLKgDOjtPsPUE/bS5zpfs9YR+WZq65uV5Gm0b+vAU6JUG5
	aX6zHY7bI4XbPQAmdhlDV/NQW1OQt/LKfm/Kjto2oJyQ7XTpIYNMFL8=
X-Google-Smtp-Source: AGHT+IHrRmXS82LcGv+9a3ea3MIIShvaWhnWf3BNJTC5Kc8qcpcmCzpBeSjIQec5Q4AZt0zn1zTDNA==
X-Received: by 2002:a17:907:3e9c:b0:ad8:9a86:cf52 with SMTP id a640c23a62f3a-adea2e3bb34mr288040966b.11.1749719310602;
        Thu, 12 Jun 2025 02:08:30 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:be2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adeaded7592sm96883166b.155.2025.06.12.02.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 02:08:29 -0700 (PDT)
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
Subject: [PATCH v3 2/5] io_uring/poll: introduce io_arm_apoll()
Date: Thu, 12 Jun 2025 10:09:40 +0100
Message-ID: <92cda3e90a4fdc9c546a6184880219c3de43809d.1749657325.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1749657325.git.asml.silence@gmail.com>
References: <cover.1749657325.git.asml.silence@gmail.com>
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



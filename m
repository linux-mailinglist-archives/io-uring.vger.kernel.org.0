Return-Path: <io-uring+bounces-8136-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AD082AC8D71
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 14:17:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4BE321BA3D23
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 12:17:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66D6822B8BC;
	Fri, 30 May 2025 12:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GyW+3uSZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9932A21CC52;
	Fri, 30 May 2025 12:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748607441; cv=none; b=htQzPVOCI0Q61LVYfvbbbrrBDgeIkMqvJNV0fnyp+tlqmE/w/KbvemqrBax3y/Xm/0rvRPtn5hxz8RwuUul0jEvEU4AfTte9aoU2Y99mIWtbx5M1FeB9fbOsWbAz2qnOI4nlMsdJz+eFDg1V8J37G18hQIp6J1xICIfdIZYgUJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748607441; c=relaxed/simple;
	bh=wYJOuL6S093inTGvvfWTLKx8WcK0RaSvoTbskIP5tdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xqm3dxi27H446U14Yx+SrnMC/27ZbI84W04odcaNb15wRoz/KQW99jqPrWFK+U9bg2AJNya95et0ybSUnA5BbYsNZc5MOL1LJO/+f4uKRuzvjJkyIv4rUTdKc7Gd6lYphagH6eFr5xRNm1MC4V8yqhIn/XHsAcx6YZb5uUT9xNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GyW+3uSZ; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ad891bb0957so348350166b.3;
        Fri, 30 May 2025 05:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748607437; x=1749212237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N97/0PsfFcq0hHRyfvZ+ENfqQRwwjgDWrJVrn6txEtc=;
        b=GyW+3uSZOCubL6/b0mreOwD65J3vgrGHztK1gzjVsro0/xsnZy74euBFgQ6e9Qbbjm
         dqp4kmMmIKAtfSnRP12MvnEzAjDMq9bHvDOdO5+o67OHJtI9sEVK3DrFTC3OP1T1MyXW
         3TIjmvfZAvS9Xp7K7rR5OmXgzG077g951762VkbjaoBsIBx/Snpiq2d82Gz2cTWnA++3
         E7y4RzuVdY1Fw6U2SqZfFkwllsf85BL4M1NqRaD0EDMcobPHcJvLdDkIPJ/o+HvxRaso
         +htOKnlF9kqvEtVX9f3nWACJzIeTCalRMiKPDY4buxFaCFael6SWuoQRa+Yj4LpQf4Gm
         2lRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748607437; x=1749212237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N97/0PsfFcq0hHRyfvZ+ENfqQRwwjgDWrJVrn6txEtc=;
        b=V+2Kfn3I9c4zyNm3efIIIvhdgOmoOAiY23Tw8tjSraVBruK2reoJN5D95uH+QgmX3m
         qkmuzQ31hbGr+2zklWalrZCGEehqzT33VLoMK47sOxVmEMdSfQsVPuKN7G8dcvHPGb27
         uzUhZ48KkqIa9W0vaGsU9XvJCX7aIY/yHhg0IKkKnhZeCKoDv3YnV1HXYtmDTqlh3Scd
         U7ztXiZfGXQLCvKxh/f5VwVx6rJrucxYyow45dn+ske5VecBFyKKBTMFrKcZvyYaNeE+
         6W60g3HeBE/UGdbtLjpgNxnvIex2PHX83Tj/3M9JVMJhaF7A1+f08Ah1PLyO/qKgUXHl
         laww==
X-Forwarded-Encrypted: i=1; AJvYcCVPKSRkViiDeX6P1Xt/EEsh4gvZ67l0PRrKX1oJYnF4AMDExkoiI5C/uZ/chvwQobAxpyzPKLU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXY2lp0X6uIuAWbSBfkzNpamgbE28IacpSHw1y5AsAUB69tLw8
	IKmlBQSxBWBMmxhX2VnO0TzSD6K6PhlPJWjowsmS2tRHMedI2jh96Y2xRcaaCg==
X-Gm-Gg: ASbGnctwMxECRCgaTuijLl9+HE96cXK6aVkgh2dFcx4AfnNuArMjrMQJcoBL7MjeCF+
	2k1o+MsDpJL1Lo6sNiV+xli7AaCAwFo6CXUcRcK7dWca6/2zMszpLf29fqHlIasEXrkLaM0YS1w
	d4ORhjoyM/u4u9rQR/sxRzhGJfFjuWN0tXYRpGiVHtJDArbtFS16jIWF6RSgNZEg7KGEIrxYcD2
	Fxdl+nvEm/XhOkTE9QN7UiTSIQxW8Kr27rovx6WsBs1pu5m4VUfJ14oD4vmCY4hmQCKnV7O5GCJ
	oaQ6WF0M69wGzfm3WN6lmJPQF2ZH6it2lWI=
X-Google-Smtp-Source: AGHT+IEFK5nse8en/rEKm5VRsPRbQoVZVVLB+qKDiwmuk3UGnC//ZUFKPqjV/MHS5FPH1cRqEOufkA==
X-Received: by 2002:a17:907:3e0c:b0:ad2:313f:f550 with SMTP id a640c23a62f3a-adb322fcd7dmr299487166b.29.1748607437145;
        Fri, 30 May 2025 05:17:17 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a320])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada5d82ccedsm318566966b.48.2025.05.30.05.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 05:17:16 -0700 (PDT)
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
Subject: [PATCH 2/5] io_uring/poll: introduce io_arm_apoll()
Date: Fri, 30 May 2025 13:18:20 +0100
Message-ID: <8abeb8e2328e923515c63e43a1942802efabb3b1.1748607147.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1748607147.git.asml.silence@gmail.com>
References: <cover.1748607147.git.asml.silence@gmail.com>
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
 io_uring/poll.c | 43 ++++++++++++++++++++++++++-----------------
 io_uring/poll.h |  1 +
 2 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 0526062e2f81..e323221317f7 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -669,33 +669,17 @@ static struct async_poll *io_req_alloc_apoll(struct io_kiocb *req,
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
@@ -712,6 +696,31 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	return IO_APOLL_OK;
 }
 
+int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
+{
+	const struct io_issue_def *def = &io_issue_defs[req->opcode];
+	__poll_t mask = POLLPRI | POLLERR | EPOLLET;
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
+		mask &= ~EPOLLIN;
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



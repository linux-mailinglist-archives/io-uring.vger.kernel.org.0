Return-Path: <io-uring+bounces-8314-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23A79AD6BBF
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 11:09:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57C11172DD2
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 09:09:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9709022DFE8;
	Thu, 12 Jun 2025 09:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ea0cyt2J"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E8822CBD8;
	Thu, 12 Jun 2025 09:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749719316; cv=none; b=WHCK4KHkqkAqnDsAyCCZ79n08/HiSvB7sjiHRDr68OnjDREp1Jb9IolYpaYRZmngQC3GUV4btmoQP13HpMQezIo0QKSHyXhJaJsa7JPzwUNTVEG2lCaSqLcBdw0SxaGuh/2UtBzh0pKAxOyySa1Fr1OOVdJMYUdudGBjB2jrBeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749719316; c=relaxed/simple;
	bh=2efenWFVRJ0EilBZaGipZU21tMPXsU85DniQxQSKJZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6Eqq1NqothKHGgq8bH8Qwb8PupAzLVhH1M7EKFj8QySvSI49CBgdCfrZlw+diwRxXoQtQwBh6fSIjZVlxZjJucycknkxmyJZreF0+au6XCW5fp4SzIWUgBfYutnC+SHRRrdKXZMUKrX2JkWOVGpE+9cdOWxDCgXKfqRw/pqMd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ea0cyt2J; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-607b59b447bso1312103a12.1;
        Thu, 12 Jun 2025 02:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749719312; x=1750324112; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ogbrohRyhOQkQnsNYMhiGAZZpnvN6u565D9/k0Fb8TU=;
        b=Ea0cyt2JTBg1tyxEJQUXjw0DEOb1Z0q9YPhDsrKccyrczNyC6ZizvaPszUAx9ew4yM
         SIrVc7UoSCdbfj7yS9Z7oBJIr+sSiBaG5FhdWkTTf441X+4iy9Mqf09aCBdE1cHh30cO
         qROQBwf1LyHusqYQ5C+P+hT7PTib46CVcT9GKH7PpBt4liGZX62t+nL3JRPxC7XYCKBG
         hGbIiyhbcf5BETXqEznwoy+x/7BkicWuNcQJfj8AyJG4wKMcPU4NgNl8ZkXYchW2pHyg
         vsfGeBBjBhP5O9LlGBZ5sFfroIO/l6zhgVuE8Qzt5Q5pt6AnNlCcMACi+g8iIVuII0fi
         Uk7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749719312; x=1750324112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ogbrohRyhOQkQnsNYMhiGAZZpnvN6u565D9/k0Fb8TU=;
        b=XT0/CYjsLuHufPy4Azb/w+TDSu3JHsp00Ri0q4g9wHsR+dE5YwRWZwVaHbZwTrMgvX
         EMTR/go2cf8iSu2m04m4lzY119evoz0QbOHDp5uGQVnD07Pi8FRcEGWgabK63WjoYB4L
         pVzSQgKKcqBbF4kSuXdM6qDIAQBjGAPi8cJB0Or52sjUy2FNtkt1VEvQ+adlAw8FPRmb
         gBZrjfwD0Y+xP8FMX2n5KIbA8XcPKZDdqohJg9AeLNvFt5P7WBvOqq2kC7AgrlVTfR7l
         seHqqIOMuovThW75X3ik9ZSnMBAxt/oHQfZQMxnlcAyteiMkaBdVQsAxoOWGwEdsFDsi
         rL7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUJah0LtUGXWRUxQXc/nHU827f0xsug0BF0DQE8rn21RO5gRHgWQdsm4mb9q+A/ZCIRUF/k7So=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpiA4PJLK/fOh6QrYbt41NZrT9OvswuLmdMFEvl7gJEw28ZpuZ
	QNQmkfZE2uZnE2Jpqi2APW6LmPWAl9vt3oSsw2u9Ko/4V3PdeCjGbdVRHOyv5g==
X-Gm-Gg: ASbGncv9bikySndGcAV2ajiW9rPWU51NJ5CEnrTfv+LMotxAQ+mSi4DyBSijlBpnVIb
	C7PtA3RWhxEbT7oiyIFBXToq1MP3HqWa9gr6DTDYVHkJgfh7SAA2xWSa2uG5uhvMGLc5eDDXSg9
	WEkKhLg3fb0poafJGKauAhVnD9j4ShOsjqcFzVZJbBKkHn0qnFgWBZSxZ49qClW3KKxuBNuEnZu
	HWQR37CL2eFnf7Hde21Gmh2PTk4ORnbiMS6+Lg8jUSQYOLtracjo3BJag/SB2GzaqX+ydz1j9Zb
	GrYWEIqyYuH+kPJMQR7MrDkbZczyOcw4RBGE8xcl0neE
X-Google-Smtp-Source: AGHT+IGjTFbXBw0rOE0rza5s7oXVSedRbTvRBmfprtVOXL0ZtIruYX7dfNcowqYnd+z1iFcVCl9YWA==
X-Received: by 2002:a17:907:3ea1:b0:ad5:61fb:265 with SMTP id a640c23a62f3a-adea9403389mr207765166b.47.1749719312196;
        Thu, 12 Jun 2025 02:08:32 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:be2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adeaded7592sm96883166b.155.2025.06.12.02.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 02:08:31 -0700 (PDT)
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
Subject: [PATCH v3 3/5] io_uring/cmd: allow multishot polled commands
Date: Thu, 12 Jun 2025 10:09:41 +0100
Message-ID: <7c6ff69e64cd3a43d820c6df7a1eb90f26d2f078.1749657325.git.asml.silence@gmail.com>
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

Some commands like timestamping in the next patch can make use of
multishot polling, i.e. REQ_F_APOLL_MULTISHOT. Add support for that,
which is condensed in a single helper called io_cmd_poll_multishot().

The user who wants to continue with a request in a multishot mode must
call the function, and only if it returns 0 the user is free to proceed.
Apart from normal terminal errors, it can also end up with -EIOCBQUEUED,
in which case the user must forward it to the core io_uring. It's
forbidden to use task work while the request is executing in a multishot
mode.

The API is not foolproof, hence it's not exported to modules nor exposed
in public headers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/uring_cmd.c | 23 +++++++++++++++++++++++
 io_uring/uring_cmd.h |  3 +++
 2 files changed, 26 insertions(+)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 9ad0ea5398c2..02cec6231831 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -12,6 +12,7 @@
 #include "alloc_cache.h"
 #include "rsrc.h"
 #include "uring_cmd.h"
+#include "poll.h"
 
 void io_cmd_cache_free(const void *entry)
 {
@@ -136,6 +137,9 @@ void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 
+	if (WARN_ON_ONCE(req->flags & REQ_F_APOLL_MULTISHOT))
+		return;
+
 	ioucmd->task_work_cb = task_work_cb;
 	req->io_task_work.func = io_uring_cmd_work;
 	__io_req_task_work_add(req, flags);
@@ -158,6 +162,9 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, u64 res2,
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 
+	if (WARN_ON_ONCE(req->flags & REQ_F_APOLL_MULTISHOT))
+		return;
+
 	io_uring_cmd_del_cancelable(ioucmd, issue_flags);
 
 	if (ret < 0)
@@ -305,3 +312,19 @@ void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
 
 	io_req_queue_iowq(req);
 }
+
+int io_cmd_poll_multishot(struct io_uring_cmd *cmd,
+			  unsigned int issue_flags, __poll_t mask)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
+	int ret;
+
+	if (likely(req->flags & REQ_F_APOLL_MULTISHOT))
+		return 0;
+
+	req->flags |= REQ_F_APOLL_MULTISHOT;
+	mask &= ~EPOLLONESHOT;
+
+	ret = io_arm_apoll(req, issue_flags, mask);
+	return ret == IO_APOLL_OK ? -EIOCBQUEUED : -ECANCELED;
+}
diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
index a6dad47afc6b..50a6ccb831df 100644
--- a/io_uring/uring_cmd.h
+++ b/io_uring/uring_cmd.h
@@ -18,3 +18,6 @@ bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
 				   struct io_uring_task *tctx, bool cancel_all);
 
 void io_cmd_cache_free(const void *entry);
+
+int io_cmd_poll_multishot(struct io_uring_cmd *cmd,
+			  unsigned int issue_flags, __poll_t mask);
-- 
2.49.0



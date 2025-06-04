Return-Path: <io-uring+bounces-8205-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67EE3ACDA1E
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 10:42:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 124B27A2FF2
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 08:40:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E8C128C5A5;
	Wed,  4 Jun 2025 08:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KbLVmyab"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7905B28C2CC;
	Wed,  4 Jun 2025 08:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749026492; cv=none; b=uqtAxrA8K+Aof50SfOpHUBjOTgWGcT6KanWUKt2JeSw2rYZJ5+szYpbqZzC8SkAZHYv90EkH6baUPneQFV9KA8pTNQxwfvQyoXrEfwESJ7jSxrKursHm2jAEOCDXhJKQdsEL+JGs1aHeARDGmLMJgH42rYp4nFk3ghbmnQVbCec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749026492; c=relaxed/simple;
	bh=wc16gYeHud5ehQHdyxvgptDx6V9FbTGG7jy/B9zR7pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RaiyPPc/vVsiR3FkspMP67vuTnGHXhze6vHefEmPXRz86sxc9kdhIebcOXxK6ybXUopzHjJt8ITyTOVVf3kIigY6xjXmMarAKUuK49+ezvaoLsEGNvwQOwklXCm87+rHpfQC0fyMl1TtmV9FUiAzrIpZf2ZJX595ClGzePcxAbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KbLVmyab; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6020ff8d51dso11536808a12.2;
        Wed, 04 Jun 2025 01:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749026488; x=1749631288; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OJHJsKl91cMnunI0MciHmEVOW2Y6PFhGuS8u170c4RE=;
        b=KbLVmyab+bxOzyhjeyo7ySc5aWoEri+Bn/e+1eLCFTCFDYtH7oD+tufv99O1+DiSee
         O+9TeK8335xJFaUOjFiOvgBgLao7TlEcQKBlMQi7Pzr29kAIPYImb116q0+X5ZKhXxmz
         p8eNKFgocQrTpGRoknZNixXNRbR3tt4P0R/Uzcb9CG6Y1uUIc3npUD1Vkbi8nho9CJEV
         ZSmevkf8z1FSJ4m/H0W8i5O9zftOWwB9AC/3LBTMPiZdI5DmmVv8AAtGqEQzNr0jsPUa
         Mku8idloiGeDJbz1LTcWldAzyWmVrSaeoWg/sFpLfnaSPYvY1ezDBsOPOBKwNnunN5E5
         fArQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749026488; x=1749631288;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OJHJsKl91cMnunI0MciHmEVOW2Y6PFhGuS8u170c4RE=;
        b=CJyPU7PsDRdW0CzvvUT/O3AwgiCCdMUbIkpP2PjMei4EZVN8hoVsjmlrsRqhmfGLJG
         RmW2F7f5SAXhzWOxQ+RSTt+V9guGpJQkiikK0XjwLOU5qAxgbLlDgKXrNOZZ5gk+t7z2
         nfwAdX4hv9DfpSLo+ECIAw4KWX6er9cqFGeOlujEXAIV28w1EHdeJQXNXM+WkLEzYeoK
         VYWrQxq92RiAOWwUcgZ02ziI1glxEVGcZLU4V3JwGdHiAWSEnxw/6gh4QBZedaZBLwuA
         pvjTOmLLRyLy19Ia1GTuenRiEiVlXD6S9GiAMP17C7GscHP407fR4BJEyPNyF4GSAHON
         k93w==
X-Forwarded-Encrypted: i=1; AJvYcCVUo9B2LmhTRFYSKaMinT8szHIfTKcJkTM5BinpfELlY19+HxSjH70D+TkzHdS69WddCyJSq6s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRKfoxfEUPeqDi0DkbTwcv8FIaful4GvEuHuL3vL6J4uobPg8Z
	s9h8/aedDw5kVhbEqRRHlqsY00cWPxW5zgleeBRi9nNPNIRSy5pX/59vkRet7Q==
X-Gm-Gg: ASbGncvU8YZf4H+LTLyWEZRzngwNUBbny+nLZCVrkHgjSuFjQYde+iDnECVhhuTFFvV
	r+fZz+Lz1NyYMpuMj46VZWRxTDKwp5Lrh0NO++r/ql2b98FRO8fXWiun5ttz4FPuaGM+iDfP2rc
	eJFRMLH7D7nRLTVA8jQMc1HaEzyBu13VCFku1F1J4iLe3d0eFoJq0Nfxk2HVdmzRPBsN3EOSOFs
	H1udGRMZ1/tyO6jV8yHS0noWKjr6QmpaQSVqFrOd4bhZ29/ti3h15JPOHs+cOQuSEx0311NgzGc
	I0uZcO36CaPbLZlsKkr+DYrbSLlo7vcmngo=
X-Google-Smtp-Source: AGHT+IHtY8aRf77bqQlpmpNUEydeqfcZtOHQWi2F1H5526FALyPp37IgBBtD7gun0aBUHndyf5YpHw==
X-Received: by 2002:a05:6402:2344:b0:606:cef8:a028 with SMTP id 4fb4d7f45d1cf-606ea3aff44mr1958392a12.22.1749026488110;
        Wed, 04 Jun 2025 01:41:28 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b3d1])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-606f3ace23bsm544261a12.12.2025.06.04.01.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 01:41:27 -0700 (PDT)
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
Subject: [PATCH v2 3/5] io_uring/cmd: allow multishot polled commands
Date: Wed,  4 Jun 2025 09:42:29 +0100
Message-ID: <38ccf137538760792007a98ab2690992e12eb664.1749026421.git.asml.silence@gmail.com>
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
index 929cad6ee326..2710521eec62 100644
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
@@ -310,3 +317,19 @@ void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
 
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
index e6a5142c890e..9565ca5d5cf2 100644
--- a/io_uring/uring_cmd.h
+++ b/io_uring/uring_cmd.h
@@ -17,3 +17,6 @@ bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
 				   struct io_uring_task *tctx, bool cancel_all);
 
 void io_cmd_cache_free(const void *entry);
+
+int io_cmd_poll_multishot(struct io_uring_cmd *cmd,
+			  unsigned int issue_flags, __poll_t mask);
-- 
2.49.0



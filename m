Return-Path: <io-uring+bounces-8337-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F0180AD9476
	for <lists+io-uring@lfdr.de>; Fri, 13 Jun 2025 20:31:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB1221BC2AA6
	for <lists+io-uring@lfdr.de>; Fri, 13 Jun 2025 18:32:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C7F522A1E1;
	Fri, 13 Jun 2025 18:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fCD06hGx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41900233715;
	Fri, 13 Jun 2025 18:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749839490; cv=none; b=Pld9Z0O4cc12WqELjUFMvO7sVSUJDgF+CrjmZzx9JqZZLODcEX+Zh3dQVmP/sfUkdRsHbLs8AdcS8vlOB/NtvifElcBKc3YEQ9dDKmO2jfeeE6hQtixPCtrYzPF69ii9FLRA3TSAyTBXsZ7iWZtDn2N/yo6uz33r6dHzhFSycUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749839490; c=relaxed/simple;
	bh=2efenWFVRJ0EilBZaGipZU21tMPXsU85DniQxQSKJZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rklcqCgw1daa60BbIOqtlb9fCcDlC8bBgWKaz5tQ9kz5prDRWZ1Hi7KUUDupeGPhdkkKi401tlVdDcdm4eYNNFyk+j02hCmI7pIlav/aTM0syRflG4KVxrjjmKHDIrAE1ibSiIb9Ql/oHMZqRbUH3AzaK7bv0GNlx+0lDaTti4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fCD06hGx; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ad574992fcaso376804866b.1;
        Fri, 13 Jun 2025 11:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749839486; x=1750444286; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ogbrohRyhOQkQnsNYMhiGAZZpnvN6u565D9/k0Fb8TU=;
        b=fCD06hGxjYHmD5TfvduJl+V5DZ0pnTrJrHLshEuntzIcBD/RahIz9XqigoDWGZe/09
         IwyDRSFXDJklMqlKjh/w0zKHL3zuBfGUhf9j5PKaWKhCsGL1Xsmr3Ub1L/b+jMJa20UB
         UAmU+5ZgLZBNFV1X+dRvsQVJt85YzxMtw5IeCjNe/85RajWnQjA1eIlQRlR1cg1nfOGn
         KoUIloYirgEmG5IuDa2jK05CL0MhM5uYpA8rYWNB3nHs/713XYsl1UqH835D5FWaE6RH
         rU0kIdnTMq9zz1MXwP4XzJnI/JlG2ltf0dw3aIbCtfwJ10GadrtpGK1jFHaoGHlJ/GcA
         yKkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749839486; x=1750444286;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ogbrohRyhOQkQnsNYMhiGAZZpnvN6u565D9/k0Fb8TU=;
        b=bi2Yn46PoS7qfMwMMBBnAh5CG7V+fyl9xRDUA0U08X5L0todjFSAF0ypcN7vfj2kqt
         bc0v3+7yw4h+pY4Zre51ANXSOnBkRxE1CFbJaHP1IvThUEHrZjPUZZvIveYHisGFcsjK
         +Mv334uaKi37bcExNxzyJShmMDvX7/D+941UpsqEWcbnojpskAPgtfgBJ5hHPnRv6my5
         3A4CBAJKTdVhODH7/Xjh3q5p6GP0vtst8xXxIN7Og2KXtwUmRY8w9rrJLe4aWY7oXnKo
         7yGyyFl0gOrnm73BMeM4LPi/gaQyYbl7xHIDK27pvXsLMRujEQPxMmVnBA1yzebmep0k
         7urA==
X-Forwarded-Encrypted: i=1; AJvYcCUpFnpRT6aXbO9HpLTAy+xn82ytV5eiBM0O4MkxOfOu7b6wo9BloZL0W1XWV+quRF4mZNu5q9Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7h0Wc1TtMZe2GJdsWItCmTwrZlFr9wvoupyka4SDS0Ruvh138
	YCubRJcDCcLXdU5s47D/C/tGGOqCF/3yMh/9+V7Ll3j4FH+2YOXmXuY56LV23Q==
X-Gm-Gg: ASbGnctdvnZtVG31NKRz2/77s2xpBrx8/dgxfhyzIH8lkJCkmhRJBbILI4/swuvwxNw
	Suj6HiHFGteqRpa6nfH7qEWnGXkbYzdgcGHxHmIXKPrTzbau4DmY9++lumFjBrcrKrEAA9OkhP4
	gZba0XJ8nmqcUKRxeFhx5wj/d11DsRnuehAzETN1tr9gRD2sqOym/u3wXMDlMk/54gAY3MqDIjr
	RgUFy/h2n/OkVMvXiVtTF9TSDVupu8MXvlt5LFxJRlH0i0lb4Mpde9fOIldPr/R/jzdgaosQ+Tw
	rxSsViXYTolsVSJbNGRmgjRTGkK+0qECtz3YuA6dEIPi5wItt8/DkfVKYM/MYIcn9rFAtirWvQ=
	=
X-Google-Smtp-Source: AGHT+IFgD4zgjQsrbp3vZfXy9cccy7I5aeO6UgYbX5f7+P7phZulZh76ItzmQlFg8q+qEeTWdoao4Q==
X-Received: by 2002:a17:907:3d88:b0:ade:2c48:1bb1 with SMTP id a640c23a62f3a-adfad4ebd30mr20580066b.53.1749839485893;
        Fri, 13 Jun 2025 11:31:25 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.48])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adf688970a1sm54772466b.175.2025.06.13.11.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 11:31:23 -0700 (PDT)
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
Subject: [PATCH v4 3/5] io_uring/cmd: allow multishot polled commands
Date: Fri, 13 Jun 2025 19:32:25 +0100
Message-ID: <87b2e7c4ae888ad877bf8153994bf9587e02d1c9.1749839083.git.asml.silence@gmail.com>
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



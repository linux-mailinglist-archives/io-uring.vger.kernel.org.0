Return-Path: <io-uring+bounces-8358-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8337FADAC3D
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 11:46:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A9B897A883A
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 09:44:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0043274672;
	Mon, 16 Jun 2025 09:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JgQLR6JK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D228926E153;
	Mon, 16 Jun 2025 09:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750067132; cv=none; b=KXw777fZaALpk2AuIvaOs5FOE/c6REYNWgNlSKyfgfFihYM90qOTETxkVzNbRHi5OEepW9JOuFMRzXwsKaFc3GNrX7+6slb4U6R/x7v9ucn7VB8mvu4ldytQ4YIoM5psSNk+HNp78q7jOuegSXUkYRv9gL9N8FO8Sc+VFhmGNKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750067132; c=relaxed/simple;
	bh=2efenWFVRJ0EilBZaGipZU21tMPXsU85DniQxQSKJZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=boDo3QQttemrdhB62JlxYnvZwSuZlT3pNEINVTq8ZJDee2br6OUpeIrogZtaVoPZQ8IB3UXV178JQLi/wVoIFymd8+XSnyC64b25gx+1owrD7NDToLfSJQ+YrD82zubdN67Kpt3+Jc4urCWnUY8vWmx1AbxjGg0zNwCRlFf+Fig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JgQLR6JK; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ad8a6c202ffso787853466b.3;
        Mon, 16 Jun 2025 02:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750067129; x=1750671929; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ogbrohRyhOQkQnsNYMhiGAZZpnvN6u565D9/k0Fb8TU=;
        b=JgQLR6JKlBypmLZ30B4dT9hGNKc8rCx5QGOxMQOkUyubhHNL0ZWQgkkRtKsgbgFX0C
         SnPLF/KlGcxL9OZUO2DpyUU+xvzbPqpl2kyXeLO4ihNs/TtjAmUaoML434EsHXZJIznt
         lzCJlJ7AS+Bcbid7NtR2zoIzRvV1mBlaAm6B+W1AKPDbporXqCtFTs2K3rMP+BwZRkR/
         ApdK+M8wz4+3bDKmwiBbXyB/ADKwq/0upTp27lSNr0Ey0UNOFNHsibo52YcbUNj+eTPm
         eywOMINLqES9m0qLPSkQJKPOczEfCj5Jb7kX9fXomUJay7o/cAeQu7FonCG/BxoRqC5s
         wFFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750067129; x=1750671929;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ogbrohRyhOQkQnsNYMhiGAZZpnvN6u565D9/k0Fb8TU=;
        b=cVO1rAcyoD34pM20hd53/0bO9ZoyvE4dhnt+Tzt7JOVB8sVJX/1Pl6h+NpXGz0tSlv
         xl38l0INaJm16mxvO/5pIG9HdwwbILtMmAJ1gwsf9HF1mP+K/jJ75cIWA5fMqngqvlcg
         M8ndkwflmFLNGsoInfmiWI69LGSfECqEZwngVgOgYyOQ8kTNIJeM3qGOkBruQfUuYNGe
         PhB7bWkiAoC+s1cU34Q6oR1YDthHi1rXTNw0b3eKGz//jHsPKGGxwG1bvTg+EuELV30h
         7BpxNZXByE+qNcigFxQjBTq88klutXh2e+8hsQlmckH1p++WmMvz3w45d1QsOAVTZmVk
         YnuQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLtx3ShmZJnUWvY19J5fblVY+mah5pFS2odSUxghT9UxMBFH1sYS6yiONO3npPtFu7Y6jQzlU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx97PilbsyKU4qwx3+Mnix5YY4MJj9PNqdM2l36tSUEWNmd0mES
	CeGpDhQ0cLHNKt+eYnQ1vxTV5X+kRXVvNjiwTlfgQZ4gijtcB9+y+wswscAy6Q==
X-Gm-Gg: ASbGncuptT/EA6x6sNQmgRn4Gl6jWUXA7l5m1kWMutRM9cg/qvI+ZIzYxKmQsgGgsDF
	k29vT5mRyUbKZMTJmMSY2ZBXobdNELelxqTqQjDQCCsdVjA6ToO0qHoPpux4v334VOFmoF2nT4p
	BwQdH2M/AAWA60619/A2/k9DcVO+bCJRZIAuIkRcXARW46IaUPIHtn/xtnBVkBep+EQ8CDvPI09
	8Eq9HEJO3GxZgzY1ZzoaKL+I2wIyfHJsjDUguwUTJRCD/g9a/vWR6323WAlNOTv1XiG22ooAXjd
	JFAsSozDPktzsMjIToAkYevw3d8/4BzZvPCJuKNJc8Na534Qotzg41Oa
X-Google-Smtp-Source: AGHT+IH55t+IfswXmuF7yutu5ot1GzAPVWWYpzodjZN054UuM/1/mHxMqO8LCUOIR+qyWoVHh7iI4g==
X-Received: by 2002:a17:907:3ea2:b0:ade:355e:d655 with SMTP id a640c23a62f3a-adfad43d903mr825682966b.41.1750067128342;
        Mon, 16 Jun 2025 02:45:28 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a3c1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adec8159393sm629363266b.15.2025.06.16.02.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 02:45:27 -0700 (PDT)
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
Subject: [PATCH v5 3/5] io_uring/cmd: allow multishot polled commands
Date: Mon, 16 Jun 2025 10:46:27 +0100
Message-ID: <bcf97c31659662c72b69fc8fcdf2a88cfc16e430.1750065793.git.asml.silence@gmail.com>
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



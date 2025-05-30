Return-Path: <io-uring+bounces-8137-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ED06FAC8D72
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 14:17:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 082CE1BA46D0
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 12:17:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0447D22CBD0;
	Fri, 30 May 2025 12:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sc9rbX8A"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3120D22C339;
	Fri, 30 May 2025 12:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748607443; cv=none; b=VcvOz4hWZ4KfjlupIFn4Ucw3r6RlOIMTeK1eIuChZsTjQJ/ij7iKTWpgs5zsALv3+lBkMkQNzVoJfoUKhM3xOpxcgvb0Nr5i6I+7L0WiyK4HfZ11sduduBaNhO9r2bei8HvAgPCiXtSjS8px0YkRHJLI16tg+N0rWrx3aVD1ySc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748607443; c=relaxed/simple;
	bh=wc16gYeHud5ehQHdyxvgptDx6V9FbTGG7jy/B9zR7pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HB5mK6tJ9MVOeFY/k5BwphFT3qj1piIDXcsN4q/B5D0KKAhFA+MvLEQzhz/TMzN/uOvprfSbes7nF5ZPMW9tY9Gpz/lmTsTtK4Yb3XZPG05BiSO0HP+wD25O6Fo9Mcn4AmwNr86JZYlG+Kv1/cxtkcEMb5HsKbzlu9IeTnzmIAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sc9rbX8A; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ad89d8a270fso638437666b.1;
        Fri, 30 May 2025 05:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748607439; x=1749212239; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OJHJsKl91cMnunI0MciHmEVOW2Y6PFhGuS8u170c4RE=;
        b=Sc9rbX8Akzy14zgTqWG3vb0exKcTVSY8g+Aj/1FxdpoBuUnQhS3TZPZqhOa+5ZmYPI
         vXW/Is56b7aXiC4lom+tXj+PzmPTPMEld5RAFChcVsz7JYBAzhhwJinQvpKeLuzRM/F/
         KAqBIeiM7O/iBuYOegbjEcm7jYvRBk7aI/KP+4KWHzov9Zh5ygNlhOEfxETzhA+SZrAz
         oxeuNdanYDVYhcP54lu8gdWK6LK/qGn9dhZllQu83cwyBJWwDf8+qndGf0s1fhfoqg3P
         sOOnf+oEP6WOinZn2Ejsx2nDBlwBq2poFKeby5K2k9a569591oQxXI0c2I1mG79DuHfs
         hmIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748607439; x=1749212239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OJHJsKl91cMnunI0MciHmEVOW2Y6PFhGuS8u170c4RE=;
        b=tJYpKIJDpsqrJ47waEl+zOBPD1AdMGA4AgCTOIXfC2GGpKVZXD2xYYxAv/xJPkkKll
         NneD4Z1bG847O5qafq+Oc341hfr41tnq9HAAP3fg5zlArn9Gf12YJKRfSH/09/7HymlG
         N/0yNm0khU8Yvnn1NzBzi54VbYSrRlWeVPCl8BbIUMirvA12Lh2Y6gAowYovAtn2ya03
         ZBn97zUAS0RrMTc7zj7uER1LM4E+gVO8VMc+f+nnSc4fs7MH/Nf9ebWmnOX2ClCC2NyB
         A9Q2GQ0ftaPHDqys8PDcFwU14zbVr/qfmlWwQGBdLQDsFxUfDY8ZI4C+DXWm777oA0Mi
         E6EQ==
X-Forwarded-Encrypted: i=1; AJvYcCVi5+EKokifbkaNg3DAp5segqmBtEMdUw8W2LhF/591vFnLqQamxkr3ET7l+8PHtA4P1+pNfMc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwArroKIRdkDwb/uubpGkXQxAsuovZPUkjr2Hir4g5WL+JNexxG
	Nw0I5CjGH2ZOzP/SG0Bi9FrG3DAFPsl39NcwrwYPhtbPHcRcjoPKOzwb+lkGZw==
X-Gm-Gg: ASbGnctNd7+DjqotQ5uFrHkEbkfs5FYllE3iJIeyY9MseLMv37U05MG//dM8LzKk/07
	OvzGWJD7Tf7odeJ7gN48MgD3USa8xDEIU43n9y6+CoWysaLrCU4vjVfFhH3cyIygprQ7dr4yEI9
	scmTNwWU53hNuyKZL9UWZqXSk2eT8ooAXlnlGI3vESXbFP2+wa0Njau99f722n0gpmHZZxlc/Wx
	yFiRoJP+5z3ow7ykyaMeuEle8ICa7Gw6G9JuHSdaiZC9739WJY6PGciTwpenomsKWQp9P8QLl4i
	lYEZ7TVnX9gyQOcwT21/xTIfduGEIQCr5oI=
X-Google-Smtp-Source: AGHT+IH6MtGlixO0sJHDushM9LxQRENnia07QHVkN3KAH8P5BCDP1WI9yP1JiVYyGAypJnVAT3fbrw==
X-Received: by 2002:a17:906:f58e:b0:ad8:6dc0:6a8a with SMTP id a640c23a62f3a-adb328ecd7fmr282114266b.1.1748607438758;
        Fri, 30 May 2025 05:17:18 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a320])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada5d82ccedsm318566966b.48.2025.05.30.05.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 05:17:17 -0700 (PDT)
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
Subject: [PATCH 3/5] io_uring/cmd: allow multishot polled commands
Date: Fri, 30 May 2025 13:18:21 +0100
Message-ID: <e61f29ecdfac2a0f42a45971a3ab586710084d97.1748607147.git.asml.silence@gmail.com>
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



Return-Path: <io-uring+bounces-6539-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C531A3AEF6
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 02:32:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4AB1D188F5FD
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 01:32:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 570003597C;
	Wed, 19 Feb 2025 01:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KzXAnWl6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A03224D6
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 01:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739928768; cv=none; b=G+1vL7/JtVqUyN4z2YkN/uGHz/WBe13ZyCQ9Aex9/AuOhquFaSU9WKtQ2g1O2SQWQsFTSG+Ht0y/eupCOuPCNkvGs8b4mXKWO4UT1wbJDWkQiaDx9ZKEBdbLC6pQac59hf5w/llZe4qjBSqidV1rkIGG6PJRXUvwqikjrlvAAiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739928768; c=relaxed/simple;
	bh=2HZPlwIOr5lP+y3yVWdqbLFGd6GCYaroT3B/n69ZsT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXw6IoulmX30Ohvh9Q0uK49MhlrVZniMo+rjakfX+hmK3Q5PC5kOBIDJ71+btUeFn97E9J2uD3xT9byi1jD8xNSsayTEcLG8oyp6kbjJ2nLWucHpwPWMv8Xqf8LcWhpCZkhik/HUXmjB4ny+voQ3vOuw/kzdMqgXmoiEdTRQ10I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KzXAnWl6; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4398e3dfc66so20266825e9.0
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 17:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739928764; x=1740533564; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G+t+NWqbKOo9YrztKAGVW57efrtLobYJWlG1VL1cnpA=;
        b=KzXAnWl6+tuUO73Y6LJpd387grG8zCSFPPsmUmzfR12KMNUmSnbdH5TE3NdjoKcdbj
         QNBUrGz5OfRFwdAMnjei9VoEkl+5uqeVSdG2IkNaw/K+NUB6SN76o+tHSenQPlnz/snl
         k8p7FxPx78XRSG2m8GBYTqspemmbGXlyuag8vyfFiIRsHnWoaKeyJJTrFodV2VqawKwC
         E5km4uvtGyWHIOPJrPvfaKZ4Fh/WmoqRyF1BA20Gj3hyoCzmv27l3nJ5b9cJVoYGRPYU
         2nfVwapv/XYXM1rtOUwzuHCMYOhA4aiqrK8A+/f58dj0RY23vpoCgVtsIyyfqBBcZCbb
         QUtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739928764; x=1740533564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G+t+NWqbKOo9YrztKAGVW57efrtLobYJWlG1VL1cnpA=;
        b=iefZhiRz8zl0eNGrNZF9MTOfOB0rCrQbNhb96xipBAwqcD0dJGXV+HybOSHdesLlbo
         plzfCX1nyQ/5+uqKjhTEOf/cVw2oz5rgbsX9pOQjl+M3bL0puLP2JsFAzmfh8D+Suu9Y
         Z3fTKtw/x155/ZwRLEjkM638f2R8SHhGxTyzLLa/x6B6cWwp/4nIVXwlP8ii17QlKwdj
         0MryyDmMYXYGeVJd6nT+NPrUZXaibnBjQ7Lv4xIIquABubW17CHDpiWPpcLjq0w8s4tX
         FQl6rWDap7CDnnh5rQkCgCfbnJbWOZTaoTuzL2yaT/jyP99yOx9P3N5lsDg689HiehYj
         QwnQ==
X-Gm-Message-State: AOJu0Yysx3JmsRu6JIOIOkwq4M9Nd/QlC5dlzSQy/nteiMhY3n9sfBrl
	eR1uTJiO1ICEAcVEt44D2ReOH+2jGciYlw+8keLDlgsIrEde33HrUPbyqw==
X-Gm-Gg: ASbGncto0zUYtHOyO484N+3e1P+VdSWn2A55dwmZF6AuSa2oAdgnMoJfjyWlnfMURDp
	JyuTjqTjs1p+BPHdxIQSLwoLFbAOJ/TsBpNAkOIj3l+OVJGlTKVXJyPl6nz7hcEq1bJmmCQm+ms
	tG/JjJ0zkjJz3X5+bCG9hNtYSp78Bs9NcCxLQLG9zO820cUmCq/6TS0W/ZqumLWe97HRW5fF3hR
	Gd9WxWjytuP3t/qE4PzHqex4ilfmFAIjnp9e11fnBw0//tqNh/hxPSxjf1Xt2ak+6PYjo1gm1rQ
	SFxK66tifMixt6jWkZF1X9DbYDh9
X-Google-Smtp-Source: AGHT+IGhZ2hh4LwYBXvqsIf/+oujwc59lbyx6QOzA3QEMu9JR3QlEEIJDFsgmvctuStd1+8BSUvfng==
X-Received: by 2002:a05:6000:178c:b0:38f:2173:b7b7 with SMTP id ffacd0b85a97d-38f5878ca87mr1453716f8f.18.1739928764403;
        Tue, 18 Feb 2025 17:32:44 -0800 (PST)
Received: from 127.0.0.1localhost ([185.69.145.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259d8f1csm16617752f8f.69.2025.02.18.17.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 17:32:42 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	chase xd <sl1589472800@gmail.com>
Subject: [PATCH v2 1/4] io_uring/rw: forbid multishot async reads
Date: Wed, 19 Feb 2025 01:33:37 +0000
Message-ID: <7d51732c125159d17db4fe16f51ec41b936973f8.1739919038.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1739919038.git.asml.silence@gmail.com>
References: <cover.1739919038.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

At the moment we can't sanely handle queuing an async request from a
multishot context, so disable them. It shouldn't matter as pollable
files / socekts don't normally do async.

Patching it in __io_read() is not the cleanest way, but it's simpler
than other options, so let's fix it there and clean up on top.

Cc: stable@vger.kernel.org
Reported-by: chase xd <sl1589472800@gmail.com>
Fixes: fc68fcda04910 ("io_uring/rw: add support for IORING_OP_READ_MULTISHOT")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 7aa1e4c9f64a..e8efd97fdee5 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -880,7 +880,15 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(ret))
 		return ret;
 
-	ret = io_iter_do_read(rw, &io->iter);
+	if (unlikely(req->opcode == IORING_OP_READ_MULTISHOT)) {
+		void *cb_copy = rw->kiocb.ki_complete;
+
+		rw->kiocb.ki_complete = NULL;
+		ret = io_iter_do_read(rw, &io->iter);
+		rw->kiocb.ki_complete = cb_copy;
+	} else {
+		ret = io_iter_do_read(rw, &io->iter);
+	}
 
 	/*
 	 * Some file systems like to return -EOPNOTSUPP for an IOCB_NOWAIT
@@ -904,7 +912,8 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	} else if (ret == -EIOCBQUEUED) {
 		return IOU_ISSUE_SKIP_COMPLETE;
 	} else if (ret == req->cqe.res || ret <= 0 || !force_nonblock ||
-		   (req->flags & REQ_F_NOWAIT) || !need_complete_io(req)) {
+		   (req->flags & REQ_F_NOWAIT) || !need_complete_io(req) ||
+		   (issue_flags & IO_URING_F_MULTISHOT)) {
 		/* read all, failed, already did sync or don't want to retry */
 		goto done;
 	}
-- 
2.48.1



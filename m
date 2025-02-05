Return-Path: <io-uring+bounces-6278-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9D7FA29B25
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 21:26:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 653A91663EF
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 20:26:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7B63212D66;
	Wed,  5 Feb 2025 20:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ODqt8Yks"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24B5846F
	for <io-uring@vger.kernel.org>; Wed,  5 Feb 2025 20:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738787209; cv=none; b=tbRTbApJMf8vJ87nf9X3B60uYJgW8jHS5VovSj1ZlkyPzCsBjaurSLejupu5Vv7iLH2DLy7BqGE4gPIedBvzmPCaNn/bStBdMbf/5ZG3eLNIfbPpCd9GIz+dvsDYqtyqoXmJET2AU/VVZeAq1aur7imEiwOVeZ5G1kA2AUsSBDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738787209; c=relaxed/simple;
	bh=XbXrFPR4SUQbYJLt5pV6inp6Pk3BI743HQarBjRbC7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+M5ZxkjumTbW4I/9PfhOqfnk24EtomWu3hvjBFbcJPEsTDkMiZkb4dbUS1WnghbdgWOCL6OAkFGv0wJRcVp2XNyUj4Zv6DgDJqjNicBR9YBY4AYkpzxS0Yg5RNzJXnmKvOAaJycLvobcUmQJt0WwbQS8yX5XbVrnAXFQX/I8kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ODqt8Yks; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-844e61f3902so17218339f.0
        for <io-uring@vger.kernel.org>; Wed, 05 Feb 2025 12:26:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738787205; x=1739392005; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FWpQv0/6LvA/sNw8SE72PAuyQcKgPaKQsYMrFISK8xE=;
        b=ODqt8YksvuZGX92P4QuiA7K/u8a/8PFVQCDKLs8/dJHP0pKaCNPZMsEgQDe2Ek86qB
         rhbfZKUseQaFKxidgYyoZK0JDD7drL1KvZn5BnTClkuWWKNvrIRQwim8K2eakY3UCtPV
         MgrXhlL4qmPqXiBf/2rLj9kZKcxGL3wiwT8T2ot0if4WlDvxinMtIqjfAf3i/7kIagtG
         jp2KX/ePWZaqgi3RlTiEyjydryhQE/RgITaXBDb6wlfE9GY6yVIHeB0xzUX2xkm63WgP
         Dj3ZAAn3pCA9jgkppPyHtyulk0HMhBzFMZX6atf+OwkZvfl7QroGP9r9PtyYB/npvT4v
         1bvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738787205; x=1739392005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FWpQv0/6LvA/sNw8SE72PAuyQcKgPaKQsYMrFISK8xE=;
        b=Wd02kNYfd7zTHastREq98ShWK+1cm5PsR5Z0TdIH8pDxJ8z2kDtJipTtsNJ0w7Q5Kg
         r9FCahO3U2UQkrF3NFqkmcHQtWTQ2p9saM32pemqE3dYILM+yEisItRTEUv74VAiMuSk
         Pe0fbg8k7Lgd+Q6gF+KEhG6/cACMk87LwOdkQptlLVze8qLzYePfp8fVZd3W/5xJQVL5
         ERVU4OaY/daQZC+PGidqaSzHk3+QIV5Clq89q02EimVbzmR86LY+BXzJewN6n/4FIlp+
         wdNPfibD0v41T5zParDV0uQT5RoWJrpRXoEPSx2WWYFukd2x6idRsiFPNvG1rPj0rbcB
         OyNg==
X-Gm-Message-State: AOJu0YxytmyAEV73sP2B1d+z6kyMHPyn84byc0JfztkwpVJMcPW8dKHH
	8xGHp+oHqnLIr9TYeoVFYGum2DLLStphPbekedTKlPEKrzMoWdJEJcWqh7USNTRUjN/nxXc6Czs
	5
X-Gm-Gg: ASbGncv9C93SWFi43qNTf0ns1on8QsrIsnuJ1CfW7WyaDfUi9skOQQigiU9txrv5Ual
	Hkediuy3h3bBxgb7P19eOEMG9bovnsX/3W+nXuIpZdIDrOvEbLXx+Hgn67m6Hv0ulDRMyVJRwZ6
	2yqZ5rBjW67D9QBCWqE8n56kMhXnEnJE9Taxp9Lg4FQQ6uTN24bBPTBnvkvhhAdzAcH46mWQiH8
	iCvSct1k/gRCpZZYgMrzEVhTJkYF1OLfZqXzLWe4VpLpynwWN6WziaghBi1p9d94BOLXI2ZaumK
	iVEHzRUchQhjalyrnsE=
X-Google-Smtp-Source: AGHT+IGIgUHJY4O5eNa61WbrZN9BXML6Eb2GzoqwH42eWQ3au231qq+NCqwQpqyddDMqtAqPVEBAyw==
X-Received: by 2002:a05:6602:3810:b0:84f:41d9:9932 with SMTP id ca18e2360f4ac-854ea514f79mr454306239f.9.1738787205124;
        Wed, 05 Feb 2025 12:26:45 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec7458ed51sm3352071173.23.2025.02.05.12.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 12:26:43 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/6] io_uring/cancel: add generic remove_all helper
Date: Wed,  5 Feb 2025 13:26:08 -0700
Message-ID: <20250205202641.646812-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250205202641.646812-1-axboe@kernel.dk>
References: <20250205202641.646812-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Any opcode that is cancelable ends up defining its own remove all
helper, which iterates the pending list and cancels matches. Add a
generic helper for it, which can be used by them.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/cancel.c | 20 ++++++++++++++++++++
 io_uring/cancel.h |  4 ++++
 2 files changed, 24 insertions(+)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 484193567839..0565dc0d7611 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -341,3 +341,23 @@ int io_sync_cancel(struct io_ring_ctx *ctx, void __user *arg)
 		fput(file);
 	return ret;
 }
+
+bool io_cancel_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
+			  struct hlist_head *list, bool cancel_all,
+			  bool (*cancel)(struct io_kiocb *))
+{
+	struct hlist_node *tmp;
+	struct io_kiocb *req;
+	bool found = false;
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	hlist_for_each_entry_safe(req, tmp, list, hash_node) {
+		if (!io_match_task_safe(req, tctx, cancel_all))
+			continue;
+		if (cancel(req))
+			found = true;
+	}
+
+	return found;
+}
diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index bbfea2cd00ea..80734a0a2b26 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -24,6 +24,10 @@ int io_try_cancel(struct io_uring_task *tctx, struct io_cancel_data *cd,
 int io_sync_cancel(struct io_ring_ctx *ctx, void __user *arg);
 bool io_cancel_req_match(struct io_kiocb *req, struct io_cancel_data *cd);
 
+bool io_cancel_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
+			  struct hlist_head *list, bool cancel_all,
+			  bool (*cancel)(struct io_kiocb *));
+
 static inline bool io_cancel_match_sequence(struct io_kiocb *req, int sequence)
 {
 	if (req->cancel_seq_set && sequence == req->work.cancel_seq)
-- 
2.47.2



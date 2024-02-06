Return-Path: <io-uring+bounces-538-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 24AFE84BAD2
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 17:24:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F0151F247C3
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 16:24:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7575C12E1ED;
	Tue,  6 Feb 2024 16:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FjAFoiP8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8301350CA
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 16:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707236659; cv=none; b=o9aA/4Qh0rpftUY9XlSDxApwNQ+Fg3ggEnvANCeQLeiOKnTPdXoXUGuEL/cac3OO6nfscHDe8D/GTir0UIaX1vZfzalphxbqox44bt7NoHRC7GnAsQeswyq+2f4gjywXMI+SzQHs6pF7MVtOiIBbXVVZWnZU/Db55l9iQnMh03g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707236659; c=relaxed/simple;
	bh=uimgy7+wl4DXZV7rrq9F0Z4HxdrzWqdEH39e6n8xHJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3MeHqHbiNZAv0L+HfWz7CnO9coiIJebT623/9JNRDfIl001c7ufEVd+nKeIjKHuGFRdPSwBX9iwEFE/lBoDJnDxye8iFTJQ60UtNtXvAUNMwqdg41Veu5dxUo1ticfAkYRwAHsewuJdfO4sZn8YjKDuWuTxmzR0ObbE+ogshlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FjAFoiP8; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7c3e06c8608so30170839f.1
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 08:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707236656; x=1707841456; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GXvepwDyq3Lcyc7QSbbVA75c61s/YgsZV8j5neg7n9s=;
        b=FjAFoiP8twD1A5ZMnsWsLzV6UToqBxW/TT2GedmFQwas6HpeieA6urF/UhFutGzZ8M
         JMVxOoW40WGD7wDxYb91COp9VwO2X8BFQcVHuDIlbsyRNMsl0fIpD7FMfLbv7nqWGRLq
         OmBX9ZFHcA6y85wa+3D7NvAt3R5sy9bjjZDsivhFE39tAvOd1wzKtaddsXnc8b4YCA8M
         nLoXTeLCHn37JhutXxPAGYU/2Xpdr6pXOgjNdMa0T0XbrwcrWqmt/1G7r/DRDjmCs1uM
         Y94ionfsf0nXtm5WC+k0dpx8kix0x5C/mX8KlxTnz9h9z4ViTwgrhmdRV7ZwFgD6U01r
         4oQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707236656; x=1707841456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GXvepwDyq3Lcyc7QSbbVA75c61s/YgsZV8j5neg7n9s=;
        b=sVZMZjtk0rDoP220SlSbMuKm3rlUuZPVYi13qtNrbEDoNfx8hqJUk7zRD4Wq6Q7bEu
         U1z0jAknmq3sq8cREIZfOiWA7vWG/nCjyUkfQoQZv1DVU+KGVAJmySaaGcQ49FD71et9
         jncXzLbSFRnYnJiFgLe8/10LvezXh3XUCwM2rJ0TtQu44ghSQIrH5l3M3v/q0MSV+Z7d
         3r7RhX/rA5SmX/dE+EW6ofieEcDUeyTWbccpFW2IvDxCqdMD5r0zYmqmhak29m4+sAbg
         /4a6gpOK1KPE8lDDalVMNGqy3qSBWD588M3pGr5a617Inmnp7gMT6aQoxtpSEO3LuyZt
         oJsg==
X-Gm-Message-State: AOJu0YyKxmMfRvYs1EgY+vm34IBQ1jfGfPwEwx9eOS1fBM9Abg46zH6R
	0hTeKCfjimO+/p/UTK4sJE320LOO+t/95nk6yuqFmzCDh/LFYYQgA85TGAN5Do6LpnsAvRRRY1K
	Ck6M=
X-Google-Smtp-Source: AGHT+IGfyR1EGiCOCn4A4iJrH7iAFLHvkxW6yM6ldJ47QFsm+vV1eopVDAwGfXekMBIqPNyzEUW89Q==
X-Received: by 2002:a6b:db13:0:b0:7c3:edbb:1816 with SMTP id t19-20020a6bdb13000000b007c3edbb1816mr2781257ioc.2.1707236656666;
        Tue, 06 Feb 2024 08:24:16 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v17-20020a6b5b11000000b007bfe5fb5e0dsm520031ioh.51.2024.02.06.08.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 08:24:14 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/6] io_uring: mark the need to lock/unlock the ring as unlikely
Date: Tue,  6 Feb 2024 09:22:51 -0700
Message-ID: <20240206162402.643507-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240206162402.643507-1-axboe@kernel.dk>
References: <20240206162402.643507-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Any of the fast paths will already have this locked, this helper only
exists to deal with io-wq invoking request issue where we do not have
the ctx->uring_lock held already. This means that any common or fast
path will already have this locked, mark it as such.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 2952551fe345..46795ee462df 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -208,7 +208,7 @@ static inline void io_ring_submit_unlock(struct io_ring_ctx *ctx,
 					 unsigned issue_flags)
 {
 	lockdep_assert_held(&ctx->uring_lock);
-	if (issue_flags & IO_URING_F_UNLOCKED)
+	if (unlikely(issue_flags & IO_URING_F_UNLOCKED))
 		mutex_unlock(&ctx->uring_lock);
 }
 
@@ -221,7 +221,7 @@ static inline void io_ring_submit_lock(struct io_ring_ctx *ctx,
 	 * The only exception is when we've detached the request and issue it
 	 * from an async worker thread, grab the lock for that case.
 	 */
-	if (issue_flags & IO_URING_F_UNLOCKED)
+	if (unlikely(issue_flags & IO_URING_F_UNLOCKED))
 		mutex_lock(&ctx->uring_lock);
 	lockdep_assert_held(&ctx->uring_lock);
 }
-- 
2.43.0



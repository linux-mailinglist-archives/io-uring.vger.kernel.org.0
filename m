Return-Path: <io-uring+bounces-578-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 292EE84CFA6
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 18:19:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCFDE1F223DB
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 17:19:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C58DC823C1;
	Wed,  7 Feb 2024 17:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tHW0/q54"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D113823D2
	for <io-uring@vger.kernel.org>; Wed,  7 Feb 2024 17:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707326391; cv=none; b=O5rpZ6HigZkKKntR+Rtl57etLp6RLhQdQ23EtF8r2Mfmz8haEpl5zusb5RXj4Bt7D987KM1xwJrMx0RTGmIb8x0ujHv7h8uLJzGz0b7ESTIVDSqM02uWOm0zVJEOLguZFjMEfmXtCKCf9rE7sAHOPr6EpjMYmda+47RHOPUkINQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707326391; c=relaxed/simple;
	bh=uimgy7+wl4DXZV7rrq9F0Z4HxdrzWqdEH39e6n8xHJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZbfbPd+jzXOt6Pfsx+gSa0N7oK8svxzfek2f5hZosClW1BBVNJUJLsfnRIKKrQO4n7uup6wee6bDiJHBeCAQJA2UyvB//eZ9D+GBMEJ7FjqrIg2uqBhzVf8XBq54MWxlhobQQ3NNBGfIEj/z8HXtPDD2KSZRyeuT6BR7LzYKFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tHW0/q54; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-363d6b409b1so1231275ab.1
        for <io-uring@vger.kernel.org>; Wed, 07 Feb 2024 09:19:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707326389; x=1707931189; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GXvepwDyq3Lcyc7QSbbVA75c61s/YgsZV8j5neg7n9s=;
        b=tHW0/q54iQpQjTXx0ItGG4KCQHn3P84p2vhXICxTq2OGmzHdlumR0vPrDOZLdZXsgI
         sCRNhIp09+nTjZh4c1nbnU7bI9Zyc6FO+Ecw9IERvapE9hwOAES2VyuxKQluPJ83TTYa
         pysQLfVH5sN2Sj3mqIAppzU4QDAVb7NPXqfd0T1WVqzImV2eF84U74qRu//fP0jOpMDB
         BA2tLSRB5thcut/hcuziRYTkBQQTh8i0OxhL/BQqdHMrQ5kHe195q949kSNvA+EqSYMY
         dGVoxfNBCur9TpSIIfQ3tzlyLdpEM9lzdCHJ+2u0qZlE6/pORinb8ywiKaLLkCXZts7U
         XGww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707326389; x=1707931189;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GXvepwDyq3Lcyc7QSbbVA75c61s/YgsZV8j5neg7n9s=;
        b=hSIiXR7PgqXjmhB/bf07K996bQoUQunPkLTKnRDTZsv64l8awTSJplKoLBpkqEK6Oo
         ZqaOPlI3TukoUFK5veWCgg5hH/Ks3Ck6NoDXNbIn+Bok4GaED+vBoSGrdXiefIGRbXxv
         tlp6kEsZ/57Fe1s15n77mE9vssuwuFtA5Gv0MRbXM7bMCpReY6N0hAa0MkdIq38U9Fzv
         GFFWf5ZEjQG/1qwB9bTGBE7Eo3xdfwA8REDbc/L1SFH2eGLjSz+la22QfVORV88ACCy3
         XO8rliVSLULuugZ7OUUXPsZ4XHKZZVRfC9pZbboQI0ZwXYbenx8J7zUVx1V9tCHsVx4z
         qAEA==
X-Gm-Message-State: AOJu0YyH2pqeC4vC1+4p7GBSBm3wYw34+tJArV/qISPtKVJtEzVHFny1
	euEXDAGXqKd4AbiM+q8NlOfqx9AqAGNhX/PAlhtUPOIDMFtK3OyhorwKsfLuFqS6PqmFAd175aW
	RRFY=
X-Google-Smtp-Source: AGHT+IH4AuyVfppAQj4Nn8Obhg0o86xsDq7rycKP7iq4TKvotoQ3bEum136qrgjMjMpi14R8HYwF8w==
X-Received: by 2002:a5d:938a:0:b0:7c3:f631:a18f with SMTP id c10-20020a5d938a000000b007c3f631a18fmr4803455iol.1.1707326388954;
        Wed, 07 Feb 2024 09:19:48 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id g22-20020a6b7616000000b007bc4622d199sm421131iom.22.2024.02.07.09.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Feb 2024 09:19:47 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] io_uring: mark the need to lock/unlock the ring as unlikely
Date: Wed,  7 Feb 2024 10:17:38 -0700
Message-ID: <20240207171941.1091453-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240207171941.1091453-1-axboe@kernel.dk>
References: <20240207171941.1091453-1-axboe@kernel.dk>
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



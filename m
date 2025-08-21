Return-Path: <io-uring+bounces-9159-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B522B2FC74
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 16:28:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 592106262C2
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 14:20:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF8F4280328;
	Thu, 21 Aug 2025 14:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="f4jYsPd2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237C726B75F
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 14:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755786005; cv=none; b=Jbi3I9SfUp7BknVEPWov2WUi9W7XP1SQtVz2ScyCNrSg1atkgORsaHjkXebAa9xzUuobNiFWEERRbQNx5PdCZLxe424Ra3DCHRSSOhTgKHswIqkqqAX9X7NlFNaOqQr5/FOX/MjVupIsX6awnfgnDZFFXxqq6FuSX+JuDJZ3KaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755786005; c=relaxed/simple;
	bh=WHshCWPAP/+LfJsAM2Ld5LwvSnuEhjATDFIQXIy4Lv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bLMirMzPwYIaRW7bFBsONjMJUGCs6n+d6G0TjeZe3tT55vXHg8kVJztZ39bLpTp0FCiAD2dMn4uFsqEQAMeTNa15bUbWRcaE+6Tsfj495RqFWUjuXvzn1gCKWTP8b8T2t+GA00B2b3zhpNdvnzlyBnFCV1mR1QuoPRrqodi8ctI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=f4jYsPd2; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3e67d83ed72so9106345ab.0
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 07:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755786001; x=1756390801; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hkt9A0h7rWMoq7WemR8DNACFxXqFilbl88yZXjx4qPk=;
        b=f4jYsPd2EQTFD5ZD39KIm7SAhBTu/NtZSSJsLMhQyUQ2OCMOJ7enO1fCWuaDhmgP/7
         4hkBzLXvQYwPGmfXA//otap26gg7lT3MYhVYJGIzDMH+L0Wk0qcQ/m0T6jYcwFcSXscT
         6jvHel/1EX11k/6o9jZQLYMffMunmiTCvjCkITS/+uCoH2GA74BjtB0WQ1vZaK9PvU17
         DWC39R/XFVjtMp94N1rtat0O+YkfR0KEPFgBAAd+nUqMbYYroq7jdWsyJd20Fg6pCQk6
         /dDzwbjywT6cbEsi+mPq/V8cjh4Tc5CX1TPsT4VgG2XbvOg5VZPGHFK4WkqQ+ucJ+r+b
         XJPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755786001; x=1756390801;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hkt9A0h7rWMoq7WemR8DNACFxXqFilbl88yZXjx4qPk=;
        b=YZA/Vl6hIQIfwgUtKPxugbZWu/cLHdeGJpv3b4D+8E+2vBhVSA62JLm3mGIaAJ5QTL
         Gt3KYZjpEPi2Na0b0AkRMDHHr8eTnxiJQCsp0xkvhP9xsUuKBYl9m/gFTFg/Voaszy8v
         91iJXoIruT+0OBhDzZNewX8ZZlA31j/0kYrfpQYZhTrp4HvA2TY6dp/cNf1YnWmrecWQ
         uYma8zu6++9KPbU7kX8YJROJAAKParkJ/dRhdfPZvna69OcEF6HH8AtOM2fkqm2DzmON
         /g8XQmLj8G6NfUeEi6cGjYdYpvlopY6z0jbPJHJdsprwBOpYVBXeHQD4HbW7GTk7Wv3S
         nDwA==
X-Gm-Message-State: AOJu0YwaMS02mpODNyMQMNkSPjpLsSB0lMFYoyJFJMkZaNZ1a4XKXb9j
	3lXu/f6kpud2lpIkrliezl5eHrlTsGNgeu0f9mPhvUYd6wGjBXRhDsy3lkuO1vpG7ZA+E6f4QZY
	k7veL
X-Gm-Gg: ASbGncsKzLPtw/j8v/fQ351YQyXugcEn/U7dE0giiRJBru5QE9D7evp7Tmi9GPeYEtq
	AkF+NUr+p75/p6KvpL9pJXHQqulP2Vk6TeyQZJiujwo7QY1IyKqYpbggOPwBMmTVY9FirLOFmQT
	3llDbTgYVJPshg0pofHRBCMTeQ60pBfP/w95j7dVz9ohLOd8sv+MIclA7DzOOAVhR88LxBkYpxr
	mEKxZROSP/G4MZ0vt/iq5+9pbQnh7jQTmajDaobdgMAKQRXcHX9ubyvvmI5rnHm8n+++2bSTqdd
	52D2nO5T2ENrPkjwL4UZAW7MUmWu4AYF5nKGQ4p6mn+zujI2MTCcf70NZELIuEquVx/6m0c9ExN
	jeN2b3sZoVmRZDugG
X-Google-Smtp-Source: AGHT+IEwsymoVMA3Ojkk4Okjy+BUJC0k4/enzM90zwHZKtEzW0+jOa3s3tLRDRaZQi21n/TTYS8rSw==
X-Received: by 2002:a05:6e02:4806:b0:3e5:4da2:93ad with SMTP id e9e14a558f8ab-3e6d7477306mr33768745ab.11.1755786000831;
        Thu, 21 Aug 2025 07:20:00 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e57e58c1basm73196595ab.5.2025.08.21.07.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 07:20:00 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/8] io_uring: remove io_ctx_cqe32() helper
Date: Thu, 21 Aug 2025 08:18:01 -0600
Message-ID: <20250821141957.680570-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821141957.680570-1-axboe@kernel.dk>
References: <20250821141957.680570-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's pretty pointless and only used for the tracing helper, get rid
of it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h  | 6 ------
 include/trace/events/io_uring.h | 4 ++--
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 9c6c548f43f5..d1e25f3fe0b3 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -740,10 +740,4 @@ struct io_overflow_cqe {
 	struct list_head list;
 	struct io_uring_cqe cqe;
 };
-
-static inline bool io_ctx_cqe32(struct io_ring_ctx *ctx)
-{
-	return ctx->flags & IORING_SETUP_CQE32;
-}
-
 #endif
diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index 178ab6f611be..6a970625a3ea 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -340,8 +340,8 @@ TP_PROTO(struct io_ring_ctx *ctx, void *req, struct io_uring_cqe *cqe),
 		__entry->user_data	= cqe->user_data;
 		__entry->res		= cqe->res;
 		__entry->cflags		= cqe->flags;
-		__entry->extra1		= io_ctx_cqe32(ctx) ? cqe->big_cqe[0] : 0;
-		__entry->extra2		= io_ctx_cqe32(ctx) ? cqe->big_cqe[1] : 0;
+		__entry->extra1		= ctx->flags & IORING_SETUP_CQE32 ? cqe->big_cqe[0] : 0;
+		__entry->extra2		= ctx->flags & IORING_SETUP_CQE32 ? cqe->big_cqe[1] : 0;
 	),
 
 	TP_printk("ring %p, req %p, user_data 0x%llx, result %d, cflags 0x%x "
-- 
2.50.1



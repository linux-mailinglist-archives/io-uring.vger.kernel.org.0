Return-Path: <io-uring+bounces-8036-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1669ABAA0A
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 14:26:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 074ED4A6BD4
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 12:26:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02B8B1DF99C;
	Sat, 17 May 2025 12:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P31KPjx1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2430B4B1E7F
	for <io-uring@vger.kernel.org>; Sat, 17 May 2025 12:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747484806; cv=none; b=gK+ysXz1wKwsGtGMh3Z9TuYm77FsERvOrshWCA6U8W6yvKXVH3ZyRfz24GVwZbQXHT8G6istNUIrqHwAGgoT1nBCF1LQlbK+cpQyvrmgdZXMnchOyFp+0lRK5+JNVVDK5lOzXkG8EgY+cjAOWLuA/fjFzp+DTeXp0eLuodJpg5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747484806; c=relaxed/simple;
	bh=fmC3n34WXXFUDtyugBz6XJMHnZtUJ3tE4IFsa/Fv/Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4TKNUjRilp6aVPJLGDAO3LoWNeMdbcI5ey4HBk1jCD1FZrk+LlVoCynwLbD3A+qM3w59i8GcY7h7Sm0Vg+QgVw8InRxV5uUSCiKA3mLPnrpC3BXwphISPTUGQf5igFo2zitV4O2KiMkCEEX+n9vX5/oCZLUQh1oyFy1I4btjGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P31KPjx1; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-600dbfe7b37so3131921a12.2
        for <io-uring@vger.kernel.org>; Sat, 17 May 2025 05:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747484803; x=1748089603; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0g3+scsxbeAY8tLL14YHQXFvyKua2AQOwE+HcDK98BE=;
        b=P31KPjx1j0fFfWcE7B06T8thzOM14vi43lc1IgDcliisLAUNUhehpKez9QOzr5xpSx
         Z4784d4HBpFX8R//Xi+bDvhxMDw3QmPQHdzCPzjJ7bbuGfZWAy2xLCenj+3Jng9GbrjF
         MaUQNE+y0BVg7O1mW0+wO2Odb7Yspf9cQFpGv35C/W7mSz8vUyTlx5vSHR8RsnbZ2l/5
         797PmJYPrtsJapqp2KeRun8fU1TQq9HPG7HympwlYOE1pwg6C+ZeMgPEamFtYkV6D3UI
         kbXKQCZTNTkDxnoFvreNFe3RpyzZZVT8etgd3bmY7x9X8vnPXy8s1RMAUWdj3EtJGIo1
         RRMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747484803; x=1748089603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0g3+scsxbeAY8tLL14YHQXFvyKua2AQOwE+HcDK98BE=;
        b=asON8ooPfMQ9kvsKgMWY6ZsW2mitFVWzZH7gexEvUUDUz2lNAkmQSAZPN79I1Byicr
         GoPjvOKOiaeXNU63ztScDcNq9+EofI+yAq3DjZS1fY3CMlTZPObTXEcbBUOmiQdP/Gqt
         0LQx9y+mA4We30uVuTHR9TGCJXzwGCcJ/IiLvhFyOG6PJbFR/2JdNE60UEIOxbaR1evg
         fsiv00YRCS8LLawNoy8X3S1wHXewNzx1GLDDw9JEQSgoP5O+k8olvtAiD2xo0BVnb1ZI
         tEQjIQgTTNs3vin2+vhRCeIdCf6B4dSfbd2cUvJHvuOtJp62d4Mh34lgIQ/t/pdIKk4T
         j5hw==
X-Gm-Message-State: AOJu0YzxAOzaRpn8ZeAv2+vLJO8RjcJ3GWhTpaGRhBP93grQ6tJlcXoG
	GMCWeVHdNwsc7wgpu8zbfyC+as67IZrVYq4tRKBNCT11yWXC/sgg2m2W0wAzIg==
X-Gm-Gg: ASbGnctwKkvWep/sfYWgdmIgEG0ZGF584qe/lFJzYXw5TlJzHNplaiRHr1zlD182hha
	PF1dwpZA55r2WLN8zCx2P1TdK++JNFqGZO6WPfy3BDmeNJzydRAaBtY/eS1JB5ffgI+ORLDOO+d
	ikzydlUIE5/4Aw42H3zcTulG7ogYy1ATntkfrdJwqWtW2wkXl32C5wO9Ibjlfefx44G4eXsSkp6
	G2Sq8wzbcBREOVYHg2psSp1tCGvTQYl2PIQDIpj36EZtovPvTzI+PmomhFWXHZC5wsHODgYs33K
	+CYAlgCg8u8wy6pE5Rz89jMkJg7g2kdNdxmkvDpvGuWvKqJJuvVdON/MwUKTJsA=
X-Google-Smtp-Source: AGHT+IFXYJTVh2GO7m4l0FZHDa7Tj/v4b0XjfF4wWdeJDl6zLkqTWlJzOSxb0mjKZzjDOTHHAerovQ==
X-Received: by 2002:a17:907:6d23:b0:ad1:fa48:da0a with SMTP id a640c23a62f3a-ad52d5578efmr606559866b.35.1747484802640;
        Sat, 17 May 2025 05:26:42 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.71])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6005a6e6884sm2876604a12.46.2025.05.17.05.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 May 2025 05:26:41 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 6/7] io_uring: avoid GFP_ATOMIC for overflows if possible
Date: Sat, 17 May 2025 13:27:42 +0100
Message-ID: <fd6facf7253b0c5111b032a0e40d0f173f28a3b3.1747483784.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1747483784.git.asml.silence@gmail.com>
References: <cover.1747483784.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

DEFER_TASKRUN enabled rings don't hold the completion lock or any other
spinlocks for CQE posting, so when an overflow happens they can do non
atomic allocations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 86b39a01a136..0e0b3e75010c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -730,7 +730,8 @@ static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
 }
 
 static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
-				     s32 res, u32 cflags, u64 extra1, u64 extra2)
+				     s32 res, u32 cflags, u64 extra1, u64 extra2,
+				     gfp_t gfp)
 {
 	struct io_overflow_cqe *ocqe;
 	size_t ocq_size = sizeof(struct io_overflow_cqe);
@@ -739,7 +740,7 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	if (is_cqe32)
 		ocq_size += sizeof(struct io_uring_cqe);
 
-	ocqe = kmalloc(ocq_size, GFP_ATOMIC | __GFP_ACCOUNT);
+	ocqe = kmalloc(ocq_size, gfp | __GFP_ACCOUNT);
 	if (ocqe) {
 		ocqe->cqe.user_data = user_data;
 		ocqe->cqe.res = res;
@@ -839,7 +840,8 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
 	io_cq_lock(ctx);
 	filled = io_fill_cqe_aux(ctx, user_data, res, cflags);
 	if (!filled)
-		filled = io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
+		filled = io_cqring_event_overflow(ctx, user_data, res, cflags,
+						  0, 0, GFP_ATOMIC);
 	io_cq_unlock_post(ctx);
 	return filled;
 }
@@ -854,7 +856,8 @@ void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 	lockdep_assert(ctx->lockless_cq);
 
 	if (!io_fill_cqe_aux(ctx, user_data, res, cflags))
-		io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
+		io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0,
+					 GFP_KERNEL);
 
 	ctx->submit_state.cq_flush = true;
 }
@@ -1444,10 +1447,13 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		 */
 		if (!(req->flags & (REQ_F_CQE_SKIP | REQ_F_REISSUE)) &&
 		    unlikely(!io_fill_cqe_req(ctx, req))) {
+			gfp_t gfp = ctx->lockless_cq ? GFP_KERNEL : GFP_ATOMIC;
+
 			io_cqring_event_overflow(req->ctx, req->cqe.user_data,
 						req->cqe.res, req->cqe.flags,
 						req->big_cqe.extra1,
-						req->big_cqe.extra2);
+						req->big_cqe.extra2,
+						gfp);
 			memset(&req->big_cqe, 0, sizeof(req->big_cqe));
 		}
 	}
-- 
2.49.0



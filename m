Return-Path: <io-uring+bounces-8230-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B0E0ACF47E
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 18:38:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CA533A3EA4
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 16:37:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3F331F462D;
	Thu,  5 Jun 2025 16:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="07VNXj/r"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89473225A34
	for <io-uring@vger.kernel.org>; Thu,  5 Jun 2025 16:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749141395; cv=none; b=JYusCR5OfK54roDJLseWEQaZX38wAAw8KWxJt1tJB0h3Q73DfGvVQv+E75AndA+QRgCq2fUnQZVt/ST6XKJd/6Akq9VbjkR1RUaWxnzAZD0k40K8qTNQ4D9s+aRjOh6vjr1l7amJvdwwYjDRbpAuB6AlFxQ0wfC4Wm9KyaXBfhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749141395; c=relaxed/simple;
	bh=wTDbhR8+kbJjLjqbNzsAnEda2w3PwqqG+aaM5bSHY24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nOY8ktlo0gS6jdPwNXfttLgzd6AVUbUql/x7cH86PAh7nCbbWqrBsxTvTH2vKZQHhZY256EuHcz+bHeI4HSwg3D6Po3R7404Y6fJv9FcOr56btjK9OBbn+4v7w0nJL0TJcuCJyF8eIiy/0gHe86T/Zu/pcZYz3BkTW7SdXR9egk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=07VNXj/r; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-86d2d984335so92941339f.3
        for <io-uring@vger.kernel.org>; Thu, 05 Jun 2025 09:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749141392; x=1749746192; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qSiO7WvgoSxPVGR8uAVGX6DDS5J9pJiJR+GZ/XVAGpc=;
        b=07VNXj/r2g2Jw14Zj5mVeh8nf+LWCO+2x+Uo07MZU4mEuH3DIwrAPJooVZDR6bqTex
         rrtQGRoAGI90DSCsdnw+7uetLNhVsG5Yw33Xg+UNj0DhHA3jJ2GLjd00ukOxx0Eo2Nh1
         7xzo21Y+jm8aqlW+kzA6OIpOhWN09IR03avJnWNcfIsKHYTD/3Sce/jrtujWe988yDVD
         ta6Kc5XfCGDpby44ZQ1+BqvVsT/WlMDGe/FX3zYLQ8bugeKV099FF12wCty1U5J1cUOj
         7AYzFQ5oQnLPooaOz8Qj9E+iW5vdxF6LuW0TMCJ49QlqvzyOTvo0Xp6wj3RuuP2zAXwT
         WQmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749141392; x=1749746192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qSiO7WvgoSxPVGR8uAVGX6DDS5J9pJiJR+GZ/XVAGpc=;
        b=tL6Px9vSZwCCtWTWUMS4MJtlViWrOjDL8t0kFA3gLEkZ42CBX1fALebsq0jCrC87sT
         xVREGBUB+Jz1d0/dMczoYO7xWQxLly6Dj1+hfCpUluMQWilvBec+NGiwoJ/zn5oDV139
         6+CVTxAzEdn3pasftGZIqC91UEU/FJ3u0HmsOJRCfun/sC/8kTGrwAK/PTb2j/nstM8E
         z+fmFe3G2ecyyMEfpjExouQtmw2dX+6lp1Ryyv0S6MhFK7COwLyux7RhHI2WxJ8FGT9u
         5Gqje9f5q8byN2N9reLU2WIrGlkt3t4Qc1DtkoRcJR388DOv40ThLf9yGgM23BBUtmmJ
         87Hw==
X-Gm-Message-State: AOJu0YzydlJhDwVCeqXO829vtg7Vs5ULczjqh/af/xVBFo6viUEkqC+d
	Fo/mL8r6DEA7/rjeiHF1pHIBuo2gYpMiVHekcgnb0oDXe4POvAwj5X5ZQz2TmUoaO5mIc3UBTuv
	QNfba
X-Gm-Gg: ASbGncu5dSRXBr+Xbn4mvQFR3kC7wsL9FmbsMHMy47+XrldY66x0bb5GZFx3KhH6d+s
	++AIdNmf4s2gXnS/T3U12HzS0EumK4TqnEkUGF/P2pSEN35AW9yLejHPCevdmo7Q3JCn4/FjaGp
	TFvT2JqEQHzhHJZ06B+SrOU4xLjnRLiYp5sXhn/RZx0+/an3VJ61chpk0Zro+WSfA7E4DJz/PYY
	LjhDHylPZbIwv5Z72XGmIGGWhdoeoRkkLJDggLKMpVC1LnqMJKjCKH89FCN0qsVqtmenQcMEugQ
	P43dj9i1DPAgqUJgThd4jaLBHbKhy/WYfu/+ZioLooj0mnJVdsYrdQAUVTxslNGRDg==
X-Google-Smtp-Source: AGHT+IEHLiI6osrZbxxLXIHT7Gf/t5f8iaAouqbBqfZ2mu/cIsRmsoEXOALqwWf1zztfEZcgNQZAew==
X-Received: by 2002:a05:6e02:152f:b0:3dd:c526:4334 with SMTP id e9e14a558f8ab-3ddc5264656mr52109145ab.16.1749141392252;
        Thu, 05 Jun 2025 09:36:32 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ddbee31f15sm10849085ab.62.2025.06.05.09.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 09:36:31 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: mark requests that will go async with REQ_F_ASYNC_ISSUE
Date: Thu,  5 Jun 2025 10:30:11 -0600
Message-ID: <20250605163626.97871-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250605163626.97871-1-axboe@kernel.dk>
References: <20250605163626.97871-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

REQ_F_ASYNC_ISSUE is flagged in a request, if the core parts of io_uring
either knows that it will be issued from an out-of-line context, or if
there's a risk that it will. As REQ_F_FORCE_ASYNC will similarly force
async issue of a request, add a io_req_will_async_issue() helper that
callers can use without needing to worry about the internal details.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h | 3 +++
 io_uring/io_uring.c            | 1 +
 io_uring/io_uring.h            | 5 +++++
 3 files changed, 9 insertions(+)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 2922635986f5..3b17c1da1ab0 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -502,6 +502,7 @@ enum {
 	REQ_F_BUF_NODE_BIT,
 	REQ_F_HAS_METADATA_BIT,
 	REQ_F_IMPORT_BUFFER_BIT,
+	REQ_F_ASYNC_ISSUE_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -591,6 +592,8 @@ enum {
 	 * For SEND_ZC, whether to import buffers (i.e. the first issue).
 	 */
 	REQ_F_IMPORT_BUFFER	= IO_REQ_FLAG(REQ_F_IMPORT_BUFFER_BIT),
+	/* request will be issued async */
+	REQ_F_ASYNC_ISSUE	= IO_REQ_FLAG(REQ_F_ASYNC_ISSUE_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, io_tw_token_t tw);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cf759c172083..8f431a9a7812 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2197,6 +2197,7 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		trace_io_uring_link(req, link->last);
 		link->last->link = req;
 		link->last = req;
+		req->flags |= REQ_F_ASYNC_ISSUE;
 
 		if (req->flags & IO_REQ_LINK_FLAGS)
 			return 0;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index d59c12277d58..ff6b577c18f5 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -524,4 +524,9 @@ static inline bool io_has_work(struct io_ring_ctx *ctx)
 	return test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq) ||
 	       io_local_work_pending(ctx);
 }
+
+static inline bool io_req_will_async_issue(struct io_kiocb *req)
+{
+	return (req->flags & (REQ_F_FORCE_ASYNC | REQ_F_ASYNC_ISSUE));
+}
 #endif
-- 
2.49.0



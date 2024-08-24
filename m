Return-Path: <io-uring+bounces-2947-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70B5595DEC1
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 17:49:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A06E71C20E45
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 15:49:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5659364BA;
	Sat, 24 Aug 2024 15:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="S1lhrjHr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8273533997
	for <io-uring@vger.kernel.org>; Sat, 24 Aug 2024 15:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724514577; cv=none; b=fWJDMlq6V3bac1b0ntgpKrv1comeqcPBuOC6n98u8fsjKKsi1i47Qa8CAXBK0wqiFHJNjonflQ4w4eiSXq+Mb1KNSa+zKDzjcu4AD56sSSAO7g3WDN0pa/YEjnKP3uBl5hhbok2bPpAFz0cCP8nnbM+QtB/q/5tNnC34y3ysGnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724514577; c=relaxed/simple;
	bh=PRaKaE9sA3U72W7chX6sHWSG5eOYSK5PclV57jFUq+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/dX8pCKRYphB9PRvfBMjl2Eovrp5A7pqGkp1ta57pra0IPiQuEyZZQBmLTqoYelP2NrFTG6x1QBF95W6DHSRQalFLGuDoAKL4MibP6XSeVuT7IzPVlZSKluxmX5o1f9uhip3RFVIHvz98U5cEcKMMx6FuGBo2rtuEc9LtVV5Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=S1lhrjHr; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-71433096e89so2590664b3a.3
        for <io-uring@vger.kernel.org>; Sat, 24 Aug 2024 08:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724514574; x=1725119374; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FY5xfN7UhK2bAjtRKe7nYvtHuClgzrrg9BUA7Pwo8eo=;
        b=S1lhrjHr3a+FtdvF1aAIPHcyoixld8PaVUIYO/lIxs29FAfhx5+KOHJGgCSa9V5drM
         Q1BmuMapwjmvKsN/Lp2n4/+sTEtKV57MSNbZUOGhuVaay84Dl4xOr1emIn3m+IhlOMZw
         sIo17cSxV3IkZDdD/hu44zRjcpkZSnSEzpNwAlGpM6lbuV7qtqd/I5TyMI67JqkcQ0o2
         OG7Plfs0wJvT2JtT3zOsNGc/cVNwkFDP2WKV0JOwTZEu4porcI8g38MrxgVqE0Z80MCI
         Ky52AQzHRsqu/KJAIcScff9XX0peak1u7LuADqVXxxOvMng7oXw5nLmC/At/qlsZJV9O
         HtdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724514574; x=1725119374;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FY5xfN7UhK2bAjtRKe7nYvtHuClgzrrg9BUA7Pwo8eo=;
        b=Gkg5O1tRTJVyyu60AUJuCc++7r+bFkEG/YJy9sXUAaVGtwsqpPr5ScearLMqiTe9UP
         L0ZoW3lpzbvQq066k1sJ2UDBnjV+eix6c59IbuNnqLjghG6Xzp9zy41cptSeLvLKtGAb
         H/tui2CXtGdUA5Roowp7kNzn6IetZgxJrpYJDlaazsEs6ePKR1S3QsloXGh2zcxL+E4K
         9mKaCQMBK0/kay4U48SLX+dY36PKr+LJfD38QT6D7JMIsNDGsqSkFmJDemuMKKbJEWm/
         XRQWYDRcqX+YhRAqeIcyE0w73wHhVGCJ73Z5RUp4BO8st2+mjRM0o7PNylHrU5UKwfWL
         e4VA==
X-Gm-Message-State: AOJu0Yz2kQehhZ8L1dAIIGqxbotzBmmnduc9pp3YM2CqY968J2sPqNLh
	9w1Wz9fj5Rezz431Dmu13kEO0SuFhXQuwkiRIlkUjS4YLPq8unO4x+IaMhmM51/7JUWQD6lsvru
	F
X-Google-Smtp-Source: AGHT+IFOWWtprh58Hx/WZFG7FJArHIeqIl7eZlBerxQqUo2Yi1S8NXEWJX08Gjebz2qa3S51d7aXJA==
X-Received: by 2002:a05:6a00:6f0c:b0:714:2d92:39db with SMTP id d2e1a72fcca58-714457e0f34mr5320400b3a.16.1724514574347;
        Sat, 24 Aug 2024 08:49:34 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-714342e09c3sm4633925b3a.122.2024.08.24.08.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2024 08:49:33 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring/kbuf: have io_provided_buffers_select() take buf_sel_arg
Date: Sat, 24 Aug 2024 09:46:58 -0600
Message-ID: <20240824154924.110619-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240824154924.110619-1-axboe@kernel.dk>
References: <20240824154924.110619-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than pass in the iovec in both spots, pass in the buf_sel_arg
struct pointer directly. In preparation for needing more of this
selection struct off that path.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index b20eee984b97..e3330ff9bfdf 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -119,7 +119,7 @@ static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
 
 static int io_provided_buffers_select(struct io_kiocb *req, size_t *len,
 				      struct io_buffer_list *bl,
-				      struct iovec *iov)
+				      struct buf_sel_arg *arg)
 {
 	void __user *buf;
 
@@ -127,8 +127,8 @@ static int io_provided_buffers_select(struct io_kiocb *req, size_t *len,
 	if (unlikely(!buf))
 		return -ENOBUFS;
 
-	iov[0].iov_base = buf;
-	iov[0].iov_len = *len;
+	arg->iovs[0].iov_base = buf;
+	arg->iovs[0].iov_len = *len;
 	return 0;
 }
 
@@ -310,7 +310,7 @@ int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 			io_kbuf_commit(req, bl, arg->out_len, ret);
 		}
 	} else {
-		ret = io_provided_buffers_select(req, &arg->out_len, bl, arg->iovs);
+		ret = io_provided_buffers_select(req, &arg->out_len, bl, arg);
 	}
 out_unlock:
 	io_ring_submit_unlock(ctx, issue_flags);
@@ -337,7 +337,7 @@ int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg)
 	}
 
 	/* don't support multiple buffer selections for legacy */
-	return io_provided_buffers_select(req, &arg->max_len, bl, arg->iovs);
+	return io_provided_buffers_select(req, &arg->max_len, bl, arg);
 }
 
 static int __io_remove_buffers(struct io_ring_ctx *ctx,
-- 
2.43.0



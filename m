Return-Path: <io-uring+bounces-5796-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3DF2A07FAF
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 19:20:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEEAD3A6F39
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 18:20:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1DC419DF7D;
	Thu,  9 Jan 2025 18:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aB7YFTBz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F4B19CC33
	for <io-uring@vger.kernel.org>; Thu,  9 Jan 2025 18:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736446794; cv=none; b=R4mFWbhJgZgTovSsZFvBgQ3p5+tChOXA7oNOipzRiG1s9BR/1UeB8N1Xx1LVOJWY+X23NMSDN3UK7i3p3psctOewt+wVjdxhvvoFF0iFaWiTtmWjDEmTVom4sW7kO9mVQWladHgYkkd6isFOy9Kn3TP5djQ0d7nJTmxxHWKWZ3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736446794; c=relaxed/simple;
	bh=xRrwNxj1/rvIJwkTHMgNtHwQ4dOt/tgHSab6xmTzMos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rcusIHOSEmvzyPbxUJtweYoOsfpQcKVAQ1xzQqVBvPg/OpQwDTEOANbXbFoVdiSGyJAfMLfmWBAC7hXtCt+nKtvbRUyy27PNWUbRYWt0V8Enx8PogcATRQqTN5tlgGrMxu5i5tw7SFLAatMlHenhGcNAwVZ9RsxXaV7Zu6Nul6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aB7YFTBz; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-84cdacbc373so33944539f.1
        for <io-uring@vger.kernel.org>; Thu, 09 Jan 2025 10:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736446791; x=1737051591; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w1t+BVTlt/VRdOOgz4cjVebKkTsKM66n/VWi2wFFbBI=;
        b=aB7YFTBzh07BcNoGuusIuMh1fUJoHXekKGoM3UECnN3f0RQcLUjCeigrBeDcOIR9Gr
         HYNYNJmG9SKQ4ScS5Y6KY3tRfj9XVJV+uRMSDUyfik2wnSI61O2ceBXNdTgJfCKmLdxs
         Gmf7VAr8E6xYV/4fYPkYNpByurFTtpYnLZaeGDkdzJnoHjuNccgYCsWDcSD0PHJg++sT
         bjjiqui1M9XOsCiIMGVBVyfyB/kKJp/hWshitDCqLiK20rZveP9lvitTT0Abmxa9vdCY
         p0hGyKp8yPCy2KOxQbZKTmLnVvKWJW8JEZI+qXs5nGIju+DOHApk407j3/OSUuXb+QeV
         EvmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736446791; x=1737051591;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w1t+BVTlt/VRdOOgz4cjVebKkTsKM66n/VWi2wFFbBI=;
        b=c1QqNVA0N8dFICyUuQlxKM3gXI2sR+on0D2TXPcDUElKeZ7LAmMoWZ2YgXdB5gGNSs
         So1W8xleUhPduGczqMcfnE9hAMA+21w2NmA6cmXETNQoMH3AEh7E1BTjIVPV+woHHwM0
         nWwN2MkF+HeoZWM2QWQov66s+BM2T4WlQiVwSNrn+6ehTLFJveL80Qz0+RmoacXM5AOq
         SHcNMa5LV6FP1TUTDvvxZ0d+lrW/ojD57DiPrfzqB4WD+gOJQC0DKyy0lxCCLcAmKi7h
         IV4lQUSqJe+SI7ckMr8TW3a88byXxkULV/jTndCZhJCQ5u7bqI+QQ5VWAJb3IqYj75K8
         UAZg==
X-Gm-Message-State: AOJu0YyW31lNaX1r8nl6V0lpSmWO+mxp6JT+iJuxCy9vcYbe5mz5ibCC
	SKknOZmZrdla1OoZZaOgNstv1w0VqIxwiPSmv9JrpSJV3+38laNO2hJnMbpUO5lU8G3I1APMxlS
	g
X-Gm-Gg: ASbGncubVno2kEYjP3nzJJXMNp9lmDJZJ8agJmfrJ5VBBHenWUmKSWXS0EuRrrPm9WP
	Hb+QW6DuE6fDvgexG+2FLKrlvbicZSKkIzizsSVSHyHm//WO7WKLnh1GCGL1iySbeFi2cMXxsJ6
	/45vJZoJhhguhXnPhJDCa8Y6l3WdkI+hPk7RqSf/t5XxuoEwy5NmsEuI0tlhLnivCgPnTKFPdFm
	s2iDiGAUu8KrxqmdG+Bf1Dd5+TWmPrL/hk6otmLU+I8ezfXbQ7qFDwv3S9EkQ==
X-Google-Smtp-Source: AGHT+IEA96I3wYkhuEk8WILlWjczhdB5ioOkiXPLpQ7zMZJA5qHuPRI3e7Uc/3Ez8O82NztxGt+PdQ==
X-Received: by 2002:a05:6e02:3201:b0:3a7:7811:1101 with SMTP id e9e14a558f8ab-3ce3a8df631mr66420645ab.20.1736446789423;
        Thu, 09 Jan 2025 10:19:49 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b71763asm440672173.103.2025.01.09.10.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 10:19:48 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	"Haeuptle, Michael" <michael.haeuptle@hpe.com>
Subject: [PATCH 3/3] io_uring/rw: don't gate retry on completion context
Date: Thu,  9 Jan 2025 11:15:41 -0700
Message-ID: <20250109181940.552635-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250109181940.552635-1-axboe@kernel.dk>
References: <20250109181940.552635-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nvme multipath reports that they see spurious -EAGAIN bubbling back to
userspace, which is caused by how they handle retries internally through
a kworker. However, any data that needs preserving or importing for
a read/write request has always been done so at prep time, and we can
sanely skip this check.

Reported-by: "Haeuptle, Michael" <michael.haeuptle@hpe.com>
Link: https://lore.kernel.org/io-uring/DS7PR84MB31105C2C63CFA47BE8CBD6EE95102@DS7PR84MB3110.NAMPRD84.PROD.OUTLOOK.COM/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rw.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index c52c0515f0a2..ee5d38db9b48 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -475,12 +475,6 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
 	 */
 	if (percpu_ref_is_dying(&ctx->refs))
 		return false;
-	/*
-	 * Play it safe and assume not safe to re-import and reissue if we're
-	 * not in the original thread group (or in task context).
-	 */
-	if (!same_thread_group(req->tctx->task, current) || !in_task())
-		return false;
 
 	io_meta_restore(io, &rw->kiocb);
 	iov_iter_restore(&io->iter, &io->iter_state);
-- 
2.47.1



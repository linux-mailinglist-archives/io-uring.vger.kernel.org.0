Return-Path: <io-uring+bounces-2562-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4577493B031
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 13:16:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EFC901F21640
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 11:16:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F6C7156F40;
	Wed, 24 Jul 2024 11:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F5O3VOhB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001A41514D1
	for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 11:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721819767; cv=none; b=OePL5rQHz69ENRIR/Ii1MwqMNVe3V5m33mcAkHfJ12GCkPOvwmyKzKI8uEHfZ9hQj4rKeGy330Y4Ry8AAZJBdQ3m0zDPtHT5WYtlpNCOz8eK9WAgzZtXOaBn5VZ39cgCGxR1BSJ7OpJyZZ88isJtrhOa2XPZJPOs8DL7neIEx1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721819767; c=relaxed/simple;
	bh=iG65+nAGu0sNmZ5b7VnU6xMDRHf+//JiPwt1wQ3bvIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjCx/cgerRXJeW+TykJCvWgQpnK2z2XQxcAGBuLEEe+ahDfYC1zi6VQzFzcjaaa3l+WCFH1V8XzumMrPcIVE9fqnEslJ/OGjxRyP4VNkG3wleAPcvgyXKox3uiVs/fGOdSFuM7xdVHqEma207yHOEM8u8AVM9n+ihsozTTkHmyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F5O3VOhB; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5a88be88a3aso3377855a12.3
        for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 04:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721819763; x=1722424563; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cEKh47UkaXuj2JEDyxIJELJBdvBHFKRpFhvKFN8rQ6c=;
        b=F5O3VOhBiAazdEMixraA8wKom5Tmvz18AfLjTNLGPTs7h89kB/eR9RiR0BHR5qQxrR
         JLmXNLCVnM2Ee92G7uaBxYsGjifyqdGT5g4bjzcskFHphJ1HYaYvwbGhrOfa31/gFLoL
         rafoEUFcWAT37V3Bl4N4zlWw/XhTSiKMDQdCWhORuV2Ngnm4X2Bjn3Q0ktwuTR4B6760
         DlhifvjkuTNKVbnEQvoQRSYrfJEWLDpOHvXCRLURYpaVh1R+b70HVTSHqMjS57G4qkGR
         ja0MKXJ5BkZtMfAsSyfheDr9XxNlWeFXFGsgFIVgiWR9iuPFOOwE1lmQLkdn3E2BMZpO
         Ywnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721819764; x=1722424564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cEKh47UkaXuj2JEDyxIJELJBdvBHFKRpFhvKFN8rQ6c=;
        b=CfD4/nC9wJDBtNjtwBIDCCMqsFVCJzjEeniG4faOEJgqjGhr4OjVBvgH87ybSTQnUd
         ULOCie9uLFZHs9fR0/tQmE0ZGAIHk28JLRY/1t47Q7hWY3jknL58jzgAM0hguA/kThya
         TklC9IgOGtqR1Uy8bWizcKg+wCv8IshGfy8GHY5tJfwUGF0BWym9xSQjNHGQ3GWoTZCM
         bjkrnF/awhSWgdlJeIlIlZ8Q+kfOBlOU9v4JWO+tQ1/CulSm69E+X+VZI82PFv0ZAgCX
         l/x/lqdpi+2C8jRvLaeaCaeIgYwmGKmt5NC81Sbmyrzd5Sm/6vMZ/qKwN3PNI7EgncoT
         nDdA==
X-Gm-Message-State: AOJu0Yyi9CJ71RM2l+s4XbMKq99qogzE+yzKZtAII6yVellWO2edtor9
	ovjNZYGtXMGWYiMsHeJYcsxcc90d0vaKRqcER77Ga7vo+XKh6gj+J0SUUg==
X-Google-Smtp-Source: AGHT+IHmKQhxQhwAf1/1ocmmeyE1A2GQoZ/LPgTq23xnLudN444MRte9AQ3mU0WNXnExDCEJ6njXfg==
X-Received: by 2002:a05:6402:4302:b0:5a1:3b03:d0cb with SMTP id 4fb4d7f45d1cf-5a47ab120ffmr11833462a12.32.1721819763532;
        Wed, 24 Jul 2024 04:16:03 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5a745917f82sm5006310a12.85.2024.07.24.04.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 04:16:03 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 1/6] io_uring: tighten task exit cancellations
Date: Wed, 24 Jul 2024 12:16:16 +0100
Message-ID: <acac7311f4e02ce3c43293f8f1fda9c705d158f1.1721819383.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1721819383.git.asml.silence@gmail.com>
References: <cover.1721819383.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_cancel_generic() should retry if any state changes like a
request is completed, however in case of a task exit it only goes for
another loop and avoids schedule() if any tracked (i.e. REQ_F_INFLIGHT)
request got completed.

Let's assume we have a non-tracked request executing in iowq and a
tracked request linked to it. Let's also assume
io_uring_cancel_generic() fails to find and cancel the request, i.e.
via io_run_local_work(), which may happen as io-wq has gaps.
Next, the request logically completes, io-wq still hold a ref but queues
it for completion via tw, which happens in
io_uring_try_cancel_requests(). After, right before prepare_to_wait()
io-wq puts the request, grabs the linked one and tries executes it, e.g.
arms polling. Finally the cancellation loop calls prepare_to_wait(),
there are no tw to run, no tracked request was completed, so the
tctx_inflight() check passes and the task is put to indefinite sleep.

Cc: stable@vger.kernel.org
Fixes: 3f48cf18f886c ("io_uring: unify files and task cancel")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8e6faa942a6f..10c409e56241 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3031,8 +3031,11 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 		bool loop = false;
 
 		io_uring_drop_tctx_refs(current);
+		if (!tctx_inflight(tctx, !cancel_all))
+			break;
+
 		/* read completions before cancelations */
-		inflight = tctx_inflight(tctx, !cancel_all);
+		inflight = tctx_inflight(tctx, false);
 		if (!inflight)
 			break;
 
-- 
2.44.0



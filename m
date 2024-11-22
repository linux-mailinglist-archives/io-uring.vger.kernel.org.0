Return-Path: <io-uring+bounces-4976-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94AC89D61E5
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 17:17:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51D20161293
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 16:17:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FE5718452E;
	Fri, 22 Nov 2024 16:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OqtzTxIQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335A57080F
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 16:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732292215; cv=none; b=Z2mLgmpsQgYGVostYfKH281UmuKpmtFkWYsO5PW3zOhYcDhDX0uZiRQoLgoPFoG+3LZO+reOtwSaR3dtS3KQ8In0aXWgqvglGejSR5H8P1t2MfC+nBtBffY3ONSwRK6XH1Eh7hmmLZwtUpNV9a3rJ+/INpiaItBpzhYEGFp38XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732292215; c=relaxed/simple;
	bh=aKqf/yet5xbIo75w1/w823xrJ+0QRPqSOoxcTHUrFMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qK+nh2Zzz+TFIncyPNGPr/GF157Pj98tilxUreJR8tFUEgslcFptOdfERap1gGpSj/+GA4X+0yqNDVOrl/WXc3R+R9fD5mzBTzqAd3o6eBMxC3hDh//RhQbCT9fVdiEzHPkhPxOToa07ImhZbwbZkCnPA2xgRFB3tyA1DL8E+I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OqtzTxIQ; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3e600add5dcso1282063b6e.2
        for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 08:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732292211; x=1732897011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZV2XLAd2FBw7uW27Z17RAX832FSnx9DIDrjhxIjZX38=;
        b=OqtzTxIQ1xarLr4yTNnsy2PKlDwAbC5in+qPgqlvZ1cJQrroj2gmiZItYzPm9eUqh2
         dPh62t3ImuySx/K4Y//3/7TgddIdSfYEZPJVPZDXA1oDAHtEjhEaEg9pY+GTR4F9uei0
         UZEsjP83cbmywFkFUerItmxeBykQuMJVqNy0WhIxBI8MJm3Qu3dUfRMmCQR2/4BBONF9
         eYt0qu3q5Kk0K8gh14U84TYYXenJCbtJhilGmJ25zAmUV0jfreH4UAs2vboQ3b0rIIFO
         EvF/SjFtiZALKIaTFFLAHoClZADlbagBvAJ8aRT163VFkH60a/f36CxZhzQcD18/jS4O
         XEbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732292211; x=1732897011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZV2XLAd2FBw7uW27Z17RAX832FSnx9DIDrjhxIjZX38=;
        b=wcoJT9A3kDnlhI41KoGLS0/WbaGJzzsY7bBZNEy0//5UWCu0Y70o6EVvS+ruG9uKa4
         ntAW5DRfQOuFBxd+VUFF9lzY+ik8nLEC04Wn7PzYl+/41GvBkEiRY+j9BSnQtwPgPGNi
         yZBYNGK6XqXjom63B/I9b0FW/XGkxhkejHv7WHjl5bBBfgkUbt71M4M5HbVRFNvHF01p
         UJKfXLKS/gcLItOER2MVkDOki+YE7KbEmNP6rAwwn0ZxBvZRhkhoTedqNg9mNUiFUSSk
         laviwe0bn2xo8qfDy437PDhUSNxsfeRcH/pf48eul+JwL1g9nzu7DYot2uGwR4W8lxWO
         RhAg==
X-Gm-Message-State: AOJu0Yz3tnZDEHY4GLID9Pqm942EmRomGWfCmSwBC6Y1GzWg/MC0ughL
	MikKnAQ4/R0Jxz9S7/ku0WPZETgrcldAKA8dm6MaF44N7sTxn9Zc62uM4IaOf7QSnrPT8PRXdVm
	76Lk=
X-Gm-Gg: ASbGncumvKp7Ql7o9QEVwGGBxH3crEjKbZftLbzKMAKQ90lEnVSqxepoYq2BrVQg/oT
	ur6FwKVbk7a7NBGZoc4RursX3+aACWdfHe7BnlfQ8o6IL9CHFwUwEEhj13y5hUOhnnDj305sJvT
	EtdulAivdQSSTUO2xn3JI6mGjOgI23ObhPLkJQ8061UqvsMZPxd/gEye2nNlk529ycGuruKpf8z
	9lBaBKuY4mo1bPDax1ropU2WO930sGHe68yAHGlifxBu9P9A4UXOQ==
X-Google-Smtp-Source: AGHT+IGncLXV1+4DOOWCSEag3vTTMGk45R4uA7tIsoK0f6Rs1D4hnu5nCBlB1K3mjc9UpHBfTxJ2Pg==
X-Received: by 2002:a05:6808:1446:b0:3e5:e4c8:cd34 with SMTP id 5614622812f47-3e91587772amr4164097b6e.25.1732292210855;
        Fri, 22 Nov 2024 08:16:50 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5f06976585esm436958eaf.18.2024.11.22.08.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 08:16:49 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/6] io_uring: make task_work pending check dependent on ring type
Date: Fri, 22 Nov 2024 09:12:39 -0700
Message-ID: <20241122161645.494868-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241122161645.494868-1-axboe@kernel.dk>
References: <20241122161645.494868-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's no need to check for generic task_work for DEFER_TASKRUN, if we
have local task_work pending. This avoids dipping into the huge
task_struct, if we have normal task_work pending.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 12abee607e4a..214f9f175102 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -354,7 +354,9 @@ static inline bool io_local_work_pending(struct io_ring_ctx *ctx)
 
 static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
 {
-	return task_work_pending(current) || io_local_work_pending(ctx);
+	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN && io_local_work_pending(ctx))
+		return true;
+	return task_work_pending(current);
 }
 
 static inline void io_tw_lock(struct io_ring_ctx *ctx, struct io_tw_state *ts)
-- 
2.45.2



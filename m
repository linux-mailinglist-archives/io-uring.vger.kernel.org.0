Return-Path: <io-uring+bounces-8515-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4F2BAEC2FF
	for <lists+io-uring@lfdr.de>; Sat, 28 Jun 2025 01:28:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FDE73AAC4D
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 23:28:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02C56290BA5;
	Fri, 27 Jun 2025 23:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="auvHkqO9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D702214813
	for <io-uring@vger.kernel.org>; Fri, 27 Jun 2025 23:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751066925; cv=none; b=gAdvykR2LYHyQEnOTkcapmMEDgo4m8/B++NfblL94hKYH0RRarK1xqUp1bw2ZDLJh0bu2cMUxrOo2svzzqo8UH2GqbMSHxQB8QDi5Id1mblLUkhJjZRDPG2tf15UQxbXAkeOgGy+v46aA83B3qeqfjbpwCN3aOuu2mLG82Jql80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751066925; c=relaxed/simple;
	bh=mmIYpuQVfYSKj+NHgnZaLphmUNhtR+O/tZWAQtxGcS4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BtDpb2WmYEDuv/iN9S2aFfPtEZixYS1dhGGVnJPd3qTxB+US/vmP7PoIHl8T53U/jTkYnGRMoRNSqv6BuhukZHQiOYT0gtzcG58Cu5rBznzfLJPz2Z+HLvcz7vkAeuAElVB+gXYWclEWkrMemmieML3rFp1KEMvZpc0nonHZYh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=auvHkqO9; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-6116d9bb6ecso232673eaf.3
        for <io-uring@vger.kernel.org>; Fri, 27 Jun 2025 16:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751066923; x=1751671723; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vhFS54RZ5e5FBjCi7j6/8xm0daxBFLkAHKsyZJXx2JE=;
        b=auvHkqO9IBgyWbK8VR98TWArP1jmanOFt1GYXmuf+sQRmky4nK5Pht9Rst1R5OPuiM
         MGcclG8tUSitGxxo8A+zByhoImGg/FmYj4JsIdkXJwgpFkm3NyQQzOuxIJMU5oCx0AhP
         ESe4cpy2wlsc+uWwMTHasPuILfhzVR8O6EDpzAEDhFWFq2xHwg7M7lmP7QZ0gVvLzHq/
         VAx4pvVmk0YN2lUEBvYCtrf6t1S9KgnyhkBp8s3JpgOsP7QNXCFaeAlUZJbdSabKT/ys
         C04VGN/ACN18DNLNLn1tuMJn+is+Sxd0z6vmi00qP1jz5bnlZ/UXcxTF8StnZnibu85n
         zyQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751066923; x=1751671723;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vhFS54RZ5e5FBjCi7j6/8xm0daxBFLkAHKsyZJXx2JE=;
        b=h+FK0wA+e5vVzQp8NDEDioXJt0JkAs2YdotyS2OvDSWNt1MG8K/rQmHK/a+GPg7irg
         L4m2efb9A197QyC0V/jVBwtANsKFH+IAkC31H5ocJe8lVLPKCQW6hhzP8WgSyjiUQELI
         jc/UChr57S0QjODjnNavbF2dqpq2SU9ptw2MvDYiOS6dDfyq1nuqf4uktPX3mszaeXtI
         5N3XHBi4UX7eD3OH706ejQWt6RAPnMR7TNdpLdntsTpo50Mzpzj9M89EvqdAfHpUGbNs
         pZC3WESOsGVOHx1tbUEexF456iTbeZm28fm65ZUg4yhsh6hTUppS7ofT/BVl+qD//Vh0
         JwHQ==
X-Gm-Message-State: AOJu0YzTLhMqRuN3rtFfsDooIvgbaO0ezTpoWDPWXK2bmgra6blctQaN
	MvU30tHlEOKXitqjJDVWvdBl9SDtta55lLTKPTDTTg01oIIIRTOXuRhdv0BkdAoLm48=
X-Gm-Gg: ASbGncuwe4RU87g/8YcKldMBwveFSzFmaC7Xa3a3SL9CGkhSucYlSkKaEcsbXjHfsop
	jewFYGi69NoE/OevTHkQw6om1XRCptqtgmmsWI716JLsT2fjcCJZ7rzVJDr9ZW2T1MMFPMXq2sP
	WL2715awv0MwqVn6URjC5qNCyymD4OOXQh7p80RmSrVnx5sWet9ewb7OPwBMkOMEPaNQz/sQ2S1
	P2SxpOcx193fppkmRjo0m2eTttu+jAguvJujC9C90KESmeAoT/ooKuhfy/tw25JupFrnMYD/ClI
	lUJOng6tF8AypObLb6i2c/LFEFVJrdTMW55msWbdia6ISE0QP7TDKwa6Th0WDZdC2Hxv/IehnGV
	1TB1GO6akVBXlcgBbd1kFCn07SBM6RDmUn3GU4nRo
X-Google-Smtp-Source: AGHT+IFwjOO7/C98zSNOmhybfpS/lM8hs+3Imm+DreQcmBSA2pvPevAEaHixYzMrQ8CZCDz4GX6Jow==
X-Received: by 2002:a05:6870:be97:b0:2ea:8c15:d6d7 with SMTP id 586e51a60fabf-2efed6f3da6mr3649368fac.27.1751066923007;
        Fri, 27 Jun 2025 16:28:43 -0700 (PDT)
Received: from anbernal-thinkpadt14sgen2i.boston.csb ([2600:4040:5b80:d200:2ccf:5acf:c5db:909c])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2efd4ef026esm1129912fac.11.2025.06.27.16.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 16:28:42 -0700 (PDT)
From: Andrew Bernal <andrewlbernal@gmail.com>
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	trivial@kernel.org,
	Andrew Bernal <andrewlbernal@gmail.com>
Subject: [PATCH][TRIVIAL] io_uring: fix four comment typos
Date: Fri, 27 Jun 2025 19:27:26 -0400
Message-ID: <20250627232726.58700-1-andrewlbernal@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix minor spelling mistakes in io_uring.c:
  - cancelation -> cancellation
  - reuqests -> requests
  - discernable -> discernible
  - cancelations -> cancellations

Signed-off-by: Andrew Bernal <andrewlbernal@gmail.com>
---
 io_uring/io_uring.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5111ec040c53..6fe489d6ae83 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -409,7 +409,7 @@ static void io_clean_op(struct io_kiocb *req)
 }
 
 /*
- * Mark the request as inflight, so that file cancelation will find it.
+ * Mark the request as inflight, so that file cancellation will find it.
  * Can be used if the file is an io_uring instance, or if the request itself
  * relies on ->mm being alive for the duration of the request.
  */
@@ -1162,7 +1162,7 @@ static void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 	BUILD_BUG_ON(IO_CQ_WAKE_FORCE <= IORING_MAX_CQ_ENTRIES);
 
 	/*
-	 * We don't know how many reuqests is there in the link and whether
+	 * We don't know how many requests is there in the link and whether
 	 * they can even be queued lazily, fall back to non-lazy.
 	 */
 	if (req->flags & IO_REQ_LINK_FLAGS)
@@ -2856,7 +2856,7 @@ static __cold void io_tctx_exit_cb(struct callback_head *cb)
 	 * When @in_cancel, we're in cancellation and it's racy to remove the
 	 * node. It'll be removed by the end of cancellation, just ignore it.
 	 * tctx can be NULL if the queueing of this task_work raced with
-	 * work cancelation off the exec path.
+	 * work cancellation off the exec path.
 	 */
 	if (tctx && !atomic_read(&tctx->in_cancel))
 		io_uring_del_tctx_node((unsigned long)work->ctx);
@@ -2988,7 +2988,7 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	/*
 	 * Use system_unbound_wq to avoid spawning tons of event kworkers
 	 * if we're exiting a ton of rings at the same time. It just adds
-	 * noise and overhead, there's no discernable change in runtime
+	 * noise and overhead, there's no discernible change in runtime
 	 * over using system_wq.
 	 */
 	queue_work(iou_wq, &ctx->exit_work);
@@ -3160,7 +3160,7 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 		if (!tctx_inflight(tctx, !cancel_all))
 			break;
 
-		/* read completions before cancelations */
+		/* read completions before cancellations */
 		inflight = tctx_inflight(tctx, false);
 		if (!inflight)
 			break;
-- 
2.49.0



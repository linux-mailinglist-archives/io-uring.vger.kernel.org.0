Return-Path: <io-uring+bounces-13588-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kCU5GxezHmr7JAAAu9opvQ
	(envelope-from <io-uring+bounces-13588-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 02 Jun 2026 12:40:23 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id ED9DA62CC06
	for <lists+io-uring@lfdr.de>; Tue, 02 Jun 2026 12:40:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DDD2430CE001
	for <lists+io-uring@lfdr.de>; Tue,  2 Jun 2026 10:22:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B08F3D3D06;
	Tue,  2 Jun 2026 10:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jytnsxLc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0087D2C11E2
	for <io-uring@vger.kernel.org>; Tue,  2 Jun 2026 10:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780395738; cv=none; b=Ng49PaWaMbLpcUm+8tbCc1NfyR3+HdhDmgbqObEEYt+5LUpYlGwCj2O5blWIkDqNAwPF5N0TG9FVnO/oiZCQ7n1TYANCaxgP4T9dZQDwgbdrXa4/K3EzPkwWVSCC2IVxt/3GwABQCVWf9egpPjJZujE37mG1m1vECk3EdU4flrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780395738; c=relaxed/simple;
	bh=3H6xjDI5tDkMB/W6Xy6Px38BroNNOLbdp1JUwUVSc2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSnr2Jb+ylgKqWObTMuIygo/O6S79/kYnmXYmud7zm2yVxgVlWNuoJrkJhhE9QplDFmnLqPL2SWd/IycdgfTN5GAlGUx6tfrA6gUlWx32rI9xXDVjRsexL8x8KxVXYjU1UnC+RmTnpDFMqu+6bDSqJ+Jw++Cd4sk3DhSxWjDnGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jytnsxLc; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-490aaeabdb4so12086595e9.1
        for <io-uring@vger.kernel.org>; Tue, 02 Jun 2026 03:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780395735; x=1781000535; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GmimhtcIiGzsQ1w5GhbPj66yrAKQj+UkWaId4r3lx4w=;
        b=jytnsxLcb7q0Ynpu3vdIDJyvE+qdQsqZ858xTrsMk2hxbaEUkQdeTyOlvoUFcckCY1
         44/585tehpb5l8gKx6aGh3FGPQR7TjoqCIBTTCrtpoZ0dmPV1Nb4BxS2urkunzp2WdXE
         A9YNY0G02PEbr8GYeZN1QNtGBQRNAnvlwDclrCphde5YnunZnMgV9se4FgwhX1Yk2nm5
         uKphp18YaVIA64vSYh7kARTaPAzF44dcqgG9q+pBuTSOuSDSK19MwygWVofFXpPwSTV4
         nybZ/l6YnLW6/pvrlTMwWjwBvyMzxLj/HurfbA9plSz2fZHK/daBjMFc4RHVBPFraZTd
         pjXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395735; x=1781000535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GmimhtcIiGzsQ1w5GhbPj66yrAKQj+UkWaId4r3lx4w=;
        b=F6ySXsgjFiHUypt9ks9PIGXXFaKN9rsNBsJH8UNqdQFlxadU17Ix/AY3mw4WZhSOnp
         ijqUl/tjIbYSj5VnYmfr/w7+AZx7GZTCXvaCChwLC+ozIXplK/ZUO5667zrpQC1cP07a
         GUCUaxmfuvsp43ejbytAQhb/UWXOnJf/5oYgbSxyuG/wL8QXnhYODy1B7eHNuXCi5ObG
         R1CM51fnlqWIGXDweGzvBPVvd3GkK71vsqXVuoy4ZmVzOP+I2gxt0NzL//ESpXjywBmP
         PS4VZOSfZ4twWN3Itxu914X0HsdpTmmgIzm72zMIVMqq6FEjNcYCUdeWaoUBQvahBUsi
         aAiw==
X-Gm-Message-State: AOJu0YzCLHbHQlRaod+efGoN4t8cJVsCO9qCaVZ7P8F56AFEPNbHCUGW
	UxIUez9Vkti1rVqR6m+HLwVel8qwhW/x4HivZkihgKeRkSQs0xNrDoS/CnHsQQ==
X-Gm-Gg: Acq92OExN0OI0j4/Qj/u+xMLz3B53+Ta5requQuoaP02TBC8GL75jRFuF91nLwTTzA0
	eIt6/1194cA6vdTlvs+E7RSJdhbgZa09hFbD1v7X3VfGavRyP/oegzU6/aX8rMO3cm22Dn2lVbs
	DvGlU0g9WMOYS1JVaggzniq/TnYCrYjWOvZGLaaZp74o1/78DGGF9nT/fs1qpfgGS3xONIqZJ+P
	yUjYxj0WN+JUTYw9luXCIjn7EZp4twogddfBk8t6333m+zud+d8i5COizB93J37/gZ25noRYJss
	ZgQcgg4mjLPb9t9amu6BMNaejXdN+xDmG1KAOSkz72lUwk2kNuZFQ5qHeEIsckaWjV+hHQ8d/y3
	Hlf8suV27Mh2R+uy4A+Q/AnDdRaExs4WNV/sO4hzt857g1dGuwhoZHy3iKRxeATug0ZqQySosE9
	AeC+l2zi9FTrneYCfUAmfpwbqMOfNpNQmiJs7LwA6dV5E+E8UUSnOKhP3vZkGojg4lpBx2ds6fj
	TlU5WxWcZ/bEw2pp/8/6UnLk9gT5Y3J15X7Zi5n
X-Received: by 2002:a05:600c:c4a5:b0:490:b432:6f1e with SMTP id 5b1f17b1804b1-490b4327145mr965885e9.33.1780395735367;
        Tue, 02 Jun 2026 03:22:15 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490b0e24069sm59123105e9.8.2026.06.02.03.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:22:14 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 1/2] io_uring/loop: add a structure for loop state
Date: Tue,  2 Jun 2026 11:22:05 +0100
Message-ID: <896b5971e721400d17df94868ceefb9636bb3ce1.1780395120.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1780395120.git.asml.silence@gmail.com>
References: <cover.1780395120.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: ED9DA62CC06
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13588-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

struct iou_loop_params is BPF accessible, but I'll need to keep extra
state that BPF programs shouldn't see. Add a new structure, which is
just wrapping around the params for now but will be extended later.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/loop.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/io_uring/loop.c b/io_uring/loop.c
index bbbb6ef14e6a..affaee440dc3 100644
--- a/io_uring/loop.c
+++ b/io_uring/loop.c
@@ -3,6 +3,10 @@
 #include "wait.h"
 #include "loop.h"
 
+struct io_loop_state {
+	struct iou_loop_params lp;
+};
+
 static inline int io_loop_nr_cqes(const struct io_ring_ctx *ctx,
 				  const struct iou_loop_params *lp)
 {
@@ -21,9 +25,11 @@ static inline void io_loop_wait_finish(struct io_ring_ctx *ctx)
 	atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
 }
 
-static void io_loop_wait(struct io_ring_ctx *ctx, struct iou_loop_params *lp,
+static void io_loop_wait(struct io_ring_ctx *ctx, struct io_loop_state *ls,
 			 unsigned nr_wait)
 {
+	struct iou_loop_params *lp = &ls->lp;
+
 	io_loop_wait_start(ctx, nr_wait);
 
 	if (unlikely(io_local_work_pending(ctx) ||
@@ -41,7 +47,7 @@ static void io_loop_wait(struct io_ring_ctx *ctx, struct iou_loop_params *lp,
 
 static int __io_run_loop(struct io_ring_ctx *ctx)
 {
-	struct iou_loop_params lp = {};
+	struct io_loop_state ls = {};
 
 	while (true) {
 		int nr_wait, step_res;
@@ -49,15 +55,15 @@ static int __io_run_loop(struct io_ring_ctx *ctx)
 		if (unlikely(!ctx->loop_step))
 			return -EFAULT;
 
-		step_res = ctx->loop_step(io_loop_mangle_ctx(ctx), &lp);
+		step_res = ctx->loop_step(io_loop_mangle_ctx(ctx), &ls.lp);
 		if (step_res == IOU_LOOP_STOP)
 			break;
 		if (step_res != IOU_LOOP_CONTINUE)
 			return -EINVAL;
 
-		nr_wait = io_loop_nr_cqes(ctx, &lp);
+		nr_wait = io_loop_nr_cqes(ctx, &ls.lp);
 		if (nr_wait > 0)
-			io_loop_wait(ctx, &lp, nr_wait);
+			io_loop_wait(ctx, &ls, nr_wait);
 		else
 			nr_wait = 0;
 
-- 
2.54.0



Return-Path: <io-uring+bounces-12677-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cHWbKdV3tWln0wAAu9opvQ
	(envelope-from <io-uring+bounces-12677-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 15:59:33 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 20C8028D959
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 15:59:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 517753012D25
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 14:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFE1D261B71;
	Sat, 14 Mar 2026 14:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="n/xap2N0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D176378D9A
	for <io-uring@vger.kernel.org>; Sat, 14 Mar 2026 14:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773500370; cv=none; b=m7xCNrvOlzDOTxyMKy/zD4CRjuuIUJ6YKgjRFHYu+6l74x42mu07LPTnja/Yuzp+OpvDd2uvxJiVguWF7mcXWpGW2/dn24CbChrBJTXoBwxaQ/nmdMXEn4+YnKdw+L8v/rP7mQ392lfRb9of8/jHDSMqWoWvi3TzGzKtEoX7jbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773500370; c=relaxed/simple;
	bh=ldHOMYBNo7rPWBC1f5nhjDPPrWqWA/BqUxSgrTBoc98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3ZB8Yg10KQdEyznnt2KHqCyCtOxNAquVzptYqfSylNP9IrHaDwC4SU608OdzxVfH1OGe1OKw9O/RA7gbb1SXS/S6ZsYcQAwUyX8J9YyaWXZk5btTNtKZrS9ksPRIJ4yBdwSudUB6XoY3WSwQ3OE3dws/kHTsALC6dvw1u9GYDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=n/xap2N0; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7d4be94eeacso3668393a34.2
        for <io-uring@vger.kernel.org>; Sat, 14 Mar 2026 07:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773500368; x=1774105168; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KdL6vZEFx+Qb8TUQjljtQAc9SifNICtGNSlusVVBR8E=;
        b=n/xap2N06HPBVPxX7/+etKpm6/b22A+KKM9F4Gsyanh4Dd8+zb8k6i9e/KlhRemHmm
         p2vbQjAWX/070F+gRAGA0SvOggISpUNHLfUj1lr8zr7L0ehR4zDLKSyC/6c5VdC+VOgt
         RR7UzW62lUE2BVv7PDBbjSWnvSFW8rphC6xi7fhNtx/8/3ncWT8FcAIUv97JmhdUbWBr
         4l/C0FQ7VlEFUTDbgXbEiNNXtYseKbTA/l8Uuj8NF9tFMzEuDOR6rPg1e99u8tlsAHh4
         nNZ5HxzF7kqCwC71FfHanpXDIqasysvtZ3yMWL9CCRvMBJJF2a1upAvsKEg07yPIg988
         +sBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773500368; x=1774105168;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KdL6vZEFx+Qb8TUQjljtQAc9SifNICtGNSlusVVBR8E=;
        b=f6IDHUfoSp8PUOSg6rfUPH8NjJGUbdt4NdGYRK1o+moGvJFTii1vXZqaqtttKYRhk2
         mtDeMjTxlKsxQAb6EdRNU+W2ogPQ5JaeGSz8CaQ38mse8L285i9w2vhDWqVIxt/zx2yz
         O9tAe71xtpOeFr2xLbEoz7tYkuy7L4//RGpalLqJVptiR+PV9rKwwGu9G4HHoY/WETS3
         DOdh6h8PpN2AfrJYWQPOSc8/X30dL+JcziewR4ccuWBCCzGnQH1jFdCW/OY1sGbTuTyb
         q2dXqwAfghC0M0C58rDIAiKK7PbYthQ9T4Eqe6iTwUg2vr3FLKp+Fsv1osvv7zF/TEOg
         o6WA==
X-Gm-Message-State: AOJu0YxW9uuvmihHh7eFgt03cGjNIFHMfwpucbIPl3Xdww94Ql1WFh1J
	wg4+ED5RMRc1Dut0TM0BvWv639RZQsL32RQind46zqM7HUhcNmXOpYG3d9L9nvndYg1Vp9Nfxr5
	6gREjE/A=
X-Gm-Gg: ATEYQzyy5oGGNX75I6W8KMfObTcXtIqeMIp31xT5ktv64K6a00l8lp+L1ccOP0Vzxf/
	eZcgwoaIciIt2dI7gC2LaJA/sWDiJU3DsntgPYUZV1yfFL5GhyXrWhfq9kAIfDzwBr02kKVL4bb
	aYPdM/VXQg5StE6bpnQyZKv9h3chIeXeHDMR0vzZBioLG61s5GXNFELaTCqkWESpX5LV2ftOv1X
	UHit+30T1d4ieaPY0P2dbU6VpfzmyZcGrEg86mwolCxXYDH4mKkHtUtAPQx+lJFye5PG1Wbl68s
	+BRYDiFZsqKChGzd51Kdr5ZhaMRFlXGV8/tplxHQqbQweW3odQZ6gBUajwYFsM1ytb0sdqyTCRl
	JWVnCk10eOQM/8tNJOVEB7phcMvHewyx8rehSSPytz1EtwLsh35G9WO8cbNrP81kHLQYQSrmUpE
	EkFeShAZtlNhlzKuhQz9eVORGmaYjM7/7/axdJwaPMYzuldLdkS1NAE35lAjt2FIUkcXNI
X-Received: by 2002:a05:6820:616:b0:67b:da6d:1670 with SMTP id 006d021491bc7-67bdaa8543amr4331600eaf.67.1773500367950;
        Sat, 14 Mar 2026 07:59:27 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67bc93065e7sm7303137eaf.9.2026.03.14.07.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 07:59:26 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: mark known and harmless racy ctx->int_flags uses
Date: Sat, 14 Mar 2026 08:58:06 -0600
Message-ID: <20260314145920.86796-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260314145920.86796-1-axboe@kernel.dk>
References: <20260314145920.86796-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12677-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 20C8028D959
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

There are a few of these, where flags are read outside of the
uring_lock, yet it's harmless to race on them.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 2 +-
 io_uring/io_uring.h | 7 ++++---
 io_uring/tw.c       | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index bfeb3bc3849d..fb5a263706be 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2242,7 +2242,7 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	struct io_ring_ctx *ctx = file->private_data;
 	__poll_t mask = 0;
 
-	if (unlikely(!(ctx->int_flags & IO_RING_F_POLL_ACTIVATED)))
+	if (unlikely(!(data_race(ctx->int_flags) & IO_RING_F_POLL_ACTIVATED)))
 		io_activate_pollwq(ctx);
 	/*
 	 * provides mb() which pairs with barrier from wq_has_sleeper
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 5cb1983043cd..91cf67b5d85b 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -470,11 +470,12 @@ static inline void io_req_complete_defer(struct io_kiocb *req)
 	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
 }
 
+#define SHOULD_FLUSH_MASK	(IO_RING_F_OFF_TIMEOUT_USED | \
+				 IO_RING_F_HAS_EVFD | IO_RING_F_POLL_ACTIVATED)
+
 static inline void io_commit_cqring_flush(struct io_ring_ctx *ctx)
 {
-	if (unlikely(ctx->int_flags & (IO_RING_F_OFF_TIMEOUT_USED |
-				       IO_RING_F_HAS_EVFD |
-				       IO_RING_F_POLL_ACTIVATED)))
+	if (unlikely(data_race(ctx->int_flags) & SHOULD_FLUSH_MASK))
 		__io_commit_cqring_flush(ctx);
 }
 
diff --git a/io_uring/tw.c b/io_uring/tw.c
index 022fe8753c19..fdff81eebc95 100644
--- a/io_uring/tw.c
+++ b/io_uring/tw.c
@@ -222,7 +222,7 @@ void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 
 	if (!head) {
 		io_ctx_mark_taskrun(ctx);
-		if (ctx->int_flags & IO_RING_F_HAS_EVFD)
+		if (data_race(ctx->int_flags) & IO_RING_F_HAS_EVFD)
 			io_eventfd_signal(ctx, false);
 	}
 
-- 
2.53.0



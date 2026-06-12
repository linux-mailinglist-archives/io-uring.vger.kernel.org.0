Return-Path: <io-uring+bounces-13685-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id wLfvHW50K2qr9wMAu9opvQ
	(envelope-from <io-uring+bounces-13685-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 04:52:30 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C2F2767655A
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 04:52:29 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=sTLJJqkx;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13685-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13685-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9A0A632AC18F
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 02:51:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60BBF374E57;
	Fri, 12 Jun 2026 02:51:33 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB173803C0
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 02:51:31 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781232693; cv=none; b=Be0TbI8OKcBjnxE9xik7nV+gAqimFrTzQ/lTNvxMUl/2GsIFSTjwRK/No88Wq6ofKywkwKlhHWDkdY7t2COT+Tg4K0JtJ7SNok3Ib/i+ZNna1Z9+zVzjVuG2fGuyDVqJY2rNvNF8Ncr5hWPJ/jpc5i1laAlthfGMZWqO7HqL6Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781232693; c=relaxed/simple;
	bh=ivZ07m8LQLk6N+o92kN3EdWHTg430fkAjM7n2Fm9OEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4bnCinQlSy2O59GbvKRIKOxvR9g37ArjEsY1hvMlDldu3Qo9TPxSVnks8MTaijuh44LzRk9qwo31BKjLfnJp3W0URoEAu2Fa0AcH3omOSGWiV2/GO6oVPsGg6TId+p3w5MtB7Yt6TjKyoqGdep1pxJakH87O++5z/BbOl8/RL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=sTLJJqkx; arc=none smtp.client-ip=209.85.210.43
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7e6dcad6018so480059a34.3
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 19:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781232690; x=1781837490; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u8hHEX4yT1XfvUonRnxWsF8Z11QCRTVPhbCt7T49oT8=;
        b=sTLJJqkxHOUexKun/jvBL8BCX71fnY1qzSQcAC4JBDt2/xhD3RK08VeLG3/3sn52/a
         ksPA+JKUxgMLqGJ86+rI+CrKVOQAuUB6az4qfJGX4qNadFq045Zerqb2PCleqRbDFHrZ
         8ilIC9IcEc+servpxrY9uadb08un4Z/vRcGDnPCRPB1k0y50+hOXcYqpt4S9w4Ll0SQ0
         Rs0iiG/ks65SzdCebUcrESm0OjZVKYBrj7jWyPKIDL8YyAMOiUZqeqroQSG8k9V1aSTJ
         wNSq8+xJWhRa9jBtsSvn8WO1N5Z/jlXcIPQiWCSs95H16js1G/3GtcI7F2O14qHFn0Qj
         iJmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781232690; x=1781837490;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u8hHEX4yT1XfvUonRnxWsF8Z11QCRTVPhbCt7T49oT8=;
        b=qAV37pjNrAA73SuL8TmYTxDJelg/jfLuXDaBGYPBTOj+z6qeA8kEPoLysgiQEGs9oi
         34KlVeaCy3ahXawr4SaMn4YSU6Sg/IGLsVBaXAq6C86vfKkc7PE4X+5k3PE0mQt+qCI2
         EyTiW1C25EMs0NNbRMewV/inh0bh0ZSwavASEgvAOAGo1dDEQP0zMi+ZzrFPC7vXZUto
         mp6QeUm9N0BW8gT6y5Cm83Z/rmEehvLHxHLuj72eeawqQL6l/MKXCzGDB1KJR1nMpQBn
         QNrUGUdNhPtp/5+9ASFUQjc96e7f6vit6Ne8vQb7Cp/dazkEzkZNHvsCEo8NYRUMujVp
         u1lQ==
X-Gm-Message-State: AOJu0YzJqhlR1px/m6zyA6AILybE6EZgdZnzoIBP0U4z6Sgh42y99qhz
	XLrI5AMiNITMH93vQkuS6LmnWqtlZPC9iHA9NC3C+Q/xneE3DzoixZMoXTaNN0jGE7TPz8pbG7/
	3S+A7j98=
X-Gm-Gg: Acq92OEPLyF7hbCIw8u3x6hu0WXoaLDXS4e4XllGC6scs1PcbHoa4xvWSFEXfB0tOlr
	ObkgYHAk7S10iQ2y2ORHErSXWoxhPwjNOfZOQoh/fokhFQF+65ugLNaPtVesTcoo7sLXONWrknG
	1mwpHLEycZiF7lR0PnMFS7142cmQMVK3+4267taME3sdbl3rIF7Mv8RcuwKHaNRjelGB4fJ0GhH
	CdzGLRYPUB9JYRmVG9asHoCp3fzaWc8g08l/pO6DEYJKwbslAwMXX45dvUeIJuzsJPW4lcny+Xs
	1P96LFBfPtdOtvEZn0l8U0x0PubM/tbhi7e3pXHKhzKUxgxRzxK+kYEuiN5VOhbkcLUoqxMZhrN
	7QKD9Ll+WJnGaAoyiTka5bw5Nswcx8PV6ycmD6C868OCEU6W5Vson4qxP5Vb4Z1J0q32ILELkol
	4s3MKb++D7t43WkVDR8EpYv+w7Tb2XDTefVkH32zJGFCeAiDirIWwxrSXfIK0OjxMqor+U
X-Received: by 2002:a05:6830:618a:b0:7e7:aac:4cc9 with SMTP id 46e09a7af769-7e7846ec39fmr666458a34.3.1781232690352;
        Thu, 11 Jun 2026 19:51:30 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e781734190sm862128a34.19.2026.06.11.19.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 19:51:29 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: dvyukov@google.com,
	csander@purestorage.com,
	krisman@suse.de,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/6] io_uring: grab RCU read lock marking task run
Date: Thu, 11 Jun 2026 20:48:27 -0600
Message-ID: <20260612025125.1690253-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260612025125.1690253-1-axboe@kernel.dk>
References: <20260612025125.1690253-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13685-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:dvyukov@google.com,m:csander@purestorage.com,m:krisman@suse.de,m:axboe@kernel.dk,s:lists@lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,kernel.dk:mid,kernel.dk:from_mime,kernel-dk.20251104.gappssmtp.com:dkim,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: C2F2767655A

Not required right now, as io_req_local_work_add() already calls this
helper with the RCU read lock held. But in preparation for that not
being the case, grab it locally.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/tw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/tw.c b/io_uring/tw.c
index 023d5e6bc491..f4335c8d50d9 100644
--- a/io_uring/tw.c
+++ b/io_uring/tw.c
@@ -158,11 +158,11 @@ void tctx_task_work(struct callback_head *cb)
  */
 static void io_ctx_mark_taskrun(struct io_ring_ctx *ctx)
 {
-	lockdep_assert_in_rcu_read_lock();
-
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG) {
-		struct io_rings *rings = rcu_dereference(ctx->rings_rcu);
+		struct io_rings *rings;
 
+		guard(rcu)();
+		rings = rcu_dereference(ctx->rings_rcu);
 		atomic_or(IORING_SQ_TASKRUN, &rings->sq_flags);
 	}
 }
-- 
2.53.0



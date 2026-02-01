Return-Path: <io-uring+bounces-12011-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GGskK5PDf2lvxQIAu9opvQ
	(envelope-from <io-uring+bounces-12011-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 01 Feb 2026 22:20:19 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FBD1C7451
	for <lists+io-uring@lfdr.de>; Sun, 01 Feb 2026 22:20:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8B8F03007E29
	for <lists+io-uring@lfdr.de>; Sun,  1 Feb 2026 21:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 072992DCF70;
	Sun,  1 Feb 2026 21:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YatxhdhD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D32520C038
	for <io-uring@vger.kernel.org>; Sun,  1 Feb 2026 21:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769980811; cv=none; b=tiixabUpV8hz7LlNYRDf5i4IWAz0y03yZsbNAUXcW3vtjma0c57ujHKpX64/ho5sVetU2D3gwqimBV+JVJ92IwE4Nq72LO7ZcpPi9MBrwozxQqI+gaI0n04/21O242abJcgSxyi1bdNu22Xag4egnTxtqcKKA0iieTzFlDtcL10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769980811; c=relaxed/simple;
	bh=w9bXIFUK/voqwE/CbztC+pRGOkCHpgqMxVqTnijLUg0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dBIVUZttuu1pFzE25CRI6b9zCsktVSEnWRcFLW3ILCqaPs4Vj9jmduuNCLAhfJgxC3nbAlYdwyppZMfOLWEsz8JT2UaWWX77+tS8s0cKqJq/KJ1VWrBk5EGNSTxmDHx+vlIk7wIiufX7wUJneYpJaXK6FQ5G2SwLAgGHmPh4t18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YatxhdhD; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48068ed1eccso34189335e9.2
        for <io-uring@vger.kernel.org>; Sun, 01 Feb 2026 13:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769980808; x=1770585608; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yQPeVhxyJvaj92kOf8274ETVzZ9axgBQSCCHTjUHOe0=;
        b=YatxhdhDZSFAGi43OXxbPvz2BvmcMcjzM9G8T9ggtBkZlieTGWQOQk67FCkEgyQRL4
         LHOV7/lnzhLGIz7e2gfMsorpvxqJU0P5T53ppeEJIbSuo2nrysQSWro/vT/hY1Q5wSjJ
         nkO/8x2aw7JXWlZu/UE0XbD+i/zBgLl0v7U1BbWLbPKx02mOFEoVNhp+iTCzYL3kCPFS
         MZmtKOfSPK1KhZz9rVvActJnYbUk3nKLZdsYBo+FloP/hWrlUs4PnC5Fr12+a+ona25T
         Bi6Tc5NKHEtnyi2guwZ0QAPu8CDveCGRIHX+MTGCKJK+M+iszG7GbQYfdGo7g6CFdtNa
         S06Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769980808; x=1770585608;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yQPeVhxyJvaj92kOf8274ETVzZ9axgBQSCCHTjUHOe0=;
        b=w3Aa+07GfwBhvqkAjwW+kMWZMHVNJ/pWYqey/xci7rRgsBtLKjebIR40EqvjeQywpf
         CCmsPYOTnPfhCAbObFumy2YeWXawE99CkJuWkgDJQKAItE0A0ol4GvzQc5C5YbbxvqJr
         +tV0dVwysNOCASP7/LHhGZEkieQLLk44p6UU6Ruq2Dt2stwjRh9vPV8wtjnsxK9s8ICE
         YsTCRWZNAfJWoofu2tuUgl3H5MZrkQzZYjrf2gSVrCVpIy6GQVXSqEX8L2ZbtrJV+5lO
         8D4/5ZsWvikF5CeO97VgNxjbEzhb9F+lfD0gI2suO3mMDubhKcBBkFs+psOMQgFMATFZ
         awgQ==
X-Gm-Message-State: AOJu0YzzRMGFtoeL6ubWCwIceaAck6nGqRqb7WsZhSf2xTPm4sJyrYaa
	dRJxz8pWl827r+i8Qj5PnGBPYnf4KbliiUfQgqT880JrjT1D518qjJNWNK6twA==
X-Gm-Gg: AZuq6aITMicNQifFrggIjxzDSNuyShJOS4GNgg1yARRAfZWf2WuIP9e3irPyYqEbye5
	VqO3WIyUCp0/5QfBWD+tgZeOmBaOQHYdkhMYc4spw2b8WKubm+URS2LjBPFdwI5Dp59mbuFfDLW
	Q5XcXKQC7srMnS6oEjevhYd/ThVfn0G2IOULMTGuBw/N2Yn6zeUxHoxlBSQQ3bLT+/FwdjtO9pn
	djlNagVkcRjUJ2lNO44aeahSKV8MnAa0stQrs2r5WuQVjfSWbUtXRStx6rIJAB9h4eeqAXNLvc5
	1glvYFOm7bnyQiGfC1mSwWJe1VVe3k2+cETxgolRv+VGAu+/xdcJLLIWBDyvnmyVsmBTk86mM/z
	iu4NQufnqIwglZxBvQbUju1zvv/981IEPkZOQDwUBTITRn8BNcC52pMn/0w+o+fpHotfU3EnkI/
	B5SotKl68XxlbMXWHPCRuuSQvugVu9Jmhf29ir4JOkcYQqjyxyGkjBDmhdsTNIggL3CM28CNFLb
	BknmIT8WX5bAKeX2A==
X-Received: by 2002:a05:600c:474a:b0:46e:35a0:3587 with SMTP id 5b1f17b1804b1-482db48e828mr124303785e9.27.1769980808341;
        Sun, 01 Feb 2026 13:20:08 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4806ce4c3d1sm366369545e9.9.2026.02.01.13.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 13:20:07 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring 1/1] io_uring/zcrx: fix rq flush locking
Date: Sun,  1 Feb 2026 21:19:56 +0000
Message-ID: <634b9ef89352140259494d6d08086aaa30a72e02.1769962683.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12011-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4FBD1C7451
X-Rspamd-Action: no action

zcrx needs to keep the rq lock for uref manipulations, for now move all
zcrx_return_buffers() under the lock.

Fixes: 475eb39b00478 ("io_uring/zcrx: add sync refill queue flushing")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 0c4b339f712e..d8b6db456bd7 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -1097,8 +1097,6 @@ static unsigned zcrx_parse_rq(netmem_ref *netmem_array, unsigned nr,
 	unsigned int mask = zcrx->rq_entries - 1;
 	unsigned int i;
 
-	guard(spinlock_bh)(&zcrx->rq_lock);
-
 	nr = min(nr, io_zcrx_rqring_entries(zcrx));
 	for (i = 0; i < nr; i++) {
 		struct io_uring_zcrx_rqe *rqe = io_zcrx_get_rqe(zcrx, mask);
@@ -1143,9 +1141,11 @@ static int zcrx_flush_rq(struct io_ring_ctx *ctx, struct io_zcrx_ifq *zcrx,
 		return -EINVAL;
 
 	do {
-		nr = zcrx_parse_rq(netmems, ZCRX_FLUSH_BATCH, zcrx);
+		scoped_guard(spinlock_bh, &zcrx->rq_lock) {
+			nr = zcrx_parse_rq(netmems, ZCRX_FLUSH_BATCH, zcrx);
+			zcrx_return_buffers(netmems, nr);
+		}
 
-		zcrx_return_buffers(netmems, nr);
 		total += nr;
 
 		if (fatal_signal_pending(current))
-- 
2.52.0



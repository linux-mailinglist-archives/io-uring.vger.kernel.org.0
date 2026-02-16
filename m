Return-Path: <io-uring+bounces-12241-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yNKoJTkEk2nF0wEAu9opvQ
	(envelope-from <io-uring+bounces-12241-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 12:49:13 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F0C7A14320F
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 12:49:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8B19C3011C54
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 11:49:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 520F735965;
	Mon, 16 Feb 2026 11:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eoAzGQdS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6114303A12
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 11:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771242550; cv=none; b=WXT0871F67WDrF8DV37wN26A6LzhI8ccMuakEO+sr9Gs29xRXipyTPFG/XwfVQzoAWg2Yc8Qhka/dWwHkfkJ2ETk+Um2Ln7D5hXrJio/pB1uvp3vcNTF4aeYbSFwiF8qq795RYzTHERyrEArT1c2yLlwGdUc6n6EtVpT8DIymCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771242550; c=relaxed/simple;
	bh=8PoHTUjlAo6oT9rwFIaf4c3DuUp0UnKS11rmeMea2wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dk0wec2/e9juY6ef582hbQkjXLtX8uxRuNoRCf0FBIyYEYSancPuYoabgA7PidvjAS67QmNqL/nq+DgfK2f3ZEqIcy5J8Ex/su+yGZsd8l/og1clv5THna/F3FqRC+7Dup2i/3rPwcBMo2+rhJbJL3gZqWSqrkre1sCbjSdQKiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eoAzGQdS; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4359108fd24so2097100f8f.2
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 03:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771242547; x=1771847347; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YK0hevINZxyIADYTBtncStm5huZwZo9MPdWAp5uCHeQ=;
        b=eoAzGQdS0Ak8n1W/0KW0yHE3ds2AALELGhUWMqagATPb0tzsknE6B7AGh4t3/z2FQL
         CyGCDyMgaukAwd3N6HymBO5oc9pc03vgICwF7FXszqRhxtVqH1EnM/gT7v6Prs73qezq
         Zh5aNySnr2T9TjIUgzZWiK4radcs7ZRH1gQC/bF8qfswQ+Crfr7AqPDSZ8WjzjwRZ5xL
         H3cLRm8vtfv15Dpak0RztRf6x2387/qUMkp5CJ5vtr4C5ap4iwYilF7HI5K5ZKbSIe3t
         6NFTiVuXRcuXHCTVdtVB/lbpBc+YOsXNJ3nhrkpSwo8ovny05QBiAG9hVXHVc8w1NRI0
         V9sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771242547; x=1771847347;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YK0hevINZxyIADYTBtncStm5huZwZo9MPdWAp5uCHeQ=;
        b=S0DUUg2u7fFhWxrnEH7UstsK8SgQdndDodMCqNbBOK6A6IPzPI4bLdqB/7NxzULZrQ
         X5O9eAJKo+6/npcEw+VevrGNWzggQVny7CKy+o5zOHYEdvPjWJblLSQp8DACWUSav0EK
         XBnN51pDTmjxPBRu2+jS2RtnrQP/Y70QUJQCsZ6BGnf3L6WUPzz5DVGberDA54/J80hq
         6df4g8dHAz7myYLD/oCmg98tyNVHQR7AIo1fMHEbbqJNTDsIf3uGSeVknipMx5E/rpTP
         2Uw649tijD331i4Eozb/Xj2N6N22qtJtrWBfMnui0/uODflWnj418BUuGwM/2LBPGpFy
         l2sg==
X-Gm-Message-State: AOJu0YxbsH5mlpozQDKSp6A/kgTC+r00VU8kxNmAwemj59kmhFGb46U0
	W+ke5pDHPv+FA5KZnH4BgyZnCa3zBQkzMiPkFaCLbu85O4wxYXh0ZTMkudCnpA==
X-Gm-Gg: AZuq6aJwpitNoZ9EIim1eKEf4iQiC5IcB6aolS8qYkW2rJgI/+DhJbTHBTHKgpUFI4r
	Rm5G1k/646YMFz6C5KlyQOuHLIyQxHqENyJuzvijr7sqZQFq+SvEnqZLY16eyJhlU1xSy97B1lN
	7ib6zv69pWZaIEiY2j4Toih/hDBaFQfB9efni9oahsOAkvBmxcABIv+qF2BuiuoXLNeM0U3HjVk
	Ws3llZ6ECdxaeFaTrKmAQCSYz151Zlo+Kpnf8Lp+erQvmrnsMh3qAlUaL7GIaygCD7NfadTfpUb
	k56bjMhPtzVuo9oCfNfTuaHNtg52qqsaZG5QZm74dqH4hBysMYxR/PkwG1w4p4r87Eh2jqqTREC
	CC2QqZOZNOKhSJxU0O4+H7olxFPxR7Yvdf3G73k/0J+m5glxjS+TRSBX8a7oGYwJjSIh5OVa6tq
	gN4a1dwm0gVub469BmBzNkb1TZHYmTRVAdQRinEIuqBI3pVmahR2viNvI7Teqy0Vb42n2KnnpPV
	oqP5OPQ
X-Received: by 2002:a05:600c:4688:b0:47f:f952:d207 with SMTP id 5b1f17b1804b1-48373a37a1dmr151061415e9.19.1771242546545;
        Mon, 16 Feb 2026 03:49:06 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:c3fa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483801ff9b3sm150756725e9.13.2026.02.16.03.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 03:49:06 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	Dylan Yudaken <dyudaken@gmail.com>
Subject: [PATCH 1/1] io_uring/zctx: separate notification user_data
Date: Mon, 16 Feb 2026 11:48:52 +0000
Message-ID: <d099d8d0d7526e4eb59f5ffd0e890888a46b21f7.1771242479.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	TAGGED_FROM(0.00)[bounces-12241-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: F0C7A14320F
X-Rspamd-Action: no action

People previously asked for the notification CQE to have a different
user_data value from the main request completion. It's useful to
separate buffer and request handling logic and avoid separately
refcounting the request.

Let the user pass the notification user_data in sqe->addr3. If zero,
it'll inherit sqe->user_data as before. It doesn't change the rules for
when the user can expect a notification CQE, and it should still check
the IORING_CQE_F_MORE flag.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 7ebfd51b84de..5673f088fc1d 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1327,11 +1327,12 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_async_msghdr *iomsg;
 	struct io_kiocb *notif;
+	u64 user_data;
 	int ret;
 
 	zc->done_io = 0;
 
-	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
+	if (unlikely(READ_ONCE(sqe->__pad2[0])))
 		return -EINVAL;
 	/* we don't support IOSQE_CQE_SKIP_SUCCESS just yet */
 	if (req->flags & REQ_F_CQE_SKIP)
@@ -1340,7 +1341,11 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	notif = zc->notif = io_alloc_notif(ctx);
 	if (!notif)
 		return -ENOMEM;
-	notif->cqe.user_data = req->cqe.user_data;
+	user_data = READ_ONCE(sqe->addr3);
+	if (!user_data)
+		user_data = req->cqe.user_data;
+
+	notif->cqe.user_data = user_data;
 	notif->cqe.res = 0;
 	notif->cqe.flags = IORING_CQE_F_NOTIF;
 	req->flags |= REQ_F_NEED_CLEANUP | REQ_F_POLL_NO_LAZY;
-- 
2.52.0



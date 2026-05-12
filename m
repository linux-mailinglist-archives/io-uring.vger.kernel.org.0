Return-Path: <io-uring+bounces-13279-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EPZhM2kBA2rdzQEAu9opvQ
	(envelope-from <io-uring+bounces-13279-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 12:31:05 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BD7851E953
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 12:31:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D25843084A4A
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 10:25:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5314C349CDD;
	Tue, 12 May 2026 10:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aZnD0tr3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27DA395AF2
	for <io-uring@vger.kernel.org>; Tue, 12 May 2026 10:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778581533; cv=none; b=S/Fkv7kdch8vj5Mnibm4FwdFhKCJGyAbjliL1oRH5lpaB174zlc2h2mgdTnVe99gfz37Nxq/i0Oa9GN1ZPRJy4U4vBfNlddw0HJM+J2rwSFllsiOJFtGcRQskVS27V4w2YmHDVrmQe4r83Ndu2ekqTxnxFbCOcNSGFYN9jPNrUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778581533; c=relaxed/simple;
	bh=Ig0Rm0l3tWYwnngupYRibeBBbXl6IALnesfeULDExOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYT9kotJJa4pBVvES51mLKOaotm3+cmOF+Wx2Y8YQoO9Ik3zT75wCXL5iC368ezT00rFcRkOoCrROl7SVzc/9FgGZaT69gcCBWv00M0HNGPQeJ9oQOZna2R0dGQMZQwgtbPly4h6uEmOu1UWlQ1UMoM5ldSrN5dJZei7oxPNw+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aZnD0tr3; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-488a8ca4aadso49176065e9.3
        for <io-uring@vger.kernel.org>; Tue, 12 May 2026 03:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778581530; x=1779186330; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rzD9Va0RuvonNeF0FpRZsFq6mTbQSj2d4JnlAEySAww=;
        b=aZnD0tr3OxrvXgkGbyeD18NTZjne7KxEw4bn5Kt9vU8n0qe/de+EfuzcKP83L6KCU9
         v93brpA/9OiocrwKgldHFo/0imiux/is9ANjxQtHnIisCLxLXH4wejGNB8q+X5vd/T8E
         4GZdEG/ec0YJRbwTFH0ydQsZ4LQIOVK673q4zAr7AU9VHzNXe7+hyNAbqn1lUei15BCR
         SYdz28cTOnHNHTyUMaLxKjRkyclSZ/7kmDa4+Lwk/20SJGfYNHz6J+koaHh6kz/Z2A8N
         pMtonUTHkY9QFUIN07EwiepZRm0qMCh28wTbzBpIZfilIl6eJurEBN8+JBs2NNfX6r71
         YtUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778581530; x=1779186330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rzD9Va0RuvonNeF0FpRZsFq6mTbQSj2d4JnlAEySAww=;
        b=cMYMfYpLFbjXH8oe+70MCntaV3jamMM8c2rwVCCpdSB8R4OU+M2wRKkWthgpKOoJ18
         ucDbdUBNqyDU6WOZaO2OMGIIRDghIX94RYGAkiVWMt+RoFyRcSPgvocyMsT/6N0qLZeU
         rrKBnb64XekU3QFtCkEjJh73Pb0mkvVQ2nqPBCGSx6k9rYecidFC5OGdWm5lKY8zldmr
         BPMyfsSROXFOQcMZOiMuM1nk5mXkbmSN8YkKJ3gMc3ADoOlLuCJUoTj/8o3lPAmgiGPr
         8jBNfaJ6caGOgyZco3JkHsas5jPygrgBBoyH5+eTje+YUsYmb2v/yqeElBeRtZE7/j2n
         bBXA==
X-Gm-Message-State: AOJu0Yx1AZ/cppZ9roI2CXgJUok4o8yph9KkbUdp+qeIimh9xKN5KYdq
	84/BRLs/x8NAKP8mmer1r16vxBlPLKetH2nvabXmv4obeNWpK4B+mlW8uIICHw==
X-Gm-Gg: Acq92OHueL5eaxeU8y8gRpkWDAYI/AKgfBRSoJj3Q5Gyr3bDRqkgoXIv5h09gGN5GW/
	OEmQ4FTMZYzD9RPA1L8qNc8WqHjxmqg/nNfKrsD2fgJMPIOnq/UE487UfJPHbf4ebp/N9Dy4BLB
	IVgZHU+dNYoBnesFp06gMnGxj4ML/aE1+u6msc4aF8gWHmSsXisRTUrgH18QLFEe9GW+K2trI02
	28AVMNg5dgV1AHTSJRWTiW2pJTRl03gNj2PWx3RVyx9alC7b6L3cnejy+8CGDsYEVRnD3rKn3oq
	TgucseHBWRRAH2sww6Lv933K2uX0gfHuxkOXdg35Fl50K8aRfWF87BqIi+VrEG8QWerSINYqdoI
	ZAVFC0LOS/qf16D63mg9IQBUXgDvZRmzfkBoaTw/lVMKUQFYfTkNx7EfisF/WHqnQIsRjmyKM7z
	DgxYDnjTu5iXK7yzDZKRUmvNdWQDyvVJK9SBMkmf0k78eyPI52ixIMAm5/yfJs685lHdOhHBE7o
	CBwCoBaIw==
X-Received: by 2002:a05:600c:4e0c:b0:48d:46a:6e5b with SMTP id 5b1f17b1804b1-48e51e19110mr465285955e9.7.1778581529976;
        Tue, 12 May 2026 03:25:29 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:8c90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e9052c9fesm74352255e9.1.2026.05.12.03.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 03:25:29 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [RFC 4/6] io_uring/zcrx: don't pass ifq_reg for for area creation
Date: Tue, 12 May 2026 11:25:04 +0100
Message-ID: <7ac1e9fbed1aafd31a654cd66eb64ddf50bf18c0.1778581283.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1778581283.git.asml.silence@gmail.com>
References: <cover.1778581283.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4BD7851E953
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-13279-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Action: no action

We might want to create an area without having an instance of struct
io_uring_zcrx_ifq_reg. Extract a helper that doesn't have the ifq
registration structure as an argument but takes the buf length
explicitly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 0ec491587a36..0551b05d53ee 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -466,21 +466,22 @@ static int io_zcrx_append_area(struct io_zcrx_ifq *ifq,
 	return 0;
 }
 
-static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
+static int __zcrx_create_area(struct io_zcrx_ifq *ifq,
 			       struct io_uring_zcrx_area_reg *area_reg,
-			       struct io_uring_zcrx_ifq_reg *reg)
+			       u32 rx_buf_len)
 {
 	int buf_size_shift = PAGE_SHIFT;
 	struct io_zcrx_area *area;
 	unsigned nr_iovs;
 	int i, ret;
 
-	if (reg->rx_buf_len) {
-		if (!is_power_of_2(reg->rx_buf_len) ||
-		     reg->rx_buf_len < PAGE_SIZE)
+	if (rx_buf_len) {
+		if (!is_power_of_2(rx_buf_len) || rx_buf_len < PAGE_SIZE)
 			return -EINVAL;
-		buf_size_shift = ilog2(reg->rx_buf_len);
+		buf_size_shift = ilog2(rx_buf_len);
 	}
+	if (WARN_ON_ONCE(ifq->niov_shift))
+		return -EINVAL;
 	if (!ifq->dev && buf_size_shift != PAGE_SHIFT)
 		return -EOPNOTSUPP;
 
@@ -550,6 +551,13 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	return ret;
 }
 
+static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
+			       struct io_uring_zcrx_area_reg *area_reg,
+			       struct io_uring_zcrx_ifq_reg *reg)
+{
+	return __zcrx_create_area(ifq, area_reg, reg->rx_buf_len);
+}
+
 static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 {
 	struct io_zcrx_ifq *ifq;
-- 
2.53.0



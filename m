Return-Path: <io-uring+bounces-12722-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iNn6OX4puWkAtAEAu9opvQ
	(envelope-from <io-uring+bounces-12722-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 11:14:22 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8975F2A7A77
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 11:14:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D45DB3011C61
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 10:12:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF2F23A1A5D;
	Tue, 17 Mar 2026 10:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lTupLbki"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703963659FA
	for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 10:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773742372; cv=none; b=KLuA5HvjUFRxxNNyCXXIgYFCzf6vQGVrFkDInAzDlpa0b0Lwe97vGGPJM0lTucQEw5CU8tf3289fFIRg/NMs79/Wpo7e2l+jw2Jy6ORwHG8XM2JiF4SMTtv4cTsSTINavfoemjyLpUwEwKEO+fhb+DDJoGIqmRZFa/vg00TTd+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773742372; c=relaxed/simple;
	bh=HyQSo0TiUBk7IUrV05za/XKotMei8+vYjSm81vs/6Mg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b5OAYv2fP1tiOqEOekkR6sRoQx6ub3WCQhi6aqQU8ksFnPnz8XwVQda8apRFBkJmoJp67vB0+eaU0GcXm+9EIsiLxMU4dCgsgtAJdh5oUwDCBr+hvJBlGuiH3HPyifH4XIvhL2UhQkbhtToe/EPDOTrNKaqTTMG1VMEkh+sit+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lTupLbki; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-485392de558so33058945e9.1
        for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 03:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773742369; x=1774347169; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bHz+9iI4VzLbOzR6bYk/i4nqtIvaNtEhy+XOMFd2gig=;
        b=lTupLbkiWcyP5oI4qhwdjCXYd7X0qigElIUYJyUWTPMEViCZrPFqv1Si9EWHYKBEsp
         4WYd0uQGCvKTYkRGBfHE0tfKtQBMAirry++fGU5yJqCuXV2UTAeg06R6jJkpR2LpjEA5
         8bDHwEBEhcntuUYbBfAaEu7UelEKFE4rfHaIZrnVG5dQc95laaBaaDG1cUA4UqNk60FM
         fSVQmjm3xWRy7/wrSjMhAeMCzqQrjwgkkoQIOpaYklqhgebUZ7pShJXJvsle+vSZvfUr
         9NQKwBgyArfv7vUjrO/cs6a2yrXA/auWxfVwAMZ4Gbfu1vRYC/dytHSNPd0DZjubcSlj
         u6Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773742369; x=1774347169;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bHz+9iI4VzLbOzR6bYk/i4nqtIvaNtEhy+XOMFd2gig=;
        b=OvnFx9lYMSfseLKrDHlbqdgmsBvFmpnhHS6xl5xRk3l8nAE1+m6Tz9G33OT9JZQTk8
         WdZJr5qmmQ6/hNevKPonhJeiUOAiX2dkhYjzFdHgVA/DGBNi/IRtncW0CTZ9ti5h7WTH
         bs2NNjUS/16a4wcQM2rSqj3K/lOzrcrsz0SUcwzS7V/BA7iqPWSn3rjxXMCK9Q9W5AEl
         mqf5XLb4xOxq45S91ZOumSFPAQ8/IocU7IPU8ayKIXQUvzT7+PnwvIw7rDupaMyqAMbq
         WV5FTbdzMc1XtuYjlcuw0iiF1G7c6RDzudrRbxr8Wmqm6YxW5WjKTCyx3cB6Yk6VnmxL
         PmRQ==
X-Gm-Message-State: AOJu0Ywi3JrCN38YoV7PZd/UEPdH5QtNJ3YYBWm6ePH4xvsBN3PAyDlK
	twUHkh7OZgJrOW+sxPwLqLhHBBZ5DNT2imktv+8Oaxlakn8KaIC/ZomDk1cqOg==
X-Gm-Gg: ATEYQzxwOaf7Pc7O0Plvp+6bmIlJOKDe2sBGImnL1ff5ETpBAvHtGw7D+mCHJTgw7eL
	UPTE1To9OABde2+XKBqlKxoMRF9p/d3ATB0H78ql6/c1EHgm0uqYlQXUSi520CCqOtHqpZWP24g
	wpMtPF3dWJYBfhMQ6/wOXzJ7OAq4fnQEflXZSvAeYpkRxSHfxDeAUGJhgL/g9EMUIfKdA247YXq
	XEe4VDhrZxJhF22/cx5dmPXVzBTQvU+9kpuBZB+BPKpb6lqSjr4TTOpp6NpB5sqaw25e9TwByw9
	HvMLP43ggDLVFPafiFjGD46FYS+FOBxIVzqENs9MsZWYQgEBkVfwsUco6dwGCUU7TR2sgMd70ja
	tDSqeQbQgsA0VLHaIh3Xj5AtYQriklr8HlhpO0QGm2gB2tCdh/nqvw5UVeOx5A249UwCLv/Fq8M
	JpzPs8bO4BbD5+Fk71/9UqDfkY4/r4PC9AqoL/a6IzU1dSoAxbgjJldVcmNr+5tlxcc/w+WLpBP
	9HVqaM4SA==
X-Received: by 2002:a05:600c:a4a:b0:47f:f952:d207 with SMTP id 5b1f17b1804b1-485566facc8mr272242305e9.19.1773742369040;
        Tue, 17 Mar 2026 03:12:49 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:f9da])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-485696a12d0sm46849425e9.13.2026.03.17.03.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 03:12:48 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 1/1] Update headers with ZCRX_CTRL opcode
Date: Tue, 17 Mar 2026 10:12:52 +0000
Message-ID: <f2e0ecd078f1b3c27428ea0921122d6cc0a2c6af.1773742334.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12722-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8975F2A7A77
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

We also need IORING_REGISTER_ZCRX_CTRL, which slipped away from the
previous patch. Add it as well.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing/io_uring.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 10497daf..1e58bc72 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -703,6 +703,9 @@ enum io_uring_register_op {
 	/* query various aspects of io_uring, see linux/io_uring/query.h */
 	IORING_REGISTER_QUERY			= 35,
 
+	/* auxiliary zcrx configuration, see enum zcrx_ctrl_op */
+	IORING_REGISTER_ZCRX_CTRL		= 36,
+
 	/* register bpf filtering programs */
 	IORING_REGISTER_BPF_FILTER		= 37,
 
-- 
2.53.0



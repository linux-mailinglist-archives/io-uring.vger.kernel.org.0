Return-Path: <io-uring+bounces-12211-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IB9vFcc6kmnUsAEAu9opvQ
	(envelope-from <io-uring+bounces-12211-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 22:29:43 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C8FEE13FC41
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 22:29:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 83A593036D78
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 21:29:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E23F72C11ED;
	Sun, 15 Feb 2026 21:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MGUuqp4v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940D12741B5
	for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 21:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771190960; cv=none; b=B1Cu7RADHOOCB3Ey2RbRVmR/IU66rYruHhnqxubVs7W3ji1SDoBos78a1RUOkUT8inibT2MME7UhssDuMb47/i3o3KtNQl/BprtYZ52E+GxOmzMxAJHFCMgfHdRB2CKqW9Kr1St2o9hq/Gtxguy+bJIpFAC0yAkPbz0YMrWWB2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771190960; c=relaxed/simple;
	bh=8B4rXAz9X0DmROqROTQqwmDddKFeM/oPYgvUCG7iZJM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jVuLbzP+E1s3x6meJF46avFWrvBJa6jkGk6ZocRxWitwl3TFYdoV9FSOl3LoG4uoH9cQIqWYpSWJWEJO0dVAijrHw8KijyYgFGz2OAeqn/DHUXsSDFgAE8XWTrADQwoSIX09hvlzzBtGoG3gv2n/EK+00LvdLBD+zncJ+QLkE90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MGUuqp4v; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-483487335c2so23332855e9.2
        for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 13:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771190958; x=1771795758; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mWyuroIb5nKyvTV5TUC4bt9dw2HBcrZYzowX9Pd+2cg=;
        b=MGUuqp4vL9PksM3ghlxoGbDa1R8WKusiky56oEWNv72184zLM1/uLg2T3UHVFiXHK/
         +VTH3wtgtCF1m00R2zGwVG8f6EsGdNkpnaq1bgtuD2EKYsk+a7waBT+x0kT1A2YWQmT1
         KxR3MydEuNc6QB0l4NyUCiMJbqPkLPFIr2XTeOIoDPsgly+suPxwnaqtMSkpAftXT9AF
         qk+J/avKtbH+BSTH1orn0CWajoeeJD5cNSN9iE1L9kV6Y0ZZXAWt4zA777aIARh2kuRL
         XXdMnjKVGKk7awaAfC9GAvVcycObVJaY6hBeXJ6td+FAxZl8C1S5gUbEVwilVfOUAPd0
         ifDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771190958; x=1771795758;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mWyuroIb5nKyvTV5TUC4bt9dw2HBcrZYzowX9Pd+2cg=;
        b=GarlsAxZImtqr2tNmMAhOXLGrjJxPZrwyG8RiTeQbJ0kpFpuMOsjxwSdw2a9kgbaPp
         i6+6yYWbUOTMI7TG29A9mw/TYKwR5I+f3l8EU3oPMkt+g3lKYfF5XI3dm75VuTBdRs50
         XtGTDUFIXmYTv1Q4JfN0vI62uK+THTATb9qT+WNobGZEU7QjCVDVM2ly4DM8oWIugF0P
         e4F3JZfZBxXjfDPdpLn2bQeGD2Is3wyq3yZOuLW3aKXO3OeA632Jfbfnoko56EUunLjM
         pcmYiufBnX5YqU1JmWwJc9ZXDtEe+d7PlTq/+c2LG8T0O0BuTinSedqqqNApitgy/de/
         YzhQ==
X-Gm-Message-State: AOJu0Yxh8TY/VZ88veI0D9JMFjQ1qbuz70arEogMxrk1Lcqf3qQRZbtW
	Y0X7OlUbhjQlHGNvDKTaIZOWNJhXUhLy4QOfrNlvgCwIeG5BvbQl70uLqgXX8Q==
X-Gm-Gg: AZuq6aIb188yTZw+VfMYSiN9/tDkKm9jiZj5OA/TiSmq41M/D/eGPTA2l48Bl2ClsER
	4JCn8YdvoZ7RDwBfUZytdGU2WrqkW4hxpT3tsyuwPCXpo83re6H7+bVr4S7iI0vFv5I9JtaW66r
	f7eF3MtqCPNklmfMFM1urmHli9DyxheH0JYYuSTLuny6QyVT07LQGhBQJylAOb9cqyoyLw9XajI
	P4z4Xaw0SY9s3ullThaQQUR7NzYx4t33c+VqA3WajJpU+w0ZubawcTxqknDiMCG7NuSkd3H96D6
	hcZmfgQxigsgY6heOBK0IThYXANItZFwMjxL58kXSNHT7b3OlIAdX9i3NjzGHgM/5YD1S0u+ZD+
	t2HYYhoeP6Vv7fp/zKq6aK48Zdz4xLh3iIO9ppj3GPbs2KEdvOIc2M/muyNZuZB57j0cip2dVaI
	O4+t1zgbLLf/WBpxIYQ+cF33OYDs+fwOFSK8NTT09x35lPB1oyNSh6fJyhPOD3/Nql/035vPmpp
	H1ElMk2lZeMpYm/pBRgopN5xyCcLdyOk0RhNqX0
X-Received: by 2002:a05:600c:a43:b0:477:89d5:fdb2 with SMTP id 5b1f17b1804b1-48373a0808amr131695255e9.14.1771190957421;
        Sun, 15 Feb 2026 13:29:17 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48371a409a5sm66790415e9.26.2026.02.15.13.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Feb 2026 13:29:16 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH 1/1] io_uring/zcrx: check unsupported flags on import
Date: Sun, 15 Feb 2026 21:29:12 +0000
Message-ID: <0e2e7c6211f2b40fb830f69f1084f0a3948bf2ee.1771190842.git.asml.silence@gmail.com>
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
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12211-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C8FEE13FC41
X-Rspamd-Action: no action

The imoorted zcrx registration path checks for ZCRX_REG_IMPORT, as it
should, but doesn't reject any unsupported flags. Fix that.

Cc: stable@vger.kernel.org
Fixes: 00d91481279fb ("io_uring/zcrx: share an ifq between rings")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 29ca1d897be9..13646d09885c 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -702,6 +702,8 @@ static int import_zcrx(struct io_ring_ctx *ctx,
 		return -EINVAL;
 	if (reg->if_rxq || reg->rq_entries || reg->area_ptr || reg->region_ptr)
 		return -EINVAL;
+	if (reg->flags & ~ZCRX_REG_IMPORT)
+		return -EINVAL;
 
 	fd = reg->if_idx;
 	CLASS(fd, f)(fd);
-- 
2.52.0



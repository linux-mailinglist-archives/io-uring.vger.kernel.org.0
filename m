Return-Path: <io-uring+bounces-13212-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CF4hD48M92ktbgIAu9opvQ
	(envelope-from <io-uring+bounces-13212-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 03 May 2026 10:51:27 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A334E4B4F6A
	for <lists+io-uring@lfdr.de>; Sun, 03 May 2026 10:51:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DA66D3005ADA
	for <lists+io-uring@lfdr.de>; Sun,  3 May 2026 08:51:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B2532264A9;
	Sun,  3 May 2026 08:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="S1l7tejD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC98F276038
	for <io-uring@vger.kernel.org>; Sun,  3 May 2026 08:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777798284; cv=none; b=OKPkca7ac2kFsA+muGcCxJ3XQHIiBJvzgSJltN6YfVhTYuwONq7VO9LDN4JiZAgf4bTlc/g+xhBzkJb26MXEVNUQ/Ag9MX8JfQLD52igqs44Ya2lW99UgNny4efyYSsU3srAr61Jb29bGJuURalKHrN9dOR7nSZ/FomyyhIa2xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777798284; c=relaxed/simple;
	bh=Wiq9lP0tzpEoE5QlEr4KHNnVpar4vwyHcnLPSe9Qvwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPJtNlnQ9sU6EeS1l6wKi7JPJg/iGPLUFJFUlQNAHhJBOMcgutAQwnR8Wry11MgYaMhuIvCes4qz3migNE3dyPCnK26sWJ3pfNdFSRIRqI9Ciq9BTZ8LQcsVvQEz/GiPaGetRaBN9dHNuimZ/MQWnYfhnL1YiOmxhvc5A31nn3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=S1l7tejD; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-67b6da5a618so5315505a12.2
        for <io-uring@vger.kernel.org>; Sun, 03 May 2026 01:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777798281; x=1778403081; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NPStkFVZLm+jjZLU/tsX8K/9LVqR7jsD8fjKsI4ziHo=;
        b=S1l7tejDCqZy7hPtvyPTAL1gWR5pelGn1vasG8wA6ASGGSlLlFFU7SPKFkNN88gkqd
         xzaSupf0igx3EOsi9yfTjZW9wA+NeDKJtbYlsKj6doUA6CVBQrbqBl30nUji0O/Wz9Hc
         kEnRHZZL2vHmh8JDG7uzueveTJOwEugY1Oqjp2PAJ9aFCBc9Goex0Wdgw7SMOWjCYZum
         Urt9VzabQpSB7uQXIdTY/jw+uK4m2tO2fe3nXXkGHjpOyWq+3tL2omsJm0n7LnLx/xdm
         KefLT7ornsp0TeNG/W/09RV8/pUVNozF/8jabgBaopoSU4Xxi6gPvJhYDD8Hd/5rjUTn
         rWPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777798281; x=1778403081;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NPStkFVZLm+jjZLU/tsX8K/9LVqR7jsD8fjKsI4ziHo=;
        b=q/7EOXRS9oBHpTki9SNZvRKGEpHN358yetdXlCpmXbTyWHfiXQasWEWTf+vKm4csFY
         uyq6dbtNlXIGro9dnislhrihjkD58DgN9xMugG3HrtOSehnjoqUmfGhd26DW9NcZo4XM
         Bu/kw3AAakegwuyxp1Ll3uTMD/HGyywfTJSur4LzshZlQ76y6sQCtpcJjZqjI1a3+SU9
         dQiFYAuq/+qPMtqlngecU6/aTe9AiC85YIBGyXMeeALv8T/r7BvbRZFeAY3PWiRKQmPa
         KAXa61UPoaqZxL8rI5YNNsnUIojXHqkiT5ddUG42vpmQ2EH0PB0rFcu6mzFxitNNItjh
         hWUQ==
X-Gm-Message-State: AOJu0YxNji5XMihms0KdQEAjJkMS5Xfb6lW2wH5o+i5npb4BWJUcF9Y9
	GF7YirezJMm0o4T3e9qtYmm7eRBQPKprBi5NogIKb77zULWRJ0Bu2gsGvey4Ybmmue+8Ftd9ydX
	7h2PXsCq3fA==
X-Gm-Gg: AeBDiet/sOf4tmwtyIgTj58FM0Bp27TXQQ6/m7U91LnYcmTz/XSxuJk165xcSN45PP0
	w4vB6MiMAHxWhoj6k4A9qmcFxbvJ7idfAIuEYiaVsSAiaTMMiPWnXcbnhyAT562BFKQ6CayeEPf
	ByoT7d2yP7LDDuqXeyYiK0j99islQkHl+r5IJQ2HT3rEuOE3WTrtHvVUXMvBXESiKR6mTsI34AQ
	mDmCOIC5f62FerU1zY4fmo1lcDPUnKIKOkxkg2YeqK6HOChJyB0BxzLFmekY/jzCHzKYFaTGRhf
	1Mzxfi278Fj3xENnoCZ+jyW/FkrSdySVLbEEsBoCnB0WbuHUJGxzjp2+TMYT8v83ZvaZRKXe+BR
	TsuctL5niV/pjzc1IlDsLYHQQWkdbgs+XTwzXLN7XtSxEp18MO9Ya/BpUSxrOgsEBmeJCIeZE0+
	8j0eVSMB9CIef8Y0rvyaQAPm6BAhuj1UqNeB38uzStz83TGIeN/ctWBMKZA5nAKzcbrvbtCfaSk
	/eQ5fBi4Q==
X-Received: by 2002:a05:6402:1515:b0:670:b72b:4044 with SMTP id 4fb4d7f45d1cf-67c1ada377bmr1570637a12.15.1777798280726;
        Sun, 03 May 2026 01:51:20 -0700 (PDT)
Received: from m2max ([77.241.229.232])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-67b85e292c2sm2368936a12.1.2026.05.03.01.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2026 01:51:18 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring/epoll: switch to using do_epoll_ctl_file() interface
Date: Sun,  3 May 2026 02:49:15 -0600
Message-ID: <20260503085101.112698-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260503085101.112698-1-axboe@kernel.dk>
References: <20260503085101.112698-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A334E4B4F6A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13212-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel.dk:email,kernel-dk.20251104.gappssmtp.com:dkim]

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/epoll.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/io_uring/epoll.c b/io_uring/epoll.c
index 8d4610246ba0..59cd4f009648 100644
--- a/io_uring/epoll.c
+++ b/io_uring/epoll.c
@@ -51,10 +51,21 @@ int io_epoll_ctl_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_epoll *ie = io_kiocb_to_cmd(req, struct io_epoll);
-	int ret;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+	struct epoll_filefd efd;
+	int ret;
+
+	CLASS(fd, f)(ie->epfd);
+	if (fd_empty(f))
+		return -EBADF;
+
+	CLASS(fd, tf)(ie->fd);
+	if (fd_empty(tf))
+		return -EBADF;
 
-	ret = do_epoll_ctl(ie->epfd, ie->op, ie->fd, &ie->event, force_nonblock);
+	efd.file = fd_file(tf);
+	efd.fd = ie->fd;
+	ret = do_epoll_ctl_file(fd_file(f), ie->op, &efd, &ie->event, force_nonblock);
 	if (force_nonblock && ret == -EAGAIN)
 		return -EAGAIN;
 
-- 
2.53.0



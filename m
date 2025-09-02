Return-Path: <io-uring+bounces-9543-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BA49B40F9D
	for <lists+io-uring@lfdr.de>; Tue,  2 Sep 2025 23:51:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B80D81B62267
	for <lists+io-uring@lfdr.de>; Tue,  2 Sep 2025 21:51:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BACF22550A3;
	Tue,  2 Sep 2025 21:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="W8xA81rq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f226.google.com (mail-il1-f226.google.com [209.85.166.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB2320311
	for <io-uring@vger.kernel.org>; Tue,  2 Sep 2025 21:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756849872; cv=none; b=F1U3VMAKZNtfR0YKqNLdxiKgzuRIx1WYNjp5zzwU4tWvTVUnX54BmFLvVtMQFwGfL7A794f8FrYoDQ/1nUcsX+oK7it+dkvw1m6YSRJpz+hi3Ot7ZVbWnXPcQThNGRFZkey4heTUDNAs9p3Kg8Qs5KBH6BR6gzz3gQZa3kFb0Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756849872; c=relaxed/simple;
	bh=PhgyBskIEFQnUD0P3UgbIXJw3q35eVbCgAjfy2fV/MY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MkEObBFAOCyOjOEEpjQDr8IgwSVKCqR3B3UX8+CKd3vGSHCHeLOuZq3fr0Avxiy1GwSi7gLDflDfetybXCnRP7iyLdr4hK3FGaGa32vHiN0P9V78Cwjj7S/0rlRIzZXAqPF7IUi4XSbJp90waMYCCfVDHJ1VeO7OeuyW4yFlyis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=W8xA81rq; arc=none smtp.client-ip=209.85.166.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-il1-f226.google.com with SMTP id e9e14a558f8ab-3e84e087634so3626365ab.0
        for <io-uring@vger.kernel.org>; Tue, 02 Sep 2025 14:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1756849870; x=1757454670; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BwJP/IZ7edcBdODnSS+hYoNQBKWq1HVWg/WApUUDlnU=;
        b=W8xA81rqhHuqcdr82ohvZKkoxv5DpLIUyrIEu7XE17G5CcZMrO7m/dN0+zDR9XPeCS
         l0vOGQkD6bn8GD8hGIs2VrvCj8iM67zvCpsZ4a9WJBH2CKjHhBjxPghPsgIxt/fH3387
         RlJJ171iRGzJJL+NWMXCWGsG1IjkjCDaLzuVM+xiGJC1hMLmRLLPQZOZGr2axv4X7EPQ
         her/lUa8QWxxj6NrrvOveyU5GXdStfJbQQM6AUwHZj3SMp5sUnSvLmeOq0n8In/nkk3s
         j/ovH1dgJP3FzbL18mqq5HxSLulrF6ut4gvwHtOfv8eFw2IbagfJrz0+aDvz3dv4einX
         U7XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756849870; x=1757454670;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BwJP/IZ7edcBdODnSS+hYoNQBKWq1HVWg/WApUUDlnU=;
        b=X9dgLWasXwPffijW2c9D5jFCemsJhUs2BfMRWx//UmqyLxMzYQxRLcQM1yrxEHO2Vq
         YCM6YEbFgZGGqQcHWFZ3Cat3Gay6Ayf0uvTthD27TX4NHkAlXbPrAiFfZ08IgSzFOfC6
         /VGHh6+vDM0N5MWLpta7ReYE5ecqA6VM5DdrDdDXmUurm0RTNb0FJ/B+hy7rOpADsTaW
         ko1GAHAXfhqwIhCKuyXuG9EoZmN/dTREVn9vulrwnGvZ9yoeHG2fmRpJ8IYz1WMmrECs
         qBTbeVSiXXjkB1o/eQVvMdKFK8W2/oN6knZ3RkDjBF8q/nBg4n1+EDuiidWPXql22eg9
         FtwA==
X-Forwarded-Encrypted: i=1; AJvYcCWpdLUeLsvZ34ZTJLdnL0C+T5b/C7ctt5Ma/hmny/HU/krifhFG8+EZdwnDUXQhUq3xmCKKVabzZA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2oZfD4BevTXuCoUiNgIje7mHJb7a5chmE0Zssj2+E4OmEgtpl
	ljz1m007WW9HjNPPY/YGCIMU+D1JhCcYZ4jUGw7mWuIhmFtMw5AGZ85SkQTxBmIxYH0A8FimYov
	psZfeGP7GwbB2+jYKldLIsVu9FEjH4YnclOyxqGI6+riw5ue7iTQh
X-Gm-Gg: ASbGncti/dqOklmXnwtWRaE5TWt3eRvmaXyBcRC1+a+TN8GO+yE8Vw9iGB2Lffr0F1D
	v70iVQ4/KexEJUXk31zNOkEg/WqgXSBLMNPQGooP9sB0sZVSt9GILqjZKX/BXNs1lr5rHfCEkG8
	+ukDd7XZf12NqOUK3H1WLAPls48Egx9I2SpbIhWNuXGktr0UjJ63iui0D5TOzbXGpTFFvb+qAnw
	2lZ/U83QzsDKqPZYRjwrjdzNlwada1CgWhMqXA33/9Ys7IcTEgpGkUOR/+yjotbb0+C9rDS1bnm
	vmT77Bkkv5pK0Yj0rMlkjBpdICUhztDsQI7hG3DGoj7lsGkoQPkOcqB73Q==
X-Google-Smtp-Source: AGHT+IGXGrDVgLYEPY3DWvVTQ6mI3JQb1xGTMbKSTJm7SLS6h82Apglk08N9OZ2x3i9SZUj1csjceovMtfQz
X-Received: by 2002:a05:6e02:1d8c:b0:3f1:a5b9:4a3a with SMTP id e9e14a558f8ab-3f3221b05c1mr95335085ab.1.1756849869879;
        Tue, 02 Sep 2025 14:51:09 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id e9e14a558f8ab-3f3deddbabdsm8385005ab.23.2025.09.02.14.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 14:51:09 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 5802D340328;
	Tue,  2 Sep 2025 15:51:09 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 4FBB1E4159F; Tue,  2 Sep 2025 15:51:09 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/register: drop redundant submitter_task check
Date: Tue,  2 Sep 2025 15:51:07 -0600
Message-ID: <20250902215108.1925105-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For IORING_SETUP_SINGLE_ISSUER io_ring_ctx's, io_register_resize_rings()
checks that the current task is the ctx's submitter_task. However, its
caller __io_uring_register() already checks this. Drop the redundant
check in io_register_resize_rings().

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/register.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index a1a9b2884eae..aa5f56ad8358 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -406,14 +406,10 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	size_t size, sq_array_offset;
 	unsigned i, tail, old_head;
 	struct io_uring_params p;
 	int ret;
 
-	/* for single issuer, must be owner resizing */
-	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER &&
-	    current != ctx->submitter_task)
-		return -EEXIST;
 	/* limited to DEFER_TASKRUN for now */
 	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
 		return -EINVAL;
 	if (copy_from_user(&p, arg, sizeof(p)))
 		return -EFAULT;
-- 
2.45.2



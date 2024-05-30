Return-Path: <io-uring+bounces-2007-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FBA08D4F14
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 17:28:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB6041C2442A
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 15:28:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BA7A17624A;
	Thu, 30 May 2024 15:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oqftRavX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD6917625C
	for <io-uring@vger.kernel.org>; Thu, 30 May 2024 15:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717082924; cv=none; b=ZDGCcayyTWRN7H11Ege9y4jIZHpkDd4GSvpb65tAEq8P7wOfh14fo5nobwSsxyGuB3Mtjsg+pwuBx3ht/vld46MzCTWEnHuTJb8kKJUSMX/nx70brDm+lltC0lxPc39egZAxmRRJLpWJ9ZN8OxWwP09iRFZ1rM/Uh+ANnY3KaUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717082924; c=relaxed/simple;
	bh=2fTRsBnz9AVyev+x2Mw9m3Z+5ustOqERm/bvZl6mXL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFRhJgTtT0EeNCNEwJZ9rmWksY4KV4cHkTW7o0rUN6JSrIbHddx6efyG63zbTzVOsQjQYOa/xXL+JlIiBzsAGg5Z9XnSxYtnhr/7lXOTpnQQ73lcvC8Xg99X076If7Ii6eaw4kRMQG/FpVburvUYPfqlxYY1y8xhuy+l9+Cp9vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oqftRavX; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3c9bcd57524so92407b6e.3
        for <io-uring@vger.kernel.org>; Thu, 30 May 2024 08:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717082921; x=1717687721; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W8MtRuHfTNaN4XZ7n4pXixV9Qfzo0rOmpWw0qaqWXrs=;
        b=oqftRavXv1XT+j3dcfesfMweekX1awcEInJZ/krPEBT9afCTUaFxJc+CGuYvXX3zix
         QRU06FpxAnrDcfcJ/wlBtTq9aAj8poXUfBFoLJ2kHEqATecJ+FPTwC+64bMRXBHGNv+J
         9OliSaIoIQX+p6QK3LFWIuFeJTEWRteTh5gY2Yq1Yp92WulRyAyZ4eG00JpbqtIXO+Y3
         oe/UPqJa+hcZSueUtDaNgTiHPY01BTqPXLjo6chCkkNweITClkUjAYNsVRrrDVig7g7H
         IvxsIDMdNvIshGLyKKrUg48n1dNBziij32JshQJnv5AX3V7cO6slw4MJBZVCbthJCbmO
         2xIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717082921; x=1717687721;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W8MtRuHfTNaN4XZ7n4pXixV9Qfzo0rOmpWw0qaqWXrs=;
        b=Vs0zfvrSFzbYLNnr0pKxhWsEvGvsMjMkp0GcQ8vUrXfu10CRvcDSIFArgVwpMlICrD
         wfA3b6D1awd+hw2Cwwx/+KY1hGAQ2173/QbcJrTGvrMabxLdsNmVKD87aL8l2d0ovXll
         jjb/PBBAYO4ot5hu8/h7BZgYP7INlYQXe1Gm0GHdLyoxhccOqMzX+4YpWEI27Xz9pr/r
         f2Jum8oetcMXNYt9C4QvPrS2onSIx8fBOYYNFDhSc9y/vqMvxCMj7YyOpUck3VJqo/1Q
         v9DHaZu+RRrI47qzHgoLASUTk9sHKtMIlN+omEA1Lqww7XgjRMOP0hQ0w9Lt6GKXZZq2
         FZXA==
X-Gm-Message-State: AOJu0Yx7usV0wE775fzRc5LoeHmS6ztIfslO5U1sr5xNIfdnFKFODkzJ
	8ozHFTdOCvCXhG+YC4Mr73vedQ5fWW9scvbv+F4jS1ISkJ1vJpepmMLmqWPo3xlPV0nZBgsc4Ce
	C
X-Google-Smtp-Source: AGHT+IF1F9ap2dy5VaM2608Z7NumpOJj6e8alrAV2K37UjbJJmJywaAKzrh+sS1le6Az/h4xoITKNA==
X-Received: by 2002:a05:6808:1403:b0:3c9:96cd:5bbf with SMTP id 5614622812f47-3d1dcc97a1cmr2998524b6e.1.1717082921368;
        Thu, 30 May 2024 08:28:41 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d1b3682381sm2008136b6e.2.2024.05.30.08.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 08:28:39 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/7] io_uring/msg_ring: remove callback_head from struct io_msg
Date: Thu, 30 May 2024 09:23:43 -0600
Message-ID: <20240530152822.535791-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240530152822.535791-2-axboe@kernel.dk>
References: <20240530152822.535791-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is now unused, get rid of it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/msg_ring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 392763f3f090..5264ba346df8 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -22,7 +22,6 @@
 struct io_msg {
 	struct file			*file;
 	struct file			*src_file;
-	struct callback_head		tw;
 	u64 user_data;
 	u32 len;
 	u32 cmd;
-- 
2.43.0



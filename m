Return-Path: <io-uring+bounces-9118-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B930B2E4E2
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 20:26:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 992F65E35EF
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 18:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0A382797B5;
	Wed, 20 Aug 2025 18:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sX3ZaDuZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5C9279DC6
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 18:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755714376; cv=none; b=nokZFsxZN8IS3Yux4kBjO/6f96xfAanddaROeUYO1Upxf26VzO2yEab8k6wwLsUjdc+yzy9BoSe0KHmAqwh6A60+PBu3Kh1VE+gmnoVl6ufnOMf8yL3bxTKd6ZqrIEJDdV3WQ050Xt0wsL0ThHKe3UJBqnj7F/txQEKO8WLNJbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755714376; c=relaxed/simple;
	bh=W2o2/lt1gFF/jVz+ETkpPF3jY5iz23sQ8bAMOjiac+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FS40nUW2bVpX27cOryXZzvcBx7tGcSPidFDIyTrnGb51QDM9JSGJ/3bpHIYUMVF7wjqyzKBy/T2/d5lywa8j25eNbKg6NVTXPKWmV/4aH+rpQSBxoR7ON3qoiv+7IQ7SY8wHH6PdFZKZwKXToD9l/iNTUeqF0xr/mExJ0dSvCbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sX3ZaDuZ; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3e56fe580b4so735335ab.0
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 11:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755714373; x=1756319173; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R9ynKemDPLRw2n8yVwpd/4vhHDk3+z92iHHf2mAeNs4=;
        b=sX3ZaDuZtWvjcIyf1Eu6Yfg21oJFdvtwYxw9H+Ih6GEk1Q9LGG5uPno0vojpuaWI3B
         ZXQemjeT3RhnPusWuZpz/Xj+6xSX+caHwLd3wyUuS71lwPBtIMKhI/oJPzc39WzfudZU
         Q9kMiYMa5+sNfB95E4GLw18oeJd+Y11V3ROjExKGfj3BJMNsJ8efbrRV+SgQgBiWS0pA
         PWOBfech5ua2BU5EiEERh83z7Phxk2v8ZEmwHZdxcmlVvir24rS+EGD1viouQ5nnoJ9G
         yXP6A/erNFpAAoSZe3N4BQ2/Bi4fCEXvkEbPRy1xh+gmOpK94XyT5AHcSTfMBKA67ftk
         ybGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755714373; x=1756319173;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R9ynKemDPLRw2n8yVwpd/4vhHDk3+z92iHHf2mAeNs4=;
        b=YZyUdXTS/+9VKCEvzeJqDil35/Q7jGc1VgwG4F2w2JGOqvdLtvCxqDXmnpr6u/oozc
         0wUwfkA0g45+YB91njSm1/v7/nhkszySAEErXaJhQKL6FHd78AI5ibBFQ85lwwdTR+vQ
         3uRwxwL7snRNn2cm/dAM7HFmAYfJbDB6CYrGGJw7+UO++DkpeIdZmZgEtSjtgnCxZ8Bw
         YchMi5aTnGDMK6d25coM7IM8NkU5LWu7H/+cRzOphUm7E+iZs0sFe2Yg1QNYDFGKz/ZR
         z6TJXaoIw02aQktFdINfgBkMn5kt/Gi8TWLnAxR8S64/beRUQ7vQ7e86SJn1mG0Q2wKC
         pjDw==
X-Gm-Message-State: AOJu0Yxk/hj6ODpaYm7Qu3wLG1PMUyiTZ6S7F7X+cfB39hridXGGIF6Y
	eSAKur0VgQUv5WK3xmBMwjPXP3aXSoy/WQEjoAqVaJNU0CsclTc3M+qDO62FXHHiy8N7zhyZDqx
	+DO4E
X-Gm-Gg: ASbGncur+BBCeCrSZJxHcpys1onPULulCVreroBg27cIkNO7ggo5aVSbzWrXeP6ltCQ
	yVXofzRF5mlG8PVyHkl1qR+kclzyB8oagH588PGP8SSYpEmYthLIghJFU0viRzFbR5Yne0DvStc
	imBaHUZ/5ysRwBdR/An5ZMb3BgLVud61lMfpYkggk2y6O2PkCi0wG35wtjubKyVzw0VIam4mXgM
	evSUUXONrxgwAZcVl86v0E4dMNh7Vx8aoWHFTZCIjO6v24FIBo3EM+vgLkMvWVQwSBDAP0L27Z4
	0h31OaHmsrzNw2h2FAzz6wBet74LbnV9luJPBqaSx0xJUbsFTVQc+SXNl6Sg+jUFbIT/vXEMnmn
	xLJe/+251FyK+ui0V
X-Google-Smtp-Source: AGHT+IE6bDSgmbNIF7CzbxM/WfDhwjHRQoIhno9+WCbzz75oKxyzFQDnZ8SNdrpNkw83/1EKGTp0+g==
X-Received: by 2002:a05:6e02:1c0a:b0:3e5:62a1:c9d0 with SMTP id e9e14a558f8ab-3e67ca57489mr67238525ab.16.1755714373396;
        Wed, 20 Aug 2025 11:26:13 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50c947b3666sm4217951173.24.2025.08.20.11.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 11:26:11 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/9] io_uring/rw: recycle buffers manually for non-mshot reads
Date: Wed, 20 Aug 2025 12:22:51 -0600
Message-ID: <20250820182601.442933-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250820182601.442933-1-axboe@kernel.dk>
References: <20250820182601.442933-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The mshot side of reads already does this, but the regular read path
does not. This leads to needing recycling checks sprinkled in various
spots in the "go async" path, like arming poll. In preparation for
getting rid of those, ensure that read recycles appropriately.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index db5d4e86f458..0c04209dc25e 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1026,6 +1026,8 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret >= 0)
 		return kiocb_done(req, ret, issue_flags);
 
+	if (req->flags & REQ_F_BUFFERS_COMMIT)
+		io_kbuf_recycle(req, req->buf_list, issue_flags);
 	return ret;
 }
 
-- 
2.50.1



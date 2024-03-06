Return-Path: <io-uring+bounces-843-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 73933873BA0
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 17:06:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 282E61F25722
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 16:06:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0B5E1361B5;
	Wed,  6 Mar 2024 16:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ksKRsGhW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12928135401
	for <io-uring@vger.kernel.org>; Wed,  6 Mar 2024 16:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709741010; cv=none; b=Nip6miYdSK0zKH2Hf+IKyGddN+q+VYyHZ6VoP61aVn3KcWMS0H3Kg1ESeNK4d4Z7FO9LFcNDw/aki8BJVwomyMIYiC5juNvRYy5VsVrOUoSB/YdYCcjqqWZSneA9+GYmFuNXAXeruTuzesZMfSCLRsuAjhH47SN9JKOefFOQd+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709741010; c=relaxed/simple;
	bh=GkYsHUiZ5ZwSrAX2zlb8zWkOdJtZ7k8JzKe4a9WHhdI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GrAUSyxd61BpdMwR6lU83EQTf+DXKXrblMZJYajr9yDcvDgpN46jDx/rjpFra/LJ7g9Isz5jZ3eVpIWKTr1WunbijrrtDyvA7IWvKKCEy3s+aTPf/IQmw5zAcdSmcOiFgAxKEWv3TXEZcS8xkYZTzynjWchACEDnjP1Pzsp59wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ksKRsGhW; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-412ed3f1e3fso14029495e9.0
        for <io-uring@vger.kernel.org>; Wed, 06 Mar 2024 08:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709741007; x=1710345807; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=a9Us87DZ/eJlaBaUUk5n9e1ujOkXx0TDGgJj/9qkmBA=;
        b=ksKRsGhWqogh2yPSPdk4rcmj475QIqfft53SCX+rxpssKZhgM8kW2nvnc/v8AxHYv+
         xl8uvuXGJJJBi6kabqS9cimGXenPkLr3vGtaw9wnWR5xU2Bxq4i29k8zq0h5PAHS5BL6
         igh4IHp7cAfDP+YpaIKHieRo1rJvRDftbYQBBjwzP8+wBUI0v6JYtwsl5TWeOtm/qTxY
         xo8LTUMOFnI6DcFdmgt9WzGXOGOqtNRc6IlHx5J8EMEc24vSkfaL2DZz3Toxe6CdHI94
         rJJEA6/TknKYvItw8XpmobKp5xLcXvePZk/z2tNug6ltkHmq4WVRc8d2Uhp0AxLH5QVC
         8qYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709741007; x=1710345807;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a9Us87DZ/eJlaBaUUk5n9e1ujOkXx0TDGgJj/9qkmBA=;
        b=bEJYiByu99Zijd7qko6/t+cMLeIxuhux2d/95EoiiYuo+sJR9VOj4falls4IVx7C5E
         7Cn7YWx9LatCqF1uxcoF2IFbk8u6c1uJhNDoDTHzmO9kkhPcBBdxN/j/iz363UwQfx7J
         SBsS77hE/2CEDDU4EmiN8eeqDAUEwFKoMd1VFSgUqxEZQpQ0yArr1/z+WzH2xEMErIEZ
         PKpGt9sXdvfp2vfV6KOWfuIars0NnUpIquV0ccOXawfWrTNP8PHnqxCY1rJXKupdtFBI
         TbpnZACjXAw3fCcDmK4GtfmgvmGRhhdeBDD+n4kmueCPbgboPdELLDLIRRpOwr8/mjHI
         C+rw==
X-Gm-Message-State: AOJu0YwlODGQGMGW88fENxlAAlpMykHuyi4hQM8gke6W0BtgcMsu8uqo
	wcWAKCuCm0f0HEiOfwC6TfrjhBeG3Pcd4AhFMAt7eAop3GdKKRUOSVoF+bB0aCk=
X-Google-Smtp-Source: AGHT+IFU/PaNjmtAhcdXVJd8Z+mui4aIRT3CWa/bYsKQx9wP6BFfoIx8RsMvIdqxmkkCFdqcO+AyVg==
X-Received: by 2002:a05:600c:a51:b0:412:fcd9:f1fc with SMTP id c17-20020a05600c0a5100b00412fcd9f1fcmr1000007wmq.22.1709741006488;
        Wed, 06 Mar 2024 08:03:26 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.233.174])
        by smtp.gmail.com with ESMTPSA id n3-20020adfe783000000b0033b79d385f6sm17749796wrm.47.2024.03.06.08.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Mar 2024 08:03:26 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: fix mshot read defer taskrun cqe posting
Date: Wed,  6 Mar 2024 16:02:25 +0000
Message-ID: <6fb7cba6f5366da25f4d3eb95273f062309d97fa.1709740837.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We can't post CQEs from io-wq with DEFER_TASKRUN set, normal completions
are handled but aux should be explicitly disallowed by opcode handlers.

Cc: stable@vger.kernel.org
Fixes: fc68fcda04910 ("io_uring/rw: add support for IORING_OP_READ_MULTISHOT")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index d5e79d9bdc71..8756e367acd9 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -932,6 +932,8 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 	 */
 	if (!file_can_poll(req->file))
 		return -EBADFD;
+	if (issue_flags & IO_URING_F_IOWQ)
+		return -EAGAIN;
 
 	ret = __io_read(req, issue_flags);
 
-- 
2.43.0



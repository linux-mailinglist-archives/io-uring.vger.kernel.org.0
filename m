Return-Path: <io-uring+bounces-7575-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1475EA94756
	for <lists+io-uring@lfdr.de>; Sun, 20 Apr 2025 11:30:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41A57171830
	for <lists+io-uring@lfdr.de>; Sun, 20 Apr 2025 09:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2730213C3F2;
	Sun, 20 Apr 2025 09:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GOCz1PRs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6877418E76B
	for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 09:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745141423; cv=none; b=rvqUbufZeIYVhNDB3D4+KWsYCc42uOIsA/d4VZdk2xUBCNxm+LyX+8AMvOuhosmVy1b5+VTe/PYPwSzQugz+k92aqWLxM4QaIww6PMjI+M+6u2EhE4PiOJLBE6a3L2b2ziTXymveTTkvDb/7xYCXDe//36EyIglDPZcS+nGCre8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745141423; c=relaxed/simple;
	bh=TaHUvlSr84kz0xVXFp5nQYP4DY9tmrV/xT9tt2WU3Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXcB7HJXawaBSHbTd2XckE1Yts52ljxPJzgdIaScFevKM5KMug39KvV+y4oUm/Yf8XP3HJVdFjti1YC8cMfSIV6LyfD4gdj80MDKVuDF5bw2Ys6yKvdVfpVkM/8fBQotgoae+mD9C/orgdgbG0AAkxDekvSxwdNwQNF6Mn4Gz+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GOCz1PRs; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43cec5cd73bso20669775e9.3
        for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 02:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745141419; x=1745746219; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pshqAxt5lV88/D1fpiPJCXTgLq8T+KBk0tdL3CEl0C4=;
        b=GOCz1PRsX6Cp3b74ZepCfbvD7HbNcrfKZ7juVOlB5g80MM/6o9bHhsqxqjWto+NFDY
         ySHHYYsyIN0miSx90FFMo6KkvEy24AAnD/n9UJ7ldyP6Ro3DkNnsDSWs7b0HCig7P/eM
         b+Dyn6pSk9LHmnAKRx7UUCC+GNeQaCmVcBYmWVSC9tVfnfhCbSqqxVjbLed1tn6Wo6bU
         EeOpdIVUiS7O0mQ4YvOZ5uUCDbXAKKyhF7TddwEsdpC1xd+4c84YCOLM5yhXqwZCW6zp
         FhXlqniHKL6AzsxkA5Yt11We/zz6YdjDQsVCrpUqBAm4+kli8YulHLz/qkxrg4Jrqn/4
         lPrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745141419; x=1745746219;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pshqAxt5lV88/D1fpiPJCXTgLq8T+KBk0tdL3CEl0C4=;
        b=b4aUrGz/kxbcXh740MKD4WTGcz7brE1q+mw4EFxfe2e+pqGoo7tnOfVxlXhGLNxQUB
         qY7E4XXZBI4k5j7Hn6G6CwfhmHpTQ52qHE5/hhY2ESU7yCbgwRCKvuiJW6tDo5khO5Ag
         nE8AmfAE4YFAYZzbxpUw3HfpdwNHXSjdDGX9mi+ERZw4S3hFE8Mo4nLKDPclsDiHpsKr
         dFiHVCu2Q9M9eUYD4zOf5D5G75ChkxOshUSzdN/FcLJOKTSFMgDu+z9Kn3dr3ErM3nRC
         wOqFAgRKSzH1MqxjO3uEI9a24tDJH8vBg6+L9qnwhGYi+PXxt666EptEIK49CMv5qksu
         nmAw==
X-Gm-Message-State: AOJu0YwrjzsPSG95u7un8GNNE6af+J4AXWjjNeZyKoFsJXTpOK5PskRt
	35P45wqrfSD0rC1ueHgOEVS/1kUgLBxOTRMYo3VDkYasVf1YNFc7Ii3nlg==
X-Gm-Gg: ASbGncvGpLyeoQRGyemE9bd7dtQ7lI6VFPA5Px0BxmwUl6wbJeLL/dufuTh8adazp+a
	oU28FhvbgIQqUR9JPR6dOFYwvnCPiuAJmlelfdzXP4GsmyBczTK+dBF99G23DYXdUll7NzzV6jq
	xigmHCOxZG1/CHeYGPEEPoEh1sOLpeZ892heJGqYMGDKFTteJHQnwzNQ+wWK6XjRu8ZP7MAERK2
	3cvmzSajC96hFQvLI5GZJcJOgSfCXQy/SGXn5n1EWFIOak4d5XImEJn9CHabjG2Q6ZKvaNTZLgP
	0vtVQNuziLka6on1wqORwHtClsaA2Bf+xW8q5ez2wX0PWIbAtc+GJA==
X-Google-Smtp-Source: AGHT+IHOspmVFSfU1C7qpte4I+0KhhahFwl4Qb3uv4Ry7vvs8ap9ER6wyb0Xw43jYFw5dl9nMYQYqA==
X-Received: by 2002:a05:600c:46c7:b0:43c:e7ae:4bcf with SMTP id 5b1f17b1804b1-4406aa876a7mr79091855e9.0.1745141419369;
        Sun, 20 Apr 2025 02:30:19 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4406d5ccd43sm91188675e9.26.2025.04.20.02.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Apr 2025 02:30:18 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH v2 3/6] io_uring/zcrx: remove sqe->file_index check
Date: Sun, 20 Apr 2025 10:31:17 +0100
Message-ID: <b51acedd326d1a87bf53e33303e6fc87661a3e3f.1745141261.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745141261.git.asml.silence@gmail.com>
References: <cover.1745141261.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sqe->file_index and sqe->zcrx_ifq_idx are aliased, so even though
io_recvzc_prep() has all necessary handling and checking for
->zcrx_ifq_idx, it's already rejected a couple of lines above.

It's not a real problem, however, as we can only have one ifq at the
moment, which index is always zero, and it returns correct error
codes to the user.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 5f1a519d1fc6..782f8e76c5c7 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1185,8 +1185,7 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
 	unsigned ifq_idx;
 
-	if (unlikely(sqe->file_index || sqe->addr2 || sqe->addr ||
-		     sqe->addr3))
+	if (unlikely(sqe->addr2 || sqe->addr || sqe->addr3))
 		return -EINVAL;
 
 	ifq_idx = READ_ONCE(sqe->zcrx_ifq_idx);
-- 
2.48.1



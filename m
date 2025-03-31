Return-Path: <io-uring+bounces-7305-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 384DFA76096
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 09:53:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7EAEC188B878
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 07:53:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6314B1C84A0;
	Mon, 31 Mar 2025 07:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OspcRl8T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE97B1C862F
	for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 07:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743407601; cv=none; b=MxgIl7jz5O127aLnSuEnR1es/X4vNNl9dw2s6tpLbf3u6ArUoJUtNF5dQBwXPPaT+SElE5OuMniA70MR41sisJjgt+cbkJdMVQg9VxF4aw6J5Xea76z6yvs5E8BgoA/rGG3G3tqYQSxnUXGCFHGc+CLcnTzh7FLBU+BQc1NoaF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743407601; c=relaxed/simple;
	bh=yMoHSrhDQ+T6pBaSQ4bn87MHukS4vJ1t3zxVB5FWy1c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rYgkurAJcDBUPWcOa8xOjTFs76GTsZ+DKVqeXb9+1rUOy4+9yGY7PsObbRLrzSylCrEmz3JUp3IvE5DoWid5ZjOO+FU38pErGCTjnCL8FlLKskEVNf5DEqqGSSYDI7djIxhxctLXwhzpuHN08UoTCNjrzYjCdh4KrsTXNmnnQ9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OspcRl8T; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ac339f53df9so752504166b.1
        for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 00:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743407597; x=1744012397; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rUMwizFlfzrlmQAtc5ZiznvNselCFbiWERkVRdbZKtE=;
        b=OspcRl8TNcnXLEEX+8prQ574l2g/vQjOVqNvHknq2fRn6ws0SB+GQ/FS4o5kZ6yuVU
         0dlMNzabw6ypI/jIk9XhqiENhAGpeiY3HGnZfit9CvA6NO80Ep/JiqkKHlSWcOHsbaTv
         n+RKTCKXDZgfXTUsLkk2wObdKOAbQgqckElrXRYckMzk2LPV+SD2RF+YfTXY/u+5Mx/2
         CXNRBrX3QN1GozEWbbDdmAEyIieLKbmZqgzrxMPuHpTbL9n9PAPia6iwCNsQTbi5hkqc
         lqTBS6vUidmYVzPHM+Rql9HNjC39YFy0DjegALbJ7e2lmimHZWIIGedybXvYMgnm/9Sq
         088Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743407597; x=1744012397;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rUMwizFlfzrlmQAtc5ZiznvNselCFbiWERkVRdbZKtE=;
        b=k85FXtIeIuOltsbOK9GaeHI8aA9sm1Ealxrznj7CJgJH3gh5eEQNwc/pz6hF9pPGbQ
         jUBLsEikJrd29plnvKPox/aAKDSViBaxSkcpBuH3CKYggcssnFU1i69Bj6/YnxB4woCX
         jTKMSAWka98hQX4FYH4ib4HulQAWmAp3tZIpZxKwc/hYCsq/L+BoJN53GgB1jh+LjPF9
         1x2OHSsJ9BceCpRkCNd9mGtHHe0r1TIF9xIjdjTdNKojGWt3HZg/PqI1xYsI2emLDzx6
         uTp8RB44n+gY/l1GeUXTkXG0xSgH/Ljrpyg0P9Q8upHzq5+hs34oN/qopcbEY85bcD4v
         8IMw==
X-Gm-Message-State: AOJu0YxUeHHTn1+E/A1JkKQuEqS1y9Eie1GiZZ6MHYqD5FHr1BGDfRZi
	CFNF4TBSz+ad97Rgd5P137oaWgjaOSaHMxNBhAw6zpAUdXutNWcFY5GE8g==
X-Gm-Gg: ASbGncuKFZn3tgO4IhWgZEwEYrRY7Btddqe8iyvXoxU6bwfgclp1Hxr02ibAEF/ILBp
	9dd3syL4eN3Jsa/B58WbCT6yUv6Di1XamBrPK9TGeNv+VtHWO90CkdPeGrbl1RB9Mj4eLEyfYQv
	bdC+0OTmM4Wu168lWC2Xglnf3bws+2JO4Oxl3QcPEZhfA/FESBDtyab5bOl5DZZQ8P+0tIaM8WO
	uj5Fj2ZPhurd/QxV29EqJYO6SV3SzaqC/kH+0k4ZGtDtOdAflVR0Wu10uh74qDVfsRWpMvEdcHu
	jr1vXxEfYU3j8npwMREDt689NRs=
X-Google-Smtp-Source: AGHT+IGndo/+RIqL8eRJbMaNr7J2N8CHYT6Gn8N3w40NkkRZnimKvV68MAw3UK1QvjQeHrp8rWYU8A==
X-Received: by 2002:a17:907:84a:b0:ac2:49b1:166f with SMTP id a640c23a62f3a-ac738bfee57mr718865766b.52.1743407597162;
        Mon, 31 Mar 2025 00:53:17 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:345])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71922b8aesm595545466b.13.2025.03.31.00.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 00:53:16 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: add req flag invariant build assertion
Date: Mon, 31 Mar 2025 08:54:00 +0100
Message-ID: <9877577b83c25dd78224a8274f799187e7ec7639.1743407551.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We're caching some of file related request flags in a tricky way, put
a build check to make sure flags don't get reshuffled.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cb17deffd6ca..6df996d01ccf 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1643,6 +1643,8 @@ io_req_flags_t io_file_get_flags(struct file *file)
 {
 	io_req_flags_t res = 0;
 
+	BUILD_BUG_ON(REQ_F_ISREG_BIT != REQ_F_SUPPORT_NOWAIT_BIT + 1);
+
 	if (S_ISREG(file_inode(file)->i_mode))
 		res |= REQ_F_ISREG;
 	if ((file->f_flags & O_NONBLOCK) || (file->f_mode & FMODE_NOWAIT))
-- 
2.48.1



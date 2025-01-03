Return-Path: <io-uring+bounces-5663-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 09D9DA00B1D
	for <lists+io-uring@lfdr.de>; Fri,  3 Jan 2025 16:05:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A75BF1643E9
	for <lists+io-uring@lfdr.de>; Fri,  3 Jan 2025 15:05:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24CC21F9A95;
	Fri,  3 Jan 2025 15:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c952Rs9g"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED4B1F9F48;
	Fri,  3 Jan 2025 15:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735916698; cv=none; b=RCVdh7FHPN0WI5rmj/tDPJ3ev2YeIPcCJ7OIA3BwE227jLDIzswwDJWWW2p/U1ZhWcCVJ3HodwxU2kWKE34onP+b1NOo2TdgbAx876K6zaSbVRDJ0adtU0Yl+8wPUQwYJgrmXPGv5uh5aLZPX1VsLpz2p6hrgypvNnGLqcE8QjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735916698; c=relaxed/simple;
	bh=H5400TLePfLQxI7UD5AI3D5cWC0CjAxIvYqocj4GrHo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f+BIAUeO+0tt5J0DFHeIfU9qUzE1ry7xh2RH/3zhp12tDhx8of0EnzMEAFObVX2hRlqniqvLnqBLsbmpv5X88uc+EtCiiZXYe8bkHpnTTewfVz8LnWdZOn8gDScOMa2a858oqcAgBm7GHD+kBqtlW4hdjL7iYz5vL3TG1jNNL+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c952Rs9g; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2163bd70069so73191865ad.0;
        Fri, 03 Jan 2025 07:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735916695; x=1736521495; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gXusr2UpHDeSOUhdbX5qqXLthJbsIE7+HUFoo4sDdoY=;
        b=c952Rs9gbEQFbz6GuVuEaJsvspz9h2N5OM6IUnRcjI02XlECUOGgw65lwd3Wq6cLbk
         LybJGPvvu3BsCndMXhgu20JkbDEuKvLbmzu5Jp7vOw0N+8qbtTkGC8fAK7bqRivfYCb7
         7NSRqozOcBmYQXBkLZc5SQGFXtFu1dhx0ImK/+0MrxbhLaHZe0+KCEnfa2slCM/4DDnX
         d7vUuiAINBhYKZWeTSv7VHzvK95uBSb3mty033wu3dfPtOgRSSAehEoRYeM/jzkpCP9d
         C3O7+8UxQh80FIQpAtU2OW2cSmIzAFhO/yruwqpMdEVTONn8s6OdjoPuYIdm1LddnkBS
         bffA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735916695; x=1736521495;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gXusr2UpHDeSOUhdbX5qqXLthJbsIE7+HUFoo4sDdoY=;
        b=C7/oZ2PMGwjwPUpXPTnnf2jm/LfPaW/rM5Q5HqYwfQNDQhp2zyMnB8EfWpOz2b1GYd
         /IkDqZ99+MMMSkU67jprxn0WbUQtMbAYogMtUMI5sKSt/TIgifIfX7gfiydFTTFxgZSj
         Z1b/tkGaUH+egUcGi59L5Kiv/hdiZdYeqerjBT7gEe1gcEXWKp4BNZysxVOWwP53D17i
         lNI75qLTXCCasx+KbNdOsiF5l6UKxUha8kQZWR4nd2gNI7x3092gB85ZRpnI2dEcJDo7
         U0UWGAu19P8YVaqg7nY6qfTrvtCTxfksbHOH2qfmXVZXVYBn2J1U5MTxN4XZfm3vzB84
         ar9A==
X-Forwarded-Encrypted: i=1; AJvYcCUJzTk0UVdcj3oQtFFcJV3VGb5wf/IdyQc4iBErIaQsKXC+/T4BXzwyHrQg69faxEq1hugljczU8g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxba8m8SsP/20BOjSIqAZKwSveigzgLrFoC39z8h2iZfbtS/FsH
	562PJr9TazW62mPt2vKpdvUTPdNgA0UqP/4uVjVOwEr6ETU+NJtx+O5uWw==
X-Gm-Gg: ASbGncvsvoG+Ynz5LaQNGpoo0xMQY5CR5OWSfymZVXixYJu4XSTRE6ZzIK2U0G3JVHX
	RqzVpcyejJy3/im+rJoxv/Fi8GJK95VCsnlQiB3jmKtNIsU7Ilr2aSHhKrY/H7Gs+t7Yx2/JAsP
	4gd/VdSHjcdMeQhuMPJnX9K4caJMXcPI+ZuiPLWGWjdllGX3cqUfsyqXMrDggQy973m/88cLOXj
	doTwAHxOzt8YhuuaeXskoPW2Zt3tnYaQY61exWDxYW6alG05xPLKFI=
X-Google-Smtp-Source: AGHT+IFZxJeo9O3rGEx8BnQZOtx8uzYu6YgIJ8pYv8JscsUpnxCfwpTqN++H4rUUS7e4dqv0Ruvgfg==
X-Received: by 2002:a05:6a20:6a24:b0:1db:ff9d:1560 with SMTP id adf61e73a8af0-1e5e0484baemr77098226637.18.1735916694562;
        Fri, 03 Jan 2025 07:04:54 -0800 (PST)
Received: from local.. ([2001:ee0:4f0f:f760:12a3:e9a:304:ed])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-842aba72f4fsm24180459a12.11.2025.01.03.07.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2025 07:04:54 -0800 (PST)
From: Bui Quang Minh <minhquangbui99@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Bui Quang Minh <minhquangbui99@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org
Subject: [PATCH] io_uring/rsrc: simplify the bvec iter's count calculation
Date: Fri,  3 Jan 2025 22:04:11 +0700
Message-ID: <20250103150412.12549-1-minhquangbui99@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As we don't use iov_iter_advance() but our own logic in io_import_fixed(),
we can remove the logic that over-sets the iter's count to len + offset
then adjusts it later to len. This helps to make the code cleaner.

Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
---
 io_uring/rsrc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 077f84684c18..d0d6ee85f32b 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -883,7 +883,7 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 	 * and advance us to the beginning.
 	 */
 	offset = buf_addr - imu->ubuf;
-	iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, offset + len);
+	iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, len);
 
 	if (offset) {
 		/*
@@ -905,7 +905,6 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 		const struct bio_vec *bvec = imu->bvec;
 
 		if (offset < bvec->bv_len) {
-			iter->count -= offset;
 			iter->iov_offset = offset;
 		} else {
 			unsigned long seg_skip;
@@ -916,7 +915,6 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 
 			iter->bvec += seg_skip;
 			iter->nr_segs -= seg_skip;
-			iter->count -= bvec->bv_len + offset;
 			iter->iov_offset = offset & ((1UL << imu->folio_shift) - 1);
 		}
 	}
-- 
2.43.0



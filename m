Return-Path: <io-uring+bounces-7391-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7852BA7B79A
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 08:10:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0F16170242
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 06:09:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93E4E14A0A8;
	Fri,  4 Apr 2025 06:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=norrbonn-se.20230601.gappssmtp.com header.i=@norrbonn-se.20230601.gappssmtp.com header.b="s2hgqZLa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DAE101F2
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 06:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743746965; cv=none; b=fvs9E9xK4nPS4jB9LJTmHSAWwkZ76vqF6RM3diWlnvTFiIaKv4ROYsWTOVbKUMgZFqWo3FJTMoNb6OfdPJvFJ15mNQw9vDoHW7za5BmWFcU7E8f7VOejbBgSbnfz/MUQPvn3hfUXyG2miDjqj66w/TWi1a9+ec0HoLgQJayiSGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743746965; c=relaxed/simple;
	bh=bz8ZeSMMKJx8FeT1cpctkBXXtRdSKryMicGy2P3s+Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ppaKt7XPQHdt6wSHMyTCFboowt0DX4zkKk4sivFvqKoh6VMGRT01XNr5XUqIGgDlbL9pxKRZ7Dq1jQncjCLeyrOFLx2c+umJ679obfI6uoT1HOwedcWYt3KPiZkS+Z1V1MvY8q+h6zGNGdz+wGriqi+GE3JEbLFildDY2cK22Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=norrbonn.se; spf=pass smtp.mailfrom=norrbonn.se; dkim=pass (2048-bit key) header.d=norrbonn-se.20230601.gappssmtp.com header.i=@norrbonn-se.20230601.gappssmtp.com header.b=s2hgqZLa; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=norrbonn.se
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=norrbonn.se
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-548430564d9so1701512e87.2
        for <io-uring@vger.kernel.org>; Thu, 03 Apr 2025 23:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20230601.gappssmtp.com; s=20230601; t=1743746955; x=1744351755; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1uzpiauGf3+DJGPaCBp93Lg0kC3laB135lTqLtAfqM0=;
        b=s2hgqZLaPP1viXRTK3Tz8gWTsZ8XjAooCv46A2Qf0ThCGALsDzoR80RHuoY0zYkt20
         ep7Cf2hrn5jPjvoiO0HKV4RAdhF7R4GIxm2mHr/kXLa2M+1JDQhQ57/MumWx15UQT1Hr
         xxMkPEU6Q952Ch/C0unvQaMsElGoQYlsNbEPD4t54Jg+vWyA79ncDrB/qg3N/+gqaSUu
         FMz1/0zk2DsJbkKSV3oclFHWv6vFkqViHv66c/QtOWDtGQfV7yhOItDLsddTqY6/W1Qz
         SWSGGzm9kIh53u4BIviTAEpgUyNv3bkSj0ABw+kukQpLrk3gcekEw/j8BA2EOJFSXexg
         XzQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743746955; x=1744351755;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1uzpiauGf3+DJGPaCBp93Lg0kC3laB135lTqLtAfqM0=;
        b=l48PqUtan4pqgk5p70iYpVZXXb3LTW/3f/sTthdk1zKfkgQOOSvbOO/VYuR+SMUFtd
         MVVc+tr00E+J3/1ecH8PPgg+sjJAxZEvC4s0gk0o7iDkFW8j0UrS/gZYg1LizgX2VK/y
         l1UxjIH4CSTHnp2OPACGuURbFbaMTehgruf+TZ/lCyjDccKJYKfniJGb+Txeq8ffr8KZ
         vyfqkocmw9LIiJjY9QSCeLdBM6VJ3LamQK+M0pZJI+3dfwGnT6bKZBfGoyb/SVgDjGXN
         ZZvgkREJDw8D02HKz9y3Wl6CRO6rSqHMQW2QaqXohZxbB8GSm9DxPvL5hNcalEpU+xHy
         yHgQ==
X-Gm-Message-State: AOJu0YwCC2bhGOAz4dcgXIo1fu3dPo3uwy8QnvxBCSvnjiFL/QKNoWUs
	6JSFjGJlvtTKr4PaZgDmTwbVqmssxE+RecQR+ZeBPAzxYExy1Ex4oVopqwCJp7wndo95h8VJJgz
	b
X-Gm-Gg: ASbGncsEsFT2xnipYKqXcONC9UvvD1h4U3PqwGxy1YE6PnYha3iaDw2QtGKjmKwYYJK
	AE+EY7AeGim/trFGn71Mzk/C43vsohrsv68Cf1l9O76aB57Q0hkRwb9L6RFUZbgSu/TWlzNDrvm
	0WKDZrmCbSNBhabsyGQyWGG8FDfJ6HtXdceK0d5EJM7ZlK4CDinipx9uhkBA/W89fCnE+v5hoD1
	8hI4lGzDxDHj4J+c+8tIwaQvNsCTCwJjLwtDHqXvoTPi/zNgp17fsb/VyFcndARrb3iYMQKOqTq
	sX7xy9uAp/Qe4m4oRtTfRf7zLUZINfVKUOG37IMDK5/S8HAPv7Vu
X-Google-Smtp-Source: AGHT+IGbWr5jjWyWUulKHgACmkj2p7+CJuh14tmjZ0P0SWJ2jV76dvChVKGiGx6L79BJ923hCVNHwg==
X-Received: by 2002:a05:6512:33d2:b0:54c:a7c:cbca with SMTP id 2adb3069b0e04-54c2282fb5dmr527086e87.43.1743746954558;
        Thu, 03 Apr 2025 23:09:14 -0700 (PDT)
Received: from kronos.emblasoft.lan ([2001:9b1:ff:d00:c594:d5eb:b633:3254])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54c1e635c7dsm340938e87.144.2025.04.03.23.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 23:09:13 -0700 (PDT)
From: Jonas Bonn <jonas@norrbonn.se>
To: io-uring@vger.kernel.org
Cc: Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH 1/1] io_uring: fix typo in io_uring.h header
Date: Fri,  4 Apr 2025 08:08:58 +0200
Message-ID: <20250404060858.539426-1-jonas@norrbonn.se>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Comment incorrectly implies that flags are mutually exclusive; in
reality, IORING_SETUP_TASKRUN_FLAG requires IORING_SETUP_COOP_TASKRUN.

Fixes: ef060ea9e4fd ("io_uring: add IORING_SETUP_TASKRUN_FLAG")
Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 include/uapi/linux/io_uring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index ed2beb4def3f6..e6637d693fa23 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -183,7 +183,7 @@ enum io_uring_sqe_flags_bit {
 /*
  * If COOP_TASKRUN is set, get notified if task work is available for
  * running and a kernel transition would be needed to run it. This sets
- * IORING_SQ_TASKRUN in the sq ring flags. Not valid with COOP_TASKRUN.
+ * IORING_SQ_TASKRUN in the sq ring flags. Not valid without COOP_TASKRUN.
  */
 #define IORING_SETUP_TASKRUN_FLAG	(1U << 9)
 #define IORING_SETUP_SQE128		(1U << 10) /* SQEs are 128 byte */
-- 
2.45.2



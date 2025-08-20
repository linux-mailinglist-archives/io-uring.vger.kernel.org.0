Return-Path: <io-uring+bounces-9131-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 602A2B2E88D
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 01:17:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6A17E7A8A83
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 23:15:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F97F2DCC1F;
	Wed, 20 Aug 2025 23:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ztr4mCIb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2685B2DC344
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 23:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755731815; cv=none; b=fj8Oi7uqroukWCS9C8UyvxENxyFCZIGdCiAjsAY1SNDk0NWUy9dnu2ryadpX915F6FOqrq0guN/EIm0Ov1z2+mxHz7fsXWYDh7A7jnhuuI8AtZUt1WkDUHR9IoyHrb7EOGv8Lj4DmGu/EDyGC0Qfe7e/2JMzmIBkOuUJuidr57U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755731815; c=relaxed/simple;
	bh=tAbRpbWCix9gVC1cPIRD7AA9XKQn3gGOD4U1Tqz/TRA=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=kNcQxpKUHwByjkQbAokHiuSKBOPUYVv3rz62Y6qklvf23pVHJHRf0IIkSGYbAhEILeJbv0GeQM5ZwIxTNmfNathuMpgDxvpmpyfCsTYY0AaCjguQ8lbHL0G5ky9PWlhxsbKAT0IlsctiyueLXff7HpZBDWu6XKDoiLzebgX2daI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ztr4mCIb; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2445806e03cso4310595ad.1
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 16:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755731811; x=1756336611; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TftlHfY+8dsspQ2CtaYsoeNzqIpyUrgGbvxgBGObSTo=;
        b=ztr4mCIbPTzjpZnr4G+L1hDoS4tGpIAq8SxwSajqh6KYCVvyjKLyicvEZSixrJ53OT
         ewg57Znr1MEyIXnhfHrrLn7XvipWqOiI7n6MB0ypqJJiluPjamytj4/kOrLEuc/ajmMH
         /ZxdPEllvDbbAvVhahCrcehe26jTUto755DmLRA6twpKZl8bSj+bhL1uRdfLO/7osu26
         ulvjE2ndkVZ628u3AKwrIBivYDNpxIMlFC9iNsv78tKzVM+otjzaNMW/y8g45ZfXwiHz
         LjNPMTRzlQ/Qykg0JHHApG5torQAIT84QC6Kb3pVmAJDYBsViEkt1xWpPIhifULtzIP6
         PujQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755731811; x=1756336611;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TftlHfY+8dsspQ2CtaYsoeNzqIpyUrgGbvxgBGObSTo=;
        b=Ilk/P3RiAj64Hh0rTeu+/VWwI4WO/iYUEDVPW7Pjcbinc78Dek3eObiYuGXelGRxDs
         2iapY9HnEj4CXwXb8wHL3jp1vnS6bxb8flxEhiocdv5y0GTwHrJxy4jowYZfwGyCvtNw
         ZVEKwLO6y4jP8a+8u+J7I1vZ1m/viyuXcvSZ9enjG70ZJtXANQTGYH8GhamL3bewcnuv
         y9mxTroLOW08b8pxi/GbLpfW1pstxfCObptKQWl4ZVZcPWAIrFEzdHjn1Wtjo3TnCa8m
         rHAJO8lg1lpGRKMWJcAsZe24CZ8Ozbk7hJq1Rn17m56hzWuKLl23CoARGL6izmTDNaUo
         5XYg==
X-Gm-Message-State: AOJu0YwrjgKnLvrd30oRMb0vVVey4T5OAg8GlzTZlGcjTIbclX9WVs7O
	hr6BpVP1T11ea3ssVt0W+TF0lRF2mkONXmPEQQ//VGgz06vBqyI2DKwEGE6dvOrkprOpvf/TnMn
	B1TdL
X-Gm-Gg: ASbGnctNJ/mzq2HtpUH810uLft24ZNOByUk/SGqm/QNZ8bMxAWyKlH1JDqHFdHwYfdq
	OIx/zlyZJtI0NG/Y/MX90yvJ/VHqG55516arkv7UFq/3+YejMnXZUG+uELCKMesEIh3wCAM6CFN
	m6NJLbfoIy4otWFT8GSSlk74X0JYNNsJik2tZarUHs+tXexrB5getlWXcJveKGvWHWsRzzo+LDu
	bdzdJclqLy9OCcsURl3gj7mFUbQEUSmBs6i/W9hC1h0uwbrJMRABMfU6zHKxTWQD6xjz0PE3oOH
	bElSBkUlCw0G+r683DWecmSj0t+kXSeX0YKVxPkdVgBNjHW4dBxwmLJxrxHIRXJU4Bzn2BGlzWi
	Qcgs0vzjAcrtL5uU7YnPe
X-Google-Smtp-Source: AGHT+IHPRVIzEgCYUL6TTet2z3RviCQ9JblLPX7Tv2R4nfdjNsLhyqfvKWeN3DISgIGjW1ii/Bw1IQ==
X-Received: by 2002:a17:902:d50f:b0:240:70d4:85c3 with SMTP id d9443c01a7336-245febd7470mr6045685ad.9.1755731811056;
        Wed, 20 Aug 2025 16:16:51 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-245ed4c6fb7sm37107225ad.89.2025.08.20.16.16.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Aug 2025 16:16:50 -0700 (PDT)
Message-ID: <e2f14b20-2ad4-4e59-9966-26dd6aa70f31@kernel.dk>
Date: Wed, 20 Aug 2025 17:16:47 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/kbuf: ensure ring ctx is held locked over
 io_put_kbuf()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

The issue_flags will tell us if this is needed or not, however a
previous commit was a bit too eager with the cleanups and removed the
required locking in case IO_URING_F_UNLOCKED is set in the issue_flags.

Cc: stable@vger.kernel.org
Fixes: e150e70fce42 ("io_uring/kbuf: open code __io_put_kbuf()")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 723d0361898e..7f17e87d8617 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -4,6 +4,7 @@
 
 #include <uapi/linux/io_uring.h>
 #include <linux/io_uring_types.h>
+#include "io_uring.h"
 
 enum {
 	/* ring mapped provided buffers */
@@ -124,9 +125,14 @@ static inline bool io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 static inline unsigned int io_put_kbuf(struct io_kiocb *req, int len,
 				       unsigned issue_flags)
 {
+	int ret;
+
 	if (!(req->flags & (REQ_F_BUFFER_RING | REQ_F_BUFFER_SELECTED)))
 		return 0;
-	return __io_put_kbufs(req, len, 1);
+	io_ring_submit_lock(req->ctx, issue_flags);
+	ret = __io_put_kbufs(req, len, 1);
+	io_ring_submit_unlock(req->ctx, issue_flags);
+	return ret;
 }
 
 static inline unsigned int io_put_kbufs(struct io_kiocb *req, int len,

-- 
Jens Axboe



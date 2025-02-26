Return-Path: <io-uring+bounces-6768-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B9E43A45236
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 02:33:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A67EC3B125F
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 01:33:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25A3A18F2CF;
	Wed, 26 Feb 2025 01:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bQcF0lLp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7714618E368;
	Wed, 26 Feb 2025 01:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740533607; cv=none; b=hULZaKkv0lGkutv5MQ5rUXZ+bQNTIWWY/dQVEUo+Kve7YNRil2zZAZNZgsuF+0vuG+yo/l6/KgxoPESZJBfxpgwc6hLcyy7wpx8oCZWri+A4DFUeYP10taOd5EpLE+QsOw1R06hVNw3mi9aCHWGhAlU8W68fB1Vn/2zDtE0+Ycs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740533607; c=relaxed/simple;
	bh=vqkVXgtE1Bz+oDvHJ+Wm86sjyQiUF6GZSlTEIJOxP5E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e+I8kQ1+OMjyxwU+MRBNfAbSAckZhIP+QQ9WcsTq0LLWYmBwVP7DrikL85exRnL8Nhdyr+aAi6f78MBGzfUaJ2uLCLmkPaDRiDh8ybzJ+Ls7gOfU2+3zESqq4aGcIIcTZX0qxLlGnhya1emFenVfyxjlMEDzG7LmCTLqVMBJz3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bQcF0lLp; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5e058ca6806so11214739a12.3;
        Tue, 25 Feb 2025 17:33:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740533603; x=1741138403; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fHRM9JMfWcUc4jYhooV/GrE5AxVnIz9OlGUExDZ/2xE=;
        b=bQcF0lLpht/W6gdCJRhERnRpf3QpqWVZZCswBV8ID9dCaIqUhyfFu+cR7P8bFxw2Gc
         +3Lf5Ewy1s2kiNbeiK3s8VTbvHVUFiGxDUetVoOeIOGL/OFKg1VcbZ83WH91vJlNmGWs
         eRukeAEnQm/KedamDO3E9vOYirpjWit5GR/XRlzElwujRH2cGIi3iMFSEc9E/GmALsTK
         TN9GpCLT9ydb2oFd7MoZm5Mtuq8/SLcO2kOBHHcmN40yk0Nk8bpK5kJI+kcz6TFlF5h4
         oOIgnFO9H531dbHy7fefgNEKa4Pp/5zR0JUiwYgXqXzL47zU5BF03wKFJVNVuegIoZnr
         kItg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740533603; x=1741138403;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fHRM9JMfWcUc4jYhooV/GrE5AxVnIz9OlGUExDZ/2xE=;
        b=nKuuzQVzk8ceeogogfMqdIJhdJtUFqbyqSRlrJYJpaZwEQr2MfHkXFC2SvP8Exe2ta
         5nfig9H9wSOQW+q8rw5Vv/6jk2dxQ2jFQEd/wllUwOJYj9dnFIOZ7KO9pq0N1OEpZuhL
         RFquQWvUMz1ot7epSDTZPbysw43u+s1kLItgpbYz1ZUaXlvfputWYEdVd02/e6L3VuTH
         RDXB6TSfcthxZH1PIehqlQRI80up7GlIrdvaKbRg/bnc2M2KWif7Ep+ZtJ36hOqqePQE
         dzOCEQowC+xI3K1xoRu8dfs8ERiXkXINWSwRsHiwyhdknpadf6+2De+SpjNUgEdKeEmH
         1xyA==
X-Forwarded-Encrypted: i=1; AJvYcCV8LQ7Pr1K5owAIWkQaMNhzdYyWxyiiiJQJdbwDluzELvwYZtXG2wBpojcfsyViOiu9be8iADkfYeVMxrfq@vger.kernel.org, AJvYcCWVMz5l0alQadBprMVABo68VD9asat4Fk1scl0YzbNIM0eajM03yCD58B1EVrAvsMxNUFLSfPA/CC5c@vger.kernel.org
X-Gm-Message-State: AOJu0YxM/hON1zB3uMR862sRAC18vCNYZIe2zc3oswBxpR/rYljHiXEV
	idCh5kzLjgMnEaCcWAHQT1F1r3wjPccW3mBcF1eb4wmESwsHnJG0boIbhg==
X-Gm-Gg: ASbGncufgtCVRPlGw0fB7s+3GiIxjvnCEkUBTRf76bKfLp1WkYCQ6FbLC3tQi7Gk2H7
	erAx4hq2PuGL9DyYFB5IzB15J/0gMVjflI8i4Rw1MO64TWBrfD2RzZEF7Ns1rmsRsP0KP4JGS7r
	1WbmVbNGweGmn8tHb5iO6A/it5a/GklDLEV9GxYojBk4NkenQp9j+TUcIxzE/ZqXvUuqSxLqETs
	3t3s5nYAusvdWTmJYPqSjeaokRjm3fDzQiokOW4SbsLAm+A9+pEWcWVFEi7u7FtetNJBfNKAMd6
	D9WkUIB2pFfdhEINF22G7BwTlj3qujmvowjVOw==
X-Google-Smtp-Source: AGHT+IEZVvRhUEpnEjg4ZjWhtkDEdkT7LPkHZKi5RPBh2J9q6kVmPehLmRCGwmLcqYPRtQu7hu9Kag==
X-Received: by 2002:a05:6402:50c8:b0:5e0:9607:2669 with SMTP id 4fb4d7f45d1cf-5e0b71070a2mr20433308a12.17.1740533603125;
        Tue, 25 Feb 2025 17:33:23 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.21])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e45bae8261sm2023196a12.45.2025.02.25.17.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 17:33:21 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: asml.silence@gmail.com,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	wu lei <uwydoc@gmail.com>
Subject: [PATCH 1/1] iomap: propagate nowait to block layer
Date: Wed, 26 Feb 2025 01:33:58 +0000
Message-ID: <ca8f7e4efb902ee6500ab5b1fafd67acb3224c45.1740533564.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are reports of high io_uring submission latency for ext4 and xfs,
which is due to iomap not propagating nowait flag to the block layer
resulting in waiting for IO during tag allocation.

Cc: stable@vger.kernel.org
Link: https://github.com/axboe/liburing/issues/826#issuecomment-2674131870
Reported-by: wu lei <uwydoc@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/iomap/direct-io.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index b521eb15759e..25c5e87dbd94 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -81,6 +81,9 @@ static void iomap_dio_submit_bio(const struct iomap_iter *iter,
 		WRITE_ONCE(iocb->private, bio);
 	}
 
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		bio->bi_opf |= REQ_NOWAIT;
+
 	if (dio->dops && dio->dops->submit_io)
 		dio->dops->submit_io(iter, bio, pos);
 	else
-- 
2.48.1



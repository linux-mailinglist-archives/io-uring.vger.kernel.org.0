Return-Path: <io-uring+bounces-7511-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B5C09A917EB
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 11:31:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2939D3AC894
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 09:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5587C226D0E;
	Thu, 17 Apr 2025 09:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fxUdZD3k"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745331898FB
	for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 09:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744882310; cv=none; b=cQMBZA3dWMFhUK1w/m7TPGjosqQtzuJJ/2lR2wyXnVAoudAW8uq96tAliaTQDm6Avoqp7ElxtoR7klo1ier3w3vMSf89+wykboTT4EgDi764uaN49t5uPKcXGK+X1J3lm8EYsnTHzmdJoqkLL4NuIT3OLTcWbFaN3EKTEPntVQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744882310; c=relaxed/simple;
	bh=4m4i3ovZLZDLSm4Dmwyuk3UM5UKhKfjagYHVEgJZwSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZW4VtMSwKSFFCilLihDSy/8P2ve8k+/6MKr0zhnXfXpfyHsULCcicbqw32tm3RE2kWbEFGzeVr9Lr9e9kZ2I68+hC45ZBQV4tLGk+6Vdk/nMYEddhc0Vl4u6WmwKryC/PAbdZ3PqSJrHsHcW/A4LVzaXUnITwQ1knGRNB64hl+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fxUdZD3k; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ac6ed4ab410so87368166b.1
        for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 02:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744882306; x=1745487106; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cFplv0LBVsW/HEE/K+nPbAW5X0VU8QoSKGserDhJBHg=;
        b=fxUdZD3knX5mRO94a+S5ZMRN+xqgiQfLYAryIcBcZavHWTDx5F72tVSHWJK106p6ux
         F9cvy1NYFbn+Dy7VESmauOipIaSI3xH+5Z0kyURdsrTqRxgtjpaD0V2aFtmRMIk6JIku
         kHW0UnhUrk2kot3tk3isWwuAD9XyaAYapFEvUEbW/wyRPjBSHFMzMoX3+YVxirU6+Vqp
         Yg5IBnKrwtauAmFz/xkfMQ/GpstU5JuM2d3nX2wMkNu1ppqHmdX5o7EbNjwLNQ3/N1a5
         y4YVSev/cx/qi0aacWI9DWni2uKc8gZ7rgvhZ8SHvHHYaHLNLIkQwu0fbbnbQHSqMOE4
         XSxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744882306; x=1745487106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cFplv0LBVsW/HEE/K+nPbAW5X0VU8QoSKGserDhJBHg=;
        b=PxlK7WfH5yIzhK9ptcR/nJQxc+HexK7YmiyCCPma76TwlVYObMa8XW9ej/RyBt+Qe8
         A3TdC/jehFFlr6qsxq+v/r96LzCq/ME0qxM0wAEGJMdO4WKgngOzuDLR0pb4xOscLEah
         vZ8LL4uJ5PuAqQw/YEwBz0YR3CE2f+55Wa8yoLkUyXY0vFn+phkb7/yOauQGlVk02oJQ
         0HC2txHmlvr4jNe5JldWN5sl1ngDAZGoqYRfUeEmoAWYOazFCl1Ar06Bjr6ham/6d07m
         0nIeUcz7g1L47px44UVP2QfF2qfCbo9lupW1V96epV5YGTEOnBgBlWhvp+oRsGhUZX3B
         fnng==
X-Gm-Message-State: AOJu0Ywymo8WA2e3HCg84sI2UBiaAP0YqvXzbCND+dGEBxwNdGG/XGpz
	j5739+dbgSHY+3n8J+MeiQdaC5qPlCWFMUdEah0BsnCn9OZVXADzzwbShd+r
X-Gm-Gg: ASbGncujqdC0ifNcKM/2iLuhtWXpD1qKBn85HHP2ezEzPN+wuEK1opg5eYIq/IPIbmi
	6EpuzTLq0UYwFJFxZncghB2tC0jqCGZwnifo6eac7nhbygaGfNI/vW6Oh8xWAYSj4RIIvqKPfqB
	qX5+BypP7O+4HLhTwC+0Jpwl5RqjZyLXafmYCw48Ip2BzPrW4DRYd8Z44mCeTCZfq/9hhpGUc/E
	87yori7OzPrGJZ6/sada+n798ltAeaTvka4odQWXEYhSdJPO2RaTGTgLnbEBKlluyAYz4CQtDKY
	IjEEKUChrBX7oohTRQ3P55UD
X-Google-Smtp-Source: AGHT+IHkBEpsk18sgWH1HNSZ66V59kVdPHIwVZPAJkg5NNZpV0MJS2yBmq1Do0iIjR0AA+V2LF2KnQ==
X-Received: by 2002:a17:906:d54f:b0:acb:205e:e0ac with SMTP id a640c23a62f3a-acb42c490dbmr482450466b.57.1744882306291;
        Thu, 17 Apr 2025 02:31:46 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:c8e6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb62b93234sm51717966b.86.2025.04.17.02.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Apr 2025 02:31:45 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: [PATCH 4/4] io_uring/rsrc: send exact nr_segs for fixed buffer
Date: Thu, 17 Apr 2025 10:32:34 +0100
Message-ID: <7a1a49a8d053bd617c244291d63dbfbc07afde36.1744882081.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1744882081.git.asml.silence@gmail.com>
References: <cover.1744882081.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nitesh Shetty <nj.shetty@samsung.com>

Sending exact nr_segs, avoids bio split check and processing in
block layer, which takes around 5%[1] of overall CPU utilization.

In our setup, we see overall improvement of IOPS from 7.15M to 7.65M [2]
and 5% less CPU utilization.

[1]
     3.52%  io_uring         [kernel.kallsyms]     [k] bio_split_rw_at
     1.42%  io_uring         [kernel.kallsyms]     [k] bio_split_rw
     0.62%  io_uring         [kernel.kallsyms]     [k] bio_submit_split

[2]
sudo taskset -c 0,1 ./t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -n2
-r4 /dev/nvme0n1 /dev/nvme1n1

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
[Pavel: fixed for kbuf, rebased and reworked on top of cleanups]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 5cf854318b1d..4099b8225670 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1037,6 +1037,7 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 			   u64 buf_addr, size_t len)
 {
 	const struct bio_vec *bvec;
+	size_t folio_mask;
 	unsigned nr_segs;
 	size_t offset;
 	int ret;
@@ -1067,6 +1068,7 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 	 * 2) all bvecs are the same in size, except potentially the
 	 *    first and last bvec
 	 */
+	folio_mask = (1UL << imu->folio_shift) - 1;
 	bvec = imu->bvec;
 	if (offset >= bvec->bv_len) {
 		unsigned long seg_skip;
@@ -1075,10 +1077,10 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 		offset -= bvec->bv_len;
 		seg_skip = 1 + (offset >> imu->folio_shift);
 		bvec += seg_skip;
-		offset &= (1UL << imu->folio_shift) - 1;
+		offset &= folio_mask;
 	}
 
-	nr_segs = imu->nr_bvecs - (bvec - imu->bvec);
+	nr_segs = (offset + len + folio_mask) >> imu->folio_shift;
 	iov_iter_bvec(iter, ddir, bvec, nr_segs, len);
 	iter->iov_offset = offset;
 	return 0;
-- 
2.48.1



Return-Path: <io-uring+bounces-1484-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 57A8589E7C7
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 03:27:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D219D1F23ABA
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 01:27:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5763865C;
	Wed, 10 Apr 2024 01:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VDqeh88D"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43FDEC2
	for <io-uring@vger.kernel.org>; Wed, 10 Apr 2024 01:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712712434; cv=none; b=B+RXC3Jft897RpFHeoCsjit7stfMeVdTVhx8thTKcO7eAY99QSXXOhQ+OB9u1cOV5+Up2pMEPbMDGftYbaXDLGVf0RTQDxyraK53hc/6Cz7nZNnguSYpa2tYKcjbratj3iQ/DvXZVND2jJol5w//errZ4c3aSbXZ/PemTOcun5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712712434; c=relaxed/simple;
	bh=W7w2Q9T23ojdDHLhaaU3uq16x93wWqFxci1pZqGoMQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtUqfZ0s5fN7N+qjxqEWO2zPpyQ4AllD08coEzeT1Zk7XuROECvxx+vGwb0seERo4J7nRH5e7Fs4z723jduP/UFmJAvxkNBWhLyJwqhiDjyFuvZvxvkWelFOL8LGdBojbGc1utZ5wgtJbtwQ+7h3gHbioaUWtjatL9u9rp+SO/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VDqeh88D; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-343c7fae6e4so4106760f8f.1
        for <io-uring@vger.kernel.org>; Tue, 09 Apr 2024 18:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712712430; x=1713317230; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IuWE7ZWtFQ3OwiocCsLF5BJ6o/QQL/vOgTFWzXUf7Vs=;
        b=VDqeh88DJI8T07eY88vaseL1i77WpL+/ufzaG1OLHgaRyIMbRmmPpOB9dlN1ofQ7TI
         ghxweDPRyS2nry6XPcpbWJdOWooeHxVPCiF6pHfPmBwUZAvmhgaNlLjw2oWG5goOFt2S
         6Z93eXRbCRohMdft8TPBAe+JdquYLKTE0PI71kJoK8JnxM08LWmCsZeU1VxLyIbcPqU4
         PIdwuQcXj533ppoLqN3dUBzLLnn7zaDngOmljWj998c1m/oPVnznT1oGPjyKo5xMd4NB
         kqSD0JRDvzuXQFND9iDd+k3sgP9w7PIRzMCbL5zYD0Te3um99Iv0N07Ih9Xn+z7I7xHV
         FErg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712712430; x=1713317230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IuWE7ZWtFQ3OwiocCsLF5BJ6o/QQL/vOgTFWzXUf7Vs=;
        b=UZR3AU6Dlcjw6TrGM9er5EZLSuHX7L+P0cIGgqujFiCt7VGIyCs+gV+/hYUccJr6pp
         IdItXMl235sLskVwYdzRmbwwuYNRXNNVVEReIs64pOIQ6gXQj2NSLzGFt53NzFa/jg7f
         84RRQmDdgLXmdWumYVftSVduE2VA58g7mMp+BB13VXcP8tMfPqSEPFG5LEXNnVunXq/I
         RIWzualZIfy6gF+WMPd28kgaPpQQBwMvyHVj++Ck8NztntCd/s6YUdfwVSNPMSDcBvud
         wlUICA2AIFswhXR17IioMOC+rSYHlIkMSwuFOz9DbKxOzlXChMFR3voPE8mfQVyX7zJA
         iyqw==
X-Gm-Message-State: AOJu0Yw7bkhOkjsIV+ENJMUSwOQWjMxqw2YRXSJNabCjv34RrjDVuRvN
	Ra/7B7vLjUwuU57R9V0mvKEWyD3JPLniQgqzTORnPRq1/s2RPxwPxwwZ+duw
X-Google-Smtp-Source: AGHT+IF+P4MxFok1WcfGuYpSNlGwnfnCjRwLb06i7SR8XFJPuwgktkzMzzbr4RttKr/wrVOc7Tk3ag==
X-Received: by 2002:a5d:634a:0:b0:33e:c7e9:3360 with SMTP id b10-20020a5d634a000000b0033ec7e93360mr736318wrw.18.1712712430383;
        Tue, 09 Apr 2024 18:27:10 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.132.24])
        by smtp.gmail.com with ESMTPSA id r4-20020a5d6944000000b00343b09729easm12737693wrw.69.2024.04.09.18.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Apr 2024 18:27:10 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH for-next 2/5] io_uring: remove extra SQPOLL overflow flush
Date: Wed, 10 Apr 2024 02:26:52 +0100
Message-ID: <2a83b0724ca6ca9d16c7d79a51b77c81876b2e39.1712708261.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1712708261.git.asml.silence@gmail.com>
References: <cover.1712708261.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

c1edbf5f081be ("io_uring: flag SQPOLL busy condition to userspace")
added an extra overflowed CQE flush in the SQPOLL submission path due to
backpressure, which was later removed. Remove the flush and let
io_cqring_wait() / iopoll handle it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7e90c37084a9..55838813ac3e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3238,8 +3238,6 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	 */
 	ret = 0;
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		io_cqring_overflow_flush(ctx);
-
 		if (unlikely(ctx->sq_data->thread == NULL)) {
 			ret = -EOWNERDEAD;
 			goto out;
-- 
2.44.0



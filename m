Return-Path: <io-uring+bounces-10443-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D6CCC414D4
	for <lists+io-uring@lfdr.de>; Fri, 07 Nov 2025 19:41:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F232F1883C7C
	for <lists+io-uring@lfdr.de>; Fri,  7 Nov 2025 18:42:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95A4D268690;
	Fri,  7 Nov 2025 18:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iHS6GBU+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46F9333758
	for <io-uring@vger.kernel.org>; Fri,  7 Nov 2025 18:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762540896; cv=none; b=TZCEv0g+m3WA8xVQ4GeEcUhM2wlT9Drlt773JvAY1q+3FMrlcEiMKueX5syTdjkakpmQWY5rcG1/XWGaqntJyVukJ/J4qnOlshrCipgqGJbDMfebYuNXJtwA+ScZbj2YRQU/oEQUfyQvvP2lkRRtWmpNlU167MiuozqBhT5Oazs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762540896; c=relaxed/simple;
	bh=S6jzR5NWItwoZssasOJDCL9QgZBzWZ0iMCVxO0Nkn7k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qiTtQIo/1ORnNWspDYZVjzhgn5UysckcAwjgta7ictHc6hrFZPsmCDIeBZaxPKQyfLV614nUNRmnJ7+tY62qWvOKtaDnxdGcMLjtC6wFmuQE4+UMecisc2bueP+5QNuzPnAsgAgcDrLHLjXMQ3llVWOIyXgLLIDoO//Od5lYpjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iHS6GBU+; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-427007b1fe5so620282f8f.1
        for <io-uring@vger.kernel.org>; Fri, 07 Nov 2025 10:41:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762540893; x=1763145693; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6ohkahrP3BOS4jTdnvpL7kcc0pbVg/oCN2xLipLgVNc=;
        b=iHS6GBU+dgqt0t8+ATHXIG3X9HTCrHH3AXRGRGtEIjJ9xAvbJMrKDekrmhrDHjTddb
         Ab416hI2IGq6nvs43Tm6Q21etYYv7AYJNUow27tVM+uXXrHNF5mfvLbMaScraJlmIqp5
         IOhOa9IMW+REvCddfn0maO4g8tNQ7TKoR0l0YdmN4blShrgqgYbklyrHRjJPPf23M+pI
         cc8MvUfqQ3YtdLslEcLv/+VVrGmu1ivG0/G/xFrJuvBNm20kl4laSxaoQCaKK7UUlWj/
         3qV5sIIseCEtaOW61EU2l+ofdzo9v+cAOs62OL6oLswAcNKZkfAFm0u/s/aj1Zsq/Y5p
         C8dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762540893; x=1763145693;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ohkahrP3BOS4jTdnvpL7kcc0pbVg/oCN2xLipLgVNc=;
        b=OEKj2v8QvkO7DBU1zbbIH6fTD2zs8J7m11chfeTRRqOUGLg/x5LS3dnNA0B6wIffAw
         FqQUoqkTu7EjhElf5uhLFjSNoVN+Hxm3bUIkQw16DclFt88S33WXyGf7TEH3ixZnpTz0
         Ez9+SratswhYkffz6IOcFU5ulMcgFzCUMWyP1iXP7YzUtt7AV9C6pKKKQgzDuRjNJlYL
         pBFwL6AqwF3h+Lwkq+0AvCCSifeQQ21z/JoGxsD4C4SAjm/GjkUV/BSlP/ppSmKtgGSd
         aaevKKoxJJHCVefClfKuPm9YP5v6dZgv1nw9SV3TR+abr5oYnB75wwwUs6jW9kmvrp1U
         rtvg==
X-Gm-Message-State: AOJu0YyQgAWxdDew87ActNeSEoQJg7KZVPFiWoGl0jX6zMu4fq+N4h8S
	kWbv0rSRa7GdFjYSJZhrUcY+NF9cSB1TOgyBJl9RgiTE7g+szfEBc4pQ51zizg==
X-Gm-Gg: ASbGncscyqpICubGk0RPrRu1FYTGSCcIDiQu3xw3bq5I2GDoSQRkUHa6BHvJ9xJQ7Xi
	SgsVonaKdAOZ67TIZQ8zzzOXq/aZfz26m3ifnzsa4l7MEdwfrtptG3r7PdTKChkvCUjA+l3Y532
	4eUMa2GFeNsjlJP5me36KRNYWhFaT0WxS5vvFkWXLynOUW3ukLapeekTuOs7nLDjSgBZUe3IrYe
	A8DG7JGtXTBAg7+4U3Ei3PQxm45Ih+zkzMFjOShqsMcG0CUSqWGrPChSj3OxVyczxTcrYUYrqhl
	ax6j78ruFym6xqzCLl4CqhpHoPF6o4uRfHY8FiBsGDrrQAI/ZlA4RqQkHN5Ssm7Nyav45TosSfe
	gCi3Y8l2slzqGmqwBzesPE7KdC0qtB93udXiUoMOl0TXz7su4epPG+r3IewifKS6gAwSK4Ju0hr
	OSxyI=
X-Google-Smtp-Source: AGHT+IHd32z3BS3GCXAJOHAecP79JP50jFETUImz9xCmOzU5N/1pIhrpblpdrniNzbXFHziQmgfu+w==
X-Received: by 2002:a05:6000:1acb:b0:429:d2a7:45a7 with SMTP id ffacd0b85a97d-42ae58d0314mr3621218f8f.25.1762540892570;
        Fri, 07 Nov 2025 10:41:32 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac679d54fsm6672256f8f.45.2025.11.07.10.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 10:41:32 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	Google Big Sleep <big-sleep-vuln-reports+bigsleep-458654612@google.com>
Subject: [PATCH 1/1] io_uring: regbuf vector size truncation
Date: Fri,  7 Nov 2025 18:41:26 +0000
Message-ID: <11fbc25aecfd5dcb722a757dfe5d3f676391c955.1762540764.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a report of io_estimate_bvec_size() truncating the calculated
number of segments that leads to corruption issues. Check it doesn't
overflow "int"s used later. Rough but simple, can be improved on top.

Cc: stable@vger.kernel.org
Fixes: 9ef4cbbcb4ac3 ("io_uring: add infra for importing vectored reg buffers")
Reported-by: Google Big Sleep <big-sleep-vuln-reports+bigsleep-458654612@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 4053d104bf4c..a49dcbae11f0 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1405,8 +1405,11 @@ static int io_estimate_bvec_size(struct iovec *iov, unsigned nr_iovs,
 	size_t max_segs = 0;
 	unsigned i;
 
-	for (i = 0; i < nr_iovs; i++)
+	for (i = 0; i < nr_iovs; i++) {
 		max_segs += (iov[i].iov_len >> shift) + 2;
+		if (max_segs > INT_MAX)
+			return -EOVERFLOW;
+	}
 	return max_segs;
 }
 
@@ -1512,7 +1515,11 @@ int io_import_reg_vec(int ddir, struct iov_iter *iter,
 		if (unlikely(ret))
 			return ret;
 	} else {
-		nr_segs = io_estimate_bvec_size(iov, nr_iovs, imu);
+		int ret = io_estimate_bvec_size(iov, nr_iovs, imu);
+
+		if (ret < 0)
+			return ret;
+		nr_segs = ret;
 	}
 
 	if (sizeof(struct bio_vec) > sizeof(struct iovec)) {
-- 
2.49.0



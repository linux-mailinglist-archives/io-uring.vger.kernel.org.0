Return-Path: <io-uring+bounces-6163-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E4BEA21350
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 21:56:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1E933A5862
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 20:56:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06C3A1B413D;
	Tue, 28 Jan 2025 20:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eo8SMujv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2401A841A
	for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 20:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738097764; cv=none; b=P5N/pKQ0GxaiL1BG1D2Ug1gBfMwSb5KS6w5zqalUt3uOEpSAbEQHptFEz9jVBSTtx30jy4loMZTgwNO8DAzPFYqsVrZxxGDyvALza5ceDqgkUt/C3+OFVVA5TmkMQ7LDSX/ZnE19z5bdjOS7ttxUCNNBebNVMNlC4E0Xv00dwCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738097764; c=relaxed/simple;
	bh=AAb5+UaRzsQRURRie90KVCp1WXj1aurr+6hUeUCdpsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJ1hwyVKB2rLV8CA4giC4/YdSxIeCbcef5j3iKxZoitWdOSNVYzb5WlmrwSqLLKFzSF6qMQj4T3b25848MnaBSuFvSGCF/Yl9+UYrb9lpjcF03QHnIH7+9f9a10xLT6ivQg0HFpKhGdfaOtA6Fi9E4q1RtPdN2GlUJmhXTnYkTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eo8SMujv; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5d0ac27b412so8101331a12.1
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 12:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738097761; x=1738702561; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KCcdkzXW6RkVCvu6uTk3n/nlNEQ2Ngvhu2rXJjQst0I=;
        b=Eo8SMujv4kklauuqBp09yfIbNMotLuWS/UwvvqjC2Qs+Wcn+XlFUL8xF6eDknaShf4
         /TzZvihTpuwe7NApnvLFQNXjCtcgBaavECgAEGlRucPFHuFhLeL+Fma6PUOFGqdUwoec
         +MiB6MQ462pEJbv+5GW1xJJDODMZR+kdncuT8A5iXmWGwOyrbzUgJm/I3sj4g9kPMKlr
         qVOEMSQGK0fRrGqKrQ+9hY+z1TDlNmId1pFDbcU/tc6NCEZ0X5FtN6/I9JfaorkNpItH
         ecMHLaa4m6mjqHOvBjDz1o7fbhARujHVZ2LhJp9l4QSZFS7a6j49AYaMcwEswTki1oMB
         IUTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738097761; x=1738702561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KCcdkzXW6RkVCvu6uTk3n/nlNEQ2Ngvhu2rXJjQst0I=;
        b=ME/7jjGGooTO4p2TdNCtMCTvfwRN0vr8bC76meBu6KUGauwG204/mu2gnujfWYdY+C
         wZxyhDnNXeZRg3db2vL75a0iO1ClACDI+IHEGZZvI87X5wEzq6ziOv1TK8lAQm2S9xo2
         dx8nrDPD/aL5gyrDdUlw1BvCfQspJ7q+DL3BlM3mMrQ50v5hU9E0tF86Fck0cUhMhvZD
         RY4kiHIf5fUaRj0VQFWfxctzYahVv3EGWoysJ/j4ekDHV5v0eoFXA3uzogXZORT5aXzU
         1Roqjl9iiXxiObsi8fBwe8HE9prUt1j9EANyestUSfZRe4F6Tz/RYxGBuBX2NXbc8kM+
         GRUQ==
X-Gm-Message-State: AOJu0YxVRUSuj6jtLQ62KW5iuFGUBZcP+ozjUdZ5mA2FLE4gYmX9X7IX
	fR77bExQV7ARJmgLA1gzwLMgHKEzs4+1jF/3rKcj7gobvpnRXWX6gpqhWg==
X-Gm-Gg: ASbGncvOv/xn8S8HKV+hRSNzcdMS8lImXeM01uweznZCNAD5T3d1VsM9HlXD0fOhlHy
	IMgAjpMvaRlYONy87R4WSCfpU5fZH5nJKPUrmJx0lSjRAWJB/IQzL3b6VOlOTK39FaRiieY9jEW
	E6sryxBLN99J+dTNI1TjYOrUn4TEmvWoaic/WTlMezdrxCPzkGXsvztIRPlh2u0if/GzXgxE0Nn
	+O4WaClyya/BDR9KsLzW38WqnQT3tBdetiPyQTvPMg4WO02YfTxKsIetdQFOcvv6wf+iwox5pAD
	T91Wlp6Kw+HLbHahmWGRpAE3WXL/
X-Google-Smtp-Source: AGHT+IEa+JBYjX9cLg31T+dr+XMFlBp1NNzDhs1Gb2+bd2LtROHyyvNEGAXe0HFHGvkuo6PclM2l8A==
X-Received: by 2002:a05:6402:1ec1:b0:5d9:b84:a01f with SMTP id 4fb4d7f45d1cf-5dc5efc5dd9mr458050a12.18.1738097761195;
        Tue, 28 Jan 2025 12:56:01 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.145.92])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc18619351sm7736949a12.5.2025.01.28.12.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 12:56:00 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 2/8] io_uring: dont ifdef io_alloc_cache_kasan()
Date: Tue, 28 Jan 2025 20:56:10 +0000
Message-ID: <35e53e83f6e16478dca0028a64a6cc905dc764d3.1738087204.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1738087204.git.asml.silence@gmail.com>
References: <cover.1738087204.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use IS_ENABLED in io_alloc_cache_kasan() so at least it gets compile
tested without KASAN.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/alloc_cache.h | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
index 28436f413bd2c..9eb374ad7490c 100644
--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -8,18 +8,14 @@
  */
 #define IO_ALLOC_CACHE_MAX	128
 
-#if defined(CONFIG_KASAN)
-static inline void io_alloc_cache_kasan(struct iovec **iov, int *nr)
-{
-	kfree(*iov);
-	*iov = NULL;
-	*nr = 0;
-}
-#else
 static inline void io_alloc_cache_kasan(struct iovec **iov, int *nr)
 {
+	if (IS_ENABLED(CONFIG_KASAN)) {
+		kfree(*iov);
+		*iov = NULL;
+		*nr = 0;
+	}
 }
-#endif
 
 static inline bool io_alloc_cache_put(struct io_alloc_cache *cache,
 				      void *entry)
-- 
2.47.1



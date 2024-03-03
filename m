Return-Path: <io-uring+bounces-817-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C494186F7EA
	for <lists+io-uring@lfdr.de>; Mon,  4 Mar 2024 01:00:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E6FA281454
	for <lists+io-uring@lfdr.de>; Mon,  4 Mar 2024 00:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 943542CA4;
	Mon,  4 Mar 2024 00:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XGkrI7PK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BFE15D1
	for <io-uring@vger.kernel.org>; Mon,  4 Mar 2024 00:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709510424; cv=none; b=YHwgZOlwckGrEPbGDVeFtHsRxP81RoSN5pkfruofzXreppjumG14qqQcWvG5nuSD/bQRz2b2PkR4+f8ksblgCcLX0IRxMfIs456l7RIrOt4DRxiytTHfS7NkOxk7y28gfpGu5DKo6TEdN9keHs+SQcM2QM9NVamg5JxJ6FVv0jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709510424; c=relaxed/simple;
	bh=/Gl7SSgOa7YpjCVphkg8a5Vyj2YfRR6gpxjGPW4LsCg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Go3ThLXr5DQ53NQsvzumKRdJtXzICsDQo+pAsr94cYGqudzA9gREirjMKq1CGwzHahsmCeXEzCaVD4qulBMfVKq9Jg4twL4slv9WalEU5piKwKj4CnOMiok5o7IzXd5Nab5dNxO1PWsAVC2Tmiz1P6z+mv+AV5EoNNr+AxT6+Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XGkrI7PK; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-512b700c8ebso4296859e87.0
        for <io-uring@vger.kernel.org>; Sun, 03 Mar 2024 16:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709510420; x=1710115220; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LbyD+vs0aIrgzbargyA287SLkdFHlcfZU0d36iAZYZc=;
        b=XGkrI7PKRO2fF8oacHgVohQ3hMxmdLgrranYPWEIJpG8HeBFoKlSqAWfwD92Ud03Xy
         GKsPbPmrW/1X8PioHwrb2xAKHHk9TxQ1L2/Jnh19LMRDsDb7kAkpWS9zxvXt+FOWmV+U
         emd7MKMWOrractwHNUzX2EjlgqAQszBaol+rZGPjM+pR+PcDDUbmn4Xt0mWR096qEeIX
         tRjAcknX3ErYPQ6bfS662YJY33FmmurHnOZSSPZ0zJ4bKnm5vJf+TQmrR5QmUMOfAd/R
         Q61VxhPBspnQQoZg5RPkGtr/A2ewC3NdS45roXWsrqtTTsQ4FrITKXYX5Qx+KyTxBUkc
         9kgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709510420; x=1710115220;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LbyD+vs0aIrgzbargyA287SLkdFHlcfZU0d36iAZYZc=;
        b=o4LF/704qDcXHgtjdWYfcxUr179I4PyMfu7k6/ofVcL1Lpy507opEimou1UJgorlCF
         q5wmYy1KOdhjFfCUOyoXxZmnen9g4ILkrR1RsxPKksqgfSEB95jgqyFmHJNDd4/y26FK
         y0sVwRo0LN0ytNI+hK1/+cSdzGI4klvazNYRaIeNDV0S/RPfEy+u3jeGgmTxXnD/M5V3
         avfe3d4n4HKcqw3OF1EOi8ggQUH+VqPkuWiJ3SXsqs0i7p6KTrmCyITbW9wTXBOdleQH
         D6QiSzjaC92a5U/8YdRNdHEpvAOL+j9Chz99rQrSOhP8TRlJIKGeJGaZTJRxpe0lFPmh
         xGoQ==
X-Gm-Message-State: AOJu0YzSX5prBsSuYashflxzFL7u98U1p4koIV/YPeTGlZUC/UlgATgd
	AnOLk8zz/y4Gl5Yf/dFAuOceL0QyohVX0FVj+5mWAOLrcVAoADrXgVELBgfO
X-Google-Smtp-Source: AGHT+IHF5h/9jWntx2TkIxSNSKCg5TCfqjBPFTi8MXLqThVZZa3oOqkkvx8QRv2nqHOA5K0z0GzdPg==
X-Received: by 2002:a19:8c48:0:b0:513:b8:fd51 with SMTP id i8-20020a198c48000000b0051300b8fd51mr5051093lfj.45.1709510420180;
        Sun, 03 Mar 2024 16:00:20 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.147.152])
        by smtp.gmail.com with ESMTPSA id j11-20020a170906830b00b00a44c723472bsm2260612ejx.57.2024.03.03.16.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Mar 2024 16:00:19 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing] man/io_uring_setup.2: document IORING_SETUP_NO_SQARRAY
Date: Sun,  3 Mar 2024 23:59:17 +0000
Message-ID: <dc574ee0e7eebe7deb691ddb18b9643495ea8331.1709510250.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 man/io_uring_setup.2 | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/man/io_uring_setup.2 b/man/io_uring_setup.2
index c86f2e7..f65c1f2 100644
--- a/man/io_uring_setup.2
+++ b/man/io_uring_setup.2
@@ -327,6 +327,18 @@ when calling
 .BR io_uring_register (2).
 Available since 6.5.
 
+.TP
+.B IORING_SETUP_NO_SQARRAY
+If this flag is set, entries in the submission queue will be submitted in order,
+wrapping around to the first entry after reaching the end of the queue. In other
+words, there will be no more indirection via the array of submission entries,
+and the queue will be indexed directly by the submission queue tail and the
+range of indexed represented by it modulo queue size. Subsequently, the user
+should not map the array of submission queue entries, and the corresponding
+offset in
+.I struct io_sqring_offsets
+will be set to zero. Available since 6.6.
+
 .PP
 If no flags are specified, the io_uring instance is setup for
 interrupt driven I/O.  I/O may be submitted using
-- 
2.43.0



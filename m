Return-Path: <io-uring+bounces-7403-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AC44A7C171
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 18:21:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E36B21891B62
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 16:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD3DB20ADD6;
	Fri,  4 Apr 2025 16:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OnUVqai9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AFF3C38
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 16:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743783669; cv=none; b=qew1E5//gkpPnOOiBj8HA2fAzXMV7h1Jj2btVJ88N9UnbnLchxXD078yH6w61je8tSxvGKXcg5tvfsbiWM/1SU2dJzQY4G/GFhfg/1TqsNs+wC5m+XBwh0FT0JkXmZrK4nOWB38t/rhUd6FHeX5podDxff7QnwzBRu1Hvf8O9Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743783669; c=relaxed/simple;
	bh=o2svi3GX9Tn1yGnFY4198tJZYNB5MwbgSFvD9XY6r/U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T15gt6NeiDnQBlFEK7WslzbUFMf86VPycW1u+8aeBfUm/zrj1vFCXvbddXI8dj11B/4+rbJ4zvGQXeZOMq0Eh/SAeGF69sV3FGy3WHoLwB6sidIndfv9HPp+v4pLpHO1QnfaNbkGj6w8TcE4Y76lS38vd0iIFqnPPbLIvfm/m1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OnUVqai9; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ac25d2b2354so394268466b.1
        for <io-uring@vger.kernel.org>; Fri, 04 Apr 2025 09:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743783666; x=1744388466; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4Q9RFc9Hy8xsCqZC+q5WqHkHe7Gg1HU1Vtvq2hvYskI=;
        b=OnUVqai9KR9heDKYJRrVxksEqoeoV/8ZzpQ1lj17jn+QM8dUP5UcTFJMr8Pwdoxyjx
         rWecnFTdywLMsovi19j1M45qTpIvjLRw8DAoIF8JhMV0nA+R47D87WQYQetGDM5j9XGX
         K11MD9sGi02jmEMjY8EDWmbijZOfxvrtrxQ8WdTB3eI5S1QtBWk95a21uIhA12u65eHH
         Tyd6KB51PHL5cSSenQu6kycaiIVINgcqiAr/B/1tzsC+c5PtG2DEKDou1Eod3S5Ns2Co
         RLECRBZpoNv4FWCWhfuDaO//nkILVlnN4l+Eqo4zlX7O3TMZnu4DWLMOg1GdtvaZSWOG
         MhqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743783666; x=1744388466;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4Q9RFc9Hy8xsCqZC+q5WqHkHe7Gg1HU1Vtvq2hvYskI=;
        b=gmRCCes45srKfYsiXFDbp3WpbqbahmJaii2opZvi6yjdZcV5/5jZPc5z010MFAmoNC
         1w/mCwSF7LAj2bRfeMJPtWcGAvUojR/C0bERmKJESqsj8lTDenRDgV6yEpO0tFz/EUHb
         J5nUlI4qOO7SYk8bWYvAQXD0rDSFRUerrVWmz+eQWNNiXcPcCr6nbiExl2kO9ctF9SYL
         UYfJk2GDqzpW66adk9WDlZA1brB6tLPEVlmoGFM+SM0B0wxwu7i1Hr6KhqQ8ZcJ1Oh8R
         LklWL7iacH4+wIudi7vNKcOW786pk2269ry2lTv80M0AIhGlYOnM3pn/ziVvJUQysj4y
         RJWQ==
X-Gm-Message-State: AOJu0YxfbBDxLnrXPf3Kd4A7YKhdO0m0KIAB2Ob2PAv66VSr/56LWHU0
	w3gEcBrTmaQ12kg5x5YdwdKUgd6C9IeUxodYaMVewgrd9ab+MgU2ZiP5cQ==
X-Gm-Gg: ASbGncuxUsXYEMfDEV7jpD0+x8C44A8mvw1xfowrxRuEM61zggprCAhRFey4w4STmgr
	Sb3CmmlKE72S2ZJZAlsH8rtP/+mEqR0de0oNXTez3xxDg1u1pPL3wb5CPstyloQ2BrCDhH3ekfe
	0OyQEP3UoOe7rz2BoteOemCGQ8TYFlT9NeUMYdObBZ963DBlFMGdsxQZtQ3R036WJg/boTWzoQs
	dVAW99YX2q06jgaVYw4hla+BASyFXZwmuQ1DFrsTgDENayi5ebu2G1AO2D86DI/ZQG597gyrjHc
	qlw0+xr4cUBhpRHipdQbZUi5YONW
X-Google-Smtp-Source: AGHT+IEksAeKXLyO/YNtAN8IEGmPwqpGffLasBafJHwLrxKwhCXBFJEXZlzBcHED0YXXqmS38X7Cbw==
X-Received: by 2002:a17:907:9301:b0:ac1:ea29:4e63 with SMTP id a640c23a62f3a-ac7d6d53ea2mr292976766b.26.1743783665728;
        Fri, 04 Apr 2025 09:21:05 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:ce28])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c0184865sm273316066b.124.2025.04.04.09.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 09:21:05 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 0/4] buffer table registration cleanup
Date: Fri,  4 Apr 2025 17:22:13 +0100
Message-ID: <cover.1743783348.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cleanup up buffer table registration, and deduplicate it with updates.
Similar series can be done for file tables.

Pavel Begunkov (4):
  io_uring/rsrc: avoid assigning buf table on failure
  io_uring: deduplicate node tagging
  io_uring: early return for sparse buf table registration
  io_uring: reuse buffer updates for registration

 io_uring/rsrc.c | 111 ++++++++++++++++++------------------------------
 1 file changed, 41 insertions(+), 70 deletions(-)

-- 
2.48.1



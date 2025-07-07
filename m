Return-Path: <io-uring+bounces-8605-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AC8DAFAEED
	for <lists+io-uring@lfdr.de>; Mon,  7 Jul 2025 10:51:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 136B61888C73
	for <lists+io-uring@lfdr.de>; Mon,  7 Jul 2025 08:51:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2AA628A70D;
	Mon,  7 Jul 2025 08:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fqda/nxn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258D11C5D7D
	for <io-uring@vger.kernel.org>; Mon,  7 Jul 2025 08:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751878274; cv=none; b=KG6KCC/4WioJYAvsRSdY6m7mOIJCbkLo0VaR6070icosF9728vmGYXM4ZDm9nMpFPzPqgmyh2NCwvvJUZfem2M8wHUtflLoKSW22L8/f8tAdmeuP55fpW7/NHk6dAyTEMTd4pUmhArGpU7bVHyQ3JismO/siBw+NGeW3ETJbVKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751878274; c=relaxed/simple;
	bh=COGqg4/NqBGC8geKbkEgWJT6MTC2JmXRMlzvGnIMAM4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NnnLS9GmLZ27+w6mtgIMtBbGkwjY4KAkNf7W5fKqWp8kKAeQ9+lI+vQE4DRQReBJodO6C1fIRbhoov6lW9dRH1Iw9yxGVNODIB+TNdzQfmrRC8DPdumCu3lpgdV04s2nW845bhIReAdTWLks0vClZjc7KooyTecmFIn1BuMJses=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fqda/nxn; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ae0a0cd709bso814773366b.0
        for <io-uring@vger.kernel.org>; Mon, 07 Jul 2025 01:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751878271; x=1752483071; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GojiWvRJyv/spnLuMRTVRgq217mQrTDXa+EB81cNv1o=;
        b=Fqda/nxnZVvDereVF0OUE5dt1DkOqFsGwqj+pBkwXnzvD3Lmufd6lFmN/VmpB05NOW
         Bor9kdU3ITn0RnPW389WJYUXHPi5Pwc4kizh//6yU/FihGH5lNrcf+jtFkgqoogINa67
         50E9WrDy9SOGTLTGuJ5YkJwuqBd2a8rUa7yUTd+2Qgszw8fW14/DmctL3WXzZ7MaDeVU
         /9JqehHDzoxfHf1a3dU84qIuAjFudR6gCl2kuQGfefIn4GUcTleWDOXmv5XIhwGhj9we
         6qDqjIRMOLl+eKjExgcsmUsEVomHMU0XmLTbKAs2wBjL/Q4LqR1t4WtIpJQJiLk8Pr9F
         IBcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751878271; x=1752483071;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GojiWvRJyv/spnLuMRTVRgq217mQrTDXa+EB81cNv1o=;
        b=fTcU04jt1aI62Pxv3hsf5P7hMijNoR+bAzc9V8hDaLR68MFsAM2zsufGSUlR2n3VYN
         7UTW4heY2Q5zK2thjcJoejkSp80zUz0Kgh12PDwhSSYEMmY1s7lw36b+5lbso/k1UCaR
         oHC9VyOW/jmqQdsnwTr/vHB4fjNYBoPEsDOmNxH7wQ/tfT2Lwzx94H1gxZwDofFjp6Zw
         xX0mU/rR5gv5ZMP8vINStbUK+296X0tLEMa+nhTZXkoOfZcJ5eTSD+ANgrSEGWHHSCrM
         /NG05/N9NkwRxLkGs/WRdkzIJPDvtEM2x+rfpXXg8FGN2B6Mgq6Nv+PPLWZRkzaB201Q
         l5qw==
X-Gm-Message-State: AOJu0YzTuKEIkSl2XxkCcgnBhAhEhfC45JIvqU/Dd3kTiRo5IwpfB9qt
	YVdIyTOnljCvK6ZLB1LHWAiSdqVNL6gWqYDh0h8RI+Clc7boPBz7Okojy15aKw==
X-Gm-Gg: ASbGncs1K/8iXRfuY4RqJiBiZcscgqbu1V34t6wfr6uo09vepI06xOMoKBk5tGcDXgY
	9WpuMDymEe65dUOIW+85oQVaBuftZWhh9Wzj5muAhHn+hVGr1vcJcEFw09bHVk8KAR+gXjQ+RmS
	//Hz/iefNnOV/1n9zeGWQUiVZdDu8fKmiorR67QmbOC4GWfS3Kjx0xFo/uOrexKd03aMlia5qQh
	flg5/GdBtqsfQdmCUwfMg+E++kOy2qphlv8MTuYifwNt19RkZqF7A9GTpLgBVIIu6Uxig53Skzl
	3VyIqj3W99Wc8/pr4Iy9k+Ju1M9AfyKae9b/3FcoGyWhjq0E2uON4WSy
X-Google-Smtp-Source: AGHT+IGITOwjvZG0cKinmkciqb3UB6j1rZocD/1xRDQX5I+XOywPPshQcwqgaH3RnRQ1+7hiV0JLzg==
X-Received: by 2002:a17:907:e90:b0:ae3:eab4:21ed with SMTP id a640c23a62f3a-ae3f80acbf7mr1326951266b.11.1751878270789;
        Mon, 07 Jul 2025 01:51:10 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:30d5])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae3f6b600ddsm663331366b.158.2025.07.07.01.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jul 2025 01:51:10 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH 1/1] io_uring/zcrx: fix pp destruction warnings
Date: Mon,  7 Jul 2025 09:52:33 +0100
Message-ID: <b9e6d919d2964bc48ddbf8eb52fc9f5d118e9bc1.1751878185.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With multiple page pools and in some other cases we can have allocated
niovs on page pool destruction. Remove a misplaced warning checking that
all niovs are returned to zcrx on io_pp_zc_destroy(). It was reported
before but apparently got lost.

Reported-by: Pedro Tammela <pctammela@mojatatu.com>
Fixes: 34a3e60821ab9 ("io_uring/zcrx: implement zerocopy receive pp memory provider")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index ade4da9c4e31..67c518d22e0c 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -862,10 +862,7 @@ static int io_pp_zc_init(struct page_pool *pp)
 static void io_pp_zc_destroy(struct page_pool *pp)
 {
 	struct io_zcrx_ifq *ifq = io_pp_to_ifq(pp);
-	struct io_zcrx_area *area = ifq->area;
 
-	if (WARN_ON_ONCE(area->free_count != area->nia.num_niovs))
-		return;
 	percpu_ref_put(&ifq->ctx->refs);
 }
 
-- 
2.49.0



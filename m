Return-Path: <io-uring+bounces-8720-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4100CB0AA7A
	for <lists+io-uring@lfdr.de>; Fri, 18 Jul 2025 20:57:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D1FB9188D690
	for <lists+io-uring@lfdr.de>; Fri, 18 Jul 2025 18:58:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1FDC2E6D31;
	Fri, 18 Jul 2025 18:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JzamZrWS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C2D2DAFDD
	for <io-uring@vger.kernel.org>; Fri, 18 Jul 2025 18:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752865073; cv=none; b=O/cFm+5btz6/5p+XYLoMjomJjEcaN0TdeLSi17YleSRaBZuWkvMMwcvG1AJviTFuRMCoOnvucTEUA8mXqmvkRTmNSmk91CkKHGYfI9UHyY20clI1aQn9wnhB0C7pA0xIqxed98RBnY59tEiOCJjpBX1HZGx455BI5ZtJ4AoKai4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752865073; c=relaxed/simple;
	bh=YgUaW2AR41TMARe481I4NV7oc+X4DYsJYsBVJbZwGNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5EqWB2gk+m4ZCYHNu2rtyOrrEP7N8a5Vq0drJZPPFUWMgIt+dD0ohRPjd/SelC1slU7AKk+RL0uaQl/8nuF+lFdgqdo/b08FA8J3paCSPFCFDpywt/cyA3E+3QC4VkihOADmdNKOtR//UO+ou1tzg+nVCkxZSK21JnfUqfSPwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JzamZrWS; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-606b58241c9so3798142a12.3
        for <io-uring@vger.kernel.org>; Fri, 18 Jul 2025 11:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752865070; x=1753469870; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aGDqU1Q73PrWu5+33OEp0F3Z6bu9QDTf6ARIQc/QG3M=;
        b=JzamZrWSQHFye/MDPF36jcIKMgRBHPOUxKyamjsPTFpxnZwRPPQgaEhQuBPa4V2s0O
         ccJjKR6adRbAMNmuJHcQDStM2bjC+ZAITb+3uYIrMCISgAotS7l4FDsDE8776skCNVIj
         wOT4N4GGEBmwVPkyD5fbPppMt7cz4aP82ZTARCvag1r0Qcfu9FjpdLlYQZ4Ut56neLWq
         vtrZrCKQ35KGVguJhIMYqSyNp0veE3yjFFmyv4H3JdhzZD772AsYuviylxBxf4V+1Qpl
         dvpxlA0w2RxsadvbhKvFWoeVXbnrTp6ItP1JLfQPHzqdx4qqRn10DbeB0G6RLmJbVbe9
         O14A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752865070; x=1753469870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aGDqU1Q73PrWu5+33OEp0F3Z6bu9QDTf6ARIQc/QG3M=;
        b=IUrQsr+al4hjgdVcB7MkK80vn628FhRSqU61hxg+1HSYmqVDMndn2tBTfRm5K+Ex/y
         2tuBzwkTtjioN6pK1386XD2/9fhFOLbPazTjB2hY5V9boxJreezYw0/nJ8OuH0MsuWya
         tAnDynoe33GEOBoDbLhYgqYau7Zel0pczjwSOjzmyZsWS1J484XuXThRwvRKEiL0Jsy5
         +1JllK21bpKCxvBUmZnR84z69NUTh81ayE2hGhnND6jqswm8H1MNOday97yYPBG0O2Q4
         fptgb9tA/t1vTmBd3OqFN80sM7rezL7/5DaParrp5IsJ/L+64u5FM5MQRGE/nzO0yFFZ
         nehQ==
X-Gm-Message-State: AOJu0YzfiJgcw/cIeKZS11YwIA+HMHlo/doU0dz/rG5XEB5CryiLjyPI
	EpU4shrfrIm4ujaaxpPZsDCk2/Kau2m9KrzvxbiOKZEVD4ZLOmRcUx26XAyxsg==
X-Gm-Gg: ASbGncvXvGTX7Cy8wLYeHggSDiyi3aRpC/WrAhnqfam0OgtprAkI9Ci+LXzqLc/OT9w
	59Z97uiSQlxO1aXR82ToVasoWw061qeFEedP3V7Ap2eTrQulKldk6WEdBDpT7xa/KP2xPr4msyL
	M4TjDa1QhY9DjcesNwBGYsXcH7ytAugOBZx/qhbmPeQqTA2rFEXcSdBmS43wXAuMjQJfMdlQU65
	Zi/bnZXDt/AY3Kw3YYcOF4Yopu1sS8CqIty4kB0a1DEqV6+8rmAAjmGTRyKT7wrEK2Q1lB3Liwm
	TxDF8zde1Yhh3lGTTLWozT32PMcUScyFDInqCsCJUuCVKJ5XedibialBDprv6wqX9RaFmr3n/G7
	lY9lC2Jv53shWNQOtIWr9DtSl9bTMJsZNbtyP
X-Google-Smtp-Source: AGHT+IHWXuKqOgRLjawsZ//Vku4KznuIyFmaeW9nkMomSBSUTQ9I8SrYNjd6f4ZFEOoMlif3jsIAbg==
X-Received: by 2002:a05:6402:4410:b0:60c:9ef6:8138 with SMTP id 4fb4d7f45d1cf-61285dfdd72mr10571903a12.32.1752865069990;
        Fri, 18 Jul 2025 11:57:49 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.246])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-612c8f09dbcsm1379130a12.12.2025.07.18.11.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jul 2025 11:57:45 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dw@davidwei.uk
Subject: [PATCH v2 3/3] io_uring/zcrx: fix leaking pages on sg init fail
Date: Fri, 18 Jul 2025 19:59:04 +0100
Message-ID: <6febff574964426984ac7baf7389f1c047ffd633.1752865051.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1752865051.git.asml.silence@gmail.com>
References: <cover.1752865051.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If sg_alloc_table_from_pages() fails, io_import_umem() returns without
cleaning up pinned pages first. Fix it.

Fixes: b84621d96ee02 ("io_uring/zcrx: allocate sgtable for umem areas")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 4f9191f922a1..2c5d4e7c3b47 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -194,8 +194,10 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 	ret = sg_alloc_table_from_pages(&mem->page_sg_table, pages, nr_pages,
 					0, nr_pages << PAGE_SHIFT,
 					GFP_KERNEL_ACCOUNT);
-	if (ret)
+	if (ret) {
+		unpin_user_pages(pages, nr_pages);
 		return ret;
+	}
 
 	mem->account_pages = io_count_account_pages(pages, nr_pages);
 	ret = io_account_mem(ifq->ctx, mem->account_pages);
-- 
2.49.0



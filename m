Return-Path: <io-uring+bounces-4761-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D61769D00F7
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 22:27:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8126E1F234FA
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 21:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 718B719ABCB;
	Sat, 16 Nov 2024 21:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OSCb6ycT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B397519D096
	for <io-uring@vger.kernel.org>; Sat, 16 Nov 2024 21:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731792437; cv=none; b=M/wsTvYAEFszOwA1lpQCV7kO8caTtSgBnqFPf2qk7x/TIWV4jpE9qnngSB3UuCdcOwPC3kvYEpO/Ou3imMvLuuM64SJIgyzOuXRnreUuAwXIx6XfJMDNi9q4vxorc80KkRN/Khdu0CqBGMW1YWf83acUd/FqpPeR/pfEpIUQJgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731792437; c=relaxed/simple;
	bh=OU7dryaE8SkeouRhD+3wmcD0a8lTfRG4iCSTyA7gINo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0S6yJQtliiWraRXOVM3nfC6OdZeAcTQWScV4PCKlTU21p9LqaIX7cmBy10YAUyOzSqxXg/JlxdurkipvtrquNYETQnafQq7frVjRXbznuPUxtsCyy79+7Gt5k6c1xEZBgZclNHbBCde59f/PFZ0iedzT7NUbUVZ10K5MlIwOZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OSCb6ycT; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-431616c23b5so16691465e9.0
        for <io-uring@vger.kernel.org>; Sat, 16 Nov 2024 13:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731792434; x=1732397234; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JNIFDJ60IAyJpMisfwJXe/VMtMZ+0miT/Bgpj+F9MiE=;
        b=OSCb6ycT0FIskw6ymowBtdHtQWOfNIn7bw8YdV8HPfRWNSXAtsNvW9qsLa4NihzdgP
         SQdMv1QgY97TfKUZWxY+5avAkKGzkX69hpp+BCNX6YKETwssZKxuRT5Uphbph2G2vRmk
         PYw0CEt2WfSd03NbB+VW/wYw0d9plbnoIPuHwatvuBO35IdJ3Zb6phWxr2Ek+ePl6jaA
         Sj8Vh8dKX2SHo2+tlxMAyyuZCDRpFg3zJSEFxqzYZ9J80pZ4aGY3zAbAmg19Vk/nMaoA
         vrkoSTdshnK2rieBbbsB/dqK9sJI5n7d8I5++BydxC34NrfxhJ0+Zdrqj2Ol1Rtd/LhD
         VPrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731792434; x=1732397234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JNIFDJ60IAyJpMisfwJXe/VMtMZ+0miT/Bgpj+F9MiE=;
        b=HldtwVZQDb3ZQjqHJCvcOjfZJZ2YsBF1sNTN4kqeZZAEIrtnSp3KDM3WWInpN9d0CD
         aAKZ/GU8XifWxEJn5/g5ysS1hJ0cVr+gfLbMwgL8+SXMc3SoXNgeN//v4Xtm59aWOcEV
         l9CmV2gkgp5Ireqa+Dta3qWQd3IbQK8yJAv7c99YMXQF2w/BDR38FMilidSI5wfRJynR
         LiaVhTS8tqz0X90R/09pny9aOYGqeHmvyD4YpJTAQP975UGjqtWTtj1zoxjoKXQu0N+I
         lQvATYkhL0vSCQYf7/4gtpSMJ34vn7avrglWnJHR7xVa2rtwvZxOd8vuXI0hzsGw2jcg
         rtGA==
X-Gm-Message-State: AOJu0YxsTxQ+Hv1wFkkmSjb93Uw58Z9P8q97CAXcLAeKq4TUJ8GvCAkI
	l3CCkKtR9pHhK/hcWmZHPOQMV652DOXifBB1/IJoTup/HtKmVbWebP9Gjw==
X-Google-Smtp-Source: AGHT+IELAHILVld3gHVeQgnVEPANfFQ0GImclvNSjbiczLorHv9mkEoeVje1k6Y6l7wdV/mSNV9w0A==
X-Received: by 2002:a05:600c:3c9e:b0:431:52da:9d89 with SMTP id 5b1f17b1804b1-432defc8b2bmr66395155e9.1.1731792433760;
        Sat, 16 Nov 2024 13:27:13 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.146.122])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432dac0aef0sm101071325e9.28.2024.11.16.13.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Nov 2024 13:27:13 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 5/8] test/reg-wait: dedup regwait init
Date: Sat, 16 Nov 2024 21:27:45 +0000
Message-ID: <c26b3c2955ad49f5be626d039653065010f5c6c4.1731792294.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731792294.git.asml.silence@gmail.com>
References: <cover.1731792294.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/reg-wait.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/test/reg-wait.c b/test/reg-wait.c
index c4e5863..10ab3a2 100644
--- a/test/reg-wait.c
+++ b/test/reg-wait.c
@@ -15,6 +15,12 @@
 #include "test.h"
 #include "../src/syscall.h"
 
+static const struct io_uring_reg_wait brief_wait = {
+	.flags = IORING_REG_WAIT_TS,
+	.ts.tv_sec = 0,
+	.ts.tv_nsec = 1000,
+};
+
 static int test_wait_reg_offset(struct io_uring *ring,
 				 unsigned wait_nr, unsigned long offset)
 {
@@ -71,11 +77,7 @@ static int test_offsets(struct io_uring *ring)
 	int ret;
 
 	rw = reg + max_index;
-	memset(rw, 0, sizeof(*rw));
-	rw->flags = IORING_REG_WAIT_TS;
-	rw->ts.tv_sec = 0;
-	rw->ts.tv_nsec = 1000;
-
+	memcpy(rw, &brief_wait, sizeof(brief_wait));
 	ret = io_uring_submit_and_wait_reg(ring, &cqe, 1, max_index);
 	if (ret != -EFAULT) {
 		fprintf(stderr, "max+1 index failed: %d\n", ret);
@@ -83,11 +85,7 @@ static int test_offsets(struct io_uring *ring)
 	}
 
 	rw = reg + max_index - 1;
-	memset(rw, 0, sizeof(*rw));
-	rw->flags = IORING_REG_WAIT_TS;
-	rw->ts.tv_sec = 0;
-	rw->ts.tv_nsec = 1000;
-
+	memcpy(rw, &brief_wait, sizeof(brief_wait));
 	ret = io_uring_submit_and_wait_reg(ring, &cqe, 1, max_index - 1);
 	if (ret != -ETIME) {
 		fprintf(stderr, "last index failed: %d\n", ret);
@@ -103,11 +101,7 @@ static int test_offsets(struct io_uring *ring)
 
 	offset = page_size - sizeof(long);
 	rw = (void *)reg + offset;
-	memset(rw, 0, sizeof(*rw));
-	rw->flags = IORING_REG_WAIT_TS;
-	rw->ts.tv_sec = 0;
-	rw->ts.tv_nsec = 1000;
-
+	memcpy(rw, &brief_wait, sizeof(brief_wait));
 	ret = test_wait_reg_offset(ring, 1, offset);
 	if (ret != -EFAULT) {
 		fprintf(stderr, "OOB offset failed: %d\n", ret);
@@ -116,11 +110,7 @@ static int test_offsets(struct io_uring *ring)
 
 	offset = 1;
 	rw = (void *)reg + offset;
-	memset(rw, 0, sizeof(*rw));
-	rw->flags = IORING_REG_WAIT_TS;
-	rw->ts.tv_sec = 0;
-	rw->ts.tv_nsec = 1000;
-
+	memcpy(rw, &brief_wait, sizeof(brief_wait));
 	/* undefined behaviour, check the kernel doesn't crash */
 	(void)test_wait_reg_offset(ring, 1, offset);
 
-- 
2.46.0



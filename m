Return-Path: <io-uring+bounces-7965-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 511EDAB5B27
	for <lists+io-uring@lfdr.de>; Tue, 13 May 2025 19:26:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B169467397
	for <lists+io-uring@lfdr.de>; Tue, 13 May 2025 17:26:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 565C71E1C3F;
	Tue, 13 May 2025 17:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A/iUFEjL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838B01DF258
	for <io-uring@vger.kernel.org>; Tue, 13 May 2025 17:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747157153; cv=none; b=bNe/Yewt397tEiGfUuFiy8vrtSCxllnd9bh0Ro5AA6OdCJ/anqPRfEByFoc6CeeuGYJN/rWuAVcLgknTZY+0qHZ9K8niVvv0I0TJ6NQuy4qiHaiq0RnrsJhpkd2eTv7ONed0lpjBuwyltxTAaF4hBIs37lEAQmTPAWYcdwBGcbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747157153; c=relaxed/simple;
	bh=3WRO3/FCcvobVFCzM57vEmfn+Q5N5/iud4tyfH2LIpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNC3k+/xEP96k5PVPjA5lGZOxuOAuRup5VITAxrGTSTFmZj9XOst+NBoHR31oTHBzejx24DetlhfCvjM+M5tsdnym22UaQffYBmhtLEdIQ+hAdGZSPjQyNXbxC3QhLNs+VZR+31Ub1auzN85/v7VYGBz8yTCJnedPgwz8clJtOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A/iUFEjL; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3a0b308856fso4345419f8f.2
        for <io-uring@vger.kernel.org>; Tue, 13 May 2025 10:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747157149; x=1747761949; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=osDCIz4OG2bMWMRGnVSoQCQY7QgXcbFbzgNjWujTJ4U=;
        b=A/iUFEjLMC5ej9BDqbO3ojCU4OxAFg1byBav0j4+j0DG4hhRSw+pcdBZx0tUqe6B+t
         IL3Mgv3DFBDvlkqgoF6SiHPnpJ3tTnA9Z/SjwfotwEn6wyr9hhTs2C4xnyTZ09CFvoLG
         1cO7KC71kBMJa5Y9oEEyD79cbePVYKC6G0CGGWvkimaqJQrB0JXhbz++r/YO1jeDutxX
         13UZExiXLXuVf6HKv2f+KSW01HnoVyQicec00K/pfyaROd8J6Tek0GMvVYcd+uc0kU+g
         wDfmdMCsvtN8csX3ehNNWSU4EvvfgJuSmgMHT1kpWpAfRoHbDRNPkRAJsipJHtll2Yeg
         exmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747157149; x=1747761949;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=osDCIz4OG2bMWMRGnVSoQCQY7QgXcbFbzgNjWujTJ4U=;
        b=K2mnD1x7mq7B95edKWy/DLqsXaQlnsTSi0XgNAsoHiF6hhRMEeYWpbSivHvCWjkwch
         6vqb+BW/UmXUAliUpPGLnyuNlIvXT5Eysv9Czlhgf7KMt9+jK5kJr/097vmnMpTfpcid
         eoAScEds3diZ2n3vVn13pHDtrVEdQDukyYxOdOaSW7gNwIN1Kb51IKW04w2lxNuljoL7
         vBlCmUWN2nhRTshCUVOtswfXyamlDTzP5IrpHbol3voniMm0AHEVgVv/AuVmw5fTbpQs
         QAao0qohQdzrby5BSdTCnDvUTMrcVb/Aq7BwT5IQEr/ykCauDJDxPwnKMh0p9k0ivrYm
         8Zog==
X-Gm-Message-State: AOJu0YxCfOW1Cnv2HV7NsVSR5MtVPk6ZaZ7AchYi4JlnhlO1YphQCE3P
	HmcQAi/09U4zpiQo8Pb2jaKBgcjEyhTfN/55WhoLAqPk+E7k22s4c3QfxA==
X-Gm-Gg: ASbGnct4hdkt/3oIYi+iMNdj2S7H+nSOPnGATgnn0blEmWmati6Bs5UPbdEVaByaeiR
	8esgAIQaeiFK/cL9Ksz0jNVu0VcWv5P9M2nNgm8QxhY8XywNN28sITl+YGUdO00jon29Kva+jsv
	AYXRqC20eTHXN9gJa6f/1ux9fcWjlDwhOe+XIHQM/gOXKOzVrVZkz1OHbO2HdGqQuRaWcTNjSYb
	uQmw0kQvSCqSnZB4w6vBIGX0JcHo6eORQCVciy13+vDSkKl02s8VpZCQaIrJ2+usXVtzCpqCsEQ
	asPh76nUrhuQ+sJYxvtdiZdvRzxRXolJutYLzBgnHXfIGfYEBTmKFr8F8XIN+pCU3DKzhI6JrB9
	w
X-Google-Smtp-Source: AGHT+IGEmpqHYAEzHVJv2kWOhbOYGJ2KA+HQ+aYaVj2BJm2mH/G3nybUPsrtRanO4DK4Hku9pjx4Zw==
X-Received: by 2002:a05:6000:1885:b0:3a1:fa6c:4732 with SMTP id ffacd0b85a97d-3a3496a5388mr122147f8f.21.1747157149224;
        Tue, 13 May 2025 10:25:49 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.146.237])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d67e0ff1sm173034745e9.14.2025.05.13.10.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 10:25:47 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 2/6] io_uring/kbuf: use mem_is_zero()
Date: Tue, 13 May 2025 18:26:47 +0100
Message-ID: <11fe27b7a831329bcdb4ea087317ef123ba7c171.1747150490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1747150490.git.asml.silence@gmail.com>
References: <cover.1747150490.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make use of mem_is_zero() for reserved fields checking.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/kbuf.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 446207db1edf..344517d1d921 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -602,8 +602,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 
 	if (copy_from_user(&reg, arg, sizeof(reg)))
 		return -EFAULT;
-
-	if (reg.resv[0] || reg.resv[1] || reg.resv[2])
+	if (!mem_is_zero(reg.resv, sizeof(reg.resv)))
 		return -EINVAL;
 	if (reg.flags & ~(IOU_PBUF_RING_MMAP | IOU_PBUF_RING_INC))
 		return -EINVAL;
@@ -679,9 +678,7 @@ int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 
 	if (copy_from_user(&reg, arg, sizeof(reg)))
 		return -EFAULT;
-	if (reg.resv[0] || reg.resv[1] || reg.resv[2])
-		return -EINVAL;
-	if (reg.flags)
+	if (!mem_is_zero(reg.resv, sizeof(reg.resv)) || reg.flags)
 		return -EINVAL;
 
 	bl = io_buffer_get_list(ctx, reg.bgid);
@@ -701,14 +698,11 @@ int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg)
 {
 	struct io_uring_buf_status buf_status;
 	struct io_buffer_list *bl;
-	int i;
 
 	if (copy_from_user(&buf_status, arg, sizeof(buf_status)))
 		return -EFAULT;
-
-	for (i = 0; i < ARRAY_SIZE(buf_status.resv); i++)
-		if (buf_status.resv[i])
-			return -EINVAL;
+	if (!mem_is_zero(buf_status.resv, sizeof(buf_status.resv)))
+		return -EINVAL;
 
 	bl = io_buffer_get_list(ctx, buf_status.buf_group);
 	if (!bl)
-- 
2.49.0



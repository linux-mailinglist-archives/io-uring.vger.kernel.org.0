Return-Path: <io-uring+bounces-4772-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C601F9D147B
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 16:31:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 00ED5B33513
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 15:14:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 177001AF0A0;
	Mon, 18 Nov 2024 15:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EYhu3npb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656A51B4F10
	for <io-uring@vger.kernel.org>; Mon, 18 Nov 2024 15:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731942830; cv=none; b=GrshNn5mw5kAmc6mhTQqOsW0OUmDN3MqxxolTWTCuYLr5kyNYTKrSdJKXXmWzXQ06fGFDPFglWRKdzYEyywNDbRx49wfzf6mV/fp47N6SJuze0A+dxajv11CH6bQZ45O0CvOkuTxfL/q/n7m1DDdIGSGkgU0XmiwEjNy9B4uZ0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731942830; c=relaxed/simple;
	bh=QI1hnCi6LHuG/gbL9Y+bp8RxolpSJ4RVCFj3Ay3kVTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VBYUG24B66dorpAxx+AkpN5/z7KIXH0kgcz1dvqknU6dRTjHh/Rp3qY8nMHa/VnTQ13Jp1KQr3hNnTuILb++C2tQb1AfE7kMMO3QyArWl+bd/9PilF96Il1hA8eDY+Y+GLTKnL0hUZsm0hbmyDwY1py3x/heuCBA7t53e+LGGgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EYhu3npb; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a9f1c590ecdso580797866b.1
        for <io-uring@vger.kernel.org>; Mon, 18 Nov 2024 07:13:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731942826; x=1732547626; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Vl6vUAErpt2OGBgtYe16x5UbXe5PqzELt9wjkLWqo2c=;
        b=EYhu3npbQHmLxDXaLW/dKW132+gwS1cVBeyGZ5u0IOu3J/d8eYAgwhODsGrSCzKdwQ
         YIkFBOaK6vw7YexNgttEKzQJn9+C4H08q6SzMldkQaxFCTRMaGdLlbr+jlIfOEYHqBvo
         BL8SDsRkOaKuaRfMWEYT2V5oVUlSgzelcAtCMKH/sCyBAnImJrsk2UTDn/+7tVEV9DnD
         x3zYo6Pq8aUAm0VZ/D5sTyZOaeF4G71SwG3GZY9Ls6hCvRiPdENXblbiqAzN6CK8gWcZ
         S9zsi/FN7MKP0iCrSVuBXgq4+6B7piHQpV57Qhw/IY1E3XBsHQAVTA8NJ6GkZMrnigmi
         P1Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731942826; x=1732547626;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vl6vUAErpt2OGBgtYe16x5UbXe5PqzELt9wjkLWqo2c=;
        b=GOom562qlNcnEHaAoIByUjsaa+69XEDMeclKPnWvuCUFIcwgmZWcsaSbCu3aYQm7i1
         bvOtxZ4CTNTz/MOVZqhz5SVP0bhav965reefgCFWtlxcAqht5LBxNQFQCepg2BJT9Noi
         zP2tFEIq/H8Xrf5S6q0B4Cb2Iyi7zcfvZ/O7VPIn+RAydjXahZA733fo9JzBKBpojFnR
         EFgfOOJ491hpfxGKGCT7gQ1Wgw6xVIBieNo+OS92ECBPy1518mCmV0gWcY2yS/y8qybY
         cx0o3kea09v8NvPyrxsiu21Ju0tq9knS0/N8kPNStStBPuYzmM5M88JUbd4ewnTRmwz9
         m/fA==
X-Gm-Message-State: AOJu0YxI7UFgOqsUlhUm2TGDagH9LfUh2HyPdlr8iQhzHu/KmmgAxPDO
	CupsbJSAcp6R9krsSD4HMSNrzQDn7a7ed5V51A45QS9CH52AdMLGsO4x9g==
X-Google-Smtp-Source: AGHT+IEmHL/UZBSJi3UbrtkXr6huGObY9Dv8KgKqJjOO/VgLGKdTTjkY5QGhOZgpAI9LGrQAWICrcw==
X-Received: by 2002:a17:907:7284:b0:a9a:345a:6873 with SMTP id a640c23a62f3a-aa4834161dfmr1247333666b.24.1731942826435;
        Mon, 18 Nov 2024 07:13:46 -0800 (PST)
Received: from 127.0.0.1localhost (82-132-218-132.dab.02.net. [82.132.218.132])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20dfffcdfsm548583066b.113.2024.11.18.07.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2024 07:13:46 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: remove io_uring_cqwait_reg_arg
Date: Mon, 18 Nov 2024 15:14:34 +0000
Message-ID: <143b6a53591badac23632d3e6fa3e5db4b342ee2.1731942445.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A separate wait argument registration API was removed, also delete
leftover uapi definitions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 4418d0192959..aac9a4f8fa9a 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -873,20 +873,6 @@ enum {
 	IORING_REG_WAIT_TS		= (1U << 0),
 };
 
-/*
- * Argument for IORING_REGISTER_CQWAIT_REG, registering a region of
- * struct io_uring_reg_wait that can be indexed when io_uring_enter(2) is
- * called rather than pass in a wait argument structure separately.
- */
-struct io_uring_cqwait_reg_arg {
-	__u32		flags;
-	__u32		struct_size;
-	__u32		nr_entries;
-	__u32		pad;
-	__u64		user_addr;
-	__u64		pad2[3];
-};
-
 /*
  * Argument for io_uring_enter(2) with
  * IORING_GETEVENTS | IORING_ENTER_EXT_ARG_REG set, where the actual argument
-- 
2.46.0



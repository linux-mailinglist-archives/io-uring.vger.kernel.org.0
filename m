Return-Path: <io-uring+bounces-7036-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8E96A57CB3
	for <lists+io-uring@lfdr.de>; Sat,  8 Mar 2025 19:20:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF8B83B16A2
	for <lists+io-uring@lfdr.de>; Sat,  8 Mar 2025 18:20:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACC071E8330;
	Sat,  8 Mar 2025 18:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UM2cBwFs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E971E833E
	for <io-uring@vger.kernel.org>; Sat,  8 Mar 2025 18:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741458036; cv=none; b=eH+0UkhCagpAMKsEkfcc0gmS7/2/ci5fVaLtejd/B/2ubTIW9zOvjakDxnM93+zY1b9msaMu5pxfLTXIi1xjAb0wNL2vuhj11KpK0+sRUPSNHps2Krp1zrNjhFYGQ9MkxrU8AyarWFlTmHYxtrRtQs78NwB1mG2FyDf4+6ZIbkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741458036; c=relaxed/simple;
	bh=WsRStN4+MQ+4qmFMl9Vywj/iOmICsG83b2FWUZBh224=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FZAHobRZTImicNmUAe5hE9HK0H48qzdKyOZABa6wndjyfX89MA1YXxTXUl8LrYpfvNM8JljA2KV6FbSrZCFs6kv1ibbHzi0qEfpie5jV2SqhPgd59UsLikXbSYkf6XeGYKDVeuDSMwnW4scqRbOCD+tdMrrfBz1SmEp6wyzzHtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UM2cBwFs; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4394036c0efso16286885e9.2
        for <io-uring@vger.kernel.org>; Sat, 08 Mar 2025 10:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741458033; x=1742062833; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ch1psHPrGZbknTJHxl/tYiHL+JT3gHV06QbVjZ5wYxY=;
        b=UM2cBwFsbNQmOQzVcT+tMYVpEcF0S/6ufYMIkE5tnXrCuaou5kIR/RPCF6GcTmszLQ
         a1NBgNxNDfmxP+TrXm87yp4KBPjjvrCGsFycvNuKYiEMwmh4I6aKQYhp7atxNOgd7WCE
         qTeP6T+gHd0yRHglfZMrpkVm9s2KBWhAJWYebvpqLy+uM9Lz05kbJg89eSp7k4xOSxZ1
         aDIH5YH1BN6e2YztyExwCzmRGWETDmsGHHs5t2KXgMCJ95IkUTUv0cde+LIUotEiQ/mu
         a5CQdv7MTXZMQqYJDmtKz+qirK67yIwV09nU9FemKTMqb23vDQu8DmwyNvRMOwCUXBVi
         xd8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741458033; x=1742062833;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ch1psHPrGZbknTJHxl/tYiHL+JT3gHV06QbVjZ5wYxY=;
        b=JtFf27KHaPKloL0fM7An9QxRlH1s6Ey2F++295oKlwZ1LBU2ON1mudXDSGijZJ0d7z
         olG9aD6tlQV5QWPgS4Da3+WXFEWSR2NI5y0K+piX0AB9vbRWYhgfVXW2/QRuKlIbzbCW
         KFfGvIvlTeXeW8HEqCdtZBVOcAl6SfyzLXhFoNJV+a7F6n37sfseVACQIXGq0PyLp8Ar
         PHcGOnKWUtZ7dOWNR4eHiBMd0NiGgsgobLA0Vy/8eoR8sEMdye/64iU3XgOzbdNVYfhf
         9fFMwtxbs0Nmu0LHAerhKxkZEBsFRErXb7sYSbMiIhEYbqmSXip4tS7pNNBLRJ01rV5x
         3k8A==
X-Gm-Message-State: AOJu0YycBLLswmyiwgdv2VNOimdqaZbs4Wf5j6qh4Fp5hd1WFSOKTLX8
	j+Gr98ZMXXzJPzAnW0L0lUAke0x9cmAn6plPCBwSYZg+8Gl7CelgTSDvaA==
X-Gm-Gg: ASbGncv5FxujnIqdQDdczn+gbISe81/rQS8c7epEuXWl0qJREL0OzqJbqGinQtJFnZX
	clrXVaBsO12NBCR1lGFJZ6WhJ/0eY1a93rl5gvz9dWO63oVBVnb1CEFEYD3Qv+7QkKmR12ZmduY
	PwCjIFNBl6Kpj9urMVScIG/pTxRIqEFAH7WyTVEspiMGm4/FdX9eTOAU9Qhh1foPggMDVHDyB8h
	WVSKRwodw7JQZee25C0yRXST0eb1jluAc7cgmvyP8ppNU5y6BgxthJLFRDGwRNyV29PiK8zNF1x
	/ehthpP8ZzTabC/4Lc2Dvmj2q3dbUhrqBPls9xs/jQ5nGAwAw/hzst5gPA==
X-Google-Smtp-Source: AGHT+IEXWOUe1VudhsJJtnQKTT+xuLIe3f0CSrG3o49ftJLCuJ1JBj79feII/IOia6N+NKiF39lLWw==
X-Received: by 2002:a05:600c:3b92:b0:43b:c7ad:55c2 with SMTP id 5b1f17b1804b1-43c5a5e9853mr47722455e9.6.1741458032596;
        Sat, 08 Mar 2025 10:20:32 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.236.160])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c106a1asm9472996f8f.100.2025.03.08.10.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Mar 2025 10:20:30 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 0/2] unify registered buffer iovec imports
Date: Sat,  8 Mar 2025 18:21:14 +0000
Message-ID: <cover.1741457480.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extract a helper for some common chunks of registered buffer iovec
handling so that callers don't have to care about offsets.

Pavel Begunkov (2):
  io_uring: introduce io_prep_reg_iovec()
  io_uring: rely on io_prep_reg_vec for iovec placement

 io_uring/net.c  | 27 ++++-----------------------
 io_uring/rsrc.c | 34 ++++++++++++++++++++++++++++++----
 io_uring/rsrc.h |  5 +++--
 io_uring/rw.c   | 24 ++----------------------
 4 files changed, 39 insertions(+), 51 deletions(-)

-- 
2.48.1



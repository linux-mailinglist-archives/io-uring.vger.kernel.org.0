Return-Path: <io-uring+bounces-4756-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 216C19D00F3
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 22:27:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D045B1F234AD
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 21:27:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F41019750B;
	Sat, 16 Nov 2024 21:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H2kbaQz2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99880194A63
	for <io-uring@vger.kernel.org>; Sat, 16 Nov 2024 21:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731792432; cv=none; b=E7LbHVaKm6xv5cIWC23s8uScqj7JRWMOvBQ4IdqZJl984aNz7gHwpbxGk/t/6foINf/zwGxms/jgmBsRuRSg+CixzesA2vOgQXOOpi4liBJugw08M3QP0jqXIQWtFK643FUoM5LYs8CknHzlG+RxgcL+Kzk0hGRRopQYZclWatU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731792432; c=relaxed/simple;
	bh=0d76QLmp7OuDcH2xZ0EzGX5tSWDaFhqANfzgu5Lf+wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qhbmNhTrRfvBC3/cSaONZbG8zRrBzxoK/LxP6QqiGnSyuTTdHTYrvJoK7H7VFV+wtlPStkYmk21OdG6CFGFHf+aUBFm0LM5H5fJsM5REjPaL4JFuc35N4mRGPZpRpvFUWHweqTV7kS5TN0rQ+T0B5uN82LU3rvqWnvdRHXD+hjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H2kbaQz2; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3822ec43fb0so1148831f8f.3
        for <io-uring@vger.kernel.org>; Sat, 16 Nov 2024 13:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731792428; x=1732397228; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TDyNNpiLdMEz+/guB7hf+ovllr1d8PllR8noRR/Yydw=;
        b=H2kbaQz28wsmM4SEoShP9aj5iI63/zCiXtpDIv7VjRL47jx6CUSqWqQnlXzM4ZR1j/
         1N5hEJn4K7KAs+SHt3vZAQ+KwfPuhNGDKK3sWvjXYqHDkEBLyjGn8W1Fa4HgoMoXA6VB
         0wAY5IAgMolnAoeTxs0VV2HqXQpTZh20fqFeocPrBog+vyWbjIcYrzRLrgWbMEPYGjLO
         QvmGorxjBUkaqt8FOP4OnRmAqw6PTHcfbyODgxyNXHfgkw/eh0bbRBUyFZ2MjQpOO6P/
         YHryHWKAY/AC6JiDvCotralw+6uIz8Elbn+vUuOq3mATROfA3Oj1pVPayV8Y3B7tzDyx
         sFPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731792428; x=1732397228;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TDyNNpiLdMEz+/guB7hf+ovllr1d8PllR8noRR/Yydw=;
        b=S4etVqPc+g31GVYIbt4BXkzHcx4kTcmt6ckMxJ6Xb5ECczuKcubB7fmtNpsYSFIrup
         LNRXLNZPP7473RNBI6Z5LIHyOFFlyJcSXQqghBNsWGUcfuG6gWvJgctrYQsLsnnR2FsX
         e/ttm3NGjHquQ6z2JMvCAehv4pxOOjQyBfls3xd7jTfGirv0qu2MVemcUVXkaq35cxlU
         fU11SHJTj8fAzdSQmKaPZLHLhtZbH70E4PJqa4cLBEO08AEM5TSqDk0I+jtoeOBPuLFV
         icrX91VUUA0nLIzpkL7KAqBIYcfoG4q8iSX1eHFvYDk8x/craOZJfftdTLeP2ySnAjVD
         /OmQ==
X-Gm-Message-State: AOJu0YzMc8GtDplEMdmAaM2dHxR6MeU5wtJ1aVBS3HsxhEAwiA/gLrCW
	CMhX5K2B7wXGMQ2DLpECw3mrUygHNuCMnpVVXZQ1fYdUYZxERX9pXDmPpQ==
X-Google-Smtp-Source: AGHT+IH+fDx7Hn9jjjtgqLLahcwRQbjqISIv9He7PQc/jORW4EiqUNWTCbCgY65WzlUzU085GAWUVA==
X-Received: by 2002:a5d:47a5:0:b0:382:3c1d:ebc1 with SMTP id ffacd0b85a97d-3823c1ded80mr1264361f8f.2.1731792427993;
        Sat, 16 Nov 2024 13:27:07 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.146.122])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432dac0aef0sm101071325e9.28.2024.11.16.13.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Nov 2024 13:27:07 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 0/8] region test fixes + improvements
Date: Sat, 16 Nov 2024 21:27:40 +0000
Message-ID: <cover.1731792294.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some tests are effectively ignored because of bugs, fix it. While
at it, improve it a bit and add tests for different region sizes.
Not very improtant for now but it'll be once the kernel has huge
page and other optimisations.

Pavel Begunkov (8):
  test/reg-wait: fix test_regions
  test/reg-wait: pass right timeout indexes
  test/reg-wait: use queried page_size
  test/reg-wait: skip when R_DISABLED is not supported
  test/reg-wait: dedup regwait init
  test/reg-wait: parameterise test_offsets
  test/reg-wait: add registration helper
  test/reg-wait: test various sized regions

 test/reg-wait.c | 222 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 153 insertions(+), 69 deletions(-)

-- 
2.46.0



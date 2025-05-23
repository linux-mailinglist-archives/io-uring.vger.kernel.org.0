Return-Path: <io-uring+bounces-8095-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D13B2AC2282
	for <lists+io-uring@lfdr.de>; Fri, 23 May 2025 14:18:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 006DF7B3AFF
	for <lists+io-uring@lfdr.de>; Fri, 23 May 2025 12:16:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CC4922D9F7;
	Fri, 23 May 2025 12:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qno763A9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08F022A4D5
	for <io-uring@vger.kernel.org>; Fri, 23 May 2025 12:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748002677; cv=none; b=GoSQxwaLUvKUwU64ZCo/r5H/To0pi9g6w8XfVapSV7ivRvGTFXVM0al2Jrjs32qyZ4tLsUVhba1QPoXF5OsMRuB0CiQ8rFHky6Im+KkJk1W5Bnj+jBsgem2c8zCA6nxwjhrddz3B3VZpim0sz2OFg7YlYaIAWQCrq6wralFxgto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748002677; c=relaxed/simple;
	bh=e8qjNjVD1aa/Gqct3p88cYuZQ343Ty12JQASFYm0L6g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G1QfFRrOH5ug00FNsie0by/MjNvG5PzL0wr0ZPpFKmYNpBxtYx1h6mLm+I2/pQ4dn8/XZYvlllSKdaqRtVohPblk4o9GreEl1k0CnySdpTo4Ree6x4IF891hOwwvDWisvRRdd9tm8QOx5Mpqh4Dhkn1rU9pgCQacnLnZY/2f4kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qno763A9; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-85d9a87660fso1032457739f.1
        for <io-uring@vger.kernel.org>; Fri, 23 May 2025 05:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748002672; x=1748607472; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EYjIfFHpQDqDb5ve0Gbb5hUkyPFbt0s3bFrhT5YeAn8=;
        b=qno763A9bofE74+iaDnRBBuUqT6J9Ac3g/69oX4bs4fmRXiK2C5qJLHd3HBVx2E+k4
         YfyV1RiqCNb9jUyZ8ssa7+j838iyfAT1KUqXQ78xPWmaRpL+HjcGk1nOyJ8AA/PP1w0m
         p6Y6GP8s+6PNMse5G1fHcxHBGeMXfvqttS/iICD5UVwoHDdCVfD4G4xNmnp1CZ0FRAME
         fsVmQVA5Ds5YfjYQHnR1PQTJFzT9bhd/gQPlWHLlpwmvXITfEDzAkpYpGYBRWVS1wXij
         Jkvba7Cl5YnqvglcmBMPia/55UJuABP7LyFlrvkQV4sXvOjKSwST/v5GoLegZ2OvQBK3
         rQRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748002672; x=1748607472;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EYjIfFHpQDqDb5ve0Gbb5hUkyPFbt0s3bFrhT5YeAn8=;
        b=synu82dHnCM/4qCLCuBkzPe84lzJ5yh9goGaGMDQFrIckoVKQsoPQ16kRkDMEfolBs
         C5iSzXV6zvfmz2zEW+4W1SZikp+zph6J6OBn7tVnIr3KfITWDt+v4h/54X2r5IOTa25Z
         TBDss+pVKSpQG9W8tjyrYXPmZ3yg1igZYM1YN6QRG14QSPJLzLfLspXPCyZ7maJbYmUJ
         d2yPcYWpBdnwVapnPFDfrs69CRreehMzuGENQ+156dHMTZHxKiz82wQXS1KY2XmuHIq9
         ibcvxkILjMTZwb86LReZMLYJr5uT+MDgJFgXeF7uYPcAvIPznNI/Dc94qdEa7uwG7PbL
         msZw==
X-Gm-Message-State: AOJu0YzlOlqS4YjrVFCx6Gb7zn2aY2AHjmSabciQabzn7yKFCZAUNBec
	pbV/tJtqr7Ab0Nx2EMciJgDZdR03AVLZmGHq1A2mgQ9vDv383l86CvZ1or7D6ysQrdmqQAsV9ZU
	pBIhx
X-Gm-Gg: ASbGncud9tKdebHuBM0HMJk+fHvqaUIae9i+Dp0nOT0omnoe1YYaV3wfGJcBjNLGlFE
	FbxRotL0ZC9uen9PxBVCGJmd4lwDpK7L2+lmFzFsoXaL4TJ6zJFiAA01k5QaAFdV5Q63b+ntS9k
	/RP9RerbVikK4uzCrctuQaAICjuMjXtnW8359azsXsuUvHHGQFFH7GB/knIzCC5hjBW0A3Njr2v
	hYBDqpAWOHtw6jxFkVE4eBsrIJA4biOS1GT1dj6whmF0OgBdMkIId9Cxu0GmUP2DiBw+wxTve5Q
	mgJVR1XFILBJbVpgj1hbrt50aAOPQIYn5Rm+dffzSQnMpkHeJ7IqDt1R
X-Google-Smtp-Source: AGHT+IH7hf5BTJcT7kvHMLbkOAY0O91PSweP/ZEH1ytJ3fzP2fQf+kZ1VQ7Zs5ZdNKJmp2fd//alkg==
X-Received: by 2002:a05:6602:358b:b0:864:4a1b:dfc5 with SMTP id ca18e2360f4ac-86a24c91181mr3551503839f.9.1748002672216;
        Fri, 23 May 2025 05:17:52 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc3ddeafsm3617552173.71.2025.05.23.05.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 05:17:51 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: changfengnan@bytedance.com,
	lidiangang@bytedance.com
Subject: [PATCHSET 0/3] Avoid unnecessary io-wq worker creation
Date: Fri, 23 May 2025 06:15:12 -0600
Message-ID: <20250523121749.1252334-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Based on a report and RFC posted here:

https://lore.kernel.org/io-uring/20250522090909.73212-1-changfengnan@bytedance.com/

this attempts to avoid spurious and pointless io-wq worker creation.
Patch 2 eliminates io-wq worker creation if the worker is currently
idle, and patch 3 attempts to eliminate worker creation if it's blocking
on a hashed item and the next work item is also hashed to the same
bucket.

 io_uring/io-wq.c | 50 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 40 insertions(+), 10 deletions(-)

-- 
Jens Axboe



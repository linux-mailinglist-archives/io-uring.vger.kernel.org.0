Return-Path: <io-uring+bounces-461-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BF6E839AF2
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 22:20:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F12FD1F26ADF
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 21:20:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72AF92C1BC;
	Tue, 23 Jan 2024 21:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lGCKCy64"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B866233CD2
	for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 21:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706044799; cv=none; b=i6mpfnaloyVr7LBhADytScnfJYVIccoLbAAzx226xb9CwqmBnnhwOznfi5DsjYkGw2Uz+Y48AzAeI6YLOred//O3EYeGuUQsjEp84hDmEBo0kruqrxDoUVBbV76zxwm/6M+8C1ZYdfg537LvTURhQZwLXRunJ6CJFqh2H1INphU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706044799; c=relaxed/simple;
	bh=q3luWcP2F4z6VX8oduWlwHtmqF5B5vX6rwmc/5rS5L0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M0/9joLtYLCoHxryL2WCKsRaHCpDA80+VIxTzXVSu/rcsHf2Bm0IjdvPwrO/kLtF4/kc6rbtPU8TQEIe7zofSkfMMssd21aCbfPIu6t+WKOZrTIA4+HzboxBshBsADMqmFEbUd5GDiMMVgH4rtOpsGwoziXI9/BfkY48IJy/7fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lGCKCy64; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-40e490c2115so35850035e9.0
        for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 13:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706044796; x=1706649596; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bvBqXQzRSfaWO1nkFxMyBPySfSdQj4elZx6sOCODS2Y=;
        b=lGCKCy64zJDw9tbshcbQFx6/PQmfakhcP+ELL4FeWHfePpNrKONoXrTm6A0c2oL1sK
         X0Q7RmvfvzZOde4ekxx4eaHUP65//5a6Zh08MQr2L2suG9tU83rLimWijzYDtPoWzh9g
         JrJtxKJR55Eak6HhoQN8rmDPW4P5CUJPAzOeaZk7H6QJSS2xxOHPcQ7gqck4PS9oLcuZ
         LBEOlVv62SFhDjjwhmbqP6ysl9vW1qjH8f14W1S2bFTFznZ6qHfoNImKQKkSDZrH2Cxz
         uQ55WycRj+VSdeCo1mKycXDx7+QYi7Jy+fyORZo1yi+lC0O1oDMDTp9OpY3hweCy1Fu9
         lD8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706044796; x=1706649596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bvBqXQzRSfaWO1nkFxMyBPySfSdQj4elZx6sOCODS2Y=;
        b=rh1RTM0ugGmlrgwUPCNOtVP8U1q5SbJijyTcMJBoBCn6JG718l8xvfC86V8Pekm0pt
         /myF5JXp38M87IHGBwkNBeineDPCyNm6B3Vu4xdaii7Mvk3lLG0UaL6j7+mJs4suFCcB
         LERoOJMH29DI4WvhJMTIaQ5/k96M7u/aQ3s6z+4fS9r6m8iVh6ObHK56ijpNF0r1nb2A
         +8nEYthJA1bxk1H88YlE+w8EnKrU4Rz4uf+jpPGTiQospki18QQ1ltIUNsmfuN/Sln2Z
         XbWz3mCmeAA9vG7TFTIBjI1jmW/eOxablM9WXWeQCV6FDEZRrojt94zQyajuf769CGsE
         l6Fw==
X-Gm-Message-State: AOJu0Yy265X6Ui/6ai+8fT2xSIaWR593q2A1nvmiNzc+KWgon5/jrGRE
	L/v49wr5Vy3b13/pbTGVV2lIPFPhwN6JuojH3EGdd0V6NIUW6blV
X-Google-Smtp-Source: AGHT+IE5PBFCKeIOv1UHzgpQx40WgCjIPZNoQVstORZ2R0QRElfjtgWyfdPZ7kCA8kD4VMNP/NuCzA==
X-Received: by 2002:a05:600c:3844:b0:40e:b17f:172e with SMTP id s4-20020a05600c384400b0040eb17f172emr92239wmr.52.1706044795726;
        Tue, 23 Jan 2024 13:19:55 -0800 (PST)
Received: from localhost.localdomain ([147.235.201.119])
        by smtp.gmail.com with ESMTPSA id u17-20020a05600c19d100b0040e47dc2e8fsm43512169wmq.6.2024.01.23.13.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 13:19:55 -0800 (PST)
From: Tony Solomonik <tony.solomonik@gmail.com>
To: axboe@kernel.dk
Cc: krisman@suse.de,
	leitao@debian.org,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	Tony Solomonik <tony.solomonik@gmail.com>
Subject: [PATCH v3 0/2] Add ftruncate to io_uring
Date: Tue, 23 Jan 2024 23:19:50 +0200
Message-Id: <20240123211952.32342-1-tony.solomonik@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123113333.79503-2-tony.solomonik@gmail.com>
References: <20240123113333.79503-2-tony.solomonik@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Libraries that are built on io_uring currently need to maintain a
separate thread pool implementation when they want to truncate a file.

Tony Solomonik (2):
  Add ftruncate_file that truncates a struct file*
  io_uring: add support for ftruncate

 fs/internal.h                 |  1 +
 fs/open.c                     | 51 ++++++++++++++++++++---------------
 include/uapi/linux/io_uring.h |  1 +
 io_uring/Makefile             |  2 +-
 io_uring/opdef.c              |  9 +++++++
 io_uring/truncate.c           | 48 +++++++++++++++++++++++++++++++++
 io_uring/truncate.h           |  4 +++
 7 files changed, 94 insertions(+), 22 deletions(-)
 create mode 100644 io_uring/truncate.c
 create mode 100644 io_uring/truncate.h


base-commit: d3fa86b1a7b4cdc4367acacea16b72e0a200b3d7
-- 
2.34.1



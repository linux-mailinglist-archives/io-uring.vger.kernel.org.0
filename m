Return-Path: <io-uring+bounces-4362-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3B719BA748
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 18:49:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 737E02819E2
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 17:49:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C142139D1E;
	Sun,  3 Nov 2024 17:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YhXUd6V3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C4C4EB50
	for <io-uring@vger.kernel.org>; Sun,  3 Nov 2024 17:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730656166; cv=none; b=RtjHYrMAqHGhJ0BT+1xamRh5cVghdirnX6AAH2OKbC8EaitSIg2aUFciLAV8HVzWpnmyJx7MfqG0Qlj/IeMImzHS+wIZTX8p/70ky3nJZpGc/GgDI3PrSOjpaIVNHboyDzZK0u29/HfCFStFO8sWgUPqO2mCAp/EbQBP3brLFrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730656166; c=relaxed/simple;
	bh=gHCzi6bnd76V52+dDVnieow3Ra4U/KmPc9bjQE3e/dU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=pE+BWQf1LWRW8VvoLGzXAbJzhhNhjGFR14rUcTmwrn4XUn0Mw435WhnOkDiXdERrbjAWhtZOoMq/f/rGh6OIF1VOLRll0cAIamjnENPjtLnXe0IO2xeEeqIIKgejQiEHQ8m+BzSx+vunqjR+Ab5EPPyGgzQu97MvhB2MsVHwObY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YhXUd6V3; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2e2c6bc4840so2611180a91.2
        for <io-uring@vger.kernel.org>; Sun, 03 Nov 2024 09:49:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730656161; x=1731260961; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=rks4kHXZhMe8YPW9GKBFLAS+5PzSS4w8IG9Xg+FAwAw=;
        b=YhXUd6V3sEUonRHbcwC8ogOyXJMZApQDbzUw6mpJ4lb17DivqsYDfQZs+v/U9mJhny
         95epAXoS9Yb0iz9+xgbuLYJTt5TmBx3JeGZeLq+WBLAOUmGeANAEC/IKvyrVmWS7dErF
         dQwDaNHhGyVwBViDol9lQvEfsgj/SqqH8CwrO5/daegI++2FfE/eKo5VeIPzZQGMV2NZ
         mCgzALjvXVJcS0z9G8rBXQ8AXm0pBCOB2EYNA6oAVHlICW9/OlDoEmKL3uVReGR1T7H+
         wE67AW0sfpmEC+vlk4J7/CJmfNZE90BV/z9Z5/wnVaRPdV4lZKp3CQKviaIYAE1pXV/y
         eXbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730656161; x=1731260961;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rks4kHXZhMe8YPW9GKBFLAS+5PzSS4w8IG9Xg+FAwAw=;
        b=NkxKv3XDpiWePuSHLk20zAQThpf2Q0gZM5bRPdvFUVCwB2v1PubZS9g+BGiuXi+bAM
         JpGHVA1C5kVGwTBthbdSCgSjhnbUMGdxnMMu7MDlRKpXleOKNdLzb0/IB7zwMXmotXZX
         k4LB+ZI18Pa8ppTYZgVftjbfAkvFOEpM/+Wk00/1TLCDDYaCADfGpyK3mHiE0Bazoi4b
         4Qsqs05jGGoyPZzxaLkj+IKU3zFLpPpQ6/Ky0NPCaGD28BP2QEKIFnOhSTxBUlyKuxFB
         0vfG2xyk4G/MEeXM58qxqvIDmrtZC5Q9MfcI8psg5r+cRHGNXBdoZ4ujgMIAZPki+101
         3Tfg==
X-Gm-Message-State: AOJu0YwpJf6ffO1mduau3IRW9Z/OT5vu96phVwZxEWLWZwqtd8vKvXLa
	JbQoxTYGGBmytGEj9s909uRW7KI9FOmd0gHqvHY5AG7W1ZLAbHkG3iiVIi03n2/gm1YVVr8U8Wa
	MHU0=
X-Google-Smtp-Source: AGHT+IHVVsnIqwYTLiMlBIVMWVlv+yykgfgeWf600wYpGlLBuLaD3mtoLWs9rsASzhnF0p1ukJX5aA==
X-Received: by 2002:a17:90b:1803:b0:2e2:cd5e:7eef with SMTP id 98e67ed59e1d1-2e94c513e33mr13754470a91.27.1730656161431;
        Sun, 03 Nov 2024 09:49:21 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e93daac455sm6861490a91.19.2024.11.03.09.49.19
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 09:49:20 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/2] io_rsrc_node cleanups
Date: Sun,  3 Nov 2024 10:47:40 -0700
Message-ID: <20241103174918.76256-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Nothing major here - just a patch reclaiming a bit of space in struct
io_rsrc_node. Nothing that yields anything yet, but may as well free
up the 'type' to have more future room.

2nd patch reclaims 8b from struct io_kiocb, by taking advantage of the
fact that provided and registered buffers cannot currently be used
together. This may change in the future, but it's true for now.

 include/linux/io_uring_types.h |  7 ++++++-
 io_uring/io_uring.c            |  6 +++---
 io_uring/net.c                 |  3 ++-
 io_uring/nop.c                 |  3 ++-
 io_uring/notif.c               |  4 ++--
 io_uring/rsrc.c                | 11 +++++------
 io_uring/rsrc.h                | 31 +++++++++++++++++++++++--------
 io_uring/rw.c                  |  3 ++-
 io_uring/uring_cmd.c           |  4 ++--
 9 files changed, 47 insertions(+), 25 deletions(-)

-- 
Jens Axboe



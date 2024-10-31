Return-Path: <io-uring+bounces-4250-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 13C859B7235
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 02:49:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BEA3B1F24368
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 01:49:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 323BB41C77;
	Thu, 31 Oct 2024 01:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wymQWMoa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9C5881E
	for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 01:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730339197; cv=none; b=hjlJfVF7jhIJG+G6n/qHvpqbO+PPKGT08sSNDB4N4wTdtrRWaHmL4zL4xmoY8NhHboYa+QFbv+2J4qed3apGHFxEP9E6XkKUyI9r+qOkXm4u+6YR4sPmiDbAQNn5uym84Pmw1fBwhV5GbL8bm1ujxRdsfp0V63cTKFtaD1mr4Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730339197; c=relaxed/simple;
	bh=NIDfLk3n2ciLPYcmWx8Iv7uT3cDkcYZ+tvJbgPEKdv4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=RH19dT8VQ8H2SV3K+fiQbeGM/zXFjHhNo8sYXh4DiiiwXUPogTvVNTt1sdeQDEch00TQx2Ez1KxBtWPCOOsG6S4BMyjtkdGW3yVuC7T3Psr3hulzEKgXwaecmvEo66UHP5a7KY7uZ1EPJD6uYttXeVFkqYbQsbV7adTEaQyuugE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wymQWMoa; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-7ea8de14848so382241a12.2
        for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 18:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730339193; x=1730943993; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=GvLh6kDI/KsyHvPVz8PuDIOcZby3LXYSyltQ68Sbue8=;
        b=wymQWMoau75okM16as0KVm1QrxRI0Gz1oYnzMJMSOQmufSChGXV1YxVZCCWLily1Ml
         3y9L9v2TfgAGoRCBYrQJ1YfeTvlrGKSFytfQhRVoCuNBrcsSdeWBOZgIkjOAn5rkkw7I
         H/Oi/gYcVWHv9Fwf1kM2Q+z29a8QeJKOR0zvy2kjXA38pRNVG/GKibfr8ePfMiLXmdbp
         5kRUm+YasKd1NC9J9t3owSi8+P4Z94JbElsmtGDFwdwQwbgqIFJ3fASfR7CIZ7CgNiIb
         oxl4Vvgxv9lET6Ay+5NnsLMa2oie03O9xvn/moLl3m5G/kR/7aWT0NS7U3+wH5E1H6tD
         Rzgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730339193; x=1730943993;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GvLh6kDI/KsyHvPVz8PuDIOcZby3LXYSyltQ68Sbue8=;
        b=wNMG0dVwPm6RSXeJfDd1Xi5XvqGc+7Tqj9ETKxDnm7zcE81axFcVe6e6A67gHUyivq
         CihVWwTYF0D3uZOCxjQN7+cbLgIwWIufw7VWQrwW411dGcDv2+zYr9yTPzhoLv6oPUMQ
         pcWUKTcTDzlGZWeFA7SC5glgvJsoQOxfm7GqZL49qXjH3XnsjTJglGCUKQHVT7LqI0bx
         1yZICKLv+323KR6qOuE0xD70pLP7wnSzZtl8GoWBvU0JYiJp0sy+0YD6u3NetP6ybmUY
         BBFFaxPRH+nVBUTMieuPWDpcGyh+9lCBPEFp+ddEYRyr4XSKgWV1K79JTAPl7P2fzpa3
         Z+/A==
X-Gm-Message-State: AOJu0YzGWLHyek9uMsjN3f8URVy6znto0pU1YoyOfLlNWuxlKjCePn+N
	C6CXRwowVytXEk6g4Jtv7qhHWAw0oKpjiSS0abHyZQyCboThbGQRR999R8hq7kEufF7T3WhE5st
	VKYY=
X-Google-Smtp-Source: AGHT+IE9fcvEiOABAygiWc4L/UaPOQUoqUDGC3PCD1wD1DyF8hOA/CNon+/a8HYQ9W6ZpIolM5V4Mw==
X-Received: by 2002:a05:6a20:d488:b0:1d5:10c1:4939 with SMTP id adf61e73a8af0-1db91d4402cmr1634266637.8.1730339193174;
        Wed, 30 Oct 2024 18:46:33 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc315aafsm285872b3a.197.2024.10.30.18.46.32
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 18:46:32 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v2 0/2] Add support for cloning partial buffer sets
Date: Wed, 30 Oct 2024 19:44:54 -0600
Message-ID: <20241031014629.206573-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

6.12 added buffer cloning support, but it's an all-or-nothing kind of
thing - if there's an existing buffer table in the destination ring,
then nothing can be cloned to it.

This adds support for cloning partial buffer sets, specifying a
source/dest offset and the number of buffers to clone. And it allows
cloning to replace existing nodes as well, specified with a separate
flag.

Changes since v1:
- Rebase on current tree (no rsrc_empty_node)
- Rewrite the replacement code to be much simpler
- Write more test cases

-- 
Jens Axboe



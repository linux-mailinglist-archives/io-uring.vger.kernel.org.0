Return-Path: <io-uring+bounces-3901-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B50F59AA33B
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 15:34:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65B591F211C5
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 13:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A571D126BFA;
	Tue, 22 Oct 2024 13:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZRCrYTIl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9288063C
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 13:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729604089; cv=none; b=DY4/tKKmkDBJGmU/fxqkOa1uGA8wRW4qdshmS25B3Ni37iJ0OCPAT4HBVfXRtqgPNDD8/cTNtoJ/VwA4O/XRohLckWKh0/aNuyQQueNNQQ/KTts5/yg3XDWnlSM50r/Hz3pEYCRZcWJdzw8jtpxrrjZEx3BlIJ29o9mQkZhugVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729604089; c=relaxed/simple;
	bh=WBxHDAnz1kOt39cTJkCxUCusBbev2ogUXj4fLnMsJkU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=t2PK3vtVeHD8ct6xyrkrHlgWRzACiAIizy/lu6YeS7myXygDwOtJXXnCER3CRWtAErKXz7ytRWFFHD3Dqx3BbupofWS5onqFSh8r9xf+gtp2gmVumQcTjKhHInX02lz3wqqnnm/l5K5/z6ujnaTAmc/Gm99wqKXK2o6PxTeXhho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZRCrYTIl; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3a3a03399fbso24216085ab.0
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 06:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729604084; x=1730208884; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=tgoS2l8VhZpexNExm16nvNWZ0smZFGdEjMO71nBUEJM=;
        b=ZRCrYTIlJT9AmR1KPXzbC50nBpvywNF9CMH1+vT8K6Vr7GMh6bC2gAE5PKzVC+KE+b
         t87OoetgI2/LYJVF5oviTELPp62OyYh/99qugIte2U0ab8i/cRBglkukQQnZBq+/Z5CI
         H0lftrVQpaxDwgSmzijlJVn4qmQieauObt0IArbZLXG/6cq1Lk6BBPqAU5JfGdgJkDmd
         tdbBbR+1KV4VBwRdzf/ZkMpyU/WjGzDYADbpjkjkMXSKyOLIuKunHapLp56tHOt++tB9
         nBHyWWfaKrcRD6tkIkxWRQZqZW/GpscggvGWO11skdX7TwZ8w9gr/+1lLxk2AzwABT3t
         tMPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729604084; x=1730208884;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tgoS2l8VhZpexNExm16nvNWZ0smZFGdEjMO71nBUEJM=;
        b=ogIPwu6Djr9M3XyKTS1PRC7P8ARWEcMQWwGxg05geTzgj+naLF+8O4DdDNBeEKyVZK
         ivSgCMhnnKCYz40cIe2K+6jAlGnFCPx5npov/6lTmNaUlepInBmJY4zJqMwjW7Q8P5x8
         u9hm395TIwZhgiEoJsbSTKRBdLIjohC7G3/rBj2qnj/h3lwkBgrpbLW98nAi17bSjkpg
         ENRdQ9GD31AgYOmQbP8vVAceDpJaw9NaQOanXQZlQpZG1jla4ov5ySWIm/DiYR+Nonbv
         V/sTyLa7+XoEe1FPNGokvvwXGjgDSxsuZhBDxi8RRYc7QKap64dHC4+U4DRCIA0oU1I+
         znOw==
X-Gm-Message-State: AOJu0YwwvQITCx6TRP8d6aio/9ti566NTAZQ/u67yzcqXMcOINGaoy3K
	jsM70UTsHaGE8HsrIDqwtJapESGxjBCUC+/TJ3D31yZ9p9HUa13Z4SNrmGilcqzd5E20hx794JS
	O
X-Google-Smtp-Source: AGHT+IG+Rzv6/QlRkajhc5y9sZQfIrJ/pNTpCj3bW63lFxhSddWDQhM8eVp8R3bCdNSvPo3Vl76RYw==
X-Received: by 2002:a05:6e02:1c2b:b0:3a3:b240:ff71 with SMTP id e9e14a558f8ab-3a3f4046bf2mr131649755ab.4.1729604084349;
        Tue, 22 Oct 2024 06:34:44 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a400b7c76bsm18032385ab.72.2024.10.22.06.34.43
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 06:34:43 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v3 for-next 0/4] Get rid of io_kiocb->imu
Date: Tue, 22 Oct 2024 07:32:54 -0600
Message-ID: <20241022133441.855081-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

There's really no need to keep this one in the io_kiocb, so get rid
of it.

Changes since v2:
- Don't grab uring_lock in io_uring_cmd_import_fixed(), but check if
  req->rsrc_node has been set.
- Verify fixed buffers work, the liburing test case was broken.

 include/linux/io_uring_types.h |  3 ---
 io_uring/net.c                 | 29 ++++++++++++++++-------------
 io_uring/rw.c                  |  5 +++--
 io_uring/uring_cmd.c           | 23 ++++++++++++++++++-----
 4 files changed, 37 insertions(+), 23 deletions(-)

-- 
Jens Axboe



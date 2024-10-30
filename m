Return-Path: <io-uring+bounces-4215-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E9AC9B6A22
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 18:06:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23FFA1F21981
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 17:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F424215C59;
	Wed, 30 Oct 2024 16:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="psNqtk1S"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8ECB2144CA
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 16:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730307365; cv=none; b=FnuEmmHDITQQ/IHvGUKUzWpyrz974/SobexJ9Od0T8utcPt6BItRmzRk2eZfY1uHX1e4TJCJNfPeeCD1i/BnBULH/AbrC5HNOITMcufBX54Xs2SwEnwVZiDfMRcKmWPG2Rfz7FLQrTMpB9CjTMRGkZ1C1+T8t/6pn/9BhHbjm+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730307365; c=relaxed/simple;
	bh=q6OcSUdq3KGcS46mXVpBifnYGIrv2MBBfm6AK+vhx3E=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=PadGP7im1X8hMfx9Dgx8b13WKKwKGLrKXalUi8D7BxM5P1tnMh89U52kQSMfb73M/pd3kiwNtT0Q/+cBXrRGZ2yzgCtKuNE9ovKApQH1nJFISR8DSb10VZG3B08XKqi/hg8n4XGk7VyMnmwpZZlX+LJbEW/vewV27f3QhEy+ais=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=psNqtk1S; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3a4e474983fso165315ab.1
        for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 09:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730307360; x=1730912160; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=91Yl99/OQNzIIBP+GwkP9Rod6/8HroJsq2xEwt5WbH0=;
        b=psNqtk1S7LeTYWAuZ9MQ7qv4WZQBl2Bc+XkfEUCSEF9nFxaGtiRB+hdZ8BdfW7scEg
         8O/RueiyazEQqcFYxYO0H5nNDm7YxLBL0GbXk3c1dOCiQvymYiBrsbM5c12Cwn7Eha2f
         L5Iq7OzhU/6UzN4UNez28B1v0S5KElMq38za4SQmgstUAyvelZpIWBUqa1dwDKMzW44o
         6jnExECNXX0bohNVT8gjClca9yodum01MedrLsrEy0jybDWosFezfTKZvLl+DWSa6Yq6
         +VLRI9jZuKWe26rde+roOrCbD1JiF/knpBLuPkJ6Mudrg5sN70FK8PgH5gnKsadTLmJ/
         VoDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730307360; x=1730912160;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=91Yl99/OQNzIIBP+GwkP9Rod6/8HroJsq2xEwt5WbH0=;
        b=AIDkYLYxIkQtDHGxM0RjoHiCPBtsrOzKOL0xBfnIUmHVvEESbbHXl66K75NmILHXri
         0BsVbPjQ0v6Us/uYk91+fjRUmublWCNfz8D0yFDPxzZiCExuiTYZeNRG/pV+aZWC5ZQF
         epQXzl1XtFfiEg+3IDt1e1q17RqhK3SQR8FJZf1Mm9p2BavbiMLaM7x04t3KxmN2Uw9v
         kKZalKNbyw1mdlN0WQnxB0pZy/E4qoTD7hw6m6LxfycSPT2vlBS2XV7rxvvNH7cGetNY
         kRxM3XYdvuWK+gZZQPfClS3ztjfFdDzol/h4PkXB/ejXSS00NIpou0OUEgMn52XeCBRY
         5+VQ==
X-Gm-Message-State: AOJu0Ywc9mChdsoq52MANZ42aOjP9VyxajE0BdKFeA++R4OkPUlBKLrE
	tUoN707+zA9Sy846wYM0Epd831VMdICJD0humKNPOSAyqJ/mLTGUEVS1gRtw4sTNtUqCfV6dAJy
	gBr4=
X-Google-Smtp-Source: AGHT+IErX4bqyGGZhf16ic0LODnLB04NHo3ir8/hxaIgPi3QQhNOo+QIr8z6wMEdMlmDpqXWS+DE4g==
X-Received: by 2002:a05:6e02:1aa2:b0:3a0:a71b:75e5 with SMTP id e9e14a558f8ab-3a4ed295f6fmr163017095ab.7.1730307359538;
        Wed, 30 Oct 2024 09:55:59 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc727505fdsm2980035173.120.2024.10.30.09.55.58
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 09:55:58 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/2] Add support for cloning partial buffer sets
Date: Wed, 30 Oct 2024 10:54:13 -0600
Message-ID: <20241030165556.64918-1-axboe@kernel.dk>
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

 include/uapi/linux/io_uring.h |  8 +++--
 io_uring/rsrc.c               | 60 +++++++++++++++++++++++++++++------
 2 files changed, 56 insertions(+), 12 deletions(-)

-- 
Jens Axboe



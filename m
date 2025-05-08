Return-Path: <io-uring+bounces-7909-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 768CFAAF922
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 13:51:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 007F9463937
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 11:51:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53475222595;
	Thu,  8 May 2025 11:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q2PffEZP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F826221FCE
	for <io-uring@vger.kernel.org>; Thu,  8 May 2025 11:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746705079; cv=none; b=FR725sJvUPh8+kAmf3mSHVDOIqMIkSq8vLPTD0XbQHsHzZ+d1iF1AzQVhPV/945H+E76Ys/cyKyBi/GaU97K0p4VFBN8ukVf8AHp89SX++X5Ew5TfuwPwaP6GCym3C/X8VnP158QTmdTYbGZ/Bb55lMzyy9R3azHUDV8f36PksE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746705079; c=relaxed/simple;
	bh=UY4hOvuxQr6gw7fxH+70oEgb2/WxKHQYr1SUPi5WAkw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gvzT/CX+WYDroaTpy6jnrlNKALgtiVPi8461F4dOFCfVufja7J0AVafw1I4qYdZlTH17Kq9sPIBPN49KFKf9TAoPMY9lacN/Th5zovNftvNMgTKL3fjOE7UbBuHqQoIf/ARrBsrcbMaNBLtftutC/q9G81hFsUm7hs0HfLedLnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q2PffEZP; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5f7ec0e4978so1650218a12.1
        for <io-uring@vger.kernel.org>; Thu, 08 May 2025 04:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746705075; x=1747309875; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xe39B7F0WMGp0nY9RT2X3SK8xDktb2Ja3AGOtlFgLsQ=;
        b=Q2PffEZP5Jq1qPGszbrRv/aeEdApzvR4KL1NWm4WA0gQBk5GnN10z87q2DfWJAWqHe
         jqY2vxdijg5e21IRrzO6wyMjTGFye3QMzm7emASgGy3VxcFSbae/lRw0uKjGQLFyTIER
         UFOir30Hor5QicCGJe4aHPuSoq0I1fS+TgD3IpiX7IdWMu1LcGEjqeETYvQqHtq2F305
         fo7T1VnQrf2NVU0jMoRxHQmM3+084Oq6DHUJmy9YxD6tgwyQfxIm1VDqbDoNPRvAkHWN
         541Nyc2EofTqiSDk4K0eOcjCoNz+1NeyFQxOqou7vxGuzfQw0520UbGskssq49LBE3ef
         xx5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746705075; x=1747309875;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xe39B7F0WMGp0nY9RT2X3SK8xDktb2Ja3AGOtlFgLsQ=;
        b=lXosdUwdQBi8JqYyRwTutffmj1MUtgDjsYNB8AkAs56vNvV5FGAUlhB0zXjhioMu71
         FOiDyMHwMR5+IRRoA/Ao7Nw40lWAA/7+sXLhV3hYV7tKlGtNVw64F4CS6f/fUMcj+2ju
         1Zt6yVmaOD8F6LTshLmg+2VbWW38+VzT83Ex8gaMLFti343Mce734VMXCTu0/aubq8nS
         aOCAkEqmLeYKgfCtJipcanH/FZ6QeBxKUTWaktD8ZnJY49qhQTZuLagPY9n4vwvn9pV3
         ffrtLTqAOVTG9gitVfSGQB6yYGHRcyAKSKx1vGNrwMEOLs021i7f3U3BW34OKQu0eZzS
         fBMA==
X-Gm-Message-State: AOJu0Yz79zMOSpughQjnWklGfJioKtb9geqne/4gp4G0X5nsGjkrq0zu
	JiH+TkcMSZt0K0Y6B43GmljkEdMsljpIH7spD2eXfU2TFUED1k7ool0N6Q==
X-Gm-Gg: ASbGncui7vft5S3m4KkevUNXU10GnpjAAKDiuHL8wBv3tdIaekdSfcHqtntkMzHxZir
	xy0eTQw6eEn/u231+55HTAMJwgYZgy0iVYS9EKzLYjTppoBKX5FdZM4sIUbzpEiNicC9LrsPvnz
	9AIyh0cZZM6odnRSvaWcwr5FyPDrz6gUdzkGe3DzeiLcDHDCvjVccQvPQIjTJOrHkuEoIA5rbgU
	TtWLHrme24jal+TRJlYlX+2mt4Z36y3n+U2yB3oo7cWfrCf8sG01qNI/fwr/fWpJXV90JXcJNOd
	3MAt4Db0TauvaW3zBiomi0x/
X-Google-Smtp-Source: AGHT+IG1/fpMYLSBJVl8LML2heKQkyfpqqWZzn6BcMwDib/g41LIdIGtNjEQGYfoWlMGbSLkEKBXFA==
X-Received: by 2002:a05:6402:35d2:b0:5fc:9328:4c9f with SMTP id 4fb4d7f45d1cf-5fc93284ed5mr216629a12.8.1746705074980;
        Thu, 08 May 2025 04:51:14 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:2cb4])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5fc8d6f65d6sm677051a12.13.2025.05.08.04.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 04:51:14 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 0/6] drain cleanups and extra
Date: Thu,  8 May 2025 12:52:20 +0100
Message-ID: <cover.1746702098.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patches 1-4 clean up draininng, on top I'll be trying to remove
the cq_extra mess. It sacrifices some performance in the path,
but shouldn't be critical, and we'll probably get rid of
the allocation later on.

Patches 5 and 6 are not related but just bundled together.

Pavel Begunkov (6):
  io_uring: account drain memory to cgroup
  io_uring: simplify drain ret passing
  io_uring: remove drain prealloc checks
  io_uring: consolidate drain seq checking
  io_uring/net: move CONFIG_NET guards to Makefile
  io_uring: add lockdep asserts to io_add_aux_cqe

 io_uring/Makefile   |  4 ++--
 io_uring/io_uring.c | 52 +++++++++++++++++++--------------------------
 io_uring/net.c      |  2 --
 3 files changed, 24 insertions(+), 34 deletions(-)

-- 
2.49.0



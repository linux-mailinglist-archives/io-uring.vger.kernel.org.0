Return-Path: <io-uring+bounces-7446-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C269A82E13
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 19:57:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B560447178
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 17:57:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C5B618CBE1;
	Wed,  9 Apr 2025 17:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VW22uMFW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E36B270ECE
	for <io-uring@vger.kernel.org>; Wed,  9 Apr 2025 17:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744221460; cv=none; b=f0zIU1f8veJSedRXnm9qVHEVRqPFhWZGQ7NiMCQAifRUjcPgsAtPmE1RF+Mxeb6GXAS2XjExaoVxaNzp9fsWRsZI5OpkdhOBDanWSuRcxSbZucWpA4NV/PJwc2Z/O7fSZDBkuPF9jikDyfi2QxENF3GctuqaoeGkLxSa40LFQEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744221460; c=relaxed/simple;
	bh=c4R6F1/lksN/i48LlQ68TaNOYRN+bB2WNUjSKQvU2Sg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kmJz5QAkZwn8NoPVFAdCfhB/cw2mcuTXqd0Wu5EqjQxCilXwqFQpvt9NVPvsHYz9z9EU4AxLBA0KiFFGZSftgIM3Lm9Tm8/6PU8OqVBAzC4n3eV5ZGewR3eUTu5RfrZBY/GkpSxFNMPHKe1vNsDzELV/62AubzMseaRtaq3yg2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VW22uMFW; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43cf034d4abso75183215e9.3
        for <io-uring@vger.kernel.org>; Wed, 09 Apr 2025 10:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744221456; x=1744826256; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cje27TIkaXld8aeKnCBWlR6DAJNEU8b8QNSPJZzw8FA=;
        b=VW22uMFWyHjx6nufbHe5MymmnUe5UYagnVe8nNkIn3BvqIdpN1tGYQym98oG/KSLMD
         yRoEcfnfHcmxGxjhqoCy/KjjAhvZPflqhe5X82LxZCI2FepV6LO4Hoq6z9xqwo7UC20G
         g1HbEdDWURQyguulVw7HfskSO0+idFuI578tnmTqO4G2PuufCKdm7PBF/61k3Fi+K+WD
         3gn26IpCL+IyCofi7UjrbfEgdVyt3yqQb9wdK4eSZvM5VHrHEjIz/V2yKmS1+LV793YC
         YIsP8dnhgLkvSdwFqJ+Ywic3cKYxPMqHdVzPgIsvNjiceaKoSGui261Xd5VlMmqz64Ub
         3FGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744221456; x=1744826256;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cje27TIkaXld8aeKnCBWlR6DAJNEU8b8QNSPJZzw8FA=;
        b=XkGo8CfEvjaj6HJkeUy8MUpgDvVf86YH908VJOOQcVZ2sCAZlEylCEfNE1fOGspEEy
         Epb3fBBZZIAlqYRWk/ZJZjDxxx7bRKxMNmpzlPDMkGDR2v2FVa/DLaaZ5g4yrk9Uyi4M
         a8xZgy0/7RS2ApKZZubiCVQyMN1Qfsag1FrzxktGLBZB+YXM/jA/o1YVcequ4jI1CXON
         HJ9iQVwXS+kDTyO9ph11XGwb1JVVeOAMSnCHO/84hoaZrCME7n7Jz+kMsqkBNQbrdtnk
         tmuOatZB/pa2FMdlSjd4S+2Iv1D+0xPBe6MnMs0/xMB7R1AvnSirBGxn9DmVWkgGvEMy
         /AYw==
X-Gm-Message-State: AOJu0YxG0WXBKI5yN6+kKEmE9AOdagkNuFWvkpp6g8l5QPw6NAYFl4bs
	PZvnhYTcjdo/2zebo908EUbAAPMi7Q0Fux99mUCOUpPQdqek5IK4p1KUZA==
X-Gm-Gg: ASbGncvg23tjmvSL8GAU+t0Un6onjEmrAwkYqobzK4lNelf/lAYkXccqhAU329cbVLW
	u9oNY4ycS1yRs8EhwS2y5MAdqC9yuN5jvy7dxNuAfxtiHExElBaDAjmltx/XcOYr6rLiAzwSndd
	dcJy+FcUszLYgiV+Q0rnDKpRQVL4Ckls+dbTA6xkj3qZ5cVEJg1PCuJa6YbQoZ7Tmo67qEL/Z4k
	cT5dNMbcKEQrwM+jNlanBZOwFYUnUsTpg7btZKujkT7Al2hPgdH1j+WIF97Xc5EuJU8lSzWHwTi
	VPilGyTEudJ9mfXNs84dzIXvihrzm5H7VZ1Ruk8bpk7UXrHxEMRwHg==
X-Google-Smtp-Source: AGHT+IGIM4737ue9F2NWyU8Uwuso70rnLOHFkhkcpxA+lUi9xsnKRupguGUVmhnwNKbWZpgvHXQ11A==
X-Received: by 2002:a05:600c:c0a:b0:43c:ec0a:ddfd with SMTP id 5b1f17b1804b1-43f1ec7cd88mr36709295e9.6.1744221456185;
        Wed, 09 Apr 2025 10:57:36 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.132.84])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39d8938a808sm2291470f8f.53.2025.04.09.10.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Apr 2025 10:57:35 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH liburing 0/2] add zcrx example
Date: Wed,  9 Apr 2025 18:58:34 +0100
Message-ID: <cover.1744221361.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We need a simple example for zcrx to show case how the api works
and how to use features. Take the selftest and strip it off tx.

Anything supporting tcp can play a role of the sender, but for
data verification (-v) it needs to follow the data pattern.
Implement it in send-zerocopy -z0.

Pavel Begunkov (2):
  examples/send-zerocopy: add data verification
  examples: add a zcrx example

 examples/Makefile        |   1 +
 examples/send-zerocopy.c |  50 +++++-
 examples/zcrx.c          | 362 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 410 insertions(+), 3 deletions(-)
 create mode 100644 examples/zcrx.c

-- 
2.48.1



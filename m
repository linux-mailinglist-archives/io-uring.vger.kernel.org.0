Return-Path: <io-uring+bounces-7972-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DC7A0AB653F
	for <lists+io-uring@lfdr.de>; Wed, 14 May 2025 10:06:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 95389188F034
	for <lists+io-uring@lfdr.de>; Wed, 14 May 2025 08:06:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56CB4218587;
	Wed, 14 May 2025 08:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eJLvlQGQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF6A218AC8
	for <io-uring@vger.kernel.org>; Wed, 14 May 2025 08:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747209981; cv=none; b=njRCDOHq2rKQsHzvAv6RDZWWfpzG8Yyx4ZLzUPyj8F7Sup2qGNha92nVeGVcX250pb6O/oi7SQbDioHB+zGrQ8E6aMflgzcsKPO1DJZmcv6EqFKQTcfGCjW23GeM/yXHnFzhB5CPqTtR77VsVtqKpd/hQYiBeRgQxqN0r6/Wnuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747209981; c=relaxed/simple;
	bh=ay8MHjq7TQP2GAH1kecs5+rgO0aMcZQFX2yNYdCi/yo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TvlwtGIOB7ELkNJJj3USl/vRu8B7yC7RqOKmzjH1rcfQnoYPN1PigaVBJ+YDlVesCcbrYt3dWXnSIqB0PsSXZpYGsNXMq2kKsxoKyaNkWTIEN6EsrErp2I81jDyPzUOaJ2pOKR29hYhgxXL+clw6l/SSfHz+EUtqj51FzdrBuQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eJLvlQGQ; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5fd1f7f8b25so6957042a12.0
        for <io-uring@vger.kernel.org>; Wed, 14 May 2025 01:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747209977; x=1747814777; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Sunf0Izi5+kMUN2OqcHY3A4tFw9kpddmicLiND7FMv8=;
        b=eJLvlQGQ4Y7Zq+6N6HuN++B+O5+4XT1JFIsahwH58+dNya4V4mTOtREDeUcRCIX4Z1
         /9fnDQz9MvQ9QlZwA/TJeqrXarbUVQ+AzLMTQZvJGMH2A6pjKqQvIPGgrT3jZjALdVbY
         Ly32IAmfb6Qxa1SJ6yx3wSY+hrNOD2/HBY3FEFEutOVk6z9IKkOs9p5FxtcfY+Tgctk8
         U+5V0g+/ax9/ZjcLhGDivzGqpAsmJC3UvcE7GEQSYxqlzQvJMwgv9IRkBuFbyin1bimO
         d9dwnQvkgikuI8p0KejsU++c7ArXRqz6cJVEGG+cQpChoAjUj/eDilbSeoI7XzvdL85b
         RDMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747209977; x=1747814777;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sunf0Izi5+kMUN2OqcHY3A4tFw9kpddmicLiND7FMv8=;
        b=E1Y1B6MW5Ob1TFTWHge/u0Vv6+chicMmDCRAm9c6L2dUOGJeZ8x+sRPCqlEalmfh48
         9V5EQ0mKxAi95v+7PwPOXjx5pPIAgB6sdq5cZTXpDyNe3D2gIEGCjUHzqnrnil+r5dyR
         5IfLcEITRcohW8QwwF+Zab/4faJlMmfMI6zKwf0KUNP4edKaQW1EQGJ0bKnMwmP1Qwcf
         l6LbYMmjj+pmQVw4hL+ZIhcIxFH0iPv52uMAvgpK5T+Yau2quscIbkIfRo2VZRFlfIf4
         4JUWW6nO2yhDlLqaDNmE8kfDmk72PJyzA9t2LTKSVIoUNcHUvb7whu/eVkVn2iBnBP9u
         RsVA==
X-Gm-Message-State: AOJu0YzcuOqj2BAcuv8J+XjHQ2CNsKwIBR6i/OTgfcfPQNmEeloj9YJZ
	ThFELd0A0B+U2qIOpZE3qYsdURNIdw+tssCsETeGMVxEn5K0q7vGjrHjtw==
X-Gm-Gg: ASbGncvhK7vfSb80QQns2tcl57ApZIp0Beam1snJcdbYQ4BvV0NKDVZ8Rcj4unwtkQp
	pKwOcwEoy49XRZBX6X4DxYSm2JQaPMKf1dl919W0Z+r3WOhY8blssQasLQVrnHRM1Znm+l5F6nx
	+9DIH0+dcoZDebaV36zPRrmRpLdj0y7SW1A6AJUHKNiqmWw9wfEdo9652CepRn6ecc7BlYVahkf
	0cS57u+Qk32Kl6w5f95kE1ewShT+BuMPKmrrpSIdzYar2G9TA52mlCuE8YfNWONv5r2EfZOFzs6
	uBKu9h8nM2mUjmt8kcnclHTQ4pYEphVnG1I=
X-Google-Smtp-Source: AGHT+IExYh0UKGLR/ibbqIkbGatny0JuTNCV5UTW+yDb5/s8JrZ63ILMxByO/9gcXvIeCc7PlXbegg==
X-Received: by 2002:a05:6402:3581:b0:5fb:f708:2641 with SMTP id 4fb4d7f45d1cf-5ff988d090bmr1807315a12.27.1747209977152;
        Wed, 14 May 2025 01:06:17 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:ee61])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5fd29adb7absm4969579a12.32.2025.05.14.01.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 May 2025 01:06:16 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 0/4] overflow completion enhancements
Date: Wed, 14 May 2025 09:07:19 +0100
Message-ID: <cover.1747209332.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sligtly improve overflow CQE handling. First two patches are just
preps. For DEFER_TASKRUN patch 3 minimises the critical section,
moves allocations out of it, and eliminates GFP_ATOMIC. And as
a follow up to a recent review, Patch 4 adds a lockdep assertion
against overflow posting abuse.

Pavel Begunkov (4):
  io_uring: open code io_req_cqe_overflow()
  io_uring: move locking inside overflow posting
  io_uring: alloc overflow entry before locking
  io_uring: add lockdep warning for overflow posting

 io_uring/io_uring.c | 90 ++++++++++++++++++++++++++-------------------
 1 file changed, 53 insertions(+), 37 deletions(-)

-- 
2.49.0



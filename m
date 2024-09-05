Return-Path: <io-uring+bounces-3045-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0415496D31C
	for <lists+io-uring@lfdr.de>; Thu,  5 Sep 2024 11:28:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE8F01F25097
	for <lists+io-uring@lfdr.de>; Thu,  5 Sep 2024 09:28:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C590B197A92;
	Thu,  5 Sep 2024 09:27:29 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E68C197A7A;
	Thu,  5 Sep 2024 09:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725528449; cv=none; b=MhjduwIZkVQi+i1avogoXzB2M7JQ3w1EuRWexhD/1vcmvEI5RZFpZ+ckb6FzXHd/+Alzty4kCp0NnQsXKACt0kbdRcsxVAiyFmYt/REkoInD1yk+H5ybkTKCxWkWF80us+8LJkqG2yNLsf9aTJ5q2YXoNKnc/K2qIGIekT0CfrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725528449; c=relaxed/simple;
	bh=4iXHiaHmMfPlrIg/MR9QkOejr+dGX2C9r+fuICZAqwE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KNBzxl6umBnFOq6IesIcwOxMGsOxeWbRaZVUuWKpb/qOey/tHkoLPPy4N8l+QMRPhQQ9dNiTbQXKBH8DEgdGv9nJWQLOTEbfDURMWXDvQRrIevSwN1CQVGXoYFcQJEMCc2BuwWZhWvYqcQKDLwk4g25CYDQeqBM9GP1xqhVcdWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3C3D11576;
	Thu,  5 Sep 2024 02:27:53 -0700 (PDT)
Received: from e127648.arm.com (unknown [10.57.75.86])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9A68C3F8A4;
	Thu,  5 Sep 2024 02:27:22 -0700 (PDT)
From: Christian Loehle <christian.loehle@arm.com>
To: linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rafael@kernel.org,
	peterz@infradead.org
Cc: juri.lelli@redhat.com,
	mingo@redhat.com,
	dietmar.eggemann@arm.com,
	vschneid@redhat.com,
	vincent.guittot@linaro.org,
	Johannes.Thumshirn@wdc.com,
	adrian.hunter@intel.com,
	ulf.hansson@linaro.org,
	bvanassche@acm.org,
	andres@anarazel.de,
	asml.silence@gmail.com,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org,
	qyousef@layalina.io,
	dsmythies@telus.net,
	axboe@kernel.dk,
	Christian Loehle <christian.loehle@arm.com>
Subject: [RFC PATCH 2/8] cpuidle: Prefer teo over menu governor
Date: Thu,  5 Sep 2024 10:26:39 +0100
Message-Id: <20240905092645.2885200-3-christian.loehle@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240905092645.2885200-1-christian.loehle@arm.com>
References: <20240905092645.2885200-1-christian.loehle@arm.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since menu no longer has the interactivity boost teo works better
overall, so make it the default.

Signed-off-by: Christian Loehle <christian.loehle@arm.com>
---
 drivers/cpuidle/Kconfig          | 5 +----
 drivers/cpuidle/governors/menu.c | 2 +-
 drivers/cpuidle/governors/teo.c  | 2 +-
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
index cac5997dca50..ae67a464025a 100644
--- a/drivers/cpuidle/Kconfig
+++ b/drivers/cpuidle/Kconfig
@@ -5,7 +5,7 @@ config CPU_IDLE
 	bool "CPU idle PM support"
 	default y if ACPI || PPC_PSERIES
 	select CPU_IDLE_GOV_LADDER if (!NO_HZ && !NO_HZ_IDLE)
-	select CPU_IDLE_GOV_MENU if (NO_HZ || NO_HZ_IDLE) && !CPU_IDLE_GOV_TEO
+	select CPU_IDLE_GOV_TEO if (NO_HZ || NO_HZ_IDLE) && !CPU_IDLE_GOV_MENU
 	help
 	  CPU idle is a generic framework for supporting software-controlled
 	  idle processor power management.  It includes modular cross-platform
@@ -30,9 +30,6 @@ config CPU_IDLE_GOV_TEO
 	  This governor implements a simplified idle state selection method
 	  focused on timer events and does not do any interactivity boosting.
 
-	  Some workloads benefit from using it and it generally should be safe
-	  to use.  Say Y here if you are not happy with the alternatives.
-
 config CPU_IDLE_GOV_HALTPOLL
 	bool "Haltpoll governor (for virtualized systems)"
 	depends on KVM_GUEST
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 28363bfa3e4c..c0ae5e98d6f1 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -508,7 +508,7 @@ static int menu_enable_device(struct cpuidle_driver *drv,
 
 static struct cpuidle_governor menu_governor = {
 	.name =		"menu",
-	.rating =	20,
+	.rating =	19,
 	.enable =	menu_enable_device,
 	.select =	menu_select,
 	.reflect =	menu_reflect,
diff --git a/drivers/cpuidle/governors/teo.c b/drivers/cpuidle/governors/teo.c
index f2992f92d8db..6c3cc39f285d 100644
--- a/drivers/cpuidle/governors/teo.c
+++ b/drivers/cpuidle/governors/teo.c
@@ -537,7 +537,7 @@ static int teo_enable_device(struct cpuidle_driver *drv,
 
 static struct cpuidle_governor teo_governor = {
 	.name =		"teo",
-	.rating =	19,
+	.rating =	20,
 	.enable =	teo_enable_device,
 	.select =	teo_select,
 	.reflect =	teo_reflect,
-- 
2.34.1



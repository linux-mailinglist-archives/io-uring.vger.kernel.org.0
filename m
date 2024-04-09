Return-Path: <io-uring+bounces-1475-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D7F489E19D
	for <lists+io-uring@lfdr.de>; Tue,  9 Apr 2024 19:32:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52C331F2429C
	for <lists+io-uring@lfdr.de>; Tue,  9 Apr 2024 17:32:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BDD815625B;
	Tue,  9 Apr 2024 17:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G3xoF8fM"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A621A13C66C
	for <io-uring@vger.kernel.org>; Tue,  9 Apr 2024 17:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712683923; cv=none; b=O2YqyrLSRjmMeSSpfHyuhYmrRoVjxKmqE4/gyxwYXP26CVwQkbmkQjrBiLo8UoeJm9sk4/RFn4ZfBlV3cSm39IvxPfVh5QO4+EwJ5UmwAC8Gp5/aRDRLJn7HVwNGjJMEQn6gu8z1ztt8DRtDFxcLWYLYEMCWGvLkDTYdenZHr44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712683923; c=relaxed/simple;
	bh=89XWmrMpZlyu7F0KRDrAyw/pyYu0FcCyRR+jjUB0A8g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q5lkdEBqb9evabTMUV7lpt8ShW4EAC4ozsmTfsxzvvfegY9LgjUHNC5bWG98lGyE3AlfT+AYXtI+IPyz7J2XqHiwP4AUkaQvnF5HRNAGn9tYjiC0OcvPGGf+EaEws325goIMVhj/WVuubuzuKz0tRUtI7hun026dTCzFKGNw+Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G3xoF8fM; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712683922; x=1744219922;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=89XWmrMpZlyu7F0KRDrAyw/pyYu0FcCyRR+jjUB0A8g=;
  b=G3xoF8fMlfQKJcRcmvnf+P5tICuxvRKpNcnfI7IfyHmqEr8/P5EJOv60
   3yJPYMHgYfE2Yn/6d/AmVuVlOu4HpVyQUW4QJIY5ocOSZBs4MFpWcw4kV
   ErkWOwThD1HhOCboN27hxFr/AkNbT1knRShyXqNRZlII1yk7BRqffzB6H
   FU/Ez4AzhRxdjn3DUdb1kxla4cOlCDq0BwAmJ17curXi/9gPL1VbOdxQu
   7Dw2u1orPLsV1mex4PHeXU4OShj/OBmwAppjEqAAXE8FLwPCx7AqEGizu
   grar1XFVCzr0v9FjSLC5TzeaziQn/jUGSmIOwsnrecaceAHH8789qXyCF
   A==;
X-CSE-ConnectionGUID: TIh2fq+iTXyIs4E2mCGPLQ==
X-CSE-MsgGUID: XaCowFoXRaaQnUz08bF/gw==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="8585607"
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="8585607"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 10:31:59 -0700
X-CSE-ConnectionGUID: w4HnfA5bS4y7PbGbn5Impg==
X-CSE-MsgGUID: FTE+uXZTQeeWzVj8OGC+dA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="20237014"
Received: from unknown (HELO dcai-bmc-sherry-1.sh.intel.com) ([10.239.138.57])
  by orviesa009.jf.intel.com with ESMTP; 09 Apr 2024 10:31:58 -0700
From: Haiyue Wang <haiyue.wang@intel.com>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyue.wang@intel.com>
Subject: [PATCH v1] io-uring: correct typo in comment for IOU_F_TWQ_LAZY_WAKE
Date: Wed, 10 Apr 2024 01:35:28 +0800
Message-ID: <20240409173531.846714-1-haiyue.wang@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The 'r' key is near to 't' key, that makes 'with' to be 'wirh' ? :)

Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
---
 include/linux/io_uring_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 05df0e399d7c..ac333ea81d31 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -13,7 +13,7 @@ enum {
 	 * A hint to not wake right away but delay until there are enough of
 	 * tw's queued to match the number of CQEs the task is waiting for.
 	 *
-	 * Must not be used wirh requests generating more than one CQE.
+	 * Must not be used with requests generating more than one CQE.
 	 * It's also ignored unless IORING_SETUP_DEFER_TASKRUN is set.
 	 */
 	IOU_F_TWQ_LAZY_WAKE			= 1,
-- 
2.43.2



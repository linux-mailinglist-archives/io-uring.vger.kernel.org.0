Return-Path: <io-uring+bounces-778-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FD788689DA
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 08:29:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D12B71C21C89
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 07:29:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7117A54776;
	Tue, 27 Feb 2024 07:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G2OXM9e+"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FADA335D8
	for <io-uring@vger.kernel.org>; Tue, 27 Feb 2024 07:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709018963; cv=none; b=jJ9f0NaguTQvXFhGmGdwqCVKB4hd7zVaXB22GhFEd5uWjiem7MK1weUgouF/yEJINka72mWGLtvMWNH+R0sCmBoEhdzUO4K5QE9tpscvLjeckZYGPumMKjRbfcjDQO2k1IAe3PIa71R6g/XH/eKuMsdDSLuYQR3vEXnlLcJW65c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709018963; c=relaxed/simple;
	bh=Idx7pHogOqECSUY80qjE10iFO4Uv7DCIiIOrYTE47KM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H0A2tcpuJOqJQyy40X3DlTNShpOrNQhYON3upJwVjWZaTpFKaQSgJZtQLCtSUqALW612pm0epsSULaN3JmnzU3JSwZkpZBdQnQ2SuYD+myUC8SDtVkuVE0WUuB5Y5fs5pn8rxLgosgfvKIszgEvD8r6dO5bp710E+1tHptWaoGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G2OXM9e+; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709018961; x=1740554961;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Idx7pHogOqECSUY80qjE10iFO4Uv7DCIiIOrYTE47KM=;
  b=G2OXM9e+yu3Mb3C+ApZVt9PgFt77/73i2drc6KcImZwZaG2H8QLs5drV
   H6P5uhcmeaZ+idAKQmyaFD6hAZYrbHf74t+fiqeSmurr6iFKcuuPp9uy3
   pTl4E6yqHbEGSsoMJvuDl6wU83DkGgv75g6Unm2S8crQG3oObX9d0/FJc
   2N0OSmv8xlGbMmgYpcLe8HFpwBMXjMwpEMk2gDbZeSXdAoDAwjV28I7Pf
   dwyPa+eCFn+AO/hbr5w8Yg/3S8hWBlx9frTO5BqwXfZe7BPBHb6mQY2O2
   lNF5TyOk2D1NU0hqfoNTwJm8zjDiTGHxQod4j8B1c8aa91MRXXTdopfXE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="13897386"
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="13897386"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 23:29:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="11545786"
Received: from dcai-bmc-sherry-1.sh.intel.com ([10.239.138.57])
  by fmviesa003.fm.intel.com with ESMTP; 26 Feb 2024 23:29:19 -0800
From: Haiyue Wang <haiyue.wang@intel.com>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyue.wang@intel.com>
Subject: [PATCH liburing v1] .gitignore: Add the built binary `examples/proxy`
Date: Tue, 27 Feb 2024 15:32:09 +0800
Message-ID: <20240227073213.1200023-1-haiyue.wang@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the missed built binary to make the git status clean.

Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index d355c59..94966e7 100644
--- a/.gitignore
+++ b/.gitignore
@@ -23,6 +23,7 @@
 /examples/napi-busy-poll-server
 /examples/ucontext-cp
 /examples/poll-bench
+/examples/proxy
 /examples/send-zerocopy
 /examples/rsrc-update-bench
 
-- 
2.43.2



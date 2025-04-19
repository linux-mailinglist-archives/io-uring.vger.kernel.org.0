Return-Path: <io-uring+bounces-7556-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C8330A942B6
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 11:58:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F05F48A3FB3
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 09:58:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DAB93FBB3;
	Sat, 19 Apr 2025 09:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="hggYxTAZ"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEE101BCA0E
	for <io-uring@vger.kernel.org>; Sat, 19 Apr 2025 09:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745056696; cv=none; b=QTu2ZgJZkDZfeVTfqxFeea+FErr16x6MPEqTwcAul5yys/EO7srFuPDoFsVtOpT/3u617ggaQTayHqAd3ioeRwVBORGaExI+IXEwbX4arclnp8AzjrdyhopL5ZvhRo63Qa5Xkk675ZeB2HQslb7RvwBgqRj8rzqxUWUs2EtkGS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745056696; c=relaxed/simple;
	bh=q28O8ZtcLNmrlz2+Wx3OWD3TtsJPlT88SGHtKx8bc4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUZe0OlSbpNsN+Zy2jmonP+AZ1C8IFAH/w1H6fnZ+hqT2XU7csOYZeBZR/TPnzNaxEBYtH1Ve911GK2QWaw17R/lHM/pBCTQGJPTCnojmcjGg4dukkiflvN9sGbpyDppN8hZZWW47RG2CEQB9X8qIHFjdrDZlxDGoadT3f/Wmfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=hggYxTAZ; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-ID:MIME-Version; bh=H/fOk
	QESKDcbw+QwrmPaXbrZ5PvFFk5tmzkRSUT+c0Q=; b=hggYxTAZa3PmwpIgkIChL
	KhSXgBNvg+ZqKFJoopCIZdLx5PA7jayTVC2BsYmzvJagNobQMgDYYMbWkB9I17yD
	jdZ6RbuwuybWcgkXd7uIHD/csD8EJBM5dLoZHiyjbSOIv7YPSKdIQAyVjgw412sh
	tBt8ILzdtCGEFQ87wr0FIw=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wD3m++lcwNo7+zKAw--.32953S3;
	Sat, 19 Apr 2025 17:58:00 +0800 (CST)
From: Haiyue Wang <haiyuewa@163.com>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyuewa@163.com>
Subject: [PATCH liburing v1 2/2] .gitignore: Add `examples/zcrx`
Date: Sat, 19 Apr 2025 17:57:21 +0800
Message-ID: <20250419095732.4076-2-haiyuewa@163.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250419095732.4076-1-haiyuewa@163.com>
References: <20250419095732.4076-1-haiyuewa@163.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3m++lcwNo7+zKAw--.32953S3
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjfU5rWrUUUUU
X-CM-SenderInfo: 5kdl53xhzdqiywtou0bp/1tbiShI0a2gDcBBU3QABsE

Add the built binary 'zcrx' for clean git track.

Signed-off-by: Haiyue Wang <haiyuewa@163.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 4148091..c693631 100644
--- a/.gitignore
+++ b/.gitignore
@@ -28,6 +28,7 @@
 /examples/rsrc-update-bench
 /examples/kdigest
 /examples/reg-wait
+/examples/zcrx
 
 /test/*.t
 /test/*.dmesg
-- 
2.49.0



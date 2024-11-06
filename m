Return-Path: <io-uring+bounces-4502-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF6C69BF0A1
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 15:47:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 84511B2522C
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 14:47:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E269A2038C2;
	Wed,  6 Nov 2024 14:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="LWu/MnY+"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECC421DC07B
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 14:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730904383; cv=none; b=LYRPL3D7QyUdfmCNV9/y8pG2KKs2dNrbkYh3r6r/AvIbnaORwGv+VVe93VUjoLjfo9yHCps1OMfz5o9Kgwud1PMA3agCPFrDmpGO29sh9KPPMy6ZcpD2fJUbTvQCumGbDPNWi4AiemEjnvnqB6RPW684WY38vNsxckI+TpRBOow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730904383; c=relaxed/simple;
	bh=AVxgRj+6MNI3DbWhH3kSARHoaGa2nnguyQoKBp2NZsw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X9S7eqjwxZTx1PffpEqdLepqf2XcpZqinee5hUzBlE899UnShN3F0bVVn2wTbT/7GpcupgILpv/4x8z0P7ojsFvX73rk69iu32APSVE98Vk8a7vfipxhW4vKHAyqmMy6kYPP/6UhwwERJ+7lX7LR+GcQei+bM3Yq6Nb/MoadijY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=LWu/MnY+; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-ID:MIME-Version; bh=dpI+3
	Zb2nolW10mS6l6rgGTPW9284/O0nlLp/nyec6c=; b=LWu/MnY+rKYCIPbmjgUPF
	3l0WCL1BCpUibMaASx/UGs45kbWDnn46xsTIeYc8/9qvtB1JCEGUfbklGEP1n2Ls
	VZjUsFOAxi8GXpPu/y4uNrexoF9Mt6KfoTPlu/nqzNTjxbjvZeBle/pDtn0H72Hs
	ZwjdYLeCPLQfGt78KmRpzU=
Received: from localhost.localdomain (unknown [114.86.104.95])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wAnLw8zgStnNMASBA--.8628S2;
	Wed, 06 Nov 2024 22:46:12 +0800 (CST)
From: Haiyue Wang <haiyuewa@163.com>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyuewa@163.com>
Subject: [PATCH liburing v1 1/2] .gitignore: Add `examples/reg-wait`
Date: Wed,  6 Nov 2024 22:45:27 +0800
Message-ID: <20241106144545.6476-1-haiyuewa@163.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAnLw8zgStnNMASBA--.8628S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvj4RJpnQDUUUU
X-CM-SenderInfo: 5kdl53xhzdqiywtou0bp/1tbiLwKPa2crT6j55wABs9

Add the built binary file name from the commit for clean git track:
abe992c56178 ("examples/reg-wait: add registered wait example")

Signed-off-by: Haiyue Wang <haiyuewa@163.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 8edb52d..7bcc514 100644
--- a/.gitignore
+++ b/.gitignore
@@ -27,6 +27,7 @@
 /examples/send-zerocopy
 /examples/rsrc-update-bench
 /examples/kdigest
+/examples/reg-wait
 
 /test/*.t
 /test/*.dmesg
-- 
2.47.0



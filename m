Return-Path: <io-uring+bounces-5163-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 613749DF691
	for <lists+io-uring@lfdr.de>; Sun,  1 Dec 2024 18:13:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A435D280C3E
	for <lists+io-uring@lfdr.de>; Sun,  1 Dec 2024 17:13:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59CF81D5CDB;
	Sun,  1 Dec 2024 17:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="nRypBfyU"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED27033086
	for <io-uring@vger.kernel.org>; Sun,  1 Dec 2024 17:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733073204; cv=none; b=bZRcgec40pmzkbzO7T008V0Bq3xK2Uu+JTHQJTPvoP8jpKbKkrT1wmnWdKfFM/h1bMH0fTuUzkKIFqmdlezBn8w1sraLUB6PLndddzauGUbDEJ1zo9kbLXbohlb6hTRu/UWyKq7/9kObIQcMo79NuUB7s09scW7d85BrkL11Sto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733073204; c=relaxed/simple;
	bh=aQhHuN1Dgpo4lw7QHpQMU+xYOjhKiigpj66Omx7TyRA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V+Ql5cemNg+hitipAVgl5+n2XJVi77/FFNXa8fZ//pHqWUFJu/4iHFbzpxB6E84OzPdKA4epV3ZHtlCe5rdkFlZquBtpfiKHzlVn1Go1oxwqC8rbSa9A0GjAmilBINl7tCgU4rxMZ8XwtAmF1JduskdkHjzjjCGvvbnOk5W6bgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=nRypBfyU; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-ID:MIME-Version; bh=BdhpQ
	bbn7QiSNX8gqiX2G5XUO1slgJnafGi30pzDz64=; b=nRypBfyU6LJZY12DawFJe
	rUWrQPFkNiZY1srlF01bS8lTWAhrYXUzx0Yx8sK9wPo1uSzC2eRtHfS/spy18t1d
	6ORroHoVV1zyid6gfa1jn3nP4XXzpWO/UcP6+3aRbf6mlyPpL6DpyZz/SvTmHE5q
	JcUVeOaQZc4YPgi9rnnMSg=
Received: from localhost.localdomain (unknown [114.86.104.95])
	by gzsmtp4 (Coremail) with SMTP id PygvCgA3hrYnmUxngk91Aw--.20135S2;
	Mon, 02 Dec 2024 01:13:11 +0800 (CST)
From: Haiyue Wang <haiyuewa@163.com>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyuewa@163.com>
Subject: [PATCH liburing v1] configure: Increase the length of print result format
Date: Mon,  2 Dec 2024 01:12:44 +0800
Message-ID: <20241201171247.23703-1-haiyuewa@163.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgA3hrYnmUxngk91Aw--.20135S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Gw4xZr48trWrCFWDCry7GFg_yoWfXFgEkF
	WkJr1I9343ArZF93W5Ca95uFy5u3W7Xrn0kF4Dtr17CF1xZ3sxJ393JF1fKFs8Xwn7Ar9r
	W39Yva18Gw1Y9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRNgAw7UUUUU==
X-CM-SenderInfo: 5kdl53xhzdqiywtou0bp/1tbiYA2oa2dMl4QkcAAAsC

The commit 906a45673123 ("Add io_uring_prep_cmd_discard") add an string
'io_uring discard command support' with length 32, it will print result
with 'yes/no' value as:
 'io_uring discard command supportno'

Change the string format length to 35, to beautify the printing:
 'io_uring discard command support   no'

And the print result maximum length is 76, should be acceptable to avoid
line wrap:
 'libgcc_link_flag                   /usr/lib/gcc/x86_64-linux-gnu/13/libgcc.a'

Signed-off-by: Haiyue Wang <haiyuewa@163.com>
---
 configure | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure b/configure
index 4794306..c2351a2 100755
--- a/configure
+++ b/configure
@@ -114,7 +114,7 @@ fatal() {
 
 # Print result for each configuration test
 print_config() {
-  printf "%-30s%s\n" "$1" "$2"
+  printf "%-35s%s\n" "$1" "$2"
 }
 
 # Default CFLAGS
-- 
2.47.1



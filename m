Return-Path: <io-uring+bounces-8799-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E8A2B12D4D
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 03:03:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 555E24A217E
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 01:02:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15BA014F121;
	Sun, 27 Jul 2025 01:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="H3NjG/hY"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8895613DDAE;
	Sun, 27 Jul 2025 01:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753578183; cv=none; b=lYci0n3H1LzBWpb/ixJyqde6mYKaxtE+5dJv2nxU314Zp9/rEHa3B6qd8WZ5QSAHCIENJbkwgsaoS1N3BUuqNPL8aTJ4IO1txYbanaYGxlLcViDfTHujPgEKjtJ4PNgYJtiEaJdwoaXuHcHULnw8BrveaO12fTKfRoB+TAPH6a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753578183; c=relaxed/simple;
	bh=etqAV++elJSj94Vs+g/cqagRXHDxS/kbllsDICy83Hc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T4lXAhZC4YmLbp34LX886Cl4QBfLZ7OZ1PL3HR0Gv2fignktAp11ZBFB3UifQGW8OkllNN7oaBnIuEOqx0r3GxHtj8KsvI0sBEs4lx9QYQK4W5FdX4ArUcJZnXIzuoG6c+NfnVL72ZYymhWANY13oq7DRbZuWS7B6w0PNvjlcCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=H3NjG/hY; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=new2025; t=1753578179;
	bh=etqAV++elJSj94Vs+g/cqagRXHDxS/kbllsDICy83Hc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Message-ID:Date:From:
	 Reply-To:Subject:To:Cc:In-Reply-To:References:Resent-Date:
	 Resent-From:Resent-To:Resent-Cc:User-Agent:Content-Type:
	 Content-Transfer-Encoding;
	b=H3NjG/hY2ssGl2jt9lvkNVhTSFk0wbNYRFB90elGMyCTrmyUW5D9CjzKe9u7HZb4Z
	 zSyMvJl6HgCbQCyz7C+yQgAT2tZQS9vWV1IAxWeHezGZHRiLOUZT8xy1kU2w0TBhgT
	 cUszwHv8/lM8I8BOLl2SvtD0hkcU9cNAnSFpRgqN39F+L6Ik3y5qnaQCd6rFv3DvN6
	 vtKUF2qWsPqsxK68H8AyNe2TEjEGsojNKnkdJVaJvZaFvn4RcQ6ryLvRvrS64b6BoK
	 ZYEHrOEBPOpjuj7k/a0hMrwR1cLSClgnTMcV/VDTVt/tZEabwrjc6TWs8v7iRV27Va
	 rXiDNB/vAxXKw==
Received: from integral2.. (unknown [182.253.126.144])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 2BC673126E06;
	Sun, 27 Jul 2025 01:02:57 +0000 (UTC)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: 
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Christian Mazakas <christian.mazakas@gmail.com>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH liburing v2 2/3] man: Add `IORING_ENTER_NO_IOWAIT` flag
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Sun, 27 Jul 2025 08:02:50 +0700
Message-Id: <20250727010251.3363627-3-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250727010251.3363627-1-ammarfaizi2@gnuweeb.org>
References: <20250727010251.3363627-1-ammarfaizi2@gnuweeb.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Based on an explanation from the Linux kernel upstream commit:

  07754bfd9aee ("io_uring: enable toggle of iowait usage when waiting on CQEs")

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 man/io_uring_enter.2 | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 99c0ab222675..a054a7cdfbd4 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -134,7 +134,21 @@ but merely an offset into an area of wait regions previously registered with
 .BR io_uring_register (2)
 using the
 .B IORING_REGISTER_MEM_REGION
-operation. Available since 6.13
+operation.
+
+Available since 6.13
+
+.TP
+.B IORING_ENTER_NO_IOWAIT
+When this flag is set, the system call will not mark the waiting task as being
+in iowait if it is sleeping waiting on events and there are pending requests.
+This is useful if iowait isn't expected when waiting for events. It can also
+prevent extra power usage by allowing the CPU to enter lower sleep states.
+This flag is only available if the kernel supports the
+.B IORING_FEAT_NO_IOWAIT
+feature.
+
+Available since 6.15.
 
 .PP
 .PP
-- 
Ammar Faizi



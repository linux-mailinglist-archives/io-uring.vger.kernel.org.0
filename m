Return-Path: <io-uring+bounces-8795-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DD42B12D3B
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 02:44:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FC7C17CCB4
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 00:44:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 482E813DDAE;
	Sun, 27 Jul 2025 00:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="gIOHzopy"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B237950276;
	Sun, 27 Jul 2025 00:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753577027; cv=none; b=HEya8uuNxBQGSMTQ924kVS+VNUaLgc0yRmT3jxhy4BrAto1A8fiSNul0nJfecIa+CGES9r1Lim0b1wchXu0VgHggYiuLjcvk9ZMp7sZx0SPTJCX55/Ny6/ZTvQb6oIn91mKGte/eftilalf9UOP4/ygj+I9Bc1KzW3xiTP1rXWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753577027; c=relaxed/simple;
	bh=etqAV++elJSj94Vs+g/cqagRXHDxS/kbllsDICy83Hc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JhLa7NEprz3q3sRqlBLDU3S8FuYfzrmYQTP77bIP8vx3DhFV/j/o/IUYb28tH/avpkUv3VpWBfbIN5Cu+B4IeItY9M8fWkQwcFFz5lJYpLG3IypCjRIgMrXf+oLIruSlqgR2O4LBnCt78nhuo8sXB2BnlL3hHSN714CmNDy4qYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=gIOHzopy; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=new2025; t=1753577018;
	bh=etqAV++elJSj94Vs+g/cqagRXHDxS/kbllsDICy83Hc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Message-ID:Date:From:
	 Reply-To:Subject:To:Cc:In-Reply-To:References:Resent-Date:
	 Resent-From:Resent-To:Resent-Cc:User-Agent:Content-Type:
	 Content-Transfer-Encoding;
	b=gIOHzopyfyxtSg0AwruuN7l2A9LuGWN/83QP90p3knEtbN4/164+c6bHKVx+8gv8M
	 ELrAtjXmitWWCU5h0jH2WnrYdXTKx8Z/NOQUzSY05S3SHd5QOBA8GykHebkh3OeEav
	 JZmKX9l3FAA/g/TLWcIyZR0ZFgGBjpn51DEbL0u01oOkahuzYs52TfeYkBcpPjnQ+H
	 /8LuN1qqc3QGVaEqgp41VseYIaUXoaPAB43Pyd20PXrxausftbZdl/lDMPkgGN+XKe
	 ZM/Qp2m32UvrZoipT3dVqhfFJndNXAgcV9xG9vIzStEyJTx2J7N5wzuBA1uh2v/uPn
	 eTdf9HijC4xsA==
Received: from integral2.. (unknown [182.253.126.144])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 74F3E3126E06;
	Sun, 27 Jul 2025 00:43:36 +0000 (UTC)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Christian Mazakas <christian.mazakas@gmail.com>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH liburing 2/3] man: Add `IORING_ENTER_NO_IOWAIT` flag
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Sun, 27 Jul 2025 07:43:15 +0700
Message-Id: <20250727004316.3351033-3-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250727004316.3351033-1-ammarfaizi2@gnuweeb.org>
References: <20250727004316.3351033-1-ammarfaizi2@gnuweeb.org>
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



Return-Path: <io-uring+bounces-8794-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 914AEB12D38
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 02:43:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B423189E87E
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 00:44:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F22AB72605;
	Sun, 27 Jul 2025 00:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="thrwQxmr"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383EA2A1CF;
	Sun, 27 Jul 2025 00:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753577025; cv=none; b=IhxA7GhxvPVM8L1wNHTrcDZOwJ6qC6CG6IRI9u7Nd3YLFZKgFyKcznBbngV3E3TQMXdVaKsXlshgWFdLmP+BD/SMZGTY0DRxSks9ew0IMwvTxvlVOXWVtDavGV61bjDPqURYPpirS0elh11yW7ClvO2MooxISFc5Wf94eCB5zGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753577025; c=relaxed/simple;
	bh=u+LMdMlZmXbZ2orkb0poCs5sPB8DiAEbn1KiRhovcm4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MtT9ODwLHFX8GbIl+5gV2gfM1VMZ735sfGA7lQvMdoe6A8Vzxb0RTqIclWfY9A8pLkuW3TVg5e7euUSCTLtmTUAOP7lx/u9qB2WaKKjPVpLVDbWhOmWHQL4ekoZKGV8els4gSqaZlh75RO023ojSY8VpqUonpFihrw1NQaIoe7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=thrwQxmr; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=new2025; t=1753577016;
	bh=u+LMdMlZmXbZ2orkb0poCs5sPB8DiAEbn1KiRhovcm4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Message-ID:Date:From:
	 Reply-To:Subject:To:Cc:In-Reply-To:References:Resent-Date:
	 Resent-From:Resent-To:Resent-Cc:User-Agent:Content-Type:
	 Content-Transfer-Encoding;
	b=thrwQxmrbeYIlM3+Q12FkG9yhZ9xPMjRNDjW8/Z9VQRBIxiEMRp+5ThUnPg1KsLwX
	 8JicqXi30piT+9Htc6t61Olaf1x+X720ROXfTLpLUKtCT91PF9XY662xUswwv1/qSq
	 OXFEIbsCMRjllCGObm7snNQjmtHqjXb8KBZG5RTGeSnW6epkdIkrcQSLBRVJ+t8e70
	 lgigFnzcsnhEOP/L3S6Z1VCvA3Vby41bq0Dd2IxlKfBseQf+Bzv5Z6a1YOhCxzNVp0
	 6tJ6LEwJN7fDg3WHdRTZ1neCcYelKz+dEyLQ6sltyEob6PfW2xNUeiipox7Rlprzyx
	 YWghEaQ2OpWMw==
Received: from integral2.. (unknown [182.253.126.144])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 5907B3126E05;
	Sun, 27 Jul 2025 00:43:34 +0000 (UTC)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Christian Mazakas <christian.mazakas@gmail.com>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH liburing 1/3] man: Add `io_uring_set_iowait(3)`
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Sun, 27 Jul 2025 07:43:14 +0700
Message-Id: <20250727004316.3351033-2-ammarfaizi2@gnuweeb.org>
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
 man/io_uring_set_iowait.3 | 57 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)
 create mode 100644 man/io_uring_set_iowait.3

diff --git a/man/io_uring_set_iowait.3 b/man/io_uring_set_iowait.3
new file mode 100644
index 000000000000..5caf0a3a4cc6
--- /dev/null
+++ b/man/io_uring_set_iowait.3
@@ -0,0 +1,57 @@
+.\" Copyright (C) 2025 Jens Axboe <axboe@kernel.dk>
+.\" Copyright (C) 2025 Ammar Faizi <ammarfaizi2@gnuweeb.org>
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_set_iowait 3 "July 27, 2025" "liburing-2.12" "liburing Manual"
+.SH NAME
+io_uring_set_iowait \- toggle of iowait usage when waiting on CQEs
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "int io_uring_set_iowait(struct io_uring *" ring ",
+.BI "                        bool " enable_iowait ");"
+.fi
+.SH DESCRIPTION
+.PP
+By default, io_uring marks a waiting task as being in iowait if it's
+sleeping waiting on events and there are pending requests. This isn't
+necessarily always useful, and may be confusing on non-storage setups
+where iowait isn't expected. It can also cause extra power usage by
+preventing the CPU from entering lower sleep states.
+
+The
+.BR io_uring_set_iowait (3)
+function allows the user to toggle this behavior. If
+.BI enable_iowait
+is set to true, the iowait behavior is enabled. If it is set to false,
+the iowait behavior is disabled. The iowait behavior is enabled by
+default when a ring is created.
+
+If the iowait is disabled, the submit functions will set
+.B IORING_ENTER_NO_IOWAIT
+in the
+.BI flags
+argument to
+.BR io_uring_enter (2).
+
+If the kernel supports this feature, it will be marked by having
+the
+.B IORING_FEAT_NO_IOWAIT
+feature flag set.
+
+Available since kernel 6.15.
+
+
+.SH RETURN VALUE
+On success,
+.BR io_uring_set_iowait (3)
+returns 0. On failure, it returns
+.BR -EOPNOTSUPP .
+
+
+.SH SEE ALSO
+.BR io_uring_enter (2),
+.BR io_uring_submit (3),
+.BR io_uring_submit_and_wait (3)
-- 
Ammar Faizi



Return-Path: <io-uring+bounces-8798-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B911FB12D4B
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 03:03:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83E79175945
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 01:03:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BAAD1386B4;
	Sun, 27 Jul 2025 01:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="stDnWIal"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC4078F2E;
	Sun, 27 Jul 2025 01:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753578181; cv=none; b=lsgN+yCWj9QioEddMEtp46YuF4UpOf6yHKveQB5eiFeeXvHqFJr0ygJU2Lua2mb07oUz340UOhVMawxacs6tq0zRJerHTS0IaJZHi8Pbu4xWmdggFz4rU1c6ZwosqmAA1qXZo+wrEVIoO3zIrFNWSlLRlfFTjoM+1+0rdepbBEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753578181; c=relaxed/simple;
	bh=u+LMdMlZmXbZ2orkb0poCs5sPB8DiAEbn1KiRhovcm4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QJR7V48T7zisiMIpgbinRs2/PTVXeCJYMuQ3Z0ji8Yj2xkQ3FQT78qfq13au81JUE6h5yVqunsVaRzva8l2NR6fn1p2S4Z+foa36HUhtlns84F1zXmXzTCNmKMaHKL9kXJnRz+bwX83iyv6oMcCqb1ZN5OQjHF9BTW3vg+J/xsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=stDnWIal; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=new2025; t=1753578177;
	bh=u+LMdMlZmXbZ2orkb0poCs5sPB8DiAEbn1KiRhovcm4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Message-ID:Date:From:
	 Reply-To:Subject:To:Cc:In-Reply-To:References:Resent-Date:
	 Resent-From:Resent-To:Resent-Cc:User-Agent:Content-Type:
	 Content-Transfer-Encoding;
	b=stDnWIal4LDjFpx7+O5Xo2LccWFoPrI3ce5i2yLfRmWXKMpTjPakHRIRD1Rno/uoX
	 UeouLAxc9F/Wn26u6y+pMsoszvmIuRckOS/EiF1RDdzBeqZJZrbzvAzKjplfS/pccd
	 b/7pXZYyFPENSLi9AikQkMrCeLTVuRBDq23eCTeKNRY5/9gsCmoQS2znsUM5n6Jjv5
	 gUyqb12Ewz/GFBTySCx/5GpxRAp+8ulTzBgXhowR0TgMRPx9txxrEH2T8IdUQHG0SG
	 mU/L1fC7bo/FRV6UcGZQlVW4fQNcDK09nlAU31/11eIgbKryomNbQ8Q5+FvHbCZvm2
	 om3Rvjhd/nNwg==
Received: from integral2.. (unknown [182.253.126.144])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 3D1363126E05;
	Sun, 27 Jul 2025 01:02:56 +0000 (UTC)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: 
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Christian Mazakas <christian.mazakas@gmail.com>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH liburing v2 1/3] man: Add `io_uring_set_iowait(3)`
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Sun, 27 Jul 2025 08:02:49 +0700
Message-Id: <20250727010251.3363627-2-ammarfaizi2@gnuweeb.org>
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



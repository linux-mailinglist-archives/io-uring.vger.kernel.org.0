Return-Path: <io-uring+bounces-11620-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DBD6D1B233
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 21:05:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AE547300F6BA
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 20:05:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A015F318B9E;
	Tue, 13 Jan 2026 20:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iJ+NxVs7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0C0318EC5
	for <io-uring@vger.kernel.org>; Tue, 13 Jan 2026 20:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768334716; cv=none; b=hMwNjZ9kfp4foCs0vhaVI9feW5VPmttO6X2ox5XrjqK0yLzhNbwVhV9SB/l4b9q4Yv4wK745XZCa4fC3xu1lxrx3FMWfMogIkCDUErWUaRV94mopN7aT+SvVB3rt5gxZ4qpMTAyoljlRE4jITc5t7iUES3AueBW081OL+1ScIyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768334716; c=relaxed/simple;
	bh=PVK4zx+iAg1xSkSww2YIAp43DZ2xDdx7KXCuUCiljPo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lnHRe2b3F0HWslhmbPKvUlGB+HtqHSebo/vfsVDiT3rftc5YShdY9OlZxu0GT0eYwm5BSilEFyFk9wkEp7DSuX0mpiP1JD0/i8s63Y3Eq98xWOEymWfqn6T/pl1mU87lPjiDe2gsrbZPRG1TY6qEIHxQ10FB6GC/+I+FmUgGd5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iJ+NxVs7; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-431048c4068so106476f8f.1
        for <io-uring@vger.kernel.org>; Tue, 13 Jan 2026 12:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768334713; x=1768939513; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hzE/bmbpWgcGvieEN/yzS+sECZYWMMekWMACbW13vIc=;
        b=iJ+NxVs7/JHV5WEVyE7ZZkePwgQdWUfDH47FxYtQzBCjfUQah+n9+XgoXKvssr1eeF
         b9VIps01juWDh1Kp9DvTt2DYzdVufIQRFfRQK4IO7oJQZh8y3bBIJO3r0xSHTLRIt/e1
         WdxXIeQw/fS/KCfeV0ehWtmkKg5lKV4MD0vYusRH49TXD9ls9bBzPpHsJIFFTYxZXgPV
         zQRu2BbezdCtnQwGw2N+yJly65SJCmx64Yfby49nk8Lvau69x1XDmbGImHNX1fFEYt6Z
         fJrMbS9t3J+lpLLGtTR/pDoC8W3Ox7LICuKdot18ZVhn8/G4RXNNqqRPkTH65zmn5Zfe
         JNYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768334713; x=1768939513;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hzE/bmbpWgcGvieEN/yzS+sECZYWMMekWMACbW13vIc=;
        b=V5v1aWP9gMqdYfJir+7AXtSaN1pcFTB5pRaqnLXLvPS0Yke3bLHSnO5OwC1C8VLYi2
         aPfImRBOY1adERCuqtJ9zOkB7yKkDDZ1EbAhSVB2OFjYt7DafPDFDN8v8cHgdhvqPS1n
         68L34ekWq+U0bi6AfNe2ESAImTRZfQUgawtEbix8Swvnq+ZpOx+NLA1SV/tgFUcG3q99
         dQ8Lfk1p6r7H9YWHq7cB8b331ymB/mUeD08jzlj+zWzXoJaPI9uog4HA9mjIS/rVZJ16
         BAYdYINtxMHgA+QI1uCXJdMqB3Tt9TC+ThRuZ9ZRT1pvU0CvFCwvv20ZnhMhQELMlvIw
         dptQ==
X-Gm-Message-State: AOJu0YzVQ7wODQ8pgSblkFd9VY1Y5dK40hhN/uBx8KN0ShoDjWbtoGST
	dU0Wc75w1cIpH2rRslIm3vwcHi1HnEfSs8R+QSukymxKd4mzci2OkMQWlooe2Q==
X-Gm-Gg: AY/fxX4wMZtWmxcDaPsXWZYqbicOMQGIj50NCJfGcIX+OlCe2N1YnY5S8e5BT/upxXR
	W5mhPrbxK26GM8rJMdeSEKDqDDGT/WVeFYcA+QZ3ZWAtUAi+XgBAaWFLEo6SHdukKUUr5uPmPsC
	dSMq4bJ0x1rKX4pRJR9ov9z+31PqW/NORE6W4Njp5EwpA6Kzg/ke4V2dZlLyvnG05Px0GD6DQaJ
	KcLQRhXtkLjyc1Gi1U6YuEHuwMunIlZrHzKG4MPiJawt9gGVkS4JolI3VhyHRCBZLZWE6MDmize
	4gAa/aq/WhhckRG7/evo5nlGiSbCznEx2FkAVQ1bgloW1APNOyhhkm72xEM73SVDOVE5qPbg04m
	M3vL9zyvnYkmXBiNNEeF5ZX1jL9jL1sfT3206W3zrlFkfPz20nz4dLioJ0Pkmebsnoh7hTKph0S
	uXJ5eMCYXuONo/CNWR/3HZIYZT+6N7M4A0hLM+8LuxrCT4c7z59po00bDQ3+8cbEcu5Vys6rvTJ
	Sq5fOaq8ZjT651DgA==
X-Received: by 2002:a05:6000:1786:b0:432:dcb1:68bc with SMTP id ffacd0b85a97d-43423ebca36mr5292712f8f.23.1768334713059;
        Tue, 13 Jan 2026 12:05:13 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5fe67csm45964942f8f.40.2026.01.13.12.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 12:05:12 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH liburing 1/1] man: add io_uring_register_region.3
Date: Tue, 13 Jan 2026 20:05:05 +0000
Message-ID: <6ba5f1669bfe047ed790ee47c37ca63fd65b05de.1768334542.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Describe the region API. As it was created for a bunch of ideas in mind,
it doesn't go into details about wait argument passing, which I assume
will be a separate page the region description can refer to.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 man/io_uring_register_region.3 | 123 +++++++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+)
 create mode 100644 man/io_uring_register_region.3

diff --git a/man/io_uring_register_region.3 b/man/io_uring_register_region.3
new file mode 100644
index 00000000..06ebd466
--- /dev/null
+++ b/man/io_uring_register_region.3
@@ -0,0 +1,123 @@
+.\" Copyright (C) 2026 Pavel Begunkov <asml.silence@gmail.com>
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_register_region 3 "Jan 13, 2026" "liburing-2.14" "liburing Manual"
+.SH NAME
+io_uring_register_region \- register a memory region
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "int io_uring_register_region(struct io_uring *" ring ",
+.BI "                             struct io_uring_mem_region_reg *" reg ");"
+.fi
+.SH DESCRIPTION
+.PP
+The
+.BR io_uring_register_region (3)
+function registers a memory region to io_uring. The memory region can after be
+used, for example, to pass waiting parameters to the
+.BR io_uring_enter (2)
+system call in an efficient manner. The
+.IR ring
+argument should point to the ring in question, and the
+.IR reg
+argument should be a pointer to a
+.B struct io_uring_mem_region_reg .
+
+The
+.IR reg
+argument must be filled in with the appropriate information. It looks as
+follows:
+.PP
+.in +4n
+.EX
+struct io_uring_mem_region_reg {
+    __u64 region_uptr;
+    __u64 flags;
+    __u64 __resv[2];
+};
+.EE
+.in
+.PP
+The
+.I region_uptr
+field must contain a pointer to an appropriately filled
+.B struct io_uring_region_desc.
+.PP
+The
+.I flags
+field must contain a bitmask of the following values:
+.TP
+.B IORING_MEM_REGION_REG_WAIT_ARG
+allows to use the region topass waiting parameters to the
+.BR io_uring_enter (2)
+system call. If set, the registration is only allowed while the ring
+is in a disabled mode. See
+.B IORING_SETUP_R_DISABLED.
+.PP
+The __resv fields must be filled with zeroes.
+
+.PP
+.B struct io_uring_region_desc
+is defined as following:
+.PP
+.in +4n
+.EX
+struct io_uring_region_desc {
+    __u64 user_addr;
+    __u64 size;
+    __u32 flags;
+    __u32 id;
+    __u64 mmap_offset;
+    __u64 __resv[4];
+};
+.EE
+.in
+
+.PP
+The
+.I user_addr
+field must contain a pointer to the memory the user wants to register. It's
+only valid if
+.B IORING_MEM_REGION_TYPE_USER
+is set, and should be zero otherwise.
+
+.PP
+The
+.I size
+field should contain the size of the region.
+
+The
+.I flags
+field must contain a bitmask of the following values:
+.TP
+.B IORING_MEM_REGION_TYPE_USER
+tells the kernel to use memory specified by the
+.I user_addr
+field. If not set, the kernel will allocate memory for the region, which can
+then be mapped into the user space.
+
+.PP
+On a successful registration of a region with kernel provided memory, the
+.I mmap_offset
+field will contain an offset that can be passed to the
+.B mmap(2)
+system call to map the region into the user space.
+
+The
+.I id
+field is reserved and must be set to zero.
+
+The
+.I __resv
+fields must be filled with zeroes.
+
+Available since kernel 6.13.
+
+.SH RETURN VALUE
+On success
+.BR io_uring_register_region (3)
+returns 0. On failure it returns
+.BR -errno .
-- 
2.52.0



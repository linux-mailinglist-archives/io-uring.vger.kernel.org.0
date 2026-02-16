Return-Path: <io-uring+bounces-12257-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KOagFJJCk2kA3AEAu9opvQ
	(envelope-from <io-uring+bounces-12257-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 17:15:14 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B90AA145FCE
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 17:15:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BCF4D300A77E
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:14:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0A243321D8;
	Mon, 16 Feb 2026 16:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mM6aBp90"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46033321D4
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 16:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771258497; cv=none; b=FCIv/a9iADvhxo7Y82Gu6HWjvuOYrBxITCpTKW/nb4/VFWLVYl6GPm5y4lrN04mO76T2GgpK2RYGGZmxzoC657n0O4mbhTZBnA6BeV5cDr2q2HLR71ylzXQ7PrijfpfAC/AGq0SGVMyrb3eRAN3NciIN3YhftMNbZ6UDVMVuQ2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771258497; c=relaxed/simple;
	bh=pLqQtD+fnZB4aI7iBIoVWYS16krvV+aWu2KCByo+DGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iraGxUV+YktU2823IAaWFzmdxswEGneMXxqkQ67uilHFkZsXkkwKjGvxH9wu2HHBjGy32p+lNcvcSzZDU1HrllWw4uagMMtk5T1ohgyL5hHzXlVMCAIiuTmg2pFmVB6jyABFAwoRdxdueM7+d451cv+hgjYVDUaenQ15CTcRhJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mM6aBp90; arc=none smtp.client-ip=209.85.128.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-48329eb96a7so18053485e9.3
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 08:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771258495; x=1771863295; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RP+RCcuEkQIJD9ELvJouTH15rgDiNXUlxScfC4dYoF4=;
        b=mM6aBp90n12DaRgz07kPNiZWB8PdQl80TcyTuwM+691sXnswjE7M0COeWWRmA7TuAL
         7zhcrmYfsb6tLfUZOVhhHCTyMQRgiWsraRP275LoXpPimafvDi5sR5Xa3zg7KbDYYxGi
         IWnCc/tT3fZQCHuSBq/vitPoygTBBuDYX/u1zmPs7ojJn3pLtdmWwkWGFE4ZojKz3ogt
         OoZ94LV/PIuTLa2W3g7j3oVrrTowM5ZcYwPSjRebjeR/mANFvqh4GlY1z137VWDycpp4
         wwJS3X0ZhLSYipLTazhgHY1qiPULz7bCKfl9L4i4PruMBex8g8LunH39hTxibPshbwWe
         ik5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771258495; x=1771863295;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RP+RCcuEkQIJD9ELvJouTH15rgDiNXUlxScfC4dYoF4=;
        b=GbTKiX42N79BX1+bKsKY8hl1/A4kaRKhpVr7K79pIX/HHE99ThQ/s6ZRQaA8IPrbF0
         vehAEoif0vY1Dvv7AUCBpHtRyCmpQACpC05hc4lYmGNBcvg5y9TTZzg92Beyf9KZI3DL
         4iGlFAsVDR5kZWFIPxIRoVAl3cCvw+8s2c1R5cP1dxtqTren++d5qw9f/ZqX858j3bpJ
         knm7TX3rTBCXD0VHxVY33bCZKqfnhq2Ab71KJP/PBR9E1TMNxVi9VsoR4Y4U/ya1ARST
         3mbJhCuV8VlOt8dsrr2AorYhN53qZcnc7OY/BahbqgBuD2soOfo4UPQQ57qKknxDa0rp
         MA7w==
X-Gm-Message-State: AOJu0Yy31EvoUPqPnKH1AtDz2rIN/RA1qwP/UsOSHHw/o5dctssmEucV
	awyI9ioYEWJQjRXWvTlkKjxwc9bHZ1Qcw16W7rQpOe5fPJohs7yXzC4s6sP6DADZRPcZug==
X-Gm-Gg: AZuq6aJKdwbwmenqOBMrPOV4RbKVDsjPz5Yv3krTCI1Ki9QMVpqW485xh4d090uz+D9
	LMgJ19W+/oHEJc4EGzI2at2dyxHsCh0E/9tLMhfnfzl9gCBJ4eqBsF6RtZ+ofLI5mpISNnDfOBa
	D/UzUzKGQHt89qubEm5I/tOotPqYDzMrFUQ5qWxByu01lk2ZN4RA7ZMzCooHfoaU0W87O1ZE8p1
	YiQWBuPJV2KOt7m9DS6PhTm7yTjyQSvsZC0CoZK7v/qTSw7IQ0x1GJ7nMWlVxAvYf/lZe6m0LmY
	PvkZyFsXH6Kdn258f9PKAdjmToMUzdAZdWes+gPjcl7UpgMZpPtlJDgFO/rT+V6x7RxoxO3BzRW
	fQLV7MkeKNAcG33Z5vfdE+M8dP2ZfvcEg+jKnozbxzFbbloBpvJ6Vv6CXOCyxQNSou9NurfzEIq
	2bgBQW2nWDwWaMWLsLESqQ+40RuFoqYYac3yH9dkPAKsfPnR1ZdVrNIyFHMxxqho+/u0oesnJy4
	klSJQ==
X-Received: by 2002:a05:600c:4f86:b0:47a:810f:1d06 with SMTP id 5b1f17b1804b1-483739fc258mr169704945e9.4.1771258494709;
        Mon, 16 Feb 2026 08:14:54 -0800 (PST)
Received: from localhost.localdomain ([196.119.106.230])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48370a4e149sm132709755e9.2.2026.02.16.08.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 08:14:54 -0800 (PST)
From: redacherkaoui <redacherkaoui67@gmail.com>
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	linux-kernel@vger.kernel.org,
	redacherkaoui <redacherkaoui67@gmail.com>
Subject: [PATCH] io_uring: document advise SQE field reuse for 64-bit lengths
Date: Mon, 16 Feb 2026 16:14:24 +0000
Message-ID: <20260216161426.10810-1-redacherkaoui67@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,vger.kernel.org,gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12257-lists,io-uring=lfdr.de];
	RCPT_COUNT_THREE(0.00)[4];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[redacherkaoui67@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B90AA145FCE
X-Rspamd-Action: no action

IORING_OP_FADVISE and IORING_OP_MADVISE reuse SQE fields to
support 64-bit lengths without extending struct io_uring_sqe.

For IORING_OP_FADVISE, the length is carried in sqe->addr when
non-zero, with sqe->len providing legacy fallback.

For IORING_OP_MADVISE, the length is carried in sqe->off when
non-zero, with sqe->len providing legacy fallback.

This differs from the more common addr/off/len interpretation
used by many other opcodes and can be confusing when constructing
SQEs manually.

Document the field mapping in the UAPI header to clarify the
intended behavior and reduce the risk of misuse.
Signed-off-by: redacherkaoui <redacherkaoui67@gmail.com>
---
 include/uapi/linux/io_uring.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index d84627cf06b4..a19bd1e42561 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -25,9 +25,11 @@ extern "C" {
 #endif
 
 /*
+ * IO submission data structure (Submission Queue Entry)
+ *
  * Field reuse for 64-bit lengths:
  *
- * Most opcodes interpret:
+ * Many opcodes interpret:
  *   - addr as a userspace pointer (buffer/iov/etc)
  *   - off  as a file offset
  *   - len  as a 32-bit length
@@ -37,12 +39,14 @@ extern "C" {
  *
  * IORING_OP_FADVISE:
  *   - off           : file offset
- *   - fadvise_advice: POSIX_FADV_* advice
+ *   - fadvise_advice: POSIX_FADV_*
+
  *   - length        : addr if non-zero, otherwise len (legacy)
  *
  * IORING_OP_MADVISE:
  *   - addr          : start address of mapping
- *   - fadvise_advice: MADV_* advice
+ *   - fadvise_advice: MADV_*
+
  *   - length        : off if non-zero, otherwise len (legacy)
  *
  * This mapping is part of the stable UAPI.
-- 
2.43.0



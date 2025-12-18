Return-Path: <io-uring+bounces-11168-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AA65ACCA18C
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 03:45:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D0A9330084D1
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 02:45:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3398727A927;
	Thu, 18 Dec 2025 02:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="QWg/Jpch"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f225.google.com (mail-pl1-f225.google.com [209.85.214.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2132FC86B
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 02:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766025907; cv=none; b=LB5Wsc6BfWJ+NbueJfGW4+e4kobqj5O/d2b5BnBg7c0rOWwryMxi384/gAWYcOBYrU4PkNeg3G5SylA7Q8GMHGrp4/voOUOTG7OBDLt290TkHEk0jtRPjfse4f74HLNHh/m/XhsnDJVaE7uO3Rz0iM2tGuJ4XZuWaPuwpG40tdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766025907; c=relaxed/simple;
	bh=L5Uqu9+rr+DwT6pdOZXAwcq9nYIz91fuoF+OXKgDo4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLZ+HVogsExWB/UOvCzXHVgckcc28EAhEEMh0Lk1MN0OZi1Tajtlb9DX6bsbWzQ2lfWWxXIO/1QznAqBZ65IR9I/Qi0lrQcTHwTymRDHeZiIH40Js0ZafZ5dYCfGEIja3NjYJO9NPkNs0U26QqahxHt7GMw0zLEMbHAqmJh4edE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=QWg/Jpch; arc=none smtp.client-ip=209.85.214.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f225.google.com with SMTP id d9443c01a7336-2a097cc08d5so345985ad.0
        for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 18:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1766025904; x=1766630704; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8/b4bbf5Fpl1ur/4rCqqMbk9Yx0Nl8rzYgHyXMsZmA8=;
        b=QWg/JpchEaI+A2XxnCK3RiZ1vRCZalvOa9J5DO55Fsq1OM25XT0Xhsrf7WnORjARY7
         SRus9koTp4mOVaZJHL5fS+B091b+iE58ZeWyMTq6CFKjJT7aqqx+8AzQGrYtxQAyYd9S
         9Zy9FQsXsN11VE5fpuoVsTVChlm6owaO5T+19PNDh9C+EcFYRbcuC+6CizPDbbs4+aeH
         0KqmrqeclKkwGbMRVadJyj+0Wv3MUCJcgb2KypFkSa2DBsfiAz/EmGZHoC4pmUE0zFIg
         uPeZTwD8YKyd1Fm8digSCiFqACpuLMb79Il0e2xrsP/VhivlJGPnfZShaMVXnSvf3bjP
         NFzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766025904; x=1766630704;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8/b4bbf5Fpl1ur/4rCqqMbk9Yx0Nl8rzYgHyXMsZmA8=;
        b=s+8wWqLq2BX44S48nyIjkHQyDLdIRik/a85/D0RhE1UOHaRz+XyGf5aQmfwYAM8c5v
         eK/O5uMtekhypL4pS7EpS++TEzodiphY+6gxntlczGOPDlYCK6eqVA9y3tG/Bk6vMq3a
         gMlXelMNpGxDbopG1uTbvF7TZ8ElKjLGPbS/N6AtNONjGC4P3PEiWPmDU29n53/ypnko
         VvAGq6QxWndJkWsCzMFGvnDP/glUK+ie2NdqmNbCzUjmWCzHytZ0PzRkfqWGkimEZIJa
         hGWECStxeQgnixRpnbJtkp+BYr/4xYdSEPlgz65KVqtcYAiYg+FQV+34JN71tB1UU+mQ
         ao8A==
X-Forwarded-Encrypted: i=1; AJvYcCXUJVXTcFh93DbXBeN3TswtByvdGn4mIrqfw3/VJyT3Om1Ovl5i/S7DxA0QVsxM5EcxBByhzHW7Vg==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywv3L5uIJkKgtEfWKVftVyMKE5cD+PiNAqm4VEvJhI6i8pyBRfR
	kRVR5qkyL8xouAcc746xNJseb7tBRN4sa7ij9GMX+svtODLGAtXjuX25dpVHCiqzuW+DyOf5nrZ
	qfQmCtxdeVsXBUzf6Q5aEkc/GX7+MJkbKMp7NRjTn/duiajFyCCyI
X-Gm-Gg: AY/fxX4TfVxo7adefFKI/8UmUYXHQpTLEbkVxr52O8l8Tk7+sVF5/Q8w1276JcmMKJp
	Ps5SMUS/qkeILHinuTV2jaHjOZXy9Tvk74hfbUD208lfndC4sR9T+9Qfq6IKQBLczuqTDp60T66
	PdXyoNFx5jqGIK0UK1VVQgSKl4w9qzY3JU/I55NVyTNCFd/Mb1VvMv8gc4vvUPq2uAs2rhC8Omf
	wrH7Pn4b7mMwKIAEI+AyM87k+Eh2HSB4I0kTNEihvEpFrx8zRTEk/1TBL1f7Y86k+uSmhK2StqK
	xI3zN/0SVwWoeGA+13LPzQBBVahYi+O17tAjaJ9EBF2jupoT3GhmVEEoRSREzseO+ClfFjsP1xT
	UG1kMBpqaIpNPOkI2+x0w4J8iQXA=
X-Google-Smtp-Source: AGHT+IELQcyX0BuhAdYyweS2xiLxp/916xvfJHq29Z1LD/xwAwNxnN1c74MVP7pk5B0pAgqSxlddAfPDutJN
X-Received: by 2002:a17:902:ebc9:b0:29a:56a:8b81 with SMTP id d9443c01a7336-2a2d4509762mr5916985ad.8.1766025904052;
        Wed, 17 Dec 2025 18:45:04 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2a2d08ab029sm1603095ad.24.2025.12.17.18.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 18:45:04 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::1199])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 764913420E0;
	Wed, 17 Dec 2025 19:45:03 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 6923CE41A13; Wed, 17 Dec 2025 19:45:02 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Joanne Koong <joannelkoong@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v6 2/6] io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SETUP_SQPOLL
Date: Wed, 17 Dec 2025 19:44:55 -0700
Message-ID: <20251218024459.1083572-3-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251218024459.1083572-1-csander@purestorage.com>
References: <20251218024459.1083572-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IORING_SETUP_SINGLE_ISSUER doesn't currently enable any optimizations,
but it will soon be used to avoid taking io_ring_ctx's uring_lock when
submitting from the single issuer task. If the IORING_SETUP_SQPOLL flag
is set, the SQ thread is the sole task issuing SQEs. However, other
tasks may make io_uring_register() syscalls, which must be synchronized
with SQE submission. So it wouldn't be safe to skip the uring_lock
around the SQ thread's submission even if IORING_SETUP_SINGLE_ISSUER is
set. Therefore, clear IORING_SETUP_SINGLE_ISSUER from the io_ring_ctx
flags if IORING_SETUP_SQPOLL is set.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/io_uring.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 761b9612c5b6..44ff5756b328 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3478,10 +3478,19 @@ static int io_uring_sanitise_params(struct io_uring_params *p)
 	 */
 	if ((flags & (IORING_SETUP_SQE128|IORING_SETUP_SQE_MIXED)) ==
 	    (IORING_SETUP_SQE128|IORING_SETUP_SQE_MIXED))
 		return -EINVAL;
 
+	/*
+	 * If IORING_SETUP_SQPOLL is set, only the SQ thread issues SQEs,
+	 * but other threads may call io_uring_register() concurrently.
+	 * We still need ctx uring lock to synchronize these io_ring_ctx
+	 * accesses, so disable the single issuer optimizations.
+	 */
+	if (flags & IORING_SETUP_SQPOLL)
+		p->flags &= ~IORING_SETUP_SINGLE_ISSUER;
+
 	return 0;
 }
 
 static int io_uring_fill_params(struct io_uring_params *p)
 {
-- 
2.45.2



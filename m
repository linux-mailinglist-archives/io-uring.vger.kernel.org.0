Return-Path: <io-uring+bounces-13992-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id Vr5ICvQQVGqGhgMAu9opvQ
	(envelope-from <io-uring+bounces-13992-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2026 00:11:00 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7242D7461C1
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2026 00:10:59 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ad0yYiOV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13992-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13992-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3D1643005D17
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2026 22:10:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A28C137A820;
	Sun, 12 Jul 2026 22:10:57 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8E1378D9B
	for <io-uring@vger.kernel.org>; Sun, 12 Jul 2026 22:10:56 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783894257; cv=none; b=KmGO/rJ4qCIybCOfcqSLByqIlOWvA+WfNmrJ4k2U4przgaljK9XCmw8VdDJrRm7CnJTcrrf+LGwVZVPPNM9PEZP9ftvnLb8Tk8vIlXQ53oJ5XBXQ3R4VQxkw8lrTV0PoyM0lap+ii804CLf0MJGOikAIITlGWkAKPsJWpNIVIFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783894257; c=relaxed/simple;
	bh=nI2OmfY6iCymHU+tfpwB1mxUFk68uJPEfLvGaKUJF94=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JtgceDWFQGtSp3oqukwMm/GzXAxoh7Oz4s8i1SW5h3r3Rjn00t4Vl+LRnEC7cpgpVeF9SQoDxX4l5FxhrBqqx/LxqvYZL/CdNDeAPud0GdBz808hbdqlDCT6oTYEH5fBj6cKMnskRa/Aq49e1UNRmtZTb+aUbpXABBmkofNSomc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ad0yYiOV; arc=none smtp.client-ip=209.85.216.52
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-388b404ea89so2051247a91.0
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2026 15:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783894256; x=1784499056; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9Na6minr8Y7XJ09vJ92XWwDtz2aqFboPlB9lZYImt/Y=;
        b=ad0yYiOVk7Xl6yEyx7Ya/Y9CB4RsFae/iK/17kWwT+d7jgNjyK1h6UeJQWVHyhX53B
         SeNEQXuyGb7etVIZ4IyrSrJT9D+kRTS8s/AMW68C2ItWyKRnkVrlEYEsh22Px/MRbtnF
         9pZtq+M3K9vxgcWD74VINpqF/SYcVWiF2Loxc2eXYId3Siq/2h7JLNFE2M0v5v1tpDGp
         Tk7j+dP59xReUHmkiX0gv2sLo8tuUWBXhfKgqn30yGcGB/on995lVZ/oYW1iUIk9UGjQ
         wKa8gCP7UMkKsngP2AxRaFNoqeJ41o7Pu/CiMXB9CX+oIASRS+jgy7F89nwRBX1350Aj
         90TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783894256; x=1784499056;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9Na6minr8Y7XJ09vJ92XWwDtz2aqFboPlB9lZYImt/Y=;
        b=IpSeBDG7VKu/8eF3larr4PfEXTze8spAukHmroJP4gXCeaS56M7A4O/DRzfXl5YZKl
         6f5/s66AD/YsH19gYV3XuJ5TjsN8DLVvlVf36Or+i7d1YZaKyhJVwyygzB3PYTn4FJJv
         XOG6QwozWQ8xUedar5TTHL8p34lVtEMHl8pNB09K1NpPgsjr8D4NeNSAryCCjjPYg0yo
         +QWQc5jaUTc2iLH6aSTsTnRWUiiYhcCCN4yDASsZ8wP9gNzjk5DoKi4o+GMmkuznzWy9
         Xw8END5qVNMf3QNgVLtK7TDa5UDWGc68Llv+SnCTv+GbyOnSPG7CBfcnAH8JLRMwW58X
         fWZw==
X-Gm-Message-State: AOJu0YxnLjWblw+v73KDbQLMFiOA5ffsQDImjMH+DMi81KV27nqcbpUe
	NhDLQGXyODCe3fnDFr24tkBA3Xsaar4cCPg/Ye1fTflXLIEJ5z8zg8M5GnIFKmP8KPk=
X-Gm-Gg: AfdE7cndC/kdwbWJtwW5QKidnIQG1x5vy1g0zPoKJtJG7mFv2ZRME3ZLnqGYbdj4s7U
	kGZetB4XpfQzvRysLymd8PjC4L2RJjWxElAZoiouWkasJyxP0v1cCCPgHb3/dv+dWjZOZsRjAXt
	SxDuSP0jSjDWVY83zgTS569W2yFPsTtt4SUP/6VrA6ggAwQB0CwxJ7kwntP0N6YPyR1QGP2QegU
	2V1OE/qCDWunEl/bSRL7ZOYn6R9ZUke+eqvfBmG2gRpJIzV8EdMGmDyisWMTLqBFFpNTM/F/OcY
	IhyS9cncid3UHDGGxUWkmLHi3lI/Zowsg4BuyRVNnbv4DCNFHQkhQChDMsosrIheU7QVZNh+2Ia
	v7mwZ0kDk1BqX2aIQJF/ZKOc4jTSGMeskEDWdCiDY2uEaS+9/gpeASEpHhK1NmTFN0BQOLshXCy
	mtmzTQ8IYwyX8EEIXCCMO8+Q+cukT8l6C8MHZIsEeWy/hci9nSm+CFzXUOHFEBVfzymbB8EVBhy
	lJTvCTDh0KifyUBzQBIqeOA738JxAGpxUoUPBG5YvaBJ/tbMpMAGQwG+9RawTLtVznio8S2fMM=
X-Received: by 2002:a17:90b:54cb:b0:36b:de66:92c3 with SMTP id 98e67ed59e1d1-38d15361ac4mr11783247a91.10.1783894255555;
        Sun, 12 Jul 2026 15:10:55 -0700 (PDT)
Received: from prateek-Aspire-A515-57G.. ([182.77.75.84])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-311747f5975sm59257231eec.4.2026.07.12.15.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 15:10:54 -0700 (PDT)
From: Prateek <kprateek283@gmail.com>
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	Prateek <kprateek283@gmail.com>
Subject: [PATCH 1/2] src/queue: don't swallow -ETIME when SQEs were submitted
Date: Mon, 13 Jul 2026 03:40:49 +0530
Message-ID: <20260712221049.534729-1-kprateek283@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.dk,gmail.com];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13992-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[kprateek283@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:axboe@kernel.dk,m:kprateek283@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kprateek283@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 7242D7461C1

If _io_uring_get_cqe() submits SQEs and then times out waiting for
completions, it returns the submit count instead of -ETIME:

  1. The first enter submits the SQEs; because submit > 0 the kernel
     returns the submit count, not -ETIME, and it is stored in err.
  2. On the next iteration the has_ts shortcut wants to report -ETIME,
     but the 'if (!err)' guard sees the non-zero submit count and keeps
     it, so -ETIME is dropped.

That contradicts io_uring_submit_and_wait_timeout(3) and
io_uring_wait_cqes(3), which document -ETIME on timeout.

At these two sites (lines 113 and 118) err is only ever 0 or a positive
submit count. A negative error from __io_uring_peek_cqe() or a prior
enter breaks out of the loop before reaching here. So the change is
functionally equivalent to dropping the err condition entirely; we change
'!err' to 'err >= 0' so -ETIME is successfully synthesized whenever no
CQE was seen.

The guards were added in 2f61e849 ("src/queue: don't wait twice if
looping in _io_uring_get_cqe()") to carry the submit count across
iterations for the partial-completion case (got some CQEs, no error);
that case still returns the count because both sites remain guarded by
!cqe.

Signed-off-by: Prateek <kprateek283@gmail.com>
---
 src/queue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/queue.c b/src/queue.c
index fcd3c702..e2e5a061 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -110,12 +110,12 @@ static int _io_uring_get_cqe(struct io_uring *ring,
 			 * timeout, so treat any timeout the same as -ETIME here.
 			 */
 			if (data->get_flags & IORING_ENTER_EXT_ARG_REG) {
-				if (!cqe && !err)
+				if (!cqe && err >= 0)
 					err = -ETIME;
 			} else {
 				struct io_uring_getevents_arg *arg = data->arg;
 
-				if (!cqe && arg->ts && !err)
+				if (!cqe && arg->ts && err >= 0)
 					err = -ETIME;
 			}
 			break;
-- 
2.43.0



Return-Path: <io-uring+bounces-13571-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OFv5GFFjG2o2BwkAu9opvQ
	(envelope-from <io-uring+bounces-13571-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 31 May 2026 00:23:13 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 7222F613A3F
	for <lists+io-uring@lfdr.de>; Sun, 31 May 2026 00:23:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B85593021D1B
	for <lists+io-uring@lfdr.de>; Sat, 30 May 2026 22:20:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 614F83793B6;
	Sat, 30 May 2026 22:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PpJSh87t"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E12737BE9C
	for <io-uring@vger.kernel.org>; Sat, 30 May 2026 22:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780179612; cv=none; b=OQWa2e8fGN1nxSEVhx062A7urunpfyBmttS7S6/S59jPwTs7xYvl1BZi230NT9hidKswFBQx77insjC1sl9uN6ySqCP1xCQR/FFwKNxsL5BEttZNkAnNmpL0w4JvnITn3eou712sTHbY85cyprileSmMIbTA5xLZVE1Rj/wBzfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780179612; c=relaxed/simple;
	bh=KUklTCUYJp1BJPLfkblwKXuxVsFK8XGxI5dwHrsx8X0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPj98q7wvFMta48x9FDrYpENshv6rqBrf6dbQVBrnvR6Vwdy1firRmx9kK8GYPAH+5lN7drJuc91CXe58zkvKzk/dcTR4/VC50awYZ95QcFKkfRRUfMPAPa6emgCpNDpKZLtIj9su/Pr+30QJfr4/GzFUvMjBZA9V9o5PjC2v80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PpJSh87t; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-45ef616daf6so1402648f8f.3
        for <io-uring@vger.kernel.org>; Sat, 30 May 2026 15:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780179609; x=1780784409; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZDT9fVob8Oysx5eRe3qdB0UmTNnWot9MWKxTp6EWmjg=;
        b=PpJSh87t8gD1KAmrvyf9Je9zYE7HS5sM15KI5x9ORgYWPFgrvseDBL7HRX/b5jWRXA
         KljLLiUJbFsSYx/DNOTb+StCpAHGDvo4VR1BiicXJJCtMf+IVrIj8QOZoarquit+ENfa
         J4bvUrBCLVhzGrv8BxwdHwW50fEp5cIUedlAMmL/VX5q5ZTN7wqTKZY7tU+lLTmV1OfC
         mX2DEZp7Jj9cJP6Pbf0A/KrbYFuGAZAV+c5M5WHiiZV+2vXYSnibqubhKm1HY47YGp4M
         7gHlUlnh023gxekMnoGetvL5bp5riIuWR58VwK+MREPqibB/kniNzgUhXVD/90zA+65u
         XgFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780179609; x=1780784409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZDT9fVob8Oysx5eRe3qdB0UmTNnWot9MWKxTp6EWmjg=;
        b=lMcNQrqp5fEj0P6zQGGk7ZVU1h+cbSMOlB5hG8PJU1wdskpStZWn51Km3OUEAYjzPO
         aUub+zHJx3nXQ2p4r0f7w8nxBoGcMn/DiqjeVbn2LqtL3m1WZarkA67aGEtPkd/f7aRq
         uFCkJM8DlpBm8odLfbWWHYcf4T5nQN7Eecgalj7qjY74/qTCUAJIprQPj647erjWaPLb
         ahk1gfN2MgiWRbSu3WPck/3eRouT/mhc8MR+F8xK51y3Grd6T3WBeYnbH8/TKlkyZUZL
         nrajZluSusmX+uP4lZ7QizYFKGoJsdUyirxDD/6e8bEH0eCJrwWgWEtVSGy+rgYwwewA
         McTg==
X-Forwarded-Encrypted: i=1; AFNElJ9AEe+LPLjvVKfIdPoFJVDHGjbgyKx1chfcSD8BOs5dT6UGydNYcszncLuw1ncVpCuGpoxFbLf0xg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzC4OXPm+ZGt43WQZHmzy6kdEDdzKijALA0I0pNabRhZSl+fSwr
	TW0MVcpkCZsMfle+MXle8pgfZDtD2fkOaAwBqegOA9D20IoQyVQM4E3b
X-Gm-Gg: Acq92OHrZlgTdww7pOF4UN4v5nOldh+kwBkWvRknCx+/HqId4Hn9y47xQR6MRPIAX67
	/0CcEKrKsFrnG20/PFUCXqsmErHirZjLDvAKdmq1dToT8A7KrjwyqxQSpkjNEs39kMYo0Tw7erj
	pgH827zRx/2IwV9ekX69NoYiLwTZyUzgMucvv9sK9rIIfPncrF/GhsGXt2PkTcN4NnQ1WfF8CZu
	EAmw7k6nt98NEfiSViGOD1UTddtaGjlPmYoIf9w9mkGPXdYmZa5vcj6lVybrKr15LRtgkJLcE2Q
	tsczsWYflawt8RIT6OrYxZSLCt7V4aDoeZT3/KrEaeyn65mriyqzmK74MRofq0Hb+i3pu6kuWEd
	ArbsTI35LoAP7dMaZZHYRBYTqvdjFeQK9RDwCB1SWOMX5xEiJ4aJJgppYEkGhUp9mz0tDImMT+j
	nHOc3QNC1Pigts7RrUjNjciCiEXSxtYZxRmbdA0eSNYnG/KG2NqoSu
X-Received: by 2002:adf:e510:0:b0:441:1e41:19c with SMTP id ffacd0b85a97d-45ef6b5a7femr6668438f8f.20.1780179608629;
        Sat, 30 May 2026 15:20:08 -0700 (PDT)
Received: from puck (234.243.199.146.dyn.plus.net. [146.199.243.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef354cd7csm13443784f8f.18.2026.05.30.15.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 15:20:07 -0700 (PDT)
From: Dylan Yudaken <dyudaken@gmail.com>
To: trondmy@kernel.org,
	anna@kernel.org,
	linux-nfs@vger.kernel.org
Cc: axboe@kernel.dk,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dylan Yudaken <dyudaken@gmail.com>
Subject: [PATCH 2/2] nfs: expose FMODE_NOWAIT for O_DIRECT read files
Date: Sat, 30 May 2026 23:19:47 +0100
Message-ID: <20260530221947.49518-3-dyudaken@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260530221947.49518-1-dyudaken@gmail.com>
References: <20260530221947.49518-1-dyudaken@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,vger.kernel.org,gmail.com];
	TAGGED_FROM(0.00)[bounces-13571-lists,io-uring=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dyudaken@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 7222F613A3F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

O_DIRECT reads already (mostly) handle async requests, with the
exception of locking the inode for direct.
Handle async requests properly by using nfs_start_io_direct_nowait,
and then expose FMODE_NOWAIT since it's now properly supported.

Signed-off-by: Dylan Yudaken <dyudaken@gmail.com>
---
 fs/nfs/direct.c |  5 ++++-
 fs/nfs/file.c   | 13 ++++++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 48d89716193a..bf0bad971d22 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -473,7 +473,10 @@ ssize_t nfs_file_direct_read(struct kiocb *iocb, struct iov_iter *iter,
 		dreq->flags = NFS_ODIRECT_SHOULD_DIRTY;
 
 	if (!swap) {
-		result = nfs_start_io_direct(inode);
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			result = nfs_start_io_direct_nowait(inode);
+		else
+			result = nfs_start_io_direct(inode);
 		if (result) {
 			/* release the reference that would usually be
 			 * consumed by nfs_direct_read_schedule_iovec()
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 25048a3c2364..c5eb22036e71 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -72,8 +72,13 @@ nfs_file_open(struct inode *inode, struct file *filp)
 		return res;
 
 	res = nfs_open(inode, filp);
-	if (res == 0)
+	if (res == 0) {
 		filp->f_mode |= FMODE_CAN_ODIRECT;
+		/* flag NOWAIT on read-only O_DIRECT files only */
+		if ((filp->f_flags & O_DIRECT) &&
+		    !(filp->f_mode & FMODE_WRITE))
+			filp->f_mode |= FMODE_NOWAIT;
+	}
 	return res;
 }
 
@@ -705,6 +710,12 @@ ssize_t nfs_file_write(struct kiocb *iocb, struct iov_iter *from)
 
 	trace_nfs_file_write(iocb, from);
 
+	/*
+	 * FMODE_NOWAIT is not set for writable files
+	 */
+	if (WARN_ON_ONCE(iocb->ki_flags & IOCB_NOWAIT))
+		return -EAGAIN;
+
 	result = nfs_key_timeout_notify(file, inode);
 	if (result)
 		return result;
-- 
2.50.1



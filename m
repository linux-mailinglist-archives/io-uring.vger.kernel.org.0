Return-Path: <io-uring+bounces-12778-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wK/ODGMov2mDxAMAu9opvQ
	(envelope-from <io-uring+bounces-12778-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2026 00:23:15 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B16BA2E7A35
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2026 00:23:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 845E53028816
	for <lists+io-uring@lfdr.de>; Sat, 21 Mar 2026 23:22:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1082B305047;
	Sat, 21 Mar 2026 23:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EYy1VqNI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B3230C34A
	for <io-uring@vger.kernel.org>; Sat, 21 Mar 2026 23:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774135357; cv=none; b=Xh/0IKyWX0ic1dGU+z3nJXN62q+SzUQPTPY3jmET1+Q4B9hx6YWsyYQ1AC0Ss2EBf6ER7JxUslJcSL/lL+i7vdvZm+/rSmX3Y0MDuoLBXaSlY2iq1mTEFjNfSg6kR5D23DOkW9SweR3R+oAwwm+w1694NczTFz/wt5vDFiPm67Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774135357; c=relaxed/simple;
	bh=2A7HAwFCyO84F13+VNf41l4t3XJGRxOx8ZgxsW5FLNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=idtRPTekZeJZr1q8GokQgR6osdz1UQFYwsTBlrGZNmw9xzZnFsax5lUyCJiqfp+j/5hbDD9AOTlMQPSEGlBMJmN6xbcFTXEcVZEMxVXB3XXxzMg6qUfRzPd+tynd8wwbEk9VeVEol3NlxLn7vxLC2807Ps1WbrSstsuB6DWoAr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EYy1VqNI; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-439c6fc2910so2172114f8f.0
        for <io-uring@vger.kernel.org>; Sat, 21 Mar 2026 16:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774135355; x=1774740155; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fk94Sdj/ITRyjAWZq3WAiEMd1s7mDg5eakazuQCLZCI=;
        b=EYy1VqNILsvBCqXqq/jw4w8ZFsZtMR/JwPMzcj0SkjUATtmaDVfJskoprXuxQn9wJ7
         l/YGB3i3+ilhUwFOnmDX/2RmhvxGD6GvyhNbXR6eMIrajdXSXZ23lRn8x0qd0ICA68f9
         jLZnYjpZ+zqJ4107UVasZi40VVEehekbQkJCwIw4QmovBSFVGV8BjvMV8K0sCs1NKzaX
         8zKjZMgqRH+5g0bRuERgXTzg7C1c3PIreuf0tA7cvqS1fDj8A0vHgy6UpsOa60zrrJ/S
         A4B5Z6lmfvVlOgsZWh/8l9D8+tSgR8n7yShCXrXjIU//eLP3OOuhtiuR9If7Wyk7OQRt
         m3NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774135355; x=1774740155;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Fk94Sdj/ITRyjAWZq3WAiEMd1s7mDg5eakazuQCLZCI=;
        b=C5Fc15kwZ5TtunP/93MlgCGJz5QhdfO0C1ZyBxAjTERrWl5IltTgZ6M1KvXkWzqGa+
         RT0ZtXwvoeUHIcbkXXidOauZVhFvmORnqhg1bCgcipL8T3sbW8kVBtzkeEYoXsc1KpfG
         ettfu0YgrRwwolNb8fMnC7ltRC5Fa9M+oc1VBZX2EzH+PxOfijH8zsuyXsxseXNejg/b
         PxtRv7ho3b/JwXdB56XzhO2dD76oDnV4id7/if6mHiUKxWCuRBul7bXW/vJE11m6qwGb
         ptDSLOBFssJ0DPkr+bOL8dfvlYz45Gy3AAQyRIUilVGNXzMN9fFQh6Ex7B2LaILN3R9q
         2p1g==
X-Gm-Message-State: AOJu0Yz4GJOLlHS79rvmxF+7KkdpZiR+3/ZfyX4jiI230y+TJT50Xbw2
	v/GpAUwg0iq4FDvqd3PWIpUtxrJRaWws59gKV2OU2HqzPN9v22+kBbwe+xsG2kyRzog=
X-Gm-Gg: ATEYQzx5gEKOhoIIvBDfsOIMO0EfxhPmEwun91hDOEA76OkFGGNgrAFbjqd4a7GVx9G
	Y/I556l33hPoJ3HYrP75wMDm2kZgtIDH3Gy8FAhVa/p0JW/PFhA8EK7Y/8RgdmhETZamL1Y/tcs
	fIDcoF0NFtCvLpVOhsYl4TNHrJ0vW9bkpM0bdRdB8bnjjyvt4LrNm9OxDlxx5lb+pF2q80S9KWn
	Ne8vFkwOQnod6tBrvZlyKpLPgMuIrU04izwVVCPZW3/09K7+cJwdEjg81z/9yQk6Ljs1B2ZFQNl
	miJNP7GfqVt5HQQobBrdQiZ6L0vd2mtvuuyP5TWXtcG6yqF6t9/FaD1KtX28ZdlhXn1KFoBWDQ8
	BYTItMD/2088bF5ZGWvmFmwdRNkrWcklT0oRxSF8BGP139XISiav8v1Xp7uoLHxOWhjpXxg8y1K
	1LB8WPVQS7a3xrHo40g4rbDtLtSzwQemcbtsAeUsqN6GYTHDl5qichgUi+PZJSuJPvtGcUbQ==
X-Received: by 2002:a05:6000:2383:b0:43b:445f:3177 with SMTP id ffacd0b85a97d-43b6427db29mr12416953f8f.31.1774135354500;
        Sat, 21 Mar 2026 16:22:34 -0700 (PDT)
Received: from ddp-thinkpad.tail20b0d.ts.net ([95.141.20.197])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b6425eeb4sm15609897f8f.0.2026.03.21.16.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 16:22:33 -0700 (PDT)
From: Daniele Di Proietto <daniele.di.proietto@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Daniele Di Proietto <daniele.di.proietto@gmail.com>
Subject: [PATCH v3 2/4] fs: Export expand_files()
Date: Sat, 21 Mar 2026 23:21:40 +0000
Message-ID: <20260321232142.911280-3-daniele.di.proietto@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260321232142.911280-1-daniele.di.proietto@gmail.com>
References: <20260321232142.911280-1-daniele.di.proietto@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12778-lists,io-uring=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.dk,kernel.org,gmail.com,vger.kernel.org,zeniv.linux.org.uk,suse.cz];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[danielediproietto@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B16BA2E7A35
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

It's going to be used in a future commit.

Signed-off-by: Daniele Di Proietto <daniele.di.proietto@gmail.com>
---
 fs/file.c     | 5 ++---
 fs/internal.h | 2 ++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 384c83ce768d..573ab3b5191e 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -285,9 +285,8 @@ static int expand_fdtable(struct files_struct *files, unsigned int nr)
  * Return <0 error code on error; 0 on success.
  * The files->file_lock should be held on entry, and will be held on exit.
  */
-static int expand_files(struct files_struct *files, unsigned int nr)
-	__releases(files->file_lock)
-	__acquires(files->file_lock)
+int expand_files(struct files_struct *files, unsigned int nr)
+	__releases(files->file_lock) __acquires(files->file_lock)
 {
 	struct fdtable *fdt;
 	int error;
diff --git a/fs/internal.h b/fs/internal.h
index cbc384a1aa09..3a26252dcdae 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -197,6 +197,8 @@ extern struct file *do_file_open_root(const struct path *,
 extern struct open_how build_open_how(int flags, umode_t mode);
 extern int build_open_flags(const struct open_how *how, struct open_flags *op);
 struct file *file_close_fd_locked(struct files_struct *files, unsigned fd);
+int expand_files(struct files_struct *files, unsigned int nr)
+	__releases(files->file_lock) __acquires(files->file_lock);
 
 int do_ftruncate(struct file *file, loff_t length, int small);
 int do_sys_ftruncate(unsigned int fd, loff_t length, int small);
-- 
2.43.0



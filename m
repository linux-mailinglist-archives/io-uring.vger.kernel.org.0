Return-Path: <io-uring+bounces-8008-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEF2DABA32A
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 20:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 941133B8F71
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 18:50:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03A0327E7E3;
	Fri, 16 May 2025 18:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CwGWfuEL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B4F215077
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 18:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747421420; cv=none; b=COPHIjfeoGFDpZdML9M8aXQ87LjEOlLkRw77wFbEwlfwBHvZ2T9KtGVbhp4ygQUd27aC5HMMR+6KW2/QHaUt5MZSunCKE8fccp4LscbXV+NlrYUxw4FH1i0rIUx+8cdS3y11mnw7TQ2lvq92GDFkr9TL9C7G9IbhcuAPznSfNVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747421420; c=relaxed/simple;
	bh=R02xVXicO57rIkeReieWqRWQsJD8OfwxVmcKUeQoq2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJDHlIKyfN1x9nV7+ZOTdzrr/DLWBs0Wlj+7CPb9S7GAo3WiB7313gJa5YO8XxGsVXAe1bOytVloTRtn9KaUx9Vxu8TTD1/BLCNBhUSWMhTIKNwpkaKQ0Y56/1iKOnOSHxPsP+Tqxl9d4Z633QLIo2xurTdrJruQy4bJ1hYWdgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CwGWfuEL; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-85dac9729c3so231133739f.2
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 11:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747421417; x=1748026217; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+uA8FnfUBNgNlnelscDNIZC2VCWBUy3e+NIR3IpZsCk=;
        b=CwGWfuEL3+xSTVpNY5gQ7OO0FqRgMzXEBz0zrPwMVfUo44fipyVqbnDmBQS97JAZR9
         naKAncyU9kbSZAef91tARXaalblS5mSPfO4O2id/TIWIikz0hNF52CBH3gIIpHsRKDOM
         NBJTwhfL2ZCB69W9Jpf3R8CI006p/yynJBI+BU1B5K0U4GExNOMdpaTEmtj5Bj0Pl7J/
         BQFhfXhRvlktqg5NLW3I7eraeB1vW9tZDS8FasJ/Uw61zvYfAA+99W80/Cny4GZPlip4
         7knr4VJJBq8rZpUgi99Ez9X39SgzREn/cW/Akd2+HDK+5Akq31IXrUPKtMeqUDxf8Qfy
         iYXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747421417; x=1748026217;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+uA8FnfUBNgNlnelscDNIZC2VCWBUy3e+NIR3IpZsCk=;
        b=Rof60ZbaD4kMvuICSLixLqqpskbz7+/AdgXSpzqpeTXd/4x9F0eHIKNEOk0+Y/jnbF
         Anu/7torGqcRu+tQ9SQGMiMA65g5n4/pek4IRiZG9nTJPwSj0Z6O2iJfFFlNZ0ZIiCKW
         N46ld5mexzjIVCStmdbZL5lSU5Z3/TzIZtBjqRMbCSH6UUqjAIF9+p7FdLzobSgidkKh
         CA5IVi0gLR6vJt7i6+dxBH5jsjmNS8DL6kaXKWR78Sj6G0u+uPeYXBt1Ak+fdL6PzzJC
         CawvU10PKG7HOIoN5C03cULbE+ECdT+PzKlCk3UQ+sYyrSihxR9xDL3O8SDWkZk2wAzx
         bhnA==
X-Gm-Message-State: AOJu0YzsRnSjoaaKpuYZj2L5hQ3YwOBdKWRBOXp+BQ/Ud2SpjuqCaAFu
	RPFx++ALTtb6E700BksUUv770O97UkeqTwzTBJjwoTCmUz3l5O1dXKNIZtqpmOMW9e1seW9Vxp4
	52yQB
X-Gm-Gg: ASbGncs495jY98iSRyuuldc8wregP+ckLjX2afBIwQw70JWujsTkbc9184Nv5bb9tFz
	8C7PgxbvLPx+wIhPo4Z/hUHm/TUB0AsHXtjyd6cKKyf0qWdlQ95f79cUoSVi77bbi9BASl/Js8x
	mUuh53t+rH3wH+UcpVCwJII9G1oEJhgzhWmpF58/n+/PSKjQ9Y6p211b15pkGLVUKy4VmGV46Vg
	aKyFYf6wh2YXGoG3H6yl3jLqGE8KU+ZYfXNGwMPBwX0bx1jUFpL1knEERplv4Rhwwsp0lXfeNcE
	CpNw4TeF9VjTCADK3mOkcjlYa3XfBQc2Mqe2dcbakirdt1GYR7TeGcOr
X-Google-Smtp-Source: AGHT+IF3iHsiFIRJnO5fzY1gVsnyr1MHx2D7HqfecYm4lDTLvyK7rbWPQ97ADBce0FQlc0+3KP9sOQ==
X-Received: by 2002:a05:6e02:1544:b0:3d9:6d52:5483 with SMTP id e9e14a558f8ab-3db842de15amr52434805ab.11.1747421416901;
        Fri, 16 May 2025 11:50:16 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3db8443ae8dsm6162115ab.49.2025.05.16.11.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 11:50:15 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring/fdinfo: get rid of dumping credentials
Date: Fri, 16 May 2025 12:48:47 -0600
Message-ID: <20250516185010.443874-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250516185010.443874-1-axboe@kernel.dk>
References: <20250516185010.443874-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's a faily obscure feature, and registered credentials would for that
mostly be a static thing. Don't bother including code to dump the
personalities indices.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/fdinfo.c | 38 --------------------------------------
 1 file changed, 38 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index b83296eee5f8..e9355276ab5d 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -15,36 +15,6 @@
 #include "cancel.h"
 #include "rsrc.h"
 
-static __cold int io_uring_show_cred(struct seq_file *m, unsigned int id,
-		const struct cred *cred)
-{
-	struct user_namespace *uns = seq_user_ns(m);
-	struct group_info *gi;
-	kernel_cap_t cap;
-	int g;
-
-	seq_printf(m, "%5d\n", id);
-	seq_put_decimal_ull(m, "\tUid:\t", from_kuid_munged(uns, cred->uid));
-	seq_put_decimal_ull(m, "\t\t", from_kuid_munged(uns, cred->euid));
-	seq_put_decimal_ull(m, "\t\t", from_kuid_munged(uns, cred->suid));
-	seq_put_decimal_ull(m, "\t\t", from_kuid_munged(uns, cred->fsuid));
-	seq_put_decimal_ull(m, "\n\tGid:\t", from_kgid_munged(uns, cred->gid));
-	seq_put_decimal_ull(m, "\t\t", from_kgid_munged(uns, cred->egid));
-	seq_put_decimal_ull(m, "\t\t", from_kgid_munged(uns, cred->sgid));
-	seq_put_decimal_ull(m, "\t\t", from_kgid_munged(uns, cred->fsgid));
-	seq_puts(m, "\n\tGroups:\t");
-	gi = cred->group_info;
-	for (g = 0; g < gi->ngroups; g++) {
-		seq_put_decimal_ull(m, g ? " " : "",
-					from_kgid_munged(uns, gi->gid[g]));
-	}
-	seq_puts(m, "\n\tCapEff:\t");
-	cap = cred->cap_effective;
-	seq_put_hex_ll(m, NULL, cap.val, 16);
-	seq_putc(m, '\n');
-	return 0;
-}
-
 #ifdef CONFIG_NET_RX_BUSY_POLL
 static __cold void common_tracking_show_fdinfo(struct io_ring_ctx *ctx,
 					       struct seq_file *m,
@@ -213,14 +183,6 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 		else
 			seq_printf(m, "%5u: <none>\n", i);
 	}
-	if (!xa_empty(&ctx->personalities)) {
-		unsigned long index;
-		const struct cred *cred;
-
-		seq_printf(m, "Personalities:\n");
-		xa_for_each(&ctx->personalities, index, cred)
-			io_uring_show_cred(m, index, cred);
-	}
 
 	seq_puts(m, "PollList:\n");
 	for (i = 0; i < (1U << ctx->cancel_table.hash_bits); i++) {
-- 
2.49.0



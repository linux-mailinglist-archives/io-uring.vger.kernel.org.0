Return-Path: <io-uring+bounces-887-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D60C8878553
	for <lists+io-uring@lfdr.de>; Mon, 11 Mar 2024 17:27:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1A067B2172C
	for <lists+io-uring@lfdr.de>; Mon, 11 Mar 2024 16:27:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D0EB55C13;
	Mon, 11 Mar 2024 16:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PoCYwnlK"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544954D9E4;
	Mon, 11 Mar 2024 16:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710174038; cv=none; b=SDBI0N0o/e2ahf1lZjQH+2nZMG9UNeIltp/n7OWCWbWNjxB6XiNp6WD/aQABmLdnqj38wf3C9QmjJGf8kHq8bbCxzjiZS6GWtfCDuz1VVdCBHZumDDFo+/YTb2W/CAvAvTbAo7YVJhPhij++qMabVtSzcWkvqy4n0FPhCiNy80s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710174038; c=relaxed/simple;
	bh=pD+JXNYfVc2XwYZgA8tF77QEryy7OGA3MWHG9Y3kxYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kbj4d7HtiJnE9xjHOWUIMxLamqDaS7JdwSall/PlHBvxO0o9rSWxjLJl4sHqUd0u2awt6EdMPMUW8m/8l/3CtDwOOUEdvL6imWbRrCuWiEhomecemftroTVBuzhgxJVMMQJ/DrTDDPZly+SL5SMLMjCTOmToi8gUtIuOlArqt0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PoCYwnlK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8426DC43399;
	Mon, 11 Mar 2024 16:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710174037;
	bh=pD+JXNYfVc2XwYZgA8tF77QEryy7OGA3MWHG9Y3kxYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PoCYwnlKlfnRZ1t10cA5IvTFslv/ZTFdV6Ey9lEx32jy04ZnyTolJJn3//cWQq10O
	 e9hc8Aw2j2sGaVfFuNdCCOm2z2lHUCHZCXIka0IhLYAMu702/5RnSBRehfmEuHFUyv
	 GP3CgbkvFXsZAJVM8q5dQ2OjkJenI3VIrIzqDbNLwmlYUpQiH5ac/SBX8eq3ifvcgf
	 Z2tXVyHPGSaeXWLHcMWu0JzLPj3vjbvwRy71KXwLsiRio7kboGUuMYygVY/TbtBowR
	 wopmFNof3Zvsl9ahdj1phNGHZbJrhbeqLkv9NYiPwF3pt7/9SB0QKpUtUF4jERS9lF
	 soMGrfotz7i5Q==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: io-uring@vger.kernel.org
Subject: [PATCH v2 2/3] fsstress: bypass io_uring testing if io_uring_queue_init returns EPERM
Date: Tue, 12 Mar 2024 00:20:28 +0800
Message-ID: <20240311162029.1102849-3-zlang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240311162029.1102849-1-zlang@kernel.org>
References: <20240311162029.1102849-1-zlang@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I found the io_uring testing still fails as:
  io_uring_queue_init failed
even if kernel supports io_uring feature.

That because of the /proc/sys/kernel/io_uring_disabled isn't 0.

Different value means:
  0 All processes can create io_uring instances as normal.
  1 io_uring creation is disabled (io_uring_setup() will fail with
    -EPERM) for unprivileged processes not in the io_uring_group
    group. Existing io_uring instances can still be used.  See the
    documentation for io_uring_group for more information.
  2 io_uring creation is disabled for all processes. io_uring_setup()
    always fails with -EPERM. Existing io_uring instances can still
    be used.

So besides the CONFIG_IO_URING kernel config, there's another switch
can on or off the io_uring supporting. And the "2" or "1" might be
the default on some systems.

On this situation the io_uring_queue_init returns -EPERM, so I change
the fsstress to ignore io_uring testing if io_uring_queue_init returns
-ENOSYS or -EPERM. And print different verbose message for debug.

Signed-off-by: Zorro Lang <zlang@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
---
 ltp/fsstress.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 4fc50efb..9d2631f7 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -762,7 +762,12 @@ int main(int argc, char **argv)
 #endif
 #ifdef URING
 			have_io_uring = true;
-			/* If ENOSYS, just ignore uring, other errors are fatal. */
+			/*
+			 * If ENOSYS, just ignore uring, due to kernel doesn't support it.
+			 * If EPERM, maybe due to sysctl kernel.io_uring_disabled isn't 0,
+			 *           or some selinux policies, etc.
+			 * Other errors are fatal.
+			 */
 			c = io_uring_queue_init(URING_ENTRIES, &ring, 0);
 			switch(c){
 			case 0:
@@ -770,9 +775,16 @@ int main(int argc, char **argv)
 				break;
 			case -ENOSYS:
 				have_io_uring = false;
+				if (verbose)
+					printf("io_uring isn't supported by kernel\n");
+				break;
+			case -EPERM:
+				have_io_uring = false;
+				if (verbose)
+					printf("io_uring isn't allowed, check io_uring_disabled sysctl or selinux policy\n");
 				break;
 			default:
-				fprintf(stderr, "io_uring_queue_init failed\n");
+				fprintf(stderr, "io_uring_queue_init failed, errno=%d\n", -c);
 				exit(1);
 			}
 #endif
-- 
2.43.0



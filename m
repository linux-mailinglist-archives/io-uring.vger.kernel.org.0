Return-Path: <io-uring+bounces-886-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E7CF878551
	for <lists+io-uring@lfdr.de>; Mon, 11 Mar 2024 17:27:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02EB71F2395D
	for <lists+io-uring@lfdr.de>; Mon, 11 Mar 2024 16:27:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AA8E51C50;
	Mon, 11 Mar 2024 16:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SQoZrvOi"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613454D9E4;
	Mon, 11 Mar 2024 16:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710174036; cv=none; b=fNeZuJox0Qaxmk408UCrOgz+jSu0vqfr69O5TMlPpHbOX1VPOlsYA7GO9PnNR4q8IhH6vvaRCsXLju+loKLXnV05cK+kisa6L24jG5zPSzRJM0tDJRpqAxfH8absM/mcC22BW4yARBeWBZXUHMHT1EQekt8A7BiGR6dd5k55FHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710174036; c=relaxed/simple;
	bh=wTf71Ms5kA2VbK3Ba4HKR/5dJ1JQif9cQASBJtfB/Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gz08rSuXRuU0tzI8Nav9u3x8rYbEcAlIDNdU/2lVwPyfNayZ5iC7+KEwGDtxUEAy+uRKxKnE71IXTNXnqpSdik2UvbBq135NvO+i9oY1EsJ/zrSyHhnL0f9NXMzeUErklmgktJLEfqh4KNdKY5bBmoCcnOlYgoweP2EpFjpDo2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SQoZrvOi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9908C43390;
	Mon, 11 Mar 2024 16:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710174036;
	bh=wTf71Ms5kA2VbK3Ba4HKR/5dJ1JQif9cQASBJtfB/Bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQoZrvOivWf5ZSF9/zGSoG3Xi4gq17S7w0ENLwKYFk6aTnSA6EKZctPbR5ffp7Q/l
	 ucshRSmpEDqQ0oyBTtmB6mC4yM9AnzNh8/OwsLXn93jWUfwbf1x0M51UmMN4zA2M8I
	 DoG8Y/tFOdHLwpEFCIInOwooAeYL0PQ8fWJldrjM1Zo9OtiS/BStecyN1vMvmhypHE
	 fsNhY/H3M3BkU0JZVLdHc6gBqZs30CgDfEzb3uV0nkFock3vZT+mN7s+rPYqmNkqag
	 Q7o4PyGBt2wVQB37MeNWJuquWdJTZ8Bof5e2bOZXApDizE7nxWJqm8+ucANluEjfXk
	 WJiUetmQ0qByw==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: io-uring@vger.kernel.org
Subject: [PATCH v2 1/3] fsstress: check io_uring_queue_init errno properly
Date: Tue, 12 Mar 2024 00:20:27 +0800
Message-ID: <20240311162029.1102849-2-zlang@kernel.org>
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

As the manual of io_uring_queue_init says "io_uring_queue_init(3)
returns 0 on success and -errno on failure". We should check if the
return value is -ENOSYS, not the errno.

Fixes: d15b1721f284 ("ltp/fsstress: don't fail on io_uring ENOSYS")
Signed-off-by: Zorro Lang <zlang@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
---
 ltp/fsstress.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 63c75767..4fc50efb 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -763,13 +763,17 @@ int main(int argc, char **argv)
 #ifdef URING
 			have_io_uring = true;
 			/* If ENOSYS, just ignore uring, other errors are fatal. */
-			if (io_uring_queue_init(URING_ENTRIES, &ring, 0)) {
-				if (errno == ENOSYS) {
-					have_io_uring = false;
-				} else {
-					fprintf(stderr, "io_uring_queue_init failed\n");
-					exit(1);
-				}
+			c = io_uring_queue_init(URING_ENTRIES, &ring, 0);
+			switch(c){
+			case 0:
+				have_io_uring = true;
+				break;
+			case -ENOSYS:
+				have_io_uring = false;
+				break;
+			default:
+				fprintf(stderr, "io_uring_queue_init failed\n");
+				exit(1);
 			}
 #endif
 			for (i = 0; keep_looping(i, loops); i++)
-- 
2.43.0



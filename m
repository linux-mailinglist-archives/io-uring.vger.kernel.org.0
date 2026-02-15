Return-Path: <io-uring+bounces-12210-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id FVK8NYENkmktqAEAu9opvQ
	(envelope-from <io-uring+bounces-12210-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 19:16:33 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 091B313F57E
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 19:16:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DFA35300D329
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 18:16:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 324202E62B3;
	Sun, 15 Feb 2026 18:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="mXKC4o44"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A9F17BED0
	for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 18:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771179390; cv=none; b=WBuV/4NmKedd9X307rUOcIpHPqILOuhFDamRS972c0fYpeeriNycacyaicvyMht3vAaC9u3UZN/8ZIt7DuMsmKFiBq+BT70Y/6zRXYH7Y6LFUxUVYSgBpJIet2VxBLcf1lsn7+u87eHAn5BCpk6P1NzRNKBtu50xeIoAgTD8ofU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771179390; c=relaxed/simple;
	bh=9sAqF9vdzNzZyOBhiNOfPqw/5F4dkBDVFKTr0FIdvxc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FuxbV4DIIMSPjA5xPJcOuzKdNv5z3sa3Y2ztb12enb+/wjVFQIFdE+WtYgL0qPQY7lrtbfD7ca4ra9iGJbRgoKMlgRs8bvauItetzozcrcWF+dmnEzua4ocrYPJeOiOg1kg3p6conJHJ5XJ0ExGZgO9panZOpI4u70RrZJf41Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=mXKC4o44; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=new2025; t=1771179381;
	bh=9sAqF9vdzNzZyOBhiNOfPqw/5F4dkBDVFKTr0FIdvxc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:
	 Content-Transfer-Encoding:Message-ID:Date:From:Reply-To:Subject:To:
	 Cc:In-Reply-To:References:Resent-Date:Resent-From:Resent-To:
	 Resent-Cc:User-Agent:Content-Type:Content-Transfer-Encoding;
	b=mXKC4o44nFjwz6ReYxtRV6s3TogJ0fI4Q48iV2zXcHIo8+m2CPi+bzwFmH6nDun0L
	 7P7GaQCYKj5yTJsEtW/iPDSLpd94PmHODZ/0nrva44KZIJwVYDOUZZ0SSA1lqBG1/u
	 AH8FblTf2THEID3l/XcrKyRQJqB8dFE8yjboJQmRnP52vNB1e/WIO8dlTHw7xsWTfh
	 sL82hI9AGkXwmCAvg3bWlxZnzA5yFB1ZXcJSXHxeWLHMaP4dXbtEn/XKBUuJPLnTq6
	 /5KLGqz/bbctIwKRowU2yt1R9tHAc40LpHQ6j77yVXvKLNiAQMZzPCC3/67DyWhYoM
	 u2li2H5Y0G8uw==
Received: from localhost.localdomain (unknown [36.50.142.76])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id EE8DD3204B4D;
	Sun, 15 Feb 2026 18:16:19 +0000 (UTC)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Christian Mazakas <christian.mazakas@gmail.com>
Subject: [PATCH liburing] github: Upgrade clang version to 22
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Mon, 16 Feb 2026 01:16:12 +0700
Message-Id: <20260215181612.1941963-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gnuweeb.org,reject];
	R_DKIM_ALLOW(-0.20)[gnuweeb.org:s=new2025];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12210-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_CC(0.00)[gnuweeb.org,vger.kernel.org,vger.gnuweeb.org,gmail.com];
	DKIM_TRACE(0.00)[gnuweeb.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ammarfaizi2@gnuweeb.org,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 091B313F57E
X-Rspamd-Action: no action

Commit 5cb44fe56b58 ("workflows/build.yml: install default ubuntu-24.04
clang") downgraded the CI to the Ubuntu 24.04 default Clang (v18). As
noted by @cmazakas, it was because it broke bindgen.

@cmazakas recently confirmed that Clang 22 does not suffer from this
bindgen incompatibility. Therefore, upgrade the environment to Clang 22
to gain access to the latest static analysis tooling.

Acked-by: Christian Mazakas <christian.mazakas@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 .github/workflows/ci.yml | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index 8f008b94eeaa..83669e131d2d 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -196,8 +196,15 @@ jobs:
 
       - name: Install Compilers
         run: |
-          sudo apt-get update -y;
-          sudo apt-get install -y ${{matrix.build_args.cc_pkg}} ${{matrix.build_args.cxx_pkg}};
+          if [[ "${{matrix.cc_pkg}}" == "clang" ]]; then \
+            wget https://apt.llvm.org/llvm.sh -O /tmp/llvm.sh; \
+            sudo bash /tmp/llvm.sh 22; \
+            sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-22 400; \
+            sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-22 400; \
+          else \
+            sudo apt-get update -y; \
+            sudo apt-get install -y ${{matrix.build_args.cc_pkg}} ${{matrix.build_args.cxx_pkg}}; \
+          fi;
 
       - name: Display compiler versions
         run: |

base-commit: 364a7b561fa13cffdd7771978dc5509ec4d9d7f9
-- 
Ammar Faizi



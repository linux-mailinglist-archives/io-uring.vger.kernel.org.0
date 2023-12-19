Return-Path: <io-uring+bounces-292-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 67AAA8186DA
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 13:01:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 792051C23B21
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 12:01:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA7F418E23;
	Tue, 19 Dec 2023 12:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="Nd6+sqEw"
X-Original-To: io-uring@vger.kernel.org
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528F518E09;
	Tue, 19 Dec 2023 12:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1702986880;
	bh=UYvkrqqBptkLhObzzTRNA92l4+e8xpKFEIQytDOoSf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nd6+sqEwoXp9fQVj+RhVs4s0o+fOr+NIsl6T6rapLQOS8ojLirAKXetrYb1V+5Qxa
	 QFWLda6BA+Wlcxxb59cfCNzNXGDrogaEc2ZLXXxuVdG1mdbQALlvLytb7KduhAQPI+
	 BerSYU5rZKT9dkL8F1fAIZFHFXomhNAwutsUxkEXL3sRUc0WD5kcRN3+Utf7F8H9pe
	 JvlHGTj1hcMQopKUH/Af3/l3RDgMw/9T8BfbuSQNkIetULBRLF3h+UyXS1I3Y6RmiE
	 582h8MejxfWH7GGOqmo0iBOI/VnQsWQ2tEV+RGkLZtUNEjDZE1/Q/bJbNJJzjFP/o9
	 dZ8LAmZTb8hzQ==
Received: from localhost.localdomain (unknown [182.253.230.19])
	by gnuweeb.org (Postfix) with ESMTPSA id B013524C191;
	Tue, 19 Dec 2023 18:54:37 +0700 (WIB)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	Michael William Jonathan <moe@gnuweeb.org>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Stefan Metzmacher <metze@samba.org>
Subject: [PATCH liburing v1 1/2] Makefile: Remove the `partcheck` target
Date: Tue, 19 Dec 2023 18:54:22 +0700
Message-Id: <20231219115423.222134-2-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231219115423.222134-1-ammarfaizi2@gnuweeb.org>
References: <20231219115423.222134-1-ammarfaizi2@gnuweeb.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the `partcheck` target because it has remained unused for nearly
four years, and the associated TODO comment has not been actioned since
its introduction in commit:

  b57dbc2d308a849 ("configure/Makefile: introduce libdevdir defaults to $(libdir)")

Cc: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 Makefile | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/Makefile b/Makefile
index 73d021c2e46255bf..7326e644e3a18bdb 100644
--- a/Makefile
+++ b/Makefile
@@ -14,9 +14,6 @@ all:
 .PHONY: all install default clean test
 .PHONY: FORCE cscope
 
-partcheck: all
-	@echo "make partcheck => TODO add tests with out kernel support"
-
 runtests: all
 	@$(MAKE) -C test runtests
 runtests-loop: all
-- 
Ammar Faizi



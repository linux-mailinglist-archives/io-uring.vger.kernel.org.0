Return-Path: <io-uring+bounces-12201-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id vm0BIjeSj2l/RgEAu9opvQ
	(envelope-from <io-uring+bounces-12201-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 22:05:59 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AF041398BF
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 22:05:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E3EF23015738
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 21:05:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41B7716A395;
	Fri, 13 Feb 2026 21:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="ujYlff+7"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036BD8C1F
	for <io-uring@vger.kernel.org>; Fri, 13 Feb 2026 21:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771016756; cv=none; b=gw5QenvzIcPLjC7v7wz8+xGmAkZRJBUusyLKSAHzUzkbaR5hfacxOpCwzxsBJDOEBPKeNSLcKF7pnXeJjDiwunvLLkjzOtnXt5edpp9ohMEL/EFh8GVeU0NFfIFZA2UZoGx/CLmAXeCsBhFjs1mH5NLoo0pd3Q7JUCb2EEIJKeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771016756; c=relaxed/simple;
	bh=TZk939/BReWb79Siuv3iarvS+76c1+sCTDVPbeqgYiA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hNkg17Mp6vvdNjo/pJczyAPOfdHfbW9mr61nO0ugYU2pB1LjEQhFIpF8gHnB2ipLjcXdIsbLpOoax+bS6dxfKxDv3mqCr5mqREZ2NaIFu0igj8QCqN5I4ZYuznDviR6FM/C0SwbJoJWG5q2zdackkrEKq7sZyhILZ1HapqdC24c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=ujYlff+7; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=new2025; t=1771016752;
	bh=TZk939/BReWb79Siuv3iarvS+76c1+sCTDVPbeqgYiA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:
	 Content-Transfer-Encoding:Message-ID:Date:From:Reply-To:Subject:To:
	 Cc:In-Reply-To:References:Resent-Date:Resent-From:Resent-To:
	 Resent-Cc:User-Agent:Content-Type:Content-Transfer-Encoding;
	b=ujYlff+7EPCqCDTvidjOtkRMC/ZPyLuodx60fCDoANT6P1PjOgROYfGvosHX26+Ed
	 4VJGWbT2ZB2F9IHxji1dxTb8V4XAK+EdaVtLrRFHLOT27/d9MaT+I190xrkoalv86p
	 PUA5n7hFysVXWenM5BB5QFnhDN6wnEKivm+y6Dd65Wlu8rdKLWP5lAEvdD2J2iENPj
	 xp6keSHShMiq6K2PINwCyVOtuYz+Mj+sNTAwHNSSQc0/NdFA5lG5LG9HaxVeZUuSem
	 EXg4Y5de0NrIOxMWkJohK/T8O3s5lw6sN0/cIaeTjtJlXMhjHiJa+Nq0yFwDeLD1v4
	 7SA/jQASRizzA==
Received: from localhost.localdomain (unknown [36.50.142.76])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id A6E543204B4A;
	Fri, 13 Feb 2026 21:05:51 +0000 (UTC)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing] src/Makefile: Fix missing bpf_filter.h installation
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Sat, 14 Feb 2026 04:05:48 +0700
Message-Id: <20260213210548.851503-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
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
	DMARC_POLICY_ALLOW(-0.50)[gnuweeb.org,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[gnuweeb.org:s=new2025];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12201-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[ammarfaizi2@gnuweeb.org,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gnuweeb.org:+];
	PRECEDENCE_BULK(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9AF041398BF
X-Rspamd-Action: no action

After a "make install" command, liburing.h fails to compile because
bpf_filter.h is not copied to the destination include directory:

    In file included from .github/workflows/test_build.c:1:
    /usr/include/liburing.h:21:10: fatal error: liburing/io_uring/bpf_filter.h: No such file or directory
    21 | #include "liburing/io_uring/bpf_filter.h"
        |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    compilation terminated.

Add the header to the Makefile's install list to satisfy the dependency.

Fixes: 46b5c4d66232dcadd0f46c875e6fabce3b3dea85 ("src/include/liburing.h: add bpf_filter.h header")
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/Makefile b/src/Makefile
index 7febcf3c223b..9f45e1999b09 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -108,6 +108,7 @@ install: $(all_targets)
 	install -D -m 644 include/liburing/barrier.h $(includedir)/liburing/barrier.h
 	install -D -m 644 include/liburing/io_uring_version.h $(includedir)/liburing/io_uring_version.h
 	install -D -m 644 include/liburing/io_uring/query.h $(includedir)/liburing/io_uring/query.h
+	install -D -m 644 include/liburing/io_uring/bpf_filter.h $(includedir)/liburing/io_uring/bpf_filter.h
 	install -D -m 644 liburing.a $(libdevdir)/liburing.a
 	install -D -m 644 liburing-ffi.a $(libdevdir)/liburing-ffi.a
 ifeq ($(ENABLE_SHARED),1)

base-commit: 9b7c673fecf8f6043dbc132cadbf5570769efd65
-- 
Ammar Faizi



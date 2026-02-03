Return-Path: <io-uring+bounces-12043-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eES5OT6Jgmn/VwMAu9opvQ
	(envelope-from <io-uring+bounces-12043-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 04 Feb 2026 00:48:14 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CFF3DFD70
	for <lists+io-uring@lfdr.de>; Wed, 04 Feb 2026 00:48:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E919E30178A4
	for <lists+io-uring@lfdr.de>; Tue,  3 Feb 2026 23:48:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADDB51E7C18;
	Tue,  3 Feb 2026 23:48:12 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE5E285C98
	for <io-uring@vger.kernel.org>; Tue,  3 Feb 2026 23:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770162492; cv=none; b=kWODHxHbm+rSk7wK/v3fPZkank29oblP2XCjJP3wmZthXQB/xKo9fPyzxZydqNQRWmZ12X2Pf4UCu01rPqHqk2R/9qwKByFUnb4+vXhUSyUh1JvYsoBufP/PQLGhSDxBLpK0GeVKnybvC3tUR4QKlPOhRxwwP7R6rB/ybC9V49g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770162492; c=relaxed/simple;
	bh=cXvbRhCWBY0UKpE8OJz+MlYi4jhzHdodmKupAuaeHCo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XpNEcQOkhdzvG3rY58lDSFKqzYwOkXcm1ESrwrlwEEJtLgwiEQuPvpHi5aZ6qWEO7MiNLz16WSdEuZEGdvluL3RomAWFukpK176ndIrEvxq0qMN4uXPjnpSoeFGcbhP8XgXPhE6QqELXIT3DbwFIduMBSzsDOmD09sJWD/XxUeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=sony.com; spf=fail smtp.mailfrom=sony.com; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=sony.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=sony.com
Received: from eig-obgw-5001b.ext.cloudfilter.net ([10.0.29.181])
	by cmsmtp with ESMTPS
	id nJOrvUQO7aPqLnQ6NvVbDA; Tue, 03 Feb 2026 23:46:35 +0000
Received: from host2044.hostmonster.com ([67.20.76.238])
	by cmsmtp with ESMTPS
	id nQ6MvcEBrSqlVnQ6Mv5nsX; Tue, 03 Feb 2026 23:46:35 +0000
X-Authority-Analysis: v=2.4 cv=I7FlRMgg c=1 sm=1 tr=0 ts=698288db
 a=O1AQXT3IpLm5MaED65xONQ==:117 a=uc9KWs4yn0V/JYYSH7YHpg==:17
 a=HzLeVaNsDn8A:10 a=z6gsHLkEAAAA:8 a=k30aKGXMej4JcZpHlBoA:9
 a=EGBcgr28NivcBxMJG6iU:22 a=iekntanDnrheIxGr1pkv:22
Received: from [66.118.46.62] (port=50430 helo=timdesk..)
	by host2044.hostmonster.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.99.1)
	(envelope-from <tim.bird@sony.com>)
	id 1vnQ6K-000000049PT-40Gn;
	Tue, 03 Feb 2026 16:46:33 -0700
From: Tim Bird <tim.bird@sony.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: linux-spdx@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tim Bird <tim.bird@sony.com>
Subject: [PATCH] io_uring: Add SPDX id lines to remaining source files
Date: Tue,  3 Feb 2026 16:46:24 -0700
Message-ID: <20260203234624.1722921-1-tim.bird@sony.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host2044.hostmonster.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - sony.com
X-BWhitelist: no
X-Source-IP: 66.118.46.62
X-Source-L: No
X-Exim-ID: 1vnQ6K-000000049PT-40Gn
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (timdesk..) [66.118.46.62]:50430
X-Source-Auth: tim@bird.org
X-Email-Count: 3
X-Org: HG=bhshared_hm;ORG=bluehost;
X-Source-Cap: YmlyZG9yZztiaXJkb3JnO2hvc3QyMDQ0Lmhvc3Rtb25zdGVyLmNvbQ==
X-Local-Domain: no
X-CMAE-Envelope: MS4xfEa4Vpd0a2mzGU3R0P5tDmDz8N50DINIeUd2lU7Ets7kurnbVOWofnCvOZoz3TkzC2X/jCN81ZoJvNgq8HypkKX+KHiXsaDSjJgsx4CnpjN/sgUmoRIf
 Rk+9G1wdtrY+P1d8Y7uOrNtkpS99wsvniFlWMiHJbUA/AGHw9302/GVQ1n4YT7aQiC0pI/oC3PcFJTN5Aph+a0z9q7gq3RKiUfE=
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.64 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[sony.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	HAS_X_SOURCE(0.00)[];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12043-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tim.bird@sony.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	HAS_X_ANTIABUSE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.979];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sony.com:mid,sony.com:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8CFF3DFD70
X-Rspamd-Action: no action

Some io_uring files are missing SPDX-License-Identifier lines.
Add lines with GPL-2.0 license IDs to these files.

Signed-off-by: Tim Bird <tim.bird@sony.com>
---
 io_uring/alloc_cache.h | 1 +
 io_uring/cmd_net.c     | 1 +
 io_uring/eventfd.h     | 1 +
 io_uring/io-wq.h       | 1 +
 io_uring/io_uring.h    | 1 +
 io_uring/memmap.h      | 1 +
 io_uring/mock_file.c   | 1 +
 io_uring/notif.c       | 1 +
 io_uring/refs.h        | 1 +
 io_uring/slist.h       | 1 +
 10 files changed, 10 insertions(+)

diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
index d33ce159ef33..ab637abc440c 100644
--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 #ifndef IOU_ALLOC_CACHE_H
 #define IOU_ALLOC_CACHE_H
 
diff --git a/io_uring/cmd_net.c b/io_uring/cmd_net.c
index 19d3ce2bd20a..cb2775936fb8 100644
--- a/io_uring/cmd_net.c
+++ b/io_uring/cmd_net.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 #include <asm/ioctls.h>
 #include <linux/io_uring/net.h>
 #include <linux/errqueue.h>
diff --git a/io_uring/eventfd.h b/io_uring/eventfd.h
index e2f1985c2cf9..400eda4a4165 100644
--- a/io_uring/eventfd.h
+++ b/io_uring/eventfd.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 
 struct io_ring_ctx;
 int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index 774abab54732..68873d370a54 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 #ifndef INTERNAL_IO_WQ_H
 #define INTERNAL_IO_WQ_H
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index a790c16854d3..6146cfd5878b 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 #ifndef IOU_CORE_H
 #define IOU_CORE_H
 
diff --git a/io_uring/memmap.h b/io_uring/memmap.h
index a39d9e518905..f4cfbb6b9a1f 100644
--- a/io_uring/memmap.h
+++ b/io_uring/memmap.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 #ifndef IO_URING_MEMMAP_H
 #define IO_URING_MEMMAP_H
 
diff --git a/io_uring/mock_file.c b/io_uring/mock_file.c
index 3ffac8f72974..80c96ad2061f 100644
--- a/io_uring/mock_file.c
+++ b/io_uring/mock_file.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 #include <linux/device.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
diff --git a/io_uring/notif.c b/io_uring/notif.c
index f476775ba44b..efce8ae12eaa 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/file.h>
diff --git a/io_uring/refs.h b/io_uring/refs.h
index 0d928d87c4ed..0fe16b67c308 100644
--- a/io_uring/refs.h
+++ b/io_uring/refs.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 #ifndef IOU_REQ_REF_H
 #define IOU_REQ_REF_H
 
diff --git a/io_uring/slist.h b/io_uring/slist.h
index 7ef747442754..77382f30321d 100644
--- a/io_uring/slist.h
+++ b/io_uring/slist.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 #ifndef INTERNAL_IO_SLIST_H
 #define INTERNAL_IO_SLIST_H
 
-- 
2.43.0



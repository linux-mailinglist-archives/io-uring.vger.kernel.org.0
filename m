Return-Path: <io-uring+bounces-13800-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id wRSbHph7NmozAQcAu9opvQ
	(envelope-from <io-uring+bounces-13800-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 20 Jun 2026 13:38:00 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D018D6A8CED
	for <lists+io-uring@lfdr.de>; Sat, 20 Jun 2026 13:37:59 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C8rKWJcl;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13800-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13800-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8541F300EA81
	for <lists+io-uring@lfdr.de>; Sat, 20 Jun 2026 11:37:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 759A52DC32C;
	Sat, 20 Jun 2026 11:37:57 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9DD2641C6
	for <io-uring@vger.kernel.org>; Sat, 20 Jun 2026 11:37:55 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781955477; cv=none; b=gisFcCtCyD8tedHq7WU98O1cGXF+dzCYolJu837OdLgvMsIbk605NPMtbC9f2sp+wSz3nHZD29VTqlgieH5ieB8Pk7H4VaLdXpo/FDD7rKE8xI2oNusrx8gJtITxVRdHXXDCeNbdtCYsHGFAE3U/hLej2zTtPtv3Pr4Mte/3WkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781955477; c=relaxed/simple;
	bh=xjLUpK2iYtfxgN3yk80WlO0GqeGniKeUCsuY7kCzuyE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IEfpNP5NffnZPJLHeqiuNXXR0vTZGrq9HUg/Fw/3RMthgp6TZM53qkZGnnyp30ZYaP1HbabS92QaYbimxt47ZQjzVMrYbFnn7361XQHvvLLvUgGxDFXbL6USOMt3JBmpPjpDAumkV7iN6wneWtsyTzRurH1Cij38ec6DJQ6eqwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C8rKWJcl; arc=none smtp.client-ip=209.85.210.178
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-842307473b5so2017878b3a.2
        for <io-uring@vger.kernel.org>; Sat, 20 Jun 2026 04:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781955475; x=1782560275; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N28dA7Zn9imvvxHny8KpMtzdROYsxCmWJnez0V1cULY=;
        b=C8rKWJclcY9wGhfDUf1aJuiPCwvZEvl70JUVZJVhHXrRXphPM61qGMQJlKRXQgVgMg
         n/Nv++vVk5h+FstVng7T3h1SkEfWCdBKulbA1J6hf5XMU/KF7lDG+nSnP/I9B6N+8rWm
         gMcpX2Xw2wFy7qUbcCSoiUrzqk0DP5+I52dXu9WLXxrBSuui2/xEYbyRAmc/fJQjwVud
         E1cj/XYTpDatA95zKINW7wnOQ5ieVGw1D7i6acEWsS4WBdGCOf2OdLpmZxU4Z7BFHBoS
         R3vCXZDrQcTLH8j5WpAsw7o/eGQUEzeJz071DpQvUxUOLjqgowocOd8Ai4sZKDK0Bpm2
         zW2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781955475; x=1782560275;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N28dA7Zn9imvvxHny8KpMtzdROYsxCmWJnez0V1cULY=;
        b=Q8GPqYxa4MFN4hzJSllqsfx/uwXImwzgoW2ucsVLDixQw2syGPUSNSpEd1/rOgDaT1
         n4Sh7CLsxgEMAWua/jjmTyJ++IFoxCaPM6VuPOtN3E/azLfKkzk9Q4J2tSA9I6oK3g1Q
         DrONxUFKS1q9HAmghuj+2Ciwua3JvFIUzDdY+dma6XGb8fkBkDimodVfvHSxPCW+kDtG
         SsCalhTzlzs5bUJyiQNFcPOKrTYQ2l9bo7sdStSHNECw5iAhP1C3gMnsF52M+/HtmH6R
         1kfb6PK8gwDQ1sPIqmowUlx35BZTblF5Yf/B1+RRkxugN5SfB6FaPPCqImOROKCF2UmL
         gHBA==
X-Gm-Message-State: AOJu0Yw1Lev9xThxnzRSafYhdIVsqEJCnX9vfuKYttWmMLLYiiA7wM/N
	HQR4X0Q+KrrzTcX4JbnTQGLcwSDYLm8hlAOIqZv1sk7m4DMCSA+VQJfgcYMuqMuiZDA=
X-Gm-Gg: AfdE7cn+k3y/Qe024qt+E/6Z878ZjPEaMQyJGWd9l8aIgCkIKVygMPahg1EcWmrqC5a
	GdVXCctDfZt2TMFlENMZ3HQEu6QLfKYCK9su+KzTa5tzBEtgJuZeqDG3TXbRX01ibNmwn0NhMiy
	7x+LOKoObGYO3SPz+5HHxvts0qq70WyzberK8runyc1P0sT7SKf/fhMEMCqgi0EnX0zbCCYxtH9
	IgGm+Ng569LJfK/pWJxBo69Zdg1FfPqdu/2deBcMOBuyreKpiX6RTaKyH4WKjFrnCY1wz/wVOt/
	JzK6jXQdwzn5unCSxtwZXIYxtJHFOJE87ZWu4bj+DJxF0JyOIjbGRxdPSu84cMnjCpqTGx2ZXM1
	60LuzaLklPYptnNosoD4xm/XTHhbxavt2PYMAEyHz3jqLHHFm60JWBcsRJFwT7DTHwbdP2Xbs0H
	ZhwJDSEnUNl1wA8pFdRcnX6sHjxHCOfghr7NRGrquiRggAfEMZsiZGG7cC2BSJV1xcQ6G2UOUIk
	jzTW8r1jpHjg6ZpDHvg
X-Received: by 2002:a05:6a00:12e0:b0:842:6c02:2fa4 with SMTP id d2e1a72fcca58-84556084f18mr6704577b3a.14.1781955475176;
        Sat, 20 Jun 2026 04:37:55 -0700 (PDT)
Received: from prateek-Aspire-A515-57G.. ([182.77.77.244])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c8bc5a1d583sm2022360a12.25.2026.06.20.04.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2026 04:37:54 -0700 (PDT)
From: Prateek <kprateek283@gmail.com>
To: io-uring@vger.kernel.org
Cc: Prateek <kprateek283@gmail.com>
Subject: [PATCH] setup: dynamically detect default huge page size
Date: Sat, 20 Jun 2026 17:06:09 +0530
Message-ID: <20260620113609.123575-1-kprateek283@gmail.com>
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
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13800-lists,io-uring=lfdr.de];
	FORGED_SENDER(0.00)[kprateek283@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:kprateek283@gmail.com,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: D018D6A8CED

    Replaces the hardcoded 2MB huge page size with dynamic detection by
    parsing /proc/meminfo. This fixes no-mmap allocation failures on
    architectures with different default huge page sizes (like ARM64
    which often uses 512MB) or x86 systems configured for 1GB pages.

    - Safely parses /proc/meminfo without allocating memory.
    - Uses raw syscalls and manual byte-by-byte matching to maintain
      strict compatibility with CONFIG_NOLIBC builds (avoiding strstr).
    - Drops the MAP_HUGE_2MB mmap flag to allow the kernel to correctly
      apply the system's default huge page size.
    - Falls back safely to 2MB if /proc/meminfo is unreadable.

Signed-off-by: Prateek <kprateek283@gmail.com>
---
 src/setup.c | 84 +++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 68 insertions(+), 16 deletions(-)

diff --git a/src/setup.c b/src/setup.c
index ea6f11fd..46e20e0b 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -220,15 +220,67 @@ __cold int io_uring_ring_dontfork(struct io_uring *ring)
 	return 0;
 }
 
-#ifndef MAP_HUGE_SHIFT
-#define MAP_HUGE_SHIFT	26
-#endif
-#ifndef MAP_HUGE_2MB
-#define MAP_HUGE_2MB	(21U << MAP_HUGE_SHIFT)
-#endif
 
-/* FIXME */
-static size_t huge_page_size = 2 * 1024 * 1024;
+static size_t get_huge_page_size(void)
+{
+	static size_t hps;
+	size_t ret = 2 * 1024 * 1024; /* fallback: 2MB */
+	char buf[4096];
+	char *p, *end;
+	unsigned long val;
+	ssize_t n;
+	int fd;
+
+	if (hps)
+		return hps;
+
+	fd = __sys_open("/proc/meminfo", O_RDONLY, 0);
+	if (fd < 0)
+		goto out;
+
+	n = __sys_read(fd, buf, sizeof(buf) - 1);
+	__sys_close(fd);
+	if (n <= 0)
+		goto out;
+	buf[n] = '\0';
+
+	/*
+	 * Scan line-by-line for "Hugepagesize:". We avoid strstr() and
+	 * memcmp() because they are not available in CONFIG_NOLIBC builds.
+	 */
+	p = buf;
+	end = buf + n;
+	while (p < end) {
+		/* Check if this line starts with "Hugepagesize:" (13 chars) */
+		if (p + 13 <= end &&
+		    p[0]  == 'H' && p[1]  == 'u' && p[2]  == 'g' &&
+		    p[3]  == 'e' && p[4]  == 'p' && p[5]  == 'a' &&
+		    p[6]  == 'g' && p[7]  == 'e' && p[8]  == 's' &&
+		    p[9]  == 'i' && p[10] == 'z' && p[11] == 'e' &&
+		    p[12] == ':') {
+			p += 13;
+			while (p < end && (*p == ' ' || *p == '\t'))
+				p++;
+			val = 0;
+			while (p < end && *p >= '0' && *p <= '9') {
+				val = val * 10 + (*p - '0');
+				p++;
+			}
+			if (val)
+				ret = val * 1024; /* kB -> bytes */
+			break;
+		}
+		/* Advance to next line */
+		while (p < end && *p != '\n')
+			p++;
+		if (p < end)
+			p++;
+	}
+out:
+	hps = ret;
+	return hps;
+}
+
 
 #define KRING_SIZE	64
 
@@ -261,13 +313,13 @@ static int io_uring_alloc_huge(unsigned entries, struct io_uring_params *p,
 	mem_used = (mem_used + page_size - 1) & ~(page_size - 1);
 
 	/*
-	 * A maxed-out number of CQ entries with IORING_SETUP_CQE32 fills a 2MB
-	 * huge page by itself, so the SQ entries won't fit in the same huge
-	 * page. For SQEs, that shouldn't be possible given KERN_MAX_ENTRIES,
+	 * A maxed-out number of CQ entries with IORING_SETUP_CQE32 can fill a
+	 * single huge page by itself, so the SQ entries won't fit in the same
+	 * huge page. For SQEs, that shouldn't be possible given KERN_MAX_ENTRIES,
 	 * but check that too to future-proof (e.g. against different huge page
 	 * sizes). Bail out early so we don't overrun.
 	 */
-	if (!buf && (sqes_mem > huge_page_size || ring_mem > huge_page_size))
+	if (!buf && (sqes_mem > get_huge_page_size() || ring_mem > get_huge_page_size()))
 		return -ENOMEM;
 
 	if (buf) {
@@ -279,8 +331,8 @@ static int io_uring_alloc_huge(unsigned entries, struct io_uring_params *p,
 		if (sqes_mem <= page_size)
 			buf_size = page_size;
 		else {
-			buf_size = huge_page_size;
-			map_hugetlb = MAP_HUGETLB | MAP_HUGE_2MB;
+			buf_size = get_huge_page_size();
+			map_hugetlb = MAP_HUGETLB;
 		}
 		sqes_size = buf_size;
 		ptr = __sys_mmap(NULL, sqes_size, PROT_READ|PROT_WRITE,
@@ -302,8 +354,8 @@ static int io_uring_alloc_huge(unsigned entries, struct io_uring_params *p,
 		if (ring_mem <= page_size)
 			buf_size = page_size;
 		else {
-			buf_size = huge_page_size;
-			map_hugetlb = MAP_HUGETLB | MAP_HUGE_2MB;
+			buf_size = get_huge_page_size();
+			map_hugetlb = MAP_HUGETLB;
 		}
 		ptr = __sys_mmap(NULL, buf_size, PROT_READ|PROT_WRITE,
 					MAP_SHARED|MAP_ANONYMOUS|map_hugetlb,
-- 
2.43.0



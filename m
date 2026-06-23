Return-Path: <io-uring+bounces-13819-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id uhpyKJurOmr6DAgAu9opvQ
	(envelope-from <io-uring+bounces-13819-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2026 17:51:55 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 403DC6B873E
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2026 17:51:55 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DROYKtiF;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13819-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13819-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3D173306411B
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2026 15:44:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1AD12E2DFB;
	Tue, 23 Jun 2026 15:44:04 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A13A269CE7
	for <io-uring@vger.kernel.org>; Tue, 23 Jun 2026 15:44:03 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782229444; cv=none; b=JtHEQjVA8L7BQQHc2xsOheIRLBLqpA48DTSEhgSQxDLj1qcMOKevGJT70jtGI+WH7NPVKRD1YFHELDkuK8mKwgspjPhVReqLLa1oDcFD9gxQyHh9DkYb4Ex8Kvj8d8uvXbucxJrtG8xZ0BCYHE4lVXZHtQ1F1bXYrZ3Z+jrI4Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782229444; c=relaxed/simple;
	bh=P8t0z5CdliK1YIHhPxx5EwTnu+zemULtDqVHxKPKwLw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SLr4r+gAL+fhCYESlU90+7DEY3JVJuGHVDkE5TD9ZxTOpO5C/i5d8xqjcj2KP1fpht+lUW+DlUwqDzkVG+1YZgTmxBdXS6YWNrS2DueV7dgx87IH7w4IZDXZooDdJ1URP7A7agqVwaVAVtnRJgwnq24wJgLLL+LAFZBDQH2Ixbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DROYKtiF; arc=none smtp.client-ip=209.85.214.172
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2c6c57c5c07so38906915ad.1
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2026 08:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782229443; x=1782834243; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GF0uwZcaI1q8/nEyAIkB13deyPNdiHEG7iPtIdQpVhI=;
        b=DROYKtiFtt0LpL5GXUnPg8/3MbZVJ0iLO+g4jdI2ZPZWZG0N7U7OY5dCPIH6GypHq+
         1yGkIAz6Xa93lmMY1eC2IBt17zDw6m5UEjQVOWqjorzPdanjQ+t2w1Hkx+g4bSC4iMeK
         GWkPSoYVxQrrMw+i5lhNrwx+OeEfNs0O4TiQUwHZow4Bbl6j10WIZrxIv6AShbAkASLU
         mJevR1/okszBl1dZeZxkXpq7QnB7+jm5J4t4jaXxQFngjVEEyz1Sp6XxCjO4j154aXLc
         tCqsb/vXAlZJ8uME1iY3y1mLZvdEsD/c3jEu5a7Be0sBGjdzgiCmoboYb5JLrtiJi07M
         NAXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782229443; x=1782834243;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GF0uwZcaI1q8/nEyAIkB13deyPNdiHEG7iPtIdQpVhI=;
        b=Ve9w/tZl9QVZtJ/PGO2hVjJmn4MhA1fAZgK6uZyPqx+R5PLOLI9liTHBIbLmruQ0Jd
         VTHVtK44xRSZxLL8yeHQHFWaF151RQLdSh61NuLlJuYRn3fuHSbZhfTkm/Sv6HfeDWHQ
         bn6LPKA4wLvRFjYjW6eY2ow6qj4KMCuHEl0Q30Wi2LkMF22j4/+otOl3R6iGHXjebw2v
         MyJ/uJOUJfRPa5Ox2oaylarbqMW3DA1bqsB35abtehwTcANUfbbOmHyPbjsYylMjtiPI
         OL0ekvU4mi87BAt3qKUUHxTuMR6VDN6VF5P3emW2CV7O0O+OFJnnNcMy2Ykn5DzJrZg9
         dyNg==
X-Gm-Message-State: AOJu0YztU5eMw+GQWhD+QANQkfaNHiAJIN0t30UR1+qCgKoqkZFhpu4f
	jv6hyUtGjHbMVTHB688+1/SC+NMFi9AuQdCNShvN67p9cA1ADGz8134uT3WZOiLtBZo=
X-Gm-Gg: AfdE7cmM32SxGB+uch5po91tQiL6vk/oMdFaAOxIGYFvSKZnaF/uZE/QtKoarIcfbnf
	kvtAhM8Gej1gvTa4lt0+ayBT7wOcAmI6d52Hxpp8XoJvxKs5HKR3YO6ts56+KcdeCnuWryWQBQJ
	bg7uaYpo+CDnez74D/GAhkrqt1QqIDbpxQTpnjvfovjs3f8SLvSdpE2Chjn2FTFR7M11JQlU/8w
	AJrdyYqCEbFeMg359UKB4Ya7F+/wx17BHjz9NGQjIRYabaaMJbgqNFp3wjIAFycFEpG56Swldz3
	Hr/HCX9JJeyYq4NSFl3gvqkCgxuvCRvt4Z0IEcM+M8sbPWGTJxJrvLQBbecQ4aXcT6qvkJ/5a6Q
	LwWnfPbW+iseXSMOvGuJvssouwp+lutoeetHtMpllaOxaOHf3dtdvcrFwgJibvojys9AZg8n/V+
	JUpsfRgzBVaXaqExoZmRUSRUXD1+NCXcFNQ+1nXoz08Jltlq/O+8UXCYq9+5aM1M/cO22lWWMzu
	XTk+y+RwkPySWQbzQuibfflNG1OnzY=
X-Received: by 2002:a17:903:2f87:b0:2c6:f3ae:2386 with SMTP id d9443c01a7336-2c718caf4a4mr216452415ad.7.1782229442186;
        Tue, 23 Jun 2026 08:44:02 -0700 (PDT)
Received: from prateek-Aspire-A515-57G.. ([182.77.73.131])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7436af590sm132403425ad.17.2026.06.23.08.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 08:44:01 -0700 (PDT)
From: Prateek <kprateek283@gmail.com>
To: gabriel@krisman.be
Cc: io-uring@vger.kernel.org,
	kprateek283@gmail.com
Subject: [PATCH v2] setup: dynamically detect default huge page size
Date: Tue, 23 Jun 2026 21:13:05 +0530
Message-ID: <20260623154305.1115403-1-kprateek283@gmail.com>
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
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	TAGGED_FROM(0.00)[bounces-13819-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER(0.00)[kprateek283@gmail.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS(0.00)[m:gabriel@krisman.be,m:io-uring@vger.kernel.org,m:kprateek283@gmail.com,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kprateek283@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 403DC6B873E

    Replaces the hardcoded 2MB huge page size with dynamic detection by
    parsing /proc/meminfo. This fixes no-mmap allocation failures on
    architectures with different default huge page sizes (like ARM64
    which often uses 512MB) or x86 systems configured for 1GB pages.

    - Safely parses /proc/meminfo without allocating memory.
    - Adds a __uring_memcmp shim for CONFIG_NOLIBC builds, allowing
      setup.c to use standard memcmp for the Hugepagesize: match.
    - Drops the MAP_HUGE_2MB mmap flag to allow the kernel to correctly
      apply the system's default huge page size.
    - Falls back safely to 2MB if /proc/meminfo is unreadable.

Signed-off-by: Prateek <kprateek283@gmail.com>
---
Changes in v2:
- Initialized hps explicitly to 0.
- Replaced the char-by-char Hugepagesize comparison with a new __uring_memcmp helper.
- Removed the redundant ret variable and simplified the fallback assignment using a ternary operator.

 src/lib.h    |  2 ++
 src/nolibc.c | 19 +++++++++++++
 src/setup.c  | 75 +++++++++++++++++++++++++++++++++++++++++-----------
 3 files changed, 80 insertions(+), 16 deletions(-)

diff --git a/src/lib.h b/src/lib.h
index 4d32d3e1..463dd4b5 100644
--- a/src/lib.h
+++ b/src/lib.h
@@ -41,10 +41,12 @@
 void *__uring_memset(void *s, int c, size_t n);
 void *__uring_malloc(size_t len);
 void __uring_free(void *p);
+int __uring_memcmp(const void *s1, const void *s2, size_t n);
 
 #define malloc(LEN)		__uring_malloc(LEN)
 #define free(PTR)		__uring_free(PTR)
 #define memset(PTR, C, LEN)	__uring_memset(PTR, C, LEN)
+#define memcmp(S1, S2, LEN)	__uring_memcmp(S1, S2, LEN)
 #endif
 
 #endif /* #ifndef LIBURING_LIB_H */
diff --git a/src/nolibc.c b/src/nolibc.c
index 88b1494a..14ede500 100644
--- a/src/nolibc.c
+++ b/src/nolibc.c
@@ -25,6 +25,25 @@ void *__uring_memset(void *s, int c, size_t n)
 	return s;
 }
 
+int __uring_memcmp(const void *s1, const void *s2, size_t n)
+{
+	size_t i;
+	const unsigned char *p1 = s1, *p2 = s2;
+
+	for (i = 0; i < n; i++) {
+		if (p1[i] != p2[i])
+			return p1[i] - p2[i];
+
+		/*
+		 * An empty inline ASM to avoid auto-vectorization
+		 * because it's too bloated for liburing.
+		 */
+		__asm__ volatile ("");
+	}
+
+	return 0;
+}
+
 struct uring_heap {
 	size_t		len;
 	char		user_p[] __attribute__((__aligned__));
diff --git a/src/setup.c b/src/setup.c
index ea6f11fd..88f86784 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -220,15 +220,58 @@ __cold int io_uring_ring_dontfork(struct io_uring *ring)
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
+	static size_t hps = 0;
+	char buf[4096];
+	char *p, *end;
+	unsigned long val = 0;
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
+	 * Scan line-by-line for "Hugepagesize:".
+	 */
+	p = buf;
+	end = buf + n;
+	while (p < end) {
+		/* Check if this line starts with "Hugepagesize:" (13 chars) */
+		if (p + 13 <= end && !memcmp(p, "Hugepagesize:", 13)) {
+			p += 13;
+			while (p < end && (*p == ' ' || *p == '\t'))
+				p++;
+			val = 0;
+			while (p < end && *p >= '0' && *p <= '9') {
+				val = val * 10 + (*p - '0');
+				p++;
+			}
+			break;
+		}
+		/* Advance to next line */
+		while (p < end && *p != '\n')
+			p++;
+		if (p < end)
+			p++;
+	}
+out:
+	hps = val ? val * 1024 : 2 * 1024 * 1024;
+	return hps;
+}
+
 
 #define KRING_SIZE	64
 
@@ -261,13 +304,13 @@ static int io_uring_alloc_huge(unsigned entries, struct io_uring_params *p,
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
@@ -279,8 +322,8 @@ static int io_uring_alloc_huge(unsigned entries, struct io_uring_params *p,
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
@@ -302,8 +345,8 @@ static int io_uring_alloc_huge(unsigned entries, struct io_uring_params *p,
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



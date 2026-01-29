Return-Path: <io-uring+bounces-11981-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oDyzFW7be2noIwIAu9opvQ
	(envelope-from <io-uring+bounces-11981-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 23:13:02 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C8F46B5358
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 23:13:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BD4C9301586C
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 22:13:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8711A326922;
	Thu, 29 Jan 2026 22:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Bz8E0Pn1";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YZ+u8KFy";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Bz8E0Pn1";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YZ+u8KFy"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799E7369210
	for <io-uring@vger.kernel.org>; Thu, 29 Jan 2026 22:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769724780; cv=none; b=WKN2YHkzqUIPBHJA74cGxEI77G/UsxikWfElSbagrCnp3lsFdy0YaHRnn3M/QYafPD/vRtweghRF/g4FkWjjBc9SOxAzQal7i9HX9PyT9rOpJ5wGk9JIxt5s+1QjPNZ0tWycOCVtMvjEiADB/QyansslVWXs7F+aH+aOBz0uroc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769724780; c=relaxed/simple;
	bh=/NPc0gE0zP/7MRatCjBC9ImLmaXIXeprpjuEzfL4E6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYvvrRdq8BfJE5bFEC0BVcPVvXJr0Exo2SUsOes/fpRgiqm6hGB4sj2Y3GdnCFpumezlD15ziYL8V3WZ5CcsIs+cI0XFsmPYTg2I0Qu/I8feKmXXIsVXthIvo4mS71ppjFfUIJxSlWhE13O5Rs1FH4XPV/H0Ycwtv0KYHvs7HGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Bz8E0Pn1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YZ+u8KFy; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Bz8E0Pn1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YZ+u8KFy; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3421F5BCF5;
	Thu, 29 Jan 2026 22:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769724765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ro+CBBjDBJ5aR9jkVcK+u31k/wjeaG9c4RSwlqSuvDk=;
	b=Bz8E0Pn1tKC0anEaylC/ixBMonpjkM2Z3h3yrbyINueobCryn/e63ZJpCCEpR/uoMaeNzv
	B6zaeQjykbAKQTArRE/hHJyqc4EXIGZR82ZGNMs4lmTZEu0H3LnK0uSIjV+i4FRej5/B/i
	PAh6Zr73uioE+GVmGd7lPpZat14V9Xo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769724765;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ro+CBBjDBJ5aR9jkVcK+u31k/wjeaG9c4RSwlqSuvDk=;
	b=YZ+u8KFyJz8giaT0N7XwTSTqsiQ6j3ff6FIuNsUiQ6orn8kEUJ8Qt9W5jo2Z3YL3LD0iSl
	UP7F9EbHVxuaj1Ag==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Bz8E0Pn1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YZ+u8KFy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769724765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ro+CBBjDBJ5aR9jkVcK+u31k/wjeaG9c4RSwlqSuvDk=;
	b=Bz8E0Pn1tKC0anEaylC/ixBMonpjkM2Z3h3yrbyINueobCryn/e63ZJpCCEpR/uoMaeNzv
	B6zaeQjykbAKQTArRE/hHJyqc4EXIGZR82ZGNMs4lmTZEu0H3LnK0uSIjV+i4FRej5/B/i
	PAh6Zr73uioE+GVmGd7lPpZat14V9Xo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769724765;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ro+CBBjDBJ5aR9jkVcK+u31k/wjeaG9c4RSwlqSuvDk=;
	b=YZ+u8KFyJz8giaT0N7XwTSTqsiQ6j3ff6FIuNsUiQ6orn8kEUJ8Qt9W5jo2Z3YL3LD0iSl
	UP7F9EbHVxuaj1Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E18C23EA61;
	Thu, 29 Jan 2026 22:12:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id a4t/MFzbe2lUcAAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 29 Jan 2026 22:12:44 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing 2/2] mmap.t: Introduce IORING_OP_MMAP test case
Date: Thu, 29 Jan 2026 17:12:36 -0500
Message-ID: <20260129221236.898135-3-krisman@suse.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260129221236.898135-1-krisman@suse.de>
References: <20260129221236.898135-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11981-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-0.999];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.de:email,suse.de:dkim,suse.de:mid]
X-Rspamd-Queue-Id: C8F46B5358
X-Rspamd-Action: no action

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 test/Makefile |   1 +
 test/mmap.c   | 372 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 373 insertions(+)
 create mode 100644 test/mmap.c

diff --git a/test/Makefile b/test/Makefile
index 64862f34..8fe56ae4 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -141,6 +141,7 @@ test_srcs := \
 	link_drain.c \
 	link-timeout.c \
 	linked-defer-close.c \
+	mmap.c \
 	madvise.c \
 	min-timeout.c \
 	min-timeout-wait.c \
diff --git a/test/mmap.c b/test/mmap.c
new file mode 100644
index 00000000..b0ec326b
--- /dev/null
+++ b/test/mmap.c
@@ -0,0 +1,372 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: test mmap operation
+ *
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <sys/mman.h>
+#include <sys/param.h>
+#include "liburing.h"
+#include "helpers.h"
+
+static bool check_hugetlb()
+{
+	/* Cheap (to implement) check whether can mmap a 2MB hugetlb
+	 * page.
+	 */
+	void *x = mmap(NULL, 2*1024*1024,
+		       PROT_READ|PROT_WRITE,
+		       MAP_PRIVATE|MAP_ANONYMOUS|MAP_HUGETLB|MAP_HUGE_2MB,
+		       -1, 0);
+	if (x == (void*)-1) {
+		munmap(x, 2*1024*1024);
+		return false;
+	}
+	munmap(x, 2*1024*1024);
+	return true;
+}
+
+static unsigned char buf[BUFSIZ];
+#define MAGIC_CHAR 0xf3
+
+const char *func;
+int pos;
+#define CATCH_FAULT(x) (func = __func__, pos=__LINE__, x)
+
+static void do_sigsev(int sig, siginfo_t *si, void *unused)
+{
+	printf("SIGSEGV on 0x%lx (%s:%d). OP_MMAP likely broken\n",
+	       (long) si->si_addr, func, pos);
+	exit(T_EXIT_FAIL);
+}
+
+int create_memfd(int size, int flags)
+{
+	int fd;
+	int remain = size;
+	int ret;
+	char path[10];
+	static int i = 0;
+
+	/* just a unique name for each call */
+	snprintf(path, 10, "t%d", i++);
+
+	if (size % sizeof(int)) {
+		printf("memfd bad size %d\n", size);
+		return -1;
+	}
+	fd = memfd_create(path, flags);
+	if (!fd) {
+		printf("memfd %d\n", fd);
+		return -1;
+	}
+	if (ftruncate(fd, size)) {
+		fprintf(stderr, "ftruncate");
+		return -1;
+	}
+	while (remain > 0) {
+		ret = write(fd, buf, MIN(size,BUFSIZ));
+		if (ret < 0) {
+			fprintf(stderr, "write");
+			return -1;
+		}
+		remain -= ret;
+	}
+	return fd;
+}
+
+int uring_mmap(struct io_uring *ring, int sqe_flags,
+	       int fd, struct io_uring_mmap_desc *descs,
+	       int nr_descs, int flags)
+{
+	struct io_uring_sqe *sqe = io_uring_get_sqe(ring);
+	struct io_uring_cqe *cqe;
+	int ret;
+
+	io_uring_prep_mmap(sqe, fd, descs, nr_descs, flags);
+	sqe->flags |= sqe_flags;
+	io_uring_submit(ring);
+	io_uring_wait_cqe(ring, &cqe);
+
+	ret = cqe->res;
+	io_uring_cqe_seen(ring, cqe);
+	return ret;
+}
+
+int test_map_file(struct io_uring *ring, unsigned int ring_flags)
+{
+	int fd, ret;
+	struct io_uring_mmap_desc desc = {
+		.addr  = NULL,
+		.len   = BUFSIZ,
+		.pgoff = 0,
+		.prot  = (PROT_READ|PROT_WRITE),
+		.flags = MAP_PRIVATE
+	};
+
+	fd = create_memfd(BUFSIZ, 0);
+	if (fd < 0) {
+		return T_EXIT_SKIP;
+	}
+
+	ret = uring_mmap(ring, 0, fd, &desc, 1, 0);
+	if (ret != 1) {
+		fprintf(stderr, "mmap at %s:%d failed.  got %d",
+			func, __LINE__, ret);
+		return T_EXIT_FAIL;
+	}
+
+	if ((long long) desc.addr <= 0) {
+		fprintf(stderr, "bad desc.addr fail %lld\n",
+			(long long)desc.addr);
+		return T_EXIT_FAIL;
+	}
+
+	if (CATCH_FAULT(memcmp(desc.addr, buf, BUFSIZ))) {
+		fprintf(stderr, "check_buf fail\n");
+		return T_EXIT_FAIL;
+	}
+	if (munmap(desc.addr, BUFSIZ)) {
+		fprintf(stderr, "unmap fail\n");
+		return T_EXIT_FAIL;
+	}
+	/* same, with a fixed file. */
+	desc.addr = NULL;
+	if (io_uring_register_files(ring, &fd, 1)) {
+		fprintf(stderr, "register fail\n");
+		return T_EXIT_FAIL;
+	}
+
+	ret = uring_mmap(ring, IOSQE_FIXED_FILE, 0, &desc, 1, 0);
+	if (ret != 1) {
+		fprintf(stderr, "mmap at %s:%d failed.  got %d",
+			func, __LINE__, ret);
+		return T_EXIT_FAIL;
+	}
+
+	if ((long long)(desc.addr) < 0) {
+		fprintf(stderr, "bad desc.addr fail %lld\n",
+			(long long)desc.addr);
+		return T_EXIT_FAIL;
+	}
+
+	if (CATCH_FAULT(memcmp(desc.addr, buf, BUFSIZ))) {
+		fprintf(stderr, "check_buf fail\n");
+		return T_EXIT_FAIL;
+	}
+	return 0;
+}
+
+int test_map_anon(struct io_uring *ring, unsigned int ring_flags)
+{
+	struct io_uring_mmap_desc descs[4];
+	void *addrs[4];
+	int ret;
+
+	for (int i = 0 ; i < 4; i++) {
+		descs[i].addr = NULL;
+		descs[i].len = 1024;
+		descs[i].pgoff = 0;
+		descs[i].prot  = (PROT_READ|PROT_WRITE);
+		descs[i].flags = MAP_PRIVATE;
+	}
+
+	ret = uring_mmap(ring, 0, -1, descs, 4, MAP_ANONYMOUS);
+	if (ret != 4) {
+		fprintf(stderr, "mmap at %s:%d failed.  got %d\n",
+			__func__, __LINE__, ret);
+		return T_EXIT_FAIL;
+	}
+
+	for (int i = 0 ; i < 4; i++) {
+
+		if ((long long)(descs[i].addr) < 0) {
+			fprintf(stderr, "bad desc.addr fail %lld\n",
+				(long long)descs[i].addr);
+			return T_EXIT_FAIL;
+		}
+
+		/* Ensure it is mapped.  SIGSEV on error */
+		CATCH_FAULT(*((char*)descs[i].addr) = MAGIC_CHAR);
+		munmap((char*)descs[i].addr, 1024);
+	}
+
+	/* reuse the addr from the first test to verify MAP_FIXED.  We
+	 * know the region is free since we just unmapped it.
+	 */
+	for (int i = 0 ; i < 4; i++) {
+		addrs[i] = descs[i].addr;
+		descs[i].flags |= MAP_FIXED;
+	}
+
+	ret = uring_mmap(ring, 0, -1, descs, 4, MAP_ANONYMOUS);
+	if (ret != 4) {
+		fprintf(stderr, "mmap at %s:%d failed.  got %d\n",
+			__func__, __LINE__, ret);
+		return T_EXIT_FAIL;
+	}
+
+	for (int i = 0 ; i < 4; i++) {
+		/* Ensure it is mapped.  SIGSEV on error */
+		CATCH_FAULT(*((char*)descs[i].addr) = MAGIC_CHAR);
+
+		if (descs[i].addr != addrs[i]) {
+			fprintf(stderr, "MAP_FIXED failed");
+			return T_EXIT_FAIL;
+		}
+	}
+	return 0;
+}
+
+int test_map_anon_hugetlb(struct io_uring *ring, unsigned int ring_flags)
+{
+	struct io_uring_mmap_desc desc = {
+		.addr = NULL,
+		.len = 1*1024*1024,
+		.pgoff = 0,
+		.prot  = (PROT_READ|PROT_WRITE),
+		.flags = MAP_PRIVATE|MAP_HUGE_2MB,
+	};
+	int ret;
+
+	ret = uring_mmap(ring, 0, -1, &desc, 1,
+			 MAP_ANONYMOUS|MAP_HUGETLB);
+	if (ret != 1) {
+		fprintf(stderr, "mmap at %s:%d failed.  got %d\n",
+			__func__, __LINE__, ret);
+		return T_EXIT_FAIL;
+	}
+
+	if ((long long)(desc.addr) < 0) {
+		fprintf(stderr, "bad desc.addr fail %lld\n",
+			(long long)desc.addr);
+		return T_EXIT_FAIL;
+	}
+
+	/* Ensure it is mapped.  SIGSEV on error */
+	CATCH_FAULT(*((char*)desc.addr) = MAGIC_CHAR);
+	return 0;
+}
+
+
+int test_weird(struct io_uring *ring, unsigned int ring_flags)
+{
+	struct io_uring_mmap_desc desc;
+	int ret, fd = create_memfd(BUFSIZ, 0);
+	if (fd < 0) {
+		return T_EXIT_SKIP;
+	}
+
+	desc.addr = NULL;
+	desc.len = 1024;
+	desc.pgoff = 0;
+	desc.prot  = (PROT_READ|PROT_WRITE);
+	desc.flags = MAP_PRIVATE;
+
+	/* This is wrong because attempt MAP_ANONYMOUS with fd.  It
+	 * fails early, because bad flag is on SQE.
+	 */
+	ret = uring_mmap(ring, 0, fd, &desc, 1, MAP_ANONYMOUS);
+	if (ret != -EINVAL) {
+		fprintf(stderr, "mmap at %s:%d failed.  got %d",
+			__func__, __LINE__, ret);
+		return T_EXIT_FAIL;
+	}
+
+	/* This is wrong because attempt MAP_ANONYMOUS with fd.  It
+	 * fails late, because bad flag is on desc.
+	 */
+	desc.flags = MAP_PRIVATE|MAP_ANONYMOUS;
+	ret = uring_mmap(ring, 0, fd, &desc, 1, 0);
+	if (ret != 1) {
+		fprintf(stderr, "mmap at %s:%d failed.  got %d",
+			__func__, __LINE__, ret);
+		return T_EXIT_FAIL;
+	}
+
+	if ((long long) desc.addr != -EINVAL) {
+		printf("mmap ANONYMOUS with fd should have failed %lx\n",
+		       (uintptr_t)desc.addr);
+	}
+
+	/* This is wrong because we can't have MAP_HUGETLB in the
+	 * descriptor.  It fails late, because bad flag is on desc.
+	 */
+	desc.flags = MAP_PRIVATE|MAP_HUGETLB;
+	ret = uring_mmap(ring, 0, fd, &desc, 1, 0);
+	if (ret != 1) {
+		fprintf(stderr, "mmap at %s:%d failed.  got %d",
+			__func__, __LINE__, ret);
+		return T_EXIT_FAIL;
+	}
+
+	if ((long long) desc.addr != -EINVAL) {
+		printf("mmap ANONYMOUS with fd should have failed %lx\n",
+		       (uintptr_t)desc.addr);
+	}
+
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring_probe *probe;
+	struct io_uring ring;
+	int ret = 0;
+	struct sigaction sa;
+	bool has_hugetlb = check_hugetlb();
+
+	sa.sa_flags = SA_SIGINFO;
+	sigemptyset(&sa.sa_mask);
+	sa.sa_sigaction = do_sigsev;
+	if (sigaction(SIGSEGV, &sa, NULL) == -1) {
+		fprintf(stderr,
+			"failed to register signal handle. continuing.");
+	}
+	memset(buf, MAGIC_CHAR, BUFSIZ);
+
+	probe = io_uring_get_probe();
+	if (!probe)
+		return T_EXIT_SKIP;
+	if (!io_uring_opcode_supported(probe, IORING_OP_MMAP))
+		return T_EXIT_SKIP;
+
+	ret = t_create_ring(10, &ring, IORING_SETUP_SUBMIT_ALL);
+	if (ret < 0) {
+		fprintf(stderr, "queue_init: %s\n",
+			strerror(-ret));
+		return T_SETUP_SKIP;
+	}
+
+	ret |= test_map_anon(&ring, 0);
+	if (ret) {
+		fprintf(stderr, "test_map_anon failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	ret |= test_map_file(&ring, 0);
+	if (ret) {
+		fprintf(stderr, "test_map_file failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	if (has_hugetlb) {
+		ret |= test_map_anon_hugetlb(&ring, 0);
+		if (ret) {
+			fprintf(stderr, "test_map_file failed\n");
+			return T_EXIT_FAIL;
+		}
+	}
+
+	ret |= test_weird(&ring, 0);
+	if (ret) {
+		fprintf(stderr, "test_map_weird failed\n");
+	}
+
+	return ret;
+}
-- 
2.52.0



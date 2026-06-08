Return-Path: <io-uring+bounces-13637-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 3q+aI4thJmqvVgIAu9opvQ
	(envelope-from <io-uring+bounces-13637-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 08:30:35 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DC341653229
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 08:30:34 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FI3KbJ0c;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13637-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13637-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 233BE301A3B2
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2026 06:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1418638B127;
	Mon,  8 Jun 2026 06:30:11 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27FC327BFA
	for <io-uring@vger.kernel.org>; Mon,  8 Jun 2026 06:30:06 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780900210; cv=none; b=QWXwYhMBAQW6YEpUO7OytBg+I6A6CyW0utGcNi8OqPxnnaC5UEr/mt6WY9R+7aYm/2Qc/8fY+8fOPb7BGd8Ko3E5NJbF5QshuMLcZnbDS0j1k9rPHjH6qdn+5JiunlwvTTNV9rZR5jC6w8wj2W8IlkP8KK0ysf7nkJUYIPKvLPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780900210; c=relaxed/simple;
	bh=EC6zXd58d8z49QA+EzUwoN6+QMz3OHbzht5PlmcPBcQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Fwn0q7zVkCKq3VLWFQA3AcqMEjr9IbsWTZbQATuG+pbAgNsPUAHDlVrO2MraR8UBmBpaNwSgM8Zy9mhcjU5Vdp+afO8tU6z+SR+VXLg01lBYyGI/WuJmegjQJ8lEE0oF9p86gygcT/TgWovru/TCkpV025iXlIrmqP1AL3ZzewQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FI3KbJ0c; arc=none smtp.client-ip=74.125.82.50
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-138188a7dccso3035995c88.1
        for <io-uring@vger.kernel.org>; Sun, 07 Jun 2026 23:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780900206; x=1781505006; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qDYJ9YnYahbdpvzrWk3FO5n4lndwP1vG0GrraJw28yE=;
        b=FI3KbJ0ckQM4hXhUKOJ1N+luv0Mpej3sHPCB48/SDAkUumrC3Htxt0BxptpUYLc22U
         OokxLp10u9FU/VSxprnj+FnJ/hs+tFk6CO8/NXX67hMMzu5iTXnQ50gcYk+NhpvUpgEb
         1xwtmeHYpksUuuaPLNdOUBlMQD/DCi/Ov5a1BTW24G3DLnCxY75vqzG03pu8pV5U5pdZ
         ga+uD084camyL6J6DMwY/PT58dH0XPnYmSUwZaGkWqTrQf3mhhzCQk1ON7ouWw+BIOgy
         2XDapsZf/Y0+MgMcffzmKjold1YJ6ZKYYNspXKDgGM9X/R1IhqZEmh/5n4rkw/O8SXjJ
         nUDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780900206; x=1781505006;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qDYJ9YnYahbdpvzrWk3FO5n4lndwP1vG0GrraJw28yE=;
        b=IxT4XVy2HrsIRkl8G7pza8Zb53olCF/Z6vikMExZ40auY3Kwqw/xJphlHvzusFsA+f
         ZUbWoRD7H1bQZLGa3FhMljQtI+Csh46vUeEXblIrboMrqijtlh9Y08bWgngDiaG+e+y7
         d/hVYAuufSEdXSxCQkdwBQQxU1ABggjRBuDokdtaOdEttR73Gmy7DDTjlVyGqJJka7Hk
         dy3ypnbbvs9eWebd2KxDPOdg0jm+re1OC2YELAJae1jpE9ivMbdIdM3UP7OHl5jn0C7H
         2tQBd+rj0vGeSjRREP6rZvDv9lPpLAzlcVwrvRxEIXhlopiTlywrmrlhdr7GJypg36gO
         8Uag==
X-Forwarded-Encrypted: i=1; AFNElJ9Cy+1V0m9FHgPjplzNr8x8z3G/4o8PWaE/SWXpocuhsI2vxI69ZlD0APNPSg0SeJHEkYyNH61LLw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8pWkC8JbqeMFgjZgFnO1vhTUSvqseoAN1+tZtpuP3mJOZJkX5
	mKytWsXIgC1xiG0+lGnDF9HNR3eFR91oV8v6D4m7tEvg96oPBuwRNmug
X-Gm-Gg: Acq92OGSFp3E7cPYiVdShWDAwx/QJj/NPEyTdDypfYCoO83fu4dNWF6UXivngkvDYXr
	U89tlVp+lRNFq/TdTupfSTojqweONybWC7dKanC6WLdptz0tA+U2EMxNgRao3pxbEph0ZYsx0UN
	jx/Fe6qoU6UxOyeNQXlmhZWlYDPgwcJawryuWUBaucdvBeX7Abxdi/FpwDyqwujUTpD9MC1fqSR
	DW1kM443PULeppFVBfop230eS4JxrhtehsU3/DV8o2eY99z2P4IVrU7ZrB0lhqkJFgPPicKPfzH
	UkKR8a8HiCnvjKKV/QaCx4kd+b/Ehhk51nfqLhW81329Nh7G1qr5IBTtK7JcaEQ6LzOs1DsnQGn
	UnHQnOcPp//FjYOm0jg4Xym5j0SCL0FLsiufYtxNvUqDhGzXT16/n7bptVZ3Tx4nvtJ830SJP5I
	z5L1Cn+p9ZVW6BLvfrcyoQGV2vM1e43KPyZ61inCs+GMf+r7yj3FfbDIEHnJC4QkAruT4Rs9Mv0
	xE9WHoQn35PYYKzy+jpNa3dGJ1bva38PfqE
X-Received: by 2002:a05:7300:4307:b0:2ce:3aa1:d39b with SMTP id 5a478bee46e88-3077b1e1921mr7540153eec.20.1780900205592;
        Sun, 07 Jun 2026 23:30:05 -0700 (PDT)
Received: from 5163NRD-SPRABHU.ssi.samsung.com (c-73-222-128-44.hsd1.ca.comcast.net. [73.222.128.44])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074dea8708sm16871033eec.15.2026.06.07.23.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 23:30:05 -0700 (PDT)
From: sw.prabhu6@gmail.com
To: axboe@kernel.dk,
	io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	dave@stgolabs.net,
	dongjoo.seo1@samsung.com,
	Swarna Prabhu <sw.prabhu6@gmail.com>,
	Swarna Prabhu <s.prabhu@samsung.com>
Subject: [RFC v1] io_uring/rsrc: add fast path huge page handling in buffer registration
Date: Sun,  7 Jun 2026 23:29:37 -0700
Message-Id: <20260608062937.804758-1-sw.prabhu6@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,stgolabs.net,samsung.com,gmail.com];
	TAGGED_FROM(0.00)[bounces-13637-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:dave@stgolabs.net,m:dongjoo.seo1@samsung.com,m:sw.prabhu6@gmail.com,m:s.prabhu@samsung.com,m:swprabhu6@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER(0.00)[swprabhu6@gmail.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	FROM_NO_DN(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	ALIAS_RESOLVED(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[swprabhu6@gmail.com,io-uring@vger.kernel.org];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,samsung.com:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: DC341653229

From: Swarna Prabhu <sw.prabhu6@gmail.com>

io_uring sqe buffer registration path returns pinned user pages in 4k
granularity. If the first pinned page is in a hugetlb folio and
pages[nr_pages - 1] is also in the same folio then store a single page
entry and report *npages = 1 while dropping nr_pages - 1 of the pin
references it took earlier.

io_uring has support to identify and coalesce multi-hugepage-backed
fixed buffers from the function 'io_check_coalesce_buffer()'. However
we need to iterate over the entire page array and this patch bypasses
the additional checks for this case. The fast path reduces the overall
sqe buffer registration time that are backed by huge pages.

Measured with fio on bare metal backed by 1024 boot-allocated 2MB hugetlb
pages and setting the cpu cores to governor for max performance.
(hugepages=1024,hugepage_size=2M):
  fio --ioengine=io_uring --rw=randwrite --bs=1M --size=2G --iodepth=256
  --direct=1 --numjobs=5 --fixedbufs=1 --registerfiles=1 --iomem=mmaphuge
  --hugepage-size=2M.

Avg across 3 runs:
Metric                          Upstream(7.1-rc1)  Patched    Delta
Reg time(io_sqe_buffer_register): 3797ns            2970ns   -21.8%
Total reg for workload:           14.35ms           11.34ms  -21.9%
fio write bandwidth:              1416MiB/s   1416MiB/s    No regression

Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>
---
 io_uring/memmap.c | 66 +++++++++++++++++++++++++++++++++++++++++++++--
 io_uring/memmap.h |  3 +++
 io_uring/rsrc.c   |  9 +++++--
 3 files changed, 74 insertions(+), 4 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 4f9b439319c4..957e67d2d8e8 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -37,11 +37,11 @@ static bool io_mem_alloc_compound(struct page **pages, int nr_pages,
 	return true;
 }
 
-struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages)
+struct page **io_pin_pages_alloc(unsigned long uaddr, unsigned long len,
+					unsigned long *nr_pages_out)
 {
 	unsigned long start, end, nr_pages;
 	struct page **pages;
-	int ret;
 
 	if (check_add_overflow(uaddr, len, &end))
 		return ERR_PTR(-EOVERFLOW);
@@ -60,6 +60,20 @@ struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages)
 	if (!pages)
 		return ERR_PTR(-ENOMEM);
 
+	*nr_pages_out = nr_pages;
+	return pages;
+}
+
+struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages)
+{
+	unsigned long nr_pages;
+	struct page **pages;
+	int ret;
+
+	pages = io_pin_pages_alloc(uaddr, len, &nr_pages);
+	if (IS_ERR(pages))
+		return pages;
+
 	ret = pin_user_pages_fast(uaddr, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
 					pages);
 	/* success, mapped all pages */
@@ -79,6 +93,54 @@ struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages)
 	return ERR_PTR(ret);
 }
 
+struct page **io_pin_pages_fast_path(unsigned long uaddr, unsigned long len, int *npages)
+{
+	unsigned long nr_pages;
+	struct page **pages;
+	int ret;
+
+	pages = io_pin_pages_alloc(uaddr, len, &nr_pages);
+	if (IS_ERR(pages))
+		return pages;
+
+	ret = pin_user_pages_fast(uaddr, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
+					pages);
+	/* success, mapped all pages */
+	if (ret == nr_pages) {
+		struct folio *folio = page_folio(pages[0]);
+
+		if (nr_pages > 1 && folio_test_hugetlb(folio) &&
+		    page_folio(pages[nr_pages - 1]) == folio) {
+			struct page **huge_pages;
+
+			huge_pages = kvmalloc_objs(struct page *, 1, GFP_KERNEL_ACCOUNT);
+			if (!huge_pages) {
+				*npages = nr_pages;
+				return pages;
+			}
+			unpin_user_folio(folio, nr_pages - 1);
+
+			huge_pages[0] = pages[0];
+			kvfree(pages);
+			pages = huge_pages;
+			*npages = 1;
+		} else {
+			*npages = nr_pages;
+		}
+		return pages;
+	}
+
+	/* partial map, or didn't map anything */
+	if (ret >= 0) {
+		/* if we did partial map, release any pages we did get */
+		if (ret)
+			unpin_user_pages(pages, ret);
+		ret = -EFAULT;
+	}
+	kvfree(pages);
+	return ERR_PTR(ret);
+}
+
 enum {
 	/* memory was vmap'ed for the kernel, freeing the region vunmap's it */
 	IO_REGION_F_VMAP			= 1,
diff --git a/io_uring/memmap.h b/io_uring/memmap.h
index f4cfbb6b9a1f..cc41af3fae61 100644
--- a/io_uring/memmap.h
+++ b/io_uring/memmap.h
@@ -7,7 +7,10 @@
 
 #define IORING_OFF_ZCRX_SHIFT		16
 
+struct page **io_pin_pages_alloc(unsigned long uaddr, unsigned long len,
+					unsigned long *nr_pages_out);
 struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages);
+struct page **io_pin_pages_fast_path(unsigned long uaddr, unsigned long len, int *npages);
 
 #ifndef CONFIG_MMU
 unsigned int io_uring_nommu_mmap_capabilities(struct file *file);
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 650303626be6..e117b10bef0b 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -771,7 +771,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	struct io_rsrc_node *node;
 	unsigned long off;
 	size_t size;
-	int ret, nr_pages, i;
+	int ret, nr_pages, i, orig_nr_pages;
 	struct io_imu_folio_data data;
 	bool coalesced = false;
 
@@ -792,7 +792,10 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 		return ERR_PTR(-ENOMEM);
 
 	ret = -ENOMEM;
-	pages = io_pin_pages((unsigned long) iov->iov_base, iov->iov_len,
+	orig_nr_pages = ((unsigned long)iov->iov_base + iov->iov_len
+			 + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	orig_nr_pages -= (unsigned long)iov->iov_base >> PAGE_SHIFT;
+	pages = io_pin_pages_fast_path((unsigned long) iov->iov_base, iov->iov_len,
 				&nr_pages);
 	if (IS_ERR(pages)) {
 		ret = PTR_ERR(pages);
@@ -826,6 +829,8 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	imu->dir = IO_IMU_DEST | IO_IMU_SOURCE;
 	if (coalesced)
 		imu->folio_shift = data.folio_shift;
+	else if (nr_pages == 1 && orig_nr_pages > 1)
+		imu->folio_shift = folio_shift(page_folio(pages[0]));
 	refcount_set(&imu->refs, 1);
 
 	off = (unsigned long)iov->iov_base & ~PAGE_MASK;
-- 
2.39.5



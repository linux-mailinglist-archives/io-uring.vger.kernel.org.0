Return-Path: <io-uring+bounces-13075-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aCQFAOuA52k+9gEAu9opvQ
	(envelope-from <io-uring+bounces-13075-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 15:51:39 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FC9343B8F0
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 15:51:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B074E3018761
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 13:46:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 028313D6479;
	Tue, 21 Apr 2026 13:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUhEpKjl"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7123D5660
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 13:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776779180; cv=none; b=kViZ72/4kNvt3oqOU61JyQZkoShiBBHAlVD2wQQ0C0pKVBBrDgsG/bYjlIOJ1lvrJ6cmJza+Xl+rvlxJanMSYk9CCy8SC0bSpcFVqLWavsiNlOnJO6BqI2Mf4MtXS8v18O0sTBhbvdrt2hDIlXHe2eMKkXxPvUWMbs8XUuLsfjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776779180; c=relaxed/simple;
	bh=uh1kH9lkjpqDoMi02GwHRmEPnnrXT4Y7PqRxPaMsKA4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cU+HrVleLF6AtrWPH1k7Ua2/h8s1qAIcZJFRJoDXqkOv2dxpasZYFtyTXTIwkGaQ5zJZUNQ5M+3T5sNAA3Xk9T9v20v43FaK4W8KsK4Qp7bzrnZGK85xVuR1dhZzuDto01IB+xBTtvtEMjEWTcXsigQz5enBy3Ke7qXaR8RpWU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUhEpKjl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163A4C2BCB3;
	Tue, 21 Apr 2026 13:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776779180;
	bh=uh1kH9lkjpqDoMi02GwHRmEPnnrXT4Y7PqRxPaMsKA4=;
	h=From:To:Cc:Subject:Date:From;
	b=tUhEpKjlU5aY5S9537ZwUGgdroXtX1BaTFakpf9usmXGUIhuxjIxdPWUGmzf5zHq8
	 UVT9fE+vPKvBpQH9Yfe+zrl9zuqeTvdaLGNGDFAIzYv+Imv4qviT6d5OdXUv5p2M0D
	 l4HWjn7tkOLCPbXip+Aw5tO85NTTzJxP6B5LuEEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: io-uring@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: take page references for NOMMU pbuf_ring mmaps
Date: Tue, 21 Apr 2026 15:46:16 +0200
Message-ID: <2026042115-body-attention-d15b@gregkh>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Lines: 135
X-Developer-Signature: v=1; a=openpgp-sha256; l=5501; i=gregkh@linuxfoundation.org; h=from:subject:message-id; bh=uh1kH9lkjpqDoMi02GwHRmEPnnrXT4Y7PqRxPaMsKA4=; b=owGbwMvMwCRo6H6F97bub03G02pJDJnP65cb+fW+duC2jwx936/wxeXg0aD/LB8vW1mwXVioM P0r/9t5HbEsDIJMDLJiiixftvEc3V9xSNHL0PY0zBxWJpAhDFycAjCRIkOGBV3xkkzG+mrJIYre n37MsJB78vPYa4YFmz7usYyR2rUrdL141Aup7ceflB+RBQA=
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [2.84 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linuxfoundation.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[linuxfoundation.org:s=korg];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-13075-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gregkh@linuxfoundation.org,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linuxfoundation.org:+];
	NEURAL_HAM(-0.00)[-0.996];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linuxfoundation.org:dkim,linuxfoundation.org:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:email]
X-Rspamd-Queue-Id: 4FC9343B8F0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Under !CONFIG_MMU, io_uring_get_unmapped_area() returns the kernel
virtual address of the io_mapped_region's backing pages directly;
the user's VMA aliases the kernel allocation. io_uring_mmap() then
just returns 0 -- it takes no page references.

The CONFIG_MMU path uses vm_insert_pages(), which takes a reference on
each inserted page.  Those references are released when the VMA is torn
down (zap_pte_range -> put_page). io_free_region() -> release_pages()
drops the io_uring-side references, but the pages survive until munmap
drops the VMA-side references.

Under NOMMU there are no VMA-side references. io_unregister_pbuf_ring ->
io_put_bl -> io_free_region -> release_pages drops the only references
and the pages return to the buddy allocator while the user's VMA still
has vm_start pointing into them.  The user can then write into whatever
the allocator hands out next.

Mirror the MMU lifetime: take get_page references in io_uring_mmap() and
release them via vm_ops->close.  NOMMU's delete_vma() calls vma_close()
which runs ->close on munmap. If the region was unregistered between
mmap and munmap (region->pages is NULL after io_free_region's memset),
walk the VMA address range instead -- the pages are still live (our refs
kept them) and virt_to_page recovers them.

This also incidentally addresses the duplicate-vm_start case: two mmaps
of SQ_RING and CQ_RING resolve to the same ctx->ring_region pointer.
With page refs taken per mmap, the second mmap takes its own refs and
the pages survive until both mmaps are closed.  The nommu rb-tree BUG_ON
on duplicate vm_start is a separate mm/nommu.c concern (it should share
the existing region rather than BUG), but the page lifetime is now
correct.

Cc: Jens Axboe <axboe@kernel.dk>
Reported-by: Anthropic
Assisted-by: gkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Note, I have no way of testing this, I'm only forwarding this on because
I got the bug report and was able to generate something that "seems"
correct, but it might be a total load of crap here, my knowledge of the
vm layer is very low so take this for where it is coming from (i.e. a
non-deterministic pattern matching system.)

I do have another patch that just disables io_uring for !MMU systems, if
you want that instead?  Or is this feature something that !MMU devices
actually care about?


 io_uring/memmap.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 68 insertions(+), 1 deletion(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index e6958968975a..6818e9abf3b3 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -366,9 +366,76 @@ unsigned long io_uring_get_unmapped_area(struct file *filp, unsigned long addr,
 
 #else /* !CONFIG_MMU */
 
+/*
+ * Under NOMMU, get_unmapped_area returns the kernel virtual address of
+ * the io_mapped_region's backing pages directly -- the user's VMA
+ * aliases the kernel allocation rather than holding its own copy or
+ * page-table entries. The CONFIG_MMU path's vm_insert_pages() takes
+ * page references that survive until munmap; this path takes none, so
+ * io_unregister_pbuf_ring() -> io_free_region() -> release_pages()
+ * frees the pages while the user's VMA still maps them. The user can
+ * then write into whatever the buddy allocator hands out next.
+ *
+ * Mirror the MMU lifetime by taking page references in io_uring_mmap()
+ * and releasing them in vm_ops->close. We re-derive the region from
+ * vm_pgoff (same lookup get_unmapped_area used) so we know which pages
+ * to grab.
+ */
+
+static void io_uring_nommu_vm_close(struct vm_area_struct *vma)
+{
+	struct io_ring_ctx *ctx = vma->vm_file->private_data;
+	struct io_mapped_region *region;
+	unsigned long i;
+
+	guard(mutex)(&ctx->mmap_lock);
+	region = io_mmap_get_region(ctx, vma->vm_pgoff);
+	/*
+	 * The region may have been unregistered (memset to zero in
+	 * io_free_region()) between mmap and munmap. The page refs we
+	 * took in io_uring_mmap() are what kept the pages alive; release
+	 * them via the VMA range since the region->pages array is gone.
+	 */
+	if (region && region->pages) {
+		for (i = 0; i < region->nr_pages; i++)
+			put_page(region->pages[i]);
+	} else {
+		/* Region cleared; walk the VMA range. */
+		unsigned long a;
+
+		for (a = vma->vm_start; a < vma->vm_end; a += PAGE_SIZE)
+			put_page(virt_to_page((void *)a));
+	}
+}
+
+static const struct vm_operations_struct io_uring_nommu_vm_ops = {
+	.close = io_uring_nommu_vm_close,
+};
+
 int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	return is_nommu_shared_mapping(vma->vm_flags) ? 0 : -EINVAL;
+	struct io_ring_ctx *ctx = file->private_data;
+	struct io_mapped_region *region;
+	unsigned long i;
+
+	if (!is_nommu_shared_mapping(vma->vm_flags))
+		return -EINVAL;
+
+	guard(mutex)(&ctx->mmap_lock);
+	region = io_mmap_get_region(ctx, vma->vm_pgoff);
+	if (!region || !io_region_is_set(region))
+		return -EINVAL;
+
+	/*
+	 * Pin the pages so io_free_region()'s release_pages() does not
+	 * drop the last reference while this VMA exists. delete_vma()
+	 * in mm/nommu.c calls vma_close() which runs ->close above.
+	 */
+	for (i = 0; i < region->nr_pages; i++)
+		get_page(region->pages[i]);
+
+	vma->vm_ops = &io_uring_nommu_vm_ops;
+	return 0;
 }
 
 unsigned int io_uring_nommu_mmap_capabilities(struct file *file)
-- 
2.53.0



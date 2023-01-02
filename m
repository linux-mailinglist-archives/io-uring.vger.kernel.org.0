Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6806A65B4CD
	for <lists+io-uring@lfdr.de>; Mon,  2 Jan 2023 17:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236490AbjABQJv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Jan 2023 11:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236472AbjABQJt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Jan 2023 11:09:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36EC5BF2
        for <io-uring@vger.kernel.org>; Mon,  2 Jan 2023 08:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672675749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/KmBUrtOn1BMOkdcQJmrOKgCHuRXJmWehWSjwC/MXzU=;
        b=daJhQqnQ3LcDFF1M+OEvkNH4s4RDWQ1FRAmOlCXMSQgVvAGibXEE0+4lowavQtAwj+LJLi
        qFsnDmyp3uH6sLRn2ZWZ0cBE8Doz4Y70C1PIFe7REJXY2o9TRvOkbf5i9xqaEvqMmBRPl/
        s/WcJU6+K5Frit837hWLr9/27HA6R7s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-xSeEzPZEPJqZEG66yU6B_Q-1; Mon, 02 Jan 2023 11:09:06 -0500
X-MC-Unique: xSeEzPZEPJqZEG66yU6B_Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD3461C08792;
        Mon,  2 Jan 2023 16:09:05 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.193.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F4E751EF;
        Mon,  2 Jan 2023 16:09:03 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Pitre <nico@fluxnic.net>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH mm-unstable v1 2/3] mm/nommu: don't use VM_MAYSHARE for MAP_PRIVATE mappings
Date:   Mon,  2 Jan 2023 17:08:55 +0100
Message-Id: <20230102160856.500584-3-david@redhat.com>
In-Reply-To: <20230102160856.500584-1-david@redhat.com>
References: <20230102160856.500584-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Let's stop using VM_MAYSHARE for MAP_PRIVATE mappings and use VM_MAYOVERLAY
instead. Rewrite determine_vm_flags() to make the whole logic easier to
digest, and to cleanly separate MAP_PRIVATE vs. MAP_SHARED.

No functional change intended.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h |  7 ++++++-
 mm/nommu.c         | 51 +++++++++++++++++++++++++++-------------------
 2 files changed, 36 insertions(+), 22 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 28568a92e5df..510f2e7cccdb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -276,7 +276,12 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_MAYSHARE	0x00000080
 
 #define VM_GROWSDOWN	0x00000100	/* general info on the segment */
+#ifdef CONFIG_MMU
 #define VM_UFFD_MISSING	0x00000200	/* missing pages tracking */
+#else /* CONFIG_MMU */
+#define VM_MAYOVERLAY	0x00000200	/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
+#define VM_UFFD_MISSING	0
+#endif /* CONFIG_MMU */
 #define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
 #define VM_UFFD_WP	0x00001000	/* wrprotect pages tracking */
 
@@ -1358,7 +1363,7 @@ static inline bool is_nommu_shared_mapping(vm_flags_t flags)
 	 * ptrace does not apply. Note that there is no mprotect() to upgrade
 	 * write permissions later.
 	 */
-	return flags & VM_MAYSHARE;
+	return flags & (VM_MAYSHARE | VM_MAYOVERLAY);
 }
 #endif
 
diff --git a/mm/nommu.c b/mm/nommu.c
index 6c4bdc07a776..5c628c868648 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -892,29 +892,36 @@ static unsigned long determine_vm_flags(struct file *file,
 	unsigned long vm_flags;
 
 	vm_flags = calc_vm_prot_bits(prot, 0) | calc_vm_flag_bits(flags);
-	/* vm_flags |= mm->def_flags; */
 
-	if (!(capabilities & NOMMU_MAP_DIRECT)) {
-		/* attempt to share read-only copies of mapped file chunks */
+	if (!file) {
+		/*
+		 * MAP_ANONYMOUS. MAP_SHARED is mapped to MAP_PRIVATE, because
+		 * there is no fork().
+		 */
 		vm_flags |= VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC;
-		if (file && !(prot & PROT_WRITE))
-			vm_flags |= VM_MAYSHARE;
+	} else if (flags & MAP_PRIVATE) {
+		/* MAP_PRIVATE file mapping */
+		if (capabilities & NOMMU_MAP_DIRECT)
+			vm_flags |= (capabilities & NOMMU_VMFLAGS);
+		else
+			vm_flags |= VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC;
+
+		if (!(prot & PROT_WRITE) && !current->ptrace)
+			/*
+			 * R/O private file mapping which cannot be used to
+			 * modify memory, especially also not via active ptrace
+			 * (e.g., set breakpoints) or later by upgrading
+			 * permissions (no mprotect()). We can try overlaying
+			 * the file mapping, which will work e.g., on chardevs,
+			 * ramfs/tmpfs/shmfs and romfs/cramf.
+			 */
+			vm_flags |= VM_MAYOVERLAY;
 	} else {
-		/* overlay a shareable mapping on the backing device or inode
-		 * if possible - used for chardevs, ramfs/tmpfs/shmfs and
-		 * romfs/cramfs */
-		vm_flags |= VM_MAYSHARE | (capabilities & NOMMU_VMFLAGS);
-		if (flags & MAP_SHARED)
-			vm_flags |= VM_SHARED;
+		/* MAP_SHARED file mapping: NOMMU_MAP_DIRECT is set. */
+		vm_flags |= VM_SHARED | VM_MAYSHARE |
+			    (capabilities & NOMMU_VMFLAGS);
 	}
 
-	/* refuse to let anyone share private mappings with this process if
-	 * it's being traced - otherwise breakpoints set in it may interfere
-	 * with another untraced process
-	 */
-	if ((flags & MAP_PRIVATE) && current->ptrace)
-		vm_flags &= ~VM_MAYSHARE;
-
 	return vm_flags;
 }
 
@@ -952,9 +959,11 @@ static int do_mmap_private(struct vm_area_struct *vma,
 	void *base;
 	int ret, order;
 
-	/* invoke the file's mapping function so that it can keep track of
-	 * shared mappings on devices or memory
-	 * - VM_MAYSHARE will be set if it may attempt to share
+	/*
+	 * Invoke the file's mapping function so that it can keep track of
+	 * shared mappings on devices or memory. VM_MAYOVERLAY will be set if
+	 * it may attempt to share, which will make is_nommu_shared_mapping()
+	 * happy.
 	 */
 	if (capabilities & NOMMU_MAP_DIRECT) {
 		ret = call_mmap(vma->vm_file, vma);
-- 
2.39.0


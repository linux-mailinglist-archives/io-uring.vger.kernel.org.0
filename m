Return-Path: <io-uring+bounces-13468-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +HV/CGktDmoK7wUAu9opvQ
	(envelope-from <io-uring+bounces-13468-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 23:53:45 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D8DB59B6D7
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 23:53:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0B4BF3144016
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 20:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE1CC378821;
	Wed, 20 May 2026 20:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="W/Fc4D31"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BCB374169
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 20:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779310245; cv=none; b=XaUtZPgUUg8SNJCrkGDxSkdBaqNIrsse33Fg4E5x1qfEgedWfr0l5Nt5QVV3TSyn2Zk8hBabFFbyAZCsSy2V5l6SLb55fpdVm4eyC2eCi0kbJE+USrY993ekEiZDX3Hd42DWVZJZwcAjjSKz8/4ynmFRdilA82SmJEyr0ggutxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779310245; c=relaxed/simple;
	bh=JzPEBxOc5uLYO+ALFu5mYnofmzvhYRoxUfHP+iRDfKc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oUlYHhbKHXunrxDr+Kb5cMOz/Jp5aksvO7ZXN9RhwzBhD/Q1p2pqc1oSU6e8pQONYalMCcaZnoBJgj9jo/B3nyjLQFnYhzEUu3sHf2KkQzGr12XCp26QRzAZcOPbkaF65Ng1swGFlsxuxEg1VT2d6RdSh1jrpl5izzdERbgyosk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=W/Fc4D31; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KKNx6O506256
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 16:50:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=ffJ2
	JJSKQVzdHRhijG2w6dxdoknMDsdke9qLMqnWpks=; b=W/Fc4D31vRqCN3cO4jiE
	O9tkJZzBanaFHDsvBZnN4bSf+oqjUQ5WkPh+/nlPxP1ife3OtDV1s201eBD4xCaX
	EOyM+PIgbyPl5oB4EEetTGEq3CKYLOEzVvyWFKK0XZMDPcskKiKyc1Om+RbJjKBx
	u8+Arrrckm2jbgidqVt8GZb/AIR3KsfeGHFHIkbr0gtRjqrzluYG5tAsE4Tanc9Z
	zOaIYsiG0Oh8zKOdM+sUv4I3Bk6Gbz322ysRCtVeAxCad7iOhpED79Xob+cU3nqW
	V1LvXqiADQcxchodCvqj7J9Q5FwUDwZfdLvzdNeNnECSRFNdecQccpvmA0qKiMKl
	1g==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4e9a0bd1sh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 16:50:35 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-90d02857cdfso1176512085a.2
        for <io-uring@vger.kernel.org>; Wed, 20 May 2026 13:50:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310235; x=1779915035;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ffJ2JJSKQVzdHRhijG2w6dxdoknMDsdke9qLMqnWpks=;
        b=DIno9m79iqjBQnZzk9rPZN3pzatE6+O9vzTDmv4fMQAbYO7ybjxjO1w7o84NBhIgD9
         0Kq2AK7sSWkyp5M2xibCunPRK9fjJ5HLRUr8tiGbZuUS9TFEwDDkWudJTFKNM84Fjin3
         A4f5+pMV9EjcH4v9kIGS9WHrGvH/o3Tutpb2atdXKNL2gFzVuLc7BAzDGMvVUF8bWkRV
         tk8o31VaVRgtnXh+cbs7XtLOsMOqke1XyDRSdfPqLUfR+54z/8DKWHyy/L8y4wI7ZSLd
         KkBFWr35pIN0GqYW/zhwEdTOTpY94eVpa77FQ0548aVX7LEfVM3vPL83FJ7aOpIOW5Wq
         36lA==
X-Forwarded-Encrypted: i=1; AFNElJ8izpTKhX7B75kLaB/gDvf4JGxlPps72TE4HvMzH4U57NtbqffY2f5F9c39PWbR71S9p4oaLaamZA==@vger.kernel.org
X-Gm-Message-State: AOJu0YypbF467AW3lt5NPw1vW4TKeSCt2C4WZM2nXzEF1yu/0o7LKSbN
	4nv31ZSvZvOYGMeYPjR8P9OhOIkKHV3oyfctADHxYCrArKtJvzF6KN4vxIqzJnzwU5rUCQVpJTS
	AQNeyDkMWabY9qvjQ1Fs/hEiPnhoLTS1Ea889jYge8FIWSsdK/RAXC4pg
X-Gm-Gg: Acq92OFUVN830rmN0QJnbuk2cZSQi93oRbhUccVOg6+D7vFGMpQ3KywBXrYtNvR6N/l
	SqrTF1K0aD6vorZuSLWn623rwjdbF8rfI8rjDwU3gViV+Za1uJ1dpFLFsBetk3EfeuVTspwP+zM
	mNmxZMOMDEarPPmg/zbPdZPSepuJnw5zXcTkShuXwZfCs2tUmXMeuuNYNpTvYB05SnRcj5m0EoK
	vWzX37DL68/h3gcJFOnUfFCLytnB2KOxohkH5ls3+K6TFvDXoq7jXyMRv4lz9BhqE7fRGAWTDeT
	Oe8lqEZgpRGstDc8zjB8BgPCqe4du7o5UygHLjBTKOjxc9eAHyqDj7zSBGAk+DZNUYV+TtauVyp
	KSCTz6/E0y9JDy5O0T+CvnPmRijeYQYIygDmEKxfMnYpymd0OOsHbTIVGMG+v8ewWLyY=
X-Received: by 2002:a05:620a:950f:b0:912:1206:ddc3 with SMTP id af79cd13be357-9121206e06emr2819137485a.26.1779310234303;
        Wed, 20 May 2026 13:50:34 -0700 (PDT)
X-Received: by 2002:a05:620a:950f:b0:912:1206:ddc3 with SMTP id af79cd13be357-9121206e06emr2819134585a.26.1779310233678;
        Wed, 20 May 2026 13:50:33 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bcf37274sm2232692085a.37.2026.05.20.13.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 13:50:33 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 20 May 2026 16:48:54 -0400
Subject: [PATCH RFC 03/11] folio_wait: move folio bit-lock and wait
 declarations to include/linux/folio_wait.h
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-filemap-split-v1-3-c36ddc2b6cf2@columbia.edu>
References: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
In-Reply-To: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779310229; l=12875;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=JzPEBxOc5uLYO+ALFu5mYnofmzvhYRoxUfHP+iRDfKc=;
 b=oKMCnu1WDCEIQovrQVPCgWvWiT5h4hdabCbpif7zEJlr8N56Mg5qWQhk3F5szAwn3Z0gBo3Wg
 0+m1hXVGY60CEfAZMYtlZBI3W1WCOQkn9X0W5SEZhF3iJoBXoSnunof
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: GrxTgIbw_TfkDyMqTjZIMBUQIeUfZJR7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDIwMyBTYWx0ZWRfX0k4G+RbBmglA
 DlAsffYrE1iyUQGvySZNrPF+X+cwG3ExVa24SGHT4m2o/HKxNMkrnqT+xrTlkpdmaJDzAq2c9sc
 HLHuh7h5c3O00bbqBbgiG1Com2B6GFKoyw0UukN66p4uxblhH6rQhWD9BoxM1DCaFgm/7Nbx2ui
 pqrYPDmBnmOKeYAbKnFUUnA+8KmzhD62fTglN0gFM90mROHWCg5aQGIAJy49dR3cAM+Qsr35Otz
 6F94QvsAA3fpAsu++asvPYCSNh4PcXHks8UUTB3KpMxekK1LXC/Lhs5GnW6dCrBS6mWb1fQqf2A
 wNj01uAmgCRIR04bkccmcpTDrrd36NW4+VJ+IJ+xofYYvnc2V6NiG/8qZuZ5jSZ7ZP9GvLC7Ym8
 ng4sRtsn/JFhjJ8OZWGOmd8ADh5vA0DTgZsPDetLsDbmGfz9sAof/tKQ5JCLuvTPt684hFNSxOW
 rYWa24kQvT6f7BbMWsA==
X-Proofpoint-ORIG-GUID: GrxTgIbw_TfkDyMqTjZIMBUQIeUfZJR7
X-Authority-Analysis: v=2.4 cv=KLJqylFo c=1 sm=1 tr=0 ts=6a0e1e9b cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=DRKH7QcZ0YB8km8p46MA:9 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11792
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 priorityscore=1501 malwarescore=0 adultscore=0 clxscore=1015
 bulkscore=10 phishscore=0 suspectscore=0 lowpriorityscore=10 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605200203
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[columbia.edu,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[columbia.edu:s=pps01];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13468-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	DKIM_TRACE(0.00)[columbia.edu:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tz2294@columbia.edu,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 3D8DB59B6D7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Move ~150 lines of folio bit-lock and wait queue infrastructure from
pagemap.h to folio_wait.h. pagemap.h includes the new header so existing
users don't break.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/folio_wait.h | 181 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pagemap.h    | 172 +-----------------------------------------
 mm/folio_wait.c            |   2 +-
 3 files changed, 183 insertions(+), 172 deletions(-)

diff --git a/include/linux/folio_wait.h b/include/linux/folio_wait.h
new file mode 100644
index 000000000000..80ddf1ffcae4
--- /dev/null
+++ b/include/linux/folio_wait.h
@@ -0,0 +1,181 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_FOLIO_WAIT_H
+#define _LINUX_FOLIO_WAIT_H
+
+#include <linux/bitops.h>
+#include <linux/page-flags.h>
+#include <linux/wait.h>
+
+struct wait_page_key {
+	struct folio *folio;
+	int bit_nr;
+	int page_match;
+};
+
+struct wait_page_queue {
+	struct folio *folio;
+	int bit_nr;
+	wait_queue_entry_t wait;
+};
+
+static inline bool wake_page_match(struct wait_page_queue *wait_page,
+				  struct wait_page_key *key)
+{
+	if (wait_page->folio != key->folio)
+	       return false;
+	key->page_match = 1;
+
+	if (wait_page->bit_nr != key->bit_nr)
+		return false;
+
+	return true;
+}
+
+void __folio_lock(struct folio *folio);
+int __folio_lock_killable(struct folio *folio);
+vm_fault_t __folio_lock_or_retry(struct folio *folio, struct vm_fault *vmf);
+void unlock_page(struct page *page);
+void folio_unlock(struct folio *folio);
+
+/**
+ * folio_trylock() - Attempt to lock a folio.
+ * @folio: The folio to attempt to lock.
+ *
+ * Sometimes it is undesirable to wait for a folio to be unlocked (eg
+ * when the locks are being taken in the wrong order, or if making
+ * progress through a batch of folios is more important than processing
+ * them in order).  Usually folio_lock() is the correct function to call.
+ *
+ * Context: Any context.
+ * Return: Whether the lock was successfully acquired.
+ */
+static inline bool folio_trylock(struct folio *folio)
+{
+	return likely(!test_and_set_bit_lock(PG_locked, folio_flags(folio, 0)));
+}
+
+/*
+ * Return true if the page was successfully locked
+ */
+static inline bool trylock_page(struct page *page)
+{
+	return folio_trylock(page_folio(page));
+}
+
+/**
+ * folio_lock() - Lock this folio.
+ * @folio: The folio to lock.
+ *
+ * The folio lock protects against many things, probably more than it
+ * should.  It is primarily held while a folio is being brought uptodate,
+ * either from its backing file or from swap.  It is also held while a
+ * folio is being truncated from its address_space, so holding the lock
+ * is sufficient to keep folio->mapping stable.
+ *
+ * The folio lock is also held while write() is modifying the page to
+ * provide POSIX atomicity guarantees (as long as the write does not
+ * cross a page boundary).  Other modifications to the data in the folio
+ * do not hold the folio lock and can race with writes, eg DMA and stores
+ * to mapped pages.
+ *
+ * Context: May sleep.  If you need to acquire the locks of two or
+ * more folios, they must be in order of ascending index, if they are
+ * in the same address_space.  If they are in different address_spaces,
+ * acquire the lock of the folio which belongs to the address_space which
+ * has the lowest address in memory first.
+ */
+static inline void folio_lock(struct folio *folio)
+{
+	might_sleep();
+	if (!folio_trylock(folio))
+		__folio_lock(folio);
+}
+
+/**
+ * lock_page() - Lock the folio containing this page.
+ * @page: The page to lock.
+ *
+ * See folio_lock() for a description of what the lock protects.
+ * This is a legacy function and new code should probably use folio_lock()
+ * instead.
+ *
+ * Context: May sleep.  Pages in the same folio share a lock, so do not
+ * attempt to lock two pages which share a folio.
+ */
+static inline void lock_page(struct page *page)
+{
+	struct folio *folio;
+	might_sleep();
+
+	folio = page_folio(page);
+	if (!folio_trylock(folio))
+		__folio_lock(folio);
+}
+
+/**
+ * folio_lock_killable() - Lock this folio, interruptible by a fatal signal.
+ * @folio: The folio to lock.
+ *
+ * Attempts to lock the folio, like folio_lock(), except that the sleep
+ * to acquire the lock is interruptible by a fatal signal.
+ *
+ * Context: May sleep; see folio_lock().
+ * Return: 0 if the lock was acquired; -EINTR if a fatal signal was received.
+ */
+static inline int folio_lock_killable(struct folio *folio)
+{
+	might_sleep();
+	if (!folio_trylock(folio))
+		return __folio_lock_killable(folio);
+	return 0;
+}
+
+/*
+ * folio_lock_or_retry - Lock the folio, unless this would block and the
+ * caller indicated that it can handle a retry.
+ *
+ * Return value and mmap_lock implications depend on flags; see
+ * __folio_lock_or_retry().
+ */
+static inline vm_fault_t folio_lock_or_retry(struct folio *folio,
+					     struct vm_fault *vmf)
+{
+	might_sleep();
+	if (!folio_trylock(folio))
+		return __folio_lock_or_retry(folio, vmf);
+	return 0;
+}
+
+/*
+ * This is exported only for folio_wait_locked/folio_wait_writeback, etc.,
+ * and should not be used directly.
+ */
+void folio_wait_bit(struct folio *folio, int bit_nr);
+int folio_wait_bit_killable(struct folio *folio, int bit_nr);
+
+/*
+ * Wait for a folio to be unlocked.
+ *
+ * This must be called with the caller "holding" the folio,
+ * ie with increased folio reference count so that the folio won't
+ * go away during the wait.
+ */
+static inline void folio_wait_locked(struct folio *folio)
+{
+	if (folio_test_locked(folio))
+		folio_wait_bit(folio, PG_locked);
+}
+
+static inline int folio_wait_locked_killable(struct folio *folio)
+{
+	if (!folio_test_locked(folio))
+		return 0;
+	return folio_wait_bit_killable(folio, PG_locked);
+}
+
+void folio_end_read(struct folio *folio, bool success);
+void folio_end_private_2(struct folio *folio);
+void folio_wait_private_2(struct folio *folio);
+int folio_wait_private_2_killable(struct folio *folio);
+
+#endif /* _LINUX_FOLIO_WAIT_H */
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 627771e82eb1..7f65c2b0097b 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -15,6 +15,7 @@
 #include <linux/bitops.h>
 #include <linux/hardirq.h> /* for in_interrupt() */
 #include <linux/hugetlb_inline.h>
+#include <linux/folio_wait.h>
 
 struct folio_batch;
 
@@ -1072,174 +1073,6 @@ static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
 	return pgoff;
 }
 
-struct wait_page_key {
-	struct folio *folio;
-	int bit_nr;
-	int page_match;
-};
-
-struct wait_page_queue {
-	struct folio *folio;
-	int bit_nr;
-	wait_queue_entry_t wait;
-};
-
-static inline bool wake_page_match(struct wait_page_queue *wait_page,
-				  struct wait_page_key *key)
-{
-	if (wait_page->folio != key->folio)
-	       return false;
-	key->page_match = 1;
-
-	if (wait_page->bit_nr != key->bit_nr)
-		return false;
-
-	return true;
-}
-
-void __folio_lock(struct folio *folio);
-int __folio_lock_killable(struct folio *folio);
-vm_fault_t __folio_lock_or_retry(struct folio *folio, struct vm_fault *vmf);
-void unlock_page(struct page *page);
-void folio_unlock(struct folio *folio);
-
-/**
- * folio_trylock() - Attempt to lock a folio.
- * @folio: The folio to attempt to lock.
- *
- * Sometimes it is undesirable to wait for a folio to be unlocked (eg
- * when the locks are being taken in the wrong order, or if making
- * progress through a batch of folios is more important than processing
- * them in order).  Usually folio_lock() is the correct function to call.
- *
- * Context: Any context.
- * Return: Whether the lock was successfully acquired.
- */
-static inline bool folio_trylock(struct folio *folio)
-{
-	return likely(!test_and_set_bit_lock(PG_locked, folio_flags(folio, 0)));
-}
-
-/*
- * Return true if the page was successfully locked
- */
-static inline bool trylock_page(struct page *page)
-{
-	return folio_trylock(page_folio(page));
-}
-
-/**
- * folio_lock() - Lock this folio.
- * @folio: The folio to lock.
- *
- * The folio lock protects against many things, probably more than it
- * should.  It is primarily held while a folio is being brought uptodate,
- * either from its backing file or from swap.  It is also held while a
- * folio is being truncated from its address_space, so holding the lock
- * is sufficient to keep folio->mapping stable.
- *
- * The folio lock is also held while write() is modifying the page to
- * provide POSIX atomicity guarantees (as long as the write does not
- * cross a page boundary).  Other modifications to the data in the folio
- * do not hold the folio lock and can race with writes, eg DMA and stores
- * to mapped pages.
- *
- * Context: May sleep.  If you need to acquire the locks of two or
- * more folios, they must be in order of ascending index, if they are
- * in the same address_space.  If they are in different address_spaces,
- * acquire the lock of the folio which belongs to the address_space which
- * has the lowest address in memory first.
- */
-static inline void folio_lock(struct folio *folio)
-{
-	might_sleep();
-	if (!folio_trylock(folio))
-		__folio_lock(folio);
-}
-
-/**
- * lock_page() - Lock the folio containing this page.
- * @page: The page to lock.
- *
- * See folio_lock() for a description of what the lock protects.
- * This is a legacy function and new code should probably use folio_lock()
- * instead.
- *
- * Context: May sleep.  Pages in the same folio share a lock, so do not
- * attempt to lock two pages which share a folio.
- */
-static inline void lock_page(struct page *page)
-{
-	struct folio *folio;
-	might_sleep();
-
-	folio = page_folio(page);
-	if (!folio_trylock(folio))
-		__folio_lock(folio);
-}
-
-/**
- * folio_lock_killable() - Lock this folio, interruptible by a fatal signal.
- * @folio: The folio to lock.
- *
- * Attempts to lock the folio, like folio_lock(), except that the sleep
- * to acquire the lock is interruptible by a fatal signal.
- *
- * Context: May sleep; see folio_lock().
- * Return: 0 if the lock was acquired; -EINTR if a fatal signal was received.
- */
-static inline int folio_lock_killable(struct folio *folio)
-{
-	might_sleep();
-	if (!folio_trylock(folio))
-		return __folio_lock_killable(folio);
-	return 0;
-}
-
-/*
- * folio_lock_or_retry - Lock the folio, unless this would block and the
- * caller indicated that it can handle a retry.
- *
- * Return value and mmap_lock implications depend on flags; see
- * __folio_lock_or_retry().
- */
-static inline vm_fault_t folio_lock_or_retry(struct folio *folio,
-					     struct vm_fault *vmf)
-{
-	might_sleep();
-	if (!folio_trylock(folio))
-		return __folio_lock_or_retry(folio, vmf);
-	return 0;
-}
-
-/*
- * This is exported only for folio_wait_locked/folio_wait_writeback, etc.,
- * and should not be used directly.
- */
-void folio_wait_bit(struct folio *folio, int bit_nr);
-int folio_wait_bit_killable(struct folio *folio, int bit_nr);
-
-/* 
- * Wait for a folio to be unlocked.
- *
- * This must be called with the caller "holding" the folio,
- * ie with increased folio reference count so that the folio won't
- * go away during the wait.
- */
-static inline void folio_wait_locked(struct folio *folio)
-{
-	if (folio_test_locked(folio))
-		folio_wait_bit(folio, PG_locked);
-}
-
-static inline int folio_wait_locked_killable(struct folio *folio)
-{
-	if (!folio_test_locked(folio))
-		return 0;
-	return folio_wait_bit_killable(folio, PG_locked);
-}
-
-void folio_end_read(struct folio *folio, bool success);
 void wait_on_page_writeback(struct page *page);
 void folio_wait_writeback(struct folio *folio);
 int folio_wait_writeback_killable(struct folio *folio);
@@ -1268,9 +1101,6 @@ int filemap_migrate_folio(struct address_space *mapping, struct folio *dst,
 #else
 #define filemap_migrate_folio NULL
 #endif
-void folio_end_private_2(struct folio *folio);
-void folio_wait_private_2(struct folio *folio);
-int folio_wait_private_2_killable(struct folio *folio);
 
 /*
  * Fault in userspace address range.
diff --git a/mm/folio_wait.c b/mm/folio_wait.c
index 18b42488ce37..06156e138c09 100644
--- a/mm/folio_wait.c
+++ b/mm/folio_wait.c
@@ -8,7 +8,7 @@
 #include <linux/mm.h>
 #include <linux/swap.h>
 #include <linux/leafops.h>
-#include <linux/pagemap.h>
+#include <linux/folio_wait.h>
 #include <linux/wait.h>
 #include <linux/hash.h>
 #include <linux/sysctl.h>

-- 
2.39.5



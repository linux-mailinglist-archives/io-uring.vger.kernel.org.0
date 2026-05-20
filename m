Return-Path: <io-uring+bounces-13467-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QHcrJ+weDmpd6QUAu9opvQ
	(envelope-from <io-uring+bounces-13467-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 22:51:56 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 439A859A382
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 22:51:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EC8D0305A75F
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 20:51:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1992C3783A2;
	Wed, 20 May 2026 20:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="CxuJGpWL"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7A7376A0C
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 20:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779310244; cv=none; b=cf8f/lmzNKfxJqz7DDdBn7nDdIppk/VPJnXiK/0ZkIqDsLQk1WqLAKBfHyKrImQQzrbYqxDzJWEDGcpcYSUaQ39veD/m2ID+8A3j2uDscmdOE7ZJh5HYHEi2v5a0DTvARmriN4+FaA6Kizy9g6ZhHQOhGo6+UMjqmc+ImHeI2L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779310244; c=relaxed/simple;
	bh=MdnqSRc2FJHBhrARlYsy3cs/9UevS5fEoCvn0pE0sDw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PZvn8pP+mtScrMNgzNfDtpOQlUmv3YL0Ojti6HG6EWP/NbRNYa9lL7J+ajVhdK7Bdr8+AiM7zgQhI2G6o9sVo1D+Q4245nLlON/9PzaQDgqTmR23YDtH8VAR5N14S91KVOCgiWkEQ4cMyrVsW3HUbYdQx75WcbHKjzEvoBoU9uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=CxuJGpWL; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KKOEcW2145225
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 16:50:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=y+gj
	tILqDLOQsRHv/xOkAmWQ2cCtCFJ6veJFyW78pUo=; b=CxuJGpWL+kS84wunAt9h
	U/LMKliWuP4nB71UXrm5g2rej0P5N7Idq6BmiNfKDH80LLeVfW44ieNa0/BkXXsi
	+L9TIuteWD2e2V/oKCwp2pBm8/BevB3hAA68MBGegIkV4f6lcMhzEeWtaWIZ/onj
	AS5ayl3chCL64tG3bR5sORVXXnch8+A3TP6eyrsP+oZjdBtNP6ga3aSMnRwc0p6/
	BYV5Iilum2otM/TkKY8H/+zERGVJ7saJ/nflnYcYRup6RXfZY6tt6SAiOZhn8cYW
	OdnmFxoq6yyFwNO6fg+uSBMB8Kt/ndgipMDZ0G1TcX+iqata3s5oeMrGTtuoq5nS
	pg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4e9ccqvatg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 16:50:40 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-90ccab62c33so602064285a.0
        for <io-uring@vger.kernel.org>; Wed, 20 May 2026 13:50:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310240; x=1779915040;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=y+gjtILqDLOQsRHv/xOkAmWQ2cCtCFJ6veJFyW78pUo=;
        b=E4di9lb6p+uZKwJknznfNXUIte5z1XMPB0d/S1Ff1eEJu8t61dr0CyJBrdInigrBxd
         kFQCwcZGrGtVEYWWh6XSPnD3eNybXRWI8vnM0ItF5ECU4jM9HiwomsVZk4zX7Qk3sa+6
         qi4p8be9hqfb5gyhwuw8LFmUZK8pNwU1uXqkIO3nefgAFeBaH6uzFyakTHQNP/22QVig
         IUqx2cU7+RKpGDCJciaRGSrfcrwlKz69wjOojIaVlSbbGGGx9L+MW14JaywYJrT3pyGu
         /uLVlnGz7fzpSSYzuxMu9b8B4W0Yc+J0VmX0F571hO7Hu/BkL3NiT+4JBBS4ObfGaTi5
         RIaQ==
X-Forwarded-Encrypted: i=1; AFNElJ9Sq3xBDnHyJNFuz6VGsjsJI980eOfmTlGwIlr4zapuMwchYFi+8OHI97/lnu++TGDkoe+95JYexQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzumaYlmkl03LzKnK7lF6+2fVoN6DdqhbY+YaBEgY4L4pi3R3iH
	AhOGx6JGIM+f4pwBeiRG7I1kUTzB/Ch6VeB+BJVzOz9cGkn6vJa1K/LefpdgOMyUyFzDxOqDval
	MqVVX3k45wHFPWSEUXXiJgnoGSgb9hegg5Abf/4QUtN2TL8OZcGTqCpq/
X-Gm-Gg: Acq92OEgjm7NOxTuP3Jo5oL95N3m8qQlKPViNu0MUZGOeQm+2pPpiQlv/WssmPCCcsu
	obPR92USMkbI3d2zathUbs754ccK7b1KfNtIaNg5aULFu8vTeJDXXgTHfWgRm1O9GPnQOsJG5dv
	CUJzeaIqFQ2gi/yh2yfNdiqK969+COrBpAs/DBheMZfj4NxUMeUT5gPRnFaDnIsG1petO0fnNhu
	HsRXF7BRbSLYQZjBcd3llGu7pARl5u+5zzrBBpK7WZrzfMA/PZy/3qi6gKJZ+jNJ+guEfUfin8y
	1TTFOzFPm05BaJqNEjCIYe4WAYyaDEyhZxmQeF4NNO0ER2W08WRMeQe57b7T9QZ5gF/w5D3eksD
	DJTl7dZDKqygpbp0s5NdJQCaQzJJidqu/HoayFzI214qj0CvyvytbW156vwsm8qZ4rxw=
X-Received: by 2002:a05:620a:4542:b0:8ee:dc47:3b70 with SMTP id af79cd13be357-911cef062demr3495293185a.39.1779310239997;
        Wed, 20 May 2026 13:50:39 -0700 (PDT)
X-Received: by 2002:a05:620a:4542:b0:8ee:dc47:3b70 with SMTP id af79cd13be357-911cef062demr3495254485a.39.1779310234746;
        Wed, 20 May 2026 13:50:34 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bcf37274sm2232692085a.37.2026.05.20.13.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 13:50:34 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 20 May 2026 16:48:55 -0400
Subject: [PATCH RFC 04/11] folio_wait: move folio_wait_writeback() family
 to mm/folio_wait.c
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-filemap-split-v1-4-c36ddc2b6cf2@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779310229; l=7803;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=MdnqSRc2FJHBhrARlYsy3cs/9UevS5fEoCvn0pE0sDw=;
 b=rkMG4EwgIAXfDMJhpCN/bphiVIHAebicxGt8s33PBw5nTp2DJPdH7PqP6gawcVTAxyPkOdXvw
 WsorbnVQOqHC4h13v+JdnPOZqm2wLrEZ0r4jbfVOfOBi4GxGI+ybNHp
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=XJQAjwhE c=1 sm=1 tr=0 ts=6a0e1ea0 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=oq273MN9QaURjshXV2UA:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: E3r99N6Yd277wayC83CD0B56kC7x0Ibe
X-Proofpoint-GUID: E3r99N6Yd277wayC83CD0B56kC7x0Ibe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDIwMyBTYWx0ZWRfX95YyDP5J4nEC
 Jl+jWduNVO2tFlAtrOm9XHSl/xB8DUy8+QH7d5lunG8DjB7TUWFjBMIU2d0EYUO3cXaqzYNbHka
 SXDEC2coVZWW/3iunO1SWErqklAsX06oalnXEzknLV0X2LLspM5P54P033pxFmdusIwKvYUb6dW
 OILwpA91Jisx3D7hT4wvPeiUxIO9v+zFkM4we/biFnCGQ2wF5DFqA65l4nTaBz9kq9coz9PAcfv
 sUz6ot0DtCzV3HB3CIWAOsh1dYZfkyjzZo9Au5rOL3tv4s0dYhddhLd1ss/E2n12VtP9nyvFcYZ
 idKUe0+g+9tvRh7SjS1Eh3+S6gj9pqsh9t82dKrr66ihDRijvtU4c2grLQGg/AmO2mw+dKprNoG
 mw3gsK4Zfo0D6RRBUQSvcH7J6DEfN2VT5E9XZSrzeN3pNazTV7OyeTtKtf0+0nCbztIbP8QYd3U
 I2A4H/Lo8Q40cq4ZOCg==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11792
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 malwarescore=0 clxscore=1015 adultscore=0
 lowpriorityscore=10 suspectscore=0 spamscore=0 priorityscore=1501
 bulkscore=10 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605200203
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[columbia.edu,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[columbia.edu:s=pps01];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13467-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[columbia.edu:+];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[columbia.edu:email,columbia.edu:mid,columbia.edu:dkim,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tz2294@columbia.edu,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 439A859A382
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

folio_wait_writeback(), folio_wait_writeback_killable() and
folio_wait_stable() are thin wrappers around folio_wait_bit() and
folio_wait_bit_killable() on PG_writeback. Move them to mm/folio_wait.c,
next to the rest of the folio bit-wait infrastructure.

The legacy wait_on_page_writeback() wrapper stays in folio-compat.c, as
its days are numbered, and it will be deleted once the remaining callers
are converted.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/folio_wait.h |  4 +++
 include/linux/pagemap.h    |  3 ---
 mm/folio_wait.c            | 67 ++++++++++++++++++++++++++++++++++++++++++++++
 mm/page-writeback.c        | 66 ---------------------------------------------
 4 files changed, 71 insertions(+), 69 deletions(-)

diff --git a/include/linux/folio_wait.h b/include/linux/folio_wait.h
index 80ddf1ffcae4..4a5cb2fcf046 100644
--- a/include/linux/folio_wait.h
+++ b/include/linux/folio_wait.h
@@ -178,4 +178,8 @@ void folio_end_private_2(struct folio *folio);
 void folio_wait_private_2(struct folio *folio);
 int folio_wait_private_2_killable(struct folio *folio);
 
+void folio_wait_writeback(struct folio *folio);
+int folio_wait_writeback_killable(struct folio *folio);
+void folio_wait_stable(struct folio *folio);
+
 #endif /* _LINUX_FOLIO_WAIT_H */
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 7f65c2b0097b..84ccb682cca8 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1074,13 +1074,10 @@ static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
 }
 
 void wait_on_page_writeback(struct page *page);
-void folio_wait_writeback(struct folio *folio);
-int folio_wait_writeback_killable(struct folio *folio);
 void end_page_writeback(struct page *page);
 void folio_end_writeback(struct folio *folio);
 void folio_end_writeback_no_dropbehind(struct folio *folio);
 void folio_end_dropbehind(struct folio *folio);
-void folio_wait_stable(struct folio *folio);
 void __folio_mark_dirty(struct folio *folio, struct address_space *, int warn);
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb);
 void __folio_cancel_dirty(struct folio *folio);
diff --git a/mm/folio_wait.c b/mm/folio_wait.c
index 06156e138c09..9d3328717bb3 100644
--- a/mm/folio_wait.c
+++ b/mm/folio_wait.c
@@ -15,6 +15,7 @@
 #include <linux/delayacct.h>
 #include <linux/psi.h>
 #include <linux/migrate.h>
+#include <trace/events/writeback.h>
 
 #include "internal.h"
 
@@ -572,6 +573,72 @@ int folio_wait_private_2_killable(struct folio *folio)
 }
 EXPORT_SYMBOL(folio_wait_private_2_killable);
 
+/**
+ * folio_wait_writeback - Wait for a folio to finish writeback.
+ * @folio: The folio to wait for.
+ *
+ * If the folio is currently being written back to storage, wait for the
+ * I/O to complete.
+ *
+ * Context: Sleeps.  Must be called in process context and with
+ * no spinlocks held.  Caller should hold a reference on the folio.
+ * If the folio is not locked, writeback may start again after writeback
+ * has finished.
+ */
+void folio_wait_writeback(struct folio *folio)
+{
+	while (folio_test_writeback(folio)) {
+		trace_folio_wait_writeback(folio, folio_mapping(folio));
+		folio_wait_bit(folio, PG_writeback);
+	}
+}
+EXPORT_SYMBOL_GPL(folio_wait_writeback);
+
+/**
+ * folio_wait_writeback_killable - Wait for a folio to finish writeback.
+ * @folio: The folio to wait for.
+ *
+ * If the folio is currently being written back to storage, wait for the
+ * I/O to complete or a fatal signal to arrive.
+ *
+ * Context: Sleeps.  Must be called in process context and with
+ * no spinlocks held.  Caller should hold a reference on the folio.
+ * If the folio is not locked, writeback may start again after writeback
+ * has finished.
+ * Return: 0 on success, -EINTR if we get a fatal signal while waiting.
+ */
+int folio_wait_writeback_killable(struct folio *folio)
+{
+	while (folio_test_writeback(folio)) {
+		trace_folio_wait_writeback(folio, folio_mapping(folio));
+		if (folio_wait_bit_killable(folio, PG_writeback))
+			return -EINTR;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(folio_wait_writeback_killable);
+
+/**
+ * folio_wait_stable() - wait for writeback to finish, if necessary.
+ * @folio: The folio to wait on.
+ *
+ * This function determines if the given folio is related to a backing
+ * device that requires folio contents to be held stable during writeback.
+ * If so, then it will wait for any pending writeback to complete.
+ *
+ * Context: Sleeps.  Must be called in process context and with
+ * no spinlocks held.  Caller should hold a reference on the folio.
+ * If the folio is not locked, writeback may start again after writeback
+ * has finished.
+ */
+void folio_wait_stable(struct folio *folio)
+{
+	if (mapping_stable_writes(folio_mapping(folio)))
+		folio_wait_writeback(folio);
+}
+EXPORT_SYMBOL_GPL(folio_wait_stable);
+
 /**
  * __folio_lock - Get a lock on the folio, assuming we need to sleep to get it.
  * @folio: The folio to lock
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 833f743f309f..50f548bbb375 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -3042,69 +3042,3 @@ void __folio_start_writeback(struct folio *folio, bool keep_write)
 	VM_BUG_ON_FOLIO(access_ret != 0, folio);
 }
 EXPORT_SYMBOL(__folio_start_writeback);
-
-/**
- * folio_wait_writeback - Wait for a folio to finish writeback.
- * @folio: The folio to wait for.
- *
- * If the folio is currently being written back to storage, wait for the
- * I/O to complete.
- *
- * Context: Sleeps.  Must be called in process context and with
- * no spinlocks held.  Caller should hold a reference on the folio.
- * If the folio is not locked, writeback may start again after writeback
- * has finished.
- */
-void folio_wait_writeback(struct folio *folio)
-{
-	while (folio_test_writeback(folio)) {
-		trace_folio_wait_writeback(folio, folio_mapping(folio));
-		folio_wait_bit(folio, PG_writeback);
-	}
-}
-EXPORT_SYMBOL_GPL(folio_wait_writeback);
-
-/**
- * folio_wait_writeback_killable - Wait for a folio to finish writeback.
- * @folio: The folio to wait for.
- *
- * If the folio is currently being written back to storage, wait for the
- * I/O to complete or a fatal signal to arrive.
- *
- * Context: Sleeps.  Must be called in process context and with
- * no spinlocks held.  Caller should hold a reference on the folio.
- * If the folio is not locked, writeback may start again after writeback
- * has finished.
- * Return: 0 on success, -EINTR if we get a fatal signal while waiting.
- */
-int folio_wait_writeback_killable(struct folio *folio)
-{
-	while (folio_test_writeback(folio)) {
-		trace_folio_wait_writeback(folio, folio_mapping(folio));
-		if (folio_wait_bit_killable(folio, PG_writeback))
-			return -EINTR;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(folio_wait_writeback_killable);
-
-/**
- * folio_wait_stable() - wait for writeback to finish, if necessary.
- * @folio: The folio to wait on.
- *
- * This function determines if the given folio is related to a backing
- * device that requires folio contents to be held stable during writeback.
- * If so, then it will wait for any pending writeback to complete.
- *
- * Context: Sleeps.  Must be called in process context and with
- * no spinlocks held.  Caller should hold a reference on the folio.
- * If the folio is not locked, writeback may start again after writeback
- * has finished.
- */
-void folio_wait_stable(struct folio *folio)
-{
-	if (mapping_stable_writes(folio_mapping(folio)))
-		folio_wait_writeback(folio);
-}
-EXPORT_SYMBOL_GPL(folio_wait_stable);

-- 
2.39.5



Return-Path: <io-uring+bounces-13463-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id zEjBEs8eDmpd6QUAu9opvQ
	(envelope-from <io-uring+bounces-13463-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 22:51:27 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E44DE59A334
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 22:51:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E6D86305000B
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 20:50:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54B3D376BF4;
	Wed, 20 May 2026 20:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="qsUbckLp"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E8C375AD0
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 20:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779310242; cv=none; b=VW/oY0iavEH5ULRdATeoyV22jRzAXb2XAJCR+0wBOxPj83UPN5P3R/1mJwywZY6Pd1GO8CNTLz0OgiAdkBBZyqR0TFFfraZwnfbdzAmi6Zvs0JtVib/PYq6Oy7d+6GG8Xc4Pw/uaBDXbxumKT2uXZ3rA5G/B29+s/7VfS9QIUlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779310242; c=relaxed/simple;
	bh=69FMnFpCCkSEBZ7/2YJYSjRd1MbsazhKzcMtt9GaMPw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=t8rlDKy2BkwTyivlCeQZsDq6Us6n+01iB0ve4HecjFiTdvHtq6crU3PgGGLPnggujvPMXPx6OMpo6XKSFjuMUS7JRbNPyV/iiZGLpDoyIj3srOsrs9um5TPvmrgh15qNZlyFKw9/jkGf7mBc6xXWmenm+npGmvQtjzEQbTudG1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=qsUbckLp; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KKO2381270836
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 16:50:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=QM60
	WXSBSIQYQWVtbfbyKvBF8T4H0CKsBjV6qw2v1YM=; b=qsUbckLpGyB+A7AmVhc9
	P/EmpJQBFEfgFQ6Udn4ZjA6omKFZKlDMSjeq+f1ohfc78WtsZMLDzvRM9bgXvo2S
	MBCu5l/GGRXt2PE4FwGczaZWrztMv9TpwKXvnjuzF2MwdCpiVEWZN2c298ivtzBY
	QGeU+gxRvkX2o9DO0ASI46sJppe6M7llf5MTsfrdKQi0QBe1i7SrgiWLC9uBdx8A
	Otr7Czvz4SEuwUdiNhvICi3uaD1ReLSTI35+Pzo+fB/osgj0Tkc39UFscfFF/RbB
	gOXVynu+j3mGFznKdiOcXCL3AYt9RyTRfgkMl31LbUIKv7ZIFGqgCOcdTZBhY7UM
	vw==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4e98j6wc86-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 16:50:37 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-913fcc4c164so1255742985a.1
        for <io-uring@vger.kernel.org>; Wed, 20 May 2026 13:50:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310237; x=1779915037;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QM60WXSBSIQYQWVtbfbyKvBF8T4H0CKsBjV6qw2v1YM=;
        b=cI6wDObxLt1Tn3laDNsa2sd0dPm9CAwIonA1iqQu9pRD5QS8GeghXNKA7yv96IjIFC
         BKOcna5QCc71STecmoFul8k8fpNSulAEUGnO85HLHj6kMLQ5r8hU2snKSZa+3xsimBPT
         3RR0h9/snAzUz6neJoa0NNOLdrG6GNhZbuU/YGt6tsNIEEuyRsTJcESnFsRetnauAcUL
         3kdGzz4g8eq/m5/VdMm/fIo2tS/pUWedCUYjqaL3B0MBCXvcVzHGE6tXhJy6EWxZ9qSf
         Wz+lsDba1Eia3a+ehtS8j9nyb3Ud1mzsE8zUwXeAva9UTcfvm5sm9ce/OqhLKwUMVt4H
         f+tw==
X-Forwarded-Encrypted: i=1; AFNElJ8CuM7qV18lfQYEKCk6RkTVO/3xQky+HWjGqS+m80Ywvejh9XjojP11JejzeYpCI/VtWIkjaz8GXg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwplwCvIJVgPpJ5I7iqUAmsr7Pw/WYSZnjttfr6CmixAEp6r9z+
	bp8o4mbjz9EhKfdU5kL3EQA82L9piYU2cPH6RNtymmgW3PLf2PUP8mX+hGTILYX50qU5OWWUt4o
	FOWwa2afm5jpvj06LUWe/gFe3EFqJ3E/KmcFzJFBcr3UeAdd49fS0ZMm0
X-Gm-Gg: Acq92OEs2ylKt1f0xzf5ddtKsUOFld4ntnSvRb5wzDN43jy6kBBmEIF+dTfZzT7GbnL
	hPb5QkEU0hVNGlVZRfRcjaJuuuJVPuKATz3bISFMsj5kA8BJt5AhAYhA3IMR+sTnvmRMHQ+BrEV
	k9x4F/yIvYVP55iOXsLD1WD5IhQD7ZjQaOy35WRIKDdIzPKZ1pcQPFntCy9XuaJmnTs2GtAyjes
	1jfEnZuGD1r+5vBDJMh5R+AN27Q7lreqig+UwW20jMiwRlfeuq8x3AvZJak1Dxzm2FTqNSRkRAt
	yRirFRgrIrDrnTRmcWNE/wLY9jFuR9R0oW8RWIr60uWAcQ2NZ21jBHSmAZK54D5nVgx4OR0apV9
	rramcjHbYtnfob4nWeKUBeXU9yNPcBaMY2hOWUgIWDrV0myuXCA7n/oY0koElxqW8jlM=
X-Received: by 2002:a05:620a:cfb:b0:911:fc2c:c078 with SMTP id af79cd13be357-911fc2cd1c1mr3069129085a.1.1779310237093;
        Wed, 20 May 2026 13:50:37 -0700 (PDT)
X-Received: by 2002:a05:620a:cfb:b0:911:fc2c:c078 with SMTP id af79cd13be357-911fc2cd1c1mr3069124685a.1.1779310236449;
        Wed, 20 May 2026 13:50:36 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bcf37274sm2232692085a.37.2026.05.20.13.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 13:50:35 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 20 May 2026 16:48:56 -0400
Subject: [PATCH RFC 05/11] folio_wait: reformat comments and fix alignment
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-filemap-split-v1-5-c36ddc2b6cf2@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779310229; l=21905;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=69FMnFpCCkSEBZ7/2YJYSjRd1MbsazhKzcMtt9GaMPw=;
 b=/LS05GFRr0I0dRdpIdwuCT27Qutf2Js6Cv+yKW0yfgbbJSYuTkFWu6MOkmEqTdIvlw3VRr5oV
 smS0ff/auk2DI+45+Yy/pAXtlKe+W4MsmUEGzwoOkLRM2bxQ/nX4MKZ
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDIwMyBTYWx0ZWRfXyVCis7wIVc15
 p4pJ84Dto/EO0z3xRof7rS5ghg0HWlCZZIxcSPbKY+wR5omWs64kIIOE2m9X948BtbTowjfbaWi
 +eL1lP7GGqxTn4jKYrnHGkPMIIiFtZKmpOUtMS4EbwmxMLT4TPOUdjMjEzcs1LjCMpa141oyfXc
 Tm5ptbRVEyAOlE1gWgeh3RAS5JHBaL7VsgrhcyphZMoOpgwZv0MVoxer4BMWW3E6lFk8bqiXyqA
 Dv2uwfOsbYccssEGNHWvAThLTqgpvr176BIuvZVOWciwpJ7vWCB2OZ4k3ulYLjEo2ziCMM4u4Gt
 Lziwhkbun57ccBbOlcPpgFFAPg3R88HGGylepIZ4Z+OA7H7GruCLCOMZhk3DbhQBpCcQC+UARvu
 Q49XWbABCQ0v9GFt9Wh5If5lITjzIfPcIbTsfdVGffKhPxPmWif0KbJXw2CZm3Gogs955NXgYKr
 D9361RimBmqb6HxmVZw==
X-Authority-Analysis: v=2.4 cv=TsDWQjXh c=1 sm=1 tr=0 ts=6a0e1e9e cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=ItFntl4SG6S2Zc4VtyUA:9 a=QEXdDO2ut3YA:10 a=O8hF6Hzn-FEA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-GUID: y7tYv4uf6ulSOtY5EheKAivhxHk5CKn9
X-Proofpoint-ORIG-GUID: y7tYv4uf6ulSOtY5EheKAivhxHk5CKn9
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11792
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 suspectscore=0 phishscore=0 lowpriorityscore=10 adultscore=0
 spamscore=0 clxscore=1015 malwarescore=0 priorityscore=1501 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605200203
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[columbia.edu,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[columbia.edu:s=pps01];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13463-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[columbia.edu:+];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tz2294@columbia.edu,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: E44DE59A334
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Reflow comments to fill 80 columns and fix indentation issues carried
over from the original locations in pagemap.h and filemap.c.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/folio_wait.h |  62 ++++++++-------
 mm/folio_wait.c            | 185 ++++++++++++++++++++-------------------------
 2 files changed, 113 insertions(+), 134 deletions(-)

diff --git a/include/linux/folio_wait.h b/include/linux/folio_wait.h
index 4a5cb2fcf046..57ccf9ffd243 100644
--- a/include/linux/folio_wait.h
+++ b/include/linux/folio_wait.h
@@ -19,10 +19,10 @@ struct wait_page_queue {
 };
 
 static inline bool wake_page_match(struct wait_page_queue *wait_page,
-				  struct wait_page_key *key)
+		struct wait_page_key *key)
 {
 	if (wait_page->folio != key->folio)
-	       return false;
+		return false;
 	key->page_match = 1;
 
 	if (wait_page->bit_nr != key->bit_nr)
@@ -41,10 +41,10 @@ void folio_unlock(struct folio *folio);
  * folio_trylock() - Attempt to lock a folio.
  * @folio: The folio to attempt to lock.
  *
- * Sometimes it is undesirable to wait for a folio to be unlocked (eg
- * when the locks are being taken in the wrong order, or if making
- * progress through a batch of folios is more important than processing
- * them in order).  Usually folio_lock() is the correct function to call.
+ * Sometimes it is undesirable to wait for a folio to be unlocked (e.g. when
+ * the locks are being taken in the wrong order, or if making progress through
+ * a batch of folios is more important than processing them in order). Usually
+ * folio_lock() is the correct function to call.
  *
  * Context: Any context.
  * Return: Whether the lock was successfully acquired.
@@ -66,23 +66,22 @@ static inline bool trylock_page(struct page *page)
  * folio_lock() - Lock this folio.
  * @folio: The folio to lock.
  *
- * The folio lock protects against many things, probably more than it
- * should.  It is primarily held while a folio is being brought uptodate,
- * either from its backing file or from swap.  It is also held while a
- * folio is being truncated from its address_space, so holding the lock
- * is sufficient to keep folio->mapping stable.
+ * The folio lock protects against many things, probably more than it should.
+ * It is primarily held while a folio is being brought uptodate, either from
+ * its backing file or from swap. It is also held while a folio is being
+ * truncated from its address_space, so holding the lock is sufficient to keep
+ * folio->mapping stable.
  *
- * The folio lock is also held while write() is modifying the page to
- * provide POSIX atomicity guarantees (as long as the write does not
- * cross a page boundary).  Other modifications to the data in the folio
- * do not hold the folio lock and can race with writes, eg DMA and stores
- * to mapped pages.
+ * The folio lock is also held while write() is modifying the folio to provide
+ * POSIX atomicity guarantees (as long as the write does not cross a page
+ * boundary). Other modifications to the data in the folio do not hold the
+ * folio lock and can race with writes, e.g. DMA and stores to mapped pages.
  *
- * Context: May sleep.  If you need to acquire the locks of two or
- * more folios, they must be in order of ascending index, if they are
- * in the same address_space.  If they are in different address_spaces,
- * acquire the lock of the folio which belongs to the address_space which
- * has the lowest address in memory first.
+ * Context: May sleep. If you need to acquire the locks of two or more folios,
+ * they must be in order of ascending index, if they are in the same
+ * address_space. If they are in different address_spaces, acquire the lock of
+ * the folio which belongs to the address_space which has the lowest address in
+ * memory first.
  */
 static inline void folio_lock(struct folio *folio)
 {
@@ -99,8 +98,8 @@ static inline void folio_lock(struct folio *folio)
  * This is a legacy function and new code should probably use folio_lock()
  * instead.
  *
- * Context: May sleep.  Pages in the same folio share a lock, so do not
- * attempt to lock two pages which share a folio.
+ * Context: May sleep. Pages in the same folio share a lock, so do not attempt
+ * to lock two pages which share a folio.
  */
 static inline void lock_page(struct page *page)
 {
@@ -116,8 +115,8 @@ static inline void lock_page(struct page *page)
  * folio_lock_killable() - Lock this folio, interruptible by a fatal signal.
  * @folio: The folio to lock.
  *
- * Attempts to lock the folio, like folio_lock(), except that the sleep
- * to acquire the lock is interruptible by a fatal signal.
+ * Attempts to lock the folio, like folio_lock(), except that the sleep to
+ * acquire the lock is interruptible by a fatal signal.
  *
  * Context: May sleep; see folio_lock().
  * Return: 0 if the lock was acquired; -EINTR if a fatal signal was received.
@@ -131,8 +130,8 @@ static inline int folio_lock_killable(struct folio *folio)
 }
 
 /*
- * folio_lock_or_retry - Lock the folio, unless this would block and the
- * caller indicated that it can handle a retry.
+ * folio_lock_or_retry - Lock the folio, unless this would block and the caller
+ * indicated that it can handle a retry.
  *
  * Return value and mmap_lock implications depend on flags; see
  * __folio_lock_or_retry().
@@ -147,8 +146,8 @@ static inline vm_fault_t folio_lock_or_retry(struct folio *folio,
 }
 
 /*
- * This is exported only for folio_wait_locked/folio_wait_writeback, etc.,
- * and should not be used directly.
+ * This is exported only for folio_wait_locked/folio_wait_writeback, etc., and
+ * should not be used directly.
  */
 void folio_wait_bit(struct folio *folio, int bit_nr);
 int folio_wait_bit_killable(struct folio *folio, int bit_nr);
@@ -156,9 +155,8 @@ int folio_wait_bit_killable(struct folio *folio, int bit_nr);
 /*
  * Wait for a folio to be unlocked.
  *
- * This must be called with the caller "holding" the folio,
- * ie with increased folio reference count so that the folio won't
- * go away during the wait.
+ * This must be called with the caller "holding" the folio, i.e. with increased
+ * folio reference count so that the folio won't go away during the wait.
  */
 static inline void folio_wait_locked(struct folio *folio)
 {
diff --git a/mm/folio_wait.c b/mm/folio_wait.c
index 9d3328717bb3..8d8237cdd73b 100644
--- a/mm/folio_wait.c
+++ b/mm/folio_wait.c
@@ -20,14 +20,12 @@
 #include "internal.h"
 
 /*
- * In order to wait for pages to become available there must be
- * waitqueues associated with pages. By using a hash table of
- * waitqueues where the bucket discipline is to maintain all
- * waiters on the same queue and wake all when any of the pages
- * become available, and for the woken contexts to check to be
- * sure the appropriate page became available, this saves space
- * at a cost of "thundering herd" phenomena during rare hash
- * collisions.
+ * In order to wait for pages to become available there must be waitqueues
+ * associated with pages. By using a hash table of waitqueues where the bucket
+ * discipline is to maintain all waiters on the same queue and wake all when any
+ * of the pages become available, and for the woken contexts to check to be
+ * sure the appropriate page became available, this saves space at a cost of
+ * "thundering herd" phenomena during rare hash collisions.
  */
 #define PAGE_WAIT_TABLE_BITS 8
 #define PAGE_WAIT_TABLE_SIZE (1 << PAGE_WAIT_TABLE_BITS)
@@ -70,44 +68,42 @@ void __init folio_wait_init(void)
  *
  *  (a) no special bits set:
  *
- *	We're just waiting for the bit to be released, and when a waker
- *	calls the wakeup function, we set WQ_FLAG_WOKEN and wake it up,
- *	and remove it from the wait queue.
+ *	We're just waiting for the bit to be released, and when a waker calls
+ *	the wakeup function, we set WQ_FLAG_WOKEN and wake it up, and remove
+ *	it from the wait queue.
  *
  *	Simple and straightforward.
  *
  *  (b) WQ_FLAG_EXCLUSIVE:
  *
- *	The waiter is waiting to get the lock, and only one waiter should
- *	be woken up to avoid any thundering herd behavior. We'll set the
+ *	The waiter is waiting to get the lock, and only one waiter should be
+ *	woken up to avoid any thundering herd behavior. We'll set the
  *	WQ_FLAG_WOKEN bit, wake it up, and remove it from the wait queue.
  *
  *	This is the traditional exclusive wait.
  *
  *  (c) WQ_FLAG_EXCLUSIVE | WQ_FLAG_CUSTOM:
  *
- *	The waiter is waiting to get the bit, and additionally wants the
- *	lock to be transferred to it for fair lock behavior. If the lock
- *	cannot be taken, we stop walking the wait queue without waking
- *	the waiter.
+ *	The waiter is waiting to get the bit, and additionally wants the lock
+ *	to be transferred to it for fair lock behavior. If the lock cannot be
+ *	taken, we stop walking the wait queue without waking the waiter.
  *
  *	This is the "fair lock handoff" case, and in addition to setting
- *	WQ_FLAG_WOKEN, we set WQ_FLAG_DONE to let the waiter easily see
- *	that it now has the lock.
+ *	WQ_FLAG_WOKEN, we set WQ_FLAG_DONE to let the waiter easily see that
+ *	it now has the lock.
  */
-static int wake_page_function(wait_queue_entry_t *wait, unsigned mode, int sync, void *arg)
+static int wake_page_function(wait_queue_entry_t *wait, unsigned int mode, int sync, void *arg)
 {
 	unsigned int flags;
 	struct wait_page_key *key = arg;
-	struct wait_page_queue *wait_page
-		= container_of(wait, struct wait_page_queue, wait);
+	struct wait_page_queue *wait_page = container_of(wait, struct wait_page_queue, wait);
 
 	if (!wake_page_match(wait_page, key))
 		return 0;
 
 	/*
-	 * If it's a lock handoff wait, we get the bit for it, and
-	 * stop walking (and do not wake it up) if we can't.
+	 * If it's a lock handoff wait, we get the bit for it, and stop walking
+	 * (and do not wake it up) if we can't.
 	 */
 	flags = wait->flags;
 	if (flags & WQ_FLAG_EXCLUSIVE) {
@@ -121,26 +117,24 @@ static int wake_page_function(wait_queue_entry_t *wait, unsigned mode, int sync,
 	}
 
 	/*
-	 * We are holding the wait-queue lock, but the waiter that
-	 * is waiting for this will be checking the flags without
-	 * any locking.
+	 * We are holding the wait-queue lock, but the waiter that is waiting
+	 * for this will be checking the flags without any locking.
 	 *
-	 * So update the flags atomically, and wake up the waiter
-	 * afterwards to avoid any races. This store-release pairs
-	 * with the load-acquire in folio_wait_bit_common().
+	 * So update the flags atomically, and wake up the waiter afterwards to
+	 * avoid any races. This store-release pairs with the load-acquire in
+	 * folio_wait_bit_common().
 	 */
 	smp_store_release(&wait->flags, flags | WQ_FLAG_WOKEN);
 	wake_up_state(wait->private, mode);
 
 	/*
-	 * Ok, we have successfully done what we're waiting for,
-	 * and we can unconditionally remove the wait entry.
+	 * Ok, we have successfully done what we're waiting for, and we can
+	 * unconditionally remove the wait entry.
 	 *
-	 * Note that this pairs with the "finish_wait()" in the
-	 * waiter, and has to be the absolute last thing we do.
-	 * After this list_del_init(&wait->entry) the wait entry
-	 * might be de-allocated and the process might even have
-	 * exited.
+	 * Note that this pairs with the "finish_wait()" in the waiter, and has
+	 * to be the absolute last thing we do. After this
+	 * list_del_init(&wait->entry) the wait entry might be de-allocated and
+	 * the process might even have exited.
 	 */
 	list_del_init_careful(&wait->entry);
 	return (flags & WQ_FLAG_EXCLUSIVE) != 0;
@@ -198,11 +192,10 @@ enum behavior {
 };
 
 /*
- * Attempt to check (or get) the folio flag, and mark us done
- * if successful.
+ * Attempt to check (or get) the folio flag, and mark as done if successful.
  */
 static inline bool folio_trylock_flag(struct folio *folio, int bit_nr,
-					struct wait_queue_entry *wait)
+		struct wait_queue_entry *wait)
 {
 	if (wait->flags & WQ_FLAG_EXCLUSIVE) {
 		if (test_and_set_bit(bit_nr, &folio->flags.f))
@@ -246,18 +239,14 @@ static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
 	}
 
 	/*
-	 * Do one last check whether we can get the
-	 * page bit synchronously.
+	 * Do one last check whether we can get the page bit synchronously.
 	 *
-	 * Do the folio_set_waiters() marking before that
-	 * to let any waker we _just_ missed know they
-	 * need to wake us up (otherwise they'll never
-	 * even go to the slow case that looks at the
-	 * page queue), and add ourselves to the wait
-	 * queue if we need to sleep.
+	 * Do the folio_set_waiters() marking before that to let any waker we
+	 * _just_ missed know they need to wake us up (otherwise they'll never
+	 * even go to the slow case that looks at the wait queue), and add
+	 * ourselves to the wait queue if we need to sleep.
 	 *
-	 * This part needs to be done under the queue
-	 * lock to avoid races.
+	 * This part needs to be done under the queue lock to avoid races.
 	 */
 	spin_lock_irq(&q->lock);
 	folio_set_waiters(folio);
@@ -266,9 +255,8 @@ static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
 	spin_unlock_irq(&q->lock);
 
 	/*
-	 * From now on, all the logic will be based on
-	 * the WQ_FLAG_WOKEN and WQ_FLAG_DONE flag, to
-	 * see whether the page bit testing has already
+	 * From now on, all the logic will be based on the WQ_FLAG_WOKEN and
+	 * WQ_FLAG_DONE flag, to see whether the page bit testing has already
 	 * been done by the wake function.
 	 *
 	 * We can drop our reference to the folio.
@@ -277,10 +265,9 @@ static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
 		folio_put(folio);
 
 	/*
-	 * Note that until the "finish_wait()", or until
-	 * we see the WQ_FLAG_WOKEN flag, we need to
-	 * be very careful with the 'wait->flags', because
-	 * we may race with a waker that sets them.
+	 * Note that until the "finish_wait()", or until we see the
+	 * WQ_FLAG_WOKEN flag, we need to be very careful with the
+	 * 'wait->flags', because we may race with a waker that sets them.
 	 */
 	for (;;) {
 		unsigned int flags;
@@ -306,8 +293,8 @@ static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
 			break;
 
 		/*
-		 * Otherwise, if we're getting the lock, we need to
-		 * try to get it ourselves.
+		 * Otherwise, if we're getting the lock, we need to try to get
+		 * it ourselves.
 		 *
 		 * And if that fails, we'll have to retry this all.
 		 */
@@ -333,13 +320,13 @@ static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
 
 	/*
 	 * NOTE! The wait->flags weren't stable until we've done the
-	 * 'finish_wait()', and we could have exited the loop above due
-	 * to a signal, and had a wakeup event happen after the signal
-	 * test but before the 'finish_wait()'.
+	 * 'finish_wait()', and we could have exited the loop above due to a
+	 * signal, and had a wakeup event happen after the signal test but
+	 * before the 'finish_wait()'.
 	 *
-	 * So only after the finish_wait() can we reliably determine
-	 * if we got woken up or not, so we can now figure out the final
-	 * return value based on that state without races.
+	 * So only after the finish_wait() can we reliably determine if we got
+	 * woken up or not, so we can now figure out the final return value
+	 * based on that state without races.
 	 *
 	 * Also note that WQ_FLAG_WOKEN is sufficient for a non-exclusive
 	 * waiter, but an exclusive one requires WQ_FLAG_DONE.
@@ -452,11 +439,10 @@ EXPORT_SYMBOL(folio_wait_bit_killable);
  * @folio: The folio to wait for.
  * @state: The sleep state (TASK_KILLABLE, TASK_UNINTERRUPTIBLE, etc).
  *
- * The caller should hold a reference on @folio.  They expect the page to
- * become unlocked relatively soon, but do not wish to hold up migration
- * (for example) by holding the reference while waiting for the folio to
- * come unlocked.  After this function returns, the caller should not
- * dereference @folio.
+ * The caller should hold a reference on @folio. They expect the page to become
+ * unlocked relatively soon, but do not wish to hold up migration (for example)
+ * by holding the reference while waiting for the folio to come unlocked. After
+ * this function returns, the caller should not dereference @folio.
  *
  * Return: 0 if the folio was unlocked or -EINTR if interrupted by a signal.
  */
@@ -471,8 +457,8 @@ int folio_put_wait_locked(struct folio *folio, int state)
  *
  * Unlocks the folio and wakes up any thread sleeping on the page lock.
  *
- * Context: May be called from interrupt or process context.  May not be
- * called from NMI context.
+ * Context: May be called from interrupt or process context. May not be called
+ * from NMI context.
  */
 void folio_unlock(struct folio *folio)
 {
@@ -490,14 +476,13 @@ EXPORT_SYMBOL(folio_unlock);
  * @folio: The folio.
  * @success: True if all reads completed successfully.
  *
- * When all reads against a folio have completed, filesystems should
- * call this function to let the pagecache know that no more reads
- * are outstanding.  This will unlock the folio and wake up any thread
- * sleeping on the lock.  The folio will also be marked uptodate if all
- * reads succeeded.
+ * When all reads against a folio have completed, filesystems should call this
+ * function to let the pagecache know that no more reads are outstanding. This
+ * will unlock the folio and wake up any thread sleeping on the lock. The folio
+ * will also be marked uptodate if all reads succeeded.
  *
- * Context: May be called from interrupt or process context.  May not be
- * called from NMI context.
+ * Context: May be called from interrupt or process context. May not be called
+ * from NMI context.
  */
 void folio_end_read(struct folio *folio, bool success)
 {
@@ -577,13 +562,12 @@ EXPORT_SYMBOL(folio_wait_private_2_killable);
  * folio_wait_writeback - Wait for a folio to finish writeback.
  * @folio: The folio to wait for.
  *
- * If the folio is currently being written back to storage, wait for the
- * I/O to complete.
+ * If the folio is currently being written back to storage, wait for the I/O to
+ * complete.
  *
- * Context: Sleeps.  Must be called in process context and with
- * no spinlocks held.  Caller should hold a reference on the folio.
- * If the folio is not locked, writeback may start again after writeback
- * has finished.
+ * Context: Sleeps. Must be called in process context and with no spinlocks
+ * held. Caller should hold a reference on the folio. If the folio is not
+ * locked, writeback may start again after writeback has finished.
  */
 void folio_wait_writeback(struct folio *folio)
 {
@@ -598,13 +582,12 @@ EXPORT_SYMBOL_GPL(folio_wait_writeback);
  * folio_wait_writeback_killable - Wait for a folio to finish writeback.
  * @folio: The folio to wait for.
  *
- * If the folio is currently being written back to storage, wait for the
- * I/O to complete or a fatal signal to arrive.
+ * If the folio is currently being written back to storage, wait for the I/O to
+ * complete or a fatal signal to arrive.
  *
- * Context: Sleeps.  Must be called in process context and with
- * no spinlocks held.  Caller should hold a reference on the folio.
- * If the folio is not locked, writeback may start again after writeback
- * has finished.
+ * Context: Sleeps. Must be called in process context and with no spinlocks
+ * held. Caller should hold a reference on the folio. If the folio is not
+ * locked, writeback may start again after writeback has finished.
  * Return: 0 on success, -EINTR if we get a fatal signal while waiting.
  */
 int folio_wait_writeback_killable(struct folio *folio)
@@ -623,14 +606,13 @@ EXPORT_SYMBOL_GPL(folio_wait_writeback_killable);
  * folio_wait_stable() - wait for writeback to finish, if necessary.
  * @folio: The folio to wait on.
  *
- * This function determines if the given folio is related to a backing
- * device that requires folio contents to be held stable during writeback.
- * If so, then it will wait for any pending writeback to complete.
+ * This function determines if the given folio is related to a backing device
+ * that requires folio contents to be held stable during writeback. If so, then
+ * it will wait for any pending writeback to complete.
  *
- * Context: Sleeps.  Must be called in process context and with
- * no spinlocks held.  Caller should hold a reference on the folio.
- * If the folio is not locked, writeback may start again after writeback
- * has finished.
+ * Context: Sleeps. Must be called in process context and with no spinlocks
+ * held. Caller should hold a reference on the folio. If the folio is not
+ * locked, writeback may start again after writeback has finished.
  */
 void folio_wait_stable(struct folio *folio)
 {
@@ -670,10 +652,9 @@ int __folio_lock_async(struct folio *folio, struct wait_page_queue *wait)
 	folio_set_waiters(folio);
 	ret = !folio_trylock(folio);
 	/*
-	 * If we were successful now, we know we're still on the
-	 * waitqueue as we're still under the lock. This means it's
-	 * safe to remove and return success, we know the callback
-	 * isn't going to trigger.
+	 * If we were successful now, we know we're still on the waitqueue as
+	 * we're still under the lock. This means it's safe to remove and
+	 * return success, we know the callback isn't going to trigger.
 	 */
 	if (!ret)
 		__remove_wait_queue(q, &wait->wait);

-- 
2.39.5



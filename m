Return-Path: <io-uring+bounces-13464-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kAgMC+AeDmro6AUAu9opvQ
	(envelope-from <io-uring+bounces-13464-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 22:51:44 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id F345B59A35B
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 22:51:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 79EB330573AE
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 20:51:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C896376BD7;
	Wed, 20 May 2026 20:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="B0T0AnEW"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED073769F3
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 20:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779310243; cv=none; b=S4TNVOp+vdFq0yh82kiQ5DU/oJ6aEIi4D8q2uhHufi6EpIgu0wyDh5v6y8S3qpbytfnyNYVr8NJw3z7Kzi35gAoXGAk4TfJTRmdxREqp+20hxDjDUIraYOSfocpTCEJrWXqMXIJm2ZVk7QKASP9t+5DOKui7wXRINcGl2RBInEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779310243; c=relaxed/simple;
	bh=jJu/raWzDXHDrGY3OmHYJ5IRBMbRwIJjRLBSVuVduxw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sHANK79p5/Hprk9UytQJiMu0g+S+ac7ykjgPG3jJVqIrsPbQGX51E5Kuxpw3IZBw3yoPN+2mNe+lLYoJVs5UdFMy2ZNSzjfU8jiX+ABWZjr/GmpO30I6Yw2Zq2Uvt/Vngivgx5VXA8sG5tIHPYRKH5pv167bDX7ykY9YmZqrYYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=B0T0AnEW; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KKOBxm1521239
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 16:50:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=sToO
	R/Pf9Se6n6q9d83MywFIBvA3eA1y47gZuXeAAaE=; b=B0T0AnEW8S1XAAxYRdDC
	Jd/njvke3xOxdIRYA722oTLR9w1rS83qi2Xp/XDadg2RZ+8QRAuRaruu3txhGiA3
	WcAY2ChK5Axkc6i1dUYeDzaiPGtTmG6btqv4svi1AzfXKUxyfoU5EodM0i5uGh23
	x2xzAkPIz87g6dPT0sjt9VI9w6jwiBO+VSPSwfPFtK9zKdtSPZ+yZ9vACywTq4JE
	YI48gAATuweguQyGWHYhDCRN2/puaW69TUVcCLHFylJ3q4EmA41rhDmy9uhUvA/M
	KwbYBh3TbT9t5d9IGqAdrbF3hRkt5T1kOdVsC2L5+Q0xHZz1vyoaL5P3LSXSqmpu
	4g==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4e9avn4t6h-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 16:50:40 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-9134059a60bso1538305685a.3
        for <io-uring@vger.kernel.org>; Wed, 20 May 2026 13:50:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310239; x=1779915039;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sToOR/Pf9Se6n6q9d83MywFIBvA3eA1y47gZuXeAAaE=;
        b=bPoZ8Ma49xpm7Q4AsrjjOGfq1z098umOXWrud3Ou7I4coo9+yRoU6AWe4AGn7tHWl0
         u5JBWE2scB9RHuhnilsw0aie6D2PatqFITjzsRvST8/zjx26iyCDFz41p4vLS9LGY6P6
         VTdkfdt+IQuHAsAIZZ+PzY8bbG8b61FBuAGsk0rxsFI/63reLqGOQhSBZxtHpjg7sIvY
         SxhpEtwwpqNZ20/sXNlvPn+VtIjFYnoZHf6MPgZbrwqdc1OU3KLb6hxVnuSHoZ7enZf5
         PbuK9WAZF4M+OC4MTDy8kaVgctVU/mL/UGK+/48XmuXtx9HeCCr6eyOacuOfFWKz9Pbo
         N2zg==
X-Forwarded-Encrypted: i=1; AFNElJ8Db+EOF1BDVgYBmpW/vWVADuKBOouF/CCNI0AgBQdWnKAqjqiRQM1x8dZ9Unyx8XxG2aMHHDJKjA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwgzbwZOs8fI5hEaNvow2gPVZdXl0KaJIYzOhJrYD6JeTEkB+M4
	m4UyLhKzShmOg1ghmqzwJPQtyMchVwS22ek/a8Q9kImRfSYCVJigQKOTGQqFMgEw+jYF8j/cGCh
	60IFQG9yBXzeM0Mf1YASUzNYuTJSAXnzF2U63gCUhmkYIhDxVA82deyZT
X-Gm-Gg: Acq92OFFeODIubQOFWMkcslCzFONakJGkNuAMnVwAI6HwsCV2Pd1iSbrKdwHNdKAZef
	ciwvtfGKTPVVhAHF1PsE3mYq37CqnBZGn6p9ajbeSwPbJF4tvB7KDNBiyrIZo3MZuZe3v/o4dkV
	+bwirqF5uujK3RzijG2g7Rl2n2VIgLcjYbFwJ1/kWs8L5um07FZY7ac1p+pze061Edr4WxFnU2s
	IXFgCsv5l6DT5sA4ewhPwApn4OS5C2JE6pRwdq643yyYCX62x80sp5K+m+TquzbGLASOAlQwEdI
	/qQ4Tg4TofM2JwgzxNbyBTOvATeKNHKxe2pwft1GOcfikEnf7u9eDU1DmWbBCOHzfG0Ah2us29r
	fHmv/8YmEQ1lR8cnt5UCO+viGEjVwCYNNqciv3kEYDwTRbXvLKq02E/jet5sveNrnlo8=
X-Received: by 2002:a05:620a:f15:b0:913:e19b:2f56 with SMTP id af79cd13be357-913e19b63d0mr2524460185a.10.1779310239205;
        Wed, 20 May 2026 13:50:39 -0700 (PDT)
X-Received: by 2002:a05:620a:f15:b0:913:e19b:2f56 with SMTP id af79cd13be357-913e19b63d0mr2524452485a.10.1779310238647;
        Wed, 20 May 2026 13:50:38 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bcf37274sm2232692085a.37.2026.05.20.13.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 13:50:38 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 20 May 2026 16:48:58 -0400
Subject: [PATCH RFC 07/11] folio_wait: convert VM_BUG_ON_FOLIO() to
 VM_WARN_ON_ONCE_FOLIO()
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-filemap-split-v1-7-c36ddc2b6cf2@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779310229; l=1934;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=jJu/raWzDXHDrGY3OmHYJ5IRBMbRwIJjRLBSVuVduxw=;
 b=aWk4flyPY3yiLsLPfjIZ128cQrOIzopXW9sJDfGsMadODQh9UbsXyooxIwmWJlV2xXqudRhGw
 BU3URuIRQ6lDLnXcm0mJlBPdMp+Mm+NXsFS8CdLq15K50p/AHbAIbje
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=S6TpBosP c=1 sm=1 tr=0 ts=6a0e1ea0 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=VwQbUJbxAAAA:8 a=M6LSvAv_FjuMSCFMCIwA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: w72kmLLvhO7u98x141YS_Kpvv4_hWUpg
X-Proofpoint-GUID: w72kmLLvhO7u98x141YS_Kpvv4_hWUpg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDIwMyBTYWx0ZWRfX38F8Wm1pHqbQ
 mO4AY8KSt0U46s6DyaL9D2aFmtx9Z2GT/XtAn7GmzLB6wcgaadN8nZpwo7zG9lecIy9402DGucw
 KnnP/vT26SB+jLbpzwXew6hj0/5BFI49POEy3ELjL0rf4OBznF+pSZ0N9vcEmqDtq94WorjjK+N
 1YbRz+j9Q3R0go4zi4jk3w2A7KK+XwPnUmNI1bQ+NkfgxbXTdCjVYVk0CAKAe2Owk4KaS97qaGA
 E6SSlmOAbh8Br9gdjZ8wqA3FSAsHRSbjG9TK3isd1OtT5VF5gJC8kNojSzgVWTpigCkYTdxzSxX
 Hm5ko7BegjNryxdu6Ojcno6syHrxBxKISw28cEk38ivrBTuG8D+poiN79yUdJrc/k9SkIqn/I8s
 Ak0rnHOVr552wn6mb7tSaDm2oYGbDqm/YpXinjUW5Ekx2DRKm04exhLmxVgHFIPf1siPxigaXZ7
 WuOIpJqwCloMlSrEt1A==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11792
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 spamscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 impostorscore=10 malwarescore=0
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605200203
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[columbia.edu,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[columbia.edu:s=pps01];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13464-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[columbia.edu:+];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,columbia.edu:email,columbia.edu:mid,columbia.edu:dkim];
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
X-Rspamd-Queue-Id: F345B59A35B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

BUG_ON() is deprecated [1]. The VM_BUG_ON_FOLIO() assertions in
folio_unlock(), folio_end_read(), and folio_end_private_2() verify folio
state invariants and are already debug checks. There is no additional
benefit gained by crashing the system.

Convert them to VM_WARN_ON_ONCE_FOLIO(), as is now preferred for such
checks.

[1] https://www.kernel.org/doc/html/latest/process/coding-style.html#use-warn-rather-than-bug

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/folio_wait.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/folio_wait.c b/mm/folio_wait.c
index 70f808729f9c..52d336bc7fe0 100644
--- a/mm/folio_wait.c
+++ b/mm/folio_wait.c
@@ -465,7 +465,7 @@ void folio_unlock(struct folio *folio)
 	/* Bit 7 allows x86 to check the byte's sign bit */
 	BUILD_BUG_ON(PG_waiters != 7);
 	BUILD_BUG_ON(PG_locked > 7);
-	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	if (folio_xor_flags_has_waiters(folio, 1 << PG_locked))
 		folio_wake_bit(folio, PG_locked);
 }
@@ -490,8 +490,8 @@ void folio_end_read(struct folio *folio, bool success)
 
 	/* Must be in bottom byte for x86 to work */
 	BUILD_BUG_ON(PG_uptodate > 7);
-	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
-	VM_BUG_ON_FOLIO(success && folio_test_uptodate(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(success && folio_test_uptodate(folio), folio);
 
 	if (likely(success))
 		mask |= 1 << PG_uptodate;
@@ -513,7 +513,7 @@ EXPORT_SYMBOL(folio_end_read);
  */
 void folio_end_private_2(struct folio *folio)
 {
-	VM_BUG_ON_FOLIO(!folio_test_private_2(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_private_2(folio), folio);
 	clear_bit_unlock(PG_private_2, folio_flags(folio, 0));
 	folio_wake_bit(folio, PG_private_2);
 	folio_put(folio);

-- 
2.39.5



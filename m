Return-Path: <io-uring+bounces-13461-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WCr+M8AeDmro6AUAu9opvQ
	(envelope-from <io-uring+bounces-13461-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 22:51:12 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C7B759A315
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 22:51:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8337E304620F
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 20:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBBEC376496;
	Wed, 20 May 2026 20:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="e3ggfQ5i"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA84F375AB2
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 20:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779310240; cv=none; b=hgkkCRLmzyitKiC9pyzQDdb0g66fCDnTRTYTGwZ/3SxfssezDnmS1ZPMR1IXAh31lUdXCLSmzqLPDYPFBvcKp2SMzcmeE64fqGgTlzcaRu9rlQ6fQQatarbPhIpJThGPw6YUba+JIkmOHPTQdih2uvnt4+AkH6spfzQIztk1tMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779310240; c=relaxed/simple;
	bh=VtCji9Vx3n0Qm0HWIP6UWTPSjZWdzR1UjYoNBHm1Y+c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Xsq0qOjU1rxxj9QfjWK03dd2BDPjuk75eDAuS8Ls1s8n2/zT6L75GhPbdttIXQPk1vw9Cm54576FSYIs9Rr5aLOZ2uoAOa/5rD977PaOxNmJMFnvaxBWm6TVa+EpLAVjqca77xAG9/UbatiLj/cksuoyj0ym1QzFWGOhMpzNGNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=e3ggfQ5i; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KKO0cE2354673
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 16:50:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Vd43
	LnA947EFq0/DCZQf4Ap5tt7EnbD+Y9KrusTIT/M=; b=e3ggfQ5iJZvEHRmVWX+j
	LpFK6H+LsUTgm8fyI6wL9f0vMt7W2oIbT9qn60r4FWKZqhpLkP3JPi064tiKO5DZ
	fkdq8VvYDIilfbURYABMrhkiDk6vnaAbF4FQsQ5CbvQQ693ktoG3RgD1IfVwDM02
	GtQWDjriMuc858rYZhQ8SwA8zKivQg4b1oB+Qr69f6/kyIX0+1MuF1XwUUTlZGbR
	oBKUlf2O2jQAMQgaGGwYC/2k2+I1UR2RtYy86RcLqQb0I0x0/HoYiUO8PCbpOwzd
	LlLoeCgkDOCpeW+7VspTHmsDFE7B4hWWUbpO2aYngH6S4S0QVjQu8/n3rWcHI4dr
	9g==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4e958qwyxq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 16:50:32 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-911cf6eb48cso1260158285a.1
        for <io-uring@vger.kernel.org>; Wed, 20 May 2026 13:50:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310232; x=1779915032;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Vd43LnA947EFq0/DCZQf4Ap5tt7EnbD+Y9KrusTIT/M=;
        b=XjpeuOIOZU+Eix3KpXA8LYlpGWsdbcI2ERgzKlClyYCtg0faM9dqI3ZrGUFYkLOZ8M
         JIelS03ZgHOCdH7XQWoqxymp3j0jQBuOLc1Cm7aWLnAx4Gf9cVFwMm2nG0QPsQI4ODrh
         TsFHRKzTxiU6Xyt7Xbjqr2JUykB/uGkIlhGJ76GbAnPzdA4xnp4twkmhC8VyRV3po33i
         udD1SVPogqo9FdlH7xNCnX2IILFhs6IAV0Ig2LVDokkDAgf9f/+9Et8In78LAUycsF/V
         cXRNBPGSo78bzIKjIzTXIv0lNV+steKbFzwSzMqaTDlbwsAOLfc8E5dDuyJEjucb1eNb
         JRQg==
X-Forwarded-Encrypted: i=1; AFNElJ/qrbQ8lJMH+I4nbwtOHah8M90PB8gmxwFzrIApB+cMMwy9OxuHNZk9tOHIsRNhrP8gcd1VJMto7Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzJA1UOfngikMJQixYaasGZBKv5jGHvH8N8XmobqOlMyQ439ZGl
	XN8iBkgN+HEoIsLc84eUFwR7kEzT/3kMjJSpfzq6bEv67Y6uGAfcBg7MGqk03SxeDSi7rUH53YC
	b6nEAEqQf7CelAbFkWfaKqEwebZ92yDPYX8CpKCZyylYp1sPtGamD8tE5zgkizJrW
X-Gm-Gg: Acq92OEURd7HXMLcL7/3SPL4k/ccG1WHSMB3JgwCcEr6uQc48QL8denqax6UgwXrzj1
	2UoLW5RRS9sCFr+Xx8pbJf5gLPnArbRVmgbiNteUm8kfp+hw41VXgtHvhAb2l0L7waKtSPOT60R
	9Qb+U56p6degByIIJVBrRibs5Pt/baja+hCYOEdewhXLXUkfXXwzwEEBscUum9oX3Pfyuggcgbp
	kC9yzJc4BT1IMmPLo0yIOWvuf93fMwwQTc5+DMPTL7k4NApRKxtTFTSaR3gXoFb2GoM3FCcI1dF
	oK4CMdD9gPLMauZ2pkCb028oHnLbcdE6g+JqsKUs6dVgcG26CNdO0cAGGSoQpPzJwP5Q2jcEsMV
	ltUfTROXriAr9rHtQ8ykfBTi1KOBTyMdVym9+o1OZOvR8NHhM+rLupTSL84275REGMYg=
X-Received: by 2002:a05:620a:45a1:b0:90d:3af3:2a62 with SMTP id af79cd13be357-911d01b8480mr3765383885a.46.1779310231910;
        Wed, 20 May 2026 13:50:31 -0700 (PDT)
X-Received: by 2002:a05:620a:45a1:b0:90d:3af3:2a62 with SMTP id af79cd13be357-911d01b8480mr3765379085a.46.1779310231448;
        Wed, 20 May 2026 13:50:31 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bcf37274sm2232692085a.37.2026.05.20.13.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 13:50:30 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 20 May 2026 16:48:52 -0400
Subject: [PATCH RFC 01/11] mm: add folio_wake_writeback() helper
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-filemap-split-v1-1-c36ddc2b6cf2@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779310229; l=1111;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=VtCji9Vx3n0Qm0HWIP6UWTPSjZWdzR1UjYoNBHm1Y+c=;
 b=azfgHe+wJUmJYcnwmRy9nfEahOjxOjPQSFoLVtJuTFiY0m9rg0Q8a5Ipg+OYQuIMW9Uilws3E
 gf20tFxHI6SAIQaIiaLwaqYFsnM1ib8jXHnImDriiGvJgm0NNJdZl85
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: zIviMk7wvZNixZX2n5E3zMoZg_g1yIJC
X-Proofpoint-ORIG-GUID: zIviMk7wvZNixZX2n5E3zMoZg_g1yIJC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDIwMyBTYWx0ZWRfX0wnRyGl2WEO9
 T3PgDiJKaBngyMH+wk7+hQcIf/GxDN6AbwAHD75G6vgv1Aoq5Lk1Ulw/Lv+DQc/Xj58A/4lfPcn
 HNnkB7yxsnnkpQDPHqm9ri6DCq7aXCAEpS2y5jhlq4Zonc+ABh6JZueeXMyT3ys6CfmMZKHxJEn
 TyBsR/f/qLuU2BjkWKrABqNNwMystwo9cq3PUGdZpGmXnwGebnu615ztQRkI97F0KArFyT+9CV+
 /CWKVIUTlnive63g2WjPjAbFuDxHo76znMYvr9h2/XOOKjgz1J6wO4poCepa6uN9noPjZi/Udop
 QB2vjP9Sv0ItmJomBXQpMbg1SIdWZlDJYZ0ojy8nJK4bGhji1L+EMm9cjqv7Q0Ex3SF8NoSYSL1
 3aZD4kB7WYq8D8pL3LJWbYJ5e1M6FczrG7p8aKA+AvgYZMvTTAVunJOa1j9ClWfTPjIkwUAtLZ2
 NGI/Bz6Ii7qqUJ7aWoQ==
X-Authority-Analysis: v=2.4 cv=W6sIkxWk c=1 sm=1 tr=0 ts=6a0e1e98 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=s_jWojCdVP8jdXr2cG4A:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11792
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=10 priorityscore=1501 lowpriorityscore=10
 adultscore=0 bulkscore=10 phishscore=0 spamscore=0 clxscore=1015
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
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
	TAGGED_FROM(0.00)[bounces-13461-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: 9C7B759A315
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add a folio_wake_writeback() wrapper for folio_wake_bit() for use in
folio_end_writeback_no_dropbehind(), in preparation for moving the folio
bit lock and wait queue code to a separate file.

No functional change.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/filemap.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 5aaba0d3e81d..567742fbaff0 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1209,6 +1209,14 @@ static void folio_wake_bit(struct folio *folio, int bit_nr)
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 
+/*
+ * Wake waiters on PG_writeback for @folio.
+ */
+static void folio_wake_writeback(struct folio *folio)
+{
+	folio_wake_bit(folio, PG_writeback);
+}
+
 /*
  * A choice of three behaviors for folio_wait_bit_common():
  */
@@ -1664,7 +1672,7 @@ void folio_end_writeback_no_dropbehind(struct folio *folio)
 	}
 
 	if (__folio_end_writeback(folio))
-		folio_wake_bit(folio, PG_writeback);
+		folio_wake_writeback(folio);
 
 	acct_reclaim_writeback(folio);
 }

-- 
2.39.5



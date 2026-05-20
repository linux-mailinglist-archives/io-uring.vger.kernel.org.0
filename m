Return-Path: <io-uring+bounces-13466-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gF+YBekeDmpd6QUAu9opvQ
	(envelope-from <io-uring+bounces-13466-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 22:51:53 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C962759A371
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 22:51:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 29D82305999A
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 20:51:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09A2C377EC1;
	Wed, 20 May 2026 20:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="R6qzpP2I"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75606376A19
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 20:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779310244; cv=none; b=KVCXePtSonTTQFaoMRpeA4DjIBlCIlA/DTqDHlmMIooAY2sDTKO5DuWN76uJVAM/yNScVTOQZ9K762MRZ568aqcogCUoAgcvvGM+K7H/LO9hjHa9HHmMeuLfODzgQkYQNEICuA432WfWGvmBNpU7pszM2Q29jpElYVdbc5IrQ3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779310244; c=relaxed/simple;
	bh=dFyWvW6idGsgNVV3N8U6/Sf1EZqh/O1Nww0zGEVwRg8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nkL+F+StDK26ULZLeiNQTNDJsjgtBObKawSRhJ2tPzqYv9CymfoZtdZXFxprqMxnjA2t2vs2MBZA7ji1ivNu6UKcPQHOQ6eK3EmwuBudJi9Gff4m0OD/Y6n6eNN9YLKp7RA1WUnF0/8mo3pQJrgKMjSWP2bphzTsdCBV/hfuJ2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=R6qzpP2I; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KKOlmp362383
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 16:50:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=avRQ
	NH2N900diQes/ogN4qxa19bmdOzpQ8cdXUSTkOY=; b=R6qzpP2I6TzJ9toROuZ4
	25CAzSV0QypPvPhnHnRyFZnZ7ztKEuyAJKs24zra5vCMLYILNukkb/Tcsd217DS4
	fggTihPdbZMn+yqz2B2JBLKJEc+41PZdlH++fP5e0SMaxYoHk97ZEfIr41vmfVO5
	XXjqsssgJOCszcemHbfkWa25njREhNk0idIx4DAK/7F/BjCp3GKntlko+aGADs6u
	d6DefmlE/cw97ki7b5pBMrodg54Pz/HR+n/BZYql+ihGX5222U2LgO/KLY7N8m6F
	Up9pgnDgHsAJ2UD7LhXHFKJfSdOfrcpQEVqb5tVXZVQD1a5fjEHWUxupV7ijBmBb
	lA==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4e9dh43r05-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 16:50:41 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-9134059a60bso1538312085a.3
        for <io-uring@vger.kernel.org>; Wed, 20 May 2026 13:50:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310240; x=1779915040;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=avRQNH2N900diQes/ogN4qxa19bmdOzpQ8cdXUSTkOY=;
        b=T67JzHNom66Ru2RKP2qaQo0dw/jWviwbjAZD5bmKlt+vhFfJWtaz2TAyvZ1nT9Ussw
         atnK11IR22bkxAMniaZ7L1LKSIENtQFA5d3s2ZpKMsab3IJfVoCZe7DkGZYhFjg8I9NR
         UE4LL9Ksekb6X9NZRGutWp7aN5bhGxpop+jV6LLvXwn4QimH+qHg0yjGRsrjEm37LsIu
         DAE89wEhhPxJnxH9OUdPcF8Z97PWEuhEDACai3AgApsLDoWZZ/EYITjbcx6mgoDUrQOa
         YpoLT98Q1L4Vcn8Ix7j8s6Uf2fnhcInZs/LIAgg+ep/Faq50eX1FW78m3SxKxFqycNSj
         04/A==
X-Forwarded-Encrypted: i=1; AFNElJ/L9yUmIik5C0/jDYBI4DBVswu9xtxuszvRjN6S6XRP9WDlcmWNs7AJyCZmCxvR+HR3Y4C64wogPQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzRPVK/WOHkIfKw0ukEerj4/v4nAceNiqKdV8cd4q/3f3bnU8dF
	kwh6q09fm5lsV/WymJfMIeu8TorchbF5NEzmfChSQmMQgOoNX+yC3sCDEKnQ6pck+iU+Q5Tialq
	p18+/0pRez1luyH+oIntNrmeKCiSbQvCfJVH3h3uV0Bnho4BStCzA7iOG
X-Gm-Gg: Acq92OFtOtT1pZBaGjrfmr+0rS2KkiSoQSs/doujse9oAyb2RsCoalKOdX52kyTd8QF
	nBQQWcej1EoPie8xQVWKJ188yC4w3WtJgOU+uSyVKrDqcIxhF65uHhBPq2TmJEnWk+C2YJWh0dh
	Qik+bggscmoDijEWFLNtS88eBXzgVRY4qV48uN+eVpIs2dHltpAbxDNuKS9y0Z9aY5ZRTUpe+nG
	s0b9s3oWvtwJqgLzCP2A4rS5R8p7uGQYsxNv2YcbNG5BamvmeZSD/TitDfPihT+/dLmD28GHOjv
	hIl9CrFR7aCslmh+qouLFxPt3mefX3I9NfvembhUTzNCRqFrqGsS/2NeTATT7oFp2JUfRyyTO4D
	OScOP/Rc2bT4M3vfT/FMuqUStsUpKxcbyOYqZ89n96EsMfSF7AJE+X3zkhXNvJNXh52o=
X-Received: by 2002:a05:620a:28c2:b0:909:e4dc:fb32 with SMTP id af79cd13be357-911cdc429b7mr3837078185a.33.1779310240607;
        Wed, 20 May 2026 13:50:40 -0700 (PDT)
X-Received: by 2002:a05:620a:28c2:b0:909:e4dc:fb32 with SMTP id af79cd13be357-911cdc429b7mr3837072885a.33.1779310240054;
        Wed, 20 May 2026 13:50:40 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bcf37274sm2232692085a.37.2026.05.20.13.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 13:50:39 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 20 May 2026 16:48:59 -0400
Subject: [PATCH RFC 08/11] MAINTAINERS: add folio_wait files to MEMORY
 MANAGEMENT - CORE
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-filemap-split-v1-8-c36ddc2b6cf2@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779310229; l=850;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=dFyWvW6idGsgNVV3N8U6/Sf1EZqh/O1Nww0zGEVwRg8=;
 b=HPyU6CJCZ8kqU8alpJJp2HCe9isKSiBdanKUUwMFGvy0Q00sMV+3afcEBole6GJFz/iDcpiMr
 llz2jdaNdK3DhYhQLMgNYC2AXXFscR5FYH0b1/6uHxLX4UxQ5UB3BTb
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDIwMyBTYWx0ZWRfX1zHS5FHR2f6g
 R42HzqtrhvxBIfJhRBkz5MF1I15HmG4UetgA8s14M3MpqIRk0krpJSXjRIqxa4lnOzDuFOK0pwH
 vpq+X0yzs06rjhuY3IjU30VQQwjiWVsca5NQi3daz+UTAcpVVnYL0Wkt4qPpSCwUs7mnEs7vGFA
 TINivGcWZ5OURXELleNYDXPZfunprVDsqLc198O42JZ2VSx5UXNkPMFmBGWN+2UkGcobPvPqgor
 N0s1v9+pIAnK3ilkKlovnO6ci2MVQ7hK0mK6HkUNetnw6vHcCJHrXVKnA864W6NeK7nj8eTAutT
 JOnrmO74gb48y6wMl3voAtNfKFuXJSEXn8OC29Lk89d2lzAH0omBqWIyBFPnKMI5bJV7qHtYZ+J
 Dypg/oMV57SzYtaQAucfMynKwAmIAJt3ntRwCrZuhNjttwVMzW8Y8Mq6iP42owIjfCzcH8/C1yV
 SbYu7BPGZspFV4ixaEg==
X-Proofpoint-GUID: jSH1th7XQZ7s5AzFvDIlUsBIZiFCwi3F
X-Authority-Analysis: v=2.4 cv=OYWoyBTY c=1 sm=1 tr=0 ts=6a0e1ea1 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=1-S1nHsFAAAA:8 a=VwQbUJbxAAAA:8 a=hdCJvu6vi-O6ykQZt0QA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22 a=gK44uIRsrOYWoX5St5dO:22
X-Proofpoint-ORIG-GUID: jSH1th7XQZ7s5AzFvDIlUsBIZiFCwi3F
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11792
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 bulkscore=10 priorityscore=1501 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 phishscore=0 suspectscore=0
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
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
	TAGGED_FROM(0.00)[bounces-13466-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[columbia.edu:+];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[columbia.edu:email,columbia.edu:mid,columbia.edu:dkim,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,linux-mm.org:url];
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
X-Rspamd-Queue-Id: C962759A371
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add mm/folio_wait.c and include/linux/folio_wait.h after they were split
out from mm/filemap.c, mm/page-writeback.c, and include/linux/pagemap.h.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8cf9ba51d981..bfe1488d9030 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16781,6 +16781,7 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/linux/folio_batch.h
+F:	include/linux/folio_wait.h
 F:	include/linux/gfp.h
 F:	include/linux/gfp_types.h
 F:	include/linux/highmem.h
@@ -16802,6 +16803,7 @@ F:	kernel/fork.c
 F:	mm/Kconfig
 F:	mm/debug.c
 F:	mm/folio-compat.c
+F:	mm/folio_wait.c
 F:	mm/highmem.c
 F:	mm/init-mm.c
 F:	mm/internal.h

-- 
2.39.5



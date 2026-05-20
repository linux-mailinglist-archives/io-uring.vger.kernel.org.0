Return-Path: <io-uring+bounces-13469-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AGu7CysfDmpd6QUAu9opvQ
	(envelope-from <io-uring+bounces-13469-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 22:52:59 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C7B0D59A3F7
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 22:52:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9640A30625A9
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 20:51:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DDD9378D63;
	Wed, 20 May 2026 20:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="iHJauhNO"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA84377553
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 20:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779310246; cv=none; b=bPsLkyMh1zAFT9CKFBsJLNqB3HLsb48e3p1CiihoyGP4AMZXc+zuV/uKIIqAUqbch3VvSQaW9GiDqEmJg56RwRydyP682lLziIJ4UUZuYTq1+El7XR2hJI4uiODYyT0nYnHOnp6T5uUlESP7QolXXXe2lXizFOK9m1M48HBB4+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779310246; c=relaxed/simple;
	bh=rA3ee1bVN85AK8Xbqqgod0QTROlaUP31hnwYXO5EEik=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mpbqVUKHQLWuQpsCs9Poo5iYihdwN07KPLWQC2/OCGQhHGnyhIDhCmfZbu+uLP61topZZth1lmiiS0StPui8KGQExhuXPMEAvCGCPX1jSMM4Ga06moATAtQ9oR+daqUWLy7N27BnV9FO0wJVY34cFg8bKBwrypmltyarXf/2rxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=iHJauhNO; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KKOM4u1521408
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 16:50:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=yDlB
	tkSZ/QVPh/7V2LuCLj7vDoerhrZrGeObhOfbEDE=; b=iHJauhNOQfQGuWQ9PBMd
	9498doyET3MaIYPPH6gAxhnfTbaNfiN2HpEWnhfQQydxrwb9YLjAr0f4Hzz9oE/O
	fgZj57LX1AT6vGPBI4TBSadyl2n+Ha4Tz+b8UVbJXRMfLIBkIuY/Ve9fGyVT4co8
	CWfypz/xg3x2wPetKTOGO0gbdH/nfd8bk8oUJYPlHyI8bnWD4jXB1S/B9q8XPwVg
	a/q7T59AHt1VqQQ1Jq/DCsxu26G8aGUFIr5qhSBAsd9ZVD/1vrojSd1jGW4Sf5ya
	FNIQdmkD5+yJCvLbmPd1L6c+MvkJlF6HEAnpWHT38ExeFCzYB0ApWQz8kBWW88CI
	Fg==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4e9avn4t6w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 16:50:42 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-90d6fe98316so1206840185a.3
        for <io-uring@vger.kernel.org>; Wed, 20 May 2026 13:50:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310241; x=1779915041;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yDlBtkSZ/QVPh/7V2LuCLj7vDoerhrZrGeObhOfbEDE=;
        b=SKx0TRP14T36XaSRnJUpAGOYJhr9DRXsQ1H9WMJDqCnnIalsHp4YTi5VCmDI2Dc7+R
         CnyZfG91Jeg2MHGuI771dPivm/s+8Ph2l8cFyqv9xgqeInXzgaLLVa8qiy1UWG5a4Kkp
         p1W9kOIVPg1eFDMKFly7+5mqsotzfZZJ3tRUAi0ICPwLcIlpputUcFZMHtIZPhWk+2xD
         Raz5oEA5QKz9CnHZT/NuLzk/qxhCntkaDwwT6KEdPhDhg9i2AvsmvsSt8UuwlJaR1s0T
         3MjI0TAXSKs0Ud+KtahDYxRIfzwfwhdkAjrUPmK2/2CMffU8jXd8OoUPpq5SgzrioRdJ
         a52w==
X-Forwarded-Encrypted: i=1; AFNElJ8mWMKsUfnrS0WPs7ZiZXw9Jhm9K9zi6fnRveSsfl2xtT4L3jY+TxNKdkXEvEjtX8p1fecXsSuy9g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxeYeRwT6duHj5A5toij0jnEKjBaiKSCz8ccVGPbvCLNieTA8sW
	IvkmH1ZbUWzB8Cg3wnOZ7AWoYCeVe6qaFiURtlKHwqyiz4rG1P3WRXRAP1mpgSMUbhbAMc2ww/U
	czrOut9KsdqCA40WCBm+o/d2xpRj9aoly6VdvyKr4DG1CLSLReByRBGgN
X-Gm-Gg: Acq92OFBt9FPAD1wtOrof9nqGObG4FC8YWfSBASUb1WpnrY/2HcHuMOOQF6A0S6mOhj
	ZZgb/NuoHER4hJQi6tUIcqHr6bWZKvvzo9dU3V8JWPlNKBSIhGAi6F72b3J5p60iAZ0Ki3cw00N
	r+LNCQJrc0zuJZbuI8NoluErV/BY1Fwo0gOW08VUI+yA/9V5Q3YJpemgCIjJf3xNdtKpr49FIKd
	1QTylHLoVvRPXD2cOGMlJBTju2CPHHvAWSD8cVox/8GUNkcoU135j5JoIo+1/On59hHxKk/GFC2
	pMxtO+LDxmiMdxFRMJKqIwLTZH4yvSA/sbDmUSp8n7m8ACCnzdUoOZU/jPiWHF28BGa5c6DWWtD
	0QiYk9D+4G6/5Nq4hyQJR2710hhjppBsXivbmBz0JEQVC/3t/5ZrNjyyIQkPlcukpGZwi5ABtsU
	f1qQ==
X-Received: by 2002:a05:620a:1986:b0:911:ed:d285 with SMTP id af79cd13be357-911cf9e0c41mr3857314985a.62.1779310241562;
        Wed, 20 May 2026 13:50:41 -0700 (PDT)
X-Received: by 2002:a05:620a:1986:b0:911:ed:d285 with SMTP id af79cd13be357-911cf9e0c41mr3857309585a.62.1779310241059;
        Wed, 20 May 2026 13:50:41 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bcf37274sm2232692085a.37.2026.05.20.13.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 13:50:40 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 20 May 2026 16:49:00 -0400
Subject: [PATCH RFC 09/11] fs: move dir_pages() from <linux/pagemap.h> to
 <linux/fs.h>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-filemap-split-v1-9-c36ddc2b6cf2@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779310229; l=1369;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=rA3ee1bVN85AK8Xbqqgod0QTROlaUP31hnwYXO5EEik=;
 b=DCkZp86sCfuyRVBmRVmURwps78q7smwQhnDSiFfY5HPBUU3kJlF0UIoGU21dz9wQUTuZXJkNF
 UGqHDG78m7UBDAclN2Kez4FnTKNYWYrHvBGgRUTdHLcho2GLQ+5jpkl
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=S6TpBosP c=1 sm=1 tr=0 ts=6a0e1ea2 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=8LwvE8iKX1rSyJpzT4YA:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: 7yBtaFt9Zk8vokTC4nubPHHK52q1eo1l
X-Proofpoint-GUID: 7yBtaFt9Zk8vokTC4nubPHHK52q1eo1l
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDIwMyBTYWx0ZWRfX7OOs9wC7oW/c
 MnfQP0Awxc+Ub3DGBDva5Pfi79LXiwzosAcb6K7G8NrPRkLV/qBDTQtR3BT1DFjbEz6epjgAbO/
 Od39nDPZY31e4EMnnECLoklDp6gplXkdGk18ubaIIFmpMUTK7EIeUgfc3bJaITwJeNjlLen+Gpr
 ZBCvASm01Its2K2EnkoML1wJaUyPQzn+H23vPxSxJ3v8Lg9OIDz7Dtsp9jlhZGIPYK99GIthaXt
 MVVuW2o5vELXZrPC4MiuWge3yCETe7+vMFnO5z1jjKy8Gn7OYdHi4wwjDhf9osAnmXqhK05lKUB
 yeHvS4Zu8kFQpUcaI4tLvQY72I8cdnM84EOEWpLKJLabhSi1nG6hPpTgiZB4kUsggMzJMXjP7Rx
 Gw/uGAjXOHu1/hmbwlUImDHSB36o4fRXHUw4WrdIC5V1nJxX/Q8Rno1Y+xdJOxHXNh6Xy9Qjkt/
 5rrT1aD8uqtt0Xf15Sg==
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
	TAGGED_FROM(0.00)[bounces-13469-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: C7B0D59A3F7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

This is an inode-based helper and should live with other inode helpers.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/fs.h      | 6 ++++++
 include/linux/pagemap.h | 6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index cd5088dfe9a1..776cc82932a7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1171,6 +1171,12 @@ static inline void i_size_write(struct inode *inode, loff_t i_size)
 #endif
 }
 
+static inline unsigned long dir_pages(const struct inode *inode)
+{
+	return (unsigned long)(inode->i_size + PAGE_SIZE - 1) >>
+			       PAGE_SHIFT;
+}
+
 static inline unsigned iminor(const struct inode *inode)
 {
 	return MINOR(inode->i_rdev);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 84ccb682cca8..f86a550ad516 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1356,12 +1356,6 @@ static inline size_t readahead_batch_length(const struct readahead_control *rac)
 	return rac->_batch_count * PAGE_SIZE;
 }
 
-static inline unsigned long dir_pages(const struct inode *inode)
-{
-	return (unsigned long)(inode->i_size + PAGE_SIZE - 1) >>
-			       PAGE_SHIFT;
-}
-
 /**
  * folio_mkwrite_check_truncate - check if folio was truncated
  * @folio: the folio to check

-- 
2.39.5



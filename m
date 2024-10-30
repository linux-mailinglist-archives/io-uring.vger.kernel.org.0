Return-Path: <io-uring+bounces-4230-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C2469B6BBA
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 19:10:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26E3A2815DB
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 18:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C05431C4616;
	Wed, 30 Oct 2024 18:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ooQouuMB"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532421CB333
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 18:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730311813; cv=none; b=QWsBBas6hN//myBV/PsbmnVeGKo18fJEbONQc5nZOIIv1GHBW2w026CM9Eq/Rdo4IpNl8+FCM/eef8XAHnhGBiLDztgwKPWRKMpO3UmdKh4f0rYVEpyq3V7JjqAjDx7YthuqIgjT8c6ZRW97OGUNXoT2zqwg5fGXgJ/1irrDFkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730311813; c=relaxed/simple;
	bh=+pH+R0JLSo9zCRylUri4bjQjSVlwjajO0NDILV+o0LM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=LjGfdjt1D4FSYlLS+DdfmfiBCpGeMvjdwBsGhrGjDkYAM1+vmk4r+6dgSH4wAkFcahkcu6k0twj7vaWpSAn3AXKwsrKp/GPMnCfvhsdV84DFS8YfuMzmj2wUYMGs7k67DJiLNXeh9bt6+5o3xLzV8Zx4YtEKVCo4BoEZ5fyHviI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ooQouuMB; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241030181003epoutp0497f64963f823f50d7b3c9e6b00ce9bd0~DTWrjtsTv0312803128epoutp04N
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 18:10:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241030181003epoutp0497f64963f823f50d7b3c9e6b00ce9bd0~DTWrjtsTv0312803128epoutp04N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730311803;
	bh=qlGQO+VBfRMV7p/1S/16PyYIBPumquj+mnc3pi8o4zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ooQouuMBj/0xC0mlCGqkrg0vM8PrU47GBsMAhDuxAAaK7liGHBH2mfLNJzRyKSdov
	 pXOa7iAIYg9vEMpaaZ/V9kd5uWiCcwDlUzI8b1kKLzmKqtGGyzBv2dugsllDdE6Mr/
	 291uqFVh4W4f5CNkhGIEyLO53StGUmCz9+nKJRic=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241030181002epcas5p12c90229c3774a81f82dc1b86c5a0d711~DTWrDg_MC2159521595epcas5p16;
	Wed, 30 Oct 2024 18:10:02 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XdwBx2RJ6z4x9Pp; Wed, 30 Oct
	2024 18:10:01 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F1.2C.18935.97672276; Thu, 31 Oct 2024 03:10:01 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241030181000epcas5p2bfb47a79f1e796116135f646c6f0ccc7~DTWo1LXbV2064920649epcas5p2m;
	Wed, 30 Oct 2024 18:10:00 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241030181000epsmtrp1340bdeb7bf891dcb84a3a6709330a72b~DTWo0WDiS0151201512epsmtrp1Y;
	Wed, 30 Oct 2024 18:10:00 +0000 (GMT)
X-AuditID: b6c32a50-cb1f8700000049f7-9d-67227679628a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	01.69.07371.87672276; Thu, 31 Oct 2024 03:10:00 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241030180957epsmtip20e86f2a78cce70206388c78df4a944ad~DTWmeJLbB0686406864epsmtip2K;
	Wed, 30 Oct 2024 18:09:57 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, gost.dev@samsung.com, vishak.g@samsung.com,
	anuj1072538@gmail.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v6 01/10] block: define set of integrity flags to be
 inherited by cloned bip
Date: Wed, 30 Oct 2024 23:31:03 +0530
Message-Id: <20241030180112.4635-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241030180112.4635-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDJsWRmVeSWpSXmKPExsWy7bCmum5lmVK6wcn3PBYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ
	19DSwlxJIS8xN9VWycUnQNctMwfoHSWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpO
	gUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsaEny+YCv5yV8y8fZepgXESVxcjJ4eEgInEjauz
	2bsYuTiEBPYwSnx9doMVwvnEKLF12jco5xujxIRpc9hhWt5e7WKGSOxllOi6dJgNwvnMKPHt
	zh2gDAcHm4CmxIXJpSANIgJLGSVWXo8GqWEWaGCS6L3bywySEBaIk1j3ZSnYVBYBVYk3B/eD
	2bwC5hILj+1mhNgmLzHz0newOKeAhcSHHTdZIGoEJU7OfAJmMwPVNG+dDXaRhMAVDonH09ey
	QjS7SGyetwLqbGGJV8e3QNlSEi/726DsbIkHjx6wQNg1Ejs290H12ks0/AEFBgfQAk2J9bv0
	IXbxSfT+fsIEEpYQ4JXoaBOCqFaUuDfpKVSnuMTDGUtYIUo8JO7cyYMETzejRO/3U6wTGOVn
	IflgFpIPZiEsW8DIvIpRKrWgODc9Ndm0wFA3L7UcHrPJ+bmbGMHJWitgB+PqDX/1DjEycTAe
	YpTgYFYS4bUMUkwX4k1JrKxKLcqPLyrNSS0+xGgKDOOJzFKiyfnAfJFXEm9oYmlgYmZmZmJp
	bGaoJM77unVuipBAemJJanZqakFqEUwfEwenVANTR/ea9zt3LDiRGZHTPS3APOfHgkiFrzor
	F8WsPHfnRNZl18Qn/2uUBCc+fbsssXS/9sH6iQemTpBu1HOYbqt16+YygXIzLQ72mafm7/m4
	7tWvG3vn7JwS0bMgaeoylinfUu4esL8eKHbfdGdVlFnyo79PBZn5dYwvnLpoclFqXiB7noD+
	XVHxS5dXsuhp82S+2P7rm/6zSkYP+STLt7l//7iaX7rtzJ8p2jItN+D9nb9MXt+zDy6aYjSL
	c3bpbu1znIlO2zsm+HXE6Atues6zaeV65YKNUfrmP01yNjbUiIplZc0w9H6RWr3Dd/Yb6bS3
	AR8cbB6sSD7dL2d6/lxtR4KPMs+TMtfHk2KcVEu/K7EUZyQaajEXFScCAMJsJH1fBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42LZdlhJXreiTCnd4Oc6AYuPX3+zWDRN+Mts
	MWfVNkaL1Xf72SxeH/7EaHHzwE4mi5WrjzJZvGs9x2Ixe3ozk8WkQ9cYLfbe0rbYs/cki8X8
	ZU/ZLbqv72CzWH78H5PF+b/HWS3Oz5rD7iDosXPWXXaPy2dLPTat6mTz2Lyk3mP3zQY2j49P
	b7F49G1ZxehxZsERdo/Pm+Q8Nj15yxTAFcVlk5Kak1mWWqRvl8CVMeHnC6aCv9wVM2/fZWpg
	nMTVxcjJISFgIvH2ahdzFyMXh5DAbkaJ+bPfM0EkxCWar/1gh7CFJVb+e84OUfSRUeLz4wuM
	XYwcHGwCmhIXJpeCxEUE1jNKnN07gQWkgVmgi0ni8gZuEFtYIEZiZv9OZhCbRUBV4s3B/WBD
	eQXMJRYe280IsUBeYual72BxTgELiQ87boLNEQKqub7wDFS9oMTJmU+g5stLNG+dzTyBUWAW
	ktQsJKkFjEyrGCVTC4pz03OTDQsM81LL9YoTc4tL89L1kvNzNzGC40xLYwfjvfn/9A4xMnEw
	HmKU4GBWEuG1DFJMF+JNSaysSi3Kjy8qzUktPsQozcGiJM5rOGN2ipBAemJJanZqakFqEUyW
	iYNTqoEp2mmDseaG3HWa7Wztk5lPL4s+9s3FLV5zYuGCOy6d01mL3z5I3zV3R/mGo7sXZuj/
	y/24X/Fz7QStU98mzt4VqdxcOz1l2TzWojyDxfJv5v+3imFdJXJnx0rjzFzXqqf2J9a2Ogb4
	PDnt73Lw/lNeV1WhSWH/c6yeBjlMWOVdp/qiqC748P60FMMJmY3p5WH2eaZT2reG/8x7sauo
	3eFeovS3iu+6IlXrz7t85BO7/ZLlevbTuSILml9NnnMpIHbK61UNnCUbLeo/RtrVru1jDN2+
	/Hkl78MLeyR+KqrOybaxsA8ra/QyybbXSvzJIl/t+mPrAmf14N48xq61VQt+LqqomnfoylyX
	j053nDyUWIozEg21mIuKEwFfjkWgIgMAAA==
X-CMS-MailID: 20241030181000epcas5p2bfb47a79f1e796116135f646c6f0ccc7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241030181000epcas5p2bfb47a79f1e796116135f646c6f0ccc7
References: <20241030180112.4635-1-joshi.k@samsung.com>
	<CGME20241030181000epcas5p2bfb47a79f1e796116135f646c6f0ccc7@epcas5p2.samsung.com>

From: Anuj Gupta <anuj20.g@samsung.com>

Introduce BIP_CLONE_FLAGS describing integrity flags that should be
inherited in the cloned bip from the parent.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
---
 block/bio-integrity.c         | 2 +-
 include/linux/bio-integrity.h | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 2a4bd6611692..a448a25d13de 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -559,7 +559,7 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 
 	bip->bip_vec = bip_src->bip_vec;
 	bip->bip_iter = bip_src->bip_iter;
-	bip->bip_flags = bip_src->bip_flags & ~BIP_BLOCK_INTEGRITY;
+	bip->bip_flags = bip_src->bip_flags & BIP_CLONE_FLAGS;
 
 	return 0;
 }
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index dbf0f74c1529..0f0cf10222e8 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -30,6 +30,9 @@ struct bio_integrity_payload {
 	struct bio_vec		bip_inline_vecs[];/* embedded bvec array */
 };
 
+#define BIP_CLONE_FLAGS (BIP_MAPPED_INTEGRITY | BIP_CTRL_NOCHECK | \
+			 BIP_DISK_NOCHECK | BIP_IP_CHECKSUM)
+
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 
 #define bip_for_each_vec(bvl, bip, iter)				\
-- 
2.25.1



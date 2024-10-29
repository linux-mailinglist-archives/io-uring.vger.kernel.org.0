Return-Path: <io-uring+bounces-4135-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 586389B5055
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 18:23:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15A7C285920
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 17:23:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1A931DA31F;
	Tue, 29 Oct 2024 17:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZGUJdLQz"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB8119992D
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 17:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730222618; cv=none; b=sdklpmUui2UWEm78B4IvenKTQ1jJnhaZnFOq1ysbt++dod+bQIU0+Kx4ZZwLGzX19LafWT+My4npSDviIS4HKCr3kGxG6PKreJkBuolm26FyHkIIxq6jOqK8hWjWMY1PVqRj1YUs3/WB+rfv1ILbUbHRdsR4/RY/6vDxFgs7vlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730222618; c=relaxed/simple;
	bh=z3oZCEUpNWP6ssVVNnvaEMGwTgZ5HxAO2xsIC7OVOu8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=cv4i2YXP6PIOT1/TpC8KUmCq9xdecPtFMmgkfjxP3pb7N7SNdJMnYkFxG4jVYQyzYbxbu9dVshgVWijz9/ULwbH/04cY0jJtk7Tnpz1e7a1zWwQMw4CfQ2/+0QVhhuXCBDf4lJRDELXP9+1YB5t/15Nco9Tgwk0Vt8575ARg2Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ZGUJdLQz; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241029172329epoutp019e320c007dae50ca54c8cfc720eb2d54~C-EvDpSsa2983329833epoutp01B
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 17:23:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241029172329epoutp019e320c007dae50ca54c8cfc720eb2d54~C-EvDpSsa2983329833epoutp01B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730222609;
	bh=n6LNHR2UxOEOGCqUSfrJ4D/dcAXYHqklNM5hsVN/lLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZGUJdLQzXfB+Jn+OV9uPft2c3Lw7ObN4HT8krFnTomAGD7B01CsLnOSt1qnlVUFEZ
	 dN7CLo0Sz9gTPbp5ouT21yUFK0NXeONz13meHiBsGczGrzlZB/rMN4jaGVEAFChgDZ
	 7nLdJIeJTmPDE6V4v7wU1gLkFNRW+fm42WSZIuGo=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241029172327epcas5p15535030cdb0b11a5fccbccc2884959e1~C-EtQ8P8J0037900379epcas5p1R;
	Tue, 29 Oct 2024 17:23:27 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XdHCd4hSqz4x9Pp; Tue, 29 Oct
	2024 17:23:25 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B1.D6.08574.D0A11276; Wed, 30 Oct 2024 02:23:25 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241029163212epcas5p343cd56d66b58a9e7e8e1faa98067891d~C_X9UiqHl1013710137epcas5p3W;
	Tue, 29 Oct 2024 16:32:12 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241029163212epsmtrp1f4a60e084ee71d4f462f7b95f77989a7~C_X9TsX_o0723107231epsmtrp1g;
	Tue, 29 Oct 2024 16:32:12 +0000 (GMT)
X-AuditID: b6c32a44-6dbff7000000217e-f7-67211a0d8c6c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	CB.09.18937.B0E01276; Wed, 30 Oct 2024 01:32:12 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241029163209epsmtip2d32c463467f446bfe0b00d6644ddd425~C_X7DJ2U50887408874epsmtip2h;
	Tue, 29 Oct 2024 16:32:09 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v5 01/10] block: define set of integrity flags to be
 inherited by cloned bip
Date: Tue, 29 Oct 2024 21:53:53 +0530
Message-Id: <20241029162402.21400-2-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241029162402.21400-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJsWRmVeSWpSXmKPExsWy7bCmpi6vlGK6wdOPChYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ
	19DSwlxJIS8xN9VWycUnQNctMwfoHSWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpO
	gUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdkb/rWWMBZe4K471b2JsYHzH2cXIySEhYCLR/WUG
	SxcjF4eQwG5GiaPH30E5nxglGk8uZIZzWq6/ZoVpeXjsBCtEYiejxJ//a9kgnM+MEpNfnWcC
	qWITUJc48ryVESQhIrCHUaJ34WmwwcwCLxkllq5axAJSJSwQJ/H30A1GEJtFQFVi9fNrbCA2
	r4ClxPemFjaIffISMy99ZwexOQWsJI4d3cMEUSMocXLmE7A5zEA1zVtngx0rIXCBQ2L7t6vM
	EM0uEj2ft0MNEpZ4dXwLO4QtJfGyvw3KTpf4cfkpE4RdINF8bB8jhG0v0XqqH2gOB9ACTYn1
	u/QhwrISU0+tY4LYyyfR+/sJVCuvxI55MLaSRPvKOVC2hMTecw1QtofEg0ezoYHayyhxrvEB
	2wRGhVlI/pmF5J9ZCKsXMDKvYpRMLSjOTU9NNi0wzEsth0d0cn7uJkZwKtdy2cF4Y/4/vUOM
	TByMhxglOJiVRHhXx8qmC/GmJFZWpRblxxeV5qQWH2I0BQb4RGYp0eR8YDbJK4k3NLE0MDEz
	MzOxNDYzVBLnfd06N0VIID2xJDU7NbUgtQimj4mDU6qBqb2t65mawodwfePJB35YGOm+YIyb
	/75gnYSXt+KXvQZvgzvZegQNOSeVmbOtnS2zef/2ttwz0TLJC/S7P2+x8fHZ3Ob/K/6t6jOu
	B3+i2FkmnKmr09R+l3j476ydVfO/s76b9kLT+J/rdqlTh45eOz3VzlBE3lE7tz26aNE0lsPT
	+Q7zKC+07594/aFZjNvt63o/t8w7WjGpki++KIR71hmzrwU75eeUFi2Y0medvq5XLKZwcp/m
	tfvSGnu+T1B+rpl9qpnt0ZLM5A3Tvxpsln1eM7s/31veVJctnH33D42dK9LnvzvR9vD81nCJ
	NrYXRxbPjPBuapKv+1/UHN3u/+6r1q3/B9mXB0xzs1dNUGIpzkg01GIuKk4EABG515JuBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42LZdlhJXpeHTzHd4Ot5JouPX3+zWDRN+Mts
	MWfVNkaL1Xf72SxeH/7EaHHzwE4mi5WrjzJZvGs9x2Ixe3ozk8WkQ9cYLfbe0rbYs/cki8X8
	ZU/ZLbqv72CzWH78H5PF+b/HWS3Oz5rD7iDosXPWXXaPy2dLPTat6mTz2Lyk3mP3zQY2j49P
	b7F49G1ZxehxZsERdo/Pm+Q8Nj15yxTAFcVlk5Kak1mWWqRvl8CV0X9rGWPBJe6KY/2bGBsY
	33F2MXJySAiYSDw8doK1i5GLQ0hgO6PE/il7mCASEhKnXi5jhLCFJVb+e84OUfSRUWLm/C52
	kASbgLrEkeetYEUiAicYJeZPdAMpYgYpmvBlNksXIweHsECMxKk+D5AaFgFVidXPr7GB2LwC
	lhLfm1rYIBbIS8y89B1sJqeAlcSxoyBHcAAts5Q4OckNolxQ4uTMJywgNjNQefPW2cwTGAVm
	IUnNQpJawMi0ilE0taA4Nz03ucBQrzgxt7g0L10vOT93EyM4urSCdjAuW/9X7xAjEwfjIUYJ
	DmYlEd7VsbLpQrwpiZVVqUX58UWlOanFhxilOViUxHmVczpThATSE0tSs1NTC1KLYLJMHJxS
	DUyJOirBSccylpy9pf3vRTaf5R8XNdGnAjKX9ySxfsvc5JyXtm1vEFdgiNnvTQt37pzIKHl9
	0WOBEy+Uw+buqsnTfMthm/j3ikPfq5ts01bxRa59cern/uK1p21jXtzI+2m0ftaH7kPK2xs9
	mjd3+MVvbp8y57mI45VKlisrylyMXBqu+/FWip3svhacVbLgUP+0A49u7dNY+Pj2yuPpBd8s
	j/Qsvb+m7O8t03c2Cu5fPzzN2rWKzX/3pLNptzdxrNDquf3u3vMwMfGFP85c+W/3ulvoo/uf
	to/eyyZGruLNXFzW5MduorAzUCtgX/SJM/9i+uaYGO7+qBCqeSYoYCdvWO+tCObYd5JdG5nK
	tnvmKLEUZyQaajEXFScCAHpm5E4dAwAA
X-CMS-MailID: 20241029163212epcas5p343cd56d66b58a9e7e8e1faa98067891d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241029163212epcas5p343cd56d66b58a9e7e8e1faa98067891d
References: <20241029162402.21400-1-anuj20.g@samsung.com>
	<CGME20241029163212epcas5p343cd56d66b58a9e7e8e1faa98067891d@epcas5p3.samsung.com>

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



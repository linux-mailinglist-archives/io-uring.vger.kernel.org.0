Return-Path: <io-uring+bounces-3723-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7FCE9A09E5
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 14:36:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 332F1B2861F
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 12:36:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3777E2076BA;
	Wed, 16 Oct 2024 12:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="OMTLVxwy"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EC1208201
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 12:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729082177; cv=none; b=kh4ftZC4puUcvXKkbnuD+dHyCTZi7KLWthL5O41wKDlYEFijsd1sqsxSKXbqBtd6zMqRO/waUHqSy0DIE050uHEX7Etm4Hx8RmaLMUDhfbw9GqgTetsA9JERK+nhz+LIpbtPTtsOd5lM2Lvbke91W8Vme7e9f2Rld4OCWcf2S1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729082177; c=relaxed/simple;
	bh=JYbAqvDZtvFYF0NPlNV17yTtG4+nrjd64NKUzbtHnvY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=asb8gx0LCPdGec8lP31d9jq7VoWFceC1OFRLJgr2J/0SJsx2LKSR7ykwAZ5oW73bFxl7XAumFjH5bAPLaLBMcQhTWQDDyb3SkOnATr2Ukun3b0gZflCBIumG/sAjdTVUP2DXLeMiUM+Pi6UGkFXblOIEBoIN3Igv+5h7Dg291/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=OMTLVxwy; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241016123608epoutp04fae2ad48fc048ecc6522b83d99c8039f~_7xIjFrFw1941219412epoutp04c
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 12:36:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241016123608epoutp04fae2ad48fc048ecc6522b83d99c8039f~_7xIjFrFw1941219412epoutp04c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1729082168;
	bh=mT4K+F2A/kIqOZdL/ZLie0ICYJwUxyCwdVtyep16tb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OMTLVxwyU5URm1/JIDINnCqM1xOWygQkKhO2HhC3iZQ3MW33HWAQ3ZwtmhMX8beZr
	 bGyJPcjnUTBkmf+Xl60Iub9qGpbEAEHxK26T2S37REqnFua2IttNpi+sMPztKrEE6k
	 fiMynzKn8kdLeE1g706ptaky+28MaF6R9hsVPbck=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241016123607epcas5p162635bbc7397511c995cc07acfa59885~_7xHsMBzi2383423834epcas5p1A;
	Wed, 16 Oct 2024 12:36:07 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XT9S43ZR7z4x9Ps; Wed, 16 Oct
	2024 12:36:04 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	88.F7.09420.433BF076; Wed, 16 Oct 2024 21:36:04 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241016113724epcas5p191ccce0f473274fc95934956662fc769~_692-Rjvd0520505205epcas5p1c;
	Wed, 16 Oct 2024 11:37:24 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241016113724epsmtrp14aee8d06e2ce78c541c7ba97a7ba58b8~_692_Xuqb0254402544epsmtrp1W;
	Wed, 16 Oct 2024 11:37:24 +0000 (GMT)
X-AuditID: b6c32a49-0d5ff700000024cc-8c-670fb334c4bf
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F9.9A.07371.475AF076; Wed, 16 Oct 2024 20:37:24 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241016113722epsmtip137a8c8fd22cb33714a53dfc2f84ee787~_691Clh-33048330483epsmtip1f;
	Wed, 16 Oct 2024 11:37:22 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	krisman@suse.de
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH v4 01/11] block: define set of integrity flags to be
 inherited by cloned bip
Date: Wed, 16 Oct 2024 16:59:02 +0530
Message-Id: <20241016112912.63542-2-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241016112912.63542-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPJsWRmVeSWpSXmKPExsWy7bCmhq7JZv50g7efxC0+fv3NYtE04S+z
	xZxV2xgtVt/tZ7O4eWAnk8XK1UeZLN61nmOxmHToGqPF9jNLmS323tK2mL/sKbtF9/UdbBbL
	j/9jsjg/aw67A5/Hzll32T0uny312LSqk81j85J6j903G9g8Pj69xeLRt2UVo8fm09UenzfJ
	BXBGZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAF2u
	pFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUq
	TMjOeDLVrmAJd8W8Vr0GxqOcXYycHBICJhJ/n+9k62Lk4hAS2M0osff+WSYI5xOjRMvtf1CZ
	b4wSZ5b0s8O0HHzcxQyR2Mso0dxxkgkkISTwmVFie7s6iM0moC5x5HkrI4gtIjCJUeL55VAQ
	m1ngFKPE2l8KXYwcHMICcRLNL9lATBYBVYmvV+1AKngFLCWalu5jglglLzHz0newtZwCVhKn
	zh1kh6gRlDg58wkLxER5ieats8HOkRDYwSFxeuFLqDtdJJbOfMcKYQtLvDq+BSouJfGyvw3K
	Tpf4cfkp1LICieZj+xghbHuJ1lP9zCC3MQtoSqzfpQ8RlpWYemodE8RePone30+gWnkldsyD
	sZUk2lfOgbIlJPaea4CyPSQ2fv4NDdxeRoldzaeYJjAqzELyzywk/8xCWL2AkXkVo2RqQXFu
	emqxaYFhXmo5PIaT83M3MYJTspbnDsa7Dz7oHWJk4mA8xCjBwawkwjupizddiDclsbIqtSg/
	vqg0J7X4EKMpMLwnMkuJJucDs0JeSbyhiaWBiZmZmYmlsZmhkjjv69a5KUIC6YklqdmpqQWp
	RTB9TBycUg1MS1QXv6r6qvM671X9sflFC2ZenH90roDMRq2t1zTLQlUOiu422pN/ie18dvOn
	iYrJkvV/X9zS9vl7VsbmZcbLCWd7pmkc6Xoho7qhtikhMi1S9qw/D0vNjGNrvDkVjjLlTa+o
	eb1lyuLt8/dZOhSs+Pg1aGHAkrk1jdeMzp8rPbaf4br25r/zL05fMWlhxtfGbctWr9i09sHn
	qUkv63Wcjos0z2L73HY+5tN3gR+Wgrs2/+gwjE8Rz1i7sdvU7vCPm6ZvP5rGCsYFXbx9/jtL
	3aOyJX0JM/JO71ru8MVKUmLjnDPcwjyzbZ9JRPlOEF5/ZYd6+vK7Oo1XNk5O52N44JHA4bE9
	0eOWhKCRX8G9KHclluKMREMt5qLiRABo0A6/UgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsWy7bCSnG7JUv50g7730hYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1ncPLCTyWLl6qNMFu9az7FYTDp0jdFi+5mlzBZ7b2lbzF/2lN2i+/oONovl
	x/8xWZyfNYfdgc9j56y77B6Xz5Z6bFrVyeaxeUm9x+6bDWweH5/eYvHo27KK0WPz6WqPz5vk
	AjijuGxSUnMyy1KL9O0SuDKeTLUrWMJdMa9Vr4HxKGcXIyeHhICJxMHHXcxdjFwcQgK7GSUO
	3PvECJGQkDj1chmULSyx8t9zdoiij4wSa7fsZwdJsAmoSxx53soIkhARmMUocXjWfCYQh1ng
	AqPE1X3PwKqEBWIkzj2fxNLFyMHBIqAq8fWqHUiYV8BSomnpPiaIDfISMy99ByvnFLCSOHXu
	IJgtBFTzb/IHRoh6QYmTM5+wgNjMQPXNW2czT2AE2oqQmoUktYCRaRWjZGpBcW56brJhgWFe
	arlecWJucWleul5yfu4mRnDsaGnsYLw3/5/eIUYmDsZDjBIczEoivJO6eNOFeFMSK6tSi/Lj
	i0pzUosPMUpzsCiJ8xrOmJ0iJJCeWJKanZpakFoEk2Xi4JRqYDJ2FJoTeIf//llDlqVnljlO
	vXsk//QVhnPPTxbME9hjpH/8/sL98VZv1pa92r5EqflgufM+Zlbd7EfG//mNDc89XrJ9cuM9
	HamrG9ZeO7d6dmL67o6uKVt+/H/xJGvXFJkUlnj/stlP0t++6Wc7/pipRmiG3vJLmdN7V/Pc
	Czl087/ei7Ly6eLn5H2fn71sfV7nb/Z55v5JbsXZW/kKjjXKXapIY1we7qIvptn3Z9IbZQaN
	ddXX9e1vPxeaqt9xls/eNK94m0F094Fngg55E6X/WX1xCDS3WuhXpjZxQ0bX/cf8q46f7fxc
	p9xpzbhkZsmPrOb1T0209+qG749q6J/VmR7fv//TD81m729NyxuUWIozEg21mIuKEwFe/GhU
	DAMAAA==
X-CMS-MailID: 20241016113724epcas5p191ccce0f473274fc95934956662fc769
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241016113724epcas5p191ccce0f473274fc95934956662fc769
References: <20241016112912.63542-1-anuj20.g@samsung.com>
	<CGME20241016113724epcas5p191ccce0f473274fc95934956662fc769@epcas5p1.samsung.com>

Introduce BIP_CLONE_FLAGS describing integrity flags that should be
inherited in the cloned bip from the parent.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/bio-integrity.c         | 2 +-
 include/linux/bio-integrity.h | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 88e3ad73c385..8c41a380f2bd 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -562,7 +562,7 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 
 	bip->bip_vec = bip_src->bip_vec;
 	bip->bip_iter = bip_src->bip_iter;
-	bip->bip_flags = bip_src->bip_flags & ~BIP_BLOCK_INTEGRITY;
+	bip->bip_flags = bip_src->bip_flags & BIP_CLONE_FLAGS;
 
 	return 0;
 }
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index dd831c269e99..485d8a43017a 100644
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



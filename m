Return-Path: <io-uring+bounces-3728-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E2529A09F4
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 14:37:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D3785B28890
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 12:37:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BF5F208201;
	Wed, 16 Oct 2024 12:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FN/TWIfL"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C890208217
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 12:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729082211; cv=none; b=Lenc9VZsvO5O2QDxEMNm6kmFJNGlcy7d+jjt6ibZCOPql4NoeOaW4WThD93z9Dy8AB8vkJTU/O39Sy0kk1FUFKIQ84ITqfilJ7IB754eD/lDcNStfTyOK6FUXuthpZlLgZyR5ev5EyMTSIs48MPBZUvLgjNRlb5TvfD5n62UAnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729082211; c=relaxed/simple;
	bh=FD1Rr3gSIir5niLs2wMOY9Fp6ypa/E7yl+xDRorWEKA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=lxbsJVRv6CMTOjdMG9+chVdgPIOA33jjzLemnDYfPXs+h/X4vtmCCoeFyc4qulJH+skDUhWLNON6yhmTiH0xPzGQELVIG2BaAf8l81CFzwc0aCiX11ZHasA2rkQ1e7Z63cJ0e0e4HRynr0WXsetRy83svbUtOSDZ+++DSl/1Pq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=FN/TWIfL; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241016123648epoutp0316e769778de60e4ab94810ede0bae7d7~_7xuMM-Ps1120611206epoutp03-
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 12:36:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241016123648epoutp0316e769778de60e4ab94810ede0bae7d7~_7xuMM-Ps1120611206epoutp03-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1729082208;
	bh=pP7fuKjfTHtbF6PT6N4PWc3TJYSIrBfJKrC83hsylPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FN/TWIfLUV/X93G36rboLeGzr/WfyzK7gW3g5K+iL9uqn6Dlq0w+CESQe1zGNDvDX
	 wormGNQTzlnAN5Ud/ZPUkj2ljxvp++R+NMMgHinXKj4RSbOYluj8+4BbFvSZ+yLR7R
	 OT2hxF3C5HzKmiPP0bW8/CEy+k6eH5s86me8e1Q8=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241016123647epcas5p2361dbf3e7a9c551f2321d41a62c57b26~_7xtmixik1006810068epcas5p2J;
	Wed, 16 Oct 2024 12:36:47 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4XT9St2kWdz4x9Pp; Wed, 16 Oct
	2024 12:36:46 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F5.37.08574.E53BF076; Wed, 16 Oct 2024 21:36:46 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241016113745epcas5p1723d91b979fd0e597495fef377ad0f62~_6_KjuipO1436014360epcas5p1C;
	Wed, 16 Oct 2024 11:37:45 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241016113745epsmtrp24559f8dcad65ab7967e8ec2fd2772af3~_6_Ki4UcD1554615546epsmtrp2v;
	Wed, 16 Oct 2024 11:37:45 +0000 (GMT)
X-AuditID: b6c32a44-6dbff7000000217e-18-670fb35e2cd8
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	5F.BA.08229.985AF076; Wed, 16 Oct 2024 20:37:45 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241016113743epsmtip1498e161032d7d5e8bb1c6da199eaf0ee~_6_IkrovM3048330483epsmtip1k;
	Wed, 16 Oct 2024 11:37:43 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	krisman@suse.de
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH v4 06/11] block: add flags for integrity meta
Date: Wed, 16 Oct 2024 16:59:07 +0530
Message-Id: <20241016112912.63542-7-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241016112912.63542-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xbVRzHc27fJN3uynRHBFdvAgSUR6XU2w6cRNyaDSOooPiHtaHXFlva
	rrcFNkxWWZpZ5L0sGx2vKEhafDBg5VFqRi2y1a1sq45HgjFxjCphioAKOGLLLbr/Puf3+v5+
	v3MOm8bzMGPYpVojYdDKNRgziu78Jikp5Z2Bvcr0n5f24SvrW3S8uvEhDW91OAHeO9/AxGev
	jiC4vXcCwR9Y/HS82XMX4EM3umm4e+4ZvOOzBRb+8fQwE++Z3EbwKVsr68U90hHbPEsauGmS
	9jusTOlA12mpa9bMlK4szNGl9YMOIB34rkq62v9UPudtdZaKkCsIA5/QlugUpVplNnb8ddlL
	skxRuiBFIMafx/haeRmRjeXm5accKdWEOsf45XKNKWTKl5MklvZClkFnMhJ8lY40ZmOEXqHR
	C/WppLyMNGmVqVrCKBGkpz+XGQp8V60au/URQ+9nVda6bjHNoItZAzhsiArhubnPkRoQxeah
	LgCH+zYZ1OEPAK/VVkc8fwLo/MFB202x/O7dYR7qBjDgJqmgVQAvzFh3HEw0EXoXLSDM+9Fm
	ABcDhWGmoT4Av9jkhzkazYbLG1YkzHQ0HrZNn9/piYuKYYdlHFBiB2HLnb9YYeagEujzj7Oo
	mH3wess9OlXzIDxz5RIt3AREB9mwa6OJQSXnwl8C30c4Gv46OciiOAauPnBHFqCEfwcWEIr1
	8My3X0eED0OLryFUlB0SSIJfjaZR5jh43vclQunugXVb9yKpXDjcvssYPGtvjTCEbr8ZCZeB
	qBTWeeKoXdUBOOW4z2gEfNsj49geGcf2v3InoDnAE4SeLFMSJZl6gZao+O+SS3Rl/WDnMSfn
	DoOZju1UD0DYwAMgm4bt5zbXcJU8rkJ+8hRh0MkMJg1BekBmaN9NtJjHSnSh36A1ygRCcbpQ
	JBIJxRkiAXaAu2RpU/BQpdxIqAlCTxh28xA2J8aMxL3anZ9xrYfo1p8+VlVov/OhOGvotwxB
	7OLRt8ae3i6+fOGUZPP647ZXcteL7Y2d3ESoi7cnKzamRfoU9d0WU1FCZY/95qfMhotjq03l
	9vcqq0bdvXlH1sacfaqkY1P/eDQVNVzzoWDRm8H2mSfJrpf9o2/kXOQciOPcuJ2ckDAJ0JPz
	soofK9EPliWv7e23n+XUW1xjbaneo97CK5MrBbHVHKRx3te3LhnpzDsUdGv46iZGzonDt12D
	rUvL9OAJ+3GdN35IdK47qsBpdaHFvtngw58Mtk+K1mqvThjy1mLTDBuXx7dEiW24h4XWR73f
	PnFfFa3IeNaawysjCsoxOqmSC5JpBlL+L3FvN1tVBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWy7bCSnG7nUv50g6Y5UhYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1ncPLCTyWLl6qNMFu9az7FYTDp0jdFi+5mlzBZ7b2lbzF/2lN2i+/oONovl
	x/8xWZyfNYfdgc9j56y77B6Xz5Z6bFrVyeaxeUm9x+6bDWweH5/eYvHo27KK0WPz6WqPz5vk
	AjijuGxSUnMyy1KL9O0SuDL2XOhgLTjHXtGz+wJbA+MSti5GTg4JAROJ1g9HmLsYuTiEBHYz
	SpxsWMICkZCQOPVyGSOELSyx8t9zdoiij4wSr7dtZAJJsAmoSxx53soIkhARmMUocXjWfCYQ
	h1ngAqPE1X3P2EGqhAVsJd7+7ATrYBFQlZh7fSrYbl4BS4n5rQehVshLzLz0HayeU8BK4tS5
	g2C2EFDNv8kfGCHqBSVOznwCdh4zUH3z1tnMExiB1iKkZiFJLWBkWsUomVpQnJueW2xYYJiX
	Wq5XnJhbXJqXrpecn7uJERxBWpo7GLev+qB3iJGJg/EQowQHs5II76Qu3nQh3pTEyqrUovz4
	otKc1OJDjNIcLErivOIvelOEBNITS1KzU1MLUotgskwcnFINTEK98++9KVkos7vMXDpKRWIK
	/43wCaLKHFucErNcdywKE1DcfGjyHbnaVxFGlV/O7GKfaCMVqte4pNVGdn9mEkv4pRrd5j/n
	Xeo3Hxf4OqffZ4/O4QLpN8JrVxzjNfOWkWj6kOZe4P/M4WZo6iK1xQndslkx6ksils5tkpcL
	39eQYZDxKjrZd2pAulbCuZDOdcyJNx9/60pkUXqap/FdUf/a60VNb1eFikREyPyxXsYs7XlE
	WNP3it/7gw2XJqr4eWtJ6y7NZDz6Zpre8nCWTF+Tyk1TBXT3NTPuKliT4qQucXxxY6z3I7b/
	VSnz7mUu032WFzlzj03IjOdRinxzi0/XXeBrtn1lkZ18cJ8SS3FGoqEWc1FxIgDFjT49DwMA
	AA==
X-CMS-MailID: 20241016113745epcas5p1723d91b979fd0e597495fef377ad0f62
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241016113745epcas5p1723d91b979fd0e597495fef377ad0f62
References: <20241016112912.63542-1-anuj20.g@samsung.com>
	<CGME20241016113745epcas5p1723d91b979fd0e597495fef377ad0f62@epcas5p1.samsung.com>

Add flags to describe checks for integrity meta buffer. These flags are
specified by application as io_uring meta_flags, added in the next patch.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 include/uapi/linux/blkdev.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/uapi/linux/blkdev.h b/include/uapi/linux/blkdev.h
index 66373cd1a83a..d606f8b9c0a0 100644
--- a/include/uapi/linux/blkdev.h
+++ b/include/uapi/linux/blkdev.h
@@ -11,4 +11,15 @@
  */
 #define BLOCK_URING_CMD_DISCARD			_IO(0x12, 0)
 
+/*
+ * flags for integrity meta
+ */
+#define BLK_INTEGRITY_CHK_GUARD		(1U << 0) /* enforce guard check */
+#define BLK_INTEGRITY_CHK_APPTAG	(1U << 1) /* enforce app tag check */
+#define BLK_INTEGRITY_CHK_REFTAG	(1U << 2) /* enforce ref tag check */
+
+#define BLK_INTEGRITY_VALID_FLAGS (BLK_INTEGRITY_CHK_GUARD |\
+				   BLK_INTEGRITY_CHK_APPTAG |\
+				   BLK_INTEGRITY_CHK_REFTAG)
+
 #endif
-- 
2.25.1



Return-Path: <io-uring+bounces-3726-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E5C539A09EC
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 14:36:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 798481F223CD
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 12:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3BEF2076BA;
	Wed, 16 Oct 2024 12:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="g5VMOxn7"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D922207A03
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 12:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729082196; cv=none; b=bJqtRsM07UtnNrZ51aESbZFfwGejPx6/20Jh5PKM40LHiBvBUj2YY+oaXyJkSZ589QFjl1te+1o5kekDnghR/Eld8VSnhjakSn+CXIs89N+IgJ4/1s44RcesrgqlTI0o0FHG0k+Iu5zHQC72WvxSHQiMyAuenLZ7/DgmKUyxDJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729082196; c=relaxed/simple;
	bh=ZF260PFRqTY8i0xvJfFGVVeNsxKecPbr5WJiEFbnwj0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=HVeUO1ih4KS1MT4+by2ov+auls1I60sHVs/PgCIbzPstFGrviwcm8O0+mI8QJWfPDWLwl02JxoEHHQe2lU/q87cuVYpGfXIO4eWbcgwkisbWs5UyO92y+uqrtbmh76qcLoGT9fjA2xYU01P3IQcg57daWgMy+3NXEC371BtY4nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=g5VMOxn7; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241016123633epoutp01dda525887b4224373fff498e50ff006c~_7xgLP3hX1584015840epoutp01q
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 12:36:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241016123633epoutp01dda525887b4224373fff498e50ff006c~_7xgLP3hX1584015840epoutp01q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1729082193;
	bh=UKoRNiCpE9xYsK9GrO7c2Huj45QYroY0N/mJ/Q8UOgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5VMOxn7sS5c4XXHGRpj/NR68Ico3k7JQF1ZuhVekvENVxYA37kZ+RArLMsSE7tCr
	 UR2bFn6Ix7SPHtW9Fi0Crqsf2NNjPTXFaSemHOegex0daLD2JHhtPqkCHJYagy+r+U
	 GMZRt/La0DSmHRGmK2GJfjFWhlheAlkT/WTpFDtE=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241016123632epcas5p3e1a8e0f298d5b0f8dfc499cf647650b0~_7xfUVskf2029820298epcas5p3a;
	Wed, 16 Oct 2024 12:36:32 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XT9SZ6CBYz4x9Pv; Wed, 16 Oct
	2024 12:36:30 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	09.08.09420.E43BF076; Wed, 16 Oct 2024 21:36:30 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241016113741epcas5p3b90adb3b43b6b443ffd00df29d63d289~_6_GdhFFt1063910639epcas5p3I;
	Wed, 16 Oct 2024 11:37:41 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241016113741epsmtrp1a08274ed734fadd9a7decb4cd101e4cf~_6_GcrwNh0254402544epsmtrp1p;
	Wed, 16 Oct 2024 11:37:41 +0000 (GMT)
X-AuditID: b6c32a49-0d5ff700000024cc-c2-670fb34e35ba
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	3E.9A.07371.485AF076; Wed, 16 Oct 2024 20:37:41 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241016113738epsmtip15ae17822cc4bf05c896c76e759451560~_6_EWKVy-2875928759epsmtip1F;
	Wed, 16 Oct 2024 11:37:38 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	krisman@suse.de
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v4 04/11] block: define meta io descriptor
Date: Wed, 16 Oct 2024 16:59:05 +0530
Message-Id: <20241016112912.63542-5-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241016112912.63542-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBJsWRmVeSWpSXmKPExsWy7bCmpq7fZv50g52bDC0+fv3NYtE04S+z
	xZxV2xgtVt/tZ7O4eWAnk8XK1UeZLN61nmOxOPr/LZvFpEPXGC22n1nKbLH3lrbF/GVP2S26
	r+9gs1h+/B+TxflZc9gd+D12zrrL7nH5bKnHplWdbB6bl9R77L7ZwObx8ektFo++LasYPTaf
	rvb4vEkugDMq2yYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DX
	LTMH6HwlhbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1SakFKToFJgV5xYm5xaV66Xl5qiZWh
	gYGRKVBhQnbGm11zmQpOs1d8fLGMqYFxJVsXIyeHhICJxIL2A6xdjFwcQgK7GSU6l11ng3A+
	MUq0Tf4KlfnGKNG79hiQwwHWcr4zHCK+l1HicE8LM4TzmVHi8o9tYHPZBNQljjxvZQSxRQQm
	MUo8vxwKUsQs8J5RYtmzWWAJYQErifYjTUwgNouAqsTs5jNgcV4BS4n9E3exQxwoLzHz0ncw
	mxOo/tS5g+wQNYISJ2c+YQGxmYFqmrfOZoao38MhsfVSAoTtItF4aTEThC0s8er4FqiZUhIv
	+9ug7HSJH5efQtUUSDQf28cIYdtLtJ7qZwb5mFlAU2L9Ln2IsKzE1FPrmCDW8kn0/n4C1cor
	sWMejK0k0b5yDpQtIbH3XAOU7SHRdKAFGry9jBK7L/QxTmBUmIXknVlI3pmFsHoBI/MqRsnU
	guLc9NRi0wLDvNRyeCwn5+duYgQnaS3PHYx3H3zQO8TIxMF4iFGCg1lJhHdSF2+6EG9KYmVV
	alF+fFFpTmrxIUZTYHhPZJYSTc4H5om8knhDE0sDEzMzMxNLYzNDJXHe161zU4QE0hNLUrNT
	UwtSi2D6mDg4pYCekWPrYtlveuDQzpkXe1axBP/+emPjh0L3HlO91hf/y6+Zfns4p/8s+/v/
	7JX68SKbjM379jvG6TpcfXNmytb9B2KZo73mbrxw5nKpUOLNjC8TH3VHvGTwnZ3E+HAXg8rd
	GYX9OzZbF3hp/dy7i1V4QfN3a4ujflvXuFzhtni+xVlh+d6T825X8OdfOptSUdwptuH8x5B/
	M5jjxQU3S6dH3FRK+arVeHlCixufRHLz7T3/Ci3iG213M/vG2DSYBlgoeCYZX9Q2bbtWvGZL
	TMO9otU8r+4rrptaYbXTeOqzunk7lv2y+2Xp3S26/NWMp1+zFe3lbG7M6VgyQVStrctovoN7
	1KJDZ/fGKCwS3TpXiaU4I9FQi7moOBEAXW363FsEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWy7bCSnG7rUv50g8OXGC0+fv3NYtE04S+z
	xZxV2xgtVt/tZ7O4eWAnk8XK1UeZLN61nmOxOPr/LZvFpEPXGC22n1nKbLH3lrbF/GVP2S26
	r+9gs1h+/B+TxflZc9gd+D12zrrL7nH5bKnHplWdbB6bl9R77L7ZwObx8ektFo++LasYPTaf
	rvb4vEkugDOKyyYlNSezLLVI3y6BK+PNrrlMBafZKz6+WMbUwLiSrYuRg0NCwETifGd4FyMX
	h5DAbkaJHZvnsHQxcgLFJSROvVzGCGELS6z895wdougjo8S8u3eZQRJsAuoSR563MoIkRARm
	MUocnjWfCSTBLPCdUeJftzOILSxgJdF+pAksziKgKjG7+QzYVF4BS4n9E3exQ2yQl5h56TuY
	zQlUf+rcQTBbCKjm3+QPUPWCEidnPmGBmC8v0bx1NvMERqCtCKlZSFILGJlWMUqmFhTnpucm
	GxYY5qWW6xUn5haX5qXrJefnbmIEx5GWxg7Ge/P/6R1iZOJgPMQowcGsJMI7qYs3XYg3JbGy
	KrUoP76oNCe1+BCjNAeLkjiv4YzZKUIC6YklqdmpqQWpRTBZJg5OqQamp0K3V5t9KZSbotM3
	Xc/KRT30KMPMlrTKxq4jC9Tri07wpy5880/wmbh5zYbQ8t0nk44J3a3zEu/wnLeV+1bRdd41
	ASsm/go+/91NVvr40ZSku6ptG6I0FjTs7W7uf3wjqdpypreieVL7+uJFhW32Ri+F1V/6v3Ly
	iQ+O7zg/Oe/atEvn3s1IjsrzL/1zzoPlbMBrl9M9f2J/tz55tuWS8iJGkefLHlf4W/IvOLVq
	cnRUgLLyMfO9D2Zfe7uX5cHKB6tytZ1sryhduZyp9LuZvU7k/V4X9f/nMs8aCsb4Bntvn/51
	5b0FTP8ldoQ/XeFcl7RHT/Oi8Sf1X3EZRqpFCaa/eGwexndVnv79hfWCEktxRqKhFnNRcSIA
	6fhL3hIDAAA=
X-CMS-MailID: 20241016113741epcas5p3b90adb3b43b6b443ffd00df29d63d289
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241016113741epcas5p3b90adb3b43b6b443ffd00df29d63d289
References: <20241016112912.63542-1-anuj20.g@samsung.com>
	<CGME20241016113741epcas5p3b90adb3b43b6b443ffd00df29d63d289@epcas5p3.samsung.com>

From: Kanchan Joshi <joshi.k@samsung.com>

Introduces a new 'uio_meta' structure that upper layer can
use to pass the meta/integrity information.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 include/linux/bio-integrity.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index 90aab50a3e14..529ec7a8df20 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -30,6 +30,16 @@ struct bio_integrity_payload {
 	struct bio_vec		bip_inline_vecs[];/* embedded bvec array */
 };
 
+/* flags for integrity meta */
+typedef __u16 __bitwise meta_flags_t;
+
+struct uio_meta {
+	meta_flags_t	flags;
+	u16		app_tag;
+	u32		seed;
+	struct iov_iter iter;
+};
+
 #define BIP_CLONE_FLAGS (BIP_MAPPED_INTEGRITY | BIP_CTRL_NOCHECK | \
 			 BIP_DISK_NOCHECK | BIP_IP_CHECKSUM)
 
-- 
2.25.1



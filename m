Return-Path: <io-uring+bounces-3810-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8599A9A3914
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 10:50:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41F3D28475C
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 08:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A03C18E76B;
	Fri, 18 Oct 2024 08:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QiowE7/n"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EAA18E74D
	for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 08:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729241424; cv=none; b=ea+CCYK76QEldoPxrIpFHqqkdTCx6QzI8t4Bx2boBqdt+oTzah/FhbRlUvirmxfcNF5Ffo5bct5l4u5tShcYg0yJu1otqWTJ0tdgisR0OUh78+Ypc9VtX8mHEKmqJBW7VTx3iCvYjI25NteNn9UxfK3DRjNckqBmWPCTCHKSiVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729241424; c=relaxed/simple;
	bh=dXAGNRNvKCH5gnbwI7IXcGCoTQyL7L1FPojjzghzptw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=q+TcNnhBX/XQ/6b5NySxATlXVlLzAYMflfpMTJMbjq4sbTRxpl93132GUm5fHILeT0r6OT00TXsaBgfLb1J7CTKSatarD99EeDO6pso48G7IgIflHJRiKjKlOx3oZADKQ4mAk9mrEIQ5YU3ABTptqpSW6UhMJtLOVhP1OS5bmfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QiowE7/n; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241018085013epoutp0392176ee0f43fcd7bcdcbd06150a19539~-f_dJedqy0661706617epoutp03Z
	for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 08:50:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241018085013epoutp0392176ee0f43fcd7bcdcbd06150a19539~-f_dJedqy0661706617epoutp03Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1729241413;
	bh=ncVCmNC5q9sLwvQGITeEvX2kPlF4Nabnk4kf+n1iovs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QiowE7/ndjk/lmriSZhyzCKXAstwezuQZSUZsrse5RTEq5GhrJEiZxJ/AqPvjkInh
	 QHFq38oQZ+Qw/IXwbSULv70OIGxvJLU1Bg+XB3nPmCWjybXOPCGXjmUmSgCL8Kso4/
	 J9BpVi2sGvUAO91HvSOlhX2oAOg1OdIhcVgLqO2I=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241018085012epcas5p2b93800cfdb671b6362bc3d6ab1791ab4~-f_cpBkVQ2265822658epcas5p2X;
	Fri, 18 Oct 2024 08:50:12 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4XVJLV6lLwz4x9QG; Fri, 18 Oct
	2024 08:50:10 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A6.DA.08574.D3122176; Fri, 18 Oct 2024 17:50:05 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241018083430epcas5p138473638c4aea07ac9320900406c8d52~-fwvEfi5F1491014910epcas5p1u;
	Fri, 18 Oct 2024 08:34:30 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241018083430epsmtrp12783beedb848e16be51a982002df02be~-fwvA2Blx2774327743epsmtrp1w;
	Fri, 18 Oct 2024 08:34:30 +0000 (GMT)
X-AuditID: b6c32a44-93ffa7000000217e-f2-6712213dd6a9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	40.82.07371.69D12176; Fri, 18 Oct 2024 17:34:30 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20241018083428epsmtip20018145a4091d5b02fc61d03210c7b85~-fwtNvBXG0587105871epsmtip2k;
	Fri, 18 Oct 2024 08:34:28 +0000 (GMT)
Date: Fri, 18 Oct 2024 13:56:48 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, kbusch@kernel.org, martin.petersen@oracle.com,
	asml.silence@gmail.com, anuj1072538@gmail.com, krisman@suse.de,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com
Subject: Re: [PATCH v4 11/11] scsi: add support for user-meta interface
Message-ID: <20241018082648.GA32006@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241017143918.GC21905@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xbdRTH87u39LFYvRQYZ11UvA7Yg1dZ6S6Mx+Zwq8ElRBMXMYZd6E2L
	QFv78DGnK7pCHAyESeIqo0zZkC5jC1SkECgwEIbARghDGDBCAB3LnGB4yLDa9jKz/z7n/L7n
	/M7j9+PjoptcMT9LbWB0ajqH5G7hNN7YFRqe8JJIGTU8H00tLj/mUBW2RkRdmSzhUmPtDoyq
	vdKNUX+YBzlUWecdRP3UfwmnWsf3UNbLczyqcLSJS9X0uDDqlqWCd0Aod1gmefLhAaO83vYl
	V95QfUreMmbiyhfnxjnyYrsNyRt++UT+V/0LqYK07HgVQysYXRCjztQostTKBDLlzfRD6TGy
	KEm4JJbaRwap6VwmgUx+PTX8cFaOu2gy6AM6x+h2pdJ6PRmZGK/TGA1MkEqjNySQjFaRo5Vq
	I/R0rt6oVkaoGUOcJCoqOsYtPJ6tspcVYdoV8UdDD8t5JmTdegYJ+EBIwXa6iOdhEdGCYOT7
	4DNoi5uXEBR2tSLWWEHQ0VHmVvG9ETN1h1h/KwJH9xjOGvMIHi1MYJ5UHCIYfqhrRh7mEqHQ
	9ZvZy/4ECXMLA96sOFGLQeuIBfcc+BFH4Ju2e16RkAgHh72Xw7Iv3Dw/62UBEQYdE/U+Hg4g
	Xob2xh7MkwiIXj6ce9jGYRtKhrWpPxHLfrDQY+exLIb7JfmbrIS14TmMZS188XPbpj4JzH0l
	3oJwQgXn+mY2Nc9DeV8dxvqfhbOPZzf9QmiqfMIkFNRWbDJA66AJY8clh/GRk+yE8jCY6xjk
	foVetDzVm+Wp61gOg6qWJa7FHY4T26HGxWdxF1xrjqxCPja0jdHqc5VMZoxWomY+/H/hmZrc
	euR907uTm9CvVldEJ8L4qBMBHyf9hRmnfJUioYL++ASj06TrjDmMvhPFuJdViosDMjXuT6E2
	pEuksVFSmUwmjd0rk5CBwgfmCwoRoaQNTDbDaBndkziMLxCbMMtB53rpwLvk/pXi4SS/jaP8
	R5ff8FUFmsz5sB596/M980UJKV1DLok00DJ0oHm25GSIoL+4JKM6YweZNnwhYnX1HnVwZrTM
	Nap5zb8urtkKwcdqhkLT9ieVChLDbwhfOdvoHIyti8/rne32iSvsr7r+XEpzaPXVjel9y1//
	Pr36/k7V2wVSY/fiM41c51rL5N6MxLTIqenK0VfPLxSETF7PbuH4VdF3Y5aPvzMufBBmzL/Y
	cMmuwLXOHxeUpb1XJ6XffbvzX7j/t/liBnkt79jWbRvVlUenAj4tdxKHezT/TOTetq6HOe5y
	rOj07HboYALbRbKl90JcXSea3lq/feczguToVbRkN67T0/8B6liBHlwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42LZdlhJXnearFC6wdK9ghYfv/5msZizahuj
	xeq7/WwWNw/sZLJYufook8W71nMsFpMOXWO02H5mKbPF3lvaFvOXPWW36L6+g81i+fF/TBbn
	Z81hd+D12DnrLrvH5bOlHptWdbJ5bF5S77H7ZgObx8ent1g8+rasYvTYfLra4/MmuQDOKC6b
	lNSczLLUIn27BK6M83M+MRZsk6hoW3CQsYHxh3AXIweHhICJxKN1zl2MnBxCArsZJXYcyQax
	JQQkJE69XMYIYQtLrPz3nL2LkQuo5gmjxLU1p1lBEiwCqhIr1u0CK2ITUJc48rwVzBYRUJJ4
	+uosI0gDs8BKJom9V2cxgySEBdwlZuy7D1bEK6ArsXPLCRaIqc1MEke+3IVKCEqcnPmEBcRm
	FtCSuPHvJRPIpcwC0hLL/3GAhDkFdCQO3tkEdoSogLLEgW3HmSYwCs5C0j0LSfcshO4FjMyr
	GCVTC4pz03OTDQsM81LL9YoTc4tL89L1kvNzNzGC40tLYwfjvfn/9A4xMnEwHmKU4GBWEuFN
	qhdMF+JNSaysSi3Kjy8qzUktPsQozcGiJM5rOGN2ipBAemJJanZqakFqEUyWiYNTqoEp85zV
	Ub4JR+/+/3hVPpr/sIJ57EPDP+XrP5lON45XMssRFxEKzzaVep/P/P2HvJF/N7Nb4NLHbvtF
	Nq2QX5W1/KwMh86f70w8ekcrXwqud5VsFk1kFnl6835A/gbh5TcFdPqVnWN+6fbeYNL7+fCt
	oubkprWTGdd3lxU+lytJ5BOZeyP/n7SUSTvbnSmf7Lt/TGb61KF/SeDeGYm35YXVXOwLVDT/
	rmaQvf7ltfNzq1ju6dN/Tp43e7mDhXaHcfiRN7EBDKVzbr/xjDh/xLs+6Fy0xEobqRV3rvOv
	fve/4a6zzwZNh9t+dbLL97C0GZ61Xp+ska+3Qvf+ma1rnl4S2GYX+Or58c/S+1fkTbFXYinO
	SDTUYi4qTgQAECi23R4DAAA=
X-CMS-MailID: 20241018083430epcas5p138473638c4aea07ac9320900406c8d52
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----w5-2f3KIOrSunQhSxAIo7Dy_B_SBAQB3Xz8aCSUoiMSFB8w5=_54f87_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241016113757epcas5p42b95123c857e5d92d9cdec55e190ce4e
References: <20241016112912.63542-1-anuj20.g@samsung.com>
	<CGME20241016113757epcas5p42b95123c857e5d92d9cdec55e190ce4e@epcas5p4.samsung.com>
	<20241016112912.63542-12-anuj20.g@samsung.com>
	<20241017113923.GC1885@green245> <20241017143918.GC21905@lst.de>

------w5-2f3KIOrSunQhSxAIo7Dy_B_SBAQB3Xz8aCSUoiMSFB8w5=_54f87_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Thu, Oct 17, 2024 at 04:39:18PM +0200, Christoph Hellwig wrote:
> On Thu, Oct 17, 2024 at 05:09:23PM +0530, Anuj Gupta wrote:
> > This snippet prevents a scenario where a apptag check is specified without
> > a reftag check and vice-versa, which is not possible for scsi[1].
> > But for
> > block layer generated integrity apptag check (BIP_CHECK_APPTAG) is not
> > specified. When scsi drive is formatted with type1/2 PI, block layer would
> > specify refcheck but not appcheck. Hence, these I/O's would fail. Do you
> > see how we can handle this?
> 
> Well, this is also related to difference in capability checking.

Right.

> Just curious, do you have any user of the more fine grained checking
> in NVMe?  If not we could support the SCSI semantics only and emulate
> them using the fine grained NVMe semantics and have no portability
> problems.
 
We can choose to support scsi semantics only and expose only the valid
scsi combinations to userspace i.e.

1. no check
2. guard check only
3. ref + app check only
4. guard + ref + app check

Something like this [*] on top of this series, untested though. Does
this align with what you have in mind?

[*]

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 24fad9b6f3ec..2ca27910770b 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -308,12 +308,10 @@ static void bio_uio_meta_to_bip(struct bio *bio, struct uio_meta *meta)
 {
 	struct bio_integrity_payload *bip = bio_integrity(bio);
 
-	if (meta->flags & BLK_INTEGRITY_CHK_GUARD)
+	if (meta->flags & IO_INTEGRITY_CHK_GUARD)
 		bip->bip_flags |= BIP_CHECK_GUARD;
-	if (meta->flags & BLK_INTEGRITY_CHK_APPTAG)
-		bip->bip_flags |= BIP_CHECK_APPTAG;
-	if (meta->flags & BLK_INTEGRITY_CHK_REFTAG)
-		bip->bip_flags |= BIP_CHECK_REFTAG;
+	if (meta->flags & IO_INTEGRITY_CHK_REF_APP)
+		bip->bip_flags |= BIP_CHECK_REFTAG | BIP_CHECK_APPTAG;
 
 	bip->app_tag = meta->app_tag;
 }
@@ -329,9 +327,9 @@ int bio_integrity_map_iter(struct bio *bio, struct uio_meta *meta)
 		return -EINVAL;
 
 	/* should fit into two bytes */
-	BUILD_BUG_ON(BLK_INTEGRITY_VALID_FLAGS >= (1 << 16));
+	BUILD_BUG_ON(IO_INTEGRITY_VALID_FLAGS >= (1 << 16));
 
-	if (meta->flags && (meta->flags & ~BLK_INTEGRITY_VALID_FLAGS))
+	if (meta->flags && (meta->flags & ~IO_INTEGRITY_VALID_FLAGS))
 		return -EINVAL;
 
 	/*
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 753971770733..714700f9826e 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -40,6 +40,15 @@
 #define BLOCK_SIZE_BITS 10
 #define BLOCK_SIZE (1<<BLOCK_SIZE_BITS)
 
+/*
+ * flags for integrity meta
+ */
+#define IO_INTEGRITY_CHK_GUARD		(1U << 0) /* enforce guard check */
+#define IO_INTEGRITY_CHK_REF_APP	(1U << 1) /* enforce ref and app check */
+
+#define IO_INTEGRITY_VALID_FLAGS (IO_INTEGRITY_CHK_GUARD | \
+				  IO_INTEGRITY_CHK_REF_APP)
+
 #define SEEK_SET	0	/* seek relative to beginning of file */
 #define SEEK_CUR	1	/* seek relative to current file position */
 #define SEEK_END	2	/* seek relative to end of file */


------w5-2f3KIOrSunQhSxAIo7Dy_B_SBAQB3Xz8aCSUoiMSFB8w5=_54f87_
Content-Type: text/plain; charset="utf-8"


------w5-2f3KIOrSunQhSxAIo7Dy_B_SBAQB3Xz8aCSUoiMSFB8w5=_54f87_--


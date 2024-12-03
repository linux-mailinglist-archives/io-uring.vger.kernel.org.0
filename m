Return-Path: <io-uring+bounces-5169-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BCD1C9E1684
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 10:00:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D589AB2653F
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 08:21:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CCE31CDA17;
	Tue,  3 Dec 2024 08:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FIZAGIp9"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC811BE251
	for <io-uring@vger.kernel.org>; Tue,  3 Dec 2024 08:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733214063; cv=none; b=WhQgvrPS/XWWCUk1hK7GFbVwQ3r1IBsQmUoFNeNGNmP800vDUOovq+oK44lWj64MEPpS32Sey6b3moVHQHTxs6UPPvJTUIohjyUtaMw5eFtwfjPaD0jL1pt+e8fOkiWTJ0twxYo0RnqgiSyR3pxIjCVXI8ohfcOjNu5B5bJ5amM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733214063; c=relaxed/simple;
	bh=q+96aXZHJPJu3iquanA8Vv/lCZTN5bUzfOksIohpdDw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=h3LMSwtbb3nebM3+N82whZADAZRS/ERJyFBqPPskyL1IdUxBVfTeqwwxUvzOEz798g/IQvuou0xOwyaqEvcpBYlIwBCmmmCG36R4F8GSH+g8h3FJmVZGOsXpJh0YCJBTSYF+DXfr3/1GhTTwNpK70YDXgrW7jskNIwOI1CgfnbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=FIZAGIp9; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241203082057epoutp01794594f80e3309606794fe438944a894~NnQCrMfCM3132031320epoutp01O
	for <io-uring@vger.kernel.org>; Tue,  3 Dec 2024 08:20:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241203082057epoutp01794594f80e3309606794fe438944a894~NnQCrMfCM3132031320epoutp01O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1733214057;
	bh=dTwN8W55S8hClRqr9MBN2nck11P6obebOea0MeHRuqA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FIZAGIp9coEJM9WW7BRUFlbUVz+2dCeqPG7PBhe04iXuvwCkga9R9rG6apclJhGC5
	 eDtWvtglwtpusuiiejuiE2JPTWiVh5RLUzxmxDFIF4s3lm8UtzWWikvTbGyOGzcR8w
	 VeDbFi+5Xhc1pIY0BkGeAh9BuTRSVew7FEd3oDLs=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241203082057epcas5p3062b3a689bce4846701582781ce8d054~NnQCc8WBP2589325893epcas5p3T;
	Tue,  3 Dec 2024 08:20:57 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Y2YWX0Xscz4x9Q9; Tue,  3 Dec
	2024 08:20:56 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	DC.8A.29212.76FBE476; Tue,  3 Dec 2024 17:20:55 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241203070444epcas5p298f09249205b1e3edc76c90e5de76c04~NmNfM7DM21505115051epcas5p2e;
	Tue,  3 Dec 2024 07:04:44 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241203070444epsmtrp252ce44e9ebfc3f2ee75f707cfd3f9f75~NmNfLnHTT1560515605epsmtrp2H;
	Tue,  3 Dec 2024 07:04:44 +0000 (GMT)
X-AuditID: b6c32a50-801fa7000000721c-c3-674ebf6767d2
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	17.6C.33707.C8DAE476; Tue,  3 Dec 2024 16:04:44 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20241203070441epsmtip1b7ef5e22bbb169dc177b845e8c10c895~NmNcsyW8-1419214192epsmtip1I;
	Tue,  3 Dec 2024 07:04:41 +0000 (GMT)
Date: Tue, 3 Dec 2024 12:26:45 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, asml.silence@gmail.com,
	anuj1072538@gmail.com, brauner@kernel.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v11 06/10] io_uring: introduce attributes for read/write
 and PI support
Message-ID: <20241203065645.GA19359@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <yq1r06psey3.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Tf1CTdRzH+z4bzwY2fZx6fV1J9CzPIAabbOMhWXbC1XONlM6rS7jEHTxs
	HPvVNiSquxEIJWJIHqYDB6ecO34c0CTk1xQmsCAaFhXy6+KSQWmAQHBexGxjw/O/1+fzeb+/
	38/n+4NJY0+jHGaG2kDp1DIljgbRW26H7uPJbx2W82uKYonFlTU6UVHbAoi6yRKUeHB7CRCj
	XW0IUVPXixDzBU46Uf5NPkL0Pp5Dia/tvwHCNvYq0WnrpxOV11wM4sxIK0pYHG6EGFp3BBBD
	pgrGG9vJNtMkgxz+MYu01p5GyevVRrJjNBclF11jdPKr5lpADlb1MMhlazBpnZ5DEoOSMmMV
	lCyN0oVQ6lRNWoZaLsGlR1PiUkRivoAniCGi8RC1TEVJ8PiERN6bGUrPOHjISZkyy5NKlOn1
	eOTrsTpNloEKUWj0BglOadOUWqE2Qi9T6bPU8gg1ZXhNwOfvF3mEJzIVxatmoHWEfOye7wC5
	4P7uIhDIhJgQOju7aV5mY50AFppTi0CQh5cAHF/MA0+CvNm7AZuOBWe7v9AGYPfKDdQXzABY
	fXUM8aro2Muw3dW3wSi2D/bMFgAv78RE8PzSdxsGGnaaBie7F1BvYQf2IWy7VL/RCAvjQZfj
	DsPH22H/pWl6EWAyA7EoaF4M9qZ3YVzY1eJAvOtAbIoJL/8wg/jai4d/XOj08w5439HM8DEH
	Ls/bUB/L4aNhl1+jhfl9N4GPD8KCgZKNHmiYAraah/yaPbBsoAHx5bfCs2vT/jzLo9lkHH5R
	U+FnCG3OXMTbM8RIOHFK6TugaQCvLLiQc+BF01OjmZ7azsfhsKpjCTV57DTseWhxM30YChvb
	I6tAQC3gUFq9Sk6lirQCnprKfnLjqRqVFWw897DEVlDXtB5hBwgT2AFk0vCdLEujVM5mpcly
	PqF0mhRdlpLS24HIc1mlNM6uVI3nv6gNKQJhDF8oFouFMVFiAf4c60HB5TQ2JpcZqEyK0lK6
	TR/CDOTkItyu+G8f6/6N4u+N/lT85xH3wamtYQk5bHs1O70vqOUet9u9X1S+Oyx6sN6wxdLV
	sHCSqjw2I5hYw+7YslmfsxjmDyzW5uHe429dDN87ixdze7LPxNrz+gvpgy9VJmUfd5ZvObq+
	Wpw58vfiCnXlxn+PjG9fTHjH+DBfqnpYF/p9+FRo3vvJEu0zOT+VIj83DZTy4z66dqSMqx7J
	Te6/Zbl7M67eiNUGv/tP/6jKFV32+3hZQCNnQVJyCl9fXU5ncwjXK+PWPYcb3huvKLSdP3Sg
	9dk5yS9Y5Zdj0rhzJ6oHFcYXJn7tFTRFHjAGb4tsPXavMz3JfD1GerXDdCjDEJv/WfJfOF2v
	kAnCaDq97H9HwECqdwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsWy7bCSnG7PWr90g3vP2Sw+fv3NYjFn1TZG
	i9V3+9ksXh/+xGhx88BOJouVq48yWbxrPcdiMXt6M5PF0f9v2SwmHbrGaLH3lrbFnr0nWSzm
	L3vKbtF9fQebxfLj/5gszv89zmpxftYcdgdBj52z7rJ7XD5b6rFpVSebx+Yl9R67bzaweXx8
	eovFo2/LKkaPMwuOsHt83iTnsenJW6YArigum5TUnMyy1CJ9uwSujBvHpjMVtMtV9E+/ztrA
	eFi8i5GTQ0LAROL9uV2MXYxcHEIC2xkl/h5YxQKRkJA49XIZI4QtLLHy33N2iKInjBJ/Nkxn
	BkmwCKhI7Hp6jAnEZhNQlzjyvBWsQUTAVGLyp61sIA3MAt3MEi/2zWUFSQgLxErsnLkGrJlX
	QFfi6fELCFOPLbvPCJEQlDg58wnYGcwCWhI3/r0E2sABZEtLLP/HAWJyChhLzPsoB1IhKqAs
	cWDbcaYJjIKzkDTPQtI8C6F5ASPzKkbR1ILi3PTc5AJDveLE3OLSvHS95PzcTYzgaNQK2sG4
	bP1fvUOMTByMhxglOJiVRHiXr/dOF+JNSaysSi3Kjy8qzUktPsQozcGiJM6rnNOZIiSQnliS
	mp2aWpBaBJNl4uCUamDibrPgOcupsWj6AnGPL5rXGBQcOM/O5phxbcHV6VEeD7W8ih9O+FFm
	sXFd92Xv1DmTxDOYP2/eHxmjMSfk1ft1l2Wenf3npVZmIH43l/24Z3MrWybDtwcuP78oVv87
	uGrlkpl2SZdeLBa9UdhtE7l+4eaQgufSWnpHmF7F9d2cGMbRevoZs01Ljivvq/ybJwQfM/SZ
	10XdeyhbHHxt9Y+7q9gMcxM/cdgvaCx7xHSZ+Y7/8fwE1geTt7mYSrhP/uGdfkPrdIxH1t9/
	Hxueu2zRzLa8+PrpJZMXWuHHD4iF/pyj/SHkr5rkJFmZ4miuW4nWXo3Cey/l2N+Iafr0q6hC
	3PL/xHDtA0+umrHMFnRQYinOSDTUYi4qTgQAck3htjUDAAA=
X-CMS-MailID: 20241203070444epcas5p298f09249205b1e3edc76c90e5de76c04
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----x2Ox1x5iNi7PYvDn9sIpGVgpr3_-t8l_a8xeGFysXFeU9Shi=_51c60_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241128113109epcas5p46022c85174da65853c85a8848b32f164
References: <20241128112240.8867-1-anuj20.g@samsung.com>
	<CGME20241128113109epcas5p46022c85174da65853c85a8848b32f164@epcas5p4.samsung.com>
	<20241128112240.8867-7-anuj20.g@samsung.com>
	<yq1r06psey3.fsf@ca-mkp.ca.oracle.com>

------x2Ox1x5iNi7PYvDn9sIpGVgpr3_-t8l_a8xeGFysXFeU9Shi=_51c60_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Mon, Dec 02, 2024 at 09:13:14PM -0500, Martin K. Petersen wrote:
> 
> I have things running on my end on top of Jens' tree (without error
> injection, that's to come).
> 
> One question, though: How am I to determine that the kernel supports
> attr_ptr and IORING_RW_ATTR_FLAG_PI? Now that we no longer have separate
> IORING_OP_{READ,WRITE}_META commands I can't use IO_URING_OP_SUPPORTED
> to find out whether the running kernel supports PI passthrough.

Martin, right currently there is no way to probe whether the kernel
supports read/write attributes or not.

Jens, Pavel how about introducing a new IO_URING_OP_* flag (something
like IO_URING_OP_RW_ATTR_SUPPORTED) to probe whether read/write attributes
are supported or not. Something like this [*]

[*]
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 38f0d6b10eaf..787a2df8037f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -723,6 +723,7 @@ struct io_uring_rsrc_update2 {
 #define IORING_REGISTER_FILES_SKIP	(-2)
 
 #define IO_URING_OP_SUPPORTED	(1U << 0)
+#define IO_URING_OP_RW_ATTR_SUPPORTED	(1U << 1)
 
 struct io_uring_probe_op {
 	__u8 op;
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 3de75eca1c92..64e1e5d48dec 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -67,6 +67,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
 		.vectored		= 1,
+		.rw_attr		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_readv,
 		.issue			= io_read,
@@ -82,6 +83,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
 		.vectored		= 1,
+		.rw_attr		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_writev,
 		.issue			= io_write,
@@ -101,6 +103,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
+		.rw_attr		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_read_fixed,
 		.issue			= io_read,
@@ -115,6 +118,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
+		.rw_attr		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_write_fixed,
 		.issue			= io_write,
@@ -246,6 +250,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
+		.rw_attr		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_read,
 		.issue			= io_read,
@@ -260,6 +265,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
+		.rw_attr		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_write,
 		.issue			= io_write,
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index 14456436ff74..61460c762ea7 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -27,6 +27,8 @@ struct io_issue_def {
 	unsigned		iopoll_queue : 1;
 	/* vectored opcode, set if 1) vectored, and 2) handler needs to know */
 	unsigned		vectored : 1;
+	/* supports rw attributes */
+	unsigned		rw_attr : 1;
 
 	/* size of async data needed, if any */
 	unsigned short		async_size;
diff --git a/io_uring/register.c b/io_uring/register.c
index f1698c18c7cb..a54aeaec116c 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -60,8 +60,11 @@ static __cold int io_probe(struct io_ring_ctx *ctx, void __user *arg,
 
 	for (i = 0; i < nr_args; i++) {
 		p->ops[i].op = i;
-		if (io_uring_op_supported(i))
+		if (io_uring_op_supported(i)) {
 			p->ops[i].flags = IO_URING_OP_SUPPORTED;
+			if (io_issue_defs[i].rw_attr)
+				p->ops[i].flags |= IO_URING_OP_RW_ATTR_SUPPORTED;
+		}
 	}
 	p->ops_len = i;
 
-- 
2.25.1

------x2Ox1x5iNi7PYvDn9sIpGVgpr3_-t8l_a8xeGFysXFeU9Shi=_51c60_
Content-Type: text/plain; charset="utf-8"


------x2Ox1x5iNi7PYvDn9sIpGVgpr3_-t8l_a8xeGFysXFeU9Shi=_51c60_--


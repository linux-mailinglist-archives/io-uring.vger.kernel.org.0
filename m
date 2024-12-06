Return-Path: <io-uring+bounces-5272-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F3869E6EA7
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 13:56:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB953188504F
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 12:53:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 736252066DF;
	Fri,  6 Dec 2024 12:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fwvESw4z"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65E72066DD
	for <io-uring@vger.kernel.org>; Fri,  6 Dec 2024 12:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733489598; cv=none; b=ft/U7aEmS+fg2G10HmQtS4tDoGsC2sS+hIDK7yD2B7lJxoNr90BxSV3JCafS83PmW+1ur2O8BFPdwM5rMUvaCriFxnf6yaf4IWK7CnZi+pkpqSQ4UxpuKXprt8advyltSi12yfyiOt0elGoPEj1tMEvpgPqtt+UJ5Nle1dx/MDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733489598; c=relaxed/simple;
	bh=3gyn0P2WBGi8VdVYfuLo1gQO5OT3TgYcL5YCwlOpEnM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=GZd+6I29ZiQkDLraE6WYDTtm9s6ojUQi1wVOL9U+hFLp7Usjw+XIatpaF7+JQIMRfbRfih7uLVR4LTulzNT5rK27khvIwP3J+sXJk10G9S2mhv/NMuGKxr4GPpXzkZRQAvTnGdllx6Fo+0vXOSi4RrKOzxD77OVr41kwTfIUsTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=fwvESw4z; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241206125314epoutp03bfc27cba9f175972af577c49a1e0c282~Ol5ogCqF72595325953epoutp033
	for <io-uring@vger.kernel.org>; Fri,  6 Dec 2024 12:53:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241206125314epoutp03bfc27cba9f175972af577c49a1e0c282~Ol5ogCqF72595325953epoutp033
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1733489594;
	bh=r0eb+1efv9hue/wz6nmaPD5kfRQiRJaq4jva+IfysW0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fwvESw4zNiq3NLNBrbRJjgXfIhBgYKtTOyZ2q67KGRHLmeOOxL0PKoZAtiR37qOt5
	 fDp/DbyBCKxdbq65tkzXbKNmz8Dt0D9kpyAjY+IKI6dc5TyHlnFPjhaqoIL/7jLFJ5
	 DvQTQBFz5nklmydT6JYnb5bXZFZ7ojiolHpu0mok=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241206125314epcas5p2d4513540aec6da02541338747e6d2156~Ol5n_IMSa3164331643epcas5p25;
	Fri,  6 Dec 2024 12:53:14 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Y4WQK11Vzz4x9Pp; Fri,  6 Dec
	2024 12:53:13 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C2.38.19933.8B3F2576; Fri,  6 Dec 2024 21:53:13 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241206100326epcas5p17d4dad663ccc6c6f40cfab98437e63f3~OjlYLUq262561725617epcas5p1Q;
	Fri,  6 Dec 2024 10:03:26 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241206100326epsmtrp1adc8403b8ba8b2f0edff705221848541~OjlYKdIiS3264032640epsmtrp1M;
	Fri,  6 Dec 2024 10:03:26 +0000 (GMT)
X-AuditID: b6c32a4a-b87c770000004ddd-c4-6752f3b81d45
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D9.D0.18729.EEBC2576; Fri,  6 Dec 2024 19:03:26 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20241206100325epsmtip119b3f07b19ba66c4ef8dd431a5ef4e75~OjlWi51oG0795007950epsmtip1K;
	Fri,  6 Dec 2024 10:03:24 +0000 (GMT)
Date: Fri, 6 Dec 2024 15:25:36 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, sagi@grimberg.me, asml.silence@gmail.com, Keith
	Busch <kbusch@kernel.org>
Subject: Re: [PATCHv11 03/10] io_uring: add write stream attribute
Message-ID: <20241206095536.pxnjbsaxg5jfaixo@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241206015308.3342386-4-kbusch@meta.com>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCJsWRmVeSWpSXmKPExsWy7bCmuu7Oz0HpBoeOM1rMWbWN0WL13X42
	i5WrjzJZvGs9x2Ix6dA1RoszVxeyWOy9pW2xZ+9JFov5y56yW6x7/Z7Fgctj56y77B7n721k
	8bh8ttRj06pONo/NS+o9dt9sYPM4d7HC4/MmuQCOqGybjNTElNQihdS85PyUzLx0WyXv4Hjn
	eFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKADlRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2
	SqkFKTkFJgV6xYm5xaV56Xp5qSVWhgYGRqZAhQnZGZv27mIsWCFYce3LYtYGxvd8XYwcHBIC
	JhJ/nmp3MXJxCAnsZpSYM/sxI4TziVGibf87NgjnG6PE2rMTmbsYOcE67i1qYIJI7GWUeLl3
	MSuE8wyof9YsFpAqFgEViZ49J9lBbDYBdYkjz1sZQWwRAUWJ88BQALGZQRoWnooBsYUFnCSu
	zn4GFucVMJOYu3s2lC0ocXLmE7CZnALmEiuvtzKB2KICMhIzln6Fumgph8TK9eYQ/7hIvFwT
	DhEWlnh1fAs7hC0l8bK/DcpOl/hx+SkThF0g0XxsHyOEbS/ReqqfGeK0DIk/q89D1chKTD21
	jgkizifR+/sJVJxXYsc8GFtJon3lHChbQmLvuQYo20Pi9aXn0CDdzihx40Y30wRG+VlIXpuF
	ZB+EbSXR+aGJdRbQO8wC0hLL/3FAmJoS63fpL2BkXcUomVpQnJueWmxaYJSXWg6P7+T83E2M
	4OSr5bWD8eGDD3qHGJk4GA8xSnAwK4nwVoYFpgvxpiRWVqUW5ccXleakFh9iNAVG1URmKdHk
	fGD6zyuJNzSxNDAxMzMzsTQ2M1QS533dOjdFSCA9sSQ1OzW1ILUIpo+Jg1OqgUlGi0fVycU1
	SmP5ERnBLRYSPQY36g7OmGD+tDKz94udhGRq1rHH3M/4YlaZdL+XK7k3I4uP64jjtIt/PqUz
	zH/lvWVa2DLbxTeFl7Bu06vg2Vc8YdLGlayph3YKe/qbfrnUMTspfrGEUa18oLdUPd+WuPWm
	R/ur1j7w8CjkWayidPeU288dhgIpS+deZH0Qr7vR5T/XTi/z6Dk3XrabqTm6VL15M2sX+y1x
	LYYZzjvNzhxlnL5O8nvO3A+ro0OXZv5icXT/9Hn7tNDHrFP1qmdP4L16yPnxjckzuG9yaB+4
	+vdUhcnvBc9i2Lg45j1hOyAi6NNoyD+n2TTSxvWdxQqGPYGWMjtFs1OFS38dv6XEUpyRaKjF
	XFScCADZvOB4RwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWy7bCSnO6700HpBjd/q1vMWbWN0WL13X42
	i5WrjzJZvGs9x2Ix6dA1RoszVxeyWOy9pW2xZ+9JFov5y56yW6x7/Z7Fgctj56y77B7n721k
	8bh8ttRj06pONo/NS+o9dt9sYPM4d7HC4/MmuQCOKC6blNSczLLUIn27BK6M3t19TAW3+Cq+
	XD/L3MC4m6eLkZNDQsBE4t6iBqYuRi4OIYHdjBLdc5rYIRISEqdeLmOEsIUlVv57zg5R9IRR
	4vzzbWBFLAIqEj17ToLZbALqEkeet4I1iAgoSpwHOgWkgVngGaPErj0rmEESwgJOEldnP2MD
	sXkFzCTm7p4NZgsJJEvc27eEESIuKHFy5hMWEJsZqGbe5odAvRxAtrTE8n8cIGFOAXOJlddb
	mUBsUQEZiRlLvzJPYBSchaR7FpLuWQjdCxiZVzFKphYU56bnFhsWGOallusVJ+YWl+al6yXn
	525iBEeOluYOxu2rPugdYmTiYDzEKMHBrCTCWxkWmC7Em5JYWZValB9fVJqTWnyIUZqDRUmc
	V/xFb4qQQHpiSWp2ampBahFMlomDU6qByZXHNYLBSrfJ8H/sqbLEGS1Lzm+8GL7srNHaM8qS
	DdryO1i9Vwt3fD3xeNd/1U/5d59MkeaPfnphV+Ld01oyW34I/2o4b7NGt7lofdNP5l2fpKYJ
	151ap655M3du+bnDDzcY70vXWfFd4OvSOr2N/w+KKt8J+HHv1V0D5flubq25Ky29249vYYnp
	+ML2dutp1szZO+Kr33PVKkYpSOVnf3/4vvFrTdVDy+WT+bwTlx0X0lm7/W1X2mnWSRY/FRKN
	QusnPlvM1nUnrnpNMafm1l+L2LgNz3TcPcHekLl01RdBWXPJpBc8Wur+Hv+P2O3a+O6y1dS5
	Sr9Y2m85uHS/D5zXGOgo578wSHbS4mcnDiuxFGckGmoxFxUnAgDti1QBCwMAAA==
X-CMS-MailID: 20241206100326epcas5p17d4dad663ccc6c6f40cfab98437e63f3
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----lzW.cJR_-6sCvQYD.lREqa.H-32Z9TKwpDxBjmCjs3VZTSBT=_63789_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241206100326epcas5p17d4dad663ccc6c6f40cfab98437e63f3
References: <20241206015308.3342386-1-kbusch@meta.com>
	<20241206015308.3342386-4-kbusch@meta.com>
	<CGME20241206100326epcas5p17d4dad663ccc6c6f40cfab98437e63f3@epcas5p1.samsung.com>

------lzW.cJR_-6sCvQYD.lREqa.H-32Z9TKwpDxBjmCjs3VZTSBT=_63789_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 05/12/24 05:53PM, Keith Busch wrote:
>From: Keith Busch <kbusch@kernel.org>
>
>Adds a new attribute type to specify a write stream per-IO.
>
>Signed-off-by: Keith Busch <kbusch@kernel.org>
>---
> include/uapi/linux/io_uring.h |  9 ++++++++-
> io_uring/rw.c                 | 28 +++++++++++++++++++++++++++-
> 2 files changed, 35 insertions(+), 2 deletions(-)
>
>diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>index 5fa38467d6070..263cd57aae72d 100644
>--- a/include/uapi/linux/io_uring.h
>+++ b/include/uapi/linux/io_uring.h
>@@ -123,7 +123,14 @@ struct io_uring_attr_pi {
> 	__u64	rsvd;
> };
>
>-#define IORING_RW_ATTR_FLAGS_SUPPORTED (IORING_RW_ATTR_FLAG_PI)
>+#define IORING_RW_ATTR_FLAG_WRITE_STREAM (1U << 1)
>+struct io_uring_write_stream {
Nit:
You can consider keeping a io_uring_attr_* prefix here, so that it aligns
with current attribute naming style.
s/io_uring_write_stream/io_uring_attr_write_stream

>+	__u16	write_stream;
>+	__u8	rsvd[6];
>+};
>+
>+#define IORING_RW_ATTR_FLAGS_SUPPORTED (IORING_RW_ATTR_FLAG_PI | 	\
>+					IORING_RW_ATTR_FLAG_WRITE_STREAM)
>
> /*
>  * If sqe->file_index is set to this for opcodes that instantiate a new
>diff --git a/io_uring/rw.c b/io_uring/rw.c
>index a2987aefb2cec..69b566e296f6d 100644
>--- a/io_uring/rw.c
>+++ b/io_uring/rw.c
>@@ -299,6 +299,22 @@ static int io_prep_rw_pi(struct io_kiocb *req, struct io_rw *rw, int ddir,
> 	return ret;
> }
>
>+static int io_prep_rw_write_stream(struct io_rw *rw, u64 *attr_ptr)
>+{
>+	struct io_uring_write_stream write_stream;
>+
>+	if (copy_from_user(&write_stream, u64_to_user_ptr(*attr_ptr),
>+			   sizeof(write_stream)))
>+		return -EFAULT;
>+
>+	if (!memchr_inv(write_stream.rsvd, 0, sizeof(write_stream.rsvd)))
This should be:
	if (memchr_inv(write_stream.rsvd, 0, sizeof(write_stream.rsvd)))

------lzW.cJR_-6sCvQYD.lREqa.H-32Z9TKwpDxBjmCjs3VZTSBT=_63789_
Content-Type: text/plain; charset="utf-8"


------lzW.cJR_-6sCvQYD.lREqa.H-32Z9TKwpDxBjmCjs3VZTSBT=_63789_--


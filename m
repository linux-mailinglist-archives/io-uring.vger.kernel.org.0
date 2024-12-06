Return-Path: <io-uring+bounces-5269-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CB6B39E6E88
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 13:50:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 319B51885F59
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 12:44:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31E7D203702;
	Fri,  6 Dec 2024 12:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="RZNPnlER"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DA3203708
	for <io-uring@vger.kernel.org>; Fri,  6 Dec 2024 12:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733489080; cv=none; b=nzdZnMf6MfYCREubpW0zXWF5VvODuNEb0xCudZGD6qmO0QDPDK5Os94uS0sFwl51YWu0CBPcMzOtLDFruchxD9gB8/RpChmOuvymTol6JErCmkbWX+8mJ9/IVFyYZG+w3mtOmghx96ape7FJKO+mtL0EliwWr/y4E7gvsO2y9dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733489080; c=relaxed/simple;
	bh=CiHjy54TML9tQqb/NTOcsUj93vOt0TCmvDz5m3bBB9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=CeQjXINu2O8+vTyxsli/Eaqsq3blNx1SK4q8v5CEJXc+Z/hkrMmXNNcNK7iFw44dg6YDp68njmMwq69JCO1yE9lSqnkkhdNuLepGQelULnGkrXnUfch/8c4gQGzYzHbjcGWnerlr80EczM6aItiqu4y8rzj+j+YUo1yxXZihXi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=RZNPnlER; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241206124433epoutp035f34c8a630adaf331ee92593e42e8d04~OlyDaevTc1877718777epoutp03M
	for <io-uring@vger.kernel.org>; Fri,  6 Dec 2024 12:44:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241206124433epoutp035f34c8a630adaf331ee92593e42e8d04~OlyDaevTc1877718777epoutp03M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1733489073;
	bh=yc4BEe7BKj+K73PpdiIviH16FCf0tS85OTF3LXxZW0Y=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=RZNPnlER4+06Nf+/vPDvBOA0dL6xh0Nmv+TUCMU9kDqlSV++JQGdQq4VPDQgI01r4
	 sVoKJ77pOTeLOqqhkyhEEa8qo8c1wmYCn2cfx6ztHBL8zRgaRqR3M0aWp3DgOIaBhc
	 La5DoKT9hET3jr1G5ZTWFdgpkb06NPJ0OUWgP4+I=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241206124433epcas5p10de029829d5ebab13ab1bd11591fc64a~OlyC3AQjG2611626116epcas5p1o;
	Fri,  6 Dec 2024 12:44:33 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Y4WDJ0hwRz4x9Pw; Fri,  6 Dec
	2024 12:44:32 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	73.A7.19710.FA1F2576; Fri,  6 Dec 2024 21:44:31 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241206124431epcas5p464e8ee56a3f519831d4f5ba16047f990~OlyBTbIJw0039500395epcas5p44;
	Fri,  6 Dec 2024 12:44:31 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241206124431epsmtrp26428836afb25bab3eb421b9afe03a90b~OlyBSyGUu2403824038epsmtrp2z;
	Fri,  6 Dec 2024 12:44:31 +0000 (GMT)
X-AuditID: b6c32a44-363dc70000004cfe-52-6752f1af1764
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	45.00.33707.FA1F2576; Fri,  6 Dec 2024 21:44:31 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241206124430epsmtip191718193b8f3ea62f14bc7fd5b3a6f89~Olx-vil760592605926epsmtip11;
	Fri,  6 Dec 2024 12:44:29 +0000 (GMT)
Message-ID: <bcfd9c63-797b-4f6b-aa6e-0e639247003b@samsung.com>
Date: Fri, 6 Dec 2024 18:14:29 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv11 03/10] io_uring: add write stream attribute
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc: sagi@grimberg.me, asml.silence@gmail.com, Keith Busch
	<kbusch@kernel.org>
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20241206015308.3342386-4-kbusch@meta.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMJsWRmVeSWpSXmKPExsWy7bCmlu76j0HpBnOarS3mrNrGaLH6bj+b
	xcrVR5ks3rWeY7GYdOgao8WZqwtZLPbe0rbYs/cki8X8ZU/ZLda9fs/iwOWxc9Zddo/z9zay
	eFw+W+qxaVUnm8fmJfUeu282sHmcu1jh8XmTXABHVLZNRmpiSmqRQmpecn5KZl66rZJ3cLxz
	vKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtCBSgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJb
	pdSClJwCkwK94sTc4tK8dL281BIrQwMDI1OgwoTsjCUHJrIUTOKr+L8upoFxHlcXIyeHhICJ
	xM9561i6GLk4hAR2M0q0XJ7FCuF8YpRY/fsLE5yz5GQvM0zL7FWXWEFsIYGdjBJfmwIgit4y
	Slz78oUdJMErYCfxbeJNoG4ODhYBFYnbJ1wgwoISJ2c+YQGxRQXkJe7fmgFWLizgJHF19jM2
	kDkiAjsYJTpfPmUCSTAL+Evc6/jDCGGLS9x6Mh9sJpuApsSFyaUgYU4Bc4mV11uhyuUltr+d
	wwwyR0JgKYfE3RX9bBBHu0hseHMV6gFhiVfHt7BD2FISn9/tharJlnjw6AELhF0jsWNzHyuE
	bS/R8OcGK8heZqC963fpQ+zik+j9/QTsHAkBXomONiGIakWJe5OeQnWKSzycsQTK9pD4/3IH
	GySotjNKvPs0g20Co8IspGCZheTLWUjemYWweQEjyypGydSC4tz01GTTAsO81HJ4dCfn525i
	BKdeLZcdjDfm/9M7xMjEwXiIUYKDWUmEtzIsMF2INyWxsiq1KD++qDQntfgQoykweiYyS4km
	5wOTf15JvKGJpYGJmZmZiaWxmaGSOO/r1rkpQgLpiSWp2ampBalFMH1MHJxSDUzF2VYOh5iT
	DM9d+jRJ+P3qSJVV22ue30zPt/APcspw7k4q6DTLmPZadGJURIfM7O+TdNO815y/q/f+U/uj
	BU+vzlsU2vOL65quXE+VwIYtKy9ukWR5xVYm8kW3o6smlVtKP8vNWCAqxLvhzs/kqqWlhXFO
	ew4m6JpEet1qvBuofXeJxKQDGdObYzaobE6ZafpzUdvqc6Y1Ah/7t/WVzvU78UVpqdveV0w9
	k17dLF5+c6VrT2ibwKmGxer61X2rFncIZqUyuPG9Xyn0t2BZJ8dLrr2zG44ZHp8V9vc9w46z
	/wXiQlV6hM3OZwgwz3FYFceqN2UNm3rLk7sbrbSXW0nVLFPO2pi3Zupc7hla1UosxRmJhlrM
	RcWJAJrzzTxGBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42LZdlhJTnf9x6B0g/Z1ShZzVm1jtFh9t5/N
	YuXqo0wW71rPsVhMOnSN0eLM1YUsFntvaVvs2XuSxWL+sqfsFutev2dx4PLYOesuu8f5extZ
	PC6fLfXYtKqTzWPzknqP3Tcb2DzOXazw+LxJLoAjissmJTUnsyy1SN8ugStjyYGJLAWT+Cr+
	r4tpYJzH1cXIySEhYCIxe9Ul1i5GLg4hge2MEtPOvmGFSIhLNF/7wQ5hC0us/PecHaLoNaPE
	selPWEASvAJ2Et8m3mTqYuTgYBFQkbh9wgUiLChxciZEiaiAvMT9WzPA5ggLOElcnf2MDWSO
	iMAORon/63aygSSYBXwlHly9xQZ3xdIDF9khEuISt57MB1vAJqApcWFyKUiYU8BcYuX1ViaI
	EjOJrq1djBC2vMT2t3OYJzAKzUJyxywkk2YhaZmFpGUBI8sqRtHUguLc9NzkAkO94sTc4tK8
	dL3k/NxNjOAI0wrawbhs/V+9Q4xMHIyHGCU4mJVEeCvDAtOFeFMSK6tSi/Lji0pzUosPMUpz
	sCiJ8yrndKYICaQnlqRmp6YWpBbBZJk4OKUamLZbFKoKsd861HXroMnxt7dju5WSbYvUbpvn
	X/aY+Gz17ffMoe3nFR+sqd57uiLHQFX765oFk1dFyoSumP1xgsXimXlvpyhasfWV35W5qKN7
	vn3z77Z4Tl2Tn6me39uaKy1aT/l5721WXGjo/U7X9wab9Wvr45fqN++5/dR5ddLsjYFJJ64G
	uL75NSVja51O6r0zHu4bdeb/Unsqqzpl9to469nCC/Y+Cd8m8Nps8zrnJ7ln1qwp+u6gZWp5
	eE26plLIhJNVvY2P3HwMTZzOTWpR4jW5wMT6ZondTKGo9RPDROss93kG+Un1uGWlRsziePn9
	1/cXE42XdNi4PTDer3/EQC9+/vtW3j9Tqjs9uZRYijMSDbWYi4oTAboZuucfAwAA
X-CMS-MailID: 20241206124431epcas5p464e8ee56a3f519831d4f5ba16047f990
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241206015353epcas5p174318c263e73bfe8728d49b5e90a14e8
References: <20241206015308.3342386-1-kbusch@meta.com>
	<CGME20241206015353epcas5p174318c263e73bfe8728d49b5e90a14e8@epcas5p1.samsung.com>
	<20241206015308.3342386-4-kbusch@meta.com>

On 12/6/2024 7:23 AM, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Adds a new attribute type to specify a write stream per-IO.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   include/uapi/linux/io_uring.h |  9 ++++++++-
>   io_uring/rw.c                 | 28 +++++++++++++++++++++++++++-
>   2 files changed, 35 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 5fa38467d6070..263cd57aae72d 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -123,7 +123,14 @@ struct io_uring_attr_pi {
>   	__u64	rsvd;
>   };
>   
> -#define IORING_RW_ATTR_FLAGS_SUPPORTED (IORING_RW_ATTR_FLAG_PI)
> +#define IORING_RW_ATTR_FLAG_WRITE_STREAM (1U << 1)
> +struct io_uring_write_stream {
> +	__u16	write_stream;
> +	__u8	rsvd[6];
> +};

So this needs 8 bytes. Maybe passing just 'u16 write_stream' is better? 
Or do you expect future additions here (to keep rsvd).

Optimization is possible (now or in future) if it's 4 bytes or smaller, 
as that can be placed in SQE along with a new RW attribute flag that 
says it's placed inline. Like this -

--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -92,6 +92,10 @@ struct io_uring_sqe {
                         __u16   addr_len;
                         __u16   __pad3[1];
                 };
+               struct {
+                       __u16   write_hint;
+                       __u16   __rsvd[1];
+               };
         };
         union {
                 struct {
@@ -113,6 +117,7 @@ struct io_uring_sqe {

  /* sqe->attr_type_mask flags */
  #define IORING_RW_ATTR_FLAG_PI (1U << 0)
+#define IORING_RW_ATTR_FLAG_WRITE_STREAM_INLINE        (1U << 1)


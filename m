Return-Path: <io-uring+bounces-4189-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF6A39B5B09
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 06:05:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F30DA1C21166
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 05:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9D361974FA;
	Wed, 30 Oct 2024 05:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WjElu5fQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352DABA4A
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 05:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730264730; cv=none; b=dMj4o+Za3rxR+5r9INJuJTUVE5AeYhL/cC18bMo3BvfaHJJjGYZATRHrTBC098n3pgfeqZokHnXEJqiSNhWeaDRutlPY/5AXhWSjEWCnYtB99iPl+6D7Z9dhzCtkmKi8rM7tMJ/P5JSjRdqftylThCVKd9Tc3mL8JdRxqLWyuE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730264730; c=relaxed/simple;
	bh=LW6rWSjj9LK9qqrK8sxhkehlqojrx13o/DskD2jD5fo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=uNm2KnDzwyxSqlNF42TaIA4baS1Kr3iZFe+PcxvOVyhMvKxNg6HuAUJVwGpR+QX4JXihmz0GSfkEjBFX6n7742OUF5uSAn7UvVAkQfccVHaaLViSkE+XyLOXB9n3aD+C+t+SCchFDphYVTjMaDWcSbjMDY7dWNT6GSZ1El7WB9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=WjElu5fQ; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241030050525epoutp04153c3fc4fc58cb77166b29c1041d33bb~DIpmmZYQn1764117641epoutp04B
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 05:05:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241030050525epoutp04153c3fc4fc58cb77166b29c1041d33bb~DIpmmZYQn1764117641epoutp04B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730264725;
	bh=etBprYSM4yFFyx7jI/nY0m4KP0A/tvtFjbDsfqM8nJE=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=WjElu5fQB3BGXq33OC861ztInCb6gEp16vr84DaKVQ9cTw4iOCfaoWyP6tlekUmCu
	 EJ3FKrDXP6X6a96ct2neTEcMvZPddDf0qRQZ41NXaCdhujTZzegrbbdyTe+SgZNEJo
	 uXKHSFuvCUfAJVbwlGbjj5L9hp3GJJW8irpgiGm8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241030050524epcas5p4451c336ce7026125a3f87be95f047eb3~DIpmFKRSN1573915739epcas5p4t;
	Wed, 30 Oct 2024 05:05:24 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4XdZnb1ynmz4x9Q7; Wed, 30 Oct
	2024 05:05:23 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F0.6C.18935.39EB1276; Wed, 30 Oct 2024 14:05:23 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241030050522epcas5p317df8853e25adec42e977ab172bb140a~DIpkU8C862186321863epcas5p3-;
	Wed, 30 Oct 2024 05:05:22 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241030050522epsmtrp2ade48a30ca6c52c955f9b90f7b14bc1f~DIpkTF8qQ0301203012epsmtrp2B;
	Wed, 30 Oct 2024 05:05:22 +0000 (GMT)
X-AuditID: b6c32a50-a99ff700000049f7-20-6721be930b81
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	DF.85.08229.29EB1276; Wed, 30 Oct 2024 14:05:22 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241030050520epsmtip262763cbc4fe93dbcba6dba18df76e472~DIph8qeYI1320213202epsmtip2C;
	Wed, 30 Oct 2024 05:05:20 +0000 (GMT)
Message-ID: <e7aae741-c139-48d1-bb22-dbcd69aa2f73@samsung.com>
Date: Wed, 30 Oct 2024 10:35:19 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/10] io_uring/rw: add support to send metadata
 along with read/write
To: Keith Busch <kbusch@kernel.org>, Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	asml.silence@gmail.com, anuj1072538@gmail.com, brauner@kernel.org,
	jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <ZyFuxfiRqH8YB-46@kbusch-mbp.dhcp.thefacebook.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJsWRmVeSWpSXmKPExsWy7bCmhu7kfYrpBpPW81h8/PqbxaJpwl9m
	izmrtjFarL7bz2bx+vAnRoubB3YyWaxcfZTJ4l3rORaL2dObmSwmHbrGaLH3lrbFnr0nWSzm
	L3vKbtF9fQebxfLj/5gszv89zmpxftYcdgdBj52z7rJ7XD5b6rFpVSebx+Yl9R67bzaweXx8
	eovFo2/LKkaPMwuOsHt83iTnsenJW6YArqhsm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwND
	XUNLC3MlhbzE3FRbJRefAF23zBygd5QUyhJzSoFCAYnFxUr6djZF+aUlqQoZ+cUltkqpBSk5
	BSYFesWJucWleel6eaklVoYGBkamQIUJ2RldR6azFrwWrDi0bgVrA+N6vi5GTg4JAROJLcvm
	MXcxcnEICexhlHjUMosdwvnEKLFiy0MmCOcbo8SXjjnMMC13L6yASuxllNh2ZD0LhPOWUWL1
	lvPsIFW8AnYSN/suM3YxcnCwCKhKfJ+SBBEWlDg58wkLiC0qIC9x/9YMsHJhgXiJ1gfXweIi
	Am4Sjf/ug81kFnjLJDHl1zUmkASzgLjErSfzmUBmsgloSlyYXApicgrYS8zfKgVRIS+x/e0c
	sHckBH5wSHzp2s8OcbSLxN4H/xghbGGJV8e3QMWlJD6/28sGYWdLPHj0gAXCrpHYsbmPFcK2
	l2j4c4MVZBcz0Nr1u/QhdvFJ9P5+AnaNhACvREebEES1osS9SU+hOsUlHs5YAmV7SPTNusYM
	D9xppx8zTmBUmIUUKrOQPDkLyTuzEDYvYGRZxSiVWlCcm56abFpgqJuXWg6P8OT83E2M4NSu
	FbCDcfWGv3qHGJk4GA8xSnAwK4nwWgYppgvxpiRWVqUW5ccXleakFh9iNAVGz0RmKdHkfGB2
	ySuJNzSxNDAxMzMzsTQ2M1QS533dOjdFSCA9sSQ1OzW1ILUIpo+Jg1OqgclchVXmpo5gcMkq
	xmsbXCwlU8P6FxaIP682tqkRT4m8xdX96tyW+Wv2nk0+cWGmjVTvwnLv/4u7FocxOF1ls5J2
	fij1aGZzxRH2D667YooUrVlSvWzkp4fsMLntuZv/9w3T2XvEk5aemLa4dcm+0JM8taYV8qc0
	xb6tTy5fxb4lTrCkXnmiBA+7yyrFym1RvU2J6vwygqdWnmYuWPbz0F9fG8NFn4+KTWA8vKG8
	tW9e+V6jZzPlyuMe/p+VEtS3fslB9ufxPP76z7nPHFNU/qYtyVDjdWP6/0XF3K1fvbzztt6c
	sijiac8s7uzNFx+c2+HU4pJnnJYXEruRYeYB6S/MHbpbnz6WXzFZOfpjoxJLcUaioRZzUXEi
	AIL8OZd2BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsWy7bCSvO6kfYrpBk8nK1t8/PqbxaJpwl9m
	izmrtjFarL7bz2bx+vAnRoubB3YyWaxcfZTJ4l3rORaL2dObmSwmHbrGaLH3lrbFnr0nWSzm
	L3vKbtF9fQebxfLj/5gszv89zmpxftYcdgdBj52z7rJ7XD5b6rFpVSebx+Yl9R67bzaweXx8
	eovFo2/LKkaPMwuOsHt83iTnsenJW6YArigum5TUnMyy1CJ9uwSujK4j01kLXgtWHFq3grWB
	cT1fFyMnh4SAicTdCyuYuhi5OIQEdjNKLHx1nB0iIS7RfO0HlC0ssfLfczBbSOA1o8SbXxIg
	Nq+AncTNvsuMXYwcHCwCqhLfpyRBhAUlTs58wgJiiwrIS9y/NQOsVVggXmLi/z/MILaIgJtE
	47/7LCB7mQXeMkkca77DCDH/E6PEq38WIDYz0A23nsxnApnPJqApcWFyKYjJKWAvMX+rFESF
	mUTX1i5GCFteYvvbOcwTGIVmIbliFpJBs5C0zELSsoCRZRWjZGpBcW56brFhgWFearlecWJu
	cWleul5yfu4mRnAEa2nuYNy+6oPeIUYmDsZDjBIczEoivJZBiulCvCmJlVWpRfnxRaU5qcWH
	GKU5WJTEecVf9KYICaQnlqRmp6YWpBbBZJk4OKUamLp+Vu9yfHbk3PIDYttYGW59PO/gXpt1
	on2H7HnVpdyZSbPvrN8VK2++Y9GRs6m6FytZlzHu+vQp43lkwL9GsdiyVRX37un2PhBJ/xgX
	fC6rU3O9qFb43tboSysrP849MF+hanuJ6rI64UnfPxw/F5cTriwf1ed6ofJdjGpfwp7lRzyy
	nSvXGkt/U791KpOL1UVhAe9TI84XlpqbpH13X6iIturn3XdhxRc+8ZQTK6cdfv+wZ3P4Z6a0
	t28bLxieanNXtOY/43NjoqJEdlE584yzbVNWeUUuDLoqouC9XCJO/sESu9LfHWusdgc8Vl3m
	8OGmwdH3Fl5Z10/rVB9SOHj4w+vOqs6nulqt3/bMKVFiKc5INNRiLipOBACOjksUTwMAAA==
X-CMS-MailID: 20241030050522epcas5p317df8853e25adec42e977ab172bb140a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241029163225epcas5p24ec51c7a9b6b115757ed99cadcc3690c
References: <20241029162402.21400-1-anuj20.g@samsung.com>
	<CGME20241029163225epcas5p24ec51c7a9b6b115757ed99cadcc3690c@epcas5p2.samsung.com>
	<20241029162402.21400-7-anuj20.g@samsung.com>
	<ZyFuxfiRqH8YB-46@kbusch-mbp.dhcp.thefacebook.com>

On 10/30/2024 4:54 AM, Keith Busch wrote:
> On Tue, Oct 29, 2024 at 09:53:58PM +0530, Anuj Gupta wrote:
>> This patch adds the capability of sending metadata along with read/write.
>> A new meta_type field is introduced in SQE which indicates the type of
>> metadata being passed. This meta is represented by a newly introduced
>> 'struct io_uring_meta_pi' which specifies information such as flags,buffer
>> length,seed and apptag. Application sets up a SQE128 ring, prepares
>> io_uring_meta_pi within the second SQE.
>> The patch processes the user-passed information to prepare uio_meta
>> descriptor and passes it down using kiocb->private.
>>
>> Meta exchange is supported only for direct IO.
>> Also vectored read/write operations with meta are not supported
>> currently.
> 
> It looks like it is reasonable to add support for fixed buffers too.
> There would be implications for subsequent patches, mostly patch 10, but
> it looks like we can do that.

Fixed buffers for data continues to be supported with this.
Do you mean fixed buffers for metadata?
We can take that as an incremental addition outside of this series which 
is already touching various subsystems (io_uring, block, nvme, scsi, fs).

> Anyway, this patch mostly looks okay to me. I don't know about the whole
> "meta_type" thing. My understanding from Pavel was wanting a way to
> chain command specific extra options.

Right. During LSFMM, he mentioned Btrfs needed to send extra stuff with 
read/write.
But in general, this is about seeing metadata as a generic term to 
encode extra information into io_uring SQE.
It may not be very uncommon that people will have the need to send extra 
stuff with read/write and add specific processing for that. And 
SQE->meta_type helps to isolate all such processing from the common case 
when no extra stuff is sent.

if (sqe->meta_type)
{
	if (type1(sqe->meta_type))
		process(type1);
	if (type2(sqe>meta_type))
		process(type1);
}

  For example, userspace metadata
> and write hints, and this doesn't look like it can be extended to do
> that.

It can be. And in past I used that to represent different types of write 
hints.
Just that in the current version, write hints are being sent without any 
type.



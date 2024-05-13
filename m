Return-Path: <io-uring+bounces-1880-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2726D8C3A1C
	for <lists+io-uring@lfdr.de>; Mon, 13 May 2024 04:18:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 407CA1C2091A
	for <lists+io-uring@lfdr.de>; Mon, 13 May 2024 02:18:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4E0519470;
	Mon, 13 May 2024 02:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="esvrLKMz"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC874C9F
	for <io-uring@vger.kernel.org>; Mon, 13 May 2024 02:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715566696; cv=none; b=Wr1lUcxiaRGOZOGrbpcYwbpa789lEizonn//zgE1QTaVhcvFBGH1ZZFwFghTgCKV7VUtN9WPj3hC9JXnuTMxkuvozLz1CKPtNMPRdpm6XeH/RpA/LbFI2kL3AW7RYqj86NaUXdWQBFQiBma2B9JUjc+j/X+0vAknfJe/xuRzzu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715566696; c=relaxed/simple;
	bh=/drXQd8z6AFSrDg2xHIpW7lIS1Fam2xth+9LwfhHHrA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=CcwzyjcXgDSHbm1VkiWSVt09vaUmph07gCPnLyOnp5TN0z3vxvincKYtlG62ITE9KfQDtT6ho/Br62EO3Yo5IFKn7+9QpAJ+4SB/k2Stf5SslaLP6MqOoqZPdVE7Br0t2jH1iAPtC49S9+28iKexsr0z62nTTGf0HllJlIHLz0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=esvrLKMz; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240513021806epoutp03f9156f6d7a67db3b07896892b59722b4~O6s-S90671701017010epoutp03N
	for <io-uring@vger.kernel.org>; Mon, 13 May 2024 02:18:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240513021806epoutp03f9156f6d7a67db3b07896892b59722b4~O6s-S90671701017010epoutp03N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715566686;
	bh=y6694A1tWw8HjrSsxFOCaTqk1Qidm6tZV9cB+Yhd2dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=esvrLKMz3V1qQqo2siDxtdMVUWga+xOLrih0cl4QFV6eyVRC42lis9veLXL6HsiSY
	 X2mBhLZarTgNy1UbcmNTLOJnH0KOZlvRpf4/Eqq0JnicK80WhhNIelTsWza5/S1WXS
	 wFc6SugyGwpoNLWE7im3cIT48QxAdJePq6VzxD+I=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240513021805epcas5p1aa4b3727ec428be9bb397396d791cf74~O6s_3u47G2999829998epcas5p1E;
	Mon, 13 May 2024 02:18:05 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Vd3701c6Qz4x9QF; Mon, 13 May
	2024 02:18:04 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	00.D6.19431.C5871466; Mon, 13 May 2024 11:18:04 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240513020155epcas5p23699782b97749bfcce0511ce5378df3c~O6e2qlYNf2430624306epcas5p2u;
	Mon, 13 May 2024 02:01:55 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240513020155epsmtrp177dd15d511b499dd55f696ec4d539ecc~O6e2pzSl42236422364epsmtrp1T;
	Mon, 13 May 2024 02:01:55 +0000 (GMT)
X-AuditID: b6c32a50-ccbff70000004be7-d5-6641785c8490
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	6C.60.08924.29471466; Mon, 13 May 2024 11:01:54 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240513020154epsmtip228ca7e2c75ea77adb9015cebb6daec00~O6e1yMXxp1091410914epsmtip2b;
	Mon, 13 May 2024 02:01:54 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, cliang01.li@samsung.com, gost.dev@samsung.com,
	io-uring@vger.kernel.org, joshi.k@samsung.com, kundan.kumar@samsung.com,
	peiwei.li@samsung.com
Subject: Re: [PATCH v2 0/4] io_uring/rsrc: coalescing multi-hugepage
 registered buffers
Date: Mon, 13 May 2024 10:01:49 +0800
Message-Id: <20240513020149.492727-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <0fa012c7-427c-4791-95be-7ba72cfe593a@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJJsWRmVeSWpSXmKPExsWy7bCmum5MhWOawZYVnBZzVm1jtFh9t5/N
	4vTfxywWNw/sZLJ413qOxeLo/7dsFr+67zJabP3yldXi2V5Oi7MTPrA6cHnsnHWX3ePy2VKP
	vi2rGD0+b5ILYInKtslITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLx
	CdB1y8wBOkdJoSwxpxQoFJBYXKykb2dTlF9akqqQkV9cYquUWpCSU2BSoFecmFtcmpeul5da
	YmVoYGBkClSYkJ2x//JspoKZnBWnm2ewNTBuZO9i5OSQEDCRWNO9i6WLkYtDSGAPo0Tf3jlQ
	zidGiTdX/jBBON8YJZY2nIRrubX0O1RiL6PEsoWdrBDOL0aJmV+vM4JUsQnoSPxe8YsFxBYR
	EJbY39EKNpdZYC2jxMqJs4A6ODiEBSIl3p3NA6lhEVCVuDflE9gGXgFbiSm/PjFBbJOX2H/w
	LDOIzQkUf9fRwQZRIyhxcuYTsPnMQDXNW2czg8yXEPjKLtGytA+q2UVi5817bBC2sMSr41ug
	XpCSeNnfxg5yg4RAscSydXIQvS2MEu/fzWGEqLGW+HdlDwtIDbOApsT6XfoQYVmJqafWMUHs
	5ZPo/f0EahWvxI55MLaqxIWD26BWSUusnbCVGcL2kDhycwvYeCGBCYwSJ6fpT2BUmIXknVlI
	3pmFsHkBI/MqRqnUguLc9NRk0wJD3bzUcng0J+fnbmIEp1GtgB2Mqzf81TvEyMTBeIhRgoNZ
	SYTXodA+TYg3JbGyKrUoP76oNCe1+BCjKTDAJzJLiSbnAxN5Xkm8oYmlgYmZmZmJpbGZoZI4
	7+vWuSlCAumJJanZqakFqUUwfUwcnFINTNvb7cragtWD5sVvnm4sYF04f+cVFf/djaWm8erd
	a1REF0t0ldRfWBqtmJi5J5i3IOpAUjHvsgjjpmC2qh1X8hfqKFgH1H9/5JL0YPqxhYqL5kus
	UN2efY3xQ0CNwvOnmT9YA+ep7nit+NpN95PFD3mb9c8vTpwZ+CjAmtO7496yBw/db5qrsvdF
	uG+uvB6dN2Pj7OLtCSvZLnivlKs9sZlTrlmzgjvz3HHFeg+hHQ/ifBI38lgcMdv6ZK9B1MQt
	IvNOnuryENPwnLEiMa27+enPNWHqX+uZX70QWbORMbXhkSaL7qH3/mzrPx01ilQ5dury+8Xl
	qxf+DY75L/A8I/FXl9LG5L9X/P/NeMWsr8RSnJFoqMVcVJwIAERH4y8sBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsWy7bCSvO6kEsc0g0WHrS3mrNrGaLH6bj+b
	xem/j1ksbh7YyWTxrvUci8XR/2/ZLH5132W02PrlK6vFs72cFmcnfGB14PLYOesuu8fls6Ue
	fVtWMXp83iQXwBLFZZOSmpNZllqkb5fAlbH/8mymgpmcFaebZ7A1MG5k72Lk5JAQMJG4tfQ7
	UxcjF4eQwG5GiTXXjjBCJKQlOg61QhUJS6z895wdougHo8SHm2/YQBJsAjoSv1f8YgGxRYCK
	9ne0soAUMQtsZZRom3KWGSQhLBAusWfFMyYQm0VAVeLelE9gU3kFbCWm/PrEBLFBXmL/QYh6
	TqD4u44OsAVCAjYSh26eZoaoF5Q4OfMJ2DJmoPrmrbOZJzAKzEKSmoUktYCRaRWjZGpBcW56
	brFhgWFearlecWJucWleul5yfu4mRnCga2nuYNy+6oPeIUYmDsZDjBIczEoivA6F9mlCvCmJ
	lVWpRfnxRaU5qcWHGKU5WJTEecVf9KYICaQnlqRmp6YWpBbBZJk4OKUamLKs1rPP04hfx7yF
	yefV5NPXN3vt+b/skNnjVtV9NYc/6N7cMyP6TuF69Q9b47PlJjTYKi5L2K01Z2PN3+aiJVK7
	Dp9mfKgRmfuSxY27OPCq2bavZu8dZ4qaOreoN/EVadds4zddZ8Bbv8PpkNGEGQfNt/FE8RjO
	l+A77vT//5vPP12PfVp7a3r35o9CAb82G6h0T33XorK+8zzL6cVWM1r2J77nySvYzRT3P3OH
	Z8wR1qn2LN3B0n7S+05qB3p0pn55qWNa3hPxZfOrszu8e89dKa/p3Pd2okX7twpph++fI+O3
	fT5qsaOKfcXZ09qTLq9Sl/ZmV7cOFSo494Dj8J7I8mvRRWsFD5kaWm85OEeJpTgj0VCLuag4
	EQDfo9CD4wIAAA==
X-CMS-MailID: 20240513020155epcas5p23699782b97749bfcce0511ce5378df3c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240513020155epcas5p23699782b97749bfcce0511ce5378df3c
References: <0fa012c7-427c-4791-95be-7ba72cfe593a@kernel.dk>
	<CGME20240513020155epcas5p23699782b97749bfcce0511ce5378df3c@epcas5p2.samsung.com>

On 2024-05-11 16:43 Jens Axboe wrote:
> On 5/10/24 11:52 PM, Chenliang Li wrote:
>> Registered buffers are stored and processed in the form of bvec array,
>> each bvec element typically points to a PAGE_SIZE page but can also work
>> with hugepages. Specifically, a buffer consisting of a hugepage is
>> coalesced to use only one hugepage bvec entry during registration.
>> This coalescing feature helps to save both the space and DMA-mapping time.
>> 
>> However, currently the coalescing feature doesn't work for multi-hugepage
>> buffers. For a buffer with several 2M hugepages, we still split it into
>> thousands of 4K page bvec entries while in fact, we can just use a
>> handful of hugepage bvecs.
>> 
>> This patch series enables coalescing registered buffers with more than
>> one hugepages. It optimizes the DMA-mapping time and saves memory for
>> these kind of buffers.

> This series looks much better. Do you have a stand-alone test case
> for this? We should have that in liburing. Then we can also augment it
> with edge cases to ensure this is all safe and sound.

Thanks! Yes, I have a liburing test case, will send it as a patch in V3.


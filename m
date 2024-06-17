Return-Path: <io-uring+bounces-2234-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10C2190A2D0
	for <lists+io-uring@lfdr.de>; Mon, 17 Jun 2024 05:16:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 998CB2812B0
	for <lists+io-uring@lfdr.de>; Mon, 17 Jun 2024 03:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BCA7525D;
	Mon, 17 Jun 2024 03:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cA3BMNKQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201E3256A
	for <io-uring@vger.kernel.org>; Mon, 17 Jun 2024 03:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718594203; cv=none; b=kxZFpoXmJcVYQPQEIfpZMJiBLjTEOPcaER5NfuaOoP59TuoO2FQXNre3gLcqznYVtxpbpZ1Ck1NLZfEz6WFpTOSylKAiQ02WNPdX6cHPfsyDkkyv8eaRmAuL0w4tcj5kHwJ1+3b1KcagElmUOc3mbs1iVaw9ScbQ9JBifYebDdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718594203; c=relaxed/simple;
	bh=psj0/OpVPny2Ca/lnAkPNQPD1gN5JP1vGro2vVLh2zw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=I6CXkigA8Szh6sTDLjjhHng9oGxpUeyO/su123yhBYZ2qvRZy33FxIptKB/1pmf6tB7iPAPhywcOxUe0J/wRz4vGBlB8RcJZ2gZGLoTC3LlfN3+hd+EIjIPk5UiizW/uYfXs4RVoBWoxRs5C/7GiXWyczptjgrdgFSpLeenubIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=cA3BMNKQ; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240617031631epoutp04386ee9baba5505e0ffb4616caaede82f~ZrE-lemAM1939719397epoutp04w
	for <io-uring@vger.kernel.org>; Mon, 17 Jun 2024 03:16:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240617031631epoutp04386ee9baba5505e0ffb4616caaede82f~ZrE-lemAM1939719397epoutp04w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1718594192;
	bh=bKFcEzQRCKwGUXQTmpho/uKWMkGdiKHg9I8J9VKLIw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cA3BMNKQgFsBzf6tYXOgPDauYFPtAHWVts1i82HtKUSYxeCxYgIYlePpQmQ22UPRI
	 xkOBDt32yFz/FHl4WBBWEThJAkCAfO+TRJGCZyweZ7TgZvvBBpox2S3IYQmNjQs2hX
	 chR/xECxv9WeEbSZkFOuxdhIGr8xjoOi6Gvf+rUs=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240617031631epcas5p1a958a146430b4d0184d06cfea32c621a~ZrE-CCXTn0532505325epcas5p1W;
	Mon, 17 Jun 2024 03:16:31 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4W2ZmF3j5vz4x9Pt; Mon, 17 Jun
	2024 03:16:29 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2E.E5.09989.D8AAF666; Mon, 17 Jun 2024 12:16:29 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240617031611epcas5p26e5c5f65a182af069427b1609f01d1d0~ZrEsjRCcA0580805808epcas5p2E;
	Mon, 17 Jun 2024 03:16:11 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240617031611epsmtrp1d907d520e85d02f336eb41b26e82f663~ZrEsicnho0216202162epsmtrp1R;
	Mon, 17 Jun 2024 03:16:11 +0000 (GMT)
X-AuditID: b6c32a4a-e57f970000002705-17-666faa8d430d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	8C.99.19057.B7AAF666; Mon, 17 Jun 2024 12:16:11 +0900 (KST)
Received: from lcl-Standard-PC-i440FX-PIIX-1996.. (unknown
	[109.105.118.124]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240617031610epsmtip2ec6bc81bd21230edce307ba3ff0e9b0a~ZrErQwmxU1234812348epsmtip2u;
	Mon, 17 Jun 2024 03:16:10 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: asml.silence@gmail.com
Cc: anuj20.g@samsung.com, axboe@kernel.dk, cliang01.li@samsung.com,
	gost.dev@samsung.com, io-uring@vger.kernel.org, joshi.k@samsung.com,
	kundan.kumar@samsung.com, peiwei.li@samsung.com
Subject: Re: [PATCH v2 0/4] io_uring/rsrc: coalescing multi-hugepage
 registered buffers
Date: Mon, 17 Jun 2024 11:16:05 +0800
Message-Id: <20240617031605.2337-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <bc9ae109-090c-4669-9be1-11ed6a6d39aa@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsWy7bCmlm7vqvw0g3UPpS2aJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wAS1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7QTUoKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLS
	vHS9vNQSK0MDAyNToMKE7IzpC2+zF3xhrTj8YQZLA+NDli5GTg4JAROJKa+eMHYxcnEICexm
	lHj39QQ7hPOJUWLDwUuMIFVCAt8YJW7Nzofp+PfwPAtE0V5GiT/PWpggnCYmiVdL/7CBVLEJ
	6Ej8XvELqIqDQ0RASuL3XQ6QGmaBPYwSGxcvYgOJCwtESrw7mwdSziKgKtF2eAbYSbwC1hL7
	27dDnScvsf/gWWYQm1PAVuLTsktQNYISJ2c+AbOZgWqat85mhqj/yy6xdkEWhO0i0X/3FVRc
	WOLV8S3sELaUxMv+NnaQEyQEiiWWrZMDOU1CoIVR4v27OYwQNdYS/67sATufWUBTYv0ufYiw
	rMTUU+uYINbySfT+fsIEEeeV2DEPxlaVuHBwG9QqaYm1E7ZCneAhsXDaJ2i4TWCUOPDgIvME
	RoVZSN6ZheSdWQirFzAyr2KUTC0ozk1PLTYtMMpLLYfHcXJ+7iZGcCrV8trB+PDBB71DjEwc
	jIcYJTiYlUR4nablpQnxpiRWVqUW5ccXleakFh9iNAWG90RmKdHkfGAyzyuJNzSxNDAxMzMz
	sTQ2M1QS533dOjdFSCA9sSQ1OzW1ILUIpo+Jg1OqgWmlkufh9yYObbvS2rNsMxV1vobW2RdM
	fzr16peUs0K3NeeZGIacszvTVxlabxHg6BjvVWgVeeeImM7vvRYxn1X6eSauYM59uvzLjzl+
	10M4FD5y1PFIP9GPNmPkX1p5tixGan04o/BO5Zkai8u1vmWz31yTYH9Ps1XEXnvpkUvzreuc
	LIIkjFuntl481WprsffLnusfFM8pyMXPfL75wrQrbK1mK7yOXPq8Q2kzq6E9v9/WJxy+Ck8F
	E3/+Pa9+9oWhs1OU6Nzn545M/JkuGXzcwTvryoXEbKf+g6rn/B/lqv13vfT5gatG0erTk7QY
	FOUEriaZPL/yuufHmqU/ajovTZOd5RDLxRbw60zkMiWW4oxEQy3mouJEANv3DPIuBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsWy7bCSvG71qvw0g/bdEhZNE/4yW8xZtY3R
	YvXdfjaL038fs1jcPLCTyeJd6zkWi6P/37JZ/Oq+y2ix9ctXVotnezktzk74wOrA7bFz1l12
	j8tnSz36tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoErY/rC2+wFX1grDn+YwdLA+JCli5GTQ0LA
	ROLfw/NANheHkMBuRonVf6azQySkJToOtULZwhIr/z1nhyhqYJJY3nSNGSTBJqAj8XvFL6Bu
	Dg4RASmJ33c5QGqYBY4xSsz4dhdsg7BAuMSeFc+YQGwWAVWJtsMzwOK8AtYS+9u3Q10hL7H/
	4FmwmZwCthKfll0CiwsJ2EhcWbeRFaJeUOLkzCdgcWag+uats5knMArMQpKahSS1gJFpFaNk
	akFxbnpusWGBUV5quV5xYm5xaV66XnJ+7iZGcMBrae1g3LPqg94hRiYOxkOMEhzMSiK8TtPy
	0oR4UxIrq1KL8uOLSnNSiw8xSnOwKInzfnvdmyIkkJ5YkpqdmlqQWgSTZeLglGpgiozlu1e8
	8cr+/V+fJ1oYPtfbHKRtt7yW/dr7qM9tGmlrv33gzpz7ydn3moD74b7T+77v3pZh/k3q2ZqK
	GTtvR8/55PTv7w453a77eX8kKwMWP3k0UURq4a7L9cxJv5a/WnTlfgj3gnl3ub3ucYYVcv9e
	Uq1xsv4L73o5rtsf+u/f/+kSslJ3SlbGsSPXOW1Tt9c/n5jtyKFcnNGu/W9PaLaK0bS7AqGL
	I37aHEjj+varOG9WpqMyh8gmJ7lpDVLH5s7wYJj//96bNxP6tNY91oxb4Hr9sfPqonoBscu3
	3F++e7OlItk70OV48rx7Ha2FIjMb2evtWbabLhBZkMadze6qsTj9/LRIrldy51t2f1diKc5I
	NNRiLipOBAD0KoDw5wIAAA==
X-CMS-MailID: 20240617031611epcas5p26e5c5f65a182af069427b1609f01d1d0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240617031611epcas5p26e5c5f65a182af069427b1609f01d1d0
References: <bc9ae109-090c-4669-9be1-11ed6a6d39aa@gmail.com>
	<CGME20240617031611epcas5p26e5c5f65a182af069427b1609f01d1d0@epcas5p2.samsung.com>

Actually here it does account an entire folio. The j is just
array index.

> It seems like you can just call io_buffer_account_pin()
> instead.
>
> On that note, you shouldn't duplicate code in either case,
> just treat the normal discontig pages case as folios of
> shift=PAGE_SHIFT.
>
> Either just plain reuse or adjust io_buffer_account_pin()
> instead of io_coalesced_buffer_account_pin().
> io_coalesced_imu_alloc() should also go away.
>
> io_sqe_buffer_register() {
> 	struct io_imu_folio_data data;
>
>	if (!io_sqe_buffer_try_coalesce(pages, folio_data)) {
>		folio_data.shift = PAGE_SHIFT;
>		...
>	}
>	
>	io_buffer_account_pin(pages, &data);
>	imu->data = uaddr;
>	...
> }

Will remove them.

Thanks,
Chenliang Li


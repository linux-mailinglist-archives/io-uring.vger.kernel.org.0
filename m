Return-Path: <io-uring+bounces-11809-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B8E8AD3A256
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 10:03:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0671330022DE
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 09:03:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD913268690;
	Mon, 19 Jan 2026 09:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="IWVgBaw2"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D9533858A
	for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 09:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768813420; cv=none; b=PwNGSEc2CcLgld9Q4J2DTPXX1OdTuud3J6fANa82+xTHqnrKBc0N9oXRU00wK5KhU/pHMCjrG0Kl7xzNcDoa0cbaeE5hE+bNt7K5xHrwwKDXdskbsorRdh66rWT29VAFDdfUwYdnsqxOT2ZlMD+N3ufFDZuP029Pi/D6U0hQi2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768813420; c=relaxed/simple;
	bh=mJGvWseM262rlN3eukOp7OOpQgsZurnLLDn1c/lZIDg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=tRrdzFg4DNvIWjIP4+HZVFBfdjBGfxR9iQcD5cFCe64krpzDFVUFPb43hqgmSYQY4YHjaYpcZWbrGCTU5HPmpZlDl1CYNytNbyU24tUArLXszWTkgsbvziCxuGYF+oR6SWbJ34YGgdMdYhybcbL4D7+OmHbNiT6D9FhtZ1Z9Aa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=IWVgBaw2; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260119090330epoutp04e25db5ebf74a2726c82ac04a6b607e46~MFmzGyZLw3142531425epoutp04W
	for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 09:03:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260119090330epoutp04e25db5ebf74a2726c82ac04a6b607e46~MFmzGyZLw3142531425epoutp04W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768813410;
	bh=mJGvWseM262rlN3eukOp7OOpQgsZurnLLDn1c/lZIDg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IWVgBaw2RcWToYk9OOGkEqo98DANLu6qNkXw7/xm/Br0OC2CjhItjPIY93dsZS6mF
	 iFHXUYLQO6sQ3K5Ywcw69NDBJUvtp0+G7WPFRr1flDX6GJ5/0V/7HP4NVOnjt/zrRV
	 uwh7FBJn3nuwcja2oOW0vnYnupC5xG4LHqjWFd+o=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260119090329epcas5p2a97c98560cbdeb99c82a0f03072568bc~MFmyolNym0957109571epcas5p2o;
	Mon, 19 Jan 2026 09:03:29 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.94]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dvkyS5zXrz2SSKk; Mon, 19 Jan
	2026 09:03:28 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260119090328epcas5p3457c9dbb7c69f70a3988e5f8f77c51d7~MFmxk9NiR2023120231epcas5p3K;
	Mon, 19 Jan 2026 09:03:28 +0000 (GMT)
Received: from green245.gost (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260119090327epsmtip1abc4f10e32661ef38898a39ff0020345~MFmw--d3m0698306983epsmtip1Z;
	Mon, 19 Jan 2026 09:03:27 +0000 (GMT)
Date: Mon, 19 Jan 2026 14:29:18 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] io_uring/rw: free potentially allocated iovec on cache
 put failure
Message-ID: <20260119085918.5ototxnmakj7qlf7@green245.gost>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <d98a65d5-3881-4029-8c2c-bc2dfb34c18e@kernel.dk>
X-CMS-MailID: 20260119090328epcas5p3457c9dbb7c69f70a3988e5f8f77c51d7
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_10a0f6_"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260119090328epcas5p3457c9dbb7c69f70a3988e5f8f77c51d7
References: <d98a65d5-3881-4029-8c2c-bc2dfb34c18e@kernel.dk>
	<CGME20260119090328epcas5p3457c9dbb7c69f70a3988e5f8f77c51d7@epcas5p3.samsung.com>

------IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_10a0f6_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 18/01/26 08:15PM, Jens Axboe wrote:
>If a read/write request goes through io_req_rw_cleanup() and has an
>allocated iovec attached and fails to put to the rw_cache, then it may
>end up with an unaccounted iovec pointer. Have io_rw_recycle() return
>whether it recycled the request or not, and use that to gauge whether to
>free a potential iovec or not.
>
>Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>

------IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_10a0f6_
Content-Type: text/plain; charset="utf-8"


------IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_10a0f6_--


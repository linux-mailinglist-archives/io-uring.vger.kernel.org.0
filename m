Return-Path: <io-uring+bounces-12048-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sMs7NH5tg2kFmwMAu9opvQ
	(envelope-from <io-uring+bounces-12048-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 04 Feb 2026 17:02:06 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 04D67E9C07
	for <lists+io-uring@lfdr.de>; Wed, 04 Feb 2026 17:02:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8A2E631B47DD
	for <lists+io-uring@lfdr.de>; Wed,  4 Feb 2026 15:30:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A4292D8763;
	Wed,  4 Feb 2026 15:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="i0cYTe7l"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E8F2D5C91
	for <io-uring@vger.kernel.org>; Wed,  4 Feb 2026 15:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219056; cv=none; b=mm8QMzQZmW1a2eCcObXdsZ+x44W8dc10RvGqvFGn0XlEfTRpUAcS6lawH6ctp1mcynaKrCl7dpNB3mQJoEt6OMFKBXprpywN8PzNOwRzLWhthmHncQAFe2njBbJsnCq9tVNTnjpzJcwoMfBB4TzTUlkjErdXc5CTlyhQbm4wkes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219056; c=relaxed/simple;
	bh=a7OAGpPMyyu4loh7iMCRQAaawYutoxtkzlPkls7sOMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=bB2pZFY2iulikIwYreJGpDtxDvvnx5RR9zgJHR7GXHtgHp2gdycNV2IknhCcy64/JgbCEjRiWmbRjXjY0iPqKVsJxbmUQpl85MUEKeU/tB4+HqW8BK2vG9QdQjweodRs4tvbZ1h9A3r0i/mEvtZ8nVyi8FAyd8UHy/j/PeT+VfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=i0cYTe7l; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260204153052epoutp0436b1aa20ff8427616e7d4c0f66cdb746~RFNmC-eZo2518325183epoutp044
	for <io-uring@vger.kernel.org>; Wed,  4 Feb 2026 15:30:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260204153052epoutp0436b1aa20ff8427616e7d4c0f66cdb746~RFNmC-eZo2518325183epoutp044
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1770219053;
	bh=GMZkkwt+ygUc95YJRehpOJ9rDzYC29QaYgbwGeEI8Ug=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=i0cYTe7lQkN7aGv58NQgjHPtUvuHT+JX3mAt19E3Y83yRgGckZc9FfmXCOTcv38ND
	 Me2yK0JIjdDdfHzWZdiDgTZssJudS2tncWvp/JQtVj8RGnJ3e80Hgm1e9eGk5fT6Hj
	 W8vHYvibHO7mYSbxNp8l7/podEfvyPtyuEjRM1Bs=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260204153052epcas5p2a5dd889761fbbe0da0188d4f55423645~RFNlpYRUi0658106581epcas5p23;
	Wed,  4 Feb 2026 15:30:52 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.95]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4f5kp34KGfz2SSKX; Wed,  4 Feb
	2026 15:30:51 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260204153051epcas5p1c2efd01ef32883680fed2541f9fca6c2~RFNkOnJ8g2260322603epcas5p16;
	Wed,  4 Feb 2026 15:30:51 +0000 (GMT)
Received: from green245.gost (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260204153049epsmtip22ed4d2525789b012deef6b6b5c76c314~RFNii_-zk3140331403epsmtip2K;
	Wed,  4 Feb 2026 15:30:48 +0000 (GMT)
Date: Wed, 4 Feb 2026 20:56:34 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, io-uring <io-uring@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Christian
	=?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, Christoph Hellwig
	<hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta
	<anuj20.g@samsung.com>, "lsf-pc@lists.linux-foundation.org"
	<lsf-pc@lists.linux-foundation.org>
Subject: Re: [LSF/MM/BPF TOPIC] dmabuf backed read/write
Message-ID: <20260204152634.gyybb2axszwpewrk@green245.gost>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmail.com>
X-CMS-MailID: 20260204153051epcas5p1c2efd01ef32883680fed2541f9fca6c2
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----dZkOkAIazzHoUX-2rQXwJ8woeHD-_lbejx.E5KOGiu3cq0eS=_150a72_"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260204153051epcas5p1c2efd01ef32883680fed2541f9fca6c2
References: <4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmail.com>
	<CGME20260204153051epcas5p1c2efd01ef32883680fed2541f9fca6c2@epcas5p1.samsung.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	CTYPE_MIXED_BOGUS(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[samsung.com,none];
	R_DKIM_ALLOW(-0.20)[samsung.com:s=mail20170921];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,green245.gost:mid,samsung.com:dkim];
	TAGGED_FROM(0.00)[bounces-12048-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RSPAMD_URIBL_FAIL(0.00)[samsung.com:query timed out];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+,1:+,2:+];
	DKIM_TRACE(0.00)[samsung.com:+];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nj.shetty@samsung.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 04D67E9C07
X-Rspamd-Action: no action

------dZkOkAIazzHoUX-2rQXwJ8woeHD-_lbejx.E5KOGiu3cq0eS=_150a72_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On 03/02/26 02:29PM, Pavel Begunkov wrote:
>Good day everyone,
>
>dma-buf is a powerful abstraction for managing buffers and DMA mappings,
>and there is growing interest in extending it to the read/write path to
>enable device-to-device transfers without bouncing data through system
>memory. I was encouraged to submit it to LSF/MM/BPF as that might be
>useful to mull over details and what capabilities and features people
>may need.
>
>The proposal consists of two parts. The first is a small in-kernel
>framework that allows a dma-buf to be registered against a given file
>and returns an object representing a DMA mapping. The actual mapping
>creation is delegated to the target subsystem (e.g. NVMe). This
>abstraction centralises request accounting, mapping management, dynamic
>recreation, etc. The resulting mapping object is passed through the I/O
>stack via a new iov_iter type.
>
>As for the user API, a dma-buf is installed as an io_uring registered
>buffer for a specific file. Once registered, the buffer can be used by
>read / write io_uring requests as normal. io_uring will enforce that the
>buffer is only used with "compatible files", which is for now restricted
>to the target registration file, but will be expanded in the future.
>Notably, io_uring is a consumer of the framework rather than a
>dependency, and the infrastructure can be reused.
>
We have been following the series, its interesting from couple of angles,
- IOPS wise we see a major improvement especially for IOMMU
- Series provides a way to do p2pdma to accelerator memory

Here are few topics which I am looking into specifically,
- Right now the series uses a PRP list. We need a good way to keep the
   sg_table info around and decide on‑the‑fly whether to expose the buffer
   as a PRP list or an SG list, depending on the I/O size.
- Possibility of futher optimization for new type of iov iter to reduce
   per IO cost

Thanks,
Nitesh

------dZkOkAIazzHoUX-2rQXwJ8woeHD-_lbejx.E5KOGiu3cq0eS=_150a72_
Content-Type: text/plain; charset="utf-8"


------dZkOkAIazzHoUX-2rQXwJ8woeHD-_lbejx.E5KOGiu3cq0eS=_150a72_--


Return-Path: <io-uring+bounces-12093-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2NpwCVCyiWndAgUAu9opvQ
	(envelope-from <io-uring+bounces-12093-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 11:09:20 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E08F10DFDC
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 11:09:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AC2E1300576B
	for <lists+io-uring@lfdr.de>; Mon,  9 Feb 2026 10:04:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F14A3644AB;
	Mon,  9 Feb 2026 10:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="M0PU4SJA"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF70D344037
	for <io-uring@vger.kernel.org>; Mon,  9 Feb 2026 10:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770631494; cv=none; b=DT6XDacD44FqGeHBMmp+IMfSWrKHN6IpOpg2Ggl9rGMUpCnZD+O2dgviaqpf/KeRz8sy+DHIW+FeTnUi9i4WZ3+knMo3D0azDpfdQu10T1W2RFiKpAzbZzzeGIqa8D2KVxJoahqFPdi++OmMQj8dBOQ2qyyPbdLmuvBg4oOPM+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770631494; c=relaxed/simple;
	bh=cFiRXRE0SoHVqgNVMPo+ew/Ov1wphdgz+R6dS43ENoY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=DZYb14Zi0xY+TE3PUtdGSDyQpHN8YWbMsubcgDtwOLapwUMC/SSpPElReyJjAIexqv7jTw5mpJpTAbrl8amG+EynKb74SIG0/Glt3QqDRX7r8xNPaHXDCS7GCgt+myN87LDI9/DRb5wKUZt5ZGqScC0VC4M29AFVwepCq3Z2S14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=M0PU4SJA; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260209100451epoutp0238943c4866a2858505224ef72a81751b~Si-XXAIFG0885708857epoutp02h
	for <io-uring@vger.kernel.org>; Mon,  9 Feb 2026 10:04:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260209100451epoutp0238943c4866a2858505224ef72a81751b~Si-XXAIFG0885708857epoutp02h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1770631491;
	bh=wt+xzp1ENYsfh++JT8pJEqjJy6IREEFFHEG8QaQpp2M=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=M0PU4SJAclY0eXdEEkxL7W3l4RdvfkAlxlzdKax8lupZZA9Cl/jrx3j6ZOZP25yX+
	 aEpRs8klxsOfPDog79GlTXng/MXN3vmtQU1Iyp+6hldb0cK5uuJbrbTaNyAdn1TzPn
	 R54qbHwrhOful2d1/CJ51zzsOdS1N40jgdgoaZGY=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260209100451epcas5p10e8d99b66259e22b08fab2a6a4df98a8~Si-W6nlVY0968409684epcas5p1Q;
	Mon,  9 Feb 2026 10:04:51 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.91]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4f8gKY6xgMz6B9mB; Mon,  9 Feb
	2026 10:04:49 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260209100448epcas5p11e31b66680677cd4399fd0efca35e6fe~Si-UuYSWS0968909689epcas5p1N;
	Mon,  9 Feb 2026 10:04:48 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260209100444epsmtip2e68e1b03792622abf5a5c487565e1186~Si-Q3OchA2836828368epsmtip2M;
	Mon,  9 Feb 2026 10:04:44 +0000 (GMT)
Message-ID: <0ddc5a14-26c3-4912-96a0-d619ca0fb36c@samsung.com>
Date: Mon, 9 Feb 2026 15:34:43 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] dmabuf backed read/write
To: Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org
Cc: io-uring <io-uring@vger.kernel.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, =?UTF-8?Q?Christian_K=C3=B6nig?=
	<christian.koenig@amd.com>, Christoph Hellwig <hch@lst.de>, Anuj Gupta
	<anuj20.g@samsung.com>, Nitesh Shetty <nj.shetty@samsung.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmail.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260209100448epcas5p11e31b66680677cd4399fd0efca35e6fe
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260203143112epcas5p4eea9225d9378dad9151e1b843c0522ce
References: <CGME20260203143112epcas5p4eea9225d9378dad9151e1b843c0522ce@epcas5p4.samsung.com>
	<4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[samsung.com,none];
	R_DKIM_ALLOW(-0.20)[samsung.com:s=mail20170921];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12093-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[samsung.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[samsung.com:mid,samsung.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joshi.k@samsung.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.986];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 9E08F10DFDC
X-Rspamd-Action: no action

On 2/3/2026 7:59 PM, Pavel Begunkov wrote:
> Good day everyone,
> 
> dma-buf is a powerful abstraction for managing buffers and DMA mappings,
> and there is growing interest in extending it to the read/write path to
> enable device-to-device transfers without bouncing data through system
> memory. I was encouraged to submit it to LSF/MM/BPF as that might be
> useful to mull over details and what capabilities and features people
> may need.

Guilty as charged, I'm interested in the topic. Thanks for posting.
We've had several attempts to move the DMA mapping cost out of the fast 
path; hopefully, this will be the final one.




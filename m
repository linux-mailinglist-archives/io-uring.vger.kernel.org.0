Return-Path: <io-uring+bounces-12331-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QPrFIqQRl2n7uAIAu9opvQ
	(envelope-from <io-uring+bounces-12331-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 14:35:32 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E934E15F1F6
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 14:35:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 50C933027688
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 13:35:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 726C633342E;
	Thu, 19 Feb 2026 13:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="GB1KBsC8"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0352F616B
	for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 13:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771508114; cv=none; b=DtV8mk84w7X3iYHK63fveqE4640yJ5IfaGNMbm+fIZXz/5witsvJ+E386UGzTmiqDcuh+q/a2f9BZJi1GeM3GkvhMpiqAyxYZupQdjKhjySg7Dn/mDRBDcCFe5RhByGDz+x9vFqJzQoE4lDLkUrxi3SsopWmugGaQjcYQ0HQk/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771508114; c=relaxed/simple;
	bh=e37iYSYs5pS2o9wcY8FYX2BOuDF8F3Sb3zzxWuGrkoE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=udev5qNF2JmMCkk+gTFwmmEU4vmFK8dUGkVS8wiE0XjaFWip7210EefdtvWrG2o3cvsZRiMgPdR0EgKJUbsUwrGQ/u6ZpNxdm9UsCyvZiArDboO0/koSFa3sgEKQBQHM9cFEU9LB/2u1Sc5oi7yif1vYl4cyJpgZEGxHHclbJG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=GB1KBsC8; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260219133510epoutp02218060fbf7cde9e2988ceebf2b53504c~VqT2l8xOR2976029760epoutp02X
	for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 13:35:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260219133510epoutp02218060fbf7cde9e2988ceebf2b53504c~VqT2l8xOR2976029760epoutp02X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1771508110;
	bh=yFzfTZqpnssLrPgESFaP/bRi4XPIp0E3vHNgL7BJejk=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=GB1KBsC899iLi6U5sRTuxs5q6+4y1SB7H5GWWAAmRntyLUYr1fNFcWZIFR4Ff1DMU
	 c2RvJf7NXZroEdINafV6Ept/xCddln5N59jZ5TWZgvdZQ5ZA+6qNiEXbpH4xsi8SP2
	 bPI+e7fu8aOpwXlIhpRE6zX7JQvGGXQu3sIOx4Sg=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260219133510epcas5p1ef0a16fc97e6a2512af52e2011bb7f07~VqT2aUKKl0131701317epcas5p1n;
	Thu, 19 Feb 2026 13:35:10 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.87]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4fGvWd5d9cz6B9m4; Thu, 19 Feb
	2026 13:35:09 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260219133509epcas5p30126d7c0435ec5fd8cc4e722942db7b3~VqT1H4S873141331413epcas5p3k;
	Thu, 19 Feb 2026 13:35:09 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260219133508epsmtip254883610657c2634035e9441244ed2be~VqT0XRvHt1028610286epsmtip2R;
	Thu, 19 Feb 2026 13:35:08 +0000 (GMT)
Message-ID: <10f41965-4dc7-4a84-b164-4a4655ed8459@samsung.com>
Date: Thu, 19 Feb 2026 19:05:07 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: add IORING_OP_URING_CMD128 to opcode checks
To: Caleb Sander Mateos <csander@purestorage.com>, Jens Axboe
	<axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260219013534.4140776-1-csander@purestorage.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260219133509epcas5p30126d7c0435ec5fd8cc4e722942db7b3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260219013614epcas5p32f6ea6efe36e9df4d2bb0760f55dce03
References: <CGME20260219013614epcas5p32f6ea6efe36e9df4d2bb0760f55dce03@epcas5p3.samsung.com>
	<20260219013534.4140776-1-csander@purestorage.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[samsung.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[samsung.com:s=mail20170921];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-12331-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[samsung.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,samsung.com:mid,samsung.com:dkim,samsung.com:email,purestorage.com:email];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joshi.k@samsung.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: E934E15F1F6
X-Rspamd-Action: no action

On 2/19/2026 7:05 AM, Caleb Sander Mateos wrote:
> io_should_commit(), io_uring_classic_poll(), and io_do_iopoll() compare
> struct io_kiocb's opcode against IORING_OP_URING_CMD to implement
> special treatment for uring_cmds. The recently added opcode
> IORING_OP_URING_CMD128 is meant to be equivalent to IORING_OP_URING_CMD,
> so treat it the same way in these functions.
> 
> Fixes: 1cba30bf9fdd ("io_uring: add support for IORING_SETUP_SQE_MIXED")
> Signed-off-by: Caleb Sander Mateos<csander@purestorage.com>

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>


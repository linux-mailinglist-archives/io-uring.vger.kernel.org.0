Return-Path: <io-uring+bounces-12330-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uIfrBhQRl2n7uAIAu9opvQ
	(envelope-from <io-uring+bounces-12330-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 14:33:08 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B5B315F1AE
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 14:33:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EF2E13006466
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 13:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F65228DC4;
	Thu, 19 Feb 2026 13:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="sNUNizLM"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE93E2FD1B1
	for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 13:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771507986; cv=none; b=jJm402O+PF7ydUXhSG+zXOE4LlryUPKDlozn4hQL1gBbbpE4sub/+tOZxkEjyfKJNyDppzMN7MgNZ/KlJyyRi8Wtzg4oEF9Q8HAJ+mJJs1ka1VhUoGbV0dant9gXeFm0UxgP+g8vpKtB8HBpNYZdR/3rg/C0jq2Vd7CTdRzg6EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771507986; c=relaxed/simple;
	bh=7wnGFOuCeaXlwEIiAvXhj/L0sba+VgW54Lzx815bI94=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=Qj5G4gSjMLzkbkr+M7jAumlp/2vkCO7hNVt1sxwSb3g4SSqxlDWXsyoR25pJa3bcwO5awjGPYekWS+J0aMINmw8qVPl9WiEFbIvVFC4JeacFSrkqLEybCGBk0wLveKkwksie/of5j6k5zYS+2nwB99xfJx/7q0Hx45IbJLFampg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=sNUNizLM; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260219133257epoutp026d5bb301e69ef102fc926fa4d8fde495~VqR6RW6Ox2812928129epoutp02T
	for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 13:32:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260219133257epoutp026d5bb301e69ef102fc926fa4d8fde495~VqR6RW6Ox2812928129epoutp02T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1771507977;
	bh=g4FnRIC5WeDzGlXdmzs7E4irc3aipRCj31DibKI6oSo=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=sNUNizLMQLfTkCw6xXqZXOAv8MJitcKX2mH3b56UhUlG51iKUqh7xljhde8v9n7Fq
	 08inR7CwVvtJDRczZVmxYbqJssLUTBJHQdGNTBORSBU9pNKWz8nea3YDZbTxLvAr/t
	 m2y2Hz1tbRrCnSmrZ72Q/NK9SfxK52Xt8wLVpNlI=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260219133256epcas5p47b66efb0335a3ee34a4ce3bb649b21da~VqR6ELAj-0045800458epcas5p4Y;
	Thu, 19 Feb 2026 13:32:56 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.94]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4fGvT41zDfz3hhT4; Thu, 19 Feb
	2026 13:32:56 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260219133255epcas5p465cfee238f7baab86443deb369933c5a~VqR5Eo8UI2965429654epcas5p4l;
	Thu, 19 Feb 2026 13:32:55 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260219133255epsmtip2ac823c66bd860dffe1e69fac175a344f~VqR4ck3Dr0866008660epsmtip2R;
	Thu, 19 Feb 2026 13:32:55 +0000 (GMT)
Message-ID: <64ad9aa3-68be-4c82-97dc-317c350e0d6d@samsung.com>
Date: Thu, 19 Feb 2026 19:02:54 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rw: handle IORING_OP_URING_CMD128 in iopoll
 dispatch
To: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, kbusch@kernel.org
Cc: io-uring@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260219123136.155590-1-anuj20.g@samsung.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260219133255epcas5p465cfee238f7baab86443deb369933c5a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260219123601epcas5p3102acea27f92bc92a8e482c18e74103f
References: <CGME20260219123601epcas5p3102acea27f92bc92a8e482c18e74103f@epcas5p3.samsung.com>
	<20260219123136.155590-1-anuj20.g@samsung.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[samsung.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[samsung.com:s=mail20170921];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[samsung.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12330-lists,io-uring=lfdr.de];
	RCPT_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,samsung.com:mid,samsung.com:dkim];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joshi.k@samsung.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 9B5B315F1AE
X-Rspamd-Action: no action

On 2/19/2026 6:01 PM, Anuj Gupta wrote:
> io_uring_classic_poll() special-cases only IORING_OP_URING_CMD for
> uring-cmd iopoll dispatch. IORING_OP_URING_CMD128 falls into the generic
> rw branch, which calls file->f_op->iopoll() after casting to struct io_rw.
> 
> That is the wrong callback path for uring_cmd requests, which should go
> through ->uring_cmd_iopoll(). Treat IORING_OP_URING_CMD128 the same as
> IORING_OP_URING_CMD in io_uring_classic_poll().
> 
> Fixes: 1cba30bf9fdd ("io_uring: add support for IORING_SETUP_SQE_MIXED")

Just noticed that Caleb had sent a patch that handles this more completely:

https://lore.kernel.org/io-uring/20260219013534.4140776-1-csander@purestorage.com/


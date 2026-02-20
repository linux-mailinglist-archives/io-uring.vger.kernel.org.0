Return-Path: <io-uring+bounces-12347-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +HdZMRVgmGnzHAMAu9opvQ
	(envelope-from <io-uring+bounces-12347-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 14:22:29 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D978167C73
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 14:22:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 84EA230063A4
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 13:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 206BC344030;
	Fri, 20 Feb 2026 13:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="S4UGP2sg"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72833451B2
	for <io-uring@vger.kernel.org>; Fri, 20 Feb 2026 13:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771593691; cv=none; b=ZVkTnYJA67wtCVNGxjKZBU0q8kyAZ3ybx2BS1UrTuJUPUbkXEspJ96i1K9WXSqxhcln+Axc5M2IThtFlpZha4Lu8HyKuc31DeYTPHzfL+EKcx6aphKH3Hn7BSrpwAu3nIi7aZrO/Bwpp/67LMaVtJ+2EEFkrQJPIoARNBSSPyO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771593691; c=relaxed/simple;
	bh=0UGOylGcMnPKCajPRzJ8KFfA+79mmuQAUQy7q/I6/FQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=gPBSoAwuu8pt3b1fwx8qjhtDLhJ/xMPXhirU06xzEWB8I8pWejQFShd4MdvCepaSTK5ODbHr6amDq7Z4T84POUPRen9xSZPxQkCRCc7iRX1nEFmMgKcDjMyI/Io2+E+oKvdxV6aXS4xAdN3T/9JKzq0OVZZy4WXpKXvQOweK3oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=S4UGP2sg; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260220132126epoutp01b9477fa5bb2391f4c9646aea1839abeb~V9xJQDnJj3010130101epoutp01h
	for <io-uring@vger.kernel.org>; Fri, 20 Feb 2026 13:21:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260220132126epoutp01b9477fa5bb2391f4c9646aea1839abeb~V9xJQDnJj3010130101epoutp01h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1771593686;
	bh=0UGOylGcMnPKCajPRzJ8KFfA+79mmuQAUQy7q/I6/FQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=S4UGP2sgJtrD9hEMqTwgoPh88yMKGsOiYk9N3Ldpf1EJa97uS02il5P8KjTYTn+fb
	 d/HmFngSoM8mAhRkh1IqbgUllqln/CIBmP8UvTjvVLYRK881o3jlYGZXaffubar5PR
	 MCz5+NMbvMfiAXlvOSVdqIYkYuJhbx63BrPtg3tE=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260220132125epcas5p18c2f046278f19d41be83b6718f1aa212~V9xIyDkXi2080620806epcas5p1K;
	Fri, 20 Feb 2026 13:21:25 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.89]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4fHW9J6ybpz2SSKY; Fri, 20 Feb
	2026 13:21:24 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260220132124epcas5p3a1a05b9b45023c74d86328beedd0d392~V9xG_P7n_1563515635epcas5p3z;
	Fri, 20 Feb 2026 13:21:24 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260220132120epsmtip2aa721d290d0c97502e090300ae4740f7~V9xD9WO-K2307523075epsmtip2G;
	Fri, 20 Feb 2026 13:21:20 +0000 (GMT)
Message-ID: <85300692-ebff-4fc0-a891-07405c554530@samsung.com>
Date: Fri, 20 Feb 2026 18:51:19 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/4] io_uring/uring_cmd: allow non-iopoll cmds with
 IORING_SETUP_IOPOLL
To: Caleb Sander Mateos <csander@purestorage.com>, Jens Axboe
	<axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Keith Busch
	<kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org, Anuj gupta <anuj1072538@gmail.com>
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260219172228.429479-1-csander@purestorage.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260220132124epcas5p3a1a05b9b45023c74d86328beedd0d392
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260219172309epcas5p2bd985f806bafcd2b919963ef689dc9a1
References: <CGME20260219172309epcas5p2bd985f806bafcd2b919963ef689dc9a1@epcas5p2.samsung.com>
	<20260219172228.429479-1-csander@purestorage.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[samsung.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[samsung.com:s=mail20170921];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[samsung.com:+];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.infradead.org,gmail.com];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12347-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joshi.k@samsung.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 3D978167C73
X-Rspamd-Action: no action

Series looked good to me.

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>


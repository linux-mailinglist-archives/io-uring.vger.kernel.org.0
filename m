Return-Path: <io-uring+bounces-12329-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IBdrCJgQl2n7uAIAu9opvQ
	(envelope-from <io-uring+bounces-12329-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 14:31:04 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7615615F165
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 14:31:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6C405304AC30
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 13:30:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 544186A33B;
	Thu, 19 Feb 2026 13:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="o3SYBzRt"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF924450FE
	for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 13:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771507820; cv=none; b=TzjGdo5qxezzTusALStXBmfKlAAzNoEGs6pwfDPlSzUeHl0w0LjT/1jhy95kIYlLxGN6dEZZuYB7vUr/JXaCRT4FMW242VLlPl8gNOzyw1ABKKz963GNkipf9WD/hbgs9tvLr03q7Qs7vSLmStUWbUyuIENNmW6nIhlInr/CYRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771507820; c=relaxed/simple;
	bh=kBzR8Xe9fCWA83ZJdT/IbWb9FS2ULFtios8FEnJzZCY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=OkKyWU8/Zdpoz4fMrYzh7NdMTibS7UyD9Ukn/lcn71wRlr6Ncp68B1HQbOQ9ktOUw95FC/RZW+db6dJQuq4ayj4Fz/9XVA8+nXBYaEdJCFj07IBwA0IcoYFcM/0RrVLMhi6UxzO2a0w+7WHFAV5Ww+dqZDzRrw4cAvYThLDbYqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=o3SYBzRt; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260219133010epoutp01637e1cba499ddf4520ce7a33c9b055d8~VqPfDd8aA2514525145epoutp019
	for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 13:30:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260219133010epoutp01637e1cba499ddf4520ce7a33c9b055d8~VqPfDd8aA2514525145epoutp019
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1771507810;
	bh=mFh8ufN01XGazkRR2X1ifQgkFck0S1wSjFmaIuMhx6s=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=o3SYBzRt+Vmvu8Ikj1qRIVNpwAJrkpKw56fC5mF1WNKzzomJERkImDaCY5Qpjcaus
	 Fxbw7clgNInx+uHIh343+fE0ncf1z38JnB2a3mauOfEHbiAwwg+AvT6RMxqCW+y4/k
	 5AKHSRSkguyr6HDntZ5mqykiKVsnlRCdnf0razbc=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260219133010epcas5p2dc75cae4531132e5393a5106150c088d~VqPesrGvx1122111221epcas5p2g;
	Thu, 19 Feb 2026 13:30:10 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.95]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4fGvPs0gN8z6B9m7; Thu, 19 Feb
	2026 13:30:09 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260219133008epcas5p3d668d010d6e2935eb7cdd022bf36a504~VqPdWVILj1696416964epcas5p3X;
	Thu, 19 Feb 2026 13:30:08 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260219133007epsmtip14753df7f26f6b26a50119176442cf511~VqPcP0d0C3175931759epsmtip1h;
	Thu, 19 Feb 2026 13:30:07 +0000 (GMT)
Message-ID: <bbe35147-af86-4066-8732-c0d786c83df5@samsung.com>
Date: Thu, 19 Feb 2026 19:00:06 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] io_uring/uring_cmd: allow non-iopoll cmds with
 IORING_SETUP_IOPOLL
To: Caleb Sander Mateos <csander@purestorage.com>, Jens Axboe
	<axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Keith Busch
	<kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260219014335.9061-1-csander@purestorage.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260219133008epcas5p3d668d010d6e2935eb7cdd022bf36a504
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260219014357epcas5p31a24ed7f17ebfe2d15f850c2a4114ebe
References: <CGME20260219014357epcas5p31a24ed7f17ebfe2d15f850c2a4114ebe@epcas5p3.samsung.com>
	<20260219014335.9061-1-csander@purestorage.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[samsung.com,none];
	R_DKIM_ALLOW(-0.20)[samsung.com:s=mail20170921];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[samsung.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,samsung.com:mid,samsung.com:dkim];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12329-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FROM_NEQ_ENVFROM(0.00)[joshi.k@samsung.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 7615615F165
X-Rspamd-Action: no action

On 2/19/2026 7:13 AM, Caleb Sander Mateos wrote:
> Currently, creating an io_uring with IORING_SETUP_IOPOLL requires all
> requests issued to it to support iopoll. This prevents, for example,
> using ublk zero-copy together with IORING_SETUP_IOPOLL, as ublk
> zero-copy buffer registrations are performed using a uring_cmd. There's
> no technical reason why these non-iopoll uring_cmds can't be supported.
> They will either complete synchronously or via an external mechanism
> that calls io_uring_cmd_done(), so they don't need to be polled.
> 
> Allow uring_cmd requests to be issued to IORING_SETUP_IOPOLL io_urings
> even if their files don't implement ->uring_cmd_iopoll().

For a moment I felt that series is going to change the user-facing 
behavior of IORING_SETUP_IOPOLL and therefore might require a 
documentation update [1].
But the change is limited to uring-cmd and that too for the files that 
don't implement ->uring_cmd_iopoll().


[1] The man page for IORING_SETUP_IOPOLL: "it is illegal to mix and 
match polled and non-polled I/O on an io_uring".


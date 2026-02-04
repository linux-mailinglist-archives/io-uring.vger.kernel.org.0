Return-Path: <io-uring+bounces-12045-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8AmbC3rigmlbeAMAu9opvQ
	(envelope-from <io-uring+bounces-12045-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 04 Feb 2026 07:08:58 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C1C9DE2321
	for <lists+io-uring@lfdr.de>; Wed, 04 Feb 2026 07:08:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1434F301CCF5
	for <lists+io-uring@lfdr.de>; Wed,  4 Feb 2026 06:07:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9806C37107B;
	Wed,  4 Feb 2026 06:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NhzBjLSH"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81159371075
	for <io-uring@vger.kernel.org>; Wed,  4 Feb 2026 06:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770185256; cv=none; b=uXgdETzvBSELtBznLs+MZQ0t7Lhhk7blx5nxBqu0y+YHL/mIdqW9TDYySVuabi3iUeyQcZt06KKsXvf3o1BojKZVB8CFYz0Xg8sJv3jEWh0rfxKycb+a7atvqwT03Boo1EGOeA8zyr6fpTXW4Qsi8l33U5O8VXHsGYk+sSCvA3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770185256; c=relaxed/simple;
	bh=vFeASoXmH/a8+nINHgGsmh6ICV7WwiJIChiSbgDwE7s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=ATkzQpdUoXqqpeneraggPP37Z4zH7l08N+vTbiwpOO+qGsTnLzLy/TgKXGWl9wEBPZVxJDRU4W+UEcWK017IfilyL6/zwII5o0TZCjjt8uHjMTUupR0W0v2aJ3xEXABBgEaU77SnLTwQI/TD2abwgq46Nl2jFPRwPDqU7pEc3VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=NhzBjLSH; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260204060727epoutp04e9618116949734219eac3e9f18945bb1~Q9hqnTUpa0200002000epoutp04E
	for <io-uring@vger.kernel.org>; Wed,  4 Feb 2026 06:07:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260204060727epoutp04e9618116949734219eac3e9f18945bb1~Q9hqnTUpa0200002000epoutp04E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1770185247;
	bh=y2frTBlrPcApGJAKcojyrODxcLgxJHU1QEnp9KWJoZE=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=NhzBjLSHtZQSQfwpotD0ry+Zimlaaw5fqm639OJbdbhO5fR5z5AnqlhFlOCe902o8
	 frZCx7w8qfrbc9ahl5e4C1eLYZNUptEigCQ8ZEOyCMxJPQOOiJ1ezeBjZ7cSv9MUPd
	 pWrdY+SkrHWCbDZFh9P9kvzipTxVl2Dyw8JReVZ8=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260204060727epcas5p232ff332ff546f37733e37b0c13d6cada~Q9hqaEc0W0625406254epcas5p2u;
	Wed,  4 Feb 2026 06:07:27 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.94]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4f5VHy44lQz2SSKd; Wed,  4 Feb
	2026 06:07:26 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260204060726epcas5p3816adfde071ae343471ac7a6a33a0e82~Q9ho7YiaV1775217752epcas5p3N;
	Wed,  4 Feb 2026 06:07:26 +0000 (GMT)
Received: from [107.122.10.194] (unknown [107.122.10.194]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260204060722epsmtip24e8143a262629db8288b2256b0e51ace~Q9hlWsA3n1083210832epsmtip2D;
	Wed,  4 Feb 2026 06:07:22 +0000 (GMT)
Message-ID: <beb2ebf6-8207-4bbe-a77c-ccb09e2d841e@samsung.com>
Date: Wed, 4 Feb 2026 11:37:20 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] dmabuf backed read/write
To: Keith Busch <kbusch@kernel.org>, Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, io-uring <io-uring@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, Christoph
	Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>, Nitesh Shetty
	<nj.shetty@samsung.com>, "lsf-pc@lists.linux-foundation.org"
	<lsf-pc@lists.linux-foundation.org>
Content-Language: en-US
From: Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>
In-Reply-To: <aYI5S1puAZ-rPvlC@kbusch-mbp>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260204060726epcas5p3816adfde071ae343471ac7a6a33a0e82
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260203180716epcas5p1c9658e583e26197b515f6db07a100aa9
References: <4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmail.com>
	<CGME20260203180716epcas5p1c9658e583e26197b515f6db07a100aa9@epcas5p1.samsung.com>
	<aYI5S1puAZ-rPvlC@kbusch-mbp>
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
	TAGGED_FROM(0.00)[bounces-12045-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[kernel.org,gmail.com];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[samsung.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,samsung.com:mid,samsung.com:dkim];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anuj20.g@samsung.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: C1C9DE2321
X-Rspamd-Action: no action

On 2/3/2026 11:37 PM, Keith Busch wrote:
> Thanks for submitting the topic. The performance wins look great, but
> I'm a little surpised passthrough didn't show any difference. We're
> still skipping a bit of transformations with the dmabuf compared to not
> having it, so maybe it's just a matter of crafting the right benchmark
> to show the benefit.
> 

Those numbers were from a drive that saturates at ~5M IOPS, 
sopassthrough didn’t have much headroom. I did a quick run with two such
drives and saw a small improvement (~2–3%): ~5.97 MIOPS -> ~6.13 MIOPS,
but I’ll try tweaking the kernel config a bit to see if there’s more
headroom.

+1 on the topic - I'm interested in attending the discussion and
reviewing/testing v3 when it lands.

Thanks,
Anuj


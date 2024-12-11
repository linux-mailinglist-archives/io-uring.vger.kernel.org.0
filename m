Return-Path: <io-uring+bounces-5451-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97BDA9ED818
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 22:06:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFD4D18811D8
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 21:06:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25A7F18BC3F;
	Wed, 11 Dec 2024 21:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ZmIDmUMJ"
X-Original-To: io-uring@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5E5259498;
	Wed, 11 Dec 2024 21:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733951212; cv=none; b=klBiNA1hyw+sNBMckchMu/MpMXEfmAnwcZkItcOhHLqCiAurmoPSq8hWoJihB+Tpx2BaXBofx1Ht0dHTQFz3cSWg+1wRlOV6IPjKIdYniFQzvXc3rGAAXzVPlaMt8aTMLcAiCRnbudsHBAgfHOY8qwYPheBctjMCtF2gAjmq0/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733951212; c=relaxed/simple;
	bh=/JV8qrvMSeI9Y299MeOgobkHL+l5vNfjqH74EmS8pgQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jNRLPF/jjv6cPaFxHviJLkxLpBUYuLldmK+0Qx9Z7MsypkF2dwjGFQnI6ymihZueFvRdRDpOil7FI1GWp8XfDLiSt/qkYb8PINvsbjHqZCDyV+mH2OU7A8WEUoPISOvwC9vIRbk5A+8t+yBijoyBv/gaCLQVZdjFDUOJ3Gej2Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ZmIDmUMJ; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Y7p7Q6L4Qzlff0H;
	Wed, 11 Dec 2024 21:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1733951196; x=1736543197; bh=/JV8qrvMSeI9Y299MeOgobkH
	L+l5vNfjqH74EmS8pgQ=; b=ZmIDmUMJ5d05zNVGbU3NBQJRbyahps0uovWH9UvB
	S/vsVkCfJuu3lwcotq2g2bqyjgLQR2FPQWCqa/epPNLeSQYFglXvwQ1a0U13QnLi
	pJiCJK/0ws1teK+zy7bfxBY/E4JaOl25MDsd7L1ax5vfEqLI/1dUGiiWViuUPDAr
	Y/tDDlFvqFYxOGOlZfx9H97R9vt+QQqG0dVso7rqk+P1tCB6KNQcpIIPBvClMJFr
	0IefEVi1npGqbP63HU/lFXiIYQdgkik0965Wad6nWgmrR0Yz51SqtTGQ2NtK9/Pu
	jMdF1YmOBsigc/vI2PBstwqKqljrhjMaaKUXne0IHI7ZgA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TdtYQu5XbU6W; Wed, 11 Dec 2024 21:06:36 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Y7p792X0Wzlff05;
	Wed, 11 Dec 2024 21:06:28 +0000 (UTC)
Message-ID: <97ed9def-7dfd-4170-9e60-6c081da409bc@acm.org>
Date: Wed, 11 Dec 2024 13:06:27 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
To: Damien Le Moal <dlemoal@kernel.org>, hch <hch@lst.de>,
 Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Nitesh Shetty <nj.shetty@samsung.com>,
 Javier Gonzalez <javier.gonz@samsung.com>,
 Matthew Wilcox <willy@infradead.org>, Keith Busch <kbusch@kernel.org>,
 Keith Busch <kbusch@meta.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "joshi.k@samsung.com" <joshi.k@samsung.com>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <yq1ed38roc9.fsf@ca-mkp.ca.oracle.com>
 <9d61a62f-6d95-4588-bcd8-de4433a9c1bb@acm.org>
 <yq1plmhv3ah.fsf@ca-mkp.ca.oracle.com>
 <8ef1ec5b-4b39-46db-a4ed-abf88cbba2cd@acm.org>
 <yq1jzcov5am.fsf@ca-mkp.ca.oracle.com>
 <CGME20241205081138epcas5p2a47090e70c3cf19e562f63cd9fc495d1@epcas5p2.samsung.com>
 <20241205080342.7gccjmyqydt2hb7z@ubuntu>
 <yq1a5d9op6p.fsf@ca-mkp.ca.oracle.com> <20241210071253.GA19956@lst.de>
 <2a272dbe-a90a-4531-b6a2-ee7c4c536233@wdc.com> <20241210105822.GA3123@lst.de>
 <a10da3f8-9a71-4794-9473-95385ac4e59f@acm.org>
 <6ff84297-d133-48d4-b847-807a75cab0f6@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6ff84297-d133-48d4-b847-807a75cab0f6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/10/24 8:07 PM, Damien Le Moal wrote:
> But for F2FS, the conventional unit is used for metadata and the other zoned LU
> for data. How come copying from one to the other can be useful ?

Hi Damien,

What you wrote is correct in general. If a conventional and zoned LU are
combined, data is only written to the conventional LU once the zoned LU
is full. The data on the conventional LU may be migrated to the zoned LU
during garbage collection. This is why copying from the conventional LU
to the zoned LU is useful.

Jaegeuk, please correct me if I got this wrong.

Bart.



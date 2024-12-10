Return-Path: <io-uring+bounces-5414-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B935D9EBA06
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 20:21:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A3931886DCD
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 19:21:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51F6F224AEB;
	Tue, 10 Dec 2024 19:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="H8w++Jtt"
X-Original-To: io-uring@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976BE23ED63;
	Tue, 10 Dec 2024 19:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733858497; cv=none; b=s97EW7qXxH2GUyl80A7nsFlwY2jgIjxFzZ8ccovBjS0TsCeOw3o9WpVElEpvf6QXYuBIsRNtsiL98uh9f2LC7xKQGjmiJVxPvUWnEezIvLVjZODuEo3SuSpLJVhqtM+DpOJyRVRrfL9RiCOAB++w1SIkk1C1Yd5uipi4PX6nV4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733858497; c=relaxed/simple;
	bh=3IuxfdZlkeKKdy0z0s/LC0FJPtMGyWmWmj3MdGBivHQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=syE+4FP6t588ImF4/YcY5SQZS94HhcemK+n1OIDLJFiPXv4SmtAbEQJzMBvN30mInR4iI3mzsuJ5Utb28h363K8Az8TrfnLcdjiuEOQyKsvF5FukOpEzh5LrwRVJ8YtiHZgVPo7lf3QwKTN0NyP6b6RVE1hACKUvG4iUjnFYpMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=H8w++Jtt; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Y77rT0hT9zlfl5W;
	Tue, 10 Dec 2024 19:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1733858483; x=1736450484; bh=kGRxI4MvkczRgURGuKE/NkzS
	kR8ERW6zUvwscihee5Y=; b=H8w++JttLWyRmupBTpStBzQYxt04HXVU8MKEQp/A
	QDh5jwvvB7s/UP9el/mzXENVIjN+SNQL050OLkUB5F4NIzwf7R6EUjlXHqRPlKov
	1u51rm2LezO45wdEDr6Uid0qCWKiscKLy5sfj5krUU0B9bTVdq9P6jO0WzAjshJ8
	0vnnMakugglrPj/CaTcLAVyWNSFkva6ccpFCmNr+hFUfHByiRhjCwfWjBss37wjc
	+Qb2yUvJDvJvNGJsIGh/Avom64luqQdXa/qRFoRiehYjX0xMZaZfTmgJFP16eCI+
	93n+QYDTSoYErgf2t0pn9JC36n/iVCi5CnmzCkklf/KarA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id v14CjmZSqQuW; Tue, 10 Dec 2024 19:21:23 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Y77rJ3qwkzlgd6J;
	Tue, 10 Dec 2024 19:21:20 +0000 (UTC)
Message-ID: <a10da3f8-9a71-4794-9473-95385ac4e59f@acm.org>
Date: Tue, 10 Dec 2024 11:21:19 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
To: hch <hch@lst.de>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
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
 "joshi.k@samsung.com" <joshi.k@samsung.com>
References: <yq1ed38roc9.fsf@ca-mkp.ca.oracle.com>
 <9d61a62f-6d95-4588-bcd8-de4433a9c1bb@acm.org>
 <yq1plmhv3ah.fsf@ca-mkp.ca.oracle.com>
 <8ef1ec5b-4b39-46db-a4ed-abf88cbba2cd@acm.org>
 <yq1jzcov5am.fsf@ca-mkp.ca.oracle.com>
 <CGME20241205081138epcas5p2a47090e70c3cf19e562f63cd9fc495d1@epcas5p2.samsung.com>
 <20241205080342.7gccjmyqydt2hb7z@ubuntu>
 <yq1a5d9op6p.fsf@ca-mkp.ca.oracle.com> <20241210071253.GA19956@lst.de>
 <2a272dbe-a90a-4531-b6a2-ee7c4c536233@wdc.com> <20241210105822.GA3123@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241210105822.GA3123@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 12/10/24 2:58 AM, hch wrote:
> On Tue, Dec 10, 2024 at 08:05:31AM +0000, Johannes Thumshirn wrote:
>>> Generally agreeing with all you said, but do we actually have any
>>> serious use case for cross-LU copies?  They just seem incredibly
>>> complex any not all that useful.
>>
>> One use case I can think of is (again) btrfs balance (GC, convert, etc=
)
>> on a multi drive filesystem. BUT this use case is something that can
>> just use the fallback read-write path as it is doing now.
>=20
> Who uses multi-device file systems on multiple LUs of the same SCSI
> target =C6=A1r multiple namespaces on the same nvme subsystem?

On Android systems F2FS combines a small conventional logical unit and a
large zoned logical unit into a single filesystem. This use case will
benefit from copy offloading between different logical units on the same
SCSI device. While there may be disagreement about how desirable this
setup is from a technical point of view, there is a real use case today
for offloading data copying between different logical units.

Bart.


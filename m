Return-Path: <io-uring+bounces-5427-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F246D9EC3DE
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 05:08:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F371283CA4
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 04:08:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A3B91B0F38;
	Wed, 11 Dec 2024 04:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m/UfDmLE"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DCB2451C0;
	Wed, 11 Dec 2024 04:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733890087; cv=none; b=L1/NqGQKSMy/78FkaHsltz3Thphs/0rH9Hg1yivfmzMzCqV6OGuDhu1WroUmFwHBRFyQNJ1heV/UXdQlGBN7wN6Gb8F5pTGJzWJ2UhY6mWmEcGOqC8TuanmdAKW0XztDnSQksr0bMkbFJF/3VqbKau2tOL1XLpRnqjk6tmEudCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733890087; c=relaxed/simple;
	bh=7/3hmNoQ4LWXf/liq0trPhtYhdVp9Bh0JJE/pGvZqI0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XkXdcnpFFnQ9gkxJDKhM1i6wbD+LpTshddOyY61G6CaZ4hqk3ThkB3lzCnilR3uAb4yq6pQ8wDQ2WHPRVCRT6mXrrUnDtk7A6Q5z3oe7HEQfjRjttbQieoGHAGjW27XkeiE9C6V8O/fkjcCkXDfCFNJ052RH4dYQsKJ+1wUDBJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m/UfDmLE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373A1C4CED2;
	Wed, 11 Dec 2024 04:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733890086;
	bh=7/3hmNoQ4LWXf/liq0trPhtYhdVp9Bh0JJE/pGvZqI0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=m/UfDmLE/Egvp+aU2S6OtaAiPyALgOouiw8E+uIWgCmIcPR4C2wjS73sbWaCLIIRt
	 gWn+RRFTfqC4ombZ1LaTAOmlr/qYUJepIDpqF1zfy3lkHpnd0LFqNKnpsIdlwoNV1q
	 torokdsotdOIaYmZoXSRFVu40kfdYFGDnY4JzzhDcn517OIX8RyHltAn5FUn2dgJh0
	 90Ev9VNXFa6tQ/jVAAgQ42wn9SV0Bz8UhMHM51OIXl55ihfMyWYmRPVVpfr5MsQpQp
	 XtdWAqu4dNI6qKMz3dGzSWvaISGjEYAGwulQJRy4k64T+fzqLVloAEjgQP4OdvMwNj
	 KSOqYl/OYF4LQ==
Message-ID: <6ff84297-d133-48d4-b847-807a75cab0f6@kernel.org>
Date: Wed, 11 Dec 2024 13:07:38 +0900
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
To: Bart Van Assche <bvanassche@acm.org>, hch <hch@lst.de>,
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
 <a10da3f8-9a71-4794-9473-95385ac4e59f@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <a10da3f8-9a71-4794-9473-95385ac4e59f@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 12/11/24 4:21 AM, Bart Van Assche wrote:
> On 12/10/24 2:58 AM, hch wrote:
>> On Tue, Dec 10, 2024 at 08:05:31AM +0000, Johannes Thumshirn wrote:
>>>> Generally agreeing with all you said, but do we actually have any
>>>> serious use case for cross-LU copies?  They just seem incredibly
>>>> complex any not all that useful.
>>>
>>> One use case I can think of is (again) btrfs balance (GC, convert, etc)
>>> on a multi drive filesystem. BUT this use case is something that can
>>> just use the fallback read-write path as it is doing now.
>>
>> Who uses multi-device file systems on multiple LUs of the same SCSI
>> target ơr multiple namespaces on the same nvme subsystem?
> 
> On Android systems F2FS combines a small conventional logical unit and a
> large zoned logical unit into a single filesystem. This use case will
> benefit from copy offloading between different logical units on the same
> SCSI device. While there may be disagreement about how desirable this
> setup is from a technical point of view, there is a real use case today
> for offloading data copying between different logical units.

But for F2FS, the conventional unit is used for metadata and the other zoned LU
for data. How come copying from one to the other can be useful ?

> 
> Bart.
> 


-- 
Damien Le Moal
Western Digital Research


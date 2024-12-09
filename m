Return-Path: <io-uring+bounces-5356-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FF609EA1A8
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 23:14:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0222928405B
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 22:14:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2B8419D09C;
	Mon,  9 Dec 2024 22:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jDq10gFK"
X-Original-To: io-uring@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A91E19D090;
	Mon,  9 Dec 2024 22:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733782437; cv=none; b=dvE8rGeVIMBRW/NDws6dugIfz8cekkhWvYopguqlrJWAOm8hnGoOF9h/hJSgD2ZLoZwIUr4ir91bwAR2rNbgm5yz0h8T+nL2LTSgrDpzUPiIiHkdTDz66V75Sl+boteLc/iLRODMRY09wdlX2z7xB0karAuN3uUYdcewnPzF2wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733782437; c=relaxed/simple;
	bh=Zoicv6FCB+iFzMQfrU4Z9XfeuHWSrSqyKjxadK6Xa+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MLDV5Aw7cIbs5lup6f/Mgy5Jxd5JWGkxqGRVre65B9kh0wTyQvtm5wYiOvahzkI3eG6nC+vTFQ+SUuvypmZNXuqY6zx24kpDg1NGWvAc9eM4936HevFtt0fI+UnYJYH0xWUcN4Zb2XbgOQSDKjR0K6KAJULQ2zvhtxFJSUhh7BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jDq10gFK; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Y6bjv2dDszlfflB;
	Mon,  9 Dec 2024 22:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1733782429; x=1736374430; bh=IQKVDEMj0TrHltVURdtOup6I
	IRHQAQ4lIbXGduLnT6I=; b=jDq10gFK/44haFYNLdurY4fNR+uBNg0nU4knZqPa
	ibGTnIO0Rl5EA+MPlZ4I5pCwvbTrPvQCB0DiYqmkZrE3zzRRmiECLY4uOJmZeKv7
	OvGmexAE5Z2hai0js6fM7Rxwg9PbyphTBqFEKalOQQwR3nhHwRigEY0paW1OxGug
	M4l/G846p7QRGdNb/z3j99331bgyzQ4FIDPiarmykDUolWZSB4WwgRcPCZmftVms
	Djmn6GlTt3+3AMAUhRq8HUJHiFM0NdmTdZ3XvlxPqfEGKY9Aqo41s+CwgyysZ5v1
	fcIIUCBF06cRgzg2HVDqMe/aiIe8MCu1CPv879TXpzViqQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jToVKEuMeHKC; Mon,  9 Dec 2024 22:13:49 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Y6bjf55d1zlfflY;
	Mon,  9 Dec 2024 22:13:41 +0000 (UTC)
Message-ID: <c639f90f-bdd1-4808-aeb7-e9b667822413@acm.org>
Date: Mon, 9 Dec 2024 14:13:40 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
To: Nitesh Shetty <nj.shetty@samsung.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Javier Gonzalez <javier.gonz@samsung.com>,
 Matthew Wilcox <willy@infradead.org>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "joshi.k@samsung.com" <joshi.k@samsung.com>
References: <d7b7a759dd9a45a7845e95e693ec29d7@CAMSVWEXC02.scsc.local>
 <2b5a365a-215a-48de-acb1-b846a4f24680@acm.org>
 <20241111093154.zbsp42gfiv2enb5a@ArmHalley.local>
 <a7ebd158-692c-494c-8cc0-a82f9adf4db0@acm.org>
 <20241112135233.2iwgwe443rnuivyb@ubuntu>
 <yq1ed38roc9.fsf@ca-mkp.ca.oracle.com>
 <9d61a62f-6d95-4588-bcd8-de4433a9c1bb@acm.org>
 <yq1plmhv3ah.fsf@ca-mkp.ca.oracle.com>
 <8ef1ec5b-4b39-46db-a4ed-abf88cbba2cd@acm.org>
 <yq1jzcov5am.fsf@ca-mkp.ca.oracle.com>
 <CGME20241205081138epcas5p2a47090e70c3cf19e562f63cd9fc495d1@epcas5p2.samsung.com>
 <20241205080342.7gccjmyqydt2hb7z@ubuntu>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241205080342.7gccjmyqydt2hb7z@ubuntu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 12/5/24 12:03 AM, Nitesh Shetty wrote:
> But where do we store the read sector info before sending write.
> I see 2 approaches here,
> 1. Should it be part of a payload along with write ?
>  =C2=A0=C2=A0=C2=A0=C2=A0We did something similar in previous series wh=
ich was not liked
>  =C2=A0=C2=A0=C2=A0=C2=A0by Christoph and Bart.
> 2. Or driver should store it as part of an internal list inside
> namespace/ctrl data structure ?
>  =C2=A0=C2=A0=C2=A0=C2=A0As Bart pointed out, here we might need to sen=
d one more fail
>  =C2=A0=C2=A0=C2=A0=C2=A0request later if copy_write fails to land in s=
ame driver.

Hi Nitesh,

Consider the following example: dm-linear is used to concatenate two
block devices. An NVMe device (LBA 0..999) and a SCSI device (LBA
1000..1999). Suppose that a copy operation is submitted to the dm-linear
device to copy LBAs 1..998 to LBAs 2..1998. If the copy operation is
submitted as two separate operations (REQ_OP_COPY_SRC and
REQ_OP_COPY_DST) then the NVMe device will receive the REQ_OP_COPY_SRC
operation and the SCSI device will receive the REQ_OP_COPY_DST
operation. The NVMe and SCSI device drivers should fail the copy=20
operations after a timeout because they only received half of the copy
operation. After the timeout the block layer core can switch from
offloading to emulating a copy operation. Waiting for a timeout is
necessary because requests may be reordered.

I think this is a strong argument in favor of representing copy
operations as a single operation. This will allow stacking drivers
as dm-linear to deal in an elegant way with copy offload requests
where source and destination LBA ranges map onto different block
devices and potentially different block drivers.

Thanks,

Bart.


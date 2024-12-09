Return-Path: <io-uring+bounces-5357-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 76ED49EA28B
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 00:14:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E028163A7C
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 23:14:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EE6019FA93;
	Mon,  9 Dec 2024 23:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zj7sUsGm"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E441F19F471;
	Mon,  9 Dec 2024 23:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733786033; cv=none; b=IysGU6WRIgH0hov8GBkj0NBcgfBo2e1ngAFJqsdiLOtEa/d7nYDhJ8dHuFjUvDT0lsJTRjl9TwRDpQJ4V0aJcvhhvsUX5hEGavrmVheTCHlEW93v5LsGUA8gTAqFUChq9SJKNIKLd2wPguWI4DAtOIiRiYhyVJ+Yk08jMCCEbC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733786033; c=relaxed/simple;
	bh=FonpP2yRbU9dV17o69mNsSGdBW1hv2v1dQRplHQBs7E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MKyE46pEK5S2jgRPidiVx3/fLSBZN9zDoz66aYXsKnvvnIcC6XDBt0A2mN4aU6ho23/n5LpH/sPQGGmnd6LzDwuNINMoyNghAsCwL8fGD2gjmEC5Tt3C3ZrhMaiFoGiwDEArLDQ9XwLyxLB423a8q6OhOhtozKGn9J9TRtz3ZtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zj7sUsGm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FEA0C4CED1;
	Mon,  9 Dec 2024 23:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733786032;
	bh=FonpP2yRbU9dV17o69mNsSGdBW1hv2v1dQRplHQBs7E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Zj7sUsGmeF0PldVUJjr8d64+L196sZukFtk1CaP3Bbi9uYGRg8k6u7TtN7hmir8Sy
	 ESkHYO/SWTnXzwqor6irRTep3qhU/MTt1OseRzkys656TTXUxwbacdQp/UNpqko05g
	 BQ3PTyCSP4EI2+4tXnVn4z+IbF8LS8VLxejnan/0HH7ITKTyi52njQwMZ8wslospjT
	 b9RIwVPg25KFvUM5TieFbcVu4KofJsjIBnUlyWcdnVj5xqDEuclP3fu4k57dOEFQDL
	 D6bBTgxS7QXp6mZQDB4juTWOS3O9actt82jcih1S8vnUD68oB2gPVldHMaTwtU+FNy
	 DghWt5Mo3RvFQ==
Message-ID: <2287bbe4-1aad-419b-89a9-7c49fdc584ba@kernel.org>
Date: Tue, 10 Dec 2024 08:13:49 +0900
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
To: Bart Van Assche <bvanassche@acm.org>,
 Nitesh Shetty <nj.shetty@samsung.com>,
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
 <c639f90f-bdd1-4808-aeb7-e9b667822413@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <c639f90f-bdd1-4808-aeb7-e9b667822413@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 12/10/24 07:13, Bart Van Assche wrote:
> On 12/5/24 12:03 AM, Nitesh Shetty wrote:
>> But where do we store the read sector info before sending write.
>> I see 2 approaches here,
>> 1. Should it be part of a payload along with write ?
>>      We did something similar in previous series which was not liked
>>      by Christoph and Bart.
>> 2. Or driver should store it as part of an internal list inside
>> namespace/ctrl data structure ?
>>      As Bart pointed out, here we might need to send one more fail
>>      request later if copy_write fails to land in same driver.
> 
> Hi Nitesh,
> 
> Consider the following example: dm-linear is used to concatenate two
> block devices. An NVMe device (LBA 0..999) and a SCSI device (LBA
> 1000..1999). Suppose that a copy operation is submitted to the dm-linear
> device to copy LBAs 1..998 to LBAs 2..1998. If the copy operation is
> submitted as two separate operations (REQ_OP_COPY_SRC and
> REQ_OP_COPY_DST) then the NVMe device will receive the REQ_OP_COPY_SRC
> operation and the SCSI device will receive the REQ_OP_COPY_DST
> operation. The NVMe and SCSI device drivers should fail the copy 
> operations after a timeout because they only received half of the copy
> operation. After the timeout the block layer core can switch from
> offloading to emulating a copy operation. Waiting for a timeout is
> necessary because requests may be reordered.
> 
> I think this is a strong argument in favor of representing copy
> operations as a single operation. This will allow stacking drivers
> as dm-linear to deal in an elegant way with copy offload requests
> where source and destination LBA ranges map onto different block
> devices and potentially different block drivers.

Why ? As long as REQ_OP_COPY_SRC carries both source and destination
information, DM can trivially detect that the copy is not within a single device
and either return ENOTSUPP or switch to using a regular read+write operations
using block layer helpers. Or the block layer can fallback to that emulation
itself if it gets a ENOTSUPP from the device.

I am not sure how a REQ_OP_COPY_SRC BIO definition would look like. Ideally, we
want to be able to describe several source LBA ranges with it and for the above
issue also have the destination LBA range as well. If we can do that in a nice
way, I do not see the need for switching back to a single BIO, though we could
too I guess. From what Martin said for scsi token-based copy, it seems that 2
operations is easier. Knowing how the scsi stack works, I can see that too.


-- 
Damien Le Moal
Western Digital Research


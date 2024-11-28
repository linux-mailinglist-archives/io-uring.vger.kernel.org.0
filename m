Return-Path: <io-uring+bounces-5112-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 017C59DB449
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 09:52:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABEFC164391
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 08:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F9A714F115;
	Thu, 28 Nov 2024 08:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="huPUraNV"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAE014BF92;
	Thu, 28 Nov 2024 08:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732783916; cv=none; b=LbogJqZF67/rrMTVF5XX0i0F3CB9SJsL3YPYaVCherYApewDtofP2SP8AVj5//E4xKdn5pDSdvgAGpc6QWbFcfsDYsXcjeBmeGPdVbkApLQna6lrpFPpet2s8IzqSnJ1FXSZ4kwFopRNCnnmUKbI6r5G3CB5RtaTrFjYTtLX7n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732783916; c=relaxed/simple;
	bh=IvK1zy/sYlcAsuAagh9WHWt5pI9LVrBWaIhMoNQD9O4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iGcWJ+DduiJJ7YnagSbbDXEAVdwu2frrAnzIJJW1TFsciwt6rHH+Zy6dHc5eYWK6CPNlwmZmNf+qT9phMhsShHNCQLfQHOrC8jDYaaBA/L3C7Gf8WWJtqZreIbYNJZQz2DufJPHfzej3+2RI+Z+Bp/LSUTsXuNT3lRBf7ABOWK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=huPUraNV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FE4C4CECE;
	Thu, 28 Nov 2024 08:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732783915;
	bh=IvK1zy/sYlcAsuAagh9WHWt5pI9LVrBWaIhMoNQD9O4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=huPUraNVdlRnc/8SRCQCbFMy8iYIjMB3PAVtxdtrPxXEKBIuk8JVyvQSXKpsyKWuo
	 SvcCUUNE7HC9Ow0pgQqrcSsjRWVD1P/g2f9kgyvtxjXhKVQQl/WoCSjhSVqKvly84z
	 +qbNSYVsjzMQgKzuLerNaymQkOu7/fWI3nFulGMiuFWVjbrMT24B6c3AJbjRYBI9+k
	 2CtCUhK0Q8s7rUZJyzmT8ZAu2XK9xcYNoRWhvchpzCiitbGPplCghEKZHDly179oyw
	 92xIUGP8xGw+tApw4velQg0xPNtB+McQCWkzpwfXXOLdLYy+5+ZsUJFbkvIjOuZIee
	 lCIVOIxNTujeQ==
Message-ID: <9e9ca761-6356-4a97-a314-d08bd5ea0916@kernel.org>
Date: Thu, 28 Nov 2024 17:51:52 +0900
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Bart Van Assche <bvanassche@acm.org>
Cc: Nitesh Shetty <nj.shetty@samsung.com>,
 Javier Gonzalez <javier.gonz@samsung.com>,
 Matthew Wilcox <willy@infradead.org>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "joshi.k@samsung.com" <joshi.k@samsung.com>
References: <20241105155014.GA7310@lst.de> <Zy0k06wK0ymPm4BV@kbusch-mbp>
 <20241108141852.GA6578@lst.de> <Zy4zgwYKB1f6McTH@kbusch-mbp>
 <CGME20241108165444eucas1p183f631e2710142fbbc7dee9300baf77a@eucas1p1.samsung.com>
 <Zy5CSgNJtgUgBH3H@casper.infradead.org>
 <d7b7a759dd9a45a7845e95e693ec29d7@CAMSVWEXC02.scsc.local>
 <2b5a365a-215a-48de-acb1-b846a4f24680@acm.org>
 <20241111093154.zbsp42gfiv2enb5a@ArmHalley.local>
 <a7ebd158-692c-494c-8cc0-a82f9adf4db0@acm.org>
 <20241112135233.2iwgwe443rnuivyb@ubuntu>
 <yq1ed38roc9.fsf@ca-mkp.ca.oracle.com>
 <9d61a62f-6d95-4588-bcd8-de4433a9c1bb@acm.org>
 <yq1plmhv3ah.fsf@ca-mkp.ca.oracle.com>
 <8ef1ec5b-4b39-46db-a4ed-abf88cbba2cd@acm.org>
 <yq1jzcov5am.fsf@ca-mkp.ca.oracle.com>
 <7835e7e2-2209-4727-ad74-57db09e4530f@acm.org>
 <yq1ed2wupli.fsf@ca-mkp.ca.oracle.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <yq1ed2wupli.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/28/24 11:09, Martin K. Petersen wrote:
> 
> Bart,
> 
>> What if the source LBA range does not require splitting but the
>> destination LBA range requires splitting, e.g. because it crosses a
>> chunk_sectors boundary? Will the REQ_OP_COPY_IN operation succeed in
>> this case and the REQ_OP_COPY_OUT operation fail?
> 
> Yes.
> 
> I experimented with approaching splitting in an iterative fashion. And
> thus, if there was a split halfway through the COPY_IN I/O, we'd issue a
> corresponding COPY_OUT up to the split point and hope that the write
> subsequently didn't need a split. And then deal with the next segment.
> 
> However, given that copy offload offers diminishing returns for small
> I/Os, it was not worth the hassle for the devices I used for
> development. It was cleaner and faster to just fall back to regular
> read/write when a split was required.
> 
>> Does this mean that a third operation is needed to cancel
>> REQ_OP_COPY_IN operations if the REQ_OP_COPY_OUT operation fails?
> 
> No. The device times out the token.
> 
>> Additionally, how to handle bugs in REQ_OP_COPY_* submitters where a
>> large number of REQ_OP_COPY_IN operations is submitted without
>> corresponding REQ_OP_COPY_OUT operation? Is perhaps a mechanism
>> required to discard unmatched REQ_OP_COPY_IN operations after a
>> certain time?
> 
> See above.
> 
> For your EXTENDED COPY use case there is no token and thus the COPY_IN
> completes immediately.
> 
> And for the token case, if you populate a million tokens and don't use
> them before they time out, it sounds like your submitting code is badly
> broken. But it doesn't matter because there are no I/Os in flight and
> thus nothing to discard.
> 
>> Hmm ... we may each have a different opinion about whether or not the
>> COPY_IN/COPY_OUT semantics are a requirement for token-based copy
>> offloading.
> 
> Maybe. But you'll have a hard time convincing me to add any kind of
> state machine or bio matching magic to the SCSI stack when the simplest
> solution is to treat copying like a read followed by a write. There is
> no concurrency, no kernel state, no dependency between two commands, nor
> two scsi_disk/scsi_device object lifetimes to manage.

And that also would allow supporting a fake copy offload with regular read/write
BIOs very easily, I think. So all block devices can be presented as supporting
"copy offload". That is nice for FSes.

> 
>> Additionally, I'm not convinced that implementing COPY_IN/COPY_OUT for
>> ODX devices is that simple. The COPY_IN and COPY_OUT operations have
>> to be translated into three SCSI commands, isn't it? I'm referring to
>> the POPULATE TOKEN, RECEIVE ROD TOKEN INFORMATION and WRITE USING
>> TOKEN commands. What is your opinion about how to translate the two
>> block layer operations into these three SCSI commands?
> 
> COPY_IN is translated to a NOP for devices implementing EXTENDED COPY
> and a POPULATE TOKEN for devices using tokens.
> 
> COPY_OUT is translated to an EXTENDED COPY (or NVMe Copy) for devices
> using a single command approach and WRITE USING TOKEN for devices using
> tokens.

ATA WRITE GATHERED command is also a single copy command. That matches and while
I have not checked SAT, translation would likely work.

While I was initially worried that the 2 BIO based approach would be overly
complicated, it seems that I was wrong :)

> 
> There is no need for RECEIVE ROD TOKEN INFORMATION.
> 
> I am not aware of UFS devices using the token-based approach. And for
> EXTENDED COPY there is only a single command sent to the device. If you
> want to do power management while that command is being processed,
> please deal with that in UFS. The block layer doesn't deal with the
> async variants of any of the other SCSI commands either...
>


-- 
Damien Le Moal
Western Digital Research


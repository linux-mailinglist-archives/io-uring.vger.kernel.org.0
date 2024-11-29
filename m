Return-Path: <io-uring+bounces-5130-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A1559DBF77
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 07:24:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9A432B20A88
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 06:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 548552B2DA;
	Fri, 29 Nov 2024 06:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qz5iEpZN"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E6333C5;
	Fri, 29 Nov 2024 06:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732861434; cv=none; b=sLbDFcNLMunJkQtzVmguPHM5jycRtJb0BePy/SOHtx5UMRBFjbgw6lOndOa7KxTP30fvmVhqq4uBwMO96jo4N0nO3nl8FTJSJAJC4s1qRR93FHFfPyFp3za1DO0IsGxMpfm616EnWT/ZhSkIehwc8zkkU0imvnDbqLVhHT7H4VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732861434; c=relaxed/simple;
	bh=WmYOGV7eRRjGkSe/aBe/GEkoJ5Km7HN7iZg6KEnDfzM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E0ir8Oyvc7wEr3gN0B0dI50i9ovZ81PbUK16A75/288gsN3ScFVMh/JXgfxoVLnElAJpyVlN0WDEGX3eHaUpWPdC8/kaL89DJdVjL5V7XdfdcVTa6GYnywQfd786PFGb+OPhFVJjE7zzdtTyYIUtCNbgWSbrR1imBSi/YA58NrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qz5iEpZN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BADC4CECF;
	Fri, 29 Nov 2024 06:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732861433;
	bh=WmYOGV7eRRjGkSe/aBe/GEkoJ5Km7HN7iZg6KEnDfzM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Qz5iEpZNXkFhwZjMRhPi7DcRLoutFcyNz/qjrjMC2vseJRbH8d6OHCKGmVmKb3aZy
	 mHyNtYmrHB4k+w/BSsBSwrJpy3V3oEDfw3I220Pow7lLNipl/sSaSy463JThA2irQc
	 ofof19ssKDakuESSyOKDtKLixQiXT4a23SvGb7oaQgaOwaUHIbHCjkayusyiLfi2vU
	 MqOggfrIeD6MD/+NThWFOoO1zmUTMMQ2DFFcmuzWmWUC11ATrC7o6ReTseqxtfoTj1
	 PW446eKbhD2NYyDtEtcRqgaHl3dLWp2KaEx2A7Otxpg/2So1pLJLMZA/XRHBuLRAGu
	 wWFU53NdI7x4g==
Message-ID: <f029f618-7ca1-4f97-8f05-675709312785@kernel.org>
Date: Fri, 29 Nov 2024 15:23:50 +0900
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Bart Van Assche <bvanassche@acm.org>, Nitesh Shetty <nj.shetty@samsung.com>,
 Javier Gonzalez <javier.gonz@samsung.com>,
 Matthew Wilcox <willy@infradead.org>, Keith Busch <kbusch@kernel.org>,
 Keith Busch <kbusch@meta.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "joshi.k@samsung.com" <joshi.k@samsung.com>
References: <a7ebd158-692c-494c-8cc0-a82f9adf4db0@acm.org>
 <20241112135233.2iwgwe443rnuivyb@ubuntu>
 <yq1ed38roc9.fsf@ca-mkp.ca.oracle.com>
 <9d61a62f-6d95-4588-bcd8-de4433a9c1bb@acm.org>
 <yq1plmhv3ah.fsf@ca-mkp.ca.oracle.com>
 <8ef1ec5b-4b39-46db-a4ed-abf88cbba2cd@acm.org>
 <yq1jzcov5am.fsf@ca-mkp.ca.oracle.com>
 <7835e7e2-2209-4727-ad74-57db09e4530f@acm.org>
 <yq1ed2wupli.fsf@ca-mkp.ca.oracle.com>
 <9e9ca761-6356-4a97-a314-d08bd5ea0916@kernel.org>
 <20241129061941.GA2545@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241129061941.GA2545@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/29/24 15:19, Christoph Hellwig wrote:
> On Thu, Nov 28, 2024 at 05:51:52PM +0900, Damien Le Moal wrote:
>>> Maybe. But you'll have a hard time convincing me to add any kind of
>>> state machine or bio matching magic to the SCSI stack when the simplest
>>> solution is to treat copying like a read followed by a write. There is
>>> no concurrency, no kernel state, no dependency between two commands, nor
>>> two scsi_disk/scsi_device object lifetimes to manage.
>>
>> And that also would allow supporting a fake copy offload with regular
>> read/write BIOs very easily, I think. So all block devices can be
>> presented as supporting "copy offload". That is nice for FSes.
> 
> Just as when that showed up in one of the last copy offload series
> I'm still very critical of a stateless copy offload emulation.  The
> reason for that is that a host based copy helper needs scratch space
> to read into, and doing these large allocation on every copy puts a
> lot of pressure onto the allocator.  Allocating the buffer once at
> mount time and the just cycling through it is generally a lot more
> efficient.

Sure, that sounds good. My point was that it seems that a token based copy
offload design makes it relatively easy to emulate copy in software for devices
that do not support copy offload in hardware. That emulation can certainly be
implemented using a single buffer like you suggest.

-- 
Damien Le Moal
Western Digital Research


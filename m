Return-Path: <io-uring+bounces-3671-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B644F99D627
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 20:09:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24828281B08
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 18:09:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6615C1C7608;
	Mon, 14 Oct 2024 18:09:30 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BECE1C7265;
	Mon, 14 Oct 2024 18:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728929370; cv=none; b=CFZLqZhQzlg0VRkFu5Knn8Giedr8BsMeomNzeCOeaSiCvWzVXIZjxvtIpTnvqfcHHcShJBzarRRmu6IDmzV3sPp5/ZVa7/WIA7eFqgsAPUMt2M5+g6naiRipcjrrKAojvcUXNdJJdRpR7YqMUCEGei90CoTPr8bErj9dVG8W5S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728929370; c=relaxed/simple;
	bh=QWPFvEXhnNSElL02iFk/bzB2xt65kkr795ytO+XzExM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PPLkfo36G/K9/i4JLGxwINCnyvHPSPlUSUja/fB9IGLwmQ7py74OzJXkrCBYQY7QusDudC6WzYRU8XEJhaLfitFZBjJJFmADfUzrp2SrmZDto7vvTCoEz8pz2eWTpsV8jOhS+4EMMN8VxwD20NVHG2qy/teEz3BToyfYEOwNJoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C93B1007;
	Mon, 14 Oct 2024 11:09:55 -0700 (PDT)
Received: from [10.1.196.40] (e121345-lin.cambridge.arm.com [10.1.196.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 513A73F71E;
	Mon, 14 Oct 2024 11:09:24 -0700 (PDT)
Message-ID: <7411ae1d-5e36-46da-99cf-c485ebdb31bc@arm.com>
Date: Mon, 14 Oct 2024 19:09:08 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Report] annoyed dma debug warning "cacheline tracking EEXIST,
 overlapping mappings aren't supported"
To: Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>,
 Hamza Mahfooz <someguy@effective-light.com>,
 Dan Williams <dan.j.williams@intel.com>, linux-block@vger.kernel.org,
 io-uring@vger.kernel.org, linux-raid@vger.kernel.org, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <ZwxzdWmYcBK27mUs@fedora>
 <426b5600-7489-43a7-8007-ac4d9dbc9aca@suse.de>
 <20241014074151.GA22419@lst.de> <ZwzPDU5Lgt6MbpYt@fedora>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <ZwzPDU5Lgt6MbpYt@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/10/2024 8:58 am, Ming Lei wrote:
> On Mon, Oct 14, 2024 at 09:41:51AM +0200, Christoph Hellwig wrote:
>> On Mon, Oct 14, 2024 at 09:23:14AM +0200, Hannes Reinecke wrote:
>>>> 3) some storage utilities
>>>> - dm thin provisioning utility of thin_check
>>>> - `dt`(https://github.com/RobinTMiller/dt)
>>>>
>>>> I looks like same user buffer is used in more than 1 dio.
>>>>
>>>> 4) some self cooked test code which does same thing with 1)
>>>>
>>>> In storage stack, the buffer provider is far away from the actual DMA
>>>> controller operating code, which doesn't have the knowledge if
>>>> DMA_ATTR_SKIP_CPU_SYNC should be set.
>>>>
>>>> And suggestions for avoiding this noise?
>>>>
>>> Can you check if this is the NULL page? Operations like 'discard' will
>>> create bios with several bvecs all pointing to the same NULL page.
>>> That would be the most obvious culprit.
>>
>> The only case I fully understand without looking into the details
>> is raid1, and that will obviously map the same data multiple times
> 
> The other cases should be concurrent DIOs on same userspace buffer.

active_cacheline_insert() does already bail out for DMA_TO_DEVICE, so it 
returning -EEXIST to tickle the warning would seem to genuinely imply 
these are DMA mappings requesting to *write* the same cacheline 
concurrently, which is indeed broken in general.

Thanks,
Robin.


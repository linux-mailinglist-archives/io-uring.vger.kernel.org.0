Return-Path: <io-uring+bounces-3129-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F3562974404
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 22:22:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9C0E11F24DFE
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 20:22:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 795A2183CC7;
	Tue, 10 Sep 2024 20:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KE/iBm/w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE45566A;
	Tue, 10 Sep 2024 20:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725999734; cv=none; b=pzyM8/O/vlneKge/FZdCDAsiiSQsFtBCVRrUqx7NdTA6QmTI2RVoxAufg8PT6VEas0EZ9DVJqTKkr71MBOmWYh4Fev609Flhjmn0am0IZL3E/Is4vsYJAl8elSrHQkgX6InutWq9JDhqCuC4Zv0EA68di5ZHAWyhQe1p/Nhm2Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725999734; c=relaxed/simple;
	bh=f3JEjOCsd1ymTwKzB4PjN7pUptasEUQGp85xPTdZ+Qk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W4omA+r6Cgup0rHLnxp4vhS4JQvUXsR7LLQsg9uZMxaYb5GKFGFc7YrtxyxmvgWWEDIyZHOTqWHjfjXe3OjnlmcygAaIoEf1AqCISI2FMza2dYNewDT8Wa7cIDCVBRpU1HAje+sFicRLYXhNvlihDzgBtD70vozZlWRbSIKDuMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KE/iBm/w; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-42cb1e623d1so12166655e9.0;
        Tue, 10 Sep 2024 13:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725999731; x=1726604531; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MDjydcKVUDScuDqfe8vsl4HZhSr4A4L5web6qrYiGpI=;
        b=KE/iBm/wkU93x3rS0tGJQ/6txvJnP7rJvNA3mkWUjSRZcXA+R+6PjIJsFT3P57bggV
         WD9KInkf1E/gWq/Zz20ShBhGH44ISTX03cgpV/nrQ7DJ4aEdcrOQdDLWuhV7L8bONThf
         QxOuMPCbATtvbXo+b3eNEpNdS0dqGmYZHIVGez8f2OgFmUbXSNQXczXecgqz16t0pQKT
         IMbGVN+md2KY2xn4HU8VQl0kyhG/Eboq/5r7WjmZfT1fkcZuWxfST+uaKIfkCtRObeJe
         TM2OBeAzWFasGQajaAJOaHdflUWVp3KkvV4ctJ7ycg5H3bsf4VLTYmBFgwWPTWpMNMoE
         ePaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725999731; x=1726604531;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MDjydcKVUDScuDqfe8vsl4HZhSr4A4L5web6qrYiGpI=;
        b=qkFWGyGueBBJ2t9xL7k0Jp3R2CCYRiH3mNxLg73PljHJBwSE+Q9prvJ+aQrxUSR/K9
         AyJ8ymmE3LN4gna5qrQypKMLuLeDbELV6jr5CesE/s3me9OHtAdhzjoiv9rARnH0nQK9
         qAz5Fe9OHvbKvUAriuEd1J/K3YZTwWE8V6/8ngqD3pLFgqYOEbOT29lYBy34TgVJR84P
         TeXxG9GsuBe7MA1fVGXoSdEWrYxwv+XG58f1QUQskctMCHArYrfPfGatW6bn2wG6dsol
         YpE7zj2VM+JwHpnqa9GPW2cBAohILIDYzpK1sWdaCKc96VV3YE8JgD7RZ6027ExPVkIu
         6vKw==
X-Forwarded-Encrypted: i=1; AJvYcCXVb5R0qBSWn9aNNjFagBTdyKmHYwWwUenRmt9UtEvSPxcYgYfm4VWo9rJtx4HvBTbDbtaewsEG5H20xg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyPX8eh6eONbIQ8SdQ01G+D1TGs7/Hv2SXRZg5IdNFU0EGZIJp7
	g10QjZhc+oN3jIv5oT96pbZmn/XqxfN/tRmE2SexxYG4y27AZamB
X-Google-Smtp-Source: AGHT+IEXI7/Uw0lWdkbc1U6kE4SSL+rt3p7Kxas3S5dCTBcXcLo8UyFbt9cKKwqFtKZcpt9g6bDf7Q==
X-Received: by 2002:a05:600c:3b0f:b0:428:23c8:1e54 with SMTP id 5b1f17b1804b1-42ccd32deb6mr6702565e9.18.1725999730311;
        Tue, 10 Sep 2024 13:22:10 -0700 (PDT)
Received: from [192.168.42.24] ([185.69.144.178])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-378956653c6sm9757407f8f.32.2024.09.10.13.22.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 13:22:09 -0700 (PDT)
Message-ID: <a9a447c7-6b6d-4a49-ac16-e6b8e97908b6@gmail.com>
Date: Tue, 10 Sep 2024 21:22:37 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/8] block: implement async discard as io_uring cmd
To: Christoph Hellwig <hch@infradead.org>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org,
 linux-mm@kvack.org
References: <cover.1725621577.git.asml.silence@gmail.com>
 <7fc0a61ae29190a42e958eddfefd6d44cdf372ad.1725621577.git.asml.silence@gmail.com>
 <Zt_8wlXTyS2E7Xbe@infradead.org>
 <430ca5b3-6ee1-463b-9e4e-5d0b934578cc@gmail.com>
 <ZuBU6Nn3lS21FN_Y@infradead.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZuBU6Nn3lS21FN_Y@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/24 15:17, Christoph Hellwig wrote:
> On Tue, Sep 10, 2024 at 11:58:23AM +0100, Pavel Begunkov wrote:
>>>> +
>>>> +	err = filemap_invalidate_pages(bdev->bd_mapping, start,
>>>> +					start + len - 1, nowait);
>>>> +	if (err)
>>>> +		return err;
>>>> +
>>>> +	while ((bio = blk_alloc_discard_bio(bdev, &sector, &nr_sects, gfp))) {
>>>> +		if (nowait)
>>>> +			bio->bi_opf |= REQ_NOWAIT;
>>>> +		prev = bio_chain_and_submit(prev, bio);
>>>> +	}
>>>> +	if (!prev)
>>>> +		return -EAGAIN;
>>>
>>> If a user changes the max_discard value between the check above and
>>> the loop here this is racy.
>>
>> If the driver randomly changes it, it's racy either way. What do
>> you want to protect against?
> 
> The discard limit shrinking and now this successfully returning while
> not actually discarding the range.  The fix is pretty simple in that

If it's shrinking then bios initialised and submitted with that
initial larger limit should fail, e.g. by the disk or driver, which
would be caught by bio_cmd_bio_end_io(). If nobody fails bios, then
nothing ever will help here, you can always first queue up bios
and change the limit afterwards while they're still in flight.

> the nowait case should simply break out of the loop after the first bio.

while ((bio = blk_alloc_discard_bio(bdev, &sector, &nr_sects, gfp))) {
	if (nowait)
		bio->bi_opf |= REQ_NOWAIT;
	prev = bio_chain_and_submit(prev, bio);
	if (nowait)
		break;
}

Like this? I need to add nr_sects==0 post loop checking either way,
but I don't see how this break would be better any better than
bio_put before the submit from v2.

>>>> +sector_t bio_discard_limit(struct block_device *bdev, sector_t sector);
>>>
>>> And to be honest, I'd really prefer to not have bio_discard_limit
>>> exposed.  Certainly not outside a header private to block/.
>>
>> Which is the other reason why first versions were putting down
>> a bio seeing that there is more to be done for nowait, which
>> you didn't like. I can return back to it or narrow the scopre.
> 
> The above should also take care of that.
> 
>>
>>> Also why start at 137?  A comment
>>> would generally be pretty useful as well.
>>
>> There is a comment, 2 lines above the new define.
>>
>> /*
>>   * A jump here: 130-136 are reserved for zoned block devices
>>   * (see uapi/linux/blkzoned.h)
>>   */
>>
>> Is that your concern?
> 
> But those are ioctls, this is not an ioctl and uses a different
> number space.  Take a look at e.g. nvme uring cmds which also
> don't try to use the same number space as the ioctl.

As far as I see nvme cmds are just dropped onto the 0x80- range. Not
continuing ioctls, right, but nevertheless random and undocumented. And
if we're arguing that IOC helps preventing people issuing ioctls to a
wrong file type, we can easily extend it to "what if someone passes BLK*
ioctl number to io_uring or vise versa? Not to mention that most of the
IOC selling points have zero sense for io_uring like struct size and
struct copy direction.

>>> Also can we have a include/uapi/linux/blkdev.h for this instead of
>>> bloating fs.h that gets included just about everywhere?
>> I don't think it belongs to this series.
> 
> How would adding a proper header instead of bloating fs.h not be
> part of the series adding the first ever block layer uring_cmds?

Because, apparently, no one have ever gave a damn about it.
I'll add it for you, but with header probing instead of a simple
ifdef I'd call it a usability downgrade.

> Just in case I wasn't clear - this isn't asking you to move anything
> existing as we can't do that without breaking existing applications.

We can, by including blkdev.h into fs.h, but that's a different
kind of a structure.

> It is about adding the new command to the proper place.

-- 
Pavel Begunkov


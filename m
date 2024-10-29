Return-Path: <io-uring+bounces-4143-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E9E79B50C3
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 18:32:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 601011C22C0F
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 17:32:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB8801EE02A;
	Tue, 29 Oct 2024 17:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="P1foUjoL"
X-Original-To: io-uring@vger.kernel.org
Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A865A1E32D5;
	Tue, 29 Oct 2024 17:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730222721; cv=none; b=jX55j3C1N2pwlVpad/wmElE1IbAOIeooDPOLotGXHTITzhEl0VdZ6WnWtDGwERf9wNVSnhv5G8a7D3YgM2tQ10iB8n7qs7X/910AfbJcPopNI7iB9se+E32YCBfYHDF53UOWraVdbdEpcGGkGN48nwV+99rlvv4kPObyVDE4lsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730222721; c=relaxed/simple;
	bh=VefMPqHdKs48yVqeNGQvsFvjWt+HqUxQSA/xr2DTZEo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BoCodt/EzfLe1X1Emz3XwMW2QNxeEljOg5LMifKXQ5um91UHjmjncY7eez9B/sat8PtKPn2q4CRiRhYTRClH43vGYwRwBnAxsHzAyUf8IncMCiBcQSLi31bZzsWhY0vuhQ+4ghXKhfO7PRk7P7Bubn7FRI17SftzpTtKnrhoDkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=P1foUjoL; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XdHFq01vdz6CmQwQ;
	Tue, 29 Oct 2024 17:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730222715; x=1732814716; bh=hXDe+tdRwT/FF9z8Lg1MKoXd
	RHtft5T0vnCZA5690oA=; b=P1foUjoLaYTOdPwbnT8wjp0jVgHHgT7aFqFr8aUL
	lZek+KvMCYfO161JiFBa3dExIzCo7Otdl5Wcnq5j61p/OFoOUgUWwu+AHtTI+fQk
	uTaj7s0rgi2A9FfoZFCmyOTJrTuLghUOPQR1c9iRTK2gkmQI69bVmL7ChEdfd4hH
	95+hqxaF7GevIzW6bWOgFRcXyASV69WG5f28U0M8h10We/+pMhjSGFZNJXjMD9xJ
	/mmkLQ7efYsaV+HVJkXnedBsczWVDC//u6NIUIov+aUrvdG0524N6kzJT2Sfs3xD
	CvV+zaHKwT2QX9oyDLgfitvJJPWw62ReU54EkOfhee4tYQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 5G4_p2--gGG8; Tue, 29 Oct 2024 17:25:15 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XdHFj2LCXz6CmQwN;
	Tue, 29 Oct 2024 17:25:12 +0000 (UTC)
Message-ID: <a1ff3560-4072-4ecf-8501-e353b1c98bf0@acm.org>
Date: Tue, 29 Oct 2024 10:25:11 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv10 4/9] block: allow ability to limit partition write
 hints
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
 io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, hch@lst.de, joshi.k@samsung.com,
 javier.gonz@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20241029151922.459139-1-kbusch@meta.com>
 <20241029151922.459139-5-kbusch@meta.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241029151922.459139-5-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/29/24 8:19 AM, Keith Busch wrote:
> +static ssize_t part_write_hint_mask_store(struct device *dev,
> +					  struct device_attribute *attr,
> +					  const char *buf, size_t count)
> +{
> +	struct block_device *bdev = dev_to_bdev(dev);
> +	unsigned short max_write_hints = bdev_max_write_hints(bdev);
> +	unsigned long *new_mask;
> +
> +	if (!max_write_hints)
> +		return count;
> +
> +	new_mask = bitmap_alloc(max_write_hints, GFP_KERNEL);
> +	if (!new_mask)
> +		return -ENOMEM;
> +
> +	bitmap_parse(buf, count, new_mask, max_write_hints);
> +	bitmap_copy(bdev->write_hint_mask, new_mask, max_write_hints);
> +	bitmap_free(new_mask);
> +
> +	return count;
> +}

bitmap_copy() is not atomic. Shouldn't the bitmap_copy() call be
serialized against the code that tests bits in bdev->write_hint_mask?

Thanks,

Bart.



Return-Path: <io-uring+bounces-3869-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A07DF9A70AC
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 19:10:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 49BA91F21674
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 17:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7C13199939;
	Mon, 21 Oct 2024 17:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RhAveDcG"
X-Original-To: io-uring@vger.kernel.org
Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DCB47A73;
	Mon, 21 Oct 2024 17:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729530621; cv=none; b=aFuiSgimUqcJCyuL+cez+9zBqNNFwCpfwliXRvhNXtb4Zlx41b73xmmBin4yA7kbjceEt7XyDnsnpYPp28LqaiE60xYBSkg1Yw0bcNlJTpTG9WuePdr5aKSfl0TPudH6D57Xkd4VO2sL5KBfuEo5uuWAb8jZvKQuEzn53xDWN7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729530621; c=relaxed/simple;
	bh=3Bawaj97+16LZJ5/kXZHuyxWrZquUh1w7tNj5hTTnAs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SPtwilQO5VA+rFoan7WIMIrRme8rJxN/MGdBvWAE9oVDuwHKRIqhs7dGh6YNUy1E6c5mN+n9RaNPAFcDJ0Jhuy3ZTJIJlEv7zK8ckK+q+HQ3kfI6cWgxMK/kDic2yS2L6pHWZUP9+ZOZ5O13cmPoIBZUUB+eYzQo/8IWdeWc4+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RhAveDcG; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XXMJ41wrsz6ClY9J;
	Mon, 21 Oct 2024 17:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729530603; x=1732122604; bh=11C38koXyZw+O5RI9Un69eSq
	783zFusoRbV176crTNM=; b=RhAveDcGf9i/kd6r+Qf6jBAL2nhRkd1q38TQRAZL
	sLyROvHW+CHEEorq3Owj3v3QQ2Ljj/5a0mY7sVHh4UWQ7/105yv9CmUJrVxenPwg
	zcsFe/W28Hdalgkdns3wXK4Bk2mc25WlPB/1UtGIzg8v/0EZaTezWmdUtpKeMMHS
	wlk6Vmk9SsFbVCeYTXY+CpUEr4sSoVMaRmTD0xgMivlu+TribTi8jAlGAnZGeYvF
	doM2jJeh8clM8zY6ZpGy7C4QyR+AXIKue1g0kYa355LsmFu9LsbMMraSw8TSVejg
	AK47DVWvnEndp861BXF8oRpOQ4SGGfs04R+oi2Gmb7POzw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id R0H-YYTLMGMS; Mon, 21 Oct 2024 17:10:03 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XXMHr68rSz6ClY9G;
	Mon, 21 Oct 2024 17:10:00 +0000 (UTC)
Message-ID: <a87c67aa-b1fe-48dc-9b5a-bc6732931298@acm.org>
Date: Mon, 21 Oct 2024 10:09:57 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv8 1/6] block, fs: restore kiocb based write hint
 processing
To: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, axboe@kernel.dk, io-uring@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, joshi.k@samsung.com, javier.gonz@samsung.com,
 Nitesh Shetty <nj.shetty@samsung.com>, Hannes Reinecke <hare@suse.de>
References: <20241017160937.2283225-1-kbusch@meta.com>
 <20241017160937.2283225-2-kbusch@meta.com> <20241018055032.GB20262@lst.de>
 <ZxZ3o_HzN8HN6QPK@kbusch-mbp>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZxZ3o_HzN8HN6QPK@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/24 8:47 AM, Keith Busch wrote:
> On Fri, Oct 18, 2024 at 07:50:32AM +0200, Christoph Hellwig wrote:
>> On Thu, Oct 17, 2024 at 09:09:32AM -0700, Keith Busch wrote:
>>>   {
>>>   	*kiocb = (struct kiocb) {
>>>   		.ki_filp = filp,
>>>   		.ki_flags = filp->f_iocb_flags,
>>>   		.ki_ioprio = get_current_ioprio(),
>>> +		.ki_write_hint = file_write_hint(filp),
>>
>> And we'll need to distinguish between the per-inode and per file
>> hint.  I.e. don't blindly initialize ki_write_hint to the per-inode
>> one here, but make that conditional in the file operation.
> 
> Maybe someone wants to do direct-io with partions where each partition
> has a different default "hint" when not provided a per-io hint? I don't
> know of such a case, but it doesn't sound terrible. In any case, I feel
> if you're directing writes through these interfaces, you get to keep all
> the pieces: user space controls policy, kernel just provides the
> mechanisms to do it.

Is it important to support partitions on top of FDP namespaces? We could
follow the example of zoned block devices and not support partitions on
top of FDP devices. From block/core.c, function add_partition():

	/*
	 * Partitions are not supported on zoned block devices that are used as
	 * such.
	 */
	if (bdev_is_zoned(disk->part0)) {
		pr_warn("%s: partitions not supported on host managed zoned block 
device\n",
			disk->disk_name);
		return ERR_PTR(-ENXIO);
	}

Thanks,

Bart.


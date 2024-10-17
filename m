Return-Path: <io-uring+bounces-3795-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A2669A283E
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 18:15:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3EE471F22925
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 16:15:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5015013B5B6;
	Thu, 17 Oct 2024 16:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Wchb2Z5X"
X-Original-To: io-uring@vger.kernel.org
Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29EB7DA84;
	Thu, 17 Oct 2024 16:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729181745; cv=none; b=HYA6lVXDSMU5aLVVXkZAcFZHo9WEMQnD+RojwqhLS8oNt3gaJlfEiH4qCdP9CHJ/7ss2SrUJX/Rx3SrpeW+5pvQAuzqQeKZnurGaget/lQuZdpdePJnTBYIVh1rV8moaYKKZiMHVLGqPgA6X9ZKvDWEagaMQMdRi/dFoHmOWSEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729181745; c=relaxed/simple;
	bh=zHcihhJxzUl73rzLdnTyPA7to6bVri5EKZRmag60bvA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O88Ccu+PFTir69Q5WckBh8xhlnSlumdcpoqMwKMgjMqioQFnUQCYLz+w5x0wl9bczdo2laxAk/ue6GeQVqiVqVcKGt6Qh9pKyn5faMi3PWlE0f8mBycUb8hzQpCMU6YOm4Hf3/hE1Rg/yEVT/zPhpgO9Sl+u7CvnKbT4ygv4MSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Wchb2Z5X; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XTtH262R8z6ClY9q;
	Thu, 17 Oct 2024 16:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729181730; x=1731773731; bh=eOvuzv/ivWqYohoOrZsk5GZx
	XsPGRis/218uLdUYAGI=; b=Wchb2Z5XYlvD9yLHrkWMJ6WZ18gP6EzjpoiMon7w
	/ioP2BWSDakTfnlY9OKkoEjRyzCE2NOOA18+7w41OSCq0uXcSnxahdlv9J0aiPEW
	QgakT5aZFbr0akzCcs2YLtQ65bxWjFRd42Uw4sow2fAxYDW7xum2vunzfqAbpOdN
	wAvlVAszWgYMPxmJkBivBK0AyykLmVV2k+9Znv/0hwxsQlvsKVePSBGAyJBX01e+
	QZS1/pTpqYT9bJvAKIITbijxh8ut7514vlLSZeturgZkOCEfwQroFlQvQC8d1wSb
	gsv59uKMu29HvZspqvF5XwKGHg8pluu4iD6ys3S5/VrpBA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id tuKOjPfACqLi; Thu, 17 Oct 2024 16:15:30 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2e14:8:c8b0:b4d2:d689:c93d] (unknown [104.135.204.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XTtGj6bSlz6ClSqH;
	Thu, 17 Oct 2024 16:15:25 +0000 (UTC)
Message-ID: <37af5088-6f09-4e75-b5d0-559e92d625bb@acm.org>
Date: Thu, 17 Oct 2024 09:15:21 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
To: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, hare@suse.de,
 sagi@grimberg.me, martin.petersen@oracle.com, brauner@kernel.org,
 viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org, bcrl@kvack.org,
 dhowells@redhat.com, asml.silence@gmail.com, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, linux-aio@kvack.org, gost.dev@samsung.com,
 vishak.g@samsung.com, javier.gonz@samsung.com
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com>
 <20240930181305.17286-1-joshi.k@samsung.com> <20241015055006.GA18759@lst.de>
 <8be869a7-c858-459a-a34b-063bc81ce358@samsung.com>
 <20241017152336.GA25327@lst.de>
 <ZxEw5-l6DtlXCQRO@kbusch-mbp.dhcp.thefacebook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZxEw5-l6DtlXCQRO@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/24 8:44 AM, Keith Busch wrote:
> On Thu, Oct 17, 2024 at 05:23:37PM +0200, Christoph Hellwig wrote:
>> If you want to do useful stream separation you need to write data
>> sequentially into the stream.  Now with streams or FDP that does not
>> actually imply sequentially in LBA space, but if you want the file
>> system to not actually deal with fragmentation from hell, and be
>> easily track what is grouped together you really want it sequentially
>> in the LBA space as well.  In other words, any kind of write placement
>> needs to be intimately tied to the file system block allocator.
> 
> I'm replying just to make sure I understand what you're saying:
> 
> If we send per IO hints on a file, we could have interleaved hot and
> cold pages at various offsets of that file, so the filesystem needs an
> efficient way to allocate extents and track these so that it doesn't
> interleave these in LBA space. I think that makes sense.
> 
> We can add a fop_flags and block/fops.c can be the first one to turn it
> on since that LBA access is entirely user driven.

Does anyone care about buffered I/O to block devices? When using
buffered I/O, the write_hint information from the inode is used and the 
per I/O write_hint information is ignored.

Thanks,

Bart.


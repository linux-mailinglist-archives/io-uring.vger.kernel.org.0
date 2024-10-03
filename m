Return-Path: <io-uring+bounces-3400-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CDB3598F978
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 00:00:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 857DE280A12
	for <lists+io-uring@lfdr.de>; Thu,  3 Oct 2024 22:00:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BBD2186E3C;
	Thu,  3 Oct 2024 22:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ZJIG9etA"
X-Original-To: io-uring@vger.kernel.org
Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09070224D1;
	Thu,  3 Oct 2024 22:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727992834; cv=none; b=t7dI7ltpnhtrCSAGXnoHW5+2Vi/j0lK6a4CG1o/lHDFwCgkEhbF6akC7QHa6BRxyE+sqQ17z8/IBUPydVjhXI03/3VuUtHr/s0iWDHRQhlluRKMyMAKhooX4aFIrikq64VrJsFH2RdKH9yiJx3oIOn2FbB4KwAsfmIW/M8VGnMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727992834; c=relaxed/simple;
	bh=IVj+wSsh4cf2uBOXlAJ67cfhtx5pQhOFpZ/jN++jz9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nJVcVaLtf4tvkKwfQl01weDs/eCXw5mzQf9LIAYPxHMi0Mtiu+SZn58vsFP3gp+yvkDGKn8TbT0NEFZQgDsGig2wiUlnywCRdP8qVy51mqKqUHEk4jCIU6FiUV30O81+nIesbeFVIKDxymS9TIHxO/Ru9ejBmjh4r5ccdmtQucA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ZJIG9etA; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XKQbN2JFNz6ClY9l;
	Thu,  3 Oct 2024 22:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727992824; x=1730584825; bh=IVj+wSsh4cf2uBOXlAJ67cfh
	tx5pQhOFpZ/jN++jz9o=; b=ZJIG9etAuWeFo63DpU/5WwAcTYG/bRzhE3wzJYpQ
	oBlGAqnYxaBh+QVigZvS9kx6RYYOZkfl6xWqBUAt5BVnOJSoB3q4q6cz80o8aYvJ
	K2Shx0X1Rp/EttqJZWDy1nQ6nicWBMBk+7kCwtNmFw+8iVQtNCfTlmrvnNek6vK3
	GkKMMCgkVLY6o5Oh/Z4Iv/qfKoyZ6UHjK1sTb06NdoazfzcJ6+H21i5awSnrXFG7
	OxNoUffo9CbUWoWkio1vBZYQ5+rzzbgzGlhV/SS55svleC/L/5mWsp8qzDkBhGd4
	45/JSp1kRUppFi4ixDePMIhrbbHgu2ZYiwFaYBROcz6N7g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TAmCIb-0ZlQg; Thu,  3 Oct 2024 22:00:24 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XKQbB4FqSz6ClY9k;
	Thu,  3 Oct 2024 22:00:22 +0000 (UTC)
Message-ID: <abd54d3a-3a5e-4ddc-9716-f6899512a3a4@acm.org>
Date: Thu, 3 Oct 2024 15:00:21 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
To: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
 hare@suse.de, sagi@grimberg.me, brauner@kernel.org, viro@zeniv.linux.org.uk,
 jack@suse.cz, jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com,
 asml.silence@gmail.com, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, linux-aio@kvack.org, gost.dev@samsung.com,
 vishak.g@samsung.com, javier.gonz@samsung.com
References: <20241001092047.GA23730@lst.de>
 <99c95f26-d6fb-4354-822d-eac94fdba765@kernel.dk>
 <20241002075140.GB20819@lst.de>
 <f14a246b-10bf-40c1-bf8f-19101194a6dc@kernel.dk>
 <20241002151344.GA20364@lst.de>
 <Zv1kD8iLeu0xd7eP@kbusch-mbp.dhcp.thefacebook.com>
 <20241002151949.GA20877@lst.de> <yq17caq5xvg.fsf@ca-mkp.ca.oracle.com>
 <a8b6c57f-88fa-4af0-8a1a-d6a2f2ca8493@acm.org>
 <20241003125516.GC17031@lst.de> <Zv8RQLES1LJtDsKC@kbusch-mbp>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <Zv8RQLES1LJtDsKC@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/3/24 2:48 PM, Keith Busch wrote:
> The only "bonus" I have is not repeatedly explaining why people can't
> use h/w features the way they want.

Hi Keith,

Although that's a fair argument, what are the use cases for this patch
series? Filesystems in the kernel? Filesystems implemented in user
space? Perhaps something else?

This patch series adds new a new user space interface for passing hints
to storage devices (in io_uring). As we all know such interfaces are
hard to remove once these have been added.

We don't need new user space interfaces to support FDP for filesystems
in the kernel.

For filesystems implemented in user space, would using NVMe pass-through
be a viable approach? With this approach, no new user space interfaces
have to be added.

I'm wondering how to unblock FDP users without adding a new
controversial mechanism in the kernel.

Thanks,

Bart.



Return-Path: <io-uring+bounces-5423-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AAB049EBC5D
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 22:59:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E643284EE1
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 21:59:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 992D823874D;
	Tue, 10 Dec 2024 21:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tMCA32fv"
X-Original-To: io-uring@vger.kernel.org
Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90E5232373;
	Tue, 10 Dec 2024 21:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733867937; cv=none; b=DJ3z29B7gXqLKN84tAbMpRC15UUm29N2jq0UzC820vUBdAG/8Lu25I+PI9pPekU01+E8J8b95dLVAicVGYeNUMgeuYD3qUCMdZw086wrMyrIC2650r1Gv0xg1BBp83KY7s3NUrUABtVEEbl66d5KoTG8yIN+TLmMGfHpOvp+tO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733867937; c=relaxed/simple;
	bh=UMPKRvLE/QQ5urEMkscdu5mz7RjqxapRnt91HnvSfRk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WYC8BSCs5vVpWqHC4VuKlYdRw2k/pXq4Gwta7clHBkiW55glnL7f5w40emxYOHsJyT0TGtBmA4/bAa96la4YyKJN0ksygmaxxjDphBTJzRY+IA2TmeU1ibmwaCbF8uKGPaQNaPuG5o4sPk0WkjtuG1hMzTSzuk+Uaiv5tJ9Min0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tMCA32fv; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Y7CL7128Qz6Cl4Ph;
	Tue, 10 Dec 2024 21:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1733867915; x=1736459916; bh=UMPKRvLE/QQ5urEMkscdu5mz
	7RjqxapRnt91HnvSfRk=; b=tMCA32fv2C7drEaWNjV7OlmjiTUE1Jwpz1HdJrFT
	DM0W9B1dfiXNGJxiycfCASwnzZaeUDrqagCcJWI8nxwp1EOG0batI29+/QZo9VDM
	LyNaOGM7xTwKNqaUK6PZ06lrIt4Q3yH5lK68FuUl1kz3x56n1/+1laEEN/ZMsSNX
	tbJ8lJY6/NDCYfrlmkZAuqimyIa+kGovBvI3hUJPiIWQssGG9lwkOVGSpcB1mLHj
	fxdNAfwESyPELGpMs85DAsyD/ineFXbI2U3TAPnHhBURBgOFRMFHL0arK8Dvq57Q
	xOPOqlyEyRUhE5CtyKGYC+iG0kCBY/I7cD7ErE5b/8qN1A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id KSORL8SM_ZVp; Tue, 10 Dec 2024 21:58:35 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Y7CKg6tF3z6ClH0D;
	Tue, 10 Dec 2024 21:58:31 +0000 (UTC)
Message-ID: <6d65d744-abed-405b-8116-b291b33796b0@acm.org>
Date: Tue, 10 Dec 2024 13:58:30 -0800
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
References: <yq1ed38roc9.fsf@ca-mkp.ca.oracle.com>
 <9d61a62f-6d95-4588-bcd8-de4433a9c1bb@acm.org>
 <yq1plmhv3ah.fsf@ca-mkp.ca.oracle.com>
 <8ef1ec5b-4b39-46db-a4ed-abf88cbba2cd@acm.org>
 <yq1jzcov5am.fsf@ca-mkp.ca.oracle.com>
 <CGME20241205081138epcas5p2a47090e70c3cf19e562f63cd9fc495d1@epcas5p2.samsung.com>
 <20241205080342.7gccjmyqydt2hb7z@ubuntu>
 <yq1a5d9op6p.fsf@ca-mkp.ca.oracle.com>
 <d9cc57b5-d998-4896-b5ec-efa5fa06d5a5@acm.org>
 <yq1frmwl1zf.fsf@ca-mkp.ca.oracle.com>
 <20241210095333.7qcnuwvnowterity@ubuntu>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241210095333.7qcnuwvnowterity@ubuntu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/10/24 1:53 AM, Nitesh Shetty wrote:
> We did implement payload based approach in the past[1] which aligns
> with this. Since we wait till the REQ_OP_COPY_SRC completes, there won't
> be issue with async type of dm IOs.
> Since this would be an internal kernel plumbing, we can optimize/change
> the approach moving forward.
> If you are okay with the approach, I can give a respin to that version.

Yes, I remember this. Let's wait with respinning/reposting until there
is agreement about the approach for copy offloading.

Thanks,

Bart.



Return-Path: <io-uring+bounces-4611-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99D949C4402
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 18:46:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EF1B284AAF
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 17:46:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38A6D1A0B15;
	Mon, 11 Nov 2024 17:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="mX9ZYwAQ"
X-Original-To: io-uring@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F1080034;
	Mon, 11 Nov 2024 17:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731347172; cv=none; b=L4sp2epDaTQphVmCaKxSFcNb7Q3oDYmG8BE7WwFukGGJT9JHgX33wj2Ykmkvq3XzlhQITPrvn5XVtj2c5AOK/1wfLXLa3uWZCGFN1paB04hH+QEXsgMGVHs6slZU4zxEanyfFWeCkUkEk4c2+ba2DDPgZN1xmc3GpdIjb1qvHMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731347172; c=relaxed/simple;
	bh=6ppk20l+MIKGQy5QjkyHIsmJX4tQUn28i+WnIW20g4w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i7AgUUVFaP9xlPasNKE8UkEdFwpe4t15IyuVTc9XRpEvK558FV+XuLxh6fXQ4X1nft7EJV++QaYKisu3P33khr1PO9Y5yEDe8xgiYRo3r1BwJOwoyPSrwBvw+cWiHx/2xaFWMKD+nWgWIU3rJziX9lpATt4mfrwZlwD54Hy1nZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=mX9ZYwAQ; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XnH5s4cJ7zlgT1M;
	Mon, 11 Nov 2024 17:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1731347165; x=1733939166; bh=EQ/YSyflFEK19dUNwksnyjAZ
	emqpoYotz99gNmDJJn4=; b=mX9ZYwAQ12bes+QJxHZczpD/MW1jRHfypLnkeTdB
	k0Efuu2qex5Us0NBWkQxjuTwVNsVzvgjhNuNQ6zReqbUcYPKUZmkbnvWKTAWm4at
	QGP4Mz4eA0g2yL7QZD+pY7yN3J8/PJjwwt3QibPgwKvaiHfKDvG+i+MrI1b1Rz2a
	eHouoKmM7l7wBGgVxxnhFibo1NYIq8vCHCVIoK6Cv5ut+XueS1VI4vHg8SJ6vmlq
	WvVBb3KRZ1ZZInrKrR7adRI71uGvrSpCJdNF7MIfYqbG4syzoiH1RdHxCALcisbC
	S8GaW0PJtFza68WV4T+GMU8wZGXWoHvCl2t2cFHFG6VqEw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lK5eOCQPE44g; Mon, 11 Nov 2024 17:46:05 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XnH5h3H2BzlgTWG;
	Mon, 11 Nov 2024 17:46:00 +0000 (UTC)
Message-ID: <a7ebd158-692c-494c-8cc0-a82f9adf4db0@acm.org>
Date: Mon, 11 Nov 2024 09:45:56 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
To: Javier Gonzalez <javier.gonz@samsung.com>
Cc: Matthew Wilcox <willy@infradead.org>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "joshi.k@samsung.com" <joshi.k@samsung.com>
References: <20241029151922.459139-1-kbusch@meta.com>
 <20241105155014.GA7310@lst.de> <Zy0k06wK0ymPm4BV@kbusch-mbp>
 <20241108141852.GA6578@lst.de> <Zy4zgwYKB1f6McTH@kbusch-mbp>
 <CGME20241108165444eucas1p183f631e2710142fbbc7dee9300baf77a@eucas1p1.samsung.com>
 <Zy5CSgNJtgUgBH3H@casper.infradead.org>
 <d7b7a759dd9a45a7845e95e693ec29d7@CAMSVWEXC02.scsc.local>
 <2b5a365a-215a-48de-acb1-b846a4f24680@acm.org>
 <20241111093154.zbsp42gfiv2enb5a@ArmHalley.local>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241111093154.zbsp42gfiv2enb5a@ArmHalley.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/11/24 1:31 AM, Javier Gonzalez wrote:
> On 08.11.2024 10:51, Bart Van Assche wrote:
>> On 11/8/24 9:43 AM, Javier Gonzalez wrote:
>>> If there is an interest, we can re-spin this again...
>>
>> I'm interested. Work is ongoing in JEDEC on support for copy offloading
>> for UFS devices. This work involves standardizing which SCSI copy
>> offloading features should be supported and which features are not
>> required. Implementations are expected to be available soon.
> 
> Do you have any specific blockers on the last series? I know you have
> left comments in many of the patches already, but I think we are all a
> bit confused on where we are ATM.

Nobody replied to this question that was raised 4 months ago:
https://lore.kernel.org/linux-block/4c7f30af-9fbc-4f19-8f48-ad741aa557c4@acm.org/

I think we need to agree about the answer to that question before we can
continue with implementing copy offloading.

Thanks,

Bart.




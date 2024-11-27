Return-Path: <io-uring+bounces-5094-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DD409DAEC8
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 22:09:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4103016616E
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 21:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 420A214658C;
	Wed, 27 Nov 2024 21:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="uCEoSSMJ"
X-Original-To: io-uring@vger.kernel.org
Received: from 001.lax.mailroute.net (001.lax.mailroute.net [199.89.1.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BCC140E38;
	Wed, 27 Nov 2024 21:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732741754; cv=none; b=MiQ5Hw5aYT/+pJivCPZWu/lBJvjfWOkc+pNle+jOUvbFaSKpWZMB9+ZIAjhV70x1naekDpBEAOhXBU2mn8SdGUn6DRV/9zGJH95c6qznuoM0wbG0yffpaon7f3aF7DmbVA9Dh1FEjNb2x+IRz1hxbQmyd8Z63Lrk8mair08M2zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732741754; c=relaxed/simple;
	bh=D5XBnnBSHb+YFe5/5cmsGkYiGUO3cyT7bmOr+0fb0Ys=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YE6TLVd2k7NpuElKYxRaiFnhiYlxOV3cdw25vQB+k8OQm1kICgVpJmae5cRMf7hjXDElJGOlUEVruok2V5ixptbRlZMtM5G3RDvwjTNQqY11rriotfCaLPp97cY+wIm9kG7sYmP5ZK6cIu6s/WSkv03yA/wHd4onfjMtzj7XAB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=uCEoSSMJ; arc=none smtp.client-ip=199.89.1.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 001.lax.mailroute.net (Postfix) with ESMTP id 4XzBnh0yn9zCm9g;
	Wed, 27 Nov 2024 21:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732741585; x=1735333586; bh=ISWmwIbPKWfnjDw9QIg1JLPO
	j+G2EW60oaWfrSMy0X4=; b=uCEoSSMJdJz7xp88pY1TWob0jGDsqDNccGMqS43u
	t5Z4bVukZBCn6nC6PMTFXOnHMzPBWW2zKn/aCxyRBv4nwjGB7o5mw659cFHHaYM4
	HXR1VdI28t5MqtRgLAccV10Xn9SQbt6vuR+yU+Ot3NCOtIUehoYfemN/zz4dMywy
	lmfUsQA/pf/KYtnsGVSShANNiEx7oCSbheaKC5pZRww61kY0mUq5ASvHtczAaX2n
	wlG1kxyWGAXUY0rcNElD+heejviIukL/DvU79d56l6Z/RT7YZWxA0N3q9mxIa/ee
	kJMK3rsFLKILTjEKHplUUCazHjODyGjOQvo+7SkBzixi3w==
X-Virus-Scanned: by MailRoute
Received: from 001.lax.mailroute.net ([127.0.0.1])
 by localhost (001.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9S9ba-RE9LAW; Wed, 27 Nov 2024 21:06:25 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 001.lax.mailroute.net (Postfix) with ESMTPSA id 4XzBnR0q0kzCm9f;
	Wed, 27 Nov 2024 21:06:18 +0000 (UTC)
Message-ID: <7835e7e2-2209-4727-ad74-57db09e4530f@acm.org>
Date: Wed, 27 Nov 2024 13:06:17 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
To: "Martin K. Petersen" <martin.petersen@oracle.com>
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
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <yq1jzcov5am.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/27/24 12:14 PM, Martin K. Petersen wrote:
> Once I had support for token-based copy offload working, it became clear
> to me that this approach is much simpler than pointer matching, bio
> pairs, etc. The REQ_OP_COPY_IN operation and the REQ_OP_COPY_OUT
> operation are never in flight at the same time. There are no
> synchronization hassles, no lifetimes, no lookup tables in the sd
> driver, no nonsense. Semantically, it's a read followed by a write.

What if the source LBA range does not require splitting but the
destination LBA range requires splitting, e.g. because it crosses a
chunk_sectors boundary? Will the REQ_OP_COPY_IN operation succeed in
this case and the REQ_OP_COPY_OUT operation fail? Does this mean that a
third operation is needed to cancel REQ_OP_COPY_IN operations if the
REQ_OP_COPY_OUT operation fails?

Additionally, how to handle bugs in REQ_OP_COPY_* submitters where a
large number of REQ_OP_COPY_IN operations is submitted without
corresponding REQ_OP_COPY_OUT operation? Is perhaps a mechanism required
to discard unmatched REQ_OP_COPY_IN operations after a certain time?

> Aside from making things trivially simple, the COPY_IN/COPY_OUT semantic
> is a *requirement* for token-based offload devices.

Hmm ... we may each have a different opinion about whether or not the 
COPY_IN/COPY_OUT semantics are a requirement for token-based copy
offloading.

Additionally, I'm not convinced that implementing COPY_IN/COPY_OUT for
ODX devices is that simple. The COPY_IN and COPY_OUT operations have
to be translated into three SCSI commands, isn't it? I'm referring to
the POPULATE TOKEN, RECEIVE ROD TOKEN INFORMATION and WRITE USING TOKEN
commands. What is your opinion about how to translate the two block
layer operations into these three SCSI commands?

> Why would we even consider having two incompatible sets of copy
> offload semantics coexist in the block layer?
I am not aware of any proposal to implement two sets of copy operations
in the block layer. All proposals I have seen so far involve adding a
single set of copy operations to the block layer. Opinions differ
however about whether to add a single copy operation primitive or
separate IN and OUT primitives.

Thanks,

Bart.





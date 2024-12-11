Return-Path: <io-uring+bounces-5445-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6F019ED35D
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 18:27:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00515283439
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 17:27:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 732251FECC0;
	Wed, 11 Dec 2024 17:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Jn6+ZsKH"
X-Original-To: io-uring@vger.kernel.org
Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA9F1FECB6;
	Wed, 11 Dec 2024 17:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733938049; cv=none; b=EZZ+3HBvvSs7MlvLquVmIO66jtk9xJJTSy3Q9P0djAjJg378sLKxIRg3JbrLzAXQdcT4slPDUta7NrKR6c99gIoWNeUGR5r4YfOpdLkZLX0ifFnmbhDX3g6v3VWECjilP0T9VvFb3oYjfzK6jaZW1wn/EDCh5Afk2l8HQQqgno8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733938049; c=relaxed/simple;
	bh=uerRqakrwvO4G34fxy4mWJpHc8Jzm+HfcVjh/HslRvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lh66R23qBQiG1bmMndl5vywrupKsSCqTMrD7pvNbYULN+hRH9i47VX0lC5jK6UtSHF39xn5BWuU4Czi/tx88abI6lL/WnFe5Dg2DYVjkaoVS8OSC15kvET6jNbOhPZXn/mnrj6hqf1nS8ouxMiVeTiY5qbwkmovX/G2UkpeB6UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Jn6+ZsKH; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Y7jGQ6jb4z6Cr2Gt;
	Wed, 11 Dec 2024 17:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1733938040; x=1736530041; bh=gmWh5tFfs7soVBLFuSO/qLnX
	u+8CTMZDvRiQMaBPqDA=; b=Jn6+ZsKHbREar6WFe1GZ0ByPNPgeHh1eoVH5k3Bf
	mH/A5t7lCLVsuWak0fNQXlIKOfzO8126Uzjxaba+goDPEjzFT9AjaBJtIULKzqe0
	9IWyuEoe9yd53BI+GN7KPYPmZUQw52b/ofwJJtzgSSYTRROAPtiBuqxT82oaIDf0
	HpAedfiM8HBcDPijE4nqorCERsOU0bxylbNfd0qb4M7fHn2k9LptP8qKw51lM4H9
	G1dmjVSE85gGToRztGnGgtDPO/kpi57nFluPjq0j5JEQ0KcPP4ChqlvrsRIflYeH
	ORJIpf7HL5DSubgUBgwRZ2ik7TSML8T1sqIGrppT0jkkhA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7pH0caqGSLM7; Wed, 11 Dec 2024 17:27:20 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Y7jGC4KWJz6Cr2Fp;
	Wed, 11 Dec 2024 17:27:14 +0000 (UTC)
Message-ID: <2f260b23-006a-4ea2-a508-39f2bace1bec@acm.org>
Date: Wed, 11 Dec 2024 09:27:13 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
To: Nitesh Shetty <nj.shetty@samsung.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Javier Gonzalez <javier.gonz@samsung.com>,
 Matthew Wilcox <willy@infradead.org>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "joshi.k@samsung.com" <joshi.k@samsung.com>
References: <9d61a62f-6d95-4588-bcd8-de4433a9c1bb@acm.org>
 <yq1plmhv3ah.fsf@ca-mkp.ca.oracle.com>
 <8ef1ec5b-4b39-46db-a4ed-abf88cbba2cd@acm.org>
 <yq1jzcov5am.fsf@ca-mkp.ca.oracle.com>
 <CGME20241205081138epcas5p2a47090e70c3cf19e562f63cd9fc495d1@epcas5p2.samsung.com>
 <20241205080342.7gccjmyqydt2hb7z@ubuntu>
 <yq1a5d9op6p.fsf@ca-mkp.ca.oracle.com>
 <d9cc57b5-d998-4896-b5ec-efa5fa06d5a5@acm.org>
 <yq1frmwl1zf.fsf@ca-mkp.ca.oracle.com>
 <7d06cc60-7640-4431-a1cb-043a959e2ff3@acm.org>
 <20241211093549.n6dvl6c6xp4blccd@ubuntu>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241211093549.n6dvl6c6xp4blccd@ubuntu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/11/24 1:36 AM, Nitesh Shetty wrote:
> Block layer can allocate a buffer and send this as part of copy
> operation.

The block layer can only do that if it knows how large the buffer should
be. Or in other words, if knowledge of a SCSI buffer size is embedded in
the block layer. That doesn't sound ideal to me.

> This scheme will require sequential submission of SRC and DST
> bio's. This might increase in latency, but allows to have simpler design.
> Main use case for copy is GC, which is mostly a background operation.

I still prefer a single REQ_OP_COPY operation instead of separate
REQ_OP_COPY_SRC and REQ_OP_COPY_DST operations. While this will require
additional work in the SCSI disk (sd) driver (implementation of a state
machine), it prevents that any details about the SCSI copy offloading
approach have to be known by the block layer. Even if copy offloading
would be implemented as two operations (REQ_OP_COPY_SRC and 
REQ_OP_COPY_DST), a state machine is required anyway in the SCSI disk
driver because REQ_OP_COPY_SRC would have to be translated into two SCSI
commands (POPULATE TOKEN + RECEIVE ROD TOKEN INFORMATION).

Thanks,

Bart.



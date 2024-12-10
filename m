Return-Path: <io-uring+bounces-5374-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 13F7E9EA3F7
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 01:59:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 047A61888B2D
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 00:59:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C46DC34CF5;
	Tue, 10 Dec 2024 00:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rSs6/jmD"
X-Original-To: io-uring@vger.kernel.org
Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AB320326;
	Tue, 10 Dec 2024 00:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733792336; cv=none; b=U9QOOfkS4kNb2Szxx7hw2qFuMauuFfXqRKco3WqqR0J5Bjnoo59SEG8nJA/QLX/40g5asKB9A0/BXnqXmUntK01PDQwoNd2WLOZF/Owlfj7rceM9rIEA3L5occlbZrTojDqBLe6H7x43MPNV9FGs6ei8xO9/AkKghC2NF5RFRb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733792336; c=relaxed/simple;
	bh=2ha5juZozT1S+bmyy87AlWutjDHhvcSbGzjh2S21aiA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UQT4EtylDgLkz2LCpfAMTKCzJ+Tdv8UJjNPVf4gu5I4lUInSvYxr6aBbQKEqk130UCf24xPkCvbrYTDs3IvokIGrtetKxU1rfAMEHwaKbwCcC4yT7SUgw2Kp0fLqKFliZVSfhGuWJFXCpKymOcALyDXMmyQ7kho2hFumZHsfp5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rSs6/jmD; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Y6gNG49jVz6CmR09;
	Tue, 10 Dec 2024 00:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1733792329; x=1736384330; bh=2ha5juZozT1S+bmyy87AlWut
	jDHhvcSbGzjh2S21aiA=; b=rSs6/jmDn/Y/OH96L5spt8vRRuR9FhryXPB9vTf5
	6AT0rvoj0nksZYiYNsaoUm+BE4D518/24+d2k/kElivkfaAf5YJfROeS+JPp/LpD
	TBaNLcIl7eyN6wrS7Twdj+iRmywBK3olIKCS1+aqFOUpCo33ExOz66gT+ObqbxAj
	W40TtlY1RmyUwY+s7NnYGbIkXkussG0QSDusA5nrT/mWMkL9nMwSb+mx0BU4r+sq
	uEW27SIJomiowoAKfhb98QUXDp5lc8cwCgNjJ5M89Z6+w6mGCNuP/GoqFaKG3iyh
	rI1ika0Ls9Cm1Yr4CViB5Sp7KNNtlE65ZwAK/r3oD1wZ9A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Foi_Qj2DjOnW; Tue, 10 Dec 2024 00:58:49 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Y6gN53R2Rz6ClY8q;
	Tue, 10 Dec 2024 00:58:45 +0000 (UTC)
Message-ID: <d9cc57b5-d998-4896-b5ec-efa5fa06d5a5@acm.org>
Date: Mon, 9 Dec 2024 16:58:44 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Nitesh Shetty <nj.shetty@samsung.com>
Cc: Javier Gonzalez <javier.gonz@samsung.com>,
 Matthew Wilcox <willy@infradead.org>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "joshi.k@samsung.com" <joshi.k@samsung.com>
References: <d7b7a759dd9a45a7845e95e693ec29d7@CAMSVWEXC02.scsc.local>
 <2b5a365a-215a-48de-acb1-b846a4f24680@acm.org>
 <20241111093154.zbsp42gfiv2enb5a@ArmHalley.local>
 <a7ebd158-692c-494c-8cc0-a82f9adf4db0@acm.org>
 <20241112135233.2iwgwe443rnuivyb@ubuntu>
 <yq1ed38roc9.fsf@ca-mkp.ca.oracle.com>
 <9d61a62f-6d95-4588-bcd8-de4433a9c1bb@acm.org>
 <yq1plmhv3ah.fsf@ca-mkp.ca.oracle.com>
 <8ef1ec5b-4b39-46db-a4ed-abf88cbba2cd@acm.org>
 <yq1jzcov5am.fsf@ca-mkp.ca.oracle.com>
 <CGME20241205081138epcas5p2a47090e70c3cf19e562f63cd9fc495d1@epcas5p2.samsung.com>
 <20241205080342.7gccjmyqydt2hb7z@ubuntu>
 <yq1a5d9op6p.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <yq1a5d9op6p.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/24 12:37 PM, Martin K. Petersen wrote:
> For token based offload, I really don't understand the objection to
> storing the cookie in the bio. I fail to see the benefit of storing the
> cookie in the driver and then have the bio refer to something else which
> maps to the actual cookie returned by the storage.
Does "cookie" refer to the SCSI ROD token? Storing the ROD token in the
REQ_OP_COPY_DST bio implies that the REQ_OP_COPY_DST bio is only
submitted after the REQ_OP_COPY_SRC bio has completed. NVMe users may
prefer that REQ_OP_COPY_SRC and REQ_OP_COPY_DST bios are submitted
simultaneously.

Thanks,

Bart.


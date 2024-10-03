Return-Path: <io-uring+bounces-3390-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B8BB098E7B5
	for <lists+io-uring@lfdr.de>; Thu,  3 Oct 2024 02:20:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 602D81F22B77
	for <lists+io-uring@lfdr.de>; Thu,  3 Oct 2024 00:20:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AFE563CB;
	Thu,  3 Oct 2024 00:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="q4Q10RP3"
X-Original-To: io-uring@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0D064A;
	Thu,  3 Oct 2024 00:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727914847; cv=none; b=UAolAD5AGZfd4pY9+InxaD3RUZARDHvnehZuzVa7BV3MHRRZEftGj8uaFzPycStYoAxtN90pPwcnvMwa+O2fpabU6DS4XtXIwFhaB/rb5s2Jj6HQ9EjoMKxaWB40SrFc3yspdqjHNAdA+L9xSO9KthyOndU7Kwv1R8R1QapzPJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727914847; c=relaxed/simple;
	bh=fNsT/Ir6QY/XIv84TKawGit7Z43Us4YdiuXKg6+cAjk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=skJivGWyXMP9QSy7egeTTu4+AaTWSbSYlKAnW+pEtBI9rQngsN195gaxzrnQfLqK6vipEY7REngkYIlakD25JtdGtckvT6+amYXcuskYMXjWj+4hb5D9W2didNbcdilG5XBa3bpP8wrAvvRWK3SBRTZoEMWGlFpud983uQZgbLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=q4Q10RP3; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XJslc5hknzlgMW9;
	Thu,  3 Oct 2024 00:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727914839; x=1730506840; bh=Oh0VWAuDQnXtvqrOgW+mdNBp
	O1eMzfyHq16DUHZnGIc=; b=q4Q10RP3cvtsde0sb2ibCa9e909lRJus9XrjroPK
	B+Vo8AEO2LHR4T59I2Vw8U7LuErXXaOZ3yQsZP4gHblTnU6tXSqsVRiXydJ7yCe0
	sGYpf69OhfMjsorv6slK6lRQXdgOKgUVgPoAHHWdk1O3+QW8Ogp8ku5bFmOnthYC
	oR2lvZRouL6esIoM3OM/Wr1bdJ+1nH5ZUYqTpkoKZLFYRN7Df7JUld7g2e/yiYag
	TQFHmM8W3jpPk/XHPMOnDjN52iYxzDWmChJP+gDGwkwrjCM2EufkemQO4zPUG+Ap
	pZK6LSrTtVI7ZPgT54P0IEFiPSWQH6iz6f8JUn2Om1hmmg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LlQiNrpWlL36; Thu,  3 Oct 2024 00:20:39 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XJslN5L2NzlgVnY;
	Thu,  3 Oct 2024 00:20:32 +0000 (UTC)
Message-ID: <052e0503-eb3f-4345-b366-1c0a2c4604a5@acm.org>
Date: Wed, 2 Oct 2024 17:20:25 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
To: Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, kbusch@kernel.org,
 hch@lst.de, hare@suse.de, sagi@grimberg.me, martin.petersen@oracle.com,
 brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
 jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com,
 asml.silence@gmail.com
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-block@vger.kernel.org, linux-aio@kvack.org,
 gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com>
 <20240930181305.17286-1-joshi.k@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240930181305.17286-1-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/24 11:13 AM, Kanchan Joshi wrote:
> Another spin to incorporate the feedback from LPC and previous
> iterations. The series adds two capabilities:
> - FDP support at NVMe level (patch #1)
> - Per-io hinting via io_uring (patch #3)
> Patch #2 is needed to do per-io hints.
> 
> The motivation and interface details are present in the commit
> descriptions.

Something is missing from the patch descriptions. What is the goal
of this patch series? Is the goal to support FDP in filesystems in
the kernel, is the goal to support filesystems implemented in user
space or perhaps something else? I think this should be mentioned in
the cover letter.

Thanks,

Bart.



Return-Path: <io-uring+bounces-3386-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5450898E2AD
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 20:37:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC548B227AE
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 18:37:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0A832141B1;
	Wed,  2 Oct 2024 18:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QVx1wWKl"
X-Original-To: io-uring@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EBC212F13;
	Wed,  2 Oct 2024 18:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727894242; cv=none; b=UsBTNVrRCqbfPoKQxZKENtpZITu9GBjNLjMAqrmvTR+G4dMGiJJqIqiw0M4xkoInNMb4oEGYKU02sUsRjZigaeDzZ+IoBsGZ3k+2Ulw9AVaXM8HhVnVC2Qsx3H9VslR9mUvHTN0iVslgaTaR17PvvlcXYlnxT7kknsvL2RMpF+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727894242; c=relaxed/simple;
	bh=msKaBRcTblAvNH8BTmUzvz0ZQ/WRHuI4LW0WaZWGq5s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nhK0D1+ypYPKTtQ/UjOeCHy8EfppAEK2xB5rW597TdaQwFGxy/2yO+bewhz1kZCy0blkOSlXq9oidfVOdpqYvTgR7/9XQoc91n8Czyt3B5VzwcocyKCK23xwxPDlsbIzn+Vd8g8o4nFq9r+fODD8GeRevY+WKNlZXKYX8UUMeS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QVx1wWKl; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XJk7N5N35zlgMWC;
	Wed,  2 Oct 2024 18:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727894234; x=1730486235; bh=gslW6VDOBWjnvqvcaaFUhPE4
	6K/gPY6VZ++uzHysEOA=; b=QVx1wWKlxWBzqLs+71Yxrsn7vyqP4TVpyyjoh4o2
	62HhZ9fJrKxzYpACINtvKg1BPuy36JCEx6L2R3GgrUAQx4XxWKYqNg0RsUMSC6u6
	Aiv/Wrtszkqi7GgdDWtE2cEVHSd8kOc0eNspvNP4435z4urSy/DT3l8U7Afatp4E
	m6rfDf24S/Nn+qdGk10CG2CQefu9V1C9BnvpwIoryOwRTdwarIgnbGqnx7uSSOf+
	3pRFx59bZ+poAt9n+LpCqnn5BZntK47T33xonOKSr5r48mOBmojUu8q3f6us64Kj
	4v1sVhZdMROcTC+UHMX15vGvroOFWLclvDkfowLn9WOudg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id W4xEJA9JNW7E; Wed,  2 Oct 2024 18:37:14 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XJk7C5sgTzlgMW9;
	Wed,  2 Oct 2024 18:37:11 +0000 (UTC)
Message-ID: <38daf18f-7637-4c27-9a43-67ad39dc15c0@acm.org>
Date: Wed, 2 Oct 2024 11:37:11 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/3] nvme: enable FDP support
To: Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, kbusch@kernel.org,
 hch@lst.de, hare@suse.de, sagi@grimberg.me, martin.petersen@oracle.com,
 brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
 jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com,
 asml.silence@gmail.com
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-block@vger.kernel.org, linux-aio@kvack.org,
 gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com,
 Hui Qi <hui81.qi@samsung.com>, Nitesh Shetty <nj.shetty@samsung.com>
References: <20240930181305.17286-1-joshi.k@samsung.com>
 <CGME20240930182056epcas5p33f823c00caadf9388b509bafcad86f3d@epcas5p3.samsung.com>
 <20240930181305.17286-2-joshi.k@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240930181305.17286-2-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/24 11:13 AM, Kanchan Joshi wrote:
> Flexible Data Placement (FDP), as ratified in TP 4146a, allows the host
> to control the placement of logical blocks so as to reduce the SSD WAF.
> 
> Userspace can send the data lifetime information using the write hints.
> The SCSI driver (sd) can already pass this information to the SCSI
> devices. This patch does the same for NVMe.
> 
> Fetch the placement-identifiers if the device supports FDP.
> The incoming write-hint is mapped to a placement-identifier, which in
> turn is set in the DSPEC field of the write command.

Is the description of this patch correct? The above description suggests
that FDP information is similar in nature to SCSI data lifetime
information. I don't think that's correct.

Thanks,

Bart.


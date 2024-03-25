Return-Path: <io-uring+bounces-1213-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B653588ACF1
	for <lists+io-uring@lfdr.de>; Mon, 25 Mar 2024 19:03:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79B4E3025F8
	for <lists+io-uring@lfdr.de>; Mon, 25 Mar 2024 18:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33C416F07D;
	Mon, 25 Mar 2024 17:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="H0iseS6v"
X-Original-To: io-uring@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735166CDCC;
	Mon, 25 Mar 2024 17:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711387404; cv=none; b=GkXciYHRrv1Sqq2nKK42MOGBbOuYds5ZtOiGygl8SK+NBrQNHzFD1U304qzM1XW7huswDUSht9aI0M5HlHRLkm9nLrNUrfrPFhl7/X/fjovfdNDMq2qGnrMHkgHdbK0lLEZvHweuwK+QR/93dNvol//1Xn+i9DxoK06XQByt+Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711387404; c=relaxed/simple;
	bh=1v8JTa2zwLY//oKs5JI1dBbv595ztN7DvLPvVEJBkpo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hMqvBNmlcFPGR9f4+fHmW3CUfN+DCBO03jk8cnkHSPaCzniFoXYzA0HV+xbjV0AdQtb6E99hPBL2nq6yGwBsPBCJNNEfRgriPDq2mdeZw+o/lpR2E0bB5IdbpcuZL5nRqW5V0UThgTjlU8MZBSXcSzjaTwtfIDhRGzx1nSQjIfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=H0iseS6v; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V3KX44rJvzlgVnN;
	Mon, 25 Mar 2024 17:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711387390; x=1713979391; bh=Fv7kCUT2BWY6M9OW2MD8hESk
	Xk9W04pTKWY7feKrcos=; b=H0iseS6vqhPg02EIP/7y4FKrmC142fEYuF4FWSqO
	ohcF4zANaSNf7Rx6TmIXcT1aMsdHTuIuH7MiUEEipMqk/ezAOAO+gMaJItvTluep
	Cc2W2D+VUaDZYOgUEHtfxjXsXMNDlHaZ3VA6QYtN0dRY8Me0Aj5V4oLG5+H62YHl
	90A0d96tyOIzqBzCwAs0RrEbXZH9KszAIqNnIXtbp/R97cf4F2d20EvcmSnPr455
	a43uNRWr7ATSRTZuanQ5SJdFJY4tkrnnd3qyRygoPWFxdBXQKQYT4CvhDVU4qwDx
	0q53ruY9j445njY1bAp7dRyVJOfySxMyZxv2hHlTdH32XQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id i0PMQCDUazuH; Mon, 25 Mar 2024 17:23:10 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V3KWw2sLbzlgTGW;
	Mon, 25 Mar 2024 17:23:08 +0000 (UTC)
Message-ID: <787fe4b7-a5af-4cd1-a7e8-8b9bad3be7d9@acm.org>
Date: Mon, 25 Mar 2024 10:23:07 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] Introduce per-task io utilization boost
Content-Language: en-US
To: Christian Loehle <christian.loehle@arm.com>,
 Qais Yousef <qyousef@layalina.io>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
 juri.lelli@redhat.com, mingo@redhat.com, rafael@kernel.org,
 dietmar.eggemann@arm.com, vschneid@redhat.com, vincent.guittot@linaro.org,
 Johannes.Thumshirn@wdc.com, adrian.hunter@intel.com, ulf.hansson@linaro.org,
 andres@anarazel.de, asml.silence@gmail.com, linux-pm@vger.kernel.org,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org,
 linux-mmc@vger.kernel.org
References: <20240304201625.100619-1-christian.loehle@arm.com>
 <86f0af00-8765-4481-9245-1819fb2c6379@acm.org>
 <0dc6a839-2922-40ac-8854-2884196da9b9@arm.com>
 <c5b7fc1f-f233-4d25-952b-539607c2a0cc@acm.org>
 <2784c093-eea1-4b73-87da-1a45f14013c8@arm.com>
 <20240321123935.zqscwi2aom7lfhts@airbuntu>
 <1ff973fc-66a4-446e-8590-ec655c686c90@arm.com>
 <2ed2dadc-bdc4-4a21-8aca-a2aac0c6479a@acm.org>
 <de1eba3c-2453-4c5c-bd80-dd7d7b33f60d@arm.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <de1eba3c-2453-4c5c-bd80-dd7d7b33f60d@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/25/24 05:06, Christian Loehle wrote:
> On 21/03/2024 19:52, Bart Van Assche wrote:
>> On 3/21/24 10:57, Christian Loehle wrote:
>>> In the long-term it looks like for UFS the problem will disappear as we are
>>> expected to get one queue/hardirq per CPU (as Bart mentioned), on NVMe that
>>> is already the case.
>>
>> Why the focus on storage controllers with a single completion interrupt?
>> It probably won't take long (one year?) until all new high-end
>> smartphones may have support for multiple completion interrupts.
> 
> Apart from going to "This patch shows significant performance improvements on
> hardware that runs mainline today" to "This patch will have significant
> performance improvements on devices running mainline in a couple years"
> nothing in particular.

That doesn't make sense to me. Smartphones with UFSHCI 4.0 controllers
are available from multiple vendors. See also 
https://en.wikipedia.org/wiki/Universal_Flash_Storage. See also
https://www.gsmarena.com/samsung_galaxy_s24-12773.php.

Bart.


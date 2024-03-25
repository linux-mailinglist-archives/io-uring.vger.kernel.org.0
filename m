Return-Path: <io-uring+bounces-1207-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8374388A59F
	for <lists+io-uring@lfdr.de>; Mon, 25 Mar 2024 16:01:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 204E830972A
	for <lists+io-uring@lfdr.de>; Mon, 25 Mar 2024 15:01:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10A1912D773;
	Mon, 25 Mar 2024 12:11:33 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 942095D731;
	Mon, 25 Mar 2024 12:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711368387; cv=none; b=amN3wMMKBM6R7th5n2yqIs7xKudbaP/lPS2NJ6+05zXzdRQDp2V9fISJoalpEYyA/4kRmPIlrTg5TozilRXHQnMnc2sq6kufB7h2OQ6qk1XYqjINN8CdBgVGEU5V5zoVvem5mxoSesjA2fad/h/Z/8CuNfyuHU+UKdhNRDrk0T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711368387; c=relaxed/simple;
	bh=yPtmna4ptGgXfkbENYERn+NKzVLez4o/N3DCc/GmLKI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h72srGKs/T4g7uwvsBa8cWauYTkJoEsvPUqtLGVWP/voNF6jNcFcOXWb13JclTySmn/7BljPaz8umAXfbRgEM/SI+3KI/dW6hVrFDnh4JxAg9v3xo5OHDBPr4rL9iW/BFX/Ngu0MsUtbNuk+W8Kiqu8McWKbelaNkm/9SUnXTGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 347BF1FB;
	Mon, 25 Mar 2024 05:06:55 -0700 (PDT)
Received: from [10.1.25.33] (e133047.arm.com [10.1.25.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 330623F67D;
	Mon, 25 Mar 2024 05:06:18 -0700 (PDT)
Message-ID: <de1eba3c-2453-4c5c-bd80-dd7d7b33f60d@arm.com>
Date: Mon, 25 Mar 2024 12:06:16 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] Introduce per-task io utilization boost
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>, Qais Yousef <qyousef@layalina.io>
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
From: Christian Loehle <christian.loehle@arm.com>
In-Reply-To: <2ed2dadc-bdc4-4a21-8aca-a2aac0c6479a@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 21/03/2024 19:52, Bart Van Assche wrote:
> On 3/21/24 10:57, Christian Loehle wrote:
>> In the long-term it looks like for UFS the problem will disappear as we are
>> expected to get one queue/hardirq per CPU (as Bart mentioned), on NVMe that
>> is already the case.
> 
> Why the focus on storage controllers with a single completion interrupt?
> It probably won't take long (one year?) until all new high-end
> smartphones may have support for multiple completion interrupts.
> 
> Thanks,
> 
> Bart.
> 

Apart from going to "This patch shows significant performance improvements on
hardware that runs mainline today" to "This patch will have significant
performance improvements on devices running mainline in a couple years"
nothing in particular.
I'm fine with leaving it with having acknowledged the problem.
Maybe I would just gate the task placement on the task having been in
UFS (with multiple completion interrupts) or NVMe submission recently to
avoid regressions to current behavior in future versions. I did have that
already at some point, although it was a bit hacky.
Anyway, thank you for your input on that, it is what I wanted to hear!

Kind Regards,
Christian


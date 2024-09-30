Return-Path: <io-uring+bounces-3326-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A06D498A993
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 18:17:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2ED11B27CA1
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 16:14:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76070193073;
	Mon, 30 Sep 2024 16:12:13 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E171192D97;
	Mon, 30 Sep 2024 16:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727712733; cv=none; b=YqpWUNYp904OtCJj0sV5fQYbafy9x4iFRmfJZMdyvzXNvL/reKtHa/t7uoFL4P4A5Q5nUzZsdfY1iGTZTtfvH2lYvpwReTxrfI1JaInERWgNF2MuNXDmCQQBzdQmHCnmllWF5SKc8qOoTWAlZalMyNy/JxJLOw65SJdkaudeJ9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727712733; c=relaxed/simple;
	bh=eK+/58ozFMgQNV61vEh1V5PhAb/8coUdXJxzT4Ha1Tw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uGg3BvYUedX91dw4tUpD3dyWNnBrzZDbMUDdY3Ltr0uX8GrZoM7wntGKihnNuix+AqK2BKgjl04M+A0fyCdGmB0SqyEUPIYCLIkM4lKUEQx62SQzUagwGe2w2YdTeLxgSKT1ueKq8SEXcMS99yG5XT47rEmWlgX0HZW5rEss/hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7FF8A367;
	Mon, 30 Sep 2024 09:12:39 -0700 (PDT)
Received: from [10.1.33.50] (e127648.arm.com [10.1.33.50])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AF3523F58B;
	Mon, 30 Sep 2024 09:12:05 -0700 (PDT)
Message-ID: <e343155e-63f9-4419-836a-0e23676ef72e@arm.com>
Date: Mon, 30 Sep 2024 17:12:03 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/8] cpuidle: Prefer teo over menu governor
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
 peterz@infradead.org, juri.lelli@redhat.com, mingo@redhat.com,
 dietmar.eggemann@arm.com, vschneid@redhat.com, vincent.guittot@linaro.org,
 Johannes.Thumshirn@wdc.com, adrian.hunter@intel.com, ulf.hansson@linaro.org,
 bvanassche@acm.org, andres@anarazel.de, asml.silence@gmail.com,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org, qyousef@layalina.io,
 dsmythies@telus.net, axboe@kernel.dk
References: <20240905092645.2885200-1-christian.loehle@arm.com>
 <20240905092645.2885200-3-christian.loehle@arm.com>
 <CAJZ5v0gKeHsvB_Jfja=yYLijhe9_dWSjCaMDtE2isOuJa6dy8w@mail.gmail.com>
Content-Language: en-US
From: Christian Loehle <christian.loehle@arm.com>
In-Reply-To: <CAJZ5v0gKeHsvB_Jfja=yYLijhe9_dWSjCaMDtE2isOuJa6dy8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 9/30/24 16:06, Rafael J. Wysocki wrote:
> On Thu, Sep 5, 2024 at 11:27 AM Christian Loehle
> <christian.loehle@arm.com> wrote:
>>
>> Since menu no longer has the interactivity boost teo works better
>> overall, so make it the default.
>>
>> Signed-off-by: Christian Loehle <christian.loehle@arm.com>

First of all thank you for taking a look.

> 
> I know that this isn't strictly related to the use of iowait in menu,
> but I'd rather wait with this one until the previous change in menu
> settles down.

Sure, I will look at any regressions that are reported, although "teo
is performing better/worse/eqyal" would already be a pretty helpful hint
and for me personally, if they do both perform badly I find debugging
teo way easier.

> 
> Also it would be good to provide some numbers to support the "teo
> works better overall" claim above.

Definitely, there are some in the overall cover-letter if you just
compare equivalent menu/teo columns, but with the very fragmented
cpuidle world this isn't anywhere near enough to back up that claim.
We have found it to provide better results in both mobile and infra/
server workloads on common arm64 platforms.

That being said, I don't mind menu being around or even the default
per-se, but would encourage anyone to give teo a try.


Return-Path: <io-uring+bounces-3052-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A72396D895
	for <lists+io-uring@lfdr.de>; Thu,  5 Sep 2024 14:31:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2524F1F278FD
	for <lists+io-uring@lfdr.de>; Thu,  5 Sep 2024 12:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC1561993BB;
	Thu,  5 Sep 2024 12:31:45 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F193083CC1;
	Thu,  5 Sep 2024 12:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725539505; cv=none; b=I4UUA7W6T3TeG2AH8n6TzQcHCcynog0IrJ5QYxOKxOHU8rFqpNflN3IS1ipWr7Di/GSYbKVHcIOpWHbdLv41KhV9brbMXxgj/sQKNtgHwPQPnL8zicl2L8+PEwjO982MBnf86R8lqy8V+sQ+CLyL9y1EKVznbVTo8TWq7ECDync=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725539505; c=relaxed/simple;
	bh=Ys+n47upRV8gJ7cBIJy241XGKNyjCb8RzCKOOkMZvPY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SjkGQL/kUwtYVfcq2AUkSvoKWLBX/Q45+CJY1N3g3BNBn3Xrg+t9fOckDLdKU3/R5O/V22aGZ3JJEoFeyOWzOJIPZtfOCZMoLyzLPku8+JYhYR4LzcJu8Gb2p28jqUMTKfXfXZRYi1uvXIiwtG6vPJHkGUBw9yZoUonn4uV/1pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A67E1FEC;
	Thu,  5 Sep 2024 05:32:08 -0700 (PDT)
Received: from [10.1.32.66] (e127648.arm.com [10.1.32.66])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 873123F73B;
	Thu,  5 Sep 2024 05:31:38 -0700 (PDT)
Message-ID: <16591e9c-1bfa-4fd0-811a-94ff4f032597@arm.com>
Date: Thu, 5 Sep 2024 13:31:36 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFT RFC PATCH 0/8] cpufreq: cpuidle: Remove iowait behaviour
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
 rafael@kernel.org, peterz@infradead.org
Cc: juri.lelli@redhat.com, mingo@redhat.com, dietmar.eggemann@arm.com,
 vschneid@redhat.com, vincent.guittot@linaro.org, Johannes.Thumshirn@wdc.com,
 adrian.hunter@intel.com, ulf.hansson@linaro.org, bvanassche@acm.org,
 andres@anarazel.de, asml.silence@gmail.com, linux-block@vger.kernel.org,
 io-uring@vger.kernel.org, qyousef@layalina.io, dsmythies@telus.net,
 axboe@kernel.dk
References: <20240905092645.2885200-1-christian.loehle@arm.com>
Content-Language: en-US
From: Christian Loehle <christian.loehle@arm.com>
In-Reply-To: <20240905092645.2885200-1-christian.loehle@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/5/24 10:26, Christian Loehle wrote:
> I wanted to share my current status after working on the schedutil
> iowait boost issue for a while now. This is what I consider the best
> solution, happy for anyone to share thoughts and test results (it's
> simply impossible to cover them all).
> I'm hoping to remove some (bad) heuristics that have been in the kernel
> for a long time and are seemingly impossible to evolve. Since the
> introduction of these heuristics IO workloads have changed and those
> heuristics can be removed while only really affecting synthetic
> benchmarks.

Lots of related discussion is also here:
[PATCHSET v4 0/4] Split iowait into two states
https://lore.kernel.org/lkml/20240416121526.67022-1-axboe@kernel.dk/
[PATCHSET v6 0/4] Split iowait into two states
https://lore.kernel.org/lkml/20240819154259.215504-1-axboe@kernel.dk/


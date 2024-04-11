Return-Path: <io-uring+bounces-1512-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DE108A1CE8
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 19:59:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A1C7F1F22F6B
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 17:59:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F10A814286;
	Thu, 11 Apr 2024 16:45:22 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E06D14A83;
	Thu, 11 Apr 2024 16:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712853922; cv=none; b=kom7tUwOW7IKkJpZnZkGRg3YRsJH/GhAGvCCY4fO1cbVj19qSbdcyXtwU7HlTaWtUziqZLqdJXPcJC01YKFGxsnXTFkSwPDBv09AKlvPfOvzopkhdso4ZjzPOXUtzygiiE2lqHuxjMCLE0ekTpz3bejm7yGWh/BzHA7R63TMYgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712853922; c=relaxed/simple;
	bh=h/ZEohgU3P5v2a7EY1UZ9zQutp5wDrWrURUGVudi2mo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pouukBNzMyoYSIl2nZpxoLE+Wc1oWx0OksI4g+jDJ3Hai5VBHFDRnFGyOO44XVLSdzV5mQzJyaGjLkmWAawwmYX/kSbRdnTsXAEqURYyJLi3RMwzDYrcyzOPkHVMumi2CDMuu2NRvtthh3yBFe4BSY5/H5nBMSrtq6ZjJbSeUYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0C52C113E;
	Thu, 11 Apr 2024 09:45:50 -0700 (PDT)
Received: from [10.1.196.40] (e121345-lin.cambridge.arm.com [10.1.196.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 21A953F6C4;
	Thu, 11 Apr 2024 09:45:17 -0700 (PDT)
Message-ID: <f2d1bb68-7ab7-4bbf-a1b1-88334ba52bab@arm.com>
Date: Thu, 11 Apr 2024 17:45:15 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] treewide: Fix common grammar mistake "the the"
To: Thorsten Blum <thorsten.blum@toblux.com>, kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-s390@vger.kernel.org, speakup@linux-speakup.org,
 intel-gfx@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-wireless@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-afs@lists.infradead.org,
 ecryptfs@vger.kernel.org, netfs@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
 linux-arch@vger.kernel.org, io-uring@vger.kernel.org, cocci@inria.fr,
 linux-perf-users@vger.kernel.org
References: <20240411150437.496153-4-thorsten.blum@toblux.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <20240411150437.496153-4-thorsten.blum@toblux.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/04/2024 4:04 pm, Thorsten Blum wrote:
> Use `find . -type f -exec sed -i 's/\<the the\>/the/g' {} +` to find all
> occurrences of "the the" and replace them with a single "the".
> 
[...]
> diff --git a/arch/arm/include/asm/unwind.h b/arch/arm/include/asm/unwind.h
> index d60b09a5acfc..a75da9a01f91 100644
> --- a/arch/arm/include/asm/unwind.h
> +++ b/arch/arm/include/asm/unwind.h
> @@ -10,7 +10,7 @@
>   
>   #ifndef __ASSEMBLY__
>   
> -/* Unwind reason code according the the ARM EABI documents */
> +/* Unwind reason code according the ARM EABI documents */

Well, that's clearly still not right... repeated words aren't *always* 
redundant, sometimes they're meant to be other words ;)

Thanks,
Robin.


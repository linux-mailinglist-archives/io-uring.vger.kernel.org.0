Return-Path: <io-uring+bounces-1515-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BAA88A2010
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 22:24:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4754528AF3A
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 20:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60B6617BD4;
	Thu, 11 Apr 2024 20:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="QMCudDh1"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.smtpout.orange.fr (smtp-27.smtpout.orange.fr [80.12.242.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0B817C6A;
	Thu, 11 Apr 2024 20:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712867046; cv=none; b=IIMQHyOHU10964xjmyecUxwErI9ZpY/eI91Ixot2UDdSFdpv7jHg7H1EVzisTVU/dYlZ40M2o8xsbgGbKodzMmeTnLiqtJ82jfN9l8HVZfFgfjUEfZnGvQilGro0G5ufYaRytnNVDDzWRvtSeKYprFsYRKYgXVoIOreu3gtWaPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712867046; c=relaxed/simple;
	bh=QhmZqca6i4GwVv1XAcc9IrrgLk4abiFm/4Wl1hb/8sw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R+q9P76gGpRrO7rGHoG85kD3J5l/gsvHfEkVuueG62aNA6G1C4zDdkYK28ZIkguOhiKEKe/L2kRBWoXddGR7JsHx1jNhYT+6BVMJYCmuyDQLzw+N6Ezu3T5JAWXyM4XpHlGlQ6qQFE41Np724XIXvcodmv8Wzc+ZTMPSxT9ESbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=QMCudDh1; arc=none smtp.client-ip=80.12.242.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Received: from [192.168.1.18] ([86.243.17.157])
	by smtp.orange.fr with ESMTPA
	id v0xXr4JUAqkPUv0xYrdLi7; Thu, 11 Apr 2024 22:23:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1712867034;
	bh=v4sYyES8feRyP/YNHQ4HOBPVocESBHJ4p6aCiQtSavI=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=QMCudDh14uA+N4VCUkUhGD3njd4hP+Nm+dZR+AHIvomm17cl8lhe+OEOieTe2tfCd
	 CSwaIP3rEU56ONRmKGTfz4ao9J8mzI9LnAVCKVmuUmS//1uy7UrVyFnucM+4esuv/T
	 oo+W9WibJxCGBDkR1ETwHvYgNw2WqclnTcAwFFkQCDIl+7Og0xYMtfR6Ce6O1eg8Xj
	 TprE9TDFAvWBbHv9DdeSW7gw0cL9SbIVgyxiFM+NCmvp8psAM0yRbsFF/z/qBtmvhS
	 tk8PC6grRGcBt957JhfI8k8joswKv/XfbhH8qO5/V5krr5vlKn6DDKJ1S1Ygk95Ha3
	 gYl5m7R2w2/OA==
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 11 Apr 2024 22:23:54 +0200
X-ME-IP: 86.243.17.157
Message-ID: <da50e56a-cb59-4815-800d-81742e5294df@wanadoo.fr>
Date: Thu, 11 Apr 2024 22:23:45 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] treewide: Fix common grammar mistake "the the"
To: Thorsten Blum <thorsten.blum@toblux.com>, robin.murphy@arm.com
Cc: cocci@inria.fr, dri-devel@lists.freedesktop.org,
 ecryptfs@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, io-uring@vger.kernel.org,
 kernel-janitors@vger.kernel.org, linux-afs@lists.infradead.org,
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
 linux-wireless@vger.kernel.org, netfs@lists.linux.dev,
 speakup@linux-speakup.org, Randy Dunlap <rdunlap@infradead.org>,
 Tyler Hicks <code@tyhicks.com>
References: <f2d1bb68-7ab7-4bbf-a1b1-88334ba52bab@arm.com>
 <20240411171145.535123-3-thorsten.blum@toblux.com>
Content-Language: en-MW
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20240411171145.535123-3-thorsten.blum@toblux.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 11/04/2024 à 19:11, Thorsten Blum a écrit :
> Use `find . -type f -exec sed -i 's/\<the the\>/the/g' {} +` to find all
> occurrences of "the the" and replace them with a single "the".
> 
> In arch/arm/include/asm/unwind.h replace "the the" with "to the".
> 
> Changes only comments and documentation - no code changes.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
> Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
> Reviewed-by: Tyler Hicks <code@tyhicks.com>

...

> --- a/drivers/scsi/isci/host.h
> +++ b/drivers/scsi/isci/host.h
> @@ -244,7 +244,7 @@ enum sci_controller_states {
>   	SCIC_INITIALIZED,
>   
>   	/**
> -	 * This state indicates the the controller is in the process of becoming

maybe: that the?

> +	 * This state indicates the controller is in the process of becoming
>   	 * ready (i.e. starting).  In this state no new IO operations are permitted.
>   	 * This state is entered from the INITIALIZED state.
>   	 */

...

> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index 3aa16e27f509..503244e8470a 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -731,7 +731,7 @@ struct io_buffer_list *io_pbuf_get_bl(struct io_ring_ctx *ctx,
>   	 * going away, if someone is trying to be sneaky. Look it up under rcu
>   	 * so we know it's not going away, and attempt to grab a reference to
>   	 * it. If the ref is already zero, then fail the mapping. If successful,
> -	 * the caller will call io_put_bl() to drop the the reference at at the
> +	 * the caller will call io_put_bl() to drop the reference at at the

Not strictly related to your patch, but "at at".

>   	 * end. This may then safely free the buffer_list (and drop the pages)
>   	 * at that point, vm_insert_pages() would've already grabbed the
>   	 * necessary vma references.

...

CJ



Return-Path: <io-uring+bounces-11812-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FD6BD3AEC5
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 16:19:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E25773004D09
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 15:19:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68EB23876B7;
	Mon, 19 Jan 2026 15:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FkxvkdHD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f195.google.com (mail-oi1-f195.google.com [209.85.167.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8BE378D6B
	for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 15:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768835957; cv=none; b=aYqvjo/qSox222vV2R/zKukUERgVszCMpnVTQKahKU6H8zJexZfdGy5NI8KprdhmeQeIYrQQas3tKPwiN7Y/RhgaLk0p3Dj0A6nrQQkpBVNscZwyW9SzEAewJA5nrqVOv3ytPNmutj4X1ESe01EUsxthGokJHswS5rPR09/Xqcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768835957; c=relaxed/simple;
	bh=9lYKl1A4wmL3dbwXIN3aCVha0yGrj9gb1A0dg+knqeM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mIXYO1eNCCLHgIYdkmxf0ZW/jJTs7lzzWytLfKPWQtYsOJYi5XCdSeTScoZkF0765dtBsqjxNT0DraCqqiZ+X9zKyBFapI6RdH3u6QyO7AoZvf47vhsZNBRp7mTQtCD95AYndKyOgMqim+3XusNbNmLMC4pHWJVegDJ42W5NHCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FkxvkdHD; arc=none smtp.client-ip=209.85.167.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f195.google.com with SMTP id 5614622812f47-45c93e60525so2332280b6e.0
        for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 07:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768835954; x=1769440754; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wte8eMJNDbcrKLuDulK17hs1mTpYcPcujxWR+qNMyWA=;
        b=FkxvkdHDP/rhGjIwObbKn0hv90Gjs/INsDHhF5CR7iSQiuxwsbie59ZNLkxms60l/o
         1hdqe+Zz/j2iXLlFTTcyRdsQEFFZ8U4ksFPxOnRR59ifM0YJJog5Hp68l8X9lR/4Ou5z
         2AjwLNdsuexnVnhFrRuXuyNYY5Q+IzN7zp5DEQZhX9Svm9AGCWnxGGv9kMd4GSFyOK8u
         qRABKY+0Ldf+E3ZRs1G/Rilkg2MsjmkGvlx7grm5+RPQ4WaeOCywceFX/5aHk53pngoX
         BPyNx+lucm5xD/W+vobUkQ49NQNOJbhXQIgrXbin1fONk+2vGraqa3AMJETL1iI0PIMy
         gRlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768835954; x=1769440754;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wte8eMJNDbcrKLuDulK17hs1mTpYcPcujxWR+qNMyWA=;
        b=w9CuRgSuoGaHAmrHlIpWOVgElnumSS9wuml8vCU5JavhYmhRUHJE/AowP/7rB8oJOp
         macwk1zlSUXwnSWuhso2vzPkBTGRnXuiEvBlRZzqArVsqm4KO2fHssWCVJhStqmiLXO5
         NN+DwnUe8XdM+Ndepyl8VEOH2Ne9Q0M1iUUhJV9W4v0jbarkwqKVJVzGjl5ZF3RkNUo5
         LZNcYxQbW9FRdxbdt8Uz2/YpAqam561wlC3QYT3S9faD1fPY/X8erODpl7RyCw23JCgD
         KYNiEbeBd33RCRgRMezidtRRNpBkLkLjH9PpHfDe9Iq60VPWqhBVd6DuGWBjhFQUCEYK
         +3ww==
X-Forwarded-Encrypted: i=1; AJvYcCV34X/IPlLorlVSN5O8/mivE7dbMv67t2IsCCghr8NRM9WI3EJdDcm0O9Pbqz2Ei9koi5KR7G7lag==@vger.kernel.org
X-Gm-Message-State: AOJu0YzBlZ1lGZfgcjVHoz+FXLZosQv/6mLSSXDztTWgoVmqwML216ls
	qQIcjHTg0L5ENLFyO36cEaPE7AYeUJ5ryt9clKWRNoXpWbWj1Wz5RLzXWtJHc8SWc1s=
X-Gm-Gg: AY/fxX4okZP86hPMZNfE1Fl7ZiG5vQHspBxvL06N8rbHIywA5NRO+FWNofXMZsLwkBR
	CyjBOz+n1kx1pATOho/nT7tzguSqpGMeBkabpOQwEPx3sZRrGPcY1rQ897sqMlurbgQc9BWZamv
	QH7Tj02axZJj70rN3VzxgLQp5VHlrEqQx30QBXMJ02YaJk3zOzo168L3+9KT8p4opganMjqDt1j
	bOQhFBGcJIEN70PjZRHg95g2+0FDkfPMfzlKo2CNO+v68TNCghOzp+XimlSVRQTmFIG/thYJ90w
	qOBTQ3wbz/wobKO4JXE36VOo+SBHSofP7L3qrFiMetjT8s/hAQyMwuIQa30YniHHUsnnc9eNg7H
	DUWNoeoxEfxN4wEr3kkTYe8hA/ahg8xhEa6o9K5H578SDCPtTSgXmhSZ9Yc+UKx542pZ55W3ZnT
	INMU68LSkv1sZA+cWRRb0nTitC4Yt/zsFvfsCqia01KktE9l+dpkALlr8YyH6wcJ66PImo+jRQM
	Sb15kwL
X-Received: by 2002:a05:6808:650a:b0:45c:8d9d:8db4 with SMTP id 5614622812f47-45c9c0c3149mr5241188b6e.55.1768835954379;
        Mon, 19 Jan 2026 07:19:14 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4044bd5c64asm7047741fac.16.2026.01.19.07.19.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jan 2026 07:19:13 -0800 (PST)
Message-ID: <9859f637-d8f9-48e0-98ba-42cc6255c73b@kernel.dk>
Date: Mon, 19 Jan 2026 08:19:13 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 0/2] nvme: optimize passthrough IOPOLL completion for
 local ring context
To: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
 Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
References: <20260116074641.665422-1-ming.lei@redhat.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260116074641.665422-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/16/26 12:46 AM, Ming Lei wrote:
> Hello,
> 
> The 1st patch passes `struct io_comp_batch *` to rq_end_io_fn callback.
> 
> The 2nd patch completes IOPOLL uring_cmd inline in case of local ring
> context, and improves IOPS by ~10%.
> 
> 
> V2:
> 	- pass `struct io_comp_batch *` to ->end_io() directly via
> 	  blk_mq_end_request_batch().

This is a much better approach indeed. Looks good to me.

-- 
Jens Axboe



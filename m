Return-Path: <io-uring+bounces-504-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 053CF843075
	for <lists+io-uring@lfdr.de>; Tue, 30 Jan 2024 23:59:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 372E01C2398A
	for <lists+io-uring@lfdr.de>; Tue, 30 Jan 2024 22:59:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41C527EF03;
	Tue, 30 Jan 2024 22:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="a9TsL7eq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5D67EF00
	for <io-uring@vger.kernel.org>; Tue, 30 Jan 2024 22:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706655594; cv=none; b=c0gd58EgtlWH3MXwPkZwH6mpFLseZjmReKiICslGCEl/M6bm/uXwQ6HpbcDmsCSag/8iVXbIHwpEM2Cve92hy60eL06LH2ju3PFZEbWK1md2CMtMwXSRVC0dsYPUmIrWUGNv5ijpSQNe/MB/yu2DKIKRK4NQcMJC2mUo2u9PO8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706655594; c=relaxed/simple;
	bh=idUO2uxaruTbpQD100whNahWL9QvzrV9EyyHrB2VU6s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GkmdEtxJ/zA97JSlbV/3+cOXjoHGJPQ3Awktg3M/TuuLqAqmGPl/K+pD+FHcloA7c8YPn0jJYIeINujdHNZH2QRtuUIIivdL8b8r3Eq5QlIPLrdeTZv+QzkNoX/gk+Gale9YjIQyCxWMwtHs6mqPMkOyI3Muo0UwXT2hP/t1zxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=a9TsL7eq; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1d3ae9d1109so6810785ad.0
        for <io-uring@vger.kernel.org>; Tue, 30 Jan 2024 14:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706655591; x=1707260391; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I9zvkvCXyqckVuozVkVhrKwkHVAXtLklw8l24aE9o40=;
        b=a9TsL7eqONedG5GciOidI+K6yGft0Y/3MiGDBfMW3yjRg+Kjx1wyEndjc0Lk76vML5
         rO+gFmy53HvaxyeCGsQl6tYpl8VAdHBNLIX39cUIWEQLGPHnmiXoWzISI9ynDG1uNE56
         GTvqETUFP0NDsY9/Lzu6h3iPmpsUV9Z+BzJPajbLjgif/ACMGGWE4p8/eq0RSaqSk+Iv
         vDcL4406u4JC6vaeoZg2YJgDz5Y1fiwCsqelFNe6CtUmylydmy0aoW2JL5t0Ot1GdWcr
         6oirpkdGjBW8gpsnd6GjX4RMwXZaMXTcs+u4bAcYUvDBWs5yhK3yQ8QU9su9AQ4fhApq
         3E5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706655591; x=1707260391;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I9zvkvCXyqckVuozVkVhrKwkHVAXtLklw8l24aE9o40=;
        b=el6qrMO4oa68g6sDdKsWpsiwKcoHBFeph381Vk4D50EtQ9b1+0whaQVFQZqro3geat
         8WyHvZTIimGWSBhJBPec9uZskgBvaaHNo3t4u/4w9/yabYxAL+JcMHRQ4pB1PJaYPAR5
         04Mhyh9T2o/q7hR5J58xIGNeXI0HHTOHA6HQNwvFh7ellfAmdD3R3tu0JLwAFkMklDf8
         8JIF3xpRpnbiLaRv/BNmS9s2P3pEtkHGybNHv1KQZtecx9EN43Aps5vLGHsg1QeM5jpl
         BfTH4fry4DQqocfqHwODszTXewdYvkBUASuq3nnXr05kKUlQHjhwgTGLb3o0Pnp+EGDy
         p9tg==
X-Gm-Message-State: AOJu0Yw8JqwBNBUYlVpfO7vEcRWp+GXVCDoINPl8CxsMNVNbiXXN4ZI2
	Za0IxNzitW7Pd4IorS9vhigtHn8f5hT7CXzfnXDwAqr+H/wOYz4fhmlbHe88BQ8=
X-Google-Smtp-Source: AGHT+IFYwAA7H2idk2+JsDU6EYfbt71pnvyYu7tJXdxp/z1vPV7dZ7TH1IOwZ9Xg0KtlKEyTj7VmLw==
X-Received: by 2002:a05:6a20:8e06:b0:19c:9b7d:bb36 with SMTP id y6-20020a056a208e0600b0019c9b7dbb36mr14519772pzj.2.1706655591162;
        Tue, 30 Jan 2024 14:59:51 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id g3-20020a17090adac300b0028b845f2890sm11028829pjx.33.2024.01.30.14.59.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jan 2024 14:59:50 -0800 (PST)
Message-ID: <2b238cec-ab1b-4160-8fb0-ad199e1d0306@kernel.dk>
Date: Tue, 30 Jan 2024 15:59:49 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 0/7] io_uring: add napi busy polling support
Content-Language: en-US
To: Olivier Langlois <olivier@trillion01.com>,
 Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org,
 kernel-team@fb.com
Cc: ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, kuba@kernel.org
References: <20230608163839.2891748-1-shr@devkernel.io>
 <58bde897e724efd7771229734d8ad2fb58b3ca48.camel@trillion01.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <58bde897e724efd7771229734d8ad2fb58b3ca48.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/30/24 2:20 PM, Olivier Langlois wrote:
> Hi,
> 
> I was wondering what did happen to this patch submission...
> 
> It seems like Stefan did put a lot of effort in addressing every
> reported issue for several weeks/months...
> 
> and then nothing... as if this patch has never been reviewed by
> anyone...
> 
> has it been decided to not integrate NAPI busy looping in io_uring
> privately finally?

It's really just waiting for testing, I want to ensure it's working as
we want it to before committing. But the production bits I wanted to
test on have been dragging out, hence I have not made any moves towards
merging this for upstream just yet.

FWIW, I have been maintaining the patchset, you can find the current
series here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-napi

-- 
Jens Axboe



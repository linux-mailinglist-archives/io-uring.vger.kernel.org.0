Return-Path: <io-uring+bounces-2273-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E20F390EF36
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 15:42:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6463AB21C18
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 13:42:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A827213DDC0;
	Wed, 19 Jun 2024 13:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1LYue/1G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526EF78C73
	for <io-uring@vger.kernel.org>; Wed, 19 Jun 2024 13:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804523; cv=none; b=Y5sBhQ4O3doCgFsnXKuElfW4W8SvksMyDcVpnqlLiD4RrKEby6MPix7iIOzdeG5s53kHJftLrGDIIo7z47D9k9E1s5yR3suTk7Xyphnsinz0Gog8ojHb+o+e8/lQ40drKQqv95WwRVPo2wC8YGvwGGPr41n7R2bPRblLIHB2xig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804523; c=relaxed/simple;
	bh=IoScpVk/gppxvVRg8+qcbwaSAcy0YbXheCz464BhMOc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BGjtT9UZh15TwH2sehTvX3MS9EIkU3jxAltIuq+6mj04B91jlQ5temfJgVm71DEekFTiaRy47yLiqF0L/4FpuB9lMiSi/3yJ3ILrheCsMfao7cEyoZc6JlU4//fj3eMkAk9CKphTHB0nM+zsTXje8coJ87IsDfR4mcqJ5hMyTK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1LYue/1G; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2c7a480c146so262678a91.2
        for <io-uring@vger.kernel.org>; Wed, 19 Jun 2024 06:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718804521; x=1719409321; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=taT3d1XaEIKtSo5RzuEe+vN4cxD2AIjbpQ8M/imv+GI=;
        b=1LYue/1GPcVd4ehAJuN3wVmJ6g4Mt5ovAbkyyRb6RPi+Ghe+nGOCxMW8Hybv6G/0Sr
         yLYOKv8ZdQ+HuesfA1GtWdWQeYV3EMRCvJRYQvbYbe+sK1syMwiZfIqvqr4OSWGJC7vH
         XJuKM/7NDUCudg8nLW7OYdxbXbx4hW72EFXdLOu/0Ib6pnijnIMHt0FRV7RajgNmwDp9
         DvSMeTwFrfT+p/5a9W04KEfmIYMdRRYB8BAfQP4rVI3a2lo2V1nwPNo6FGWZKyiWYyS+
         UH3KZQ+1aQrYhi5ATlAMu2t0yeRQk4R8Nh6w7/0qoEDT2AI9RN3FMYaMnfTPcMHLaPxS
         tJjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718804521; x=1719409321;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=taT3d1XaEIKtSo5RzuEe+vN4cxD2AIjbpQ8M/imv+GI=;
        b=WQ+XygnZoBzWuZIZ9B/ZcikZi1y0y8jmKAoI6kiSUs54z3b4lE9F1NJppjFNd5CICh
         nxiXbDgHNiYo1BVRJY2fsCDly/lgRSuNY+VBmaEJQl9dGZTzt92aKZLwj6LFXvIwLL5q
         jTQu2SCDAZX6cyk+yN4UHnYKzqZvAjIuGlDSJbh3S/pFO/Iddew/eFVkD/eQCwEd+j8v
         1tCaIuBm8VQKq9CGU3yaDOFzmdul6udeMBJQc6X544vOAF5mpCHvoEHZ+9IfAucxCTPF
         qq0R0zTciy2ToKda20y01Pkx5jSamNTK24l+wtAMhLQJTer7PaSO2CH+z6Jcj80ETKq0
         bZWw==
X-Gm-Message-State: AOJu0YzF1ItKt5IIYWpXN9xlHukZWl3KvVWK608rASo1oLDehSiokdIT
	A6hRphsC2ZldssXQzLC1WOo/yRUX4wsbbcyknaLkeTAauH3TpKnVPu3GE9typs0=
X-Google-Smtp-Source: AGHT+IGPYaaDsofKObxnrw3tYN7YQCXjMhjIprtv6z6/QYPYXGDC/K84ZaMMvm2inHOOfehpnMp1ZA==
X-Received: by 2002:a17:90a:f285:b0:2c4:da09:e29 with SMTP id 98e67ed59e1d1-2c7b5dab1b2mr2451923a91.3.1718804521529;
        Wed, 19 Jun 2024 06:42:01 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4c45cafa1sm12944662a91.16.2024.06.19.06.42.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jun 2024 06:42:01 -0700 (PDT)
Message-ID: <2e91f4d1-6678-48cb-b212-f15c513e0665@kernel.dk>
Date: Wed, 19 Jun 2024 07:42:00 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] io_uring op probing fixes
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <20240619020620.5301-1-krisman@suse.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240619020620.5301-1-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/18/24 8:06 PM, Gabriel Krisman Bertazi wrote:
> Hi Jens,
> 
> I didn't know this interface existed until today, when I started looking
> at creating exactly this feature.  My goal is to know which operation
> supports which modes (registered buffers, bundled writes, iopoll).  Now
> that I know it exists, I might just expose the extra information through
> io_uring_probe_op->flags, instead of adding a new operation. What do you
> think?

Yes! I've always wanted to add more to the probe side, for example
which flags a given op may set in cqes as well, and what op specific
flags it takes as well. Ideally something that is then also used when
doing the prep in the op itself, as not to maintain this information
in multiple spots.

-- 
Jens Axboe




Return-Path: <io-uring+bounces-2796-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D54E9550F3
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 20:38:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0C188B21496
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 18:38:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97B6D1C0DC5;
	Fri, 16 Aug 2024 18:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XiP/cE/L"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BBF7DA90
	for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 18:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723833510; cv=none; b=FUQOWEMPBuhdHAVng6+84L9piDntsU20I7nUUSGMGbOxtiL6uKL/Xx62ztXWyFiqb81IWj6nGaxVfDS1Mcvyu9mJaV8kCmDlOEOx3yTRE6aLACWp7pEwUQWuaqFa4IAqLKnFOIZ4LXFzsp08Lypxjp9NY+lhhpyANElOlt2vM2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723833510; c=relaxed/simple;
	bh=YYjQVeR59AKP0NrJDwe9XS62WZ9cdMKOlenaLGByXZk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E7ifg1teSUlbZsVLyokoE1zDaBpHYk1ztcxgBH2MVnXGrhoMML6Bb8CFvwx3fyhaCK3ZzE+H8BredrmHrfmEo+V1i73w8uGg1NQGrIxVjsxfoLhFWh8yjx0xWAgX05ltMmESBtgQ+GiiJ6I9YGiN4vzsBzNTTPl1IhkbgPhwu+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XiP/cE/L; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-39d25267dacso760625ab.3
        for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 11:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723833507; x=1724438307; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2JaidciDyh2FCoyTrOSc9wb/j/c1Qcpbr/Ubzo3w2rA=;
        b=XiP/cE/LfRsPVxjsQfbV0szsdENbqHWHUQIPW0Bvr23vlFqXbFcsxBmu+j6ItJxF7e
         ntlhyngXtoN/QukZuoq6fEzo+klCGnl7bdwMm0FWlULBSE5nK3P6s1hxidNdu64OKuTU
         L6Bf+HLoO4Z3eYnqX899j50RD/O1q+QsxBQQYU6Eit5R+efejMVtPQxP9SrZNHaCuGhV
         9xrA9luxx9WxpUhOf5qvDQByY3xFmWiSgJ7GyCAbcWPwLC7NANaurBgb8mF2BuwUKzmw
         ScTAn1LtO+/Dc6DSAWUoRHt7w87xIp96kcx7SB3762D1/FM/9rdoXbjRr2fP96wH4HMJ
         8zVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723833507; x=1724438307;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2JaidciDyh2FCoyTrOSc9wb/j/c1Qcpbr/Ubzo3w2rA=;
        b=TQdJffZwbZd9cuU1mtFRuMQ/RNBHcyYzEd9/iT0k/u6RAwKSuPxSG6R/XpKs8gPvOA
         5FhACL0X1rCCIMBOeSnH/DftrjY+vWg8XSWMlYodlbJ36m1Vp5IOi7W25Lo845xD5Vd7
         V0e//HgFoB9S2UiGlIKUfypyFDnF+2y6t5wNFFKkLxm4WOSvg2zAv8Cd/TS+1Rn/3bzy
         hgW07U4ocM89nO8LqeHQZbWhjoxcQtePn7wK8MMHHznJAupth0kydSwGGY/sQdsDI6TF
         KVA4GDb1CANWkQSpcKSVQyDHUybV6ITvASmBPDufsUpQLyFNC2PZPzUwPj0vdvqnjB/x
         r+zA==
X-Forwarded-Encrypted: i=1; AJvYcCU3BtDUccIp6Iz2iD5v843Q2cd+sGp/+F3sqxkZukVdR2i+1SdgweFM6wMvvik3IySDUsJ0vVjdQ7tnDS0wAr2NWcs+sKAVjIw=
X-Gm-Message-State: AOJu0YxzlRcNPxmbhwvC52+soluej+nX5G9AuFFSwO1dtAlO1Xb5iOMH
	FL9KUdP+YcJndN2VIAoynHQvIWEjwjpJJo77+R0ADZdOd8J5reDZAiXBi10raxctKqgnom5+z7m
	3
X-Google-Smtp-Source: AGHT+IE+RKbiSKXf8s34Q8hKpn4sRyLehR+TzF7wilIa3v18mEG1zUm8RFsFk8rQHspOO498apPvzg==
X-Received: by 2002:a05:6602:90:b0:81f:a783:e595 with SMTP id ca18e2360f4ac-824f3b2dcb3mr244847539f.1.1723833507338;
        Fri, 16 Aug 2024 11:38:27 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ccd6e95b90sm1403223173.60.2024.08.16.11.38.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2024 11:38:26 -0700 (PDT)
Message-ID: <5163db7a-c40a-4cd1-b809-e701bec6f98d@kernel.dk>
Date: Fri, 16 Aug 2024 12:38:26 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] io_uring: do not set no_iowait if
 IORING_ENTER_NO_WAIT
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20240816180145.14561-1-dw@davidwei.uk>
 <20240816180145.14561-3-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240816180145.14561-3-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/16/24 12:01 PM, David Wei wrote:
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index 9935819f12b7..e35fecca4445 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -41,6 +41,7 @@ struct io_wait_queue {
>  	unsigned cq_tail;
>  	unsigned nr_timeouts;
>  	ktime_t timeout;
> +	bool no_iowait;
>  
>  #ifdef CONFIG_NET_RX_BUSY_POLL
>  	ktime_t napi_busy_poll_dt;

I'd put that bool below the NAPI section, then it'll pack in with
napi_prefer_busy_poll rather than waste 7 bytes as it does here.

-- 
Jens Axboe



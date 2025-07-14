Return-Path: <io-uring+bounces-8663-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEB01B040D9
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 16:02:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 186561668A8
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 14:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DEBB251791;
	Mon, 14 Jul 2025 14:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xItvqeOQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A47253B56
	for <io-uring@vger.kernel.org>; Mon, 14 Jul 2025 14:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752501623; cv=none; b=k486uvLj9/B/RH9+Pi5nLyyoPfSPopY4+E1KMjuGY6++mBe8t+YOiPXC8E1NnXzRCLiRicYnv+ktYeaXuvE2Lk81YnQDeEmaPYePsfeQQ79t9y6yvKUULrdly70Hv0mqzQVBio3j5kXV6iJrfG365uGCmz28b/tGqzHZ9wppVmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752501623; c=relaxed/simple;
	bh=Q7wko7/wUh2H3S5qcStyrWfJDnuYYGnuowbqH9GBFCc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s3YrHi03Tf5ZXjgJ+WdlKOhFYDI0Q9uwn4Sb3LZnNXnD8TYcMz4Bepjol4ynuFXsGCuFZ0ZVFgpKgrd+ICdCXO9lFa+d1HVmMAYoQVMRTAk8vPdBmclDRneWKP3+OCrZFF9DOgEKe2zgo2nMq1d4TIxIZYtv1sM5QuB+IN7Sknc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xItvqeOQ; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3d948ce7d9dso28189095ab.2
        for <io-uring@vger.kernel.org>; Mon, 14 Jul 2025 07:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752501620; x=1753106420; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xEDN5ceIXoDkHoOeV+Ed848IKBn1ofuiV0LfaO0DA7o=;
        b=xItvqeOQJf+kIThBcA7IbckFWeCkihXA05n3GIDuX+JVdDV8A/67x90CnuY8DJ3eZo
         MgjWlEz/PZHOmvNZXnkkcFLe2a20OwNxg8fFEXrgpzQnaA6r6sbyET0M4zLGuXL5XTRF
         DOJsdPQSbc68N66fOrsvDPWFw1Pea2Q43anJQm8EYPTA9ctV/hIOX6DdGwXOE/8lHtJZ
         fDdFqSp/L0OTgMQunD+kuuMyHoSVd8K5S6vh4qpd5omVjimaHgbkyVF+jKuslAYr5CXN
         ZnEYqRZGWKFK6qhL57GD3sfQ0d1q/d7293XyHqkE8NkWucDmAYxS2APMpm8O9miD+QIx
         aAAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752501620; x=1753106420;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xEDN5ceIXoDkHoOeV+Ed848IKBn1ofuiV0LfaO0DA7o=;
        b=oFGB9idunR48fyD6+LX+GgjlWMn8Jht6Mo9qZ1WwQba6JXLY2R0Dvg5R64fse4fsnW
         FEbGKZ32mi4b18o6V4WldBEv8+UYsn3GFOC2ztayp+IbcwyrR/VOOdshCU/04n+f9JPp
         f64zIlD3qg9ixu2Y2ap/7oQUOk8JTeS5dz0+oa1XRJItDOuc3iLtW1C+6AGfZUpJzpWh
         M28sOMmBgT9s3vexTG7DYKLPvLrzRgPx1lo/HmvvG6G0LMtvCtPveZApCE/ARQrTVgS8
         A0orsSmFGWpLFIF10o054q9WeK3xn4wx8A+kQWbcfaG/Vk0++1zmIryyTbGDtD42xAgy
         E6Qg==
X-Gm-Message-State: AOJu0YzP6quBLOQdfFIcW+v7tAm+qX6Eubyg17oQO1fsY+rxEnHSD8Y7
	J78pGBGE588uxN0MrFADxqStRmYYkSBu2Zv8jwJm2AkByiAk+JeucTv5r61/HJ8AWVQ=
X-Gm-Gg: ASbGncvKh3jBUQh5/dwk3giB8W1SHxRRKO2yhylLZnFXQeC3TvjHCX3GZUq0NH7hfjy
	iVbOgendglbamFNDJz5Sr+6H4IeqR+AzNqvsamZ9GWoulvbiY03x2Pgx4hQh4gYPnY7bLwcVI+r
	CMGJDGb7jzczuRB7tCM8dtCBaEDKUzG31tXlFljzz3DSaVl7gFEygIqLRUOWDDAgyQpjqFUhd5b
	4Afw6kMxqlx2DGW02SupZr3OShguBhurhwU1q9LDXlTMuIj2AND45w5abbWKndd3LBzzDwBJJjU
	YkweVQLOIaVBKfgrOb39X7SZ2ZQ2fzJc7zoxR46p9H2cDdFywo2Qk7QzDCJklibWHRyOnraZ9rS
	HfcCfbPj8D4U55ev//K4=
X-Google-Smtp-Source: AGHT+IH+QmTwJHy/hmLCFp17WJEN7d08zkwID1qqZ5aqE2Hh/uewiX5O0llmnaALKYkrnI653xS9TQ==
X-Received: by 2002:a05:6e02:3f13:b0:3d9:65b6:d4db with SMTP id e9e14a558f8ab-3e2542f9baamr159539255ab.12.1752501619621;
        Mon, 14 Jul 2025 07:00:19 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5055994a689sm2010304173.143.2025.07.14.07.00.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jul 2025 07:00:18 -0700 (PDT)
Message-ID: <0be7407a-3fd8-4456-a4f1-4b5ab99ea5ba@kernel.dk>
Date: Mon, 14 Jul 2025 08:00:16 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL liburing] Add musl build-test for GitHub Action Bot
To: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc: io-uring Mailing List <io-uring@vger.kernel.org>,
 GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Khem Raj <raj.khem@gmail.com>,
 Christian Mazakas <christian.mazakas@gmail.com>,
 Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
References: <20250714042439.3155247-1-ammarfaizi2@gnuweeb.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250714042439.3155247-1-ammarfaizi2@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/13/25 10:24 PM, Ammar Faizi wrote:
> Hi Jens,
> 
> Please pull this musl build-test for GitHub action.
> 
> Several build issues have been reported by musl libc users when
> compiling liburing. These are not isolated incidents, common
> problems include:

[snip]

Thanks, this is great! Because it is one of those things that keeps
biting us in the butt. Pulled.

-- 
Jens Axboe


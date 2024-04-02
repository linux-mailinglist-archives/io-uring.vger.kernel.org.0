Return-Path: <io-uring+bounces-1368-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C54D895C0C
	for <lists+io-uring@lfdr.de>; Tue,  2 Apr 2024 20:55:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B9AB1F2370E
	for <lists+io-uring@lfdr.de>; Tue,  2 Apr 2024 18:55:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC35C15B15D;
	Tue,  2 Apr 2024 18:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DSori6Xw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1EC15B129
	for <io-uring@vger.kernel.org>; Tue,  2 Apr 2024 18:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712084128; cv=none; b=t6k40EeTFHIKCq4yNLtdDwh7A94BkYvdZyVodaiwMbYnRfcVxonPH8q1N9bgIzBwDKJw00uIVFkhGNvqwXRUSF81NCb+qeR2RcGBUln4ToVwCHWNyLUWylDpk/TOYYuhsB/8HS8g8c/dZdnkjow6X9QRdLCAjfHGEcaDESk1PV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712084128; c=relaxed/simple;
	bh=Dk00FlgdGaeX3yUPDWCaCFg4Gbj7+7kzsUBTGty4cm0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TaFbtrm3itjNcQnu3NND7YQe9fNaPSl2aO/JvDUxJ1wlee6f5zQIEm3pZ0FiHRkZ8/yLrHPuzxvHvfIOlvDDh0mJslbLNEINV1ee/RdJAiZAWuK1lnbrmwYHqtzhaslF1serVS4Id//Gmayjvc5VsQf2bW5iGNxgPruUbsLL8Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DSori6Xw; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7cc5e664d52so70771439f.0
        for <io-uring@vger.kernel.org>; Tue, 02 Apr 2024 11:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712084124; x=1712688924; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y9CEKYteE8uUUvJpYXds6TwWJm/m8kxE7cZKTVullfs=;
        b=DSori6XwAipnquplkwt88IRAYxw1J1pIjZjUSDuvtjY/uIbH/eGq64IJnvXaB6QSSi
         jJ+OFHOeHUH5xksQybnfnfeVeftdro7oe4Tuu4vgVYvy+3EDnc440RdvSQt+2pgfTTMJ
         EqRCaEz9XvXGjqvk//FkqiyR18CzHlC4l2zR7D4JsMgS/deWVgL36gfzw9O1VQZ55SEv
         /3kVyAQ3hp2EreuWwX258EbHjiFULRY2f1aEg6x7aRwWOu12r7W6SvNfgieZr2yCzyRJ
         uXiqBYpwxha1Hlvi/Bh6Bs3Z4NltWKcZczu1dafk+LwEMUuuklXmgiECydT/WEDM/hX4
         zELQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712084124; x=1712688924;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y9CEKYteE8uUUvJpYXds6TwWJm/m8kxE7cZKTVullfs=;
        b=Xo6Tl1AZCtLgJ+1i+ZZJNSmQzsRlYvOj/35COv1nPvIDk++fck6AL8bb0e0GM7rREp
         IXTJs2QES+AGyR0bwSE8ohC7ZFsLryBloEewRql5LrnBEUdVZK1YqZFlr/9kUOiZV5tf
         LfuKFC5rc/zgp/COk/+wNWLGQOS8i942NsC5z7tlwyEUj+oLqWQbRNWMDW9fNp1QNsqt
         ZuuM6HrX36SBY7GcxuT6SpfeHl1p6R59YWYgo2Mn7nsnd/SW0nFkx4nau1IJyKTPZzM3
         XcZMR2WUMUJnxyU8r3n9U68TXDU0rfiksvObKaH0Pw2ATHEkB+kpy37L6YuJWBLPH+j9
         vCbw==
X-Forwarded-Encrypted: i=1; AJvYcCXQ/91QJLWe3PRRXx84Lk9zdS/2DWocxRoT+2ADNbsDcVvEQXhDmoza8D57Xxg+mwx9kq8sL5FyoLfj+N49CHFF8GM76h2xY3I=
X-Gm-Message-State: AOJu0YxTPYnUentK6GJpvmICfBc9WYW3LUlbR0YWUrqM+S15felQq7mk
	VLRngrE2R0QydCIIMDJvK3gLp1yD742PNgpIwgRF+HEdR+w7dIa1PZVd3QoZ16Y=
X-Google-Smtp-Source: AGHT+IEjGK6NxzKYxt51ZVO+1tkBY7glBsqdLv4qs0KMaJYsKOk/Z9a8P8Su7684Ypgt9899NjSJZQ==
X-Received: by 2002:a5e:9914:0:b0:7d3:433a:d33d with SMTP id t20-20020a5e9914000000b007d3433ad33dmr489178ioj.2.1712084122903;
        Tue, 02 Apr 2024 11:55:22 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id m4-20020a056638260400b0047ef03e3512sm1765520jat.135.2024.04.02.11.55.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Apr 2024 11:55:22 -0700 (PDT)
Message-ID: <727c3d14-b645-406a-8ba8-506e5753d646@kernel.dk>
Date: Tue, 2 Apr 2024 12:55:20 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] kernel BUG in put_page
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>,
 syzbot <syzbot+324f30025b9b5d66fab9@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <0000000000002464bf06151928ef@google.com>
 <a801e5e8-178b-41c5-bf76-352eabcabf45@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a801e5e8-178b-41c5-bf76-352eabcabf45@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/2/24 12:51 PM, Pavel Begunkov wrote:
> On 4/2/24 09:47, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
> 
> gmail decided to put it into spam, replying for visibility
> in case I'm not the only one who missed it.

First I see of them... I'll take a look at both, must be fallout
from the mapping changes.

-- 
Jens Axboe




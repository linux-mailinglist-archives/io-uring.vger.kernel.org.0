Return-Path: <io-uring+bounces-2605-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D8499414B2
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 16:46:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29322284B68
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 14:46:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80FCA1A2551;
	Tue, 30 Jul 2024 14:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="c3VL8Dv6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177731A2554
	for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 14:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722350780; cv=none; b=JiFgRLtm7LaqnpOA0CcxqA0no/LMEe9E2tuDuCHtDVNM7CV26mfDKPex6UT+Y7HrWic3QO9eTXZI1R7hWpWNR4dFG2ngODESLUQpbWZaO31Wsxj89LL3j1badeUZ2ygSwMY8iOxRcY4K8k+bLvigtIgAJFBcop/bJt4nt+/0QqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722350780; c=relaxed/simple;
	bh=ui1zMul/xk9yEFWrcO7zia2nKEkCWbKVnzCPvUYCC5k=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=V8I1jGaE8QMWT7xOMgSrPDktfmjZxEBHJiA0Ne9ScGf33egj9NVCASdvMcDs4iMXPHtRE5axb7B4fkPdboTUVdg5ClZUEc6jtlOPlF3oiwPupNmpCWIGlxE0lRoYjTI4J9TTbPTNF+dHiQo17rwCvL6+HfLwSsKK5URQydCnIHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=c3VL8Dv6; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1fc5a93ce94so3223585ad.1
        for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 07:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1722350776; x=1722955576; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A8ALlx/8zhsQvP6mF2Re2PM19Bf1L/OkOrXsDuuko38=;
        b=c3VL8Dv6kd3x8NgI2gJ4oCmUWpLvTRjOGMlcFC07lqEjAEICMA3iyYotp9wXwiH46Y
         5gXmbidQhTiID9uCuv3Xbs4uBK8cvevh5ZiDmEWHhcj3PfJF93m3mcf24TaZkKPUXmm1
         UAgxopAr45xZuMZqcZgg9gQ0fT35kIZEKJr2RkEzsaGuoK6aEAxZO0bWZcXaOSTC68jm
         +2Mm09gC/o3KaBGEqvbJ8vprBJ3EesomJlGKwm/W+PxZXWdrEpIUVbti9p30Z/ycEJDb
         wTizWKkxvCkcTSDqe8162H78a4yljaUiTsQYlIMxx73VIc/7PMiMZPfOWR4kMJ492PZU
         zngQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722350776; x=1722955576;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A8ALlx/8zhsQvP6mF2Re2PM19Bf1L/OkOrXsDuuko38=;
        b=UJxs62MOF94kPlVS3mX5tWtet+4MAL6cPzzq1E2fOF7qzESAwgoFFdD6837cUo9YRd
         +Xa8+z4vh4rcnQZEdu9YEv/NlzbLvVj/GRFHKGVa1PM95gH0a9mr/rNBMWjU8pWk9k5P
         gxOOpeODxxs1kiaonWi7YMgt3KOUv3PZ5Ndmua7PAMIuw+JzcBjETTx+lf8RsKPZ13w8
         OC09/Gf/oqdff6XcWwJBK7Sf7oW3hCks4EuojXMZux1vUD5cjeC7cWqwclVxeHM4NRbf
         TFqYw1h71nicwBnBfXGXT8KPNj/xtcQAoMDM0oDOdNKvpsE7WPPww+fnTN3ofSLFwJGw
         uVrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVT4+A4teYUzVvwDIRLWgYpewzDetydRZPzFkquWCYug6xNFa2MaFglyEPLfOZOccavAATFdqbiRw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyMj+nKLO6bjtI0dZvFmyLQ2MXNmu8LPXVI1oLuitLvFZCVwM4x
	hZVpD9sKgeRrj/5vZbWWpBnCanQHlj44BajAhdGvCVDOyMi83XWyKjI/kJ2YadtGZ3xhefvBekU
	Y
X-Google-Smtp-Source: AGHT+IFoQgzEMfGo0aBy0mlJR7a08HZhLYaKLY+t5SGbuPr8PJXUFN6rMysDGvX7EFtV3xqDZ3OOvg==
X-Received: by 2002:a17:902:e542:b0:1fd:d7a7:a88d with SMTP id d9443c01a7336-1fed6d24609mr119103025ad.11.1722350776345;
        Tue, 30 Jul 2024 07:46:16 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7c85cb5sm102609305ad.35.2024.07.30.07.46.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 07:46:15 -0700 (PDT)
Message-ID: <7f4ce37c-d38c-4438-a18e-38f0c2b2a204@kernel.dk>
Date: Tue, 30 Jul 2024 08:46:14 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: add napi busy settings to the fdinfo output
To: Pavel Begunkov <asml.silence@gmail.com>,
 Olivier Langlois <olivier@trillion01.com>, io-uring@vger.kernel.org
References: <bb184f8b62703ddd3e6e19eae7ab6c67b97e1e10.1722293317.git.olivier@trillion01.com>
 <99aa340f-2379-4bdb-9a7d-941eee4bf3bf@gmail.com>
 <0ad8d8b1912f5d3b1115dca9ee229c6f6c0226b2.camel@trillion01.com>
 <0de84f6b-bf13-4c96-9788-1089d4c3a959@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0de84f6b-bf13-4c96-9788-1089d4c3a959@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/30/24 8:08 AM, Pavel Begunkov wrote:
> On 7/30/24 15:04, Olivier Langlois wrote:
>> Thank you Pavel for your review!
>>
>> Since I have no indication if Jens did see your comment before applying
>> my patch, I will prepare another one with your comment addressed.
> 
> Jens saw it
> 
> https://git.kernel.dk/cgit/linux-block/commit/?h=for-6.12/io_uring

Yep, I shuffled it below the lock. I queued this one for 6.12 as it's
not really 6.11 material, and the other two for 6.11. I did a bit of
commit message editing for all of them.

-- 
Jens Axboe




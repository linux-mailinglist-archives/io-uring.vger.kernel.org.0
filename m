Return-Path: <io-uring+bounces-897-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8A49879765
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 16:21:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D82C21C21974
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 15:21:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E411C7C09F;
	Tue, 12 Mar 2024 15:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="elI2bz84"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2227C099
	for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 15:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710256895; cv=none; b=sNfeVnlcr9lV3wwSlU54jyyqqScZBzX+5uiivNUHJ3x0IBbuzIyLkpk24tx40bz3rnH1wYMlH2DpxeR1fz7KABuXKdEEIEpPrwPT6sHBdp+cVYFebr90UrQopHbguJQ99gl4QkDoL9JN3YZP1f+Q+ll6LWdHf7XBeTTBx2jWyxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710256895; c=relaxed/simple;
	bh=6POe+SvA0dsjF01BwyLDxeHg0sPG7dx2CVsJuWVp/J4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ThWMeENDXXdxbx/et/MWJ3PCP3lqufIdqrrGGIfWXqZbt4CaRE5OM7g65yVUjyUiYd8y4tjHCePNGXkslJNlmAEbInBREWWKi3qe5Q7hz43sato2Gu/p9RkRnsW4AV0+dIwpgINlkEC2k097WdD4h9WMWgQuc/S9RfGfTu//gP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=elI2bz84; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-55b5a37acb6so2126354a12.0
        for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 08:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710256893; x=1710861693; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WA+2UZeZ/+bV4iFdtAOVHcnQcmWrPZic0/TGwaAO4ME=;
        b=elI2bz84nuZuKwEB9YYcvLOhSiBh7Ri8q4cDdboR58mijHN8V/OpC5Y42/nv+MZu0Y
         0pKsM9LS79Z5EQqUzvv+XRcUon87yapV4xfJ8+3FkeOnFxXFQqQIK/h3ewcgIL7oPT47
         0DTSblNWs97xP6DPoj7r01EI3tdzCJi7N/v5gKaOjJJd+zFyGk+UhXh3oam0xvWRSbW9
         kAJJ+OAEATdfyoHNb45s7NVI1LYcSD7K4MD3tTcOpeTuR9TKcJLafkxs4RnPqrmCUWHT
         J1htpbf5XoA9e5j19JlL6+vQTI6ra8zv9Zu0DRIvfNHKDc6Rn5cRwYCguPhFyZKsKxqf
         M/uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710256893; x=1710861693;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WA+2UZeZ/+bV4iFdtAOVHcnQcmWrPZic0/TGwaAO4ME=;
        b=WnCaIpodBLE4aYqq/9JWEujgCc4/Ba2xhlqNV9nPcal5o233dc8YboAhdnG7VLW4yo
         VPNCtscKRY0cC0EAECLXsqR+hnCRexFRvjSf2CB1MmaWe4eGz3Cv3w5agK1jIdV1d5v2
         L32BmK4Yn7WSG/dz8nzY9hn67fKJgLPr2fzN0/vv6kze+LaPdPq5vf1Agtf0zXb81L7a
         zrFlBmYVi+s6IWGEAB30o0awac1xwY6Nrmu//FZKlB1A5wSOeHj1RMr/Zd2j1/QpfW/B
         a0aLkww768GtDhGIOKECHcdDCzUiPGCzGr2nQq7eJla3XA0EtRymSCGo+gr514kCYHrl
         2r1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVDhMs6VFEwqIIlKTqqZsgHrYMKpjBNqRMmjDCBustCd9aDemYYWQ/2QFeouQyUK4j79gcb9mpELy3KRRhYOEzV5QBz3GZmmAs=
X-Gm-Message-State: AOJu0Yxq/n8LDKnKy7Su/9965Kn5Y0V3YIl/UHupHsRcIo+g6ciyEN8c
	6T5bI3ivbLTWfw0+fs3nivbNOxCBWP6RQjsrG/kebbwtY0RQ6ud1s36MD7S4H/z1Y+ZglaTblBq
	E
X-Google-Smtp-Source: AGHT+IGijTtYOFstxKa7CmdTQdRjum5vSSCFAy8GTqnPUizXeUrItZIeWJrTy+ZtvVMFfRAtlpuR4g==
X-Received: by 2002:a05:6a00:939a:b0:6e6:9560:fcf1 with SMTP id ka26-20020a056a00939a00b006e69560fcf1mr2337834pfb.1.1710256892849;
        Tue, 12 Mar 2024 08:21:32 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id r2-20020aa79ec2000000b006e31f615af6sm6446435pfq.17.2024.03.12.08.21.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Mar 2024 08:21:32 -0700 (PDT)
Message-ID: <fb57be64-4da6-418b-9369-eae0db42a570@kernel.dk>
Date: Tue, 12 Mar 2024 09:21:30 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10/5.15] io_uring: fix registered files leak
Content-Language: en-US
To: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 Alexey Khoroshilov <khoroshilov@ispras.ru>, lvc-project@linuxtesting.org,
 Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
 Roman Belyaev <belyaevrd@yandex.ru>
References: <20240312142313.3436-1-pchelkin@ispras.ru>
 <8a9993c7-fd4d-44ff-8971-af59c7f3052c@kernel.dk>
 <466e842f-66c6-4530-8c16-2b008fc3fbc6-pchelkin@ispras.ru>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <466e842f-66c6-4530-8c16-2b008fc3fbc6-pchelkin@ispras.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/12/24 9:14 AM, Fedor Pchelkin wrote:
> On 24/03/12 08:34AM, Jens Axboe wrote:
>> On 3/12/24 8:23 AM, Fedor Pchelkin wrote:
> 
> [...]
> 
>>> I feel io_uring-SCM related code should be dropped entirely from the
>>> stable branches as the backports already differ greatly between versions
>>> and some parts are still kept, some have been dropped in a non-consistent
>>> order. Though this might contradict with stable kernel rules or be
>>> inappropriate for some other reason.
>>
>> Looks fine to me, and I agree, it makes much more sense to drop it all
>> from 5.10/5.15-stable as well to keep them in sync with upstream. And I
>> think this is fine for stable, dropping code is always a good thing.
>>
> 
> Alright, got it. So that would require dropping it from all of the
> supported 5.4, 6.1, 6.6, 6.7, too.
> 
> Would it be okay if I'll send this as a series?

Yeah I think so, keeping the code more in sync is always a good thing
when it comes to stable. Just make sure you mark the backport commits
with the appropriate upstream shas. Thanks!

-- 
Jens Axboe



Return-Path: <io-uring+bounces-969-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21C7A87D127
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 17:24:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC9BD2834DC
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 16:24:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF440446BA;
	Fri, 15 Mar 2024 16:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cim9Eo78"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B6F45944;
	Fri, 15 Mar 2024 16:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710519866; cv=none; b=oBpNAPCMulR9CrYTVOjIYiZeIqO0I3yXVZSm1rsBCIAn4K5MnYaU7W1dCLoWuOfEdtjAYTq0McQR9vylqKwZ+DRV8zy5bJe+dxjnYTeAR3Rioft0GpdfilhovO3u+WJ9WlGifbd2krFzPT6VS12aN4uOVWhn/Da1xgCS+cDp/Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710519866; c=relaxed/simple;
	bh=Ie3hzWKDZk9LBtiyCPnwtgIrU89JAwCyeMZTUTwyvB4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mpPQ7zt/k0UcmhPbPC8fbULyE2RXnxNcchAuBlTB3zL/3QpLGeR61n0eO8hMzbsfZyIUh9FTL2UfbD+/oSlM/KQH+4kME10JOIhuGV3JEBoBkwXRJ2ou10aJwwJ3OQjIzPiBDgGLk9YJuDunMDR1JFHagfxT8XClLOr3fsHDgJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cim9Eo78; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-33e672e10cfso1195448f8f.0;
        Fri, 15 Mar 2024 09:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710519864; x=1711124664; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=InJjIecxqS0noVAl+hGJPnuyuXiLaSAuElMhtMrSFsA=;
        b=Cim9Eo78hsSJADkCbQ0XpO9WfbPigiXQ4V1mSKGUculbjCRfoQ1Pihv3DeuW8jafEJ
         ctsVo4N+OmzVHHoHTB6GcmDKii34rVk7X6QKliVlMpDe9dk46ceU2RFKeTeh5zQQScbv
         PqsFNx9LL3OSapodyP/9/Lr8Nf3cKiWnPBf793pN1ORyv41pihEWW3ETAINeVPmPd+oE
         hQLNnUZW+OPUWdvl1MJsTo9UL5uC59crHfv73jQDqt3ynHpR1FyHsxO8d7NrEv+tZ9x3
         ObVrvAJpr+17ttfGDWq5u8OCknRjXIOZAJEffQoZPCZOQN1VOz6IpryVQ1EUpojmAe8P
         tzdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710519864; x=1711124664;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=InJjIecxqS0noVAl+hGJPnuyuXiLaSAuElMhtMrSFsA=;
        b=U+72VppytUcC/JK89YSIp+MrE0khOGS5TAWevfeTiTqzMoAO7KAXdaknYm0xGszFXY
         smWsbwsI+tCBlB91Ib9v0NczWgDcGomNDiCF0tLzh8SUx5kWc+rVQEgu0bPLMiJ3wfbT
         oCAse+s+3fF6Jv4szmtGuk/JSeDk8hUSqsTVs5Kd2nTeXfpQppGuI6ds9MIa4M1Oi27P
         YJw/oyAlZFMI3+ferF5Gv13mGnQDWBtpWpUbFbayjKnSxvhaWs8yIJegNorjPa8vlxSY
         kYGsL79NxEYDx/sANL+qoCbGGctzcaI6MpAscGJkxLpxTW2hD0hiXLNLCZi7MgUtCGUz
         Ubew==
X-Forwarded-Encrypted: i=1; AJvYcCWuNnEvo6aO1Ln3xLIA3oslEKDR+EQelKQxhu+awG5R2Y0u4kl1zrr5rQI/1bAftqocqO3FmrK/q4kC/j4VZgrbTQv36tL1r8I=
X-Gm-Message-State: AOJu0YwaDr9mifG4nF6wZnZr8yeMNDdwvwPoGlZHjzc3O/wadlFCsls+
	2JxWQPxdMiSGxHWCiq/RGuFb0PuHGi/WaTH9+ciS+mVX6D7nbjmh
X-Google-Smtp-Source: AGHT+IEkrew/a9GuMIhSC+VCAl+i1VLjsmaZhYMtRWBXsh0Jp9/W9zNJXUYiYpTe97XtutmDEh0E/g==
X-Received: by 2002:a5d:54cf:0:b0:33e:8fb4:f3e7 with SMTP id x15-20020a5d54cf000000b0033e8fb4f3e7mr4561324wrv.26.1710519863796;
        Fri, 15 Mar 2024 09:24:23 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.141.58])
        by smtp.gmail.com with ESMTPSA id n6-20020a5d4006000000b0033e699fc6b4sm3533630wrp.69.2024.03.15.09.24.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 09:24:23 -0700 (PDT)
Message-ID: <7a6b4d7f-8bbd-4259-b1f1-e026b5183350@gmail.com>
Date: Fri, 15 Mar 2024 16:23:18 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/11] io_uring: get rid of intermediate aux cqe caches
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
 Ming Lei <ming.lei@redhat.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
 <0eb3f55722540a11b036d3c90771220eb082d65e.1710514702.git.asml.silence@gmail.com>
 <6e5d55a8-1860-468f-97f4-0bd355be369a@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6e5d55a8-1860-468f-97f4-0bd355be369a@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/24 16:20, Jens Axboe wrote:
> On 3/15/24 9:30 AM, Pavel Begunkov wrote:
>> io_post_aux_cqe(), which is used for multishot requests, delays
>> completions by putting CQEs into a temporary array for the purpose
>> completion lock/flush batching.
>>
>> DEFER_TASKRUN doesn't need any locking, so for it we can put completions
>> directly into the CQ and defer post completion handling with a flag.
>> That leaves !DEFER_TASKRUN, which is not that interesting / hot for
>> multishot requests, so have conditional locking with deferred flush
>> for them.
> 
> This breaks the read-mshot test case, looking into what is going on
> there.

I forgot to mention, yes it does, the test makes odd assumptions about
overflows, IIRC it expects that the kernel allows one and only one aux
CQE to be overflown. Let me double check

-- 
Pavel Begunkov


Return-Path: <io-uring+bounces-9682-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29EF0B50467
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 19:26:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9A9F5E1246
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 17:26:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F368356915;
	Tue,  9 Sep 2025 17:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VcCaMTv2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFC13568F2
	for <io-uring@vger.kernel.org>; Tue,  9 Sep 2025 17:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757438783; cv=none; b=K3i+GIoN0lYCIUolGTbTQUfXpQRSwlE39xo8bqrFTeTeug+tDWqyCTcu/TrwtnVB6zmNHUYkt2ZQo8Fo95RDnbH8bm0xJhzKi2GizYWbpx2k1O5Kj6H0FdyxENirLCxjWyw1urp/grAauW2F4Yjqbe3lyT5K01/cjHrdkECnC8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757438783; c=relaxed/simple;
	bh=w3dda49bNz9voqj0u5TQ4cIEZEIRTG781SvVnQ2M8+E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BG0erHLAMxfoVAvOAsoDawEU/KG6qi3qBoku0XPwOfxVx924Trka/ab8tXFB5eIKk4kCBPBp0Zgd11B4vqYdrhEVUvDWK85N8HOUBF6Z5NdvFChJMGTlWs4d/Lotlb1fJs0QZC8Cy9jBkEQzG9z6el+BRzG5Dm+3BDi9nxoLE5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VcCaMTv2; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-88758c2a133so536323239f.0
        for <io-uring@vger.kernel.org>; Tue, 09 Sep 2025 10:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757438780; x=1758043580; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZXzL+MzBMX4xvnA/6SWkWrF76gCtEMsscBnEBOB1jMw=;
        b=VcCaMTv2suqC5faQX2pBWCioe1OYsCJ4bfms7giRM337sFhpVYpB90Fxny53UIp3Zq
         DitQITqzhwXJTsqXCDWftMfB0ZSv+lIBrjAxvmEkDwxWbb9Cy6Tb4zgOE0TRsLS5YHeD
         pVzipsU2Gf8chvAMBr1Z0uCe15ZxiSoAmUzqitePhdilGpHf3tu3nT44TrOgY3bfOXnG
         lUA7fU+DdZG+ch8j0ZJmZc3APLO8KsQvUhvPsyLzcRf9BjfdI19ih+r9HNtkCrWm8gqd
         DMRnKeKNjPrNEz22VtQu9tyPiwtLOG/JSOnzBBPj0Rg8YNaiOOixMjpvoLRuwDOcNWqh
         hwbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757438780; x=1758043580;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZXzL+MzBMX4xvnA/6SWkWrF76gCtEMsscBnEBOB1jMw=;
        b=t2tZS6DQgE7acYIFM0ehiR8oY6Ys1Pe4g6sbrDuBA0kvWlg1sju3JrM22Qg0isqsKj
         bm6vsQA3Esiw9bxzaAuZEfwR3BZ1t63lJZnp9Q+qc4EC5Bb0GJmydb7rA6BnJAkFq9kN
         GNsGkaKhJqU4HpgdvFxJ6Y9ml0KD+DNMTNBlgnqV7fx/VzW3AdHfrioOWSioO1FhZx7t
         OqMCRoo+2DMqCvuu0+W11IE49/v02uk//O0dZQ2mbL0HUO/cYo5D0EaItsrtFYMC28oo
         zT9He/q184HJLSPqxNqFkEmjJdziXGDj+EljJK/F/7P7UXiHUBW/UqhyDW5He2Cn3wBF
         1qAA==
X-Forwarded-Encrypted: i=1; AJvYcCXxlvkQJ4bw4dwHDbPk/QVBGgkCsVWFqbhiXdT65s09MIl36o5SMoMjgtQmBKCLC02OZQbadrRIiA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyUVgCMEwMh8C8POLf7FUZk1QWfKJNn3aZxnXsY2mDFrZHTXMVc
	KvCZHmun7YuNljSlScDC0Nc8tEzmzeJL7Opmp/5xmHq3aQhB18Aus+yMhBeM7wZ+ln8=
X-Gm-Gg: ASbGnct1dtlluMyvnedPu/IUx59MzLUAXCcewAulUa6q/GgpaaPxUggHHxeOs177cqu
	L9YDt0LwTye0Ozzlu2xAepYMPhuZhswbnhxyjU/XOMxNoLnjuQeYiRHHlKQ6usLAMRNiG/hiEVL
	uDQ3Bf+RwfwL9+mvZePEtxCvCZtnJlrRPCNZiMM7F6Ebq9f3Ysyp/CzHml1YlGRoowHqDcr6u/R
	jdfhukTqC5goyRVqo041KNP/Hb8nioNlOByhSs9liU5BMLiBez19/+/132/RBFHS8KK+jMX/D2X
	SIqwZ5jwv2o4sNnLGABLDXpEK3YT2hpejQjuQamn3o0bmzIIYj/t3aHxg2R/1yfond7p9sdCjEb
	gUaOQPhICnwtR1dedS+c=
X-Google-Smtp-Source: AGHT+IEDIJxRrCDoRd0PL3WQuDi8SnQ/UVNbt2HDmkns706+HN5Aesz/cR8Hq7g5UkgwMebu0TbTUA==
X-Received: by 2002:a05:6e02:12c3:b0:409:5da6:c72b with SMTP id e9e14a558f8ab-4095da6c7cfmr109467745ab.4.1757438780266;
        Tue, 09 Sep 2025 10:26:20 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50d8f10a1e1sm9912093173.35.2025.09.09.10.26.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 10:26:19 -0700 (PDT)
Message-ID: <72dd17ad-5467-49d3-9f40-054b1bf875d5@kernel.dk>
Date: Tue, 9 Sep 2025 11:26:19 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] b4 dig: Add AI-powered email relationship discovery command
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
 Sasha Levin <sashal@kernel.org>
Cc: konstantin@linuxfoundation.org, csander@purestorage.com,
 io-uring@vger.kernel.org, torvalds@linux-foundation.org,
 workflows@vger.kernel.org
References: <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <20250909163214.3241191-1-sashal@kernel.org>
 <20250909172258.GH18349@pendragon.ideasonboard.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20250909172258.GH18349@pendragon.ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/9/25 11:22 AM, Laurent Pinchart wrote:
> On Tue, Sep 09, 2025 at 12:32:14PM -0400, Sasha Levin wrote:
>> Add a new 'b4 dig' subcommand that uses AI agents to discover related
>> emails for a given message ID. This helps developers find all relevant
>> context around patches including previous versions, bug reports, reviews,
>> and related discussions.
> 
> That really sounds like "if all you have is a hammer, everything looks
> like a nail". The community has been working for multiple years to
> improve discovery of relationships between patches and commits, with
> great tools such are lore, lei and b4, and usage of commit IDs, patch
> IDs and message IDs to link everything together. Those provide exact
> results in a deterministic way, and consume a fraction of power of what
> this patch would do. It would be very sad if this would be the direction
> we decide to take.

Fully agree, this kind of lazy "oh just waste billions of cycles and
punt to some AI" bs is just kind of giving up on proper infrastructure
to support maintainers and developers.

-- 
Jens Axboe


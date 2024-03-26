Return-Path: <io-uring+bounces-1217-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DA1D88B8CC
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 04:39:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF8F31C32EBF
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 03:39:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD336129A7C;
	Tue, 26 Mar 2024 03:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vdbvphlI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC951D53C
	for <io-uring@vger.kernel.org>; Tue, 26 Mar 2024 03:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424371; cv=none; b=Yl1lHQFWgahR2M5lAcKRQAMXEQAFGuttCzqtGXuCMcxbp6U3LonaSGoKrhDDMo+6hRZ67jYmEo++dC4h585XMsW0l8zkaimYfnJ7dlah+WgJYnUYUpmMzcBAF4h2oJCGFq85s66PHE4XKJjQ0JoGUbCdvT1pnK0M1vz/fod9TpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424371; c=relaxed/simple;
	bh=uLOGpXy3TAm8xxYZtqs8rVS5uFMWT04mTqs9ZngYo1M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GvFYeGEEp97c1G1VTXiwwQDaaz3q+e9m51Qf3cK8Ddk79YxKDkhWRPlaN6Pivf81zrJPE7A6fAxd9DV1sprrmkuQqzl5H8L31NOY0wnb5k5O5hPDENfIMbmowdkI5Z9VhLlZm4+Ae5IdXX74yo0ke1ldH7y5m5dFvs4oXuZ+oLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vdbvphlI; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-5a46b30857bso1250311eaf.1
        for <io-uring@vger.kernel.org>; Mon, 25 Mar 2024 20:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711424368; x=1712029168; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aYyWwyq5NdihiY0183Y4ocBSorvsV4N+BBq9vl7LYDQ=;
        b=vdbvphlIwlAg9HK0XXsLXppedzTrJW9OVl8mAKYqyD9j1lPQdeF0/ZzXT4VHR22Mx5
         abLyulArPJE0oJk/rjdDIZqtfQadEtUDBL+1evKs8vOUI7T2gPSJTcV5/ALdfOKIq9ue
         MTjTG2yrsQQ010jdDp0GI+46VOgYbtyojn/Q+p/Gws3GFfzJmDpbKNzuDABT+lzKsSVq
         z5ts63mGgyN5pT6RDuqKxTA4j47Gwiu4ck4Mbxll6hl3qaxf6kmvlSC1Gie3O06/x0Qp
         ugJ9JPh+d3UkdiUG7qLTqUGStw9wNWfyxXe8H9gaxitfFvwYbtZeyfEqsgn1oboeQ6zx
         rQFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711424368; x=1712029168;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aYyWwyq5NdihiY0183Y4ocBSorvsV4N+BBq9vl7LYDQ=;
        b=dflIuchBuPqEVFQvRZoiKpqbCW8BRVPvIo+OyVYAqMRvWqAL1jlivLn0fRQiw0BCmg
         P/rGWo3wqkEW0F2r1S7WDikJM80SDsKmESPnGV5Tg9OOFtIFHfchgJxfKM2rnV/UVrks
         yPRFwaR0qFnabOsPBZ6Q+V0mNHg0d97QUMD2Dk8KLOaT0DKcO5ftgxOTeoOs/SfiUlqH
         k4aZnVurUkUNcsPzfF+9qMJyd5K4I4llnxB2bJm+ZZoYguE5gLstwOVl2xAtuIjTb5y5
         msIxR06oMHf4NbEz83BLCKP5I/3z9V4RS5FrW2paBenUnZjNIsBjGLIUrmf+WNZqfHNW
         GViQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlIe2POZv73j4O8AcG5q4HQ/HEgMcWYi1SE+D4fwOv4RY2zAp4Ie/Oq5QFQAn4hcrqMS/aie+PzkX2J6cUTesAZX9OERdUOYg=
X-Gm-Message-State: AOJu0YxZjJaIFd33+BWh0JLZsUbimCUsNpEBWqL70AQHGA0onNMW+eZU
	Dppo9t3BVqrdaiRBoJewKa4erx8Cs05Gso8XTsPXzl71r0JHL3Eq/q9AKZBzGCQ=
X-Google-Smtp-Source: AGHT+IElFKMAHk+SOA6w9kBY0nmgmx2P2dLSXK7tM7Mw9hlbm3C7RcjZHbgY1CFKwd2m+Z5N0UwVTA==
X-Received: by 2002:a05:6808:21a9:b0:3c3:be3e:aaa6 with SMTP id be41-20020a05680821a900b003c3be3eaaa6mr11077672oib.0.1711424367798;
        Mon, 25 Mar 2024 20:39:27 -0700 (PDT)
Received: from [192.168.201.244] ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id ka5-20020a056a00938500b006eab499fb50sm1053889pfb.128.2024.03.25.20.39.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Mar 2024 20:39:27 -0700 (PDT)
Message-ID: <f7f547aa-998f-4e9f-89e1-1b10f83912d6@kernel.dk>
Date: Mon, 25 Mar 2024 21:39:25 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_uring: releasing CPU resources when polling
Content-Language: en-US
To: Xue <xue01.he@samsung.com>
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, anuj20.g@samsung.com, wenwen.chen@samsung.com,
 ruyi.zhang@samsung.com, xiaobing.li@samsung.com, cliang01.li@samsung.com
References: <20240318090017.3959252-1-xue01.he@samsung.com>
 <CGME20240326032337epcas5p4d4725729834e3fdb006293d1aab4053d@epcas5p4.samsung.com>
 <20240326032331.1003213-1-xue01.he@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240326032331.1003213-1-xue01.he@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/25/24 9:23 PM, Xue wrote:
> Hi,
> 
> I hope this message finds you well.
> 
> I'm waiting to follow up on the patch I submitted on 3.18,
> titled "io_uring: releasing CPU resources when polling".
> 
> I haven't received feedback yet and wondering if you had
> a chance to look at it. Any guidance or suggestions you could
> provide would be greatly appreciated.

I did take a look at it, and I have to be honest - I don't like it at
all. It's a lot of expensive code in the fast path, for a problem that
should not really exist. The system is misconfigured if you're doing
polled IO for devices that don't have a poll queue. At some point the
block layer returned -EOPNOTSUPP for that, and honestly I think that's a
MUCH better solution than adding expensive code in the fast path for
something that is really a badly configured setup.

-- 
Jens Axboe



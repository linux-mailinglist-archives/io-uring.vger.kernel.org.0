Return-Path: <io-uring+bounces-928-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D129D87B308
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 21:50:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E8751F2372A
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 20:50:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFDAD2E629;
	Wed, 13 Mar 2024 20:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rXzTLllZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EA712E6C
	for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 20:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710363042; cv=none; b=dGRbApnafRY076h3GIIGPDKKd5At1UvKhToILVXtKMvIRSoJSaqiep1vCtQCtTsQvOAWOBS9e5c+Toh6BSVOC6uo5dZslwf9ynu710HwPSfJLrMCBnwV6aVojpF2ANMaZODoMzSwPWwaFYHoovzNJivvrWw7RmZ6Vk7nCtqio+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710363042; c=relaxed/simple;
	bh=t+AV4nBiLpBpYcNXKRdm9wUTbLCThdsQKNG0S0V0J68=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Mi63GOdw/DFQkjExhFxGbZhjTCvlNjUj3VusJM2a/icUA7V3mcSdGGHzkvjiv8WwZnJ8A8X2MnpvVBQ1ZA5fp/dLd9/Dj258nDsI78JcS6sgDM5hCca+QAjSfhZ//iMgC4O4yJmhrQJO6zZG1hvTrOYy7Mur3+ywwESDt1G6DOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rXzTLllZ; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3663903844bso481995ab.1
        for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 13:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710363039; x=1710967839; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uMnm6IDhQgFB7co4nB5S4l0ki6jOkmdQyiN3wFNe8GU=;
        b=rXzTLllZ/gYU0flVjn8huCEHyxLBMFeJFpfZJ1rK4+B6FKr9QK3j+uRPSepbzSlK5E
         A+Mt5EuyL6O/ptexuXRpoomXAxivofIsle0GRAZSUiZOyMpvrsGCcaE6AuqRZqvQMb/Y
         FMtG1q290+HJx+8QzpbuSY6Zo7imqRH0RKVJFeGqKRd7bHU0kugQjle5BJ+tkoP8qm9M
         Xs6xtlzVfFNdlGJXjnynhggkW+wlRGq/hoTzwf9UulLUhyzInqq6maVykR/0FtwCPP1S
         +kBzGOPo1UE9+jw/VExFdq9ICeP3v+coogouiCB/6Fr59U3PTx74VWzOLZJ5B5FZeazW
         YB5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710363039; x=1710967839;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uMnm6IDhQgFB7co4nB5S4l0ki6jOkmdQyiN3wFNe8GU=;
        b=ipu3oWX0NtpiGaBvvA2TKuIm/qQhKUuKEpX+oOuPnWscjtp/5xZfJ6OJLTrnkL38LI
         GME+XAN/++UlboJ+KXS2cppwbnjqicsY3fRZ4+rS/4CXQqLPc7knCZhcFBuz/i1yCBBo
         wopIOGguJ9p4qO4FGuZHEWY5LVJAPEyE0W7O7vMGcrLVLdtkeHXLxuRfmfRDmGOhcgZi
         tfl4pr4Qj2RJm7xbw/HsCrSpYxUEo6d4PLJN3u6WQYMtjrBhtRqrMbV69+m7zNqWaNsj
         x5qM+2M2eLpRyJOZoLNu0J/Fn4wxIPY0FSxHHO7JZ8VflsnU8R+SNMC0bv0ZOigEU6tv
         /HKQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1cBfVo/EylIi3MctG618SWZqwezs89YaJSWlZJnyjKlLMiWz9PibkMAe2HCpg77DADq72sN8N+MkxfB4jwCl4elYZTVSYzPw=
X-Gm-Message-State: AOJu0YyHQd+zGcJYgp4lbvdbIoVImmgs1WPSdNgVHxx7r3InJSabZjnj
	izE/NTrXVvUrhLOd3itgXgcQIw+iS99jlDAZDXv/mFZsOR9fzp0rB/i59iLU1ptqdrQWEdNgotS
	f
X-Google-Smtp-Source: AGHT+IF8CU4JXgsNlV4hgHxDI5uAWDXEudBd4pAejqbt6SDscrC9ntUUGQDqhS1CJlzJ0RbcEhhm0A==
X-Received: by 2002:a6b:7804:0:b0:7c8:789b:b3d8 with SMTP id j4-20020a6b7804000000b007c8789bb3d8mr132926iom.0.1710363039254;
        Wed, 13 Mar 2024 13:50:39 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id p19-20020a0566380e9300b0047729416c75sm37466jas.98.2024.03.13.13.50.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Mar 2024 13:50:38 -0700 (PDT)
Message-ID: <af4cc4db-b8f4-445a-9ed8-f2eee203eee3@kernel.dk>
Date: Wed, 13 Mar 2024 14:50:38 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring: simplify io_mem_alloc return values
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1710343154.git.asml.silence@gmail.com>
 <ba1f5a30be45eec6cf73cfdbf4b4e1679a03cef8.1710343154.git.asml.silence@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ba1f5a30be45eec6cf73cfdbf4b4e1679a03cef8.1710343154.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/13/24 9:52 AM, Pavel Begunkov wrote:
> io_mem_alloc() returns a pointer on success and a pointer-encoded error
> otherwise. However, it can only fail with -ENOMEM, just return NULL on
> failure. PTR_ERR is usually pretty error prone.

I take that back, this is buggy - the io_rings_map() and friends return
an error pointer. So better to keep it consistent. Dropped this one.

-- 
Jens Axboe



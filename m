Return-Path: <io-uring+bounces-10876-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAC3EC992E1
	for <lists+io-uring@lfdr.de>; Mon, 01 Dec 2025 22:30:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CEDB3A46C7
	for <lists+io-uring@lfdr.de>; Mon,  1 Dec 2025 21:29:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0D9F280A51;
	Mon,  1 Dec 2025 21:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rXNDBwY1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EBA283FDD
	for <io-uring@vger.kernel.org>; Mon,  1 Dec 2025 21:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764624583; cv=none; b=BZrSBfJBGQ9zr/YOhwDIWhmJIGXW5zzA4FD/zq06oNyWo6SuNgS7NXsurh1aVvxd1vUYVjpE2OkxzwMSL+keuL4WyL56YonjnqUHvWrMIIFbwfpaN81CdyI/OFRo+M80qHlminFq4goyok1RqUWYh5N5HLPCMqv4iTz6HNf0f/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764624583; c=relaxed/simple;
	bh=fUr/3r8+X9hQq1L8RjOlfNQtiYU50/Yd76LoDMVuowk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BfGDV9SC5CyuosZNmF4/pwoKl9mVtRyoxo0y1a+Yd7wFTSrX+3JADFGCqPuu/lutnmmbhQeasNouV7bJhRoJ6iU559gUeWLd+pCumNXlpLUDUxKH1VArl16sjaksdOQg8xp0BGNPILlbkmD0ZC/e9OZoVqzSen6W0ROMZ/nbKpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rXNDBwY1; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-3f13043e2fdso458298fac.1
        for <io-uring@vger.kernel.org>; Mon, 01 Dec 2025 13:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764624580; x=1765229380; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5YBoKpCxU3I3NlwrrVz9XEzCD2XS8PMwXx2t1PI0yM8=;
        b=rXNDBwY1xgEx7JW+/Y0xAp4LmzSwvpSXAZIQAJnlfV/Zf1fCpBRFIo0EFfWbMQRVhE
         GW1GNEOVgoJKVDkweLVt9mnCGnanqXhaSVkB5UcXbehfQU7KsYt/CBULXS9+atVOxSQd
         D09zk6a82VO2MFKh2Sohc8g9TypPqzrN+zOYJ8w9LYsvZxHxDIn+09Ssy8hDDIzD7u6d
         0hn9T/I8d6wgWnQ2kCfTHeNchQ1QZ2TfxC23KXFDrz6hUMmLdrW2WImyEq0+IYZ1wwrK
         wc+b7BxXqph05tJlZ9fcReMV6i/PUgz+VCOXb3uh2Rr1JrcwNjmwyaSyisA6jAss/QBv
         sBGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764624580; x=1765229380;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5YBoKpCxU3I3NlwrrVz9XEzCD2XS8PMwXx2t1PI0yM8=;
        b=jPo+JDKZUBjCjMbWzO7phM3nGzY9zBXQUO+GqGrMyUvqAN3El+Q4ImaqfwIposK1AZ
         GnD+ixMgX1c3wKBYA3nXF8MqQJP4/kJd9Qvj62BHyO9GPj5b3FrxOnjwTK9EZtXpMPL+
         tC8Wyih5lsSYrHQwfCSqlJFG48W9ir571NZUgDvaWn4CAf6YZsGBcaJrZGmyOO9uAijI
         9qmNOIqJ32IF+hNyTdCr+TKshCIZ0hJUKIhWBMqza8wUPbeBsF49LAqLQ821bDKKrSyw
         G+/0uLOOLZ7/vBwix2U8g1jtHoH7heItTiCbL6TFy5k17wTZmRbpiWyIMBzBBHb7UvPu
         tRGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUj/5xhnU8DfTadDRG1/oROapAl24yKl3xItp2YCl9sFqd+OUyb1MC5Ip6yvMuMPdw6JGub430EVg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyg838w28TxkfvAV4s7mXRACLzFTwS1m2O5foZzH4WAS5Dbn5sg
	VdSzWVKWddu7WO50x9UndMtg//7Af1odtY2YzAzRMasCqKnbzkQ8lxvFxklO2yOz5i0VvZPUcJc
	NKax1Atg=
X-Gm-Gg: ASbGncvtzDADr0ZV2JnOiWO7g2Z37Ijxp6Mq/MRHZVQLoKK6wX/LmhFxCxnQv/Rhs5c
	H8FbWQk/xC2usFsz4uyCoylR5Q3eGEy2s7m4SarcY+39alHtJfm8yiT/xP1md52aMkHZkCDSOy/
	oWJpFYArXZJEGbak51NgJXYnpuee/8KL8ODQiX47beh3Xc/VMRH3jwQXR5rMRU5osMjXbcDvVDT
	j+4ArmF+IKKCGuzsnHqTTzU9aeklYFyS0nXgtf1VcDqeVgOzSCFRDasfviu4cbkAb5Dav3hxq1+
	luC2pZE/DENise/3ACevTQv7Iu6yUuZ1UzIPuVCUBUzrZxQOYkVtIkih2vQCFPKe5pD+3em0it+
	Wj4wgiH4Jn9+56ildSXp7yU/5OT6QZkcm2ecI657hlzsvW47aq6ictIcfVEQi2n1vJg8iCk/Izv
	4UCTN8Tw==
X-Google-Smtp-Source: AGHT+IFlQEH2qhlCNLiemJ+Hzzc3DExxXiDrBZG/svLR1ZMCQw9icQtSzdfZF588bPxbrsfx6ZEZFQ==
X-Received: by 2002:a05:6808:c40e:b0:450:5e3a:6f20 with SMTP id 5614622812f47-4511294ed9dmr18920972b6e.10.1764624580070;
        Mon, 01 Dec 2025 13:29:40 -0800 (PST)
Received: from [192.168.1.99] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-453169b3d78sm4344187b6e.2.2025.12.01.13.29.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Dec 2025 13:29:39 -0800 (PST)
Message-ID: <1425ef9c-dfc5-4802-89fd-d12aa55f93c0@kernel.dk>
Date: Mon, 1 Dec 2025 14:29:38 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] memory leak in io_submit_sqes (5)
To: syzbot <syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 ssranevjti@gmail.com, syzkaller-bugs@googlegroups.com
References: <692e0777.a70a0220.2ea503.00bc.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <692e0777.a70a0220.2ea503.00bc.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/1/25 2:24 PM, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> memory leak in io_submit_sqes

Yep that patch made no sense to me...

Shaurya Rane, was that some kind of AI hallucination, or what led to that?!

-- 
Jens Axboe



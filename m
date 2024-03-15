Return-Path: <io-uring+bounces-968-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37EDB87D11C
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 17:21:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67D921C22EC3
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 16:21:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96A7A45942;
	Fri, 15 Mar 2024 16:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BP81AGz2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BAB45028
	for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 16:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710519656; cv=none; b=fTFvVbmbcjNtpM8AqyDjke1EvraDsHmK1xMe5jFwGIrLVIeA4ZMnw1F9MjiWvIC0caBztQsb8Qsi9dV0KUm5HIeK9GeGtFO8hgqrIju1Uv6zZgnYPvtC4vGvi3Xnwhor7TI4wAcfMji3UPpfGpWbIsgnU2C13gXRMJ6sDG0b52Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710519656; c=relaxed/simple;
	bh=Z6EFxoutHZVK6zJ9o4cvquk4gB0jrtuY/AXOAoUtGC4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o29nUdGzjCObhvfyEheEo1bifZS/8++KChILBJg3842hP2Q8Hk2+wVgddJ1MAxGoPDRKvTvPz/0t05+AXUfp26+ftnpcPFhWBq24WiPRN9b3lC2XaTXBuQJsYn51JZi7Q+a8DMwq8TddGOjgSzax9pkZJiwuAlqzl1k1IPsas2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BP81AGz2; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7cbf1751c8fso9529839f.0
        for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 09:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710519653; x=1711124453; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1p0Lq0m2EZg986149GaGwg2Ju9h7+VpqiFNMJ2p+kOs=;
        b=BP81AGz2N/awkQF52BodZPZ3t48E/C8lFVQ965BnL1L8id8WAIZ3zk05/1b/3s3rAU
         AImY87/NcOocMTOAADW1YYLI9h0lzrTMjsa0iV9KR5SvmgY9gHEiQWA0fOHV4OUtgJnX
         SYYkrQe0buGuivi/ZonAkTPfVvePXgImOHKDk6sexqLpkzupsE8PrMkDcHa2k2aw1ctG
         2mqaQBG5q0Ec6jjpVBvbLOvVnx3LEdgMN1EinujZPBXroqQOhOsmgsiFf/fbwKDm3qcB
         ELgifA1RLtV63+XuYVwaUPGSG2Ob29ezqBIZKcEYtu/uKKCrUG+0PZr7VLUUT04ZbF6a
         xdjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710519653; x=1711124453;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1p0Lq0m2EZg986149GaGwg2Ju9h7+VpqiFNMJ2p+kOs=;
        b=VINhHWaY8llbiQ6IxiV00CQOAsS1xq7QYWlYqJ3tfeXWuAmA8BvEeIDuNyVg1ieDgm
         cUpZnxryi/kBXSR/TzQHCBntvpG0YEPczmwf2hvrvESddN8rvakZPnbXP0ITp1OXIYjt
         9+XRIMXToxk0raCx4EvTpGrlCt9uifyqhA6Vsp3NKzYfQvXkcmwuOgZIisesg1PNAt+I
         yFZupwxqwhq8WJeZrE9ZSn+C7XaEGp8ldCZV+eywRcz6cGdHZwQ/mMHf1I7oSoUUahrB
         CIHJjvlAcJTJTbJRrFdOaSxlxwnnUep0WUMBtEh0XgojWAjneRG+1gUE3bMlq2SqyJuC
         wKfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOYTsprG1OWYugvNCRns0071nTMQorjzVb22tnoTVF+vhBsINBGWXHoxKqSRjR+RT2O37wRu7zRe32wU2XogZCRw3AizOommo=
X-Gm-Message-State: AOJu0YyUS8ElRCM1PTro5qjG3GMqadLTdVSR42AmGq2wAqzEOLujglpI
	c9SRPvRs3ikGq1qddKarZPw8Tfn/BF+OlGeLkkb0rgM8elyEjG9Z2CSG4uFmJM0=
X-Google-Smtp-Source: AGHT+IHI4jokg11GVbWUclXTVDHBAutZIy6pCJFXre+RShmfjMMsqdBHT8OE/IHjMszpADrR9ErLOw==
X-Received: by 2002:a5d:9253:0:b0:7c8:bd77:b321 with SMTP id e19-20020a5d9253000000b007c8bd77b321mr5728782iol.2.1710519653256;
        Fri, 15 Mar 2024 09:20:53 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x12-20020a02970c000000b0047469899515sm812052jai.154.2024.03.15.09.20.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 09:20:52 -0700 (PDT)
Message-ID: <6e5d55a8-1860-468f-97f4-0bd355be369a@kernel.dk>
Date: Fri, 15 Mar 2024 10:20:51 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/11] io_uring: get rid of intermediate aux cqe caches
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
 Ming Lei <ming.lei@redhat.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
 <0eb3f55722540a11b036d3c90771220eb082d65e.1710514702.git.asml.silence@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0eb3f55722540a11b036d3c90771220eb082d65e.1710514702.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/15/24 9:30 AM, Pavel Begunkov wrote:
> io_post_aux_cqe(), which is used for multishot requests, delays
> completions by putting CQEs into a temporary array for the purpose
> completion lock/flush batching.
> 
> DEFER_TASKRUN doesn't need any locking, so for it we can put completions
> directly into the CQ and defer post completion handling with a flag.
> That leaves !DEFER_TASKRUN, which is not that interesting / hot for
> multishot requests, so have conditional locking with deferred flush
> for them.

This breaks the read-mshot test case, looking into what is going on
there.

-- 
Jens Axboe



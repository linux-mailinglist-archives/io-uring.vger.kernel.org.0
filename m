Return-Path: <io-uring+bounces-8590-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 62A74AF6614
	for <lists+io-uring@lfdr.de>; Thu,  3 Jul 2025 01:11:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D09061C41664
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 23:11:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AB6A2EBDF8;
	Wed,  2 Jul 2025 23:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="WBuJaMoG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5D425486A
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 23:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751497856; cv=none; b=feXx94WcUgFExdlCxmDumH6UZWE8H2xAgKpPezzP6HtSO2buDKdTMALcjrZmb7wAa5TmmksfsySyJgr0dqppFRSZkSX9ca/2u2IAWriw4pKOkbBpBsGRyNxfrzuZRISTIbDEWNYuHTJIvOIETZNLUOqp1rWJ8lexRSERL9I8WHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751497856; c=relaxed/simple;
	bh=uTkKxEpHkYTPh6vfi37hBJCkHIf6S1UQSyunlbFTeck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MO7H+RY1hvoyw0/PIFxSvQ8crX7Guzc96lUQbaKYU3ucvtVcq48uTTz3RKqmjdgbKbb5397DZgI1fh2kIhvdec+K7kbvrl6rVlsJgJsnhPApS5XatctEL0I/M6q0kt23pFaMVrsy+d0RVY8Q0Hlt4IDw/+BLaYsG6vdR4h+3KRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=WBuJaMoG; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-87694a21617so14041139f.1
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 16:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1751497852; x=1752102652; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mRzmI2UqKh+nJzvITL/rvNkTaM9BurV04cBbc5PSwYM=;
        b=WBuJaMoGKQMTZS4EQs/AJAXya1trqBTXROqzPweMLHv0bYpXVQcLu+RjpVeBFEGvg7
         daKXtfy4yqCo8wQ5vmvxjMAcDco53B02FfQyyzQE8npJY4Q7QrIQkgNByQ+//+zq3o7H
         bPGZKzu/KHn4NjALSGsUUgAdDaQqsEkHpRL9jQ/5QNl/zw7laV0L/O1PZoGeFrYMvO8r
         j6SHiEijFJXpmyN3p8eyhEYgZVG0shxLVR1Yl0QBCKpbhT3SaalZIr/SjJP5Q3QHDERg
         DQWCpwiG2bu+vNNmgi8iJXwcJVWoNspyVS1XVWjwDnBSS+vbdcTEtP9ipvag4S5wH+Ll
         Pitg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751497852; x=1752102652;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mRzmI2UqKh+nJzvITL/rvNkTaM9BurV04cBbc5PSwYM=;
        b=FBkAv2CVH20boFqu4aJQxco4SAgMoTPQ+0wZZjZMRR+4AmCjcTkhqCNqYBgzunTMRw
         tiJSxPnmwdipk9H+FszAo/TwjRvr+JY0t8tmw9giBMXWmFn7R2sF6HP3HecVgRgBkbZ4
         we6L+UlQ/udnZu9oCTKWwfkxOI5zcrZuD0xMTvTR6omv6RZfv2FzmlkeslXymWboubEp
         wLrV/94fw99VR0zJO7sVyjS42Dh0owlgaywZ7J/BQqc3bGXHKRGA2ic8aUGrQ8diln4m
         vNmvIrXCEnvOLCPcprrTftkAClzF1g9Qlhb1ZgSEUypZRKIyWNXS9i+GKh92W5azVC1/
         ZbwQ==
X-Gm-Message-State: AOJu0YxaAvEG8HPlsfySwxIjmWmGST3ShmyW2u2lRKKo1xrIrJimhpOh
	Ji+I8gmRuCbEGTfGEzL7+94dzEsaf7mJoNeYN8mV+E0ZbUwoHgLy9144ivhMUPpckcc=
X-Gm-Gg: ASbGnctj730GioOapvbRvKT0i9huAbMd3gBBsPWSj/xLVTopqRM31A8+jMXNMw8hQZ4
	klfGLoW/nqP+Mnoaq9N7eW5g5EjVrJ0YCaXMQHXIqj38u/d2Uzrtkh4soRe0rPEU10BAcK0DrfW
	y/AQ5j1EVeWIgPkqO5kjzeVSwxfw3lFAn7a2fd8TmqImdg55ZGXG8+sasJlajzUHd5zsvCqjHpL
	gVGApci3DfQyf2d4DPC/oOUk/ODyiPtEhxEeBdGntuBOzbjZ7CXn9+iphhAndsFGFVNSIBDGMFz
	yKZyZjHS6qsi389EY1qccNrk2EVEHMy75BLnXHUmsSnl5LJbZadXg7CbDp4=
X-Google-Smtp-Source: AGHT+IEhq6pHfoYzDGLlZdC+PVUvVjUAZEeRL0VjPgqTYNKczZpb3LgZuwy+H6ypeQSFtzmTk8D1IQ==
X-Received: by 2002:a5e:d907:0:b0:876:4204:b63d with SMTP id ca18e2360f4ac-876d54b924fmr1678639f.8.1751497852133;
        Wed, 02 Jul 2025 16:10:52 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50204ab05a8sm3182428173.120.2025.07.02.16.10.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jul 2025 16:10:51 -0700 (PDT)
Message-ID: <2cf2350f-286a-42cb-aa02-2eee7099fe22@kernel.dk>
Date: Wed, 2 Jul 2025 17:10:50 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: skip atomic refcount for uncloned buffers
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250619143435.3474028-1-csander@purestorage.com>
 <CADUfDZo5O1zONAdyLnp+Nm2ackD5K5hMtQsO_q4fqfxF2wTcPA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZo5O1zONAdyLnp+Nm2ackD5K5hMtQsO_q4fqfxF2wTcPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/2/25 3:11 PM, Caleb Sander Mateos wrote:
> Hi Jens,
> Any concerns with this one? I thought it was a fairly straightforward
> optimization in the ublk zero-copy I/O path.

Nope looks fine, I just have a largish backlog from being gone for 10
days. I'll queue it up for 6.17.

-- 
Jens Axboe



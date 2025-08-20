Return-Path: <io-uring+bounces-9129-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 03ABEB2E5B1
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 21:36:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8999B1CC06B7
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 19:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B33202566D9;
	Wed, 20 Aug 2025 19:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="N2xmSyfy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B8736CE0C
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 19:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755718572; cv=none; b=qwPtK+uDRiAbuQCaxSkvvuRrn3vk/rwywcJ4wWob+P38D/fWNUAjfHb5IAPIDSZPgmOAqMvbc9FvuJ8Q+sAAfQx3kInBeKXm4XnIbYfZhyq1FApvZaNdDBVTkiirH24kxmSuPDaYFGRZx0KsoB6CxY4V0qNGP2Vny+/zn4xG91c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755718572; c=relaxed/simple;
	bh=fS/09YLxWRt83swEvL434rci1Z30jMZQwSTy0hXoWpw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=eqqHBsrnMJD2xbeC5sby3WhEJYhA0M8MXvobQHMjr2Y3Ha7cRSVHprJSd+RINrPsQU6gpAPaBKUibxrA3VsQO5qILKi7XgSs+uejtwrP/W879pi7m0khOIYcrsx1j8Un12xBWskofMfl0lzL+VfHv87zPy2+wH3Ey5eyzRNoN8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=N2xmSyfy; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-8844ee2cb61so6526239f.2
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 12:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755718569; x=1756323369; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N4YHyRSPuWTa9KcBcli935wOTmatTFJLhoWf1OnFbB4=;
        b=N2xmSyfyTpQc4Evvf83WwqPnKXmcPFDNhw5hwH8BJhnk4Kz0Zl5eCs8wWULj1zuZpW
         7aan0SWkTWZtfQncfoHmrapn5cjnhj5+0atp040atJLWUb0j1e0vA/ogXNQqGUuUX8to
         ecGFo5x0EfPaEn7YU8p5Zaba/qMbTZQIWBAbf75e7Rh8C9mWhGLhqfk3rASWYwdGshTd
         Hlccr+M7Fclts7ZLwnZFE5tzHAkKiYCe+iBskg+MXb2gaDGOfMSlNye0eMPcQVkhUu3N
         Z5X6A2OJelaAGLF5qZKsfyc4BAV6erZ7ebso+fbf8WckanhZvzeUoUIpf1G3mpRM7la4
         clcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755718569; x=1756323369;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N4YHyRSPuWTa9KcBcli935wOTmatTFJLhoWf1OnFbB4=;
        b=AG3vlfRS+MblIo50ILWxGMOl4pGzZdqXgG+33Qb/pSzeXFnyK2dNVSUQ1pYEduibJw
         UnfL1vfCk/bDq4jIHtimoX9hai+w1Vn5xWOH5ZLFjI+g8/8W661LKIVvqNRT0SkPtgqM
         dH8Ea7PLpHHmxHUO5qHeowF06Jsz2UMHRseoBAQraYAxqIfRj2I0KZUhBAfrCojaGQNw
         fGyj57dwRQIgL1bWdws+B2KnnWUwdRF2ryJE1xWBzrwYwIs9pRcMVmAaPoTgcvcySZ3J
         uMshFnjS5okDo3JHeUFmNPd6rXG4gmg59cxxaWDcTAAFJ9sAF5qSF/Zva0e+AeaeIZiD
         dyIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMEcH+U3Cqgpt7ZfH04I6aofT3n/OLxqqsErXOlGqbGK/zNdKQe+uW79DS2G1Grs/d8EkG/ApJHw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyeOXJ9f9HjjDM+4XNXMU+lvjZjtX/cWfobTV26UZwKeS0uDNj0
	vnZX3LEsUBU/z4sVqLe2mAaxeJg1B+Le0JSVfLX4tSs33zIbTlorLGshvvS9A6dABbs=
X-Gm-Gg: ASbGnctmAH94DjUJfaJK2FOuj4R036szQL/Fal12sYxMMa+qz40Bs3bgkEWjRf09MvY
	ujMjaroQ7fCe9nrJ86Radu0nD/UDTMIp2I071Hx8w2ZfFiR5kZPp4fR3hR7dmIwx/GwOaOCZTZR
	1m5PHuhaK827bEV9QBvz3Ow7T+tzoW1s9vn47TY8gXMbgCJEV3oZX7NtYthzAT20Owiba07dBaN
	IxXK/p1XHKZ1YfZ5K3mFlk8QkGh1b+QR9n92e1g6qZunS/lBQN2bGLiiaAdq2Yxhk2QXqq1h6cl
	F9m5d2nDslZVfnUteL0zavb4GuPufvR4OyHnxvuX8gDUmmHlRaSphONNOPPthiOO/y8SPWFJ2Nz
	ZjXgr1S9Wf/9BL7QjdcU=
X-Google-Smtp-Source: AGHT+IEmYOPNvd37ugIRaNAONErKFhei/aUzDa8N8zotTuoMpenXVocJrjm57jsnvIaTATQ8ee8qaA==
X-Received: by 2002:a05:6602:160d:b0:861:6f49:626 with SMTP id ca18e2360f4ac-8847185c83cmr789082039f.6.1755718568576;
        Wed, 20 Aug 2025 12:36:08 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-884702457d5sm115648739f.17.2025.08.20.12.36.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Aug 2025 12:36:07 -0700 (PDT)
Message-ID: <46d0d30b-e9da-402d-9393-7877e9de117e@kernel.dk>
Date: Wed, 20 Aug 2025 13:36:07 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [zcrx-next 0/2] add support for synchronous refill
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1755468077.git.asml.silence@gmail.com>
 <175571405086.442349.7150561067887044481.b4-ty@kernel.dk>
 <c6ea1a29-3a0a-4eee-b137-a0b2929f00df@gmail.com>
 <b811389e-2a4b-42b3-b9ed-3d31e5e30fd2@kernel.dk>
 <20422c51-1227-42a8-8506-8f499eb53e89@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20422c51-1227-42a8-8506-8f499eb53e89@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/20/25 1:33 PM, Pavel Begunkov wrote:
> On 8/20/25 20:02, Jens Axboe wrote:
>> On 8/20/25 12:57 PM, Pavel Begunkov wrote:
>>> On 8/20/25 19:20, Jens Axboe wrote:
>>>>
>>>> On Sun, 17 Aug 2025 23:44:56 +0100, Pavel Begunkov wrote:
>>>>> Returning buffers via a ring is efficient but can cause problems
>>>>> when the ring doesn't have space. Add a way to return buffers
>>>>> synchronously via io_uring "register" syscall, which should serve
>>>>> as a slow fallback path.
>>>>>
>>>>> For a full branch with all relevant dependencies see
>>>>> https://github.com/isilence/linux.git zcrx/for-next
>>>>>
>>>>> [...]
>>>>
>>>> Applied, thanks!
>>>
>>> Leave these and other series out please. I sent them for
>>> review, but it'll be easier to keep in a branch and rebase
>>> it if necessary. I hoped tagging with zcrx-next would be
>>> good enough of a sign.
>>
>> Alright, but then please make it clear when you are sending
>> something out for merging.
> 
> That would be a pull request, should be obvious enough. Perhaps
> it'd make sense to tag for review only patches. Any preference
> what tag it should be or otherwise?

Please just send patches rather than a pull request. PRs get messed up
by people all the time, and there's no picking and choosing there, it's
all or nothing.

A review tag would be good in the subject, anything easily recognizable
should do it. Like for-review or whatever, doesn't matter to me.

-- 
Jens Axboe


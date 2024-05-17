Return-Path: <io-uring+bounces-1921-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 956BD8C8C9A
	for <lists+io-uring@lfdr.de>; Fri, 17 May 2024 21:09:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B2B128643F
	for <lists+io-uring@lfdr.de>; Fri, 17 May 2024 19:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B307312F58C;
	Fri, 17 May 2024 19:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BXm6kn6E"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C886A005
	for <io-uring@vger.kernel.org>; Fri, 17 May 2024 19:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715972963; cv=none; b=PH2PW/nIV9xxXiWgPhmNuhgifUQNOtUziQ2QS0aW7UNHvQUyxPJdHPfbVbef906V9fTHa9HoY0Ng7H/nnktCSNSMKktqYbergSPGdOhESA0oPT/EuJIOprjQ7BHNtH/gA+fjKIeeR3Csg6yY2QwM8ZQD8oFNgG7mrTc667Q9yAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715972963; c=relaxed/simple;
	bh=jrlsWPlW40xq4w5YV4XlMdxXDhEE/iD56hNAA7gh4b4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TjNYMVTIOEnYj0F5oJkJ237LkgAeVakr7yHq20gSfrCwrQi+zs/Pa03FL8qlTvttxvzxk2v78HFnQDXq6ky03x+Z+hq7mlfFtvJtkRWLx8Hwm3XPDYK/DT2e081k3ybuGVdvcI13F5yrxb7xkVkIxZjiF1rXR2xd0MzG5fT8n4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BXm6kn6E; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7e1e4508b7aso3833039f.2
        for <io-uring@vger.kernel.org>; Fri, 17 May 2024 12:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715972958; x=1716577758; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0mlKVLZ/dmHejbZlyrLvQ28TQoNJof/YgX8AO0bV1ZA=;
        b=BXm6kn6EzB1qq/2NOJHyHb9YctQvPSFzy9pqBjXoLzvhbArLlMLrLGg/St7rKTRUpM
         jCVnJR1LWPmBftyucsszWB3JaZYlCA/BfSxUX35jQDA0s+fYhwF7mRBd2LDjMO103dmx
         mgM5hnk4ai5yNmp37UQAU3Mbw9bXWgPdUXhfeIFxzVVNlIveLchJ1aCGVuIHWweEQBqB
         dF6y0W9pO5YzgZdf8bx2DwMJQV+lr8ohurMvbFd9o7afqdkC9O5bbrt2zxNXGYZDTAVb
         DWZqqlraYrCYtlFvWvl0kBopvnTu+zfU6UAHeBybwELnDCWSYAF5Zh5Hd3Pm2bCnmdmE
         a0JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715972958; x=1716577758;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0mlKVLZ/dmHejbZlyrLvQ28TQoNJof/YgX8AO0bV1ZA=;
        b=VMZJejLYFC5e77s0kwz+Qtmt/wp5KkYUQW3dJJYsNyptwaupxT/F/88AuJOA3YvR+0
         vhxwH/++v+E8sUM4NLfakQs7cVeafLn8vEfhGUz1gJAN363E/xoaBfXuuKDHmujdp/qm
         2dPP3bCIUlD/YWrgt2YblfxksyRArYrp7hzlIhXwc+J14eaiwh0hfmlj+Fi2Lpu5IXuw
         fSrUrhUHZ+DfKOEfJrYRYoGOHnrD6BM8vHSUgbNaOIXbfRAZOKtUs60E8SWO/hpTJH14
         +apzQ26H+Cbwi+MLDjrD3OVMmB4HTPGHRLH4at94tJ2kKjyKo8QNQijKgPQBnV9WsjdG
         POjw==
X-Forwarded-Encrypted: i=1; AJvYcCWzJaAJ9jRjhHIh1vXRz2z3prqU+UKUFPmozqyDneu1ITUo+c9ngIBihe82OfKTs17vKB8ZX2B+Cf6zlleVyXrlc7B331DFcOg=
X-Gm-Message-State: AOJu0Yzm59Fj1vhZzlx6oSVxeFpmmPTDX0KQXqqCyE3o30u7WkVISCPt
	RaPvzAIcSj3+XhIQbmG9Kb4519vNjh2dOm+5SNtTovBjbwLaSgdtppEwnN9rayE=
X-Google-Smtp-Source: AGHT+IGgYBynSP4G4+GD1KWVtDarbWzKPBQdy6v6Iq73uiJWql/loFys5Hp/k6R5THrBB3ewntG48w==
X-Received: by 2002:a5e:8704:0:b0:7de:e495:42bf with SMTP id ca18e2360f4ac-7e1b51f3e6amr2335163739f.1.1715972958425;
        Fri, 17 May 2024 12:09:18 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-48937141644sm4784802173.69.2024.05.17.12.09.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 May 2024 12:09:17 -0700 (PDT)
Message-ID: <f7367e15-150f-4fbb-b026-73d9407fd863@kernel.dk>
Date: Fri, 17 May 2024 13:09:16 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Announcement] io_uring Discord chat
To: Gabriel Krisman Bertazi <krisman@suse.de>, io-uring@vger.kernel.org
References: <8734qguv98.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8734qguv98.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/17/24 12:51 PM, Gabriel Krisman Bertazi wrote:
> Following our LSFMM conversation, I've created a Discord chat for topics
> that could benefit from a more informal, live discussion space than the
> mailing list might offer.  The idea is to keep this new channel alive for a
> while and see if it does indeed benefit the broader io_uring audience.
> 
> The following is an open invite link:
> 
>  https://discord.gg/8EwbZ6gkfX

Great initiative!

> Which might be revoked in the future.  If it no longer works, drop me an
> email for a new one.
> 
> Once we have some key people around, I intend to add an invite code to
> the liburing internal documentation.

Is it public - and if not, can it be? Ideally I'd love to have something
that's just open public (and realtime) discussion, ideally searchable
from your favorite search engine. As the latter seems
difficult/impossible, we should at least have it be directly joinable
without an invite link. Or maybe this is not how discord works at all,
and you need the invite link? If so, as long as anyone can join, then
that's totally fine too I guess.

-- 
Jens Axboe



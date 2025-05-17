Return-Path: <io-uring+bounces-8042-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6F6CABAAC0
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 16:36:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADC703A48BB
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 14:36:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4267C1E519;
	Sat, 17 May 2025 14:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="iA9HDM00"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32BF31E3DF4
	for <io-uring@vger.kernel.org>; Sat, 17 May 2025 14:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747492607; cv=none; b=QivHJZb6+YnTre+3PfElCl2sxJVM3u2pDdMmYHQAZUhZnrQUteyLg1C5QjmsLrXkxmcLUyEhlitAGlrlZf7HLjI4ATe5UZ3TTbAAbznWaPPEOJKEGfjx2vqJ4Zh86pnqPW23kiKlprm5IQD1aAJOzdTD7QcNP8b5hQJgAA4HUNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747492607; c=relaxed/simple;
	bh=TNnCWZdlQEp+GIqo9nb5nDXEZe/tCO9hV4e3k7NdwDs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=UKIJYPduCc49o1MZFRg668BVxkvfOZ5IEYacphbTNnRtZH/cQwBT83qQMu3Ml4lNmZVaEzK9QMTSaMrViAGdFVB9m2849H9zuLSmcKqeyEKNq6BNRLJryXO69iTW6yryxNzgKJIQhSdHDkXugaGRkaS+RkqgmShFZ5AwbAWGjbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=iA9HDM00; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=I+uruZI8GJkL4owb21/kMJIkKUy8+DCUZ1JjlMfDAl0=;
	b=iA9HDM00nOc3ikf9CdwlqpsAmhheaLQ9+8K1pTWwGHtbK7ZEU+k531SMrP5feu
	VSaPNuqv2sSGbYlX56dC07D+e9me8i/vX1YwYGoAiAqzId81KSUm5G35hnNjoXJm
	Nx3KzbCLg7tqRek8Al+TeZZ1oheIHf+aNo8PBt3BL8gDA=
Received: from [192.168.31.211] (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wC36o7unihojLkxCA--.37997S2;
	Sat, 17 May 2025 22:36:31 +0800 (CST)
Message-ID: <bf2520b3-c704-45aa-a2d5-afca575d5fe6@163.com>
Date: Sat, 17 May 2025 22:36:29 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v1] register: Remove old API
 io_uring_register_wait_reg
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20250517140725.24052-1-haiyuewa@163.com>
 <80d92472-402b-407c-8e39-ce39b8ef46ed@kernel.dk>
 <e6efc1d8-f317-4475-b33e-0027d4c4d140@163.com>
 <1c9d0a4e-d615-4a12-b2e1-cb3bb6030e77@kernel.dk>
From: Haiyue Wang <haiyuewa@163.com>
In-Reply-To: <1c9d0a4e-d615-4a12-b2e1-cb3bb6030e77@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wC36o7unihojLkxCA--.37997S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Gw47urW7WrW8Cr15Ar1xGrg_yoW3Zwb_Xr
	Wqkwn3C3yUKas7t3Z8JFsYyrWvqwn8Cr43CFyUKryfAwnxt345WF1kJF1vg34UX3WY9Fna
	kFs0vF45AFWjvjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRBOJYtUUUUU==
X-CM-SenderInfo: 5kdl53xhzdqiywtou0bp/1tbiShVQa2gomddxeQAAsi



On 2025/5/17 22:33, Jens Axboe wrote:
> On 5/17/25 8:31 AM, Haiyue Wang wrote:
>>
>>
>> On 2025/5/17 22:20, Jens Axboe wrote:
>>> On 5/17/25 8:07 AM, Haiyue Wang wrote:
>>>> The commit b38747291d50 ("queue: break reg wait setup") just left this
>>>> API definition with always "-EINVAL" result for building test.
>>>>
>>>> And new API 'io_uring_submit_and_wait_reg' has been implemented.
>>>
>>> You can't just remove symbols from a previously released
>>> version of the library...
>>
>> Cna only remove during the development cycle ?
> 
> Once a symbol is in a released version, it can't go away or you'd
> break both compile and runtime use of it. The only symbols that can get
> modified/removed are the ones that haven't been released yet, which
> right now would be the 2.10 symbols.
Oh, got it, thanks.
> 



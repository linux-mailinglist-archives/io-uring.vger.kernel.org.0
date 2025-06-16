Return-Path: <io-uring+bounces-8370-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A9945ADB58C
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 17:35:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C568B18893FB
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 15:35:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B952F21ABAD;
	Mon, 16 Jun 2025 15:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lmKSEyOI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FAD214A94
	for <io-uring@vger.kernel.org>; Mon, 16 Jun 2025 15:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750088134; cv=none; b=FHYl9lf2me/a4doeoct58UPqjgw0ODOvkN3z6LQFmc1QofA4NUJsWmj9nlvecMkbXDBtUtlQxuNlFCraGDauq7Uy6x/n9TaoFdsuhTP8R4Xnq2oYGdO9E6tE9PD1S6DEu46kPHCWMalJYL+NaFKwSyoKmsMIVW4ev+JVxrDzJ4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750088134; c=relaxed/simple;
	bh=ZAHdBuK1SaolaqO19wnp2+pCadbZnXUUD2E2cKZKxC0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=FK6icrQ7taTzDQ6n4u++86a/OE+wFSNVATixPIv5bwAbSbWLjvX4RcD2NlWQBBySofP6hNwMOUmz6EjrDT8hOV0tYeOFkWPEQ8F4sJ4/r/r/f/zILvGWMTTBEWGcidUB6d5szna+WddiOK3hvWA0D3MPiZs6zK6rI+YIogtf8VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lmKSEyOI; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3ddc4ad070bso15045265ab.3
        for <io-uring@vger.kernel.org>; Mon, 16 Jun 2025 08:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750088131; x=1750692931; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zr040FXfDALzYQB3oH79aTMY/bon9PirUbN0NZKSvc4=;
        b=lmKSEyOILHNbDWQnIK8lfN9P2voM93FqaIrGwc6ZPgHLL2i2kA4l326YxC+3znOkkl
         EPExX/WsF/LM/u5A1dkHoOiLGZ5wqvBW4ZS/Jo3hFLGZR8qI5j0PcPsEBFn3n1eoJKg4
         dmbeacjDAdcCDFDDIQ6W71m4dCoqlXbNgoD2f5jd7iszyQrL+OA4NRzaR5pqLSVSuECv
         o9dNLBTkaFC3vcoZEN/3iFQ2dYDSwpVL8dBZxO9dfn6R1cFCIdNsIVhba4akBT0joMGf
         GSPVnLvW0cuI3jsPqtfiv33OqEfr5YS7k/sTrc3SNwseUlg7Q7se7ktLSOa5ov2aKV1H
         FCzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750088131; x=1750692931;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zr040FXfDALzYQB3oH79aTMY/bon9PirUbN0NZKSvc4=;
        b=a5JQ2RalYyoB33OPdw51bVKkIWi9Ed+INhmmUtkwuAVjQ/OuiKISl+BTYQyKSarq4u
         yv1oJ6S0fc295tFstmTMJZh7Fz+tRLVQ1Pgr3bNZNTkWZCS3yE12OfJC0SpClAxIU3r8
         u936vtV2EpyOtBQuacynzlyGljlT5kwj5ibLH9Qp2vtMAluIUIL0wzphsxhveipGCEic
         MQNjG1RBYEdl7XEtvptB7EEt2QxVe1A9baGoUNwQxZFIbdOTdVWOt5t5ws5Ls1dXBlkD
         HwBoQDU3lxVIJYYO6YEMz7Wc0cSdJmb6+tHgimO5KqA4TwHO3fR0CN0CzfRk7KEfTRaB
         4xcA==
X-Gm-Message-State: AOJu0YzDJ3UKQMyzmozSCpMPor+2n6Q+8E5ykhI0pqtDJ/vjf/DearpO
	SuIpMnZ7HTdZu/5raxcyL375/MvFVa1gEgp12O3pfl4fMqY0xSQfAkcpFmRi35mTRoM7MyQjYV1
	WQAA7
X-Gm-Gg: ASbGncsQoSfrfS3aiXhK3bEP1UcOd2yGs6XUWpBXh2tbtRVhtVfpPX+rL1KKTR2adcP
	kTPTKhCdcvoGC7yn3zIxT39k+aXsVZK2z36RWMvqqkwNrCXVBQ7hX0MLPUup3Yyv2k24n93Mm8C
	gHTPspMfYI0trLChVu5c5H2sqQz5MBF3i8XUU1tOe6LR8sCsci0ebgc//oleAv7NswoT3FtOj0g
	NSv1wwG8pD3ERCcTWnnAH8xyHr5XICZxrUsp+YwixmfhDXwOwRuxysWzj8LsVdggBK+lz23EQ5b
	KbIx9qz3t7yQR62oniyACwrpSPqoHG1dlp57its3Pcb4okD1bD2IInmvpDU=
X-Google-Smtp-Source: AGHT+IE6ZMCPjqZWaUT4ZB3x17bOCNzJrkVTRCi7Q6KXxPouF8LZ5EwM+JBG1ysRg6JzZizxj2r9pg==
X-Received: by 2002:a92:ca4a:0:b0:3dd:b726:cc52 with SMTP id e9e14a558f8ab-3de07cdb48amr115775725ab.5.1750088131042;
        Mon, 16 Jun 2025 08:35:31 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50149b7adaasm1767971173.9.2025.06.16.08.35.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jun 2025 08:35:30 -0700 (PDT)
Message-ID: <a3aaaba3-17d6-4d23-8723-2a25526a4587@kernel.dk>
Date: Mon, 16 Jun 2025 09:35:29 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Building liburing on musl libc gives error that errno.h not found
From: Jens Axboe <axboe@kernel.dk>
To: =?UTF-8?Q?Milan_P=2E_Stani=C4=87?= <mps@arvanta.net>
Cc: io-uring@vger.kernel.org
References: <20250615171638.GA11009@m1pro.arvanta.net>
 <b94bfb39-0083-446a-bc76-79b99ea84a4e@kernel.dk>
 <20250615195617.GA15397@m1pro.arvanta.net>
 <1198c63d-4fe8-4dda-ae9f-23a9f5dafd5c@kernel.dk>
 <20250616130612.GA21485@m1pro.arvanta.net>
 <39ae421b-a633-4b47-bf2b-6a55d818aa7c@kernel.dk>
 <20250616141823.GA27374@m1pro.arvanta.net>
 <290bfa14-b595-4fea-b1fe-a3f0881f4220@kernel.dk>
Content-Language: en-US
In-Reply-To: <290bfa14-b595-4fea-b1fe-a3f0881f4220@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/16/25 9:13 AM, Jens Axboe wrote:
> On 6/16/25 8:18 AM, Milan P. Stani? wrote:
>> On Mon, 2025-06-16 at 07:59, Jens Axboe wrote:
>>> On 6/16/25 7:06 AM, Milan P. Stani? wrote:
>>>> On Mon, 2025-06-16 at 06:34, Jens Axboe wrote:
>>>>> On 6/15/25 1:56 PM, Milan P. Stani? wrote:
>>>>>> On Sun, 2025-06-15 at 12:57, Jens Axboe wrote:
>>>>>>> On 6/15/25 11:16 AM, Milan P. Stani? wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> Trying to build liburing 2.10 on Alpine Linux with musl libc got error
>>>>>>>> that errno.h is not found when building examples/zcrx.c
>>>>>>>>
>>>>>>>> Temporary I disabled build zcrx.c, merge request with patch for Alpine
>>>>>>>> is here:
>>>>>>>> https://gitlab.alpinelinux.org/alpine/aports/-/merge_requests/84981
>>>>>>>> I commented in merge request that error.h is glibc specific.
>>>>>>>
>>>>>>> I killed it, it's not needed and should've been caught during review.
>>>>>>> We should probably have alpine/musl as part of the CI...
>>>>>>
>>>>>> Fine.
>>>>>>
>>>>>>>> Side note: running `make runtests` gives 'Tests failed (32)'. Not sure
>>>>>>>> should I post full log here.
>>>>>>>
>>>>>>> Either that or file an issue on GH. Sounds like something is very wrong
>>>>>>> on the setup if you get failing tests, test suite should generally
>>>>>>> pass on the current kernel, or any -stable kernel.
>>>>>>>
>>>>>> I'm attaching log here to this mail. Actually it is one bug but repeated
>>>>>> in different tests, segfaults
>>>>>
>>>>> Your kernel is ancient, and that will surely account from some of the
>>>>> failures you see. A 6.6 stable series from January 2024 is not current
>>>>> by any stretch, should definitely upgrade that. But I don't think this
>>>>> accounts for all the failures seen, it's more likely there's some musl
>>>>> related issue as well which is affecting some of the tests.
>>>>
>>>> This happens also on 6.14.8-1 asahi kernel on apple m1pro machine.
>>>> I forgot to mention this in previous mail, sorry.
>>>
>>> Also on musl, correct?
>>
>> Yes, correct.
>>
>>> Guessing it must be some musl oddity. I'll try and setup a vm with
>>> alpine and see how that goes.
>>
>> It could be. I can ask on #musl IRC channel on libera.chat
> 
> Probably easier if I just take a look at it, as long as I can get
> an alpine vm image going.

Pure guesswork, but you are most likely running into default ulimit
limits being tiny. Probably something ala:

rc_ulimit="-n 524288 -l 262144"

in /etc/rc.conf would help.

-- 
Jens Axboe


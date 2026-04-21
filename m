Return-Path: <io-uring+bounces-13094-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UEnLJxeu52lZ/QEAu9opvQ
	(envelope-from <io-uring+bounces-13094-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 19:04:23 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C93BD43DB3F
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 19:04:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DD8423002510
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 17:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32AD9385535;
	Tue, 21 Apr 2026 17:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="vw8AFeT7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5E4282F35
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 17:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776791049; cv=none; b=a5sO6T2G13VcYQHQBKJ4kVEsVZoH08oiuoyBur+CWlRzf163WsTNQJ40PoW8j4Ziru+fSV8pQT0CiQu9LKPu+teJlJxFrGuS8vShN2ZwKda8eOeyuCrTsgyY7vonQM8XadWzbD0OIDyZggZ1WIrEImWt9+rNJlmdlkAHtigsifQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776791049; c=relaxed/simple;
	bh=81Iw/3VK/3Lg5EFFvgZagzKgUKX2HRpP1aoT1A8bt3M=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=qL3eftXfezX3Ixqy/5vt0dX0kmQuqexwf4wzltzrfB0O1W/pcdp4uTJapzfQwejxA8WlwHg/2wwnbCzr1eTkSSI2rkQC5h7ApGpbx+bxZl7tPmI4xxgVY3OJ8NKIktW/K6vpZ+oxgbZ4Axo/wYI5cBdiHngj5vE5xcje2Szmtiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=vw8AFeT7; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7dcd8ef572aso520635a34.1
        for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 10:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776791046; x=1777395846; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oP86SGKBPWLPAnc8R7zmRt3kcZzQHNh8CjxKbI4+I8Q=;
        b=vw8AFeT7DAMHfSXS2T3IssGa4rExVngo7RVSm/3QS4BkhEoXWYnRdq2D7bzCyVk+6z
         QWnYquteqxbB8t0gApjxO0816KlMkvMxAWyiOmPFBAJGQTPPbnXtV6WgKCWPp2wE2ekM
         Iu+qRsbwSFNAPsw1PTuQP7U8T4//bq2EJWzwJRxoJI1HYQ2c5J8Xw+mw8X9ppFgqUxMF
         ESF0gZFn+iD7y164q9hevGjHCq0l5WTZnW5DX9NUpb7C1lZx4HGUenY13MoUW5PkaI7h
         iGcWfCwuFWjzN9Djmn1Jh7jfzWIAKIydmx5BEcaRXhd2C4IJEGEEQJHzgPUcqVlmDAM7
         WsxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776791046; x=1777395846;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oP86SGKBPWLPAnc8R7zmRt3kcZzQHNh8CjxKbI4+I8Q=;
        b=Po4fu93llAbk6slT3Ov01zPMNTDCytGTDcxO/4ED4ccJIl0oRWXcU5Quynw5LW9bha
         bQz0bZCzIcvg5xbRluk/wcAlOVNb6C5t4tUWhWFbowR1F/FOB7hbGgZNDrvQQv/vK2i2
         KO7PXlkZHRyGm2KcBvITjh4qL9ydZUT63zJfRfhRfwdjBy57tcooFWVfVdaaLbS4WhJX
         Y4RFfLn0yaIO9gWTgZ2Jn2s+r+o0o0jXULVJYiinAmeg8BoKsyGslbf29eapOXa62Zqc
         j28CZ75OsZS/1lRymtSfzrUdVfpmH/EKu7jOtX0qJ0tSNfpUP+U0A2zvTY+l36uKUwaz
         fzaQ==
X-Gm-Message-State: AOJu0YyzkSXMnE4DiXBK+/HTsL6u00AN6RcF5PIfrg1Syqyrn+cfuTRR
	Nx1srRBwtSk+mHVtcj37+6p8b7z+eWlGlJ8hG0mchuZrSLt2BsYEJxV61lIkzn0GTUQ/NNbTaWy
	YpHMGNic=
X-Gm-Gg: AeBDiev/P1Sp1xOnnB7wswse3CFYk3aPGZWtmoauTM6ZbNnNWa8hzUTo2twgeCNh525
	tUlg40vsZm2UeAL9xKPojTGk+TuqDhj0zUhZrlhm1N7cWYU8pucotvflZvj0WBsQ38WH93NzeUU
	lj6GxyaoobghX5YNfCWhEqdIewD3vUhX/1Svm5LuoebSVEkG+0x0cybOr9vO8mMmJZYbBmkW0K+
	rcWHvdZeWAQOYjL3XMPmJdC5nvL4wV6svNucHAxdFxde5SUihCF1S1tRnBwvRM1qws63jIzsyjN
	KxNOdg0/gtslXBaImBSWghnIhT5pxu9xK9YMvAoy6vFzvcQM1DuKomksVgSNIrdCLE/3V3k6HHX
	xHDUnIcOah7rvsIUNHCtdvBpnj5Lh3LMBeyYnnSfFQyWJKp5eRd/D53I+uOWsJq6xffn1P1V1bL
	mY2GCs0/mrYUQ1TgcUC9sGrPSgBG9eqV3kOv5y7GA6X/c/CZ1vGMLaKUTltJrFrcAgN2+At6zto
	q3PlhVIfp118RArIjU=
X-Received: by 2002:a05:6830:411a:b0:7d7:eab6:fb23 with SMTP id 46e09a7af769-7dc951fc6admr12267771a34.22.1776791045050;
        Tue, 21 Apr 2026 10:04:05 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dc9759bfa3sm11720567a34.13.2026.04.21.10.04.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 10:04:04 -0700 (PDT)
Message-ID: <1ae11797-3a6b-4242-bf36-2fdcc797e859@kernel.dk>
Date: Tue, 21 Apr 2026 11:04:03 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: take page references for NOMMU pbuf_ring mmaps
From: Jens Axboe <axboe@kernel.dk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: io-uring@vger.kernel.org
References: <2026042115-body-attention-d15b@gregkh>
 <842a9dff-b12c-4cec-bc8d-8c1adb3ba280@kernel.dk>
 <2026042108-fiscally-unglazed-56c7@gregkh>
 <2026042140-arrogance-freehand-d8bd@gregkh>
 <c5077dde-0dfe-48d0-9504-76c7ff30b0e8@kernel.dk>
 <aed22e56-a39b-4c4b-a413-b5b1cd64deb4@kernel.dk>
 <2026042125-disabled-conjure-67e4@gregkh>
 <5671d6b0-780b-4847-b4ac-ad500acdf180@kernel.dk>
Content-Language: en-US
In-Reply-To: <5671d6b0-780b-4847-b4ac-ad500acdf180@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13094-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,r7625:email,kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Queue-Id: C93BD43DB3F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/21/26 10:41 AM, Jens Axboe wrote:
> On 4/21/26 10:24 AM, Greg Kroah-Hartman wrote:
>> On Tue, Apr 21, 2026 at 10:21:04AM -0600, Jens Axboe wrote:
>>> On 4/21/26 10:05 AM, Jens Axboe wrote:
>>>> On 4/21/26 10:01 AM, Greg Kroah-Hartman wrote:
>>>>> On Tue, Apr 21, 2026 at 03:55:38PM +0200, Greg Kroah-Hartman wrote:
>>>>>> On Tue, Apr 21, 2026 at 07:50:32AM -0600, Jens Axboe wrote:
>>>>>>> On 4/21/26 7:46 AM, Greg Kroah-Hartman wrote:
>>>>>>>> Note, I have no way of testing this, I'm only forwarding this on because
>>>>>>>> I got the bug report and was able to generate something that "seems"
>>>>>>>
>>>>>>> AI bug report I presume? Because I can't imagine anyone ever attempted
>>>>>>> to run this.
>>>>>>
>>>>>> Yes, I got a bunch of "non-mmu" bug reports, which is a bit odd but I
>>>>>> guess you can do that with qemu these days?  I should dig into that,
>>>>>> maybe that way I can test this and get a reproducer for you.  If not,
>>>>>> let's just bin the thing.
>>>>>>
>>>>>>>> correct, but it might be a total load of crap here, my knowledge of the
>>>>>>>> vm layer is very low so take this for where it is coming from (i.e. a
>>>>>>>> non-deterministic pattern matching system.)
>>>>>>>>
>>>>>>>> I do have another patch that just disables io_uring for !MMU systems, if
>>>>>>>> you want that instead?  Or is this feature something that !MMU devices
>>>>>>>> actually care about?
>>>>>>>
>>>>>>> I mean, who really cares about !MMU in the first place, we should just
>>>>>>> kill that off with a passion.
>>>>>>>
>>>>>>> Let me take a closer look at this and bounce it past some vm people, my
>>>>>>> nommu knowledge is close to zero as it's never been relevant in my
>>>>>>> professional life time. Which is saying something...
>>>>>>
>>>>>> Let me try to get a reproducer going first, let's not waste any more
>>>>>> human time on this just yet, sorry for sending this out without that
>>>>>> done first...
>>>>>
>>>>> Ok, attached is a poc.c and a script to run it.  If you run this on a
>>>>> 7.0 kernel today, it "should" crash. and then if you apply the patch it
>>>>> doesn't (or at least that's what happened in my testing.)
>>>>>
>>>>> Note, I have run this locally, and it seems to work, but be careful, I
>>>>> can't guarantee anything, it does seem quite odd in that it "crashes"
>>>>> the kernel with a sysrq call to show "proof".  Although that is a cool
>>>>> trick, I need to remember that...
>>>>
>>>> I'll try and run a nommu qemu and see what pops out on my end. What a
>>>> waste of time for a nothing burger ;-)
>>>
>>> What is fix-paddr.py? It's referenced in the build script.
>>
>> Oops, this thing scattered crud all over the filesystem.  Here's what is
>> in the cross-wrap directory that it created.  If I forgot anything else,
>> let me know, sorry about that.  I need to clean up my working directory
>> for this box (which is rightfully air-gapped) as it's accumulated a lot
>> of cruft...
> 
> Still get the same error:
> 
> qemu-system-riscv64: Some ROM regions are overlapping
> These ROM regions might have been loaded by direct user request or by default.
> They could be BIOS/firmware images, a guest kernel, initrd or some other file loaded into guest memory.
> Check whether you intended to load all this guest code, and whether it has been built to load to the correct addresses.
> 
> The following two regions overlap (in the memory address space):
>   build-nommu/vmlinux.qemu ELF program header segment 0 (addresses 0x0000000000000000 - 0x00000000001f1e18)
>   mrom.reset (addresses 0x0000000000001000 - 0x0000000000001028)
> 
> axboe@r7625 ~/v/nommu [1]> qemu-system-riscv64 --version
> QEMU emulator version 10.2.2 (Debian 1:10.2.2+ds-1)
> Copyright (c) 2003-2025 Fabrice Bellard and the QEMU Project developers
> 
> What are you running this with?

Skipped the paddr/strip stuff and just booted arch/riscv/boot/Image:

[...]
[    0.217868] Freeing unused kernel image (initmem) memory: 400K
[    0.218137] This architecture does not have kernel memory protection.
[    0.218478] Run /init as init process
[*] pbuf_ring page mmap()ed at 0x8059c000
[*] unregistered; canary[0..3] = 55 55 55 55
[+] OK: canary intact — mmap holds page reference, fix is applied
[    0.237876] reboot: Power down

and doesn't complain here. Same sha, current Linus -tip which is also
what was used in the poc script.

Hmm?

-- 
Jens Axboe



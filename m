Return-Path: <io-uring+bounces-13093-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EI/tIuSo52lQ+wEAu9opvQ
	(envelope-from <io-uring+bounces-13093-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 18:42:12 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 05C7A43D87D
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 18:42:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 956473020853
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 16:42:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B755C37C103;
	Tue, 21 Apr 2026 16:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="KxTS2jsw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF292E7631
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 16:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776789719; cv=none; b=VenSa3Fb5HzEA3ol6KvaZzxh80+Wjd4mOP0vfPetKhO++0QNOVVHk1vCVh2Cq0LI5BVc854+orNciJQALYW8NFJYtOPUlCUD++pd1iP6hYX+wo9KGIAXmSf4WhbKbUBG1+wEoHEWjuQQUtkzdA/XryBCqstZqkTC/+0rXl+RyS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776789719; c=relaxed/simple;
	bh=N/3ni/2nRrIq2TVOkz7Wxo6iEkFMQDk11oejJtDoI+U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GX7SR0s7Tx25ezRVnb8VZ5u8kSa6vKPzlSPhZ1XxBw+m+0vqimyUKoQBM2ylhFME0yU2jHiZXtPEVu9KTG2Un53GClvbHn4gPuNfdVWSXoY1FEKTcXESxFov//KUdtO72U3y8QKVDx735bJuP8oxIgJpAMZ4vYHujucXPzTgSRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=KxTS2jsw; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-682fce74c06so3553272eaf.3
        for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 09:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776789711; x=1777394511; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hzQsrBAfpJcdo9GTyjdcudYsoKdEUrc7mGLMGz6Wnwk=;
        b=KxTS2jswBbYO3+ZQtATomlGUELK4hbwcc7gcPnmTO5D+WWmEp1KnQMTUWBxWyrdRl1
         Iodn/bMYQMNeMUFYW0WZgwADxM4sH3kicLUBvXBoW/9ETBAMqZxgDUDon3y60lIhJAUp
         LneuqYB+1byF5wADgwnep70b2Z6HTgSd/8HtonQpM9CMPaZ+0pj6jHUj0WofGOj7jUrT
         OwpXZM9XuXaQvr9ipPpp4vRtOCwMe5OWDovkZMYoJSY04axKEJMx45qXhvkX0agJFT9X
         3UgYdf3t572dJiLgtBlbglbN7HHZk6aSsKCW9+1RZF0KS5l/u1kAP8X4m1lKPfCUYLC3
         mJvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776789711; x=1777394511;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hzQsrBAfpJcdo9GTyjdcudYsoKdEUrc7mGLMGz6Wnwk=;
        b=EB5xeJp8LFHx7wcTPFv2A1N12h3SjomwAMDLghMr7DAs/7sHiB07ShitzkxH1Dk+IG
         1m+q3tFVG/mFWzCt5aQ81Myy8Ifx6A/7QsNERqCOYFckGk7v9PXvtvvWdmFcM5v4q30S
         OHyMmhpDaFFebrlViBa3cD0H4tT/Iveo6i9JCzeFqeLKMYfT9boQ0cWI0XF7JCS0SUku
         26SVigpnTGs5OY+aEjJmuQtAhwuyexVRYdk4f4XjWY6YfO9WcZBSKvMxhDSaEBpqn6kW
         zbm2fT5nCTa3gJc6R0B3pBTaix5fSdElS8xKFfrESdm9tEZKWTlMW92GhX6hYGqfdtaC
         iNLg==
X-Gm-Message-State: AOJu0YyYtzjptlMVTHB5tJnmgieIK+c3RJAyNXl4GiG8JGfrM8vVCB/c
	3ndSL4UrFTPXe2jLklkdIfVqGwCWaeh1NXjaeYILFqBNwlRONqvkECt01i86iqKnCzUaI6BO+hK
	mpJhPptc=
X-Gm-Gg: AeBDieviWqF2qgbsqhJcCLDNAJZ8nYxGpYVtNkCkHW2eR094pjEIBv16KWM5Bl5lbbO
	bGcSAfpiLZbFXngxFxjXs/U1KM0G80Br6psOevMyiaW25KIo+BPkfGPS1jIyG5HcqLOoQMWoD4z
	qPO1SEiNfZsqCQn0bohlpw7fPsOBD44SsSm9QtkD7olScHk/HOMj0V8u974O5zQ6PruZm0r48xh
	Jol67AZvNZ4J1q+nC4D7tczey3bUVRumXDFwPMfgYg4xoxdwcMmvA8wXaK607dZzsfcSNjOl9pe
	kwbOwRJJ4V8ofEZvtqwbSOjdZ2L3N2jZWsiaQ4H9hdMK4JgrLqBNVY5OOurODW+8G+xfjN+q59u
	B5xCjRa3qmcAKpXBuuvOGX2ePe/VFwWULGCejX8drhWKWadqpf11hLIXnY+ProAAfThjK/84KVX
	7uANjJbkUt+4AD32ychyIrRsFgn3rmhIElKMuO415K2hdiaeibT6DQrG1FWze3p5zrmQ2oZfsqY
	dTZffHhGSCZMS9AgUkeNevcHKLsRQ==
X-Received: by 2002:a05:6820:810a:b0:67b:cc71:c4fc with SMTP id 006d021491bc7-69462e68f9amr9617352eaf.23.1776789710989;
        Tue, 21 Apr 2026 09:41:50 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42c054997absm5219493fac.3.2026.04.21.09.41.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 09:41:50 -0700 (PDT)
Message-ID: <5671d6b0-780b-4847-b4ac-ad500acdf180@kernel.dk>
Date: Tue, 21 Apr 2026 10:41:49 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: take page references for NOMMU pbuf_ring mmaps
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: io-uring@vger.kernel.org
References: <2026042115-body-attention-d15b@gregkh>
 <842a9dff-b12c-4cec-bc8d-8c1adb3ba280@kernel.dk>
 <2026042108-fiscally-unglazed-56c7@gregkh>
 <2026042140-arrogance-freehand-d8bd@gregkh>
 <c5077dde-0dfe-48d0-9504-76c7ff30b0e8@kernel.dk>
 <aed22e56-a39b-4c4b-a413-b5b1cd64deb4@kernel.dk>
 <2026042125-disabled-conjure-67e4@gregkh>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2026042125-disabled-conjure-67e4@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13093-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20251104.gappssmtp.com:dkim,r7625:email]
X-Rspamd-Queue-Id: 05C7A43D87D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/21/26 10:24 AM, Greg Kroah-Hartman wrote:
> On Tue, Apr 21, 2026 at 10:21:04AM -0600, Jens Axboe wrote:
>> On 4/21/26 10:05 AM, Jens Axboe wrote:
>>> On 4/21/26 10:01 AM, Greg Kroah-Hartman wrote:
>>>> On Tue, Apr 21, 2026 at 03:55:38PM +0200, Greg Kroah-Hartman wrote:
>>>>> On Tue, Apr 21, 2026 at 07:50:32AM -0600, Jens Axboe wrote:
>>>>>> On 4/21/26 7:46 AM, Greg Kroah-Hartman wrote:
>>>>>>> Note, I have no way of testing this, I'm only forwarding this on because
>>>>>>> I got the bug report and was able to generate something that "seems"
>>>>>>
>>>>>> AI bug report I presume? Because I can't imagine anyone ever attempted
>>>>>> to run this.
>>>>>
>>>>> Yes, I got a bunch of "non-mmu" bug reports, which is a bit odd but I
>>>>> guess you can do that with qemu these days?  I should dig into that,
>>>>> maybe that way I can test this and get a reproducer for you.  If not,
>>>>> let's just bin the thing.
>>>>>
>>>>>>> correct, but it might be a total load of crap here, my knowledge of the
>>>>>>> vm layer is very low so take this for where it is coming from (i.e. a
>>>>>>> non-deterministic pattern matching system.)
>>>>>>>
>>>>>>> I do have another patch that just disables io_uring for !MMU systems, if
>>>>>>> you want that instead?  Or is this feature something that !MMU devices
>>>>>>> actually care about?
>>>>>>
>>>>>> I mean, who really cares about !MMU in the first place, we should just
>>>>>> kill that off with a passion.
>>>>>>
>>>>>> Let me take a closer look at this and bounce it past some vm people, my
>>>>>> nommu knowledge is close to zero as it's never been relevant in my
>>>>>> professional life time. Which is saying something...
>>>>>
>>>>> Let me try to get a reproducer going first, let's not waste any more
>>>>> human time on this just yet, sorry for sending this out without that
>>>>> done first...
>>>>
>>>> Ok, attached is a poc.c and a script to run it.  If you run this on a
>>>> 7.0 kernel today, it "should" crash. and then if you apply the patch it
>>>> doesn't (or at least that's what happened in my testing.)
>>>>
>>>> Note, I have run this locally, and it seems to work, but be careful, I
>>>> can't guarantee anything, it does seem quite odd in that it "crashes"
>>>> the kernel with a sysrq call to show "proof".  Although that is a cool
>>>> trick, I need to remember that...
>>>
>>> I'll try and run a nommu qemu and see what pops out on my end. What a
>>> waste of time for a nothing burger ;-)
>>
>> What is fix-paddr.py? It's referenced in the build script.
> 
> Oops, this thing scattered crud all over the filesystem.  Here's what is
> in the cross-wrap directory that it created.  If I forgot anything else,
> let me know, sorry about that.  I need to clean up my working directory
> for this box (which is rightfully air-gapped) as it's accumulated a lot
> of cruft...

Still get the same error:

qemu-system-riscv64: Some ROM regions are overlapping
These ROM regions might have been loaded by direct user request or by default.
They could be BIOS/firmware images, a guest kernel, initrd or some other file loaded into guest memory.
Check whether you intended to load all this guest code, and whether it has been built to load to the correct addresses.

The following two regions overlap (in the memory address space):
  build-nommu/vmlinux.qemu ELF program header segment 0 (addresses 0x0000000000000000 - 0x00000000001f1e18)
  mrom.reset (addresses 0x0000000000001000 - 0x0000000000001028)

axboe@r7625 ~/v/nommu [1]> qemu-system-riscv64 --version
QEMU emulator version 10.2.2 (Debian 1:10.2.2+ds-1)
Copyright (c) 2003-2025 Fabrice Bellard and the QEMU Project developers

What are you running this with?

-- 
Jens Axboe



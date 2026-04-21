Return-Path: <io-uring+bounces-13100-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EGBoNs6352mu/wEAu9opvQ
	(envelope-from <io-uring+bounces-13100-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 19:45:50 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4058243E249
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 19:45:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3297230A9677
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 17:39:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F13AE4C6C;
	Tue, 21 Apr 2026 17:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="mzK5uUaZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECB431E827
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 17:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776793140; cv=none; b=IF2AQiLjukZv5BvFxzgDW25c6wF+yNebwb4dFX8I2GvabUmqolA2JVE5ev5QWhecvRXUOdez6N5/6CtaBRCX7mzJD0tmHJdnzR3tn+AthKikyNWpgK3bz7SLZGEuk/8AfK0VX2R5MLvK1SxKyGWn+bk0USBaS95d0qpoMo4kqRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776793140; c=relaxed/simple;
	bh=grmo2aJGdNZRjgCE3tndTQdgheoX/yCDqQnTj41EKDw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=RjJoiJbwZHY28/x2ux+8fe0A7JEAN8VUc/YF/BVdbwfIyqycRj3nPraSpwEpTYXoqizPQJ2tb5/IU2jaTPrAlim1f+5TRiDWNsiY067GfQxrJuEIAHLEyaDgfZcAl6RW8b5JYL6gciNTu14qMVIBTs7ah71l0arhOMP5BqBdQhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=mzK5uUaZ; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-42fb77499edso203369fac.2
        for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 10:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776793137; x=1777397937; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CV7AdSX88oG6/rWeYpFDcamSHCjg45yYURUNRYF1yfg=;
        b=mzK5uUaZdHf3278x4ONRG6cWEQ0ZJvzNZGYqHDdJuLk5FUeSBJHs2KnGq5/8FF5q+D
         NiFCsp1XEdEwf7iru9HxE4MMzNE2y7WxfHosUt3GmdvZve9NhNXHIc9kdPFXcwYHuWKV
         pty0L8qRLgMp78LMR4ijRSJ/vBperZIYzDSG092P5hZuBd+vK71irZo6oDTybglenda8
         SGXOAyrjBo/GcA3IEKC2vwe7P5w8m4ajciOmFO1ldzmUpu3qzBxovXpdU7H0+Q/9OtPl
         d/WHlZlqFiiQJYrB58+bikvuSzFrrjqkqOpZZw+nsdz8TPU6reaTIi8IzDdLcokFYlpc
         alzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776793137; x=1777397937;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CV7AdSX88oG6/rWeYpFDcamSHCjg45yYURUNRYF1yfg=;
        b=Qs+lsHSqprgPuAfwR6rlHn7gsMmhYlT67bFVSi4d/nIjwj5Ly03rIZppl0W5gZX9+u
         8BIFcMgzGTFoJIwywlxyE204r5BaB1PjjqaeLk7Abc+FBLZs3UdjWw352oiPRcsN1EnG
         E5pzHtToNr+gzSFCB/DuzX8OIBSghD0P7xI1uuZYL26uDlJw9f4xxGfr4QyCAPLdrZG3
         tsPDCQoANsyOQwnYfua2wUb+spAWJWQoztGil6kXyTRQkqoE5PF4Eu+BTomdDDxK77TP
         2pGl73VPRVymbhI9PypA4I+3GTj+cVC04p10g1A7sGs9IqmYX8TJ/Sp3G977al1EPl+s
         J8mQ==
X-Gm-Message-State: AOJu0YwbQAHkHafuqqYZrQ/xFWG+n1x7SbTXYFjVo3yIvUhFhrwJrbGO
	YwscP+jmzmeoyJwEP8bJcEZu0makAdJS5Ft7bNRl7GA7iLRgcIdkD9Y0h/7bGXvYyRxhETlYCho
	gnt8vvAc=
X-Gm-Gg: AeBDietZa0tJPAEVFL9EEAZf7WxdxArRYjqjpIPsIO4EJCaRHWhpKvpC6Kmd+YOMvls
	/F6oeKXj3pCkMqrMdR0AhxXSJoHnHLd5plO7HBaNhxYD1hVYelRQAWAduaaVvSz6Fjm6Sos/pPC
	QSPNTsEHAXrfwX8Hs4/nxPMbdwqIWsmymrptODi3Dg7gtD8uq2bIp/1Qvxw9/p2UXlOQBeCD6ua
	ReLXTm7DzjrdwN1CvrEQyUK4u0ndv9mSbFjPySp2IA2AbnuspDWh5zXzC3OBIgtxkt3lBVaWkbx
	e9wJAoScF6bYrPzw5G4y5HXGpIypvp5oLKipMDrQy45BALq3fRTVwy/wqBIqHlzAZsX/tYM9XXf
	15fvRqlhiDJPZdKVJcRqtZET5111D2+PdQhCPtZzMyoGylYW2Br8LMGJ+PxB02ENSbnQqoRFhOJ
	S7OPYPlI1J/VCW2Oju8kqOZ7fF6bxW9FhZtbnP1xHu2O8MFze4iDJLSDKWBsyyuek79hlthO/4z
	uxLcLF/8eDr/F7UO5c=
X-Received: by 2002:a05:6870:b30f:b0:423:994:9b76 with SMTP id 586e51a60fabf-42aded1de0fmr11094336fac.24.1776793137240;
        Tue, 21 Apr 2026 10:38:57 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42b9304b7f6sm12557045fac.1.2026.04.21.10.38.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 10:38:56 -0700 (PDT)
Message-ID: <c615ad6f-19f6-4b90-92d9-5f273cec05b9@kernel.dk>
Date: Tue, 21 Apr 2026 11:38:56 -0600
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
 <1ae11797-3a6b-4242-bf36-2fdcc797e859@kernel.dk>
Content-Language: en-US
In-Reply-To: <1ae11797-3a6b-4242-bf36-2fdcc797e859@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13100-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: 4058243E249
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/21/26 11:04 AM, Jens Axboe wrote:
> On 4/21/26 10:41 AM, Jens Axboe wrote:
>> On 4/21/26 10:24 AM, Greg Kroah-Hartman wrote:
>>> On Tue, Apr 21, 2026 at 10:21:04AM -0600, Jens Axboe wrote:
>>>> On 4/21/26 10:05 AM, Jens Axboe wrote:
>>>>> On 4/21/26 10:01 AM, Greg Kroah-Hartman wrote:
>>>>>> On Tue, Apr 21, 2026 at 03:55:38PM +0200, Greg Kroah-Hartman wrote:
>>>>>>> On Tue, Apr 21, 2026 at 07:50:32AM -0600, Jens Axboe wrote:
>>>>>>>> On 4/21/26 7:46 AM, Greg Kroah-Hartman wrote:
>>>>>>>>> Note, I have no way of testing this, I'm only forwarding this on because
>>>>>>>>> I got the bug report and was able to generate something that "seems"
>>>>>>>>
>>>>>>>> AI bug report I presume? Because I can't imagine anyone ever attempted
>>>>>>>> to run this.
>>>>>>>
>>>>>>> Yes, I got a bunch of "non-mmu" bug reports, which is a bit odd but I
>>>>>>> guess you can do that with qemu these days?  I should dig into that,
>>>>>>> maybe that way I can test this and get a reproducer for you.  If not,
>>>>>>> let's just bin the thing.
>>>>>>>
>>>>>>>>> correct, but it might be a total load of crap here, my knowledge of the
>>>>>>>>> vm layer is very low so take this for where it is coming from (i.e. a
>>>>>>>>> non-deterministic pattern matching system.)
>>>>>>>>>
>>>>>>>>> I do have another patch that just disables io_uring for !MMU systems, if
>>>>>>>>> you want that instead?  Or is this feature something that !MMU devices
>>>>>>>>> actually care about?
>>>>>>>>
>>>>>>>> I mean, who really cares about !MMU in the first place, we should just
>>>>>>>> kill that off with a passion.
>>>>>>>>
>>>>>>>> Let me take a closer look at this and bounce it past some vm people, my
>>>>>>>> nommu knowledge is close to zero as it's never been relevant in my
>>>>>>>> professional life time. Which is saying something...
>>>>>>>
>>>>>>> Let me try to get a reproducer going first, let's not waste any more
>>>>>>> human time on this just yet, sorry for sending this out without that
>>>>>>> done first...
>>>>>>
>>>>>> Ok, attached is a poc.c and a script to run it.  If you run this on a
>>>>>> 7.0 kernel today, it "should" crash. and then if you apply the patch it
>>>>>> doesn't (or at least that's what happened in my testing.)
>>>>>>
>>>>>> Note, I have run this locally, and it seems to work, but be careful, I
>>>>>> can't guarantee anything, it does seem quite odd in that it "crashes"
>>>>>> the kernel with a sysrq call to show "proof".  Although that is a cool
>>>>>> trick, I need to remember that...
>>>>>
>>>>> I'll try and run a nommu qemu and see what pops out on my end. What a
>>>>> waste of time for a nothing burger ;-)
>>>>
>>>> What is fix-paddr.py? It's referenced in the build script.
>>>
>>> Oops, this thing scattered crud all over the filesystem.  Here's what is
>>> in the cross-wrap directory that it created.  If I forgot anything else,
>>> let me know, sorry about that.  I need to clean up my working directory
>>> for this box (which is rightfully air-gapped) as it's accumulated a lot
>>> of cruft...
>>
>> Still get the same error:
>>
>> qemu-system-riscv64: Some ROM regions are overlapping
>> These ROM regions might have been loaded by direct user request or by default.
>> They could be BIOS/firmware images, a guest kernel, initrd or some other file loaded into guest memory.
>> Check whether you intended to load all this guest code, and whether it has been built to load to the correct addresses.
>>
>> The following two regions overlap (in the memory address space):
>>   build-nommu/vmlinux.qemu ELF program header segment 0 (addresses 0x0000000000000000 - 0x00000000001f1e18)
>>   mrom.reset (addresses 0x0000000000001000 - 0x0000000000001028)
>>
>> axboe@r7625 ~/v/nommu [1]> qemu-system-riscv64 --version
>> QEMU emulator version 10.2.2 (Debian 1:10.2.2+ds-1)
>> Copyright (c) 2003-2025 Fabrice Bellard and the QEMU Project developers
>>
>> What are you running this with?
> 
> Skipped the paddr/strip stuff and just booted arch/riscv/boot/Image:
> 
> [...]
> [    0.217868] Freeing unused kernel image (initmem) memory: 400K
> [    0.218137] This architecture does not have kernel memory protection.
> [    0.218478] Run /init as init process
> [*] pbuf_ring page mmap()ed at 0x8059c000
> [*] unregistered; canary[0..3] = 55 55 55 55
> [+] OK: canary intact ? mmap holds page reference, fix is applied
> [    0.237876] reboot: Power down
> 
> and doesn't complain here. Same sha, current Linus -tip which is also
> what was used in the poc script.
> 
> Hmm?

I'm just going to apply the patch, it's trivial (grab refs at mmap, drop
on close) and there's zero point in spending anymore time on this.

-- 
Jens Axboe


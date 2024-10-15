Return-Path: <io-uring+bounces-3697-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC7D299FAA4
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 23:56:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91054282157
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 21:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C1E821E3AC;
	Tue, 15 Oct 2024 21:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OZDimRId"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D59021E3AD
	for <io-uring@vger.kernel.org>; Tue, 15 Oct 2024 21:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729029395; cv=none; b=gly/LxLCEB4YsjbCKcyPxQKXhEVmXy1V58StApv4/j9luPkI0/pJSF9sNdBdpPGWQroAVdsU/ryW1xfKsdW2yEzugeOuHqf8AAAcI5GimHdrajd5awpEIjpSZVCIAJnIkJenpIMcg8tFYIicUYdMcBXWl6yPLBb3VULz480qTeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729029395; c=relaxed/simple;
	bh=4Uy54j1DkCQrdxslahHQHnRnxPK5qHQNCzNCYrdm/xs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ddUwLt3pXex2qg/QKREx7ahhLXprQ2CPn4UlxvswFCnJ1wSI3zNbs5x0zyF3TcTBTIAmi5H7bP72/fQxEurpaPjHIWEG0VsYjbDtiDkv5BtDbHkrHLErVoskk6ROhyZ48yKhAtsvfb75QCb+chUBqeNBXK2L2rN1i9Gsj5xO7Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OZDimRId; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-7d916b6a73aso3682353a12.1
        for <io-uring@vger.kernel.org>; Tue, 15 Oct 2024 14:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729029392; x=1729634192; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QFkGuKLa9PThDnuFLf1f8jYSOyUXfp3vyHGTq/9/32A=;
        b=OZDimRIdy+S/kT68WpWQHP0RZ/EcQVS6SioFs5vsw4/fXITsUyV9jD+kBBz6cuAZ0m
         NNuDeGs9wX2SiO/MBEo0ZGbEmzokiZkyha1cWUPsNZ6t9e49Z+tEvVKp3/ZjLLI72Xc2
         OTvOVq15RxO5pnjU5BDG8k43MGmpOnyAzh6uxYLdBbcjkJo8OtMoTr2pSLa6ZYFz8Hws
         01J40EHqAmGQvrOpXqTPlCRaF+Km7tzXvKIOfJ/hH7FbvVSLlzhUMO1rX/fIcuBeslNu
         TcOeoYGYK00lrVOV3gx15cAOfefXYjwMcoT6ifhg2/2WfQz0We6/B/bTHIbxjuXg86as
         q4SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729029392; x=1729634192;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QFkGuKLa9PThDnuFLf1f8jYSOyUXfp3vyHGTq/9/32A=;
        b=JB9QOfpeGhUM9C7wGeu/rjDAifcDBSfdDezC7hDDJXndQwjEurmx5Um778VaqJbCOz
         z9EJq/zvJpkVkTQJctzppv3TCxU/NQVT1dP5ChFhbFsq9CSkW2ekCcTTaRZYVds6rkN1
         3/eg5iIYmjT7aLylxNmx1d4LmK7noNYXmdihozmGq+nlLpT07FZHbUTBwypzgBJHP3o8
         lGqbI7PVLnaf93GfBwFx43Nym9sJShTmDIYzHg+CGN78p4wzXGQ2oubZ7Exl6KSWnqNc
         Jvk2SsRHLzdq5m5ckt1WLH4zRbosmg9US0eGkyWsEL5uNaFv20ld33ZfkFQ7ZdHqD2v4
         810A==
X-Forwarded-Encrypted: i=1; AJvYcCW/0rGJSjqMX5xpKsIYjuYFxxTBKXOOI+dHMx/WMoPjIM0JMuT2qEuMEPnSkFUfBW4aoJqwQCchNA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzmM3EVjkFYc6c/dCsxjn5TI5sr7pzizwwZZmoRb+gu4IDflIN8
	y19Mi95yXmv8fjkod3liimtWaT9+rQqg23Q0+E88ybe2vzTNW5Qb4+5/6ZfI7c4=
X-Google-Smtp-Source: AGHT+IGSB7VEbrRQMAMd2gydDia3b2v+qHtrJzVt2rNY5s590p0/85VBsTTBCyzD2Cyg2SZ4xCEMdg==
X-Received: by 2002:a05:6a20:9f0f:b0:1d9:2a8:ce10 with SMTP id adf61e73a8af0-1d905f58e3emr2090753637.34.1729029392135;
        Tue, 15 Oct 2024 14:56:32 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e7750a74csm1792986b3a.212.2024.10.15.14.56.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2024 14:56:31 -0700 (PDT)
Message-ID: <fc3a0edc-f2fb-488a-81d9-016f78b5671d@kernel.dk>
Date: Tue, 15 Oct 2024 15:56:29 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: WARNING in get_pat_info
To: Dave Hansen <dave.hansen@intel.com>,
 Marius Fleischer <fleischermarius@gmail.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Cc: syzkaller@googlegroups.com, harrisonmichaelgreen@gmail.com,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <CAJg=8jwijTP5fre8woS4JVJQ8iUA6v+iNcsOgtj9Zfpc3obDOQ@mail.gmail.com>
 <CAJg=8jxg=hCxTeNMmtUTKeBhP=4ryoAb0ekoP05FOLjmDN5G0g@mail.gmail.com>
 <f02a96a2-9f3a-4bed-90a5-b3309eb91d94@intel.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f02a96a2-9f3a-4bed-90a5-b3309eb91d94@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/15/24 2:04 PM, Dave Hansen wrote:
> On 10/15/24 11:55, Marius Fleischer wrote:
>> Hope you are doing well!
>>
>> Quick update from our side: The reproducer from the previous email
>> still triggers a WARNING on v5.15 (commit hash
>> 3a5928702e7120f83f703fd566082bfb59f1a57e). Happy to also test on
>> other kernel versions if that helps.
>>
>> Please let us know if there is any other helpful information we can provide.
> 
> I don't know for sure, but I suspect that io_uring is triggering this.
> The reproducer is:
> 
> 	syz_io_uring_setup(0x6f7e, &(0x7f0000000080), 0x0, 0x0)
> 	syz_clone(0x24080, 0x0, 0x0, 0x0, 0x0, 0x0) (fail_nth: 40)
> 
> and the stack trace shows:
> 
>  untrack_pfn+0xdc/0x240 arch/x86/mm/pat/memtype.c:1122
>  ...
>  __mmput+0x122/0x4b0 kernel/fork.c:1126
>  ...
>  __do_sys_clone+0xc8/0x110 kernel/fork.c:2721
> 
> So whatever is happening is going on with a VM_PFNMAP VMA.  Those aren't
> super common except when you're mmap()'ing something from a device
> driver.  I would randomly guess that io_uring_setup() is setting up a
> VM_PFNMAP VMA and untrack_pfn() is getting called when that VMA is
> getting torn down.
> 
> The other goofiness is that the copy_mm() path is ending up in
> exit_mmap().  I think the only way to end up doing that is in the
> failure path of dup_mm().
> 
> So I *think* what happens is that a io_uring VMA gets created in
> dup_mmap(), but never gets any pages faulted in.  Some later setup fails
> and the new mm needs to be torn down.  *Something* about the io_uring
> VMA screws up the untrack_pfn() code.
> 
> I'm hoping that this rings a bell with the io_uring folks and this is a
> bug they've found and fixed in mainline that just got missed backporting
> to stable.

Doesn't ring a bell, and haven't had anyone report that before. The
older io_uring code does indeed use remap_pfn_range(), this is gone in
newer kernels. But in any case, I can't seem to trigger this on
5.15-stable, I might be missing something in my .config...

-- 
Jens Axboe


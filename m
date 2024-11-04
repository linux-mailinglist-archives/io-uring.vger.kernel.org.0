Return-Path: <io-uring+bounces-4405-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 22AF49BB5DF
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 14:24:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A86091F22191
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 13:24:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01A1EAD24;
	Mon,  4 Nov 2024 13:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HQZB1NN9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389D833FE;
	Mon,  4 Nov 2024 13:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726646; cv=none; b=Rf9HAA4AF7b2rSJ4jUYqoIN02IthlcOF8T8fw96+fr3YFdDilLKUuGS9F63J2Q0XsWCJcfBTTced5kZsLr+RlHUQ3YOKXlwza1BWUxqS6mWqRHJHadfjaEo8AcbBXnPyfKr9dTrjCqvDNbyeeSGIpAwSTlX9TeJCDVfiLhuoPwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726646; c=relaxed/simple;
	bh=VgYl+1JFNgr4kv5U51TEQjGQmlUnID65alX3Oy/GZMc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TXD6jQ1Yo6gURXaidDRZR5Wv0VtyUiCw7fEY8OphsK+duXlA+miGuUvkVfds+E/S4xVz2I7tB/vj9E8uj1/k/ZgmiEUQ9sBd2xbgbWyVCiuRIQe3x6w6uK7ESm7FVoreBZFNkeatLU6fZR+zIBW410OlZi9bIn40HnwG4blWoGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HQZB1NN9; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a9acafdb745so731890866b.0;
        Mon, 04 Nov 2024 05:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730726643; x=1731331443; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y4GZkqZLCKhw5XdFgK8hdGA3caDYzJnkw1T8nHEHxxo=;
        b=HQZB1NN9n8NULMNHoiIx9henZT8MVeCdeJEjYgf/pKIbbhtcxaXajP1kxSD7n1mvV0
         E2+0CeivOXehIs6fA6ZdFdwrOkqZB8A9Yw5sbRMENhi1Hd5mfPjPC+BkuU28kici3nOY
         k1pHEg8QG0GMCktEZgrVniHl2odmkZVNYGLcVSfyGhz1QOiD7ochqe3p3AGVaOIA9Fsp
         qq6c+fm54f1K/td0/wmLBsUw1cTWAXC6H1Js2Ryrgjf15Pd8Powqafqc7XXmDUsAZ8FY
         VhMmW5bSlmhbsNErksS+wb9IEUlwVLP6VXOCsgtFJZkUewP9PTgxXKwSQOr35g5Pf741
         qvtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730726643; x=1731331443;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y4GZkqZLCKhw5XdFgK8hdGA3caDYzJnkw1T8nHEHxxo=;
        b=kOxKlCkgV26BqHsy0YhbuHsf2Qv8spPPUZFbxNqE8M0GquLF531Vicz1ffL0bzmKzu
         R0dkkBzhlr8OGVq4f8t33TMmm96FpsqMbezMowITNqDskqDewlab4vn8CPrTZsSLgU5H
         BH2maWzfLSP97eT/jw2kBgbBZx/YeDWYx57FA5/B0yRbgqbpiNdTV5eolKiup1GuJy5T
         57VGOli9ti2K0nFMwRzqAbMDDIxe6nz7APanfYjfO6pfmdf72M+1QBG6oxZS0b7bslI8
         UyRLm2wp+836KABJrwHbzSGe9fdLJnb5LQx9jknkjMvIkumTPW7esForMcH24gez9kn8
         knGA==
X-Forwarded-Encrypted: i=1; AJvYcCVWAtIuNDTNHW5QLxpyK/6FIQjHuswaUs8P0Dj67tFJoVyPVEaLSti51SvB1rBbj52GxhZONnT53A==@vger.kernel.org, AJvYcCWh/k3tJYAQoGZNJbpdMWTUqFiRS4txwLCJe1tYxB9q6suSDV3BOnWZ9pVhq6v/OkTGB0txf/XjwXHP+mI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKpjRfKg3HLKD74yzhqkNyTDgnQvef5Gs1F8hlJDPtqgPrdTVV
	NjMcPAL/VO0EasBIleNr8wS1zieEI5JyOoA7MWaz689igLVTqVEf4jOhnA==
X-Google-Smtp-Source: AGHT+IHCi0lLwpRzY/AHvRh5TRF/+J+W97PiMYhG7ylj4Zzzee+Vr3WV1XBkptXQ/Y+nVsyp6pfjSA==
X-Received: by 2002:a17:907:6d20:b0:a9a:139:c3de with SMTP id a640c23a62f3a-a9e6549249bmr1098467966b.29.1730726643348;
        Mon, 04 Nov 2024 05:24:03 -0800 (PST)
Received: from [192.168.42.215] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e56493f0asm553921966b.35.2024.11.04.05.24.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 05:24:02 -0800 (PST)
Message-ID: <8fc4d419-5d16-4f58-ae66-8267edaff6ef@gmail.com>
Date: Mon, 4 Nov 2024 13:24:09 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V8 5/7] io_uring: support leased group buffer with
 REQ_F_GROUP_KBUF
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>,
 Akilesh Kailash <akailash@google.com>
References: <ZyGBlWUt02xJRQii@fedora>
 <bbf2612e-e029-460f-91cf-e1b00de3e656@gmail.com> <ZyGURQ-LgIY9DOmh@fedora>
 <40107636-651f-47ea-8086-58953351c462@gmail.com> <ZyQpH8ttWAhS9C5G@fedora>
 <4802ef4c-84ca-4588-aa34-6f1ffa31ac49@gmail.com> <ZygSWB08t1PPyPyv@fedora>
 <0cd7e62b-3e5d-46f2-926b-5e3c3f65c7dd@gmail.com> <ZyghmwcI1U4WizyX@fedora>
 <74d8d323-789c-4b4d-8ce6-ada6a567b552@gmail.com> <ZyjHQN9VITpOlyPA@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZyjHQN9VITpOlyPA@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/24 13:08, Ming Lei wrote:
> On Mon, Nov 04, 2024 at 12:23:04PM +0000, Pavel Begunkov wrote:
>> On 11/4/24 01:21, Ming Lei wrote:
...>>>> 3. The lease ends, and we copy full 4K back to user space with the
>>>> unitialised chunk.
>>>>
>>>> You can correct me on ublk specifics, I assume 3. is not a copy and
>>>> the user in 3 is the one using a ublk block device, but the point I'm
>>>> making is that if something similar is possible, then just zeroing is not
>>>> enough, the user can skip the step filling the buffer. If it can't leak
>>>
>>> Can you explain how user skips the step given read IO is member of one group?
>>
>> (2) Illustrates it, it can also be a nop with no read/recv
> 
> As I explained before, the application has to be trusted, and it must
> have the permission to open the device & call into the buffer lease
> uring_cmd.

It might be trusted to read some data of the process using the
device, but obviously it can't be trusted to read random kernel data.
I'm trying to understand which one is that.

> It is in same situation with any user emulated storage, such as qemu,
> fuse, and the application has to do things right.
> 
>>
>>>> any private data, then the buffer should've already been initialised by
>>>> the time it was lease. Initialised is in the sense that it contains no
>>>
>>> For block IO the practice is to zero the remainder after short read, please
>>> see example of loop, lo_complete_rq() & lo_read_simple().
>>
>> It's more important for me to understand what it tries to fix, whether
>> we can leak kernel data without the patch, and whether it can be exploited
>> even with the change. We can then decide if it's nicer to zero or not.
>>
>> I can also ask it in a different way, can you tell is there some security
>> concern if there is no zeroing? And if so, can you describe what's the exact
>> way it can be triggered?
> 
> Firstly the zeroing follows loop's handling for short read

> Secondly, if the remainder part of one page cache buffer isn't zeroed, it might
> be leaked to userspace via another read() or mmap() on same page.

What kind of data this leaked buffer can contain? Is it uninitialised
kernel memory like a freshly kmalloc'ed chunk would have? Or is it private
data of some user process?

-- 
Pavel Begunkov


Return-Path: <io-uring+bounces-6833-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FD86A47CB9
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 12:57:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C77C3AC6CA
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 11:57:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 024C322A1CF;
	Thu, 27 Feb 2025 11:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G+uCb33f"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B869227599;
	Thu, 27 Feb 2025 11:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740657449; cv=none; b=BNENpVC6+HB9Lz/9o5xlxlqhwr7uyhxoYKGYuJSmVemEn1vSky1l+AfI7kcpY0mD5RZrjmOpOZbBb2arXT4QkduXl9yWLmJ35n26I3izrRtlSnzRP+M0MW6TimhUjxzP6q2eY4p4dVLAi7kJC7X0+wlF85VDAiSN2y/qe8HAPg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740657449; c=relaxed/simple;
	bh=rGTjWMY7XwVDnvHA5Z64VEBYNX/wac8hYc+GBCRTjJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P2Yatajt8+ffPV1aMhPNVX16FIWBmxEIvVQfFgB7Mf+DyaUJD/7yEoEumJqqH0BoG0haRZlfXfweevCqar+Vk2g8b/kXQ0LUDKPL6lbke+JHtIHGy3u6A3jKfCg49J5D0t6jGA4gu7zt+GcYQD/ylxkII7XEglbixWciAblGUFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G+uCb33f; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-abf17fa4a29so50444966b.3;
        Thu, 27 Feb 2025 03:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740657446; x=1741262246; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CrI91tLdiEt7M/XW95bclUn0WDE3jwBds2FECmKWUEs=;
        b=G+uCb33f9sD0SlJvYm7gvEekAZ+waqrtTdC3YxBGMlTXAuMPUqdzHQyzoBz9mE1lZ/
         mbPB2vZoJCI9YDd81F40wYiYBUpNELUwN46WNOAqYIkAy87Jpw5SLtlyrZJ0vqWqeB1n
         sgvKsMXVlw9YaU7evGlW0zMnTNcSyli/2VXHwPCj9yIqGSjwA8GDF5+ehxaEh9aM9Df2
         WwnNbc/GgIav7ZLChStu6YAmg2CIfw2v7RSvaDKYudgp5wwAopDaxJORwo5zVOw37Ezv
         cnZ4SlUGkYE2FjlyRM3At3+RWaom2ract8g+86CgWIr4O2ci0wnW2IEN1pEuECYEuWvH
         FAog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740657446; x=1741262246;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CrI91tLdiEt7M/XW95bclUn0WDE3jwBds2FECmKWUEs=;
        b=ePU0BwYbVHxpnfSjOvEPMmK0sHmsRrjs+/47ZNgW5paLeHBoGnmA7KiQSMg7wHYyPw
         Uvbsr1djTKRKK7caUeTLd8SRFWkcg3UJYvwWKc9xUTHsVY6KRjrEiWKsY05UdgRUbAGi
         h2qKZ1TXU0CJxJGwUujdjjYxmZNG1j/Ca0wMcUdhmJ0SMfweTSnayG3DDKW2uflLciwy
         6RaTATlXWM/2YbOVNgf2oN7V2tzPyuTUgSPWN5HvWuAJHYO8WIWmlDE6POiY8aEsXRRf
         /suinGdqv7+EKq3ZEUAnMUMIg+DjpTSPY9pJPflKLNq8e1GwAToaXEzV0DGxovNpAJ24
         7eTg==
X-Forwarded-Encrypted: i=1; AJvYcCW591s6WcRbwciRiZKsnW9mKIuwdLrhQw5hsYnnKg0/17TtcGT0FbfOuvN6RYmAMdJL6lhZ0SqCGrNh@vger.kernel.org, AJvYcCXwrQh+T5Mg+S2F5ROV0834lxG+F+X+FI/c0MwroEgvXdwq5hThMSQesg6dWQ9znotWaY4eo0630xwDzJaq@vger.kernel.org
X-Gm-Message-State: AOJu0Yzoqk+uqi/IDoiM68H9pPA8Z6FzBRveodqqsSnHz8np3DjhwtyB
	3JrvBgTZ/uFMNu/vvE8kaMfYHeUWVbzt+DHF/EkurDEXa25OUGC49R369Q==
X-Gm-Gg: ASbGncvRSWkg2BQZHl8ey9Gha9teamHhc6dE7sqa7AZ5eKBwtN2kHc0dB9cih7xFSZX
	MRMyvseH3W+nZ1fC1GVnjjXfl/Zi9CIBqZYu1wBDWIga6mO0TSKgHUdwHrYsPVpUCHZrPxFxEb5
	X94eqr5iX6HNmDjahb/6LHt0AbRBVCOeatq1LqC5rg0AUX2VHatEeuJMhQWQ58qaY5a3wYSSKR+
	C+B6AjZLuFhu5QhcOSEvlsCTqw+/l3kJEgTPAHfKub2eYlpZzrjJYHYd/sPOCpvAmbLUoNP5GDK
	hECmU32ncjqTWAGZPDtH/C9tYNr7VuuBCm38XXckjZondF1IpeBXyOOlW7s=
X-Google-Smtp-Source: AGHT+IE0NpnK1nCAt/oaKhM5+h2yiALTwE8EA9YyzKWJXJQnRRA01wCtDxog1sMK7wKKg2OeDprrQA==
X-Received: by 2002:a05:6402:40ca:b0:5e0:922e:527a with SMTP id 4fb4d7f45d1cf-5e43c17fd68mr30521489a12.0.1740657446065;
        Thu, 27 Feb 2025 03:57:26 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:4215])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c7bc015sm109917566b.164.2025.02.27.03.57.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2025 03:57:25 -0800 (PST)
Message-ID: <cedd1f78-7fa6-41f5-9481-c6757762dc66@gmail.com>
Date: Thu, 27 Feb 2025 11:58:23 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] iomap: propagate nowait to block layer
To: Dave Chinner <david@fromorbit.com>
Cc: io-uring@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
 linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
 linux-xfs@vger.kernel.org, wu lei <uwydoc@gmail.com>
References: <ca8f7e4efb902ee6500ab5b1fafd67acb3224c45.1740533564.git.asml.silence@gmail.com>
 <Z76eEu4vxwFIWKj7@dread.disaster.area>
 <7b440d54-b519-4995-9f5f-f3e636c6d477@gmail.com>
 <Z79-PEZ2YQybCjmi@dread.disaster.area>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z79-PEZ2YQybCjmi@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/25 20:49, Dave Chinner wrote:
> On Wed, Feb 26, 2025 at 12:33:21PM +0000, Pavel Begunkov wrote:
>> On 2/26/25 04:52, Dave Chinner wrote:
>>> On Wed, Feb 26, 2025 at 01:33:58AM +0000, Pavel Begunkov wrote:
...
>>> Put simply: any code that submits multiple bios (either individually
>>> or as a bio chain) for a single high level IO can not use REQ_NOWAIT
>>> reliably for async IO submission.
>>
>> I know the issue, but admittedly forgot about it here, thanks for
>> reminding! Considering that attempts to change the situation failed
>> some years ago and I haven't heard about it after, I don't think
>> it'll going to change any time soon.
>>
>> So how about to follow what the block layer does and disable multi
>> bio nowait submissions for async IO?
>>
>> if (!iocb_is_sync(iocb)) {
>> 	if (multi_bio)
>> 		return -EAGAIN;
>> 	bio_opf |= REQ_NOWAIT;
>> }
> 
> How do we know it's going to be multi-bio before we actually start
> packing the data into the bios? More below, because I kinda pointed

The same way block layer is gauging it

nr = bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS + 1);
if (nr > BIO_MAX_VECS)
	// multiple bios

Let me try to prepare that one, and we can discuss there.

> out how this might be solved...
> 
>> Is there anything else but io_uring and AIO that can issue async
>> IO though this path?
> 
> We can't assume anything about the callers in the lower layers.
> Anything that can call the VFS read/write paths could be using async
> IO.
> 
>>> We have similar limitations on IO polling (IOCB_HIPRI) in iomap, but
>>> I'm not sure if REQ_NOWAIT can be handled the same way. i.e. only
>>> setting REQ_NOWAIT on the first bio means that the second+ bio can
>>> still block and cause latency issues.
> 
> Please have a look at how IOCB_HIPRI is handled by iomap for
> multi-bio IOs. I -think- the same can be done with IOMAP_NOWAIT
> bios, because the bio IO completion for the EAGAIN error will be
> present on the iomap_dio by the time submit_bio returns. i.e.
> REQ_NOWAIT can be set on the first bio in the submission chain,
> but only on the first bio.
> 
> i.e. if REQ_NOWAIT causes the first bio submission to fail with
> -EAGAIN being reported to completion, we abort the submission or
> more bios because dio->error is now set. As there are no actual bios
> in flight at this point in time, the only reference to the iomap_dio
> is held by the iomap submission code.  Hence as we finalise the
> aborted DIO submission, __iomap_dio_rw() drops the last reference
> and iomap_dio_rw() calls iomap_dio_complete() on the iomap_dio. This
> then gathers the -EAGAIN error that was stashed in the iomap_dio
> and returns it to the caller.
> 
> i.e. I *think* this "REQ_NOWAIT only for the first bio" method will
> solve most of the issues that cause submission latency (especially
> for apps doing small IOs), but still behave correctly when large,
> multi-bio DIOs are submitted.
> 
> Confirming that the logic is sound and writing fstests that exercise
> the functionality to demonstrate your eventual kernel change works
> correctly (and that we don't break it in future) is your problem,
> though.

IIUC, it'll try to probe if block can accommodate one bio. Let's say
it can, however if there are more bios to the request they might
sleep. And that's far from improbable, especially with the first bio
taking one tag. Unless I missed something, it doesn't really looks
like a solution.

>>> So, yeah, fixing this source of latency is not as simple as just
>>> setting REQ_NOWAIT. I don't know if there is a better solution that
>>> what we currently have, but causing large AIO DIOs to
>>> randomly fail with EAGAIN reported at IO completion (with the likely
>>> result of unexpected data corruption) is far worse behaviour that
>>> occasionally having to deal with a long IO submission latency.
>>
>> By the end of the day, it's waiting for IO, the first and very thing
>> the user don't want to see for async IO, and that's pretty much what
>> makes AIO borderline unusable.  We just can't have it for an asynchronous
>> interface.
> 
> Tough cookies. Random load related IO errors that can result in
> unexpected user data corruption is a far worse outcome than an
> application suffering from a bit of unexpected latency. You are not
> going to win that argument, so don't bother wasting time on it.

I didn't argue with that, the goal is to not have either. The 3rd
dimension is efficiency, and it's likely where compromise will need to
be. Executing all fs IO in a worker is too punitive for performance,
but doing that for multi bio IO and attempting async if there is a
single bio should be reasonable enough.

>> If we can't fix it up here, the only other option I see
>> is to push all such io_uring requests to a slow path where we can
>> block, and that'd be quite a large regression.
> 
> Don't be so melodramatic. Async IO has always been, and will always

It's not melodramatic, just pointing that the alternative is ugly, and
I don't see any good way to work it around in io_uring, so would really
love to find something that will work.

> be, -best effort- within the constraints of filesystem
> implementation, data integrity and behavioural correctness.

The thing is, it blocks all requests in the submission queue as well as
handling of inflight requests, which can get pretty ugly pretty fast.
The choice the user have to make is usually not whether the latency is
tolerable, but rather whether the async interface is reliable or should
it use worker threads instead. Unfortunately, the alternative approach
has already failed.

Yes, things can happen, c'est la vie, but if we're reported a problem
io_uring should get it sorted somehow.

-- 
Pavel Begunkov



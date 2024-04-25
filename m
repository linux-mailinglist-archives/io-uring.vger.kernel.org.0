Return-Path: <io-uring+bounces-1626-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 563EF8B24D5
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 17:16:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4DB9BB23D54
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 15:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AF283BBE5;
	Thu, 25 Apr 2024 15:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Bx2Oz39Z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EF737152
	for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 15:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714058158; cv=none; b=gAI4TqP3JJ3VtWsJU/PBFY6dDj928qYzV/eUsra8UMnSJBwIJDkP+7tmdKsh0Bps8fYm9wNPsHg31CI0HcdbAL3RtqlrKRWrPFfMw3cLxLYmQ9ugJ+o6rXE+dX2iDvyhMrB0P3yv/L3q5lyNznpqAUp/AX9JHiVEc1wnRWVRKdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714058158; c=relaxed/simple;
	bh=qpd0FDJKwtqsySfx9bTVQl171QK/DL/80kQHkEKT0mU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eA6WKI+NYvrRhoI/XKbUTJ2FcXim7ZS2U59Ueh0F42ppQpmh7PAdgb9/EkKoWOOkmqZ+i3vWPBKA+GK73QRdhl8GVueGAoC/CijXRVuYlhQm1uwHAvLIl+q007veDKObfctlLdR/D8c5+/dKxVyiFXSM293WdMRhqJ3URgFyksU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Bx2Oz39Z; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7d9a64f140dso10269939f.1
        for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 08:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1714058155; x=1714662955; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ROO2JYB0GIb0LDk6wTTz87cLHm2ZzTDiJIzS59FToHo=;
        b=Bx2Oz39ZjjOuZmSNHZnpkzYm013IMHke7AmTYZAp1S1b5f/WofM8uPqM6GKPEOfbEZ
         8Z9cv3RM+bEAKOZWyF2dSs1E7db5WDeyHrLcRa5zPh8imXb12Y0OtBPDynjho16150LV
         M4nV9C0/r9/vMRm3aRZZXHYY7E3pXU2CMgRs42wUXVBOhnuBIVhjAqiGYEqK165gfVWD
         ptX0ZvPw0x15lb31iw9ctrxbOlvL+FsQWgwZCQfaX0j2e8ccl3ypyF48HuGjKbiFHoDX
         lvm5B8yjkKtwpYmc+LZuktbBgx0jTzP8t1f8pxpsUPlvfFGZGM8lrPoo/wer6yA89h1f
         5jJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714058155; x=1714662955;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ROO2JYB0GIb0LDk6wTTz87cLHm2ZzTDiJIzS59FToHo=;
        b=Pk6cWonKc+Tg9mglcukHti5ptOOjKW2Gs5LBsqyvjIGIxjuqcclD+hZVMLXpefjlRQ
         23Hf0ZvdkNK/tplK0KTiDVGtmSlYJ8B0xm+wWfnCGJxrtkiBU4S1bA3JHhAXQXv+p+Kh
         QU9Js3Ca4+yG4W6MSvUPopXkbuMbn4qi3vy4U/W534ZE0ljELgGuC8bbV5cKms3BzUuI
         lUvZQz91gBqnwZlIPoe35vooutyrINFSpcrumGsD4LpDnoLE7m2NRctQWeYtYX6Twb2X
         9OoewXNTmHSrIWxGkHzCpbhQo8drEv9sDTuMW7vnziBBOq3LpN8XD4UKMNKIVbqBSWof
         kL+w==
X-Gm-Message-State: AOJu0Yx5gA5jIE+nGxaSGAC8bAIUOS9pg+kI08W6vKRJHw+IMCg/yfZv
	sCsL37wLH+KwpJLHemlXEvflco6pTJ3lm7sZf7dSvmPhvimjc1WWVLNxSUkiKBM=
X-Google-Smtp-Source: AGHT+IHG8ZkMGKjMozZP1TCUwe5KSiNQ3r0yD9q+ZjKQTCfON85jVe/5EeN0m3JA505GZUTEWHCKXQ==
X-Received: by 2002:a05:6602:4f95:b0:7da:8d35:8a5e with SMTP id gr21-20020a0566024f9500b007da8d358a5emr7002339iob.2.1714058155141;
        Thu, 25 Apr 2024 08:15:55 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l10-20020a05663814ca00b0048485c3d865sm4940972jak.101.2024.04.25.08.15.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Apr 2024 08:15:54 -0700 (PDT)
Message-ID: <3ad6810f-1c3b-496c-ba35-f22d05149589@kernel.dk>
Date: Thu, 25 Apr 2024 09:15:53 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rw: ensure retry isn't lost for write
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, Anuj Gupta <anuj20.g@samsung.com>
Cc: io-uring@vger.kernel.org, anuj1072538@gmail.com
References: <CGME20240422134215epcas5p4b5dcd1a5cd0308be5e43f691d7f92947@epcas5p4.samsung.com>
 <20240422133517.2588-1-anuj20.g@samsung.com>
 <be81e7b5-06b4-463e-85cf-acee80c452d4@gmail.com>
 <58d1a95d-066d-4620-950a-fdd70780afad@kernel.dk>
 <53894e1d-d249-464e-ba21-5cb3106c39db@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <53894e1d-d249-464e-ba21-5cb3106c39db@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/24/24 9:04 AM, Pavel Begunkov wrote:
> On 4/24/24 14:36, Jens Axboe wrote:
>> On 4/23/24 8:00 AM, Pavel Begunkov wrote:
>>> On 4/22/24 14:35, Anuj Gupta wrote:
>>>> In case of write, the iov_iter gets updated before retry kicks in.
>>>> Restore the iov_iter before retrying. It can be reproduced by issuing
>>>> a write greater than device limit.
>>>>
>>>> Fixes: df604d2ad480 (io_uring/rw: ensure retry condition isn't lost)
>>>>
>>>> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
>>>> ---
>>>>    io_uring/rw.c | 4 +++-
>>>>    1 file changed, 3 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/io_uring/rw.c b/io_uring/rw.c
>>>> index 4fed829fe97c..9fadb29ec34f 100644
>>>> --- a/io_uring/rw.c
>>>> +++ b/io_uring/rw.c
>>>> @@ -1035,8 +1035,10 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
>>>>        else
>>>>            ret2 = -EINVAL;
>>>>    -    if (req->flags & REQ_F_REISSUE)
>>>> +    if (req->flags & REQ_F_REISSUE) {
>>>> +        iov_iter_restore(&io->iter, &io->iter_state);
>>>>            return IOU_ISSUE_SKIP_COMPLETE;
>>>
>>> That's races with resubmission of the request, if it can happen from
>>> io-wq that'd corrupt the iter. Nor I believe that the fix that this
>>> patch fixes is correct, see
>>>
>>> https://lore.kernel.org/linux-block/Zh505790%2FoufXqMn@fedora/T/#mb24d3dca84eb2d83878ea218cb0efaae34c9f026
>>>
>>> Jens, I'd suggest to revert "io_uring/rw: ensure retry condition
>>> isn't lost". I don't think we can sanely reissue from the callback
>>> unless there are better ownership rules over kiocb and iter, e.g.
>>> never touch the iter after calling the kiocb's callback.
>>
>> It is a problem, but I don't believe it's a new one. If we revert the
>> existing fix, then we'll have to deal with the failure to end the IO due
>> to the (now) missing same thread group check, though. Which should be
> 
> My bad, I meant reverting the patch that removed thread group checks
> together with its fixes.

Gotcha, yeah let's do that for now. It's a bit annoying as with the
async data prep we can sanely retry anything at this point, and avoid
any random -EAGAIN bubbling back to userspace. But we do have some gaps
to cover in terms of either missing that (what the 2nd patch attempted
to do), so doesn't look like we can sanely cover that for now.

I did a revert (ish) commit, will send it out to the list shortly.

>> doable, but would be nice to get this cleaned and cleared up once and
>> for all.
> 
> It's not like I'm in love with that chunk of code, if anything the
> group check was quite feeble and quite, but replacing it with sth
> clean but buggy is questionable...

It's just an awful work-around that isn't needed anymore, as it's meant
to check if we can sanely re-import. With the current code base, there's
never any need to re-import anything, and we can always sanely retry.
The problem is just that we need to be able to handle that...

> Do you think it was broken before? Because I don't see any simple
> way to fix it without propagating reissue back to io_read/write.

It's just always felt a bit fragile in how we attempt to catch the
reissue flag, never quite loved that part. Seems to be it could only be
completely solid if we remove the need to check this in the read/write
issue path completely, and leave it to the callback side. It all really
(again) boils back to how the lower level don't handle this
consistently. If we bubbled back -EAGAIN through the issue path always,
it'd be trivial to handle. But we don't, so handling it completion side
seems like the saner choice.

-- 
Jens Axboe



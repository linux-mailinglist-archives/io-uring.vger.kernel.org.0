Return-Path: <io-uring+bounces-10009-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 39196BDAC22
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 19:20:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9745F18A298C
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 17:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EA5F305942;
	Tue, 14 Oct 2025 17:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="grKHHhmB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2C62C3768
	for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 17:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760462401; cv=none; b=Y5T9ePCS0Ip5GKNEPTENXANjZanRlrEP6YfGaLtnQqo4cFqOlRF8/uSTxcj4AmCAuWzTZ0Q3gL6ytdISZ+wjaLPGH70tBMHTu8yeuIqTDce13H4TuBeOFjQNrGoKhAIzZsYjZSbiNLsSCSdCJ9aJKvdsYpV7886Tej/LI7cf8XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760462401; c=relaxed/simple;
	bh=jN5uvRf++jRqiVxOi1+DAKHxM7cjIgzZk4l3n3hxWTc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=HcP8gNCa1GgRSFLo3bVcPep6iah95unDvlA0z+B1SclcFJyJlWOrOSaZeD/vNsUSubqVoT2eapUcPalUPa7cPZJTo7yRNXMS9eyNcTI6lTAI2sfr4tj+HoLSYlgV5Vgrw2Koy1HCWGKIM1E9pNKB6YD4d9VjP/zednl8XFW8WjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=grKHHhmB; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-42f9353c810so23014925ab.0
        for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 10:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1760462396; x=1761067196; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zxMshKdr+quspeuqEkHg5hx4oo8EDYYaNKqavavB9F4=;
        b=grKHHhmBx4QZf/oAMnYF7YYsYPZuj3cOqVORdJV+bpByr+afsP38FshCKFBYXDtuGo
         mde7bWuHZc44mkYL/bcGQNEiw/7qox/6HNun1sDFYKUTC+gQE8tnItop9+vLDKc0J5vK
         ilHKcCWVHXQyMmhmpK8KkkLIOdMgo0CoE+5Vpl7YV2W/ja0VGvaZlmY83FvllQK8lcQz
         5pUypxgcLVmriuLTyhv4X2nwbPTtZVYnlBejo7uh1orFR1sspB562KJr9OBxtYOp0pW5
         S3YKm/U9SV3YZB4/LFOk0WopfKMiyQIkYea/53pBg7eMkyWS9n6OEmUVv4K9lRfENwSn
         crOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760462396; x=1761067196;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zxMshKdr+quspeuqEkHg5hx4oo8EDYYaNKqavavB9F4=;
        b=mmwg2g8TMuo5DX5+5EtFB7vXsgwZcLJw+lg6fqn/s30dnEtk0zmRf4CPuf3H5oBWZM
         ffz9Bp5gK1bLyXxxn3gHdKpacGjYtiiZ9PrPj+tkatQBkrb7Es2a6ZnhUuY3SBc+U77M
         DRBQe0h8EM1T1DCCV1ZtC0n3QQC5Qj0MjjX2+xmz/qLNbNjAwKXEDnA4OF56+d3zxT0A
         CuOMPfI0SUsEz0jYP4sFW/RSIU7u017tqC0OcSmnqadUgyPSs52CgknXv+2Hh8R6Vh+H
         to/KcCyDbbntInqjXVZYJL6eaa+odl2W6DmeFO+Z+G8dfUF2MpxMuBuLfRBtYiocF9Dc
         7fag==
X-Forwarded-Encrypted: i=1; AJvYcCU+X02XT5KnovTqy2ePiuMQ4fJFdxuURlx6KNlRU4zEppC9zgvuKaE0DkiO3xYUshGaV4i4/M/LTw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxcxyX8hTjCEaIVagVQQvgnQT2qIgx2q4xn3tak7bKfR42xRH+i
	2bt4WueA1bK/Ym/SeoWK+pJZRWHIlDlT3ZpdZNHSdVizXw6hlOcWaniFLc7rtwnxXQQ=
X-Gm-Gg: ASbGncu9Q0J98qtJu0wqT832s84lwmnYOSKt69idFSI/tOZqoszhkg7Ot4Vp647RS6X
	0+A9Yt9q7csvrZ1woWwcV0C5fIN+Gp0plb5JrIVHhA3eB7KQOavLckzYrGyOhauXjhMkbXUL3vV
	rfcP/jl8mATSno+YbBbW54LfJ5mw+RHiEGosa631nEGPGRr1XrXo7yFKFRLJoH5wpW0klVx0nMl
	Qybd0td/dmdtYRCf/o4ZVl+qxfSY1DW0RKod/ru3TYfz1bt+W9Cl8jsircCF2uQnHds+snVHI7D
	JPUtOkFPE0tFhhd5MBW2S1evW/ZFWsHkSYJ9IjgJ9tVrccW8n15q/2AX5hb/g2gtb/JoEXk2ed9
	oa210MmLbtHRC9fwJh3RXMpYa8JNi6qlZvcbshMerWZZgLMbb
X-Google-Smtp-Source: AGHT+IFk17J4ayITB42kfpq0IM6mIDNvxACkmVGhGgQrU7gFZgCD1NF39bszoJ18EwhKYVr0gC/qQg==
X-Received: by 2002:a05:6e02:12c1:b0:430:8bff:c5a1 with SMTP id e9e14a558f8ab-4308bffc74dmr102414665ab.4.1760462396430;
        Tue, 14 Oct 2025 10:19:56 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-58f72bc0c6bsm4978253173.60.2025.10.14.10.19.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 10:19:55 -0700 (PDT)
Message-ID: <e6308a8d-80e3-49c1-9d0c-696701a74118@kernel.dk>
Date: Tue, 14 Oct 2025 11:19:54 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Introduce non circular SQ
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1760438982.git.asml.silence@gmail.com>
 <845640f0-d8a7-4fc1-aaff-334491780063@kernel.dk>
 <de8f211d-6a9f-4fc4-bedc-1be47d4ef292@gmail.com>
 <73fc1193-6615-4e72-98f8-4f9ca5cc9e31@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <73fc1193-6615-4e72-98f8-4f9ca5cc9e31@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 10/14/25 10:08 AM, Pavel Begunkov wrote:
> On 10/14/25 17:02, Pavel Begunkov wrote:
>> On 10/14/25 16:05, Jens Axboe wrote:
>>> On 10/14/25 4:58 AM, Pavel Begunkov wrote:
>>>> Add a feature that makes the kernel to ignore SQ head/tail and
>>>> always start fetching SQ entries from index 0, which helps to
>>>> keep caches hot. See Patch 2 for more details.
>>>>
>>>> liburing support:
>>>> https://github.com/isilence/liburing.git sq-rewind
>>>>
>>>> Tested by forcing liburing to enable the flag for compatible setups.
>>>>
>>>> Pavel Begunkov (2):
>>>>    io_uring: check for user passing 0 nr_submit
>>>>    io_uring: introduce non-circular SQ
>>>>
>>>>   include/uapi/linux/io_uring.h |  6 ++++++
>>>>   io_uring/io_uring.c           | 34 +++++++++++++++++++++++++---------
>>>>   io_uring/io_uring.h           |  3 ++-
>>>>   3 files changed, 33 insertions(+), 10 deletions(-)
>>>
>>> I like the concept of this, makes a lot of sense. No need to keep
>>> churning through the entire SQ ring, when apps mostly submit a few
>>> requests at the time. Will help cut down on cacheline usage.
>>>
>>> Curious, do you have any numbers on this for any kind of workload?
>>
>> No, very likely it's a micro optimisation in the grand picture and
>> would be hard to measure for anything sensible / realistic. It
>> shouldn't be too difficult to come up with a test with a bunch of
>> pinned tasks putting a memory pressure, but that would be as useful
>> as it sounds.
> 
> Simplicity was not the last priority either. E.g. userspace can
> replace all io_uring_get_sqe() with wrapping the SQ pointer
> into some array_view at the beginning and work with that.

Yeah agree, it's nice both ways.

-- 
Jens Axboe



Return-Path: <io-uring+bounces-10008-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 48189BDA8EE
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 18:06:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 016243E23C8
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 16:06:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4659A2C0323;
	Tue, 14 Oct 2025 16:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W3P2niFr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6F725487B
	for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 16:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760458015; cv=none; b=OpKErlVx/Sw7TmYrDRkT7BvIlfn/3RzmkXZ3yDcb3EksY2svqBy/gyVakOqvJ3RRtu+RL3og5DnTmNj9itPUvC2DOzL3W7O1bbU5vgZHZbpVZOj7Tg//jQIeri825jAQ9YGK3VwLMkj3K3IoZ8zg+Cx6l8B12sz7H7SoFjGJW20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760458015; c=relaxed/simple;
	bh=D2h4Ix72AgMZm+RMK+OHwHfSu/OSzCYYh0VRauY1DM0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=Ukk3RxcDlW/DwUOYefKf1sBeeQZ0EWppw220v3cdMiuJk9giwYVaG9b8T3XU/cVnTKC4ZZF1ujKDwSTP2Nd53eU9mzyZdrirv9eQtMbuJeKRt5pi+pG4Ingwe6n6WRVd5xkAyXPPMwmeO0HZUAzdd/NaOvzMjbmZcJ4kJ9v8kg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W3P2niFr; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-46e52279279so39679675e9.3
        for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 09:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760458012; x=1761062812; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dThXzT+iSZbksObjNXwPpvw7t/I5WMUUKglw1f0bozs=;
        b=W3P2niFrfhBzAEs8og4bwXyY4yPjdEjLWiLUVRCUqvG6Oq48VeO1Du5D24d13aLLlF
         S/Fv03QxTP0sAzd2Cxp/RmuT3z61yKFSmK4GHT3RVCKyVbbeY/1N9ICsUHUTlLs55cqj
         vtsUNgLNk0fSQQ6ZSMZ2tBZ+b3tZ1gQeKfWDMTooK8QmzoIdJRB/AmARXG/1t4FKU04r
         x7pN1M2O86yWh4DnYrFAz7h48r7QJdrI1UHztXNqnKlR5XdFXiVOYrqwI4hX8uK595kd
         Odh2UCId5T+bFCY0COlDO/6T1j0FUFBIzEDTInaLXK07NTdcG3QHkzvB5g97/kclODXz
         8+UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760458012; x=1761062812;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dThXzT+iSZbksObjNXwPpvw7t/I5WMUUKglw1f0bozs=;
        b=jZNJow7rSvZDP6DKqhkIE7cPtGLyoadgM4HmYPVrOn/+osd/ISpdFCHjJZzTNU+cT+
         Xxtnaqhrc0Ey0XWkDOti2KG4mLboQnwT0p2GJmxUBzhstfPj10Ex8Z2k/7ifWWN64iLQ
         3k2+ajcSxn33EpcreVpIKSQOsXWyB9UMJBzEaP2FdgpGdqcLu9hs3NmldGGMdKV1vAp4
         bYZq9mjg6PtL9xSNpaWv7rx/yWkXH6QhrxlTinYerKYS8TvgYINYzaoOfT3fkR10iJ+T
         cSPRY00yW8BHMtoq/XdlOPjmh6myx9/tGjrjvysSPw33ilbUYXE7CAPsQIROCeFJyDGN
         xWyw==
X-Forwarded-Encrypted: i=1; AJvYcCWiSaMsbydE9vTAk7hEz8j6lAY4ik9+CbwSeCqc80rkFn6b0vCc8cLDoIY7Xvp8kMdhstsu9LMSdQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwNpqWTMAbGru4vxO+4NeFgGkMUuzYSsImakEOxdFeEIJ5STpeQ
	9nJt/HuKxH4YdQ4by9WoylguIQ0RLE4W1iKazKtuBE5mlufdFJ8C4dcvpMr5LQ==
X-Gm-Gg: ASbGncvKhJhJvfPwSzvszU2ZyyqW3QbmFH9kECgncix3ALTEn/BYxlOH98W/g7osmxk
	d/KLu1E/4YYMADTBrE+6v5oN5yh43Ynr/5KfXL/Btj1tlLcEA/Y1inILYP6tkBNEQbQR1dOOZoW
	kJo3j3Z+1aAEpXMeg+5MlJlK8vafSDTrqhDS3w4mTV7Clm74djRwg9FbWo6QzCQugW5kesVrYhU
	PkT4fH/iCMUobrR23eRP7NDkfmnir3cfO+MBTdF00SOfx2EaDMF0iXWcaC9k6IEUIBtPJBbadmu
	9AA7y3XvzcjOyRsoKcN3NDGkQwH7ycRQIFKSsBhPmRLr3wWpkZX3Y/QBzTeKaAVFQyDapHVzWwg
	ssscJfBwqX3U6L7pPH9HSoPFr81dFiFFbWi+ML+E0POVW1KGZ84ZpLPPOpqpU1FlruD4v+tlq7w
	==
X-Google-Smtp-Source: AGHT+IFxbKUHArolCW9jZ8PW46GtS9soJEWTB2ILzkPekH9LamyIdLb+pm6YRSh5swamcZ4uQT8gyg==
X-Received: by 2002:a05:600c:4586:b0:46e:4883:27d with SMTP id 5b1f17b1804b1-46fa9b079a9mr185523755e9.30.1760458011418;
        Tue, 14 Oct 2025 09:06:51 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:75fd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fab3cd658sm161610105e9.1.2025.10.14.09.06.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 09:06:50 -0700 (PDT)
Message-ID: <73fc1193-6615-4e72-98f8-4f9ca5cc9e31@gmail.com>
Date: Tue, 14 Oct 2025 17:08:07 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Introduce non circular SQ
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1760438982.git.asml.silence@gmail.com>
 <845640f0-d8a7-4fc1-aaff-334491780063@kernel.dk>
 <de8f211d-6a9f-4fc4-bedc-1be47d4ef292@gmail.com>
Content-Language: en-US
In-Reply-To: <de8f211d-6a9f-4fc4-bedc-1be47d4ef292@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/14/25 17:02, Pavel Begunkov wrote:
> On 10/14/25 16:05, Jens Axboe wrote:
>> On 10/14/25 4:58 AM, Pavel Begunkov wrote:
>>> Add a feature that makes the kernel to ignore SQ head/tail and
>>> always start fetching SQ entries from index 0, which helps to
>>> keep caches hot. See Patch 2 for more details.
>>>
>>> liburing support:
>>> https://github.com/isilence/liburing.git sq-rewind
>>>
>>> Tested by forcing liburing to enable the flag for compatible setups.
>>>
>>> Pavel Begunkov (2):
>>>    io_uring: check for user passing 0 nr_submit
>>>    io_uring: introduce non-circular SQ
>>>
>>>   include/uapi/linux/io_uring.h |  6 ++++++
>>>   io_uring/io_uring.c           | 34 +++++++++++++++++++++++++---------
>>>   io_uring/io_uring.h           |  3 ++-
>>>   3 files changed, 33 insertions(+), 10 deletions(-)
>>
>> I like the concept of this, makes a lot of sense. No need to keep
>> churning through the entire SQ ring, when apps mostly submit a few
>> requests at the time. Will help cut down on cacheline usage.
>>
>> Curious, do you have any numbers on this for any kind of workload?
> 
> No, very likely it's a micro optimisation in the grand picture and
> would be hard to measure for anything sensible / realistic. It
> shouldn't be too difficult to come up with a test with a bunch of
> pinned tasks putting a memory pressure, but that would be as useful
> as it sounds.

Simplicity was not the last priority either. E.g. userspace can
replace all io_uring_get_sqe() with wrapping the SQ pointer
into some array_view at the beginning and work with that.

-- 
Pavel Begunkov



Return-Path: <io-uring+bounces-9723-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id AB42EB524FB
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 02:28:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 80BCC4E0643
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 00:28:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16EBC156677;
	Thu, 11 Sep 2025 00:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="h4s9z8XN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8253828E3F
	for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 00:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757550535; cv=none; b=oAz9lqcO7lWfFsqKBYIYFto9cfLYmt6mEBS5MpPNL6F+UWY3/EQW9kvP3rC3TBA7itxwe+Ci19u3VJY1mFoHKFLxUyOjl6aM3CKCj+dCZ1APzcmMJQ++YWQwaFrJwISKOATt/dXpTnUiPvt8gvPwmIOsxcP6YYZ6y4dMg1Q4K8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757550535; c=relaxed/simple;
	bh=toL39ARlVr7ZlC9b2890K3sq1ZqfrV9Api3o7Gv+0Bk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m+YONC8Lb0RrQrvnCB6TjxWCeBj+7SHJuNr8BcFy0OS5lGAIASSwBrii149IsFz582jaGWHfPspTn1wHAZVmkv7zJHSk9KlxB4kwbC32dfVC0/eC28pvkEcL1sC4pSMJY4viQV2DSq0T4+s++znIFKQ/2b5cohNEeqhrvSmA+gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=h4s9z8XN; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-4135366c20fso911165ab.0
        for <io-uring@vger.kernel.org>; Wed, 10 Sep 2025 17:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757550532; x=1758155332; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9mNOaduwe8kMjUPYks8hgUHrKrqr8qKYtPsGRQpW+PY=;
        b=h4s9z8XNrb2qRkR28mGP8nmyiMdKegN4o0c7iqgI7yprd0y0XjqI4isMcjSeP+WYtd
         kS6wf11PDs63iv4AfwwHKCdf45vwW+pUpbA+QU68dWGi7WR/5m+TuQ3Tm3as4ThsMcXB
         2OpzqzMg0ulkRhUMgSxO5WjPQXIXDu0tJiFqBSQIhvR78q1F1nPq/JKq4Z3zpiKkWVeG
         IqUZV25Mkdr7Mhuj0hwnQUxBZJDPi7IigkQhv8welORgJPj7mJ6+M40RXC9eypeiOA/i
         /k2U/7tUq0xPjSHv9gLCxm+JjmsSfy+jKlwEGhp+a3hrqvZ0zt23uNMNQrSxUJUP+XPs
         bZ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757550532; x=1758155332;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9mNOaduwe8kMjUPYks8hgUHrKrqr8qKYtPsGRQpW+PY=;
        b=ADt7YJhRtNbU8sofHlZ7gANW8YTB0+SqIf5JN4QAANGXA1L9Fts9BNLvOZUuaTygKR
         TYvnyiEK6TVimdoC1JbQzqhb1Jhpe5uozZMEwByYi9rZ3nwwTgmbE6DnY+5GTGnwEAxC
         2hInq83A4NHi6Uq8MINBefqE9rmmyFdMTVHae3g5Ky33IM0ZkbqYX6LdDgc584BnM10d
         Diu6Kn24KpBL8I0rZo7cbO5zvXTKyz0AFstn+7YpDM+ZQBIuvoGQljFJ5ZTcua6hcjSR
         KF1hZHDl9iKU43lH7i5dIH9NUDpoAc5LBoX1JRc2rhG/L5b6p8h4vEjZcQZ5b8zEsg+8
         B6Aw==
X-Gm-Message-State: AOJu0YztuvrHjOZtJHEDiwIZaQLsNMRdcvZul5X8U+xAhpiplRb3Sv1K
	eLytKZPWaoXYXq9B3DegK0uXQ2hBcjau1Dcb+HV3IID7uBg/wxLcNhxamXZkF/2ORqY=
X-Gm-Gg: ASbGncsVstLykDr4XVSAX2vlhcQbmg+sm0xKU4iRUeuG+vVtQMr4M5Twwx7zm1Eo7e+
	qfr9kjspUO7mY7oTLY4983XBtvaujILPzzhiDpazLriEJA8aZtj5I6cJ2OLmZkGFIlbX1KG80IC
	afc97yNJIH61QZCvHEbwh+dg1E4f/uJRzHJixCuDa5WQp/OfPnaO6pgCwJhJEJqrMvA1JfKKVmI
	mmc7R6xo6X5Qav9l7lhKFkGfTehgDW+kQcEhx/M4ICMQY5a1BWGnnqrA4H4IkXvlBxkpU+ZxefA
	XK4naBepO4OZx5YyBwiWIH0ShaMLeO2irDweUMy5qmifBb+HhUan9gOxp1np3B6tPw6m2ILeDx4
	=
X-Google-Smtp-Source: AGHT+IGUzix8HaokKnjoOUjNLf4BGHweWL5BczKw1YX7+VMAP2VERFCFAKDMvb7cDTu/esH8VNSXHQ==
X-Received: by 2002:a05:6e02:3788:b0:419:52c5:eed8 with SMTP id e9e14a558f8ab-41952c5f2abmr49735605ab.16.1757550532515;
        Wed, 10 Sep 2025 17:28:52 -0700 (PDT)
Received: from [172.19.0.90] ([99.196.129.100])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-41c96bb22c3sm3571275ab.38.2025.09.10.17.28.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Sep 2025 17:28:51 -0700 (PDT)
Message-ID: <8cb8a77e-0b11-44ba-8207-05a53dbb8b9b@kernel.dk>
Date: Wed, 10 Sep 2025 18:28:43 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCHv2 1/1] io_uring: add support for
 IORING_SETUP_SQE_MIXED
To: Caleb Sander Mateos <csander@purestorage.com>,
 Keith Busch <kbusch@meta.com>
Cc: io-uring@vger.kernel.org, Keith Busch <kbusch@kernel.org>
References: <20250904192716.3064736-1-kbusch@meta.com>
 <20250904192716.3064736-3-kbusch@meta.com>
 <CADUfDZrmuJyqkBx7-8qcqKCsCJDnKTUYMk4L7aCOTJGSeMzq6g@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <CADUfDZrmuJyqkBx7-8qcqKCsCJDnKTUYMk4L7aCOTJGSeMzq6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/10/25 11:44 AM, Caleb Sander Mateos wrote:
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index 04ebff33d0e62..9cef9085f52ee 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -146,6 +146,7 @@ enum io_uring_sqe_flags_bit {
>>         IOSQE_ASYNC_BIT,
>>         IOSQE_BUFFER_SELECT_BIT,
>>         IOSQE_CQE_SKIP_SUCCESS_BIT,
>> +       IOSQE_SQE_128B_BIT,
> 
> Have you given any thought to how we would handle the likely scenario
> that we want to define more SQE flags in the future? Are there
> existing unused bytes of the SQE where the new flags could go? If not,
> we may need to repurpose some existing but rarely used field. And then
> we'd likely want to reserve this last flag bit to specify whether the
> SQE is using this "extended flags" field.

Yep this is my main problem with this change. If you search the io_uring
list on lore you can find discussions about this in relation to when
Ming had his SQE grouping patches that also used this last bit. My
suggestion then was indeed to have this last flag be "look at XX for
IOSQE2_* flags". But it never quite got finalized. IIRC, my suggestion
back then was to use the personality field, since it's a pretty
specialized use case. Only issue with that is that you could then not
use IOSQE2_* flags with personality.

IOW, I think the IOSQE_SQE_128B flag is fine for prototyping and testing
these patches, but we unfortunately do need to iron out how on earth
we'll expose some more flags before this can go in.

Suggestions welcome...

-- 
Jens Axboe


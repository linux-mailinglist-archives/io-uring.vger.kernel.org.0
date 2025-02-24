Return-Path: <io-uring+bounces-6695-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B419A42C65
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 20:10:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D03753A61C1
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 19:10:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9A85189F36;
	Mon, 24 Feb 2025 19:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="C48qejSx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648B01E5B95
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 19:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740424208; cv=none; b=UO6eMtPuK6tJqRA0CYqyeeMm+WXKgSulNbgGHMWryDPkDnOR4jPYBocle48z/OaHpcbsOdUSa4nZVUq03mBDXlSMJ9offsQIcCkOd51rea34CFZqI5NxrWBakBhUj1YH/Bb8gKIUu2WSVbR52dx+fC2oycFAJzWxh+U49tB0Mx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740424208; c=relaxed/simple;
	bh=T7YErwBzM3Xp9awb651aOZgPiu2dAaV63y7n1aimj9I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DE2oX+BEcd5Xq+jdz3LN0KpYQBAmBlAnQJ7ZWxtj0XST2nbUxCqiJWZGvFiIbmIC/Lfb59YLd8MJgv4vEwdk+nxAoMLtHlvyZnNSsk8jxuEK7JRIucrHZUcB9YoL9n6qGBHGyJE/1aVpcQZiGXv0a7sMteHZRg7cOhbdqzkOFVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=C48qejSx; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3d2f7257181so1276745ab.1
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 11:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740424205; x=1741029005; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PqbHB05B4SvIPHaJMOkpStsDUjppa28qG+czwoXrbKg=;
        b=C48qejSxH6IF1Ow052MGWOqndOtse36ibHm7CKPnPRydPSBfLJqUd2e3PHYuK1NO2U
         xtiPFryTzdZ8XvwuJ3y99oMhuhGExvVdNpmgJkSyI5RJ4Db2pAW8JSFy0xNGQcIPCdyv
         sX5LXbJ+Q0VaNEGfkbxP5GYUk0ma08qoMoi2Jg3gQVkQ5CXPzWEVx3Uxq4qXRx3xQSIg
         1hvk1BLvcF7FHR7rOfCi+MMtwa0l18GwDe8fZb3MIXCTjNHzya2mDj1cBxXHOmkDeld6
         N4jlS/BHA9NmOYYjTHDcEqrfKVQHWOluzIiVSJMKPO9dbWnIca0BEW+5HYNlKmywn3tZ
         ZYww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740424205; x=1741029005;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PqbHB05B4SvIPHaJMOkpStsDUjppa28qG+czwoXrbKg=;
        b=Z6xJcQ0Co9R7r6xduaBjz5hqvqslm3rnrcDoLWt5aYlIZv1NbFOM0qul0yYgA96UQc
         cLj06+u3+vxGjvNHtDNkIKa42ptpzOdnqR/k5beuAMNouKkfi/kBba08aYzn+kycq4Vn
         eP0NJt1NI3k6uInTGg4HrGqgHR/GOOPWoAszG3ppUL0fHpgTSY3e2Ez/a3K7cj47r2Mp
         9nHQhO+Vy5O+qyTUUYt7vDMAX2HY+Pu1cxmhcZ5trb4rYFWW46XvWPfg+LWI2DQyK3fY
         ranJKawTNmoBsXdGnrNEkPDqbwbXfrjHLioNxvCsr2IbqMU/+zy2BIsLmZyrdgPhwAvs
         ejzA==
X-Gm-Message-State: AOJu0YwDo4WunswgIzFZgjeU744Yr71G2tA6m7E2DOBleMtVHT4yXr0x
	0SExEEJGkGW3mWWfnG0hXWdJcEwklPka1GizbUvNVqnZE226bEUA6xCHBWkCzpc=
X-Gm-Gg: ASbGnctr42y2yvuNzVaTmfnuQ2lFnfnaKEgrdX9I5IrmHc631W7VZ756TGX13R7dUBu
	Ir9oHoUXYaQOJd4BHkR7vWGkFo2/u02/vMoN7H7sqdrLSpMy/CEKKKe5LartBqOmApGx8Xxdq8r
	PytQP3pfcoMrMJVLoVWpmK4XUGBJVL15dK70ha/riP8mPbtslWuLBot2B3FZHsa1w2CZxRFFP4M
	tbGO2x9rK5he5rF/Y9/rbF/mo/uYqRqB40TgTAcgbsg7LsoXA/GqcsXHlCjRYXuXPjY7b7e3rom
	njkDHDRfqOaS3Q45ncwoF0U=
X-Google-Smtp-Source: AGHT+IE9yRT47uLO/qnZ8m+KBTEjrY8OpDaMFUTbEWKNyPYD36u9FByoFodrZPa/f5LtblX40YcluQ==
X-Received: by 2002:a05:6e02:20ca:b0:3d2:ae4f:fa12 with SMTP id e9e14a558f8ab-3d2caf01848mr117386215ab.15.1740424205319;
        Mon, 24 Feb 2025 11:10:05 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f0475134c2sm25231173.91.2025.02.24.11.10.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 11:10:04 -0800 (PST)
Message-ID: <2f7a0d65-afc2-4592-935a-30cc324104c6@kernel.dk>
Date: Mon, 24 Feb 2025 12:10:03 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/waitid: remove #ifdef CONFIG_COMPAT
To: Pavel Begunkov <asml.silence@gmail.com>,
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250224172337.2009871-1-csander@purestorage.com>
 <ebad3c9b-9305-4efd-97b7-bbdf07060fea@kernel.dk>
 <CADUfDZrXAn=+4B9boaKe3aMBq19TXn8JDQm4kL0ctOxwB6YF9g@mail.gmail.com>
 <fedd8628-327a-473b-9443-4504fab48c2c@kernel.dk>
 <91c200cd-2b2d-4756-b641-aa1bd4ec9796@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <91c200cd-2b2d-4756-b641-aa1bd4ec9796@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/24/25 12:10 PM, Pavel Begunkov wrote:
> On 2/24/25 17:55, Jens Axboe wrote:
>> On 2/24/25 10:53 AM, Caleb Sander Mateos wrote:
>>> On Mon, Feb 24, 2025 at 9:44?AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 2/24/25 10:23 AM, Caleb Sander Mateos wrote:
>>>>> io_is_compat() is already defined to return false if CONFIG_COMPAT is
>>>>> disabled. So remove the additional #ifdef CONFIG_COMPAT guards. Let the
>>>>> compiler optimize out the dead code when CONFIG_COMPAT is disabled.
>>>>
>>>> Would you mind if I fold this into Pavel's patch? I can keep it
>>>> standalone too, just let me know.
>>>
>>> Fine by me, though I thought Pavel was suggesting keeping it separate:
>>> https://lore.kernel.org/io-uring/da109d01-7aab-4205-bbb1-f5f1387f1847@gmail.com/T/#u
>>
>> I'm reading it as he has other stuff that will go on top. I don't see
>> any reason to double stage this part, might as well remove the
>> CONFIG dependency at the same time, if it's doable.
>>
>> Pavel?
> 
> I'm not sure why you'd want that, but I don't mind

Just because it imho should've been in the initial commit, so I'd
consider it more of a fixup commit. But if you're fine with it, I'll
fold it in with a note.

-- 
Jens Axboe


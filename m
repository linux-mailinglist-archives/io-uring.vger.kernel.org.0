Return-Path: <io-uring+bounces-6097-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B8AAA1A6C0
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 16:11:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8153165B91
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:11:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B16DF21147C;
	Thu, 23 Jan 2025 15:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ed59xVzn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D7E211A3A
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 15:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737645099; cv=none; b=D+iRsj9KrtY6un28ANSg6kWEWAcslAGZiw4KEyrXu7GIEDsTl7UC/V0I1l/N9KTjk2uD0ItPIyLwBPdx8qz8j6ggawOAyesGAVZVHYr46PB/EJMZP7yREBZhFZdxz1NfkOQrzHujErzFsQJ6rlNrHfhrWm2o2OBKrmQGIXrqEw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737645099; c=relaxed/simple;
	bh=UVZ6NArjF1ZcMZyxotnmH4G0QHWDEIgCrE9ut+q8Xc4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CZLi13nB5VmnZ99J4s03rQGGOkLK5YYPMXKkvR5WBDZlkX6a8y5QF8G3VGEzo/hasLTkcisxvsqtJETJkerFG2d7pGT33J0Vu/XKxtSokoGDzDARLgg4DIRbo0phQgAh15q/g9/jCxMZma07CQIs8kL5ruTTsNpi81hTLqhVkU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ed59xVzn; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3a81324bbdcso7526605ab.1
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 07:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737645097; x=1738249897; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wm83wscrQUkd5TN8872EIFISEWysD3t/grREQ5ujlzc=;
        b=ed59xVznQlMsauQdnQdYChqnqKYo09oFJPuuMKh7ZyNuxc+9M9XPvdl83c0LhTeEXO
         Ha/qP4+tcdbcz53UCFyI0RflS/b1V5xVxFb2waHLeAuw/4fLHxHjY9aLHAdxcop+mYzn
         rRCgcc3IKmTda4CytsqHZlpkMCllmG70R8Y3/Nivy4RRRBiQ77Cy3JNNTMqjT57cv3XV
         hw1I983hXWxuRSpl1qC4ve2mK+1/mWw7to+J7hB1XHhKWS+rYOeBUmi+0vZ6gzmAShSn
         eRm/UrxsbQI/6B9WTe1W+fSmBY9wwxIb1axRLjp5It91PwNF1t3hkH4CxpJdu+c/s8Br
         F16A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737645097; x=1738249897;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wm83wscrQUkd5TN8872EIFISEWysD3t/grREQ5ujlzc=;
        b=OM7obE5TFYi5ARlI41CYjVZoAopGJ9gAictjI/L7LyQzIbYdzTTK5pEd2/zkzSB/0w
         41tFl5wuFIn9+UntbddWF4WOOWEVN0YqDbz4GexAwYSAvl3Xx+mrAIszHSUBBFirS+dX
         p+S9kSv7UN244mf+dA+3LK8AITxE8E/Le16EedskJw3kAYMRRp9Txa8AJuE1lqUiuSgU
         X62/IzuievzAYt4pKengOo4eL4idPKUz/EZQYhGU0VJg9PQR7+UKZptuQJegSzfD9Jba
         IAJmXTUx8kkadkNzGjVrdvdy4Vkd1bifckGCvR1lBs6q9lgg9x8eWg+iVWWal5a7ySi0
         KY9Q==
X-Forwarded-Encrypted: i=1; AJvYcCV3etDvMHQ9f/c1IisdvGbTc+xTZ1YS8mnRfmlYAANhyu0Ab80ykGpYoNii2NYmtuAJLwyWKNzY5g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxAQhlkyXLIYj/mR+FC78K1SfKEF2OfT7k1tF/S0QrIwtO7x+4D
	NnOMGyxXW3RGClCgWuwJOznQGm+F9mjaBsICp5ttVMWx8XePSNXcyiaaZ0MJadg=
X-Gm-Gg: ASbGncurxzKJpMTldGOuozZp5HkTeOnq0LGF82fZFEBzxbJUX8E4xpGo4SRJSOJETiv
	9K2TGiMt4SxVeTXEAZ9Jdktqjx9I/QkghP7CkbgC6lEv+IFVf1tzdAck2sMqDW0jkMb7BH4LN35
	4Db/Xg1eOKN8RYpSv1Prpkw8c7RDWv/N4M735wY8+6lM67qjZtSa88JaO8+v62+ARHMnBf3yFjr
	AemiuZKNk/vh9TSorm1lzLnepDdDpguTYHqj8Yp0YQHz9g7shEc928jeP2e9NRg0Pqu6s7C7kEZ
X-Google-Smtp-Source: AGHT+IGe+UG483tiaLa5Jk8Cj7iFRNaZ4YZSe8w/dn+nAvwTG5bujucefh9nlhgP2jHIWeWkQZCw2g==
X-Received: by 2002:a92:cda1:0:b0:3a7:955e:1cc5 with SMTP id e9e14a558f8ab-3cf743b9350mr238785155ab.1.1737645096856;
        Thu, 23 Jan 2025 07:11:36 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3cf71aae907sm42399885ab.35.2025.01.23.07.11.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 07:11:36 -0800 (PST)
Message-ID: <9a4261bd-7c8c-4413-b9ac-ae1aeead1060@kernel.dk>
Date: Thu, 23 Jan 2025 08:11:35 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/uring_cmd: add missing READ_ONCE() on shared
 memory read
To: Jann Horn <jannh@google.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250121-uring-sockcmd-fix-v1-1-add742802a29@google.com>
 <173757472950.267317.14676213787840454554.b4-ty@kernel.dk>
 <4bf7e5d1-4e66-496d-a503-5dc349efe398@kernel.dk>
 <CAG48ez0r4_U-9TfZOnZA0TKKPc64eYgYQt-3jHDYEqE9OuhLxQ@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAG48ez0r4_U-9TfZOnZA0TKKPc64eYgYQt-3jHDYEqE9OuhLxQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/23/25 7:44 AM, Jann Horn wrote:
> On Thu, Jan 23, 2025 at 1:18?AM Jens Axboe <axboe@kernel.dk> wrote:
>> On 1/22/25 12:38 PM, Jens Axboe wrote:
>>>
>>> On Tue, 21 Jan 2025 17:09:59 +0100, Jann Horn wrote:
>>>> cmd->sqe seems to point to shared memory here; so values should only be
>>>> read from it with READ_ONCE(). To ensure that the compiler won't generate
>>>> code that assumes the value in memory will stay constant, add a
>>>> READ_ONCE().
>>>> The callees io_uring_cmd_getsockopt() and io_uring_cmd_setsockopt() already
>>>> do this correctly.
>>>>
>>>> [...]
>>>
>>> Applied, thanks!
>>>
>>> [1/1] io_uring/uring_cmd: add missing READ_ONCE() on shared memory read
>>>       commit: 0963dba3dc006b454c54fd019bbbdb931e7a7c70
>>
>> I took a closer look and this isn't necessary. Either ->sqe is a full
>> copy at this point. Should probably be renamed as such... If we want to
>> make this clearer, then we should do:
> 
> Are you sure? On mainline (at commit 21266b8df522), I applied the
> attached diff that basically adds some printf debugging and adds this
> in io_uring_cmd_sock():

Yeah you are right, braino on my part. If we don't go async, it's not
copied. The changed fix is still better, but I'll reword the commit
message to be more accurate.

-- 
Jens Axboe


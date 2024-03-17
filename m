Return-Path: <io-uring+bounces-1054-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FFEF87E060
	for <lists+io-uring@lfdr.de>; Sun, 17 Mar 2024 22:32:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40E751C20C63
	for <lists+io-uring@lfdr.de>; Sun, 17 Mar 2024 21:32:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BADB208A7;
	Sun, 17 Mar 2024 21:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="i2iFAV08"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E331420B04
	for <io-uring@vger.kernel.org>; Sun, 17 Mar 2024 21:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710711171; cv=none; b=Kz+456SS+jl4dupyS2k9sOTe/c5Ctm+y5/38X4Wlt40JcGUOrtcqY3sik5AqIAl6KQkzellbWPiKqjA9Dtgz589tdDQKeMti7O1Llpdnw6JncvBNmXh25hFKaLg75SN7BCkr9VYhYawL0meFJy3MJPvjXjayBc4J+XfNw2mM4fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710711171; c=relaxed/simple;
	bh=he7XLr6nvEeXA1sNzO0MiwcJH/cIatKtgQGktTuGREU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KQTSqXG3ZRfcW8AaznlqJ0Znh7O8bdrY31fcIaS+6+D2aioDQsGcu/jOTwdJiHfE0u7F+BbYUde3TdHcHrzyIgxJ3DoaSZzzkAzx7wklwCv/8I4PTSO2u9Xdn+nQiWRZDwIM/M/YIOtb9wQ9VugLaIXWOTkr+OURO5xsgHzLE3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=i2iFAV08; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6e6ca65edc9so1297976b3a.0
        for <io-uring@vger.kernel.org>; Sun, 17 Mar 2024 14:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710711169; x=1711315969; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A37s91U0IzsJqmO2knfT6dX9PadaYPKrqlyiA5V8Xuc=;
        b=i2iFAV08abmeCz0ediWQZHL2PTkg4grsc5hFfqSLsLXn83Gk5LWSoe0Lc2m3qJh2K9
         w128N6uLmoETqhO7B+oVYTAlSB0OQLR0KulhA+DTMnriL9hYZWPl9swleo9OYT+eCVBp
         n1iQac2Rcu125T4mboFAeKScD+Dzs2Hwkxd0U1f1ReQA5i5Qd49EWah8ifZR2xsOI7ZE
         +28qAqn6fW+Al+jq6ilsMh9sdIV9+gmJFPEK5Bdt0E841gJ2vPe7wxPyluRQ9Dv7U7pS
         cawrls1OLZbhYgGZtsusE+5R+Ff5gDc76WPmYQKbKRcZHCrTpgf0PjAhkdt9gXm0mD+m
         toeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710711169; x=1711315969;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A37s91U0IzsJqmO2knfT6dX9PadaYPKrqlyiA5V8Xuc=;
        b=OBO34iK6Y6eutwZDjKZ/mc1lgzI7wgu+2sTWfvMpCT10NJinI5jyD9oEOdqlO2SyJL
         101jOYAUErZiamU4s6ON5qHBkC13Srwn/IL2pIAUx6GiS8Yfcq6hMVqoh0xUZgo4TZ+t
         QizbvvIre2IkKfGOeMOPjt3Ux5owuoQQrHb5ajoSAupfK9oQW8UlLsXwRedmPlIf2rfL
         dL7RP8VgyggFX9waMn8WzZNzKzNQl/XiV6zTUYO/QXWxGYuu/0A4U/q8uyNxJCswQnV+
         etQESpN6tgQoSIgrX5aziAGwBcBY1ocFqcLsnJCVbnTS2WWOiAawhLOe8K0oLwwgJ/8o
         Rrcg==
X-Gm-Message-State: AOJu0Yzhm2N4a5ckwcs2avH+Xi2vqTieAGCV6DMx4WVrOFh4I+MSUTBH
	2wYAq/KL4b8iOar8gk7iIiuxLW+NkshRH+HY5zSIktK6NHg3rvJmMLrKVpn5SCgIFRMT2rcQraA
	3
X-Google-Smtp-Source: AGHT+IE2vo4jzcOzj4c7DFgKAHzWyn6YTkaMFK/0ODKucUCwDG1w6lIarE6qvGTD/gL9xFSl/FMbzA==
X-Received: by 2002:a05:6a20:6a04:b0:1a3:5606:70bf with SMTP id p4-20020a056a206a0400b001a3560670bfmr6211672pzk.5.1710711169181;
        Sun, 17 Mar 2024 14:32:49 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id e24-20020a656898000000b005dc8c301b9dsm5028443pgt.2.2024.03.17.14.32.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Mar 2024 14:32:48 -0700 (PDT)
Message-ID: <4787bb12-bb89-490a-9d30-40b4f54a19ad@kernel.dk>
Date: Sun, 17 Mar 2024 15:32:47 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH 00/11] remove aux CQE caches
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 Kanchan Joshi <joshi.k@samsung.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
 <171054320158.386037.13510354610893597382.b4-ty@kernel.dk>
 <ZfWIFOkN/X9uyJJe@fedora> <29b950aa-d3c3-4237-a146-c6abd7b68b8f@gmail.com>
 <ZfWk9Pp0zJ1i1JAE@fedora> <1132db8f-829f-4ea8-bdee-8f592b5e3c19@gmail.com>
 <e25412ba-916c-4de7-8ed2-18268f656731@kernel.dk>
 <d3beeb72-c4cf-4fad-80bc-10ca1f035fff@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d3beeb72-c4cf-4fad-80bc-10ca1f035fff@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/17/24 3:29 PM, Pavel Begunkov wrote:
> On 3/17/24 21:24, Jens Axboe wrote:
>> On 3/17/24 2:55 PM, Pavel Begunkov wrote:
>>> On 3/16/24 13:56, Ming Lei wrote:
>>>> On Sat, Mar 16, 2024 at 01:27:17PM +0000, Pavel Begunkov wrote:
>>>>> On 3/16/24 11:52, Ming Lei wrote:
>>>>>> On Fri, Mar 15, 2024 at 04:53:21PM -0600, Jens Axboe wrote:
>>>>
>>>> ...
>>>>
>>>>>> The following two error can be triggered with this patchset
>>>>>> when running some ublk stress test(io vs. deletion). And not see
>>>>>> such failures after reverting the 11 patches.
>>>>>
>>>>> I suppose it's with the fix from yesterday. How can I
>>>>> reproduce it, blktests?
>>>>
>>>> Yeah, it needs yesterday's fix.
>>>>
>>>> You may need to run this test multiple times for triggering the problem:
>>>
>>> Thanks for all the testing. I've tried it, all ublk/generic tests hang
>>> in userspace waiting for CQEs but no complaints from the kernel.
>>> However, it seems the branch is buggy even without my patches, I
>>> consistently (5-15 minutes of running in a slow VM) hit page underflow
>>> by running liburing tests. Not sure what is that yet, but might also
>>> be the reason.
>>
>> Hmm odd, there's nothing in there but your series and then the
>> io_uring-6.9 bits pulled in. Maybe it hit an unfortunate point in the
>> merge window -git cycle? Does it happen with io_uring-6.9 as well? I
>> haven't seen anything odd.
> 
> Need to test io_uring-6.9. I actually checked the branch twice, both
> with the issue, and by full recompilation and config prompts I assumed
> you pulled something in between (maybe not).
> 
> And yeah, I can't confirm it's specifically an io_uring bug, the
> stack trace is usually some unmap or task exit, sometimes it only
> shows when you try to shutdown the VM after tests.

Funky. I just ran a bunch of loops of liburing tests and Ming's ublksrv
test case as well on io_uring-6.9 and it all worked fine. Trying
liburing tests on for-6.10/io_uring as well now, but didn't see anything
the other times I ran it. In any case, once you repost I'll rebase and
then let's see if it hits again.

Did you run with KASAN enabled?

-- 
Jens Axboe



Return-Path: <io-uring+bounces-4435-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0708D9BBBF6
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 18:31:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A6BBF1F21069
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 17:31:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C92018E29;
	Mon,  4 Nov 2024 17:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HRJ5v10a"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2E61C9EB8
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 17:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730741485; cv=none; b=ovXZsDUV22ljW0pRNj6rNVZf1A3mCws5u5xLTb1Ayd9GvuuxdNxE6fEtV5qP4lxryyQNzW107J+194vh6gEN9bHiHfC/i8uVw6h/V4ankxmL7vb3TpDWdQkH7a1Kl8iw9ooVmmyKUzCsOm0Td/LMVAD1Zew0YRw51OXueIvPBro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730741485; c=relaxed/simple;
	bh=D+8cboCKmXbjd9xDZY6+Va/CrFf76rKthGLr0EET7uw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cb/F12/CvjZfCEm/9wv6rbjLHX21SrXsq+OnnfxLni7z4FKGDSpPtt806HPwM8BDjsyuzpdXUdyf+WZakEjEN9PgmfEK4SdmQyu2o455qJQKqDaAkf882UyO10y4TN+gdp6plLpizxc9ki2ilpcmZXDCuwSdSn20dUH7K62f4dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HRJ5v10a; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-83abdaf8a26so173584939f.1
        for <io-uring@vger.kernel.org>; Mon, 04 Nov 2024 09:31:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730741482; x=1731346282; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QXD5lLvoyIko8XuAkP726zUKUS9M9g/ww80dFW+8nGg=;
        b=HRJ5v10ajJXjS3JuJxHAebiS4TgmMHrH7CRTN8EWex1Xw2QqBh1Nf0SrYWUbHEkrXf
         BckD5GLIyuRwpupGrpDS7Hj+3lEwArFcFxaE82UANglS5Tk3t1o8WbRsTLrYX1+hvcqN
         VAqsNHThg6qxLYx4F2hb5Z+yaIod2oxnXq+3ZGbokicC5BmhL6nAn7zXxQ+KrnxlKa17
         wa0OIjhJXSL+1VE618jJQUFZPqHyTFCZUclEmZrNteHIVryYUc3rR0jkDyIqHHd7Wa4Y
         dSDA5Dla8vmgZor3fC7ec77e2hNGbUd4uDwytgFYD7srE4pj5uV1eWq+m0Q3/ejiZsb7
         WPEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730741482; x=1731346282;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QXD5lLvoyIko8XuAkP726zUKUS9M9g/ww80dFW+8nGg=;
        b=KWZMfjessOeKG5y3fusS8/8a8mDJr+nSh1a97Pwjd0zxrm2EZV08t7Num8bU2OTTor
         nIrYHGCvk+K/7cxyqYfqiZXKtwG1fleh4c6xeCxHl7P3IaUtQME7Y58/iUbdtrI7/sCk
         /65AnYi3wWOOqlIRI7itM4DRZul471O2hMwThwF5byNSh5wAZ5/jo3i/qaEHLiWwAFGv
         SAY/GuEXftOadkEuw3+WJjyrP+p7rSWAW0jr0UdbcrDRijP/ko8g4C6tosCniHrn5vzy
         WLClqimHRMRhGBGme3ialmoACAxE2kk2APenJdRgHFGKbHtZfeG82viVAk3/Kvx8y3Um
         ntlw==
X-Forwarded-Encrypted: i=1; AJvYcCVT/F1Z66tMglTCmQhO3Ktbx7gTPWFfnxmfnNTUX08jvXJUq8BAY58U29KGCNlxDDRNBo29reGehw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxlC9Tzlg05gbSGRalGdyO2C+CeZRSit1UATNpdhP81ay6UMqLk
	Qt/C2JvR/RAnEqwBglDMWvgs4KJkif6JjAHHx4dd4il72dWAaAjYEEfVy1bYmt0=
X-Google-Smtp-Source: AGHT+IFXFhiko3NvBnPFXezGjHBTIZEM4USsweLLqRqFQpZ/TO+mgnkexOcSfJCpcXn4PvWxJMK8/g==
X-Received: by 2002:a05:6602:6116:b0:83b:29a5:ff91 with SMTP id ca18e2360f4ac-83b29a602d7mr2773481439f.9.1730741481538;
        Mon, 04 Nov 2024 09:31:21 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83b67aeaeabsm220017039f.11.2024.11.04.09.31.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 09:31:20 -0800 (PST)
Message-ID: <421a29af-1bb8-4106-a875-5c382eed3d90@kernel.dk>
Date: Mon, 4 Nov 2024 10:31:19 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/cmd: let cmds to know about dying task
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: maharmstone@fb.com, linux-btrfs@vger.kernel.org
References: <55888b6a644b4fc490849832fd5c5e5bfed523ef.1730687879.git.asml.silence@gmail.com>
 <269a3887-070f-4faf-85d6-73e833f727ab@kernel.dk>
 <6c774395-6537-477d-a5a6-f58edb07f436@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6c774395-6537-477d-a5a6-f58edb07f436@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/4/24 9:47 AM, Pavel Begunkov wrote:
> On 11/4/24 16:15, Jens Axboe wrote:
>> On 11/4/24 9:12 AM, Pavel Begunkov wrote:
>>> When the taks that submitted a request is dying, a task work for that
>>> request might get run by a kernel thread or even worse by a half
>>> dismantled task. We can't just cancel the task work without running the
>>> callback as the cmd might need to do some clean up, so pass a flag
>>> instead. If set, it's not safe to access any task resources and the
>>> callback is expected to cancel the cmd ASAP.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>
>>> Made a bit fancier to avoid conflicts. Mark, as before I'd suggest you
>>> to take it and send together with the fix.
>>
>> That's fine, or we can just take it through the io_uring tree, it's not
>> like this matters as both will land before -rc1.
> 
> There should be a btrfs patch that depends on it and I would hope
> it gets squashed into the main patchset or at least goes into the
> same pull and not delayed to rc2.

Right, all I'm saying is that both will land in -rc1 and it doesn't
really matter. Even if it's -rc2 it's not like a potential breakage with
this for certain exiting conditions is an issue. All that really matters
is that the final release is fine.

But like I said, I don't really care - it can go through the btrfs tree
as-is, or I can take it and it'll land in -rc1. If the latter, then I'd
just modify it to use io_should_terminate_tw() fro the get-go, if it
goes via the btrfs tree, then we can do a separate patch for that after
the fact.

I just need to know what the btrfs people intend to do here, so I can
plan accordingly.

-- 
Jens Axboe


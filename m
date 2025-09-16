Return-Path: <io-uring+bounces-9822-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BCB45B5A088
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 20:33:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 694653B1411
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 18:33:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C692822758F;
	Tue, 16 Sep 2025 18:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Pk6YK6uk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A1F143756
	for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 18:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758047596; cv=none; b=eg0lGL6OxADHS7HfJuRyDgJ4zMG9KHxoOKZ7lHY6Qg7L1k3TRI4Rz1duhboMsIQ/713LYYWSBWgk/38D3KV2GzEyxWLjnMLpgvZveYTmucIFA3CtrAX1SBkwc69lY1EOOEr/UctKJGKtpySLr1iPrc/UhEat3hhm7IjNsN6XJ9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758047596; c=relaxed/simple;
	bh=E+js8Mj/9PcwV7FMBMBKNAcVI1TfhdtugZP+viB2/E8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Mnq9XPDEzlaWXyU3rNOpl2YkProFiPGWCxNQ+p+jJI/WEA9lzx5E8+lTf+Pb8aIgC0Stm/hBnvdRKcj5RD9AAOGQyrzPOH8K4zpBSvb8HoUiTzutF0J5mRQpHkQh/SxHJTjOeXI9kgJ5q/WK1l6XWIErJzRONaaVGQC92ZNaVjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Pk6YK6uk; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-887764c2834so370009939f.1
        for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 11:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758047593; x=1758652393; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3+FTu3ZmC968x/uN9Z0827TSUO9xT+nB98chg/725hg=;
        b=Pk6YK6ukkzo6shMcXcHZn38HP4xZkdbMyPgPz61I4Js8z031Z9GqPfJTj9D7gEzWpP
         ku6hBsyb9oYgfeo9cQFvlFFJ3GQh6x0KrV8hn+bUgJjbYCLSDhFepC76cFCd0zbM5Uxt
         3QOC+JYbQRWVvwc6bKwYs1YVw3z58OB2ywaq4ZF8FNr+DcXP8ndvHr6fUyglajWABJDl
         mLZeEI+5hyJJD5PiG40NKk+Mi8Y7OBRPeRa2F82qD/NUehmZcwSBxAMCqVKJJllzKwdf
         j08kClliafo1MzLI3wCXcOzAIM8BrvPDjiU5pmEcbel14fYn0mPqHcRZNNtPeal7E6b0
         6Irw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758047593; x=1758652393;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3+FTu3ZmC968x/uN9Z0827TSUO9xT+nB98chg/725hg=;
        b=WRzlrMR5M1ZqZ4sU1g5yr+mUo0DlHNJeTRVnNge9Ihn6Yf19dLKaLuY/33Uk+4rNFW
         zXFheqaoGEjFNoRPUjE6UrpRpxfuX5Jhx+GlyIJQnZ7HUOERDqqNPMrFK6xIqxoIjQ/J
         KIwkbDR6+IghUwf4k2V5Y6WKTjWVWbicWUK4orbjQXJz8xhuOa2H71sKj3KY1zvnS2sD
         mRZDrzRrl0e/8393H3QZc5s3H7PiE5zGIRFN7O757szD7EXKYjK8ELkS1mI9497tPqMv
         U/s6Dlakr732qpE6lqn4JOzQRtLFX1+wxlYG544WvPbZKPkXftvMx15QZ/IQ9odSz7Ee
         frGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWc7Yi03MgXSqgsJVjSJLPp3hrfoqST0vB5PhuNM2hMIokNtrq8U7QDfl192wsLLPHhXeDzY6id9Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyhc7g9add7nAUdGNJ81ZIP1h5WLobwBJtB09ZpB3284brJw8KF
	wEKlXT5BCzSsIgXE0CeiRmzzdKCd3R4swDBsBAI6HChzOYsT7mmo8NzBIOH82RICeUZhpuhQa3i
	X0vDJ
X-Gm-Gg: ASbGncsGAx8s+rDsQb6vwdiz+qSzONfzCZXEJhWa3rZ3TJnljyDEYIFnmyTB7yF0ZjV
	7JRUI1n6k5ysOgH8Qs2jqUzTIP72cisdQW7mSOSy3PPqTpHZyQlw8x5OmKndNETHVKAZ4DTPFxB
	pogTy5z1Xbd8kCMZJU2zCfA3W2TjK7fweSj5BDWC72aHwgWe3aL3VXTYVgJTyy7MrfRno0I1Ef6
	2IrnTC2Yow8iQO/Q5uO9AtI7dJwoThasVYXkmtt43nNRMJ3LpjmhYhSzBAbdSYnOcTiEVnFdAJW
	xKzA2tZeOv+MrrenoW6DNcF8PwWuL5gxGYy4QPKkwtaic1ak3bdHN7VMsPSxm1i2rpwsB2KRuj8
	H37nFirMBJNRCQp62EEyYRCo9L6kXvw==
X-Google-Smtp-Source: AGHT+IHKh6ktpxlMQlwYYPn8/SjhVvjDHGCITqk1lu1IxhrqGs9p3wGvwUzsqwwdLWZ5q/emhy9XSg==
X-Received: by 2002:a05:6e02:16c6:b0:424:30f:8e93 with SMTP id e9e14a558f8ab-424030f9143mr87767465ab.15.1758047593134;
        Tue, 16 Sep 2025 11:33:13 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-42414a03227sm5526495ab.20.2025.09.16.11.33.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Sep 2025 11:33:12 -0700 (PDT)
Message-ID: <da6a8cb0-d726-48ea-8f10-2e5852e5acd3@kernel.dk>
Date: Tue, 16 Sep 2025 12:33:12 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next] io_uring/query: check for loops in in_query()
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <2a4811de-1e35-428d-8784-a162c0e4ea8f@kernel.dk>
 <a686490e-03f0-4f21-a8d6-47451562682a@gmail.com>
 <6e347e14-9549-4025-bc99-d184f8244446@gmail.com>
 <3acf3cdc-8ace-42e6-a8a8-974442d98092@kernel.dk>
 <437ebe86-3183-470a-b5d3-1d5ff8557e01@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <437ebe86-3183-470a-b5d3-1d5ff8557e01@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/16/25 9:05 AM, Pavel Begunkov wrote:
> I'd rather delay non fatal signals and even more so task work
> processing, it can't ever be reliable in general case otherwise
> and would always need to be executed in a loop. And the execution
> should be brief, likely shorter than non-interruptible sections
> of many syscalls. In this sense capping at 1000 can be a better
> choice.

Let's just cap it at 1000, at least that's a more reasonable number. I
don't think there's a perfect way to solve this problem, outside of
being able to detect loops, but at least 1000 can be documented as the
max limit. Not that anyone would ever get anywhere near that...

> You was pretty convincing insisting that extra waiting on teardown is
> not tolerable. In the same spirit there were discussions on how fast
> you can create rings. I wouldn't care if it's one or two extra
> syscalls, but I reasonably expect that it might grow to low double
> digit queries at some point, and 10-15 syscalls doesn't sound that
> comfortable while that can be easily avoided.

Those are completely different matters. The teardown slowness caused
100-150x slowdowns, doing 10-15 extra syscalls for setup is utter noise
and nobody would ever notice that, let alone complain about it. But I'm
willing to compromise on some sane lower limit, even if I think the
better API is just doing single queries at the time because that is the
sanest API when we don't need to care about squeezing out the last bit
of efficiency.

-- 
Jens Axboe


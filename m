Return-Path: <io-uring+bounces-7097-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 66B5CA6524F
	for <lists+io-uring@lfdr.de>; Mon, 17 Mar 2025 15:07:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E3B73AD392
	for <lists+io-uring@lfdr.de>; Mon, 17 Mar 2025 14:07:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1274A2356D0;
	Mon, 17 Mar 2025 14:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dtWJvc9i"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799A654652
	for <io-uring@vger.kernel.org>; Mon, 17 Mar 2025 14:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742220431; cv=none; b=BMeAFIvib/MPig8BziqMx5DI0kClqQSbG2gxCzmDEWk8q9/a02ONHVIx73hqmArGsVfb7LMKCyud0W5Yccl2WLD5Q3kPuOtTTHKEtkIsq+VNrCY4NunVH93woRHMK99+1aUogF9MIs+ssPfUvS6faE6M3QUEJJ/7DKeu2XkcWZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742220431; c=relaxed/simple;
	bh=mBayp1wEhtDFrnwqoabPiASUIGwQ4CcaXbst1wgjIYk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=F8M4S/Ux7rnnygT7ZDjbNjCf3cLv/8//6jmamfMy+AMkPG6QOK3yy9fRdPpBc+n6YqQAY3jJy6Lnixl9SaHMLlxOJqQuSqbyc0shLZbnF1Vscx6fxWwXziK5Tu6IuENTw6aXORR3VSecjG5qW6+3vEVrubzPokgznSGgleRVd6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dtWJvc9i; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-85b3f92c8dfso141082939f.2
        for <io-uring@vger.kernel.org>; Mon, 17 Mar 2025 07:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742220426; x=1742825226; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rN3hFTHSJ3mkHqLJw3qPuMsDxNdrfgwtwUWPh4W2t0Y=;
        b=dtWJvc9izTchi6NwHeFawZq7dqC+Z1XmmDZk/HfbBj8N/NPMn5ZFLQXO4yt9NrXq4j
         Iqb6Yc3WsQgX6973I/uKA5vTFG1ZFw1TgTQhLsoQoA80D2J3mvjFgHsNrxK3yBoBCuaO
         w0nSHG8rGyRvNXaf1vHfKONUSgvVe9AXd0dnvr/8ZpTThjrS9C7Cyb9TNCDPIxx/8/6H
         Q84O6MJmb+BmiQ7jV0yaAdEissZil7vZpVXzZYW/Mm7ht8OHRgMwg+VDJXhOXmPW//26
         npQd0113x1Pr6HC+mfBbt1J23Q8KilvINgTECJawgVyklx7l/95VjPbQfANXmH5fd+aZ
         qFGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742220426; x=1742825226;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rN3hFTHSJ3mkHqLJw3qPuMsDxNdrfgwtwUWPh4W2t0Y=;
        b=LKgb0XczBCoKnIX64cFksNL0mPs62rcGv9fmXDcwW7fY61YZwZt+QvXszsGEe754Ik
         k6dKmOijDzDqr4VgjuYgY1lVKcRlDr3kTynsNK30N+NnWoY+wQ2ITGY4fQ9mwItesjLF
         Pe80AllMD8Ula7FBCHsFfaPtc0xaImZR5223y4d5PdpzaCHtGTiiqEmgCjDWU5oi5rr2
         MSL7aQroyWl5u0S04c4esKLqPs2hSjxJxw4xLFRsLZtllktoL7nkFuTWbXE3y9TkAHlA
         J9OJmuKb4v1b6LDYSIYqU6D1xJyrIwXljPzNfxI7KPvlMi2EAX+Ltx+1wvOEhSGhySDx
         IryQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2eNQ0fuwhhX0myLhZNOXHqt+MvV0NZHMaOOtvPDP954SC9fZ8vElE9QsbR7WzzfvATRG+bpGrsQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzRG0H6/2EE9nos+JMR5sbO4bv8B3jpCbg4omee+5nmuLugIqzj
	LbxSCkL/m2Azucr3xmX4//4xydh3l9thzbo6c4xMenXCj7e7LxK+PYpSnMd5qg0Zacz/8HzZqp0
	D
X-Gm-Gg: ASbGncu54z0DoWF8qlNp+0e/OKv38h+XVObxSzazmZIr1XJYW5vFfF7/tW+MSisupfn
	Rvj1h2wVpn/XZ8l/KuP0n0AQNdjBbJ95RLK971dGNy4Gty/V2errmLH39hYTBeAZaDSTAiGmG1r
	4eIQtqjV7X402I+eL481Yi7BHPP/sF8GvP2wg30mpVof5kbOGlW1o2J6QjUiSPwF/FYMbUHAjlK
	xffyWFpNZezq6RqMXui/9zSMuzvYgYPuhHgQOAqOMjjC1k9xmbc5oFGzLDDzJGaHLU1ArzbBhWF
	PcSjwPkQouDhMOXKVszQkw+rTcgTBbOh6qgPiEGj
X-Google-Smtp-Source: AGHT+IHgZMnp/Beg1vEEO96Olyb1wS/F8jeS/L7RtArANUb4jcdGjhF+Nv/bBUJYh7Mon8uighCfAg==
X-Received: by 2002:a05:6e02:378f:b0:3d3:dcb8:1bf1 with SMTP id e9e14a558f8ab-3d4839f440dmr151090105ab.3.1742220425423;
        Mon, 17 Mar 2025 07:07:05 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d47a647078sm26983915ab.8.2025.03.17.07.07.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 07:07:04 -0700 (PDT)
Message-ID: <37fcb9fb-a396-477e-9fe5-ab530c5c26b5@kernel.dk>
Date: Mon, 17 Mar 2025 08:07:03 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: enable toggle of iowait usage when waiting
 on CQEs
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <f548f142-d6f3-46d8-9c58-6cf595c968fb@kernel.dk>
 <c8e9602a-a510-4e7a-b4e9-1234e7e17ca9@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c8e9602a-a510-4e7a-b4e9-1234e7e17ca9@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/16/25 12:57 AM, Pavel Begunkov wrote:
> On 3/14/25 18:48, Jens Axboe wrote:
>> By default, io_uring marks a waiting task as being in iowait, if it's
>> sleeping waiting on events and there are pending requests. This isn't
>> necessarily always useful, and may be confusing on non-storage setups
>> where iowait isn't expected. It can also cause extra power usage, by
> 
> I think this passage hints on controlling iowait stats, and in my opinion
> we shouldn't conflate stats and optimisations. Global iowait stats
> is there to stay, but ideally we want to never account io_uring as iowait.
> That's while there were talks about removing optimisation toggle at all
> (and do it as internal cpufreq magic, I suppose).
> 
> How about posing it as an optimisation option only and that iowait stat
> is a side effect that can change. Explicitly spelling that in the commit
> message and in a comment on top of the flag in an attempt to avoid the
> uapi regression trap. We'd also need it in the option's man when it's
> written. And I'd also add "hint" to the flag name, like
> IORING_ENTER_HINT_NO_IOWAIT, as we might need to nop it if anything
> changes on the cpufreq side.

Having potentially the control of both would be useful, the stat
accounting and the cpufreq boosting. I do think the current name is
better, though, the hint doesn't really add anything. I think we'd want
to have it be clear on one controlling accounting only. Maybe adding
both flagts now would be the better choice, except you'd get -EINVAL if
you set IORING_ENTER_IOWAIT_BOOST. And then you'd need two FEAT flags,
which is pretty damn wasteful.

Hmm...

-- 
Jens Axboe


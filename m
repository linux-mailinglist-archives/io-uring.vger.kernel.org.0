Return-Path: <io-uring+bounces-3380-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93CCD98DED3
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 17:23:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 26CC3B22156
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 15:22:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A8561D096E;
	Wed,  2 Oct 2024 15:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="j6YqRXRK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3480748F
	for <io-uring@vger.kernel.org>; Wed,  2 Oct 2024 15:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727882553; cv=none; b=fkAKW3sDG9kZ/wNiFBavDvfUdB3Yh1xwP5isBN9H9/sbs17MxCjSnQOZn6xOHOnW3TCImIttjGZLOnMk5NS0c7B7/ow+mEG61cre78cRS9lH3h5jaRTY1O5xiJmJOBuGjrKP1OXc8GHJyX5xG40dlB7XmTJVmErArmIQ390L62s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727882553; c=relaxed/simple;
	bh=lwp3Tp5n6BdxKk+6MuoALCrdMJyGXC6b2uPxWbLfXv0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DrS/7+wXdiFkHix0WWfF3+Nzvvfieyb9vL4faS9OXqhReKJXdwJBfjqTHoBpYklLqOE6KDteWt9cz+JpxoaI6SeteOepfEPt7WjQIGAAhOG0f1tNav8k7GBUnvLYQbuFaEUm8hMhTYASI4OlruqJXqBKumW0x0KNuGBsIaN9WXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=j6YqRXRK; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3a1a4870713so23930855ab.0
        for <io-uring@vger.kernel.org>; Wed, 02 Oct 2024 08:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727882551; x=1728487351; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XFmPXFxwmqaEH2pONVsLGilCAvF1LQPRHWEwVuuQJ1U=;
        b=j6YqRXRK2dF/kEh4+lygz/VljuH3j1JnFGJgbyzNEKhNdpF44N+OfF0a4KzGWujfeG
         epdw9q4NHXbYtCYFHppvVUtetlRH0Kad9PqoE2Cl+JHUWFqCyLjRG6S/ERvkw6rTJwbU
         BiYLdphuRcV++WjJ9XSE0E0/uL/mHrU5y4fy2e0CO5SGXEzPtds8jHJveOmUbhvHmP+2
         Jj8vY+3qsa1ipLeJQTpY6I2MQveTQEa5BNfgTI9/SxR/M1VXHZjx3TL0yJA+jdS6EJWp
         WuWYsMU8zIQU5CwpPwyFG0t78+9i8Fh2jblgX8LfIEGBLcI8t3ms/5s8qAdrNeSyHzIk
         aRVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727882551; x=1728487351;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XFmPXFxwmqaEH2pONVsLGilCAvF1LQPRHWEwVuuQJ1U=;
        b=nWC74IqVOHY3w6l316xP8zSMPqCgtJ0SHJjih2MeYaboflGDF6+zvySisfDYU4ylCq
         8QVfAPKDabYZdZ5qwjyhRyLxDwfjQbhvwXhSSOFH1yKBhgI0pkaRzAeP2FahDVal+9AU
         sbjEd5MltlBYwijA5FQnjz0pnInH84UdL6S7ILuvNtpExQKGAHREokKYeVleGmNZWFgA
         bstDxjPG7yABDgHmK22p1gI4hAym9YskxFMnIrGj9r1EukTyXp03S2FzOMsfs/hFi6XK
         8nKlcCz75+Eyltx4vG/5rXQdl6jdguas19UHl8kgwzaX4TqNhQs5wqwerKHYQVGhnAv/
         GhWA==
X-Forwarded-Encrypted: i=1; AJvYcCVaba21eBCh4lzxEtlF89FNlEOC7HsrMCfSUF00XKXj0C2ytR+Bat/6Iops9WmdI4m22Zs1c25UCg==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywdpnnq9PkDhIfkO+tyUGJ/Yr/4enh0ztI/3Qmclg6GXVzQ8R79
	ZEMTrT5tU2kij5eIKcWnr45E2PylcFN/QP0NsZDxSyUaWyvD4bNQt3S3WouEMXg=
X-Google-Smtp-Source: AGHT+IEBXbiNHRx4XAwQFwRZqM92YvVanHnKcrNWpONgoVpy541W2Db8S2wG2E4AqcgHPytdS2Swmg==
X-Received: by 2002:a05:6e02:148e:b0:39b:640e:c5e6 with SMTP id e9e14a558f8ab-3a365942ff6mr33405025ab.17.1727882550903;
        Wed, 02 Oct 2024 08:22:30 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a344de21bfsm36751815ab.54.2024.10.02.08.22.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2024 08:22:30 -0700 (PDT)
Message-ID: <865a8947-1267-4df2-a2bd-dfe36c293317@kernel.dk>
Date: Wed, 2 Oct 2024 09:22:29 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
To: Christoph Hellwig <hch@lst.de>
Cc: Kanchan Joshi <joshi.k@samsung.com>, kbusch@kernel.org, hare@suse.de,
 sagi@grimberg.me, martin.petersen@oracle.com, brauner@kernel.org,
 viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org, bcrl@kvack.org,
 dhowells@redhat.com, bvanassche@acm.org, asml.silence@gmail.com,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-block@vger.kernel.org, linux-aio@kvack.org,
 gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com>
 <20240930181305.17286-1-joshi.k@samsung.com> <20241001092047.GA23730@lst.de>
 <99c95f26-d6fb-4354-822d-eac94fdba765@kernel.dk>
 <20241002075140.GB20819@lst.de>
 <f14a246b-10bf-40c1-bf8f-19101194a6dc@kernel.dk>
 <20241002151344.GA20364@lst.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241002151344.GA20364@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/2/24 9:13 AM, Christoph Hellwig wrote:
> On Wed, Oct 02, 2024 at 09:03:22AM -0600, Jens Axboe wrote:
>>> The previous stream separation approach made total sense, but just
>>> needed a fair amount of work.  But it closely matches how things work
>>> at the hardware and file system level, so it was the right approach.
>>
>> What am I missing that makes this effort that different from streams?
>> Both are a lifetime hint.
> 
> A stream has a lot less strings attached.  But hey, don't make me
> argue for streams - you pushed the API in despite reservations back
> then, and we've learned a lot since.

Hah, I remember arguing for it back then! It was just a pain to use, but
thankfully we could kill it when devices didn't materialize with a
quality of implementation that made them useful. And then we just yanked
it. Nothing is forever, and particularly hints is something that can
always be ignored. Same for this.

>>> Suddenly dropping that and ignoring all comments really feels like
>>> someone urgently needs to pull a marketing stunt here.
>>
>> I think someone is just trying to finally get this feature in, so it
>> can get used by customers, after many months of fairly unproductive
>> discussion.
> 
> Well, he finally started on the right approach and gave it up after the
> first round of feedback.  That's just a bit weird.

I'm a big fan of keep-it-simple-stupid, and then you can improve it down
the line. I think the simple approach stands just fine alone.

-- 
Jens Axboe


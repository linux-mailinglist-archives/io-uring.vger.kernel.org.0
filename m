Return-Path: <io-uring+bounces-6585-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3925A3DE15
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 16:17:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7E251732AC
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 15:15:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F3BE1F4735;
	Thu, 20 Feb 2025 15:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ybn03y8W"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E161EEA3B
	for <io-uring@vger.kernel.org>; Thu, 20 Feb 2025 15:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740064522; cv=none; b=lNfLa9czANF3LyH+X0N/tEf+0IbyHs7oRkZLCqdlERkZP30H0lZqXYGzPXY9nm2IqTjvH3dnPLv+rwrkuyJiaq2Xe1gAGdilXtIayzNXCW0x3w7D8Pj2I/g1YxNdzkBeO6FJgX+nLX1vJglIrUsuFLmTcXEk8BJZW7ckDedME+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740064522; c=relaxed/simple;
	bh=2lypZIVM4573Oy9ASIWmYUX19E/cTsKcVfrLLtJ4Yzo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kAHzE5LNz/Ml61IZGWTfM9pQN6bNWPvWpryMNADh2ttWqe2/HTBjyqwy4SeSOZvDAVew4NlJ77VxT4Dx+byPuuP65nzidg0e8CW2anSmWtfHfSXI2A/xNwISgHp8kgqwnnSSeVh2Mgz1vVTiLnqF82s8hGKy8DKpsz+8ShJbvLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ybn03y8W; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-85517db52a2so20917239f.3
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2025 07:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740064518; x=1740669318; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lc0kVOcVBa+1xUpdAG1o0QP4R1TQ3LE6XaKlxbsDJBY=;
        b=Ybn03y8W9RPU5p99kyJxhFSZxUuvtJgOUwdMBdCUgdoelYkpnQUQ549AaKBpOLgNAQ
         odTs0NffCuIT1/QT3pla4wk6eKbS1IUMN7TMvLh0lAeYmVYRWOWINCNk/UoNKQy+gp1d
         yTVCr35Dthvqh0KPESeOXCV53OY2rC5cgSIw0Hlnxz41hcRrnepQ+8hn4Xw+sI7OqdaQ
         kseIRHTE7d4gGadqj8xQEhsTArRwZwQXSb5z9hCv73zgnIbX+HH6cMqDGdBcXHNDHeG+
         zB0tLNu/sPj8D/VdvSHr2aN6HR7vOYNCP2UEYnSdI+zX0FRV8Lo/BXb//Y4DG6j2r/Kz
         gY1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740064518; x=1740669318;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lc0kVOcVBa+1xUpdAG1o0QP4R1TQ3LE6XaKlxbsDJBY=;
        b=k+GyIq/efe0UygNR+q4zhwOb8pZSxH28Z6qg6PyheTwVFRpFIQQlCCegqYYXdgQjpi
         FsEbDONuE5aWUBOl/8vEy+lTrNoq/KcJDa0OdXOVY+dDcR9U3+jd6BOlZi4I+dXETK52
         B9QF0UrQd3hrYDP6IH3f0HQaoizrICxP2fpkpE5w8JFs+MeUpKhlWd0PhNI8tA/xGmQJ
         scr/4ZH707jh/rxSbODlnFj84RR91vvYOvqR1vV7N1y6IbEIRNzajJI1H8DqgpzA9SM8
         jGhYH3e0IEdH6tZAu1oAdEZlc7hTnyAM1HCokA+47t0RMlZrrHUtr+WXdMp0rTjoYUXn
         Mpow==
X-Forwarded-Encrypted: i=1; AJvYcCWlfh/PCeIEchPSbqaQ18ySU0ilztsYaqGp6lsVImr0KjNYFRAKH4stf8BR8rBEA61FLo3jt1ldHg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwoniJGVAyyw9pYxHiKiROHuUXqbow+WVZtjZaetPfhnpwaC9ic
	kQhT7903pKumLe8UjiQDZkjsboQV52T0H8nbVU16Jm7gjAa8mGXMiIqo3tOc6Nw=
X-Gm-Gg: ASbGncunU6olgOo5LM0MfwMV5BDLlC+GbrvMTtwZpNKN8H3lxKQNBhMd9EftsRSe56A
	/PKqvUuNKR7GLWO4iuAbwYaboHdFwFiwQNRSKnsiIqnC/7jIi/DtuBEbaGZrWk4zmRm33geUaIr
	IrkwHDdWuc5qzBUO2Gg/bW2u+TzaQmTpEfuPkrTJ0vNem6EhvYC3F7WEJxCcGvDuTGc0/c1bunj
	QWEQOU9wtPhzCOJSM4IJmN9ED76yOeqACr6Jdr/J55govoh0YtHf1rZpXlMDJ4u/VHW99o/MrrK
	uPFFtfCysQVY
X-Google-Smtp-Source: AGHT+IG5rDxrXr/58y2FFTwSJH1Vf/agd3/d6YIX7/gBYJunps3a/dJzWBXOHv418SAu54/Zhbnqsg==
X-Received: by 2002:a05:6e02:2408:b0:3d0:4e2b:9bbb with SMTP id e9e14a558f8ab-3d2809580eemr247850825ab.21.1740064518236;
        Thu, 20 Feb 2025 07:15:18 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d29a06fb6csm19565835ab.4.2025.02.20.07.15.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2025 07:15:17 -0800 (PST)
Message-ID: <2bbd9c79-27aa-4c28-80b4-29c3280f3d71@kernel.dk>
Date: Thu, 20 Feb 2025 08:15:16 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCHSET v4 0/7] io_uring epoll wait support
To: Christian Brauner <brauner@kernel.org>, io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, asml.silence@gmail.com
References: <20250219172552.1565603-1-axboe@kernel.dk>
 <20250220-aneinander-equipment-8125c16177e4@brauner>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250220-aneinander-equipment-8125c16177e4@brauner>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/20/25 2:21 AM, Christian Brauner wrote:
> On Wed, 19 Feb 2025 10:22:23 -0700, Jens Axboe wrote:
>> One issue people consistently run into when converting legacy epoll
>> event loops with io_uring is that parts of the event loop still needs to
>> use epoll. And since event loops generally need to wait in one spot,
>> they add the io_uring fd to the epoll set and continue to use
>> epoll_wait(2) to wait on events. This is suboptimal on the io_uring
>> front as there's now an active poller on the ring, and it's suboptimal
>> as it doesn't give the application the batch waiting (with fine grained
>> timeouts) that io_uring provides.
>>
>> [...]
> 
> Preparatory patches in vfs-6.15.eventpoll with tag vfs-6.15-rc1.eventpoll.
> Stable now.

Thanks, I'll rebase on your branch.

-- 
Jens Axboe



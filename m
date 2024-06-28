Return-Path: <io-uring+bounces-2386-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 902CA91C76F
	for <lists+io-uring@lfdr.de>; Fri, 28 Jun 2024 22:41:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE61B1C22D86
	for <lists+io-uring@lfdr.de>; Fri, 28 Jun 2024 20:41:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AA2F78286;
	Fri, 28 Jun 2024 20:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="b2zqS4+S"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B5A4D8BC
	for <io-uring@vger.kernel.org>; Fri, 28 Jun 2024 20:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719607265; cv=none; b=D8czTAHavxVIw75PlR5m3f1d4j7+WvwWLXcUMM7U0avWAg/9APODvGELW76rfY1XofVbVQO4bidKUFtL6S8I+YRzAyrlyRk62uC1FhOIpVIAR89XIPwVVU5yPiF/raf2g+cJYdRJ+BpJ1KCMQml2z6iIG8/oCV9RXKc68d3JUqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719607265; c=relaxed/simple;
	bh=fHnQaHhbvVYwukowvzyMTqQ/4nywo2XtLLUCkd1xTGA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=dmlLmcq7KJbbwPDH8yWh6GsKoQtf5HZiuR4Ws/7kqpu/8JKMKtzp4AKovhB+Iy+oJnLRmNohuw6gz5rda0bgDmXFyScqbuWSwMIhkFTTficHvMUCuVZc6aqxgbYGJzHEZoCOdHbHaZTgG/tIbWf3rTESEKUchIdw7kezcNoTi4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=b2zqS4+S; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-254925e6472so107901fac.0
        for <io-uring@vger.kernel.org>; Fri, 28 Jun 2024 13:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1719607263; x=1720212063; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h/rUVUWSsqzH+BwyS/RRWB/P23DUfU4JVXChiPPIMqo=;
        b=b2zqS4+SPROCwQXFh11p5Zjq9c0VrXTMrZ4tHHyd7Qlkyu5GF9c1CQA3u0TJHlyTxb
         X2BtKT0eoxef9CbPRSZzXAHarUDZUF/255gH1nUoxjuezRoSwmj/AoRJ4DAlwgh9+67M
         d02yAlL7r/jgdAYgpM2C6OZc8x7lT7fmwvnghO50E4WO+BL/OqiJIq3rObUHNmX7G4oS
         /zBQ0+gWLZYEkXW0hltHLnNMEWzUs/WdI4gY+eVuxLybmTrzltZi+lqqnXQC1q8IF8/K
         y/P/4dLJyYQfGvNfDjJ33UdkXu7e9E3Pdu/Lub3CkZA3o272LAqOyEytEH1+z2brPmxJ
         lpnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719607263; x=1720212063;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h/rUVUWSsqzH+BwyS/RRWB/P23DUfU4JVXChiPPIMqo=;
        b=iBO8iezPg80k4pURWxtPg4OTDb1CD5pXNi8ku9ocQ2qrdEHa5SxWbGIjWg75Q56euT
         f8Ri4hvw7nFR8p4yabMDnstDdBxD1iscnD/9YLG6HVbEOPs9/Uw9PVTOi1faQ1s8xCTX
         Bz7sV8e/wJQR9ER+3Rlrtepcd64KZ0aa1y4sFaGGnqZxQYoIDkCpfHsvmVwGMnbf6UMC
         g+eHIlfEwq2Z2WYMTNOlb/4H1TH34MF3SFfybhBgeS8W06i/sQ1ZG6kBgsh8VE7zZUWP
         TLe+Ak4BsDUbw9ODSzi9fB3F7BoqZxbCHV4CzTgGE/jmm5OgW5J5bpw72QHTPcb+CQ9f
         Pk7w==
X-Forwarded-Encrypted: i=1; AJvYcCUjx0dL2hrnOLOyd9359CO3sdcNXGSvQ7Iu98T4fl53XrpmO6Ka6sxFMBZi7a9JVyFgs1MOuP/1cazbfCGZTeLTqU31MeywMLo=
X-Gm-Message-State: AOJu0YwzZfLe2Yz9eO8hrxh0NXZLbpimURKjI/XclFvkvhiYhWIe5eR9
	4hqCbyQLS2mw7MW0xWAkJgElGaasHFtgfFqtJZeIwF/l7RRHlmWgeS8pOtaRsRQ=
X-Google-Smtp-Source: AGHT+IHzIw2ax1G02UjYSR0YVWZnApYeGUjzjAj0KGPvETJECW1JgcPGPnjXfe84BRsFEiRcUejzRg==
X-Received: by 2002:a05:6808:1484:b0:3d5:4213:82dd with SMTP id 5614622812f47-3d542139c8fmr21229204b6e.4.1719607262618;
        Fri, 28 Jun 2024 13:41:02 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d62f9e9b20sm427802b6e.25.2024.06.28.13.41.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jun 2024 13:41:01 -0700 (PDT)
Message-ID: <dc126f39-e5a1-4ebe-98ed-ec615f553bb4@kernel.dk>
Date: Fri, 28 Jun 2024 14:41:00 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] Monthly io-uring report (Jun 2024)
To: syzbot <syzbot+list9762eac493f50a993bbb@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <00000000000051e313061bf00dcb@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <00000000000051e313061bf00dcb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/28/24 3:41 AM, syzbot wrote:
> Hello io-uring maintainers/developers,
> 
> This is a 31-day syzbot report for the io-uring subsystem.
> All related reports/information can be found at:
> https://syzkaller.appspot.com/upstream/s/io-uring
> 
> During the period, 3 new issues were detected and 1 were fixed.
> In total, 6 issues are still open and 94 have been fixed so far.
> 
> Some of the still happening issues:
> 
> Ref Crashes Repro Title
> <1> 3582    Yes   general protection fault in try_to_wake_up (2)
>                   https://syzkaller.appspot.com/bug?extid=b4a81dc8727e513f364d
> <2> 16      Yes   KMSAN: uninit-value in io_req_cqe_overflow (3)
>                   https://syzkaller.appspot.com/bug?extid=e6616d0dc8ded5dc56d6
> <3> 2       No    KCSAN: data-race in io_worker_handle_work / io_wq_worker_cancel (3)
>                   https://syzkaller.appspot.com/bug?extid=90b0e38244e035ec327c

None of these should be valid anymore. 1 is ancient, and all the more
recent testing and reports I see of this are not even related to
io_uring, or the original report.

2 should be fixed Linus's tree, and 3 was fixed for 6.11 as it isn't
really important. But my two attempts at getting a re-run of those had a
failure on the syzbot side.

Please close them, thanks.

-- 
Jens Axboe



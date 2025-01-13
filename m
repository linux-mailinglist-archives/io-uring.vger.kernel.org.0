Return-Path: <io-uring+bounces-5843-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 37F62A0BA24
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2025 15:46:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F43018885F1
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2025 14:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35AB41FBBC9;
	Mon, 13 Jan 2025 14:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Bb14Rb/+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E06A1FBBC3
	for <io-uring@vger.kernel.org>; Mon, 13 Jan 2025 14:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736779269; cv=none; b=qFzbPxdEiFanmy/371vZLCuHl74Tl7zBfyWY2Wa7BgOfiZVVKGyClZ6t0LSPotc76oVAFQs36HBgW1njJaJsJdlFpYVYGOKGVZKZHQm7/2WWyHiJHtpfFMFqopXvDdyssjZ+/pbXt/XzcA1KjfUeNpxmujgymhAgKy/k02uqgZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736779269; c=relaxed/simple;
	bh=MkRhU+hEUVNXhSMZtusrZ34UrCVHqaM9agyt3mGSGtk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aAfDPgNjfL6+wHGpD7f4WZFZN8HQEjr/7uhOWvAivZhoIz2LW/+aPX17WuAyLlzXFhdxgp8yGluWQYYahPLO6IHHCubgaUBdHt/vzPIFDUfc02ryIMoCltpUIjc51jbj7RsLtKV6iob5SEjyAvhDHjtPz30w/fZXlRVUXGayp/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Bb14Rb/+; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3ce46520a29so27384335ab.1
        for <io-uring@vger.kernel.org>; Mon, 13 Jan 2025 06:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736779265; x=1737384065; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gSEPsTSDg5NSELpR5L3UvRRfuKV7NotquBWPBaWmNWE=;
        b=Bb14Rb/+0ou6TAC16rVkjljCEm5Z5c5FoLV/X1kyc6hnkSd5ZSHxZGTVkMEMLU3LaQ
         I5pRc+/a5u6gPdyS14wq0N+yPGCLjmP/PKbHURICDVRL7srk/CVEBdXfmXiNENf3ChOL
         fREIxfFPb8bcrxmNMuSVSgomGEU9A05TiROx2wbYw8BJFTwbvv1CM7jcBnooARz+HxBH
         CTvxnoJLoU2JQU/P+fZeMpYNH2AQr5kD6TO3BxPwsTF95kJzuh4VgJXKYyCpi1CPLsBh
         2SqKUKJAKakTHSXYB6pEqwFRRzfyQOfTgdLUNPcjUl7tgLFTjsJCBhHSsC+Gh3fUDo1A
         opFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736779265; x=1737384065;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gSEPsTSDg5NSELpR5L3UvRRfuKV7NotquBWPBaWmNWE=;
        b=S8OQF8mrDt1mcLNcFHsfBvrvFGJt0Tk0oRcmMXyp/JPZ4DJ23e2mtNXvBsmkO8BBvX
         7WZPUK9aP6tn8ym/pzA8O4YDl/TAn8UmUAqB8XpQaEP3TGUfUVsD1KvVDDFusISgNYsZ
         vA0Nn6flLIvzs2lPuyt2OtoM6Ghnc+hBtIga1jvwWDzVQ+wt2bQaFmahpBFcgTpYOFc+
         oFAHEx3MT96deSnB4WUQdEZP1PZDObGFnW68fKs6u4zP5ALf03Vl221n2k47vR84Ui9U
         crFVHU7klWqLDU6dMJ5pDtqormPknIs9N2SLTryYQQjJTSjMmS1xHhDc+2Y071Co0oVB
         abLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVcPF5tzQ38n1Yjmi6eTOO6Yqbz9KSvbDsqTIYZg7Aly/mWscev4vjGNyBZ+Nv/OjzWs4fAjt0jgA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwhJ4EwgLm60fAJAxOaGi2YeRvr5dptCxBg1oLNfXdpo7Vb8p9R
	Z+VBwCYkaZhv69JBIli8Csj7fpTBVpPQvaIQFwlCa/31O3oj4kgeoPa79RUTwEE=
X-Gm-Gg: ASbGncvITOxxlswmL3kioS/fmncaKJuvAnsUxgIk7S3zB7cs5TVOHyq4YonCw23D7v/
	QkcuDIW2N0sOSdkV2sCPsNOwan0h29bJ6jbPwNZ7TGkCU+et5fS96BXxWfeqxvEklv3VBOTukWv
	57G9gOsaTIm91gh/ETAkKMy6aDPxw9f+qMrpUC2NzkRj6w0IKW/TY5QOta5wXh5UgkIT011c9X3
	IXikA/QrZEMVPNZo26kr1zwPeiJ6BROnnukLkIhhepgeL/WvjBL
X-Google-Smtp-Source: AGHT+IEXUe9MaclZbcj9uS5sSg0Caj3AYDWXDGsIxrkXuoYg7sZ9/qAdHOge7AimKL3yPRGgno8kQQ==
X-Received: by 2002:a05:6e02:3d01:b0:3a7:d84c:f2b0 with SMTP id e9e14a558f8ab-3ce3a87d5d7mr189091555ab.8.1736779265728;
        Mon, 13 Jan 2025 06:41:05 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b5f93desm2800687173.14.2025.01.13.06.41.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jan 2025 06:41:05 -0800 (PST)
Message-ID: <657d1713-b4dc-4ecd-be9e-599a1c8e7a09@kernel.dk>
Date: Mon, 13 Jan 2025 07:41:04 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: futex+io_uring: futex_q::task can maybe be dangling (but is not
 actually accessed, so it's fine)
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jann Horn <jannh@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Darren Hart <dvhart@infradead.org>,
 Davidlohr Bueso <dave@stgolabs.net>, =?UTF-8?Q?Andr=C3=A9_Almeida?=
 <andrealmeid@igalia.com>, kernel list <linux-kernel@vger.kernel.org>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring <io-uring@vger.kernel.org>
References: <CAG48ez2HHU+vSCcurs5TsFXiEfUhLSXbEzcugBSTBZgBWkzpuA@mail.gmail.com>
 <3b78348b-a804-4072-b088-9519353edb10@kernel.dk>
 <20250113143832.GH5388@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250113143832.GH5388@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/13/25 7:38 AM, Peter Zijlstra wrote:
> On Fri, Jan 10, 2025 at 08:33:34PM -0700, Jens Axboe wrote:
> 
>> @@ -548,7 +549,7 @@ void __futex_queue(struct futex_q *q, struct futex_hash_bucket *hb)
>>  
>>  	plist_node_init(&q->list, prio);
>>  	plist_add(&q->list, &hb->chain);
>> -	q->task = current;
>> +	q->task = task;
>>  }
>>  
>>  /**
> 
> The alternative is, I suppose, to move the q->task assignment out to
> these two callsites instead. Thomas, any opinions?

That suggestion was posed in my reply as well, but I didn't spend the
time checking if it was safe/feasible. If you/Thomas think it's safe, we
can certainly do that instead. But I'd much rather you make that call
than me :-)

-- 
Jens Axboe


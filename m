Return-Path: <io-uring+bounces-741-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 588E8867A18
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 16:23:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB2AA1F22A9B
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 15:23:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 400E612A172;
	Mon, 26 Feb 2024 15:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ynUf992S"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342B012BEAB
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 15:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708960942; cv=none; b=n0LUPk9R7s6TiUL1o/cghOukjjpl48aFq3g99SkFmJdxw+FHabRJFNm2FI1mn0SlwjYrmtGgj4F8H3xEGxmMWyV0K3oNGNvN1tNBnUoAy1gz4p4v7JNXZIqh+WOUnZgxQZTu69KA5XNptWh1Ynd7qyMEpGKvI+Y8EsE1yvUmUDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708960942; c=relaxed/simple;
	bh=q6PlynHg6KXlg8Ah4Lr07GAHkQaiS8DiJM+WX/SJNw4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pbb+PeddxGBUEgRygIrzS7zvuvKKG5jzQxpSP66mSuCD7d6AjBWz/UvU+yeW8bsvKdJP5tTV0aYXHsmTxim4rOqxs9EGQDpwK+CRdTzj9RFBgjMGjIPOKXF9m4o8wOWMUj6NEBcNMLz4wb+qCmsg8Idm7GOn/sIMvocrgvAGdyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ynUf992S; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7bf3283c18dso58482739f.0
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 07:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708960939; x=1709565739; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ljTo86Ymo5JKK5mbc4NsrjNUZpEb5BRn9kshgphq5bU=;
        b=ynUf992SXH8XtLFGeCf7FQr1U1GOo7ziLA2qHjvLbKqR9YoqkwhKYNTIRX8Z6aD6z7
         iuIzwLDbByNroQjcqwK6kuTh9RQQMZydaPvYxKv3Itvwl81Rxv5E2Puue/xbCJBVgTOC
         0aTkBR/WsdQXCeYlijzTxAIVDlZtjzNTvylo1/m5L+H/9SOIscDCPBAHW01Tq8rdrBSj
         RYZMOwjiIRz4z6PLZtDb3UtQ1fIAC6ur9d1vFR066HY9DIhg9YDrBAKkzL2dqgW6O3fe
         mn1DdY+8hKTHrrFpU59WfXyi2vKxSux1Zu7EMyEy9D12aUbKcZ1vR7UA5MYjUTN6mFNr
         GpLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708960939; x=1709565739;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ljTo86Ymo5JKK5mbc4NsrjNUZpEb5BRn9kshgphq5bU=;
        b=Tm+sMwR0wa913n602II4RxY/J8Sf0UNCPxdfbQh1fsQHDzc2W43Aox4L0Um4Du6mql
         mcm6dlTt6ABDNVdgNEnUjBlbHHu5TJNP/Qvu/OTAMq1gyNk2YlAQN1zXime4gsDNI4ua
         AuApEvvt6qbq6TTfoFjCY4a9yrxmbIXK5cTxBVMMvlgDSZU45v/fB1E4bVld5dGCV+I2
         4AIuRwKdhnARPeheYIrF07AgtnNGVn/dOMvMX0Qf9Y2tycYDxen+cMlJErmm70CT7e8L
         u3EdcM2PO5quxa1As1LjDoJzJrLTQHUpbIKtFZxI9kEyQa/3LtC7N6h2oID6ftOVFjD8
         mb/A==
X-Forwarded-Encrypted: i=1; AJvYcCXt59SuHRQgJNalEbWDvDpTD2OTa5rwXbDPU1OPqmTW0UjJ00y+Cup9RR4MwFOxkCo47fqoIEHHsKN/MMESRXSzaHNwrgfIUsA=
X-Gm-Message-State: AOJu0YzGetNEk29mSqE9zL/ojvbg/Q1mw65XkC4dav16NPD2ApC5X5uC
	hNwB2OG+t7XIpb2xV0crQqYQMJGFDQKTU1HbBaMTPKMFtDqih0gfV85DjDSW3X6YnEUIZODgLQz
	1
X-Google-Smtp-Source: AGHT+IGvaOV9WEYtO/gHY9h5DqJgf6SNWCWiNqE1kTp/vssTONOlp/lZm4xCJpOtxI9R+sZsseOGRA==
X-Received: by 2002:a6b:5d0b:0:b0:7c7:b8fb:8922 with SMTP id r11-20020a6b5d0b000000b007c7b8fb8922mr3863135iob.0.1708960939236;
        Mon, 26 Feb 2024 07:22:19 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id y10-20020a02a38a000000b00474582ec39asm1329416jak.61.2024.02.26.07.22.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 07:22:18 -0800 (PST)
Message-ID: <e24a37e2-1d7c-4514-9708-5fb90a3be9d1@kernel.dk>
Date: Mon, 26 Feb 2024 08:22:18 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/4] io_uring: only account cqring wait time as iowait
 if enabled for a ring
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20240224050735.1759733-1-dw@davidwei.uk>
 <678382b5-0448-4f4d-b7b7-8df7592d77a4@gmail.com>
 <2106a112-35ca-4e02-a501-546f8d734103@davidwei.uk>
 <cf1f03ce-352b-4a61-a595-d595413bc831@kernel.dk>
 <8dc18842-bb1b-4565-ab98-427cbd07542b@gmail.com>
 <a5fc01ba-d023-4f02-acb1-fa1d3cfbff2d@kernel.dk>
 <a19fc5fb-cbb3-4a61-bce2-d6cb52227c19@kernel.dk>
 <c9d444ba-0200-4f9c-a6d9-c6bb0fcd127d@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c9d444ba-0200-4f9c-a6d9-c6bb0fcd127d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/24 7:56 AM, Pavel Begunkov wrote:
> On 2/25/24 21:11, Jens Axboe wrote:
>> On 2/25/24 9:43 AM, Jens Axboe wrote:
>>> If you are motivated, please dig into it. If not, I guess I will take a
>>> look this week.
> 
> I tried to split the atomic as mentioned, but I don't think anybody
> cares, it was 0.1% in perf, so wouldn't even be benchmarkeable,
> and it's iowait only patch anyway. If anything you'd need to read
> two vars every tick now, so nevermind

Agree, I did ponder that too, but seems not worth it at all.

>> The straight forward approach - add a nr_short_wait and ->in_short_wait
>> and ensure that the idle governor factors that in. Not sure how
>> palatable it is, would be nice fold iowait under this, but doesn't
>> really work with how we pass back the previous state.
> 
> It might look nicer if instead adding nr_short_waiters you'd
> do nr_iowait_account for the iowait% and leave nr_iowait
> for cpufreq.
> 
> The block iowaiting / io_schedule / etc. would need to set
> both flags...

That's what I meant with the nesting too, but then we need to return
flags from eg io_schedule_prepare(). Not a big issue as I think that's
the only spot, and we can even just keep the type the same. Callers
should treat it as a cookie/token anyway.

I'll make that change.

-- 
Jens Axboe



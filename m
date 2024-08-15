Return-Path: <io-uring+bounces-2779-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A85989538FA
	for <lists+io-uring@lfdr.de>; Thu, 15 Aug 2024 19:26:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34766282ED7
	for <lists+io-uring@lfdr.de>; Thu, 15 Aug 2024 17:26:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E9E11B3F2F;
	Thu, 15 Aug 2024 17:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cm18WV5K"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FDB1AED29;
	Thu, 15 Aug 2024 17:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723742771; cv=none; b=PQCUQ9PhLo3R/rY7RZtQMObAX7I2YFD9MWz9JIMEPM7Pds7CP4fG3uM11kpcLs1Vi85uworNXiyb6gu/gYs+oKJ0xq2LZGaZP80GAEOKLRRl9/ixULCiBlTsClfEW8wK8Ju39ALqHXtCj7w9F27m/ck+e4+d1hv4wnO9Yj8kc7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723742771; c=relaxed/simple;
	bh=0FgCHGO21g+3JtHhLj+2R1Nkr15raoGVYmzA7zOpTdQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AwYM9TQH3Be+Vp86EKce1D/MgKZQtdnUMcofNRR1I1iwKQC6wKj2lbOV0YlAkt9QSesuBbVSXKcPa3Cpkd+bhKLufGf3ZJ7qvxTobhBZxns57h3pH/lHsa249fNGHFfSPih+O8YAun9TmG2UCiY6IPRo4VyTdxvHsFx2d/9shsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cm18WV5K; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a7d2a9a23d9so148921566b.3;
        Thu, 15 Aug 2024 10:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723742768; x=1724347568; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9m9sXMIDc7Stw58EnRpTLc98lXl6hbDfeMyJIcE5wAI=;
        b=cm18WV5K3eWqJVluU9g4Bau6cuCg9xSeHQ6QASsc2NHq25DLAZ78Lno7A65ediVIV7
         x96Fkg0t+ctUTzdrE5vU9xvNxCfQm+RRjyfWGhECB5G0oBLuW3Qycagxlgj4ZPZVX8L8
         P2soZ9wZ1Fh1NhErxFDNA6OLLcoBuYJ2Yx6NKcNlWLyQyvGqrfLHqoRrpAXGQOoluzn9
         BqiP12TETqrXH2bz65CSXbDBbPcbpdAI5LAto2o/8mwAGdifV2WIEhEoQxyrbSSoQIHc
         Kg8tNk51tAHkndow9fuUSyLo/pi/oTyUN4TMfLZLZBssYkdMwoGZt/oKY+7Sdg8KYEdV
         qRHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723742768; x=1724347568;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9m9sXMIDc7Stw58EnRpTLc98lXl6hbDfeMyJIcE5wAI=;
        b=apif5HmTUnVjl/FBcmc5rbVZc+ZfsVXozbDADgSkr6Fw0aQ40usaN8Oe/umDp8zH3o
         ys3bY2pqOQhmI91pC5ds8PWzXeHp4CgnBYfct+dwJpaqmKGnp/xagJuzGXyIg0/mx2AA
         6qYg+PZNn+28uY/TFhan8mD5y34fPiKeH79ZiAQwq3nzAwZ/2NTS0Qhp0fmVsndHk/6N
         LGd8TEDQ8fNpdvxXZV9FHTz2JhFWD+pYdQ+o3h8YPP8iD5q5x4FjoD+geRdrkbNJtMlq
         p/AvSr25tLDaEDWxDc/U4zwIwZyxCDOlN0jRMY0CpRzwjTU+1crn4B76w5f8yViwfXaV
         qnVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWzkmVH1G6M3kHSObk2B8oDn7zB6lk0CvCvbZuFq39S5Ibzn80+1jqO7YwYt5uxgV8laSiaiz3C8G/bC8kWVX9hgrlI9xm3pq1NPfUoq4TqR9Zl7slGUzDhTPtVbN0866/bDPqtPQ==
X-Gm-Message-State: AOJu0YzJEHgLVHJe0LHZXz/o2zzh5bI0dTIz3mHskOcJOsM67F8Apcrb
	2TnFfCYLddIy/kNaAaZWbqjpvHtfznXcKEkgvJQ3uGUkzwmQs/H3
X-Google-Smtp-Source: AGHT+IFm+n1m+h6LlbNc+d2ECCG6xjbcGgBWu8N5vd6RmausgWlVcEkONrOz7KZFXr+AKcHwHCcGnQ==
X-Received: by 2002:a17:907:948a:b0:a7a:ae85:f253 with SMTP id a640c23a62f3a-a8392a46fdamr17650066b.57.1723742767519;
        Thu, 15 Aug 2024 10:26:07 -0700 (PDT)
Received: from [192.168.42.192] ([85.255.234.87])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a83838d023dsm129627066b.64.2024.08.15.10.26.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2024 10:26:07 -0700 (PDT)
Message-ID: <543700ee-7020-4f99-81d3-9fd7228e508e@gmail.com>
Date: Thu, 15 Aug 2024 18:26:42 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/5] implement asynchronous BLKDISCARD via io_uring
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org,
 linux-mm@kvack.org
References: <cover.1723601133.git.asml.silence@gmail.com>
 <9eac5571-a330-40b1-92ac-c6983be3619c@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9eac5571-a330-40b1-92ac-c6983be3619c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/15/24 16:50, Jens Axboe wrote:
> On 8/14/24 4:45 AM, Pavel Begunkov wrote:
>> There is an interest in having asynchronous block operations like
>> discard. The patch set implements that as io_uring commands, which is
>> an io_uring request type allowing to implement custom file specific
>> operations.
>>
>> First 4 patches are simple preps, and the main part is in Patch 5.
>> Not tested with a real drive yet, hence sending as an RFC.
>>
>> I'm also going to add BLKDISCARDZEROES and BLKSECDISCARD, which should
>> reuse structures and helpers from Patch 5.
>>
>> liburing tests for reference:
>>
>> https://github.com/isilence/liburing.git discard-cmd-test
> 
> FWIW, did a quick patch to wire it up for fio. Using this
> job file:
> 
> [trim]
> filename=/dev/nvme31n1
> ioengine=io_uring
> iodepth=64
> rw=randtrim
> norandommap
> bs=4k
> 
> the stock kernel gets:
> 
>    trim: IOPS=21.6k, BW=84.4MiB/s (88.5MB/s)(847MiB/10036msec); 0 zone resets
> 
> using ~5% CPU, and with the process predictably stuck in D state all of
> the time, waiting on a sync trim.
> 
> With the patches:
> 
>    trim: IOPS=75.8k, BW=296MiB/s (310MB/s)(2653MiB/8961msec); 0 zone resets
> 
> using ~11% CPU.

Thanks for giving it a run. Can be further improved for particular use cases,
e.g. by adding a vectored version as an additional feature, i.e. multiple
discard ranges per request, and something like retry of short IO, but for
that we'd want getting -EAGAIN directly from submit_bio unlike failing via
the callback.


> Didn't verify actual functionality, but did check trims are going up and
> down. Drive used is:
> 
> Dell NVMe PM1743 RI E3.S 7.68TB
> 
> Outside of async trim being useful for actual workloads rather than the
> sync trim we have now, it'll also help characterizing real world mixed
> workloads that have trims with reads/writes.

-- 
Pavel Begunkov


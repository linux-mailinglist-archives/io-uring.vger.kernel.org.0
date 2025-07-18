Return-Path: <io-uring+bounces-8723-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 93FF4B0AB55
	for <lists+io-uring@lfdr.de>; Fri, 18 Jul 2025 23:18:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3227E1C81BF0
	for <lists+io-uring@lfdr.de>; Fri, 18 Jul 2025 21:18:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 014AD15E5BB;
	Fri, 18 Jul 2025 21:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kvuXKqDh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C46DC2C9
	for <io-uring@vger.kernel.org>; Fri, 18 Jul 2025 21:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752873500; cv=none; b=MrnOmILH9FBxaUpmYEIigWMiMJbpwBwULbwoR4aDsP6uy+/xnIWPtGgTOTKcSOtmiL4KueP5U++RNRfXfj4g0u7sPbDESw6alz4HIa0qfO7jJsrhyKbTQ0nisVNIsBgn6Iisp1hH6ji8VwkF4zZQ3CGPQTmhy5uFcTaWNXscWcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752873500; c=relaxed/simple;
	bh=WE2CVxtUBRNLCiFRpCKdsXPdFVbKPRiJwy+mC/rA9EQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BSjm18NA2qRyotCDz2yvqidKNl5YICKm+t4I9EPdZXDyheFDFz+SMu24y4DtZPMk38PwLVQ4PFU7iBRNXobUlpfnGIqv9y2acATQ6RTce/45Z6dKmz7SD78GVGAOOjiYNLg5FituXB4oXFq3KVJuPZvFr5ar28xzWDL1LU/L1S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kvuXKqDh; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-739b3fe7ce8so2509399b3a.0
        for <io-uring@vger.kernel.org>; Fri, 18 Jul 2025 14:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752873496; x=1753478296; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+O7xDXMkXpRjUVGwmOCjVr7IAwe2z5FHekjZkrl6LTw=;
        b=kvuXKqDh0wVHZwKP7+Irrbuwid7q8LF+4kdDGyK9zuh/V4AxSVMHdcuXjcLtIXOw84
         ItLnaQEh7QKWBY2inWrC8uFd5tsgDSMB1aU+vEyro+Fz6snzd8siahr8JtfhHooyCDa1
         uA8kd2K7TKLP1IEQYQyewt17c/LqQgfzsE0jWw/nrXv1Ojp4pDFa4LLI8jG8UmTxvKe8
         HGJZ2GTjDTDqkAMWvfL+1wXn09ez7rBxarbOw0JM3Np/1pogmU9eBSStGSGtY6tKiX0b
         onRcJ50AWJ9e2zpfklwrH9t2cZ+eTr2B/k0Vg0fivT0ui291CbeWGijCH45OtO5rj8Fj
         kbfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752873496; x=1753478296;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+O7xDXMkXpRjUVGwmOCjVr7IAwe2z5FHekjZkrl6LTw=;
        b=WZog9S+HbQPJMrhPdwjx+1ybuCGPJoxu/i7C3XrtSGoRv22YngoLTR1fBIatRIHV8l
         sKQX9ev9+aIZ4MbLFe9pMjiH9uc7i+i2ubbmROELnyH+3K+GsZS8+6GcKglQz0DwmweW
         GK+d+5CQsM/Hs26Brj7WSnBH4GH4RQYuSnLxiG18iVqdAbM/phJcSKBiETTt0EtDSORX
         u4J+5OnkfXfW8JonzmmDpOGPBbMJwHIzxAvg3Wiu0PL8+sk+xIJrtLPWouU4dBvlKURi
         5mIuRwQaf9ne0kTvh2rb5hHaqN2U4tZ7xNXOTbb6sRU4wTeSnDA+y7ZkbjvidzW7e6jz
         YagQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNzzd5vriP1X/Rp6/Vdewj6VOAqj8AhIe6qQjEY8elW9Tm3qOszOqKI3TyEfUuuOLCefAAgNX5dg==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywd/6941Dhkk6zYoJC1M3LuAvVic65zbk51zMNnz1dJQCbmT/W0
	L8ysh3vRbHu7P+YF/xqK0JTm7fnZlE5pSe7hi/NJR8NsZdOQDgdFx+x+sdFtxWUh399oWXUMT6+
	UtAfG
X-Gm-Gg: ASbGncs9u70vMFwrXGFh8tOZp6MWS8CIZ03/GP0NBM9CmkkAV3xDzZxEILJ3bpUzFFP
	wfk9zYfxnTxQESCQf5koe0k1trTR9SBuCXbBo9zo2SOh17txVS3syBIRw/mDraEt5JzxNQ/jkdb
	lZgWZwRRf4e+v1cxxu8SHeyTcevjPnz8EUg6TzhLCFetJ+CfW3g8/4Rn8M1o8n+0lsmO7+WJwUb
	8Hxur6Vu+38RcW15zXRl8y0vMB1QhXgg+ijoYtaubMAmc+aA55SoA97h4owcp7oU6gwEOXDT6z2
	o/zR6Ln6GVzMdpgB1jcohJVOAwv6U2Eg1VaaqJeYWvMRp9YiQot0Js9id6qRdbzWLU7mSasO54c
	y6aVsg4cGIc7GDVgIuiqIFR7vEeL5z9Msi3/UQ4jYE7mbmQLd3EiGiMZK
X-Google-Smtp-Source: AGHT+IGv1u7fG7KTjArqOpgT6gfLDtN3m1H8qBRET8CREb2Sz+YkZVSAb+3rhqzufkzu03nZs9Vcrg==
X-Received: by 2002:a17:903:3b8b:b0:234:d679:72e3 with SMTP id d9443c01a7336-23e24f59dbfmr166366125ad.42.1752873495835;
        Fri, 18 Jul 2025 14:18:15 -0700 (PDT)
Received: from [172.20.8.9] (syn-071-095-160-189.biz.spectrum.com. [71.95.160.189])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23e3b6cfbaesm17998295ad.151.2025.07.18.14.18.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jul 2025 14:18:15 -0700 (PDT)
Message-ID: <430975c6-6814-4683-b4f1-c05695c1e551@kernel.dk>
Date: Fri, 18 Jul 2025 15:18:14 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] account zcrx area pinned memory
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: dw@davidwei.uk
References: <cover.1752865051.git.asml.silence@gmail.com>
 <ed4fcb1c-795c-4af2-bb47-7c6bd5c438cf@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ed4fcb1c-795c-4af2-bb47-7c6bd5c438cf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/18/25 1:01 PM, Pavel Begunkov wrote:
> On 7/18/25 19:59, Pavel Begunkov wrote:
>> Honour RLIMIT_MEMLOCK while pinning zcrx areas.
> 
> It appeared cleaner resending the whole thing. Let me know
> if a fixup patch is preferable.

Fixup would be better in this case, as there's already other
patches on top at this point.

-- 
Jens Axboe



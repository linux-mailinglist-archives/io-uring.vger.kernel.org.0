Return-Path: <io-uring+bounces-7600-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 50218A9555A
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 19:38:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3ADC73B3469
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 17:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E6271A23A1;
	Mon, 21 Apr 2025 17:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="LmV/5xSD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C922C1DFFD
	for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 17:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745257112; cv=none; b=XJl/4lsQio0dTMK4ZBZuFMJtIhJr8g216/v3tcJGJa24RYBQvDbTD/tecO/mrRnX9Av6GZZQjNngo2zrMfAAvtHvVbUVkZHFbdCa/ZpVZ3uXUKLDiSe2scZi5OMH8joSd+stQ+OZvXFEHF3vz7l1Ub+vIHMfu72spYa29mcU4mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745257112; c=relaxed/simple;
	bh=hetrBE0XMRI/ejSuAGA8dfMhyL3cE7RdUOnctnqD6lw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pQdvfcgf+OO1D8QLjQqoGtIhBpTRxYAbsIDqTUcieZ+7irkQn5R7R/Qjhno2/p96tVDEYBUrHwW9bpOuPMIZgfNcLjRkm+xgri7+jNlFiWd7Qt4e4YowDlH0r9+Qg40W0iX59qrLS/29j1lDcnaxpB9J5o1gVx4WePjZbZtj4yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=LmV/5xSD; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-736b350a22cso3404984b3a.1
        for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 10:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1745257110; x=1745861910; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eDfOTbeexJnkE5sAYh55Xe+pgtYFXT3HLU1AHnsFBw0=;
        b=LmV/5xSDx7GWcYYB8Kupln3wlQ/k8z2pWUhMhtuL6pW10bAu0PQmKpkZKoLy+k+Vjd
         Lr+kpXdMHFig26HiuYtMb/38P4RCfv6yq3fbtqCbXH8/42QDb7W1kH0P1XjDGWmDVRbu
         YLHL6acG7f0tnOIU6PNOL9P8Yjjr1Un3RrtvBkvAMvw8zV307K58bX7b7X8Gu91C0Tb0
         F0kenvpcc0ZnAOUtbU2SCK/ED1oQ+RBO8SuO2wtDxJsdPpHhvEmkbN1kg5qMolDxX6/x
         y0vMjvbiyQQv35olMwmUdOOr7ffbXuo0QTNSawnC7FmESxwstXB/I3/NtLuej5ZR3J3/
         iDYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745257110; x=1745861910;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eDfOTbeexJnkE5sAYh55Xe+pgtYFXT3HLU1AHnsFBw0=;
        b=vjAog0ri6ctdF3DmM7aRaQopR7B4IObSIajW58QvlZdogXwI3b3oFELCvci47uVXU/
         7TSduq4TFk3zFDZnPT62OkT11eCL9WTWf7Y8oGqz4u2Zxp79g+8+td3zPIikC32ufSr6
         hoGcwRuYH6fa1uw54YZTMhwXnfQt4EL/UVEkgfmM7xd+KTNkQ247g0uhtX6tXjxivzJH
         uemzO9IVtgX8XvS2EZEIW24pV7bE8U2sO/ZgSbICMwPKain1HNKJoJ1xyxbJ6gHleiMf
         sQinvliaemMVMPbEiFT6ABYWnZ3PmIWEUmvDEXa8UKvkzBQ3RxlOdCc3OC5/201wVufN
         vuoQ==
X-Forwarded-Encrypted: i=1; AJvYcCX7A9DuEuCNtNAv3zUp9GdJZjTcOb0otYE3Pgphs/ZkIu2YkXHfpmfh9EuvtrxAhakt/6+0guUFZA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx08S9bzl+SnQLuBrOaStGUYL64cvtrxsRSa/zsjUPw99rl/W66
	/hDYUGlsxilOuXLptriHuwFjqGNyvyk4rZ1ixQKaTrHZ3OBMIePJEDL+vosLSEg=
X-Gm-Gg: ASbGnctOFrq8fExC3REi1w/XIY+OWEJlGIK7wmx0fMTqghDKmltDIKerSs7zPRJv7zi
	XsbrsIpVEK5/5m3LMEzMmWrVZ5rOHN8v23NtbYKbywNR5jfVQi12INpvX2GGQRNXVHVeSf7VPvq
	iXlGmvO0rkbcbiSWYiQA9oU7qsKAjPd5DqmNZQbB3VWq6VygzoF8ebp/JHiiaz0ZGwCExOBrktz
	YIA9unXlbFddjibkAX1TcMK1vVj6Kjy2Ge0gsc36A3d+8UgltQSdF6VZJJ0gIfHmwbLHNm7NMVx
	kWE/xlCBjxAAo/2Iu1DePIC7sZRkjrftiLrjH5U9amL7SXUJQ5ZgwhX35fkoV4r54NZ2FGKEZuz
	5b1g=
X-Google-Smtp-Source: AGHT+IFkXcylapXkQ5XIOQ2R6oOl/z4AAzkZT/512tZvQG5VPsOasfFpqlwakxOGKPSojI+YeV0iZw==
X-Received: by 2002:a05:6a00:4608:b0:730:4c55:4fdf with SMTP id d2e1a72fcca58-73dc14a8851mr17491243b3a.7.1745257109893;
        Mon, 21 Apr 2025 10:38:29 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1156:1:1cf1:8569:9916:d71f? ([2620:10d:c090:500::7:efc4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73dbf8e135csm6834482b3a.44.2025.04.21.10.38.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Apr 2025 10:38:29 -0700 (PDT)
Message-ID: <eb4d1e04-b330-45e7-870b-fa254632519d@davidwei.uk>
Date: Mon, 21 Apr 2025 10:38:27 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 1/3] examples: remove zcrx size limiting
Content-Language: en-GB
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1745146129.git.asml.silence@gmail.com>
 <64f4734fbd7722e87a21959ac668b066bd984717.1745146129.git.asml.silence@gmail.com>
 <5a6b754c-d511-42ce-a9db-5aa9ae222599@davidwei.uk>
 <a5ad67ad-f5ca-49fd-9bcc-53277394fac1@gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <a5ad67ad-f5ca-49fd-9bcc-53277394fac1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-04-20 23:40, Pavel Begunkov wrote:
> On 4/21/25 01:22, David Wei wrote:
>> On 2025-04-20 04:24, Pavel Begunkov wrote:
>>> It's not handled too well and is not great at show casing the feature,
>>> remove it for now, we may add it back later in a different form.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>   examples/zcrx.c | 34 ++++------------------------------
>>>   1 file changed, 4 insertions(+), 30 deletions(-)
>>>
>>
>> I'm relying on this selftest. Can the deletion wait until the
>> replacement is ready?
> 
> I assumed you're using the selftest, and not this liburing/examples/*
> 
> Anyway, let's see what I can do with it
> 

Oh my mistake :facepalm: I got this mixed up with the selfteset.


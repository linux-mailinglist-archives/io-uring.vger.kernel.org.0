Return-Path: <io-uring+bounces-7714-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFBA1A9B5FA
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 20:10:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 088DB4A7C90
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 18:10:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 386A828EA4B;
	Thu, 24 Apr 2025 18:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="bKZu2i/+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB46728E614
	for <io-uring@vger.kernel.org>; Thu, 24 Apr 2025 18:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745518205; cv=none; b=X/t9IQ8f4lNcvkSpEYoiRpJwfXnL/ZdzIJXulwS7Pr4Qd9uivjSiM64+zRTVREakrs0xdbG6bSgQActStsp2vYWlSN6uJorz3+m/4UcBZ/ooHEtGBbqmA0cKWnIMmUSDdNvBxpciy/FZYnNQV1s5G8JYLzgjPa9QOMJ7+xdcD8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745518205; c=relaxed/simple;
	bh=Wr8Howp6YUBHFQ5IXcbrHAh69nUeNbi1WwiX/cJv9UA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pw7hawetXGPJZdQq77zn54XKmkNEDlZWWC1PKPy8CIiAzRxaKo6SZAEdl2Dz1tgmfIgSEGs+pB4SowNGBFIRQKF6HvR9PiGub+PfHj4et2276omcdY15j+qbceVDdytg9/oLo0GcW9ey2V/8o3x3fWVwHfKAdZQpv79899eGbNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=bKZu2i/+; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2295d78b45cso21556545ad.0
        for <io-uring@vger.kernel.org>; Thu, 24 Apr 2025 11:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1745518203; x=1746123003; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+UKNt0lCLDr2VLT9kOvLTb2AuOQOpzIZeg4tCrvuwj0=;
        b=bKZu2i/+MrIu2KWaD9cKAvnwOtvxeCXthuKHF+RSMnLrA28adNRkceF7FVKDQdVdOb
         Nvq6c/Jj8r4Z19qC5Pwd3i793T8SUDrsgwkz5e/def9SNCHPVg8SYZ/nlELW5/MxEspu
         3fkd6+cWdFheKMYW0CgmG5pGFUhTOq8OacB+G/Fubs4yQGoQoLNEiYqTUzGTeokFEQd5
         o/G3Qe0xBpy2OFfQtwTjMjZfVpJgERu7ftw5jiMl+1hFlOiK+BFkFdUYxKr+kHfXTMN9
         aP9osERILIZ6wsDW+OtIUr30RDevAJkzjjvHS0+p9M9XRYNWLF4ncQkUdhN2Pc/3Bius
         9adQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745518203; x=1746123003;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+UKNt0lCLDr2VLT9kOvLTb2AuOQOpzIZeg4tCrvuwj0=;
        b=MHfrX99qKoe6AGqY7f3UjJsMg09apcH2SgITPk7Lhu9dGe1Daq8Iqyt4KuHRB9L+Ug
         DMdM7Ts87hMJz7aGxCC+5KingCEJpXhEszH4w+hPggd+VirVghRjOgSenImGVqZl6bJ9
         sp5XKIP4z8S8kCwdUd3r1Ymj2KJg3KIVAdSXqGg+DdxEHfdCe8+XJ4056b85jj22yoJI
         9lvxmHcZEPG/vGkfwc24x3rzpGtrdjFHm28WFznstf2O9aDioqwcJBwMz8quV+f+/BMx
         cb+Ub0ijWVUqw+xvBQAgVzJcsQEZxkACUP0Fk21GlKBzRsDG/lA4n/eJr7agJNKtNkHz
         Iw5A==
X-Gm-Message-State: AOJu0YzEDkNDkv90hiKnvh7iIgyfk50tN/gYzs9ULcJk6KctsPBJkocf
	yDx5DbMAkmMW6L28XUvBmONHxdhIBJiY6NaefxYzth0RoPK8Xc7dn2frgoj/A0k=
X-Gm-Gg: ASbGncuZht9fmLygjDhBMqTN1s8S3CtOHIOpaqxaliz/aePv8KaL/Wd7hAnZn6Imqet
	qheWfiIcx6WMC3DcAj/yhQmcsvMIyK5RyfcizquaUqH+QBTTy3X2ZiQL1VJL98g3+wfdcvmLHzE
	KCh6jvMbDSNdO4UMub523pe5cVwPb5Xp3C/YIDJ7zwO60wspyGUrGgQCLcnwr5OrKzyntI+Bhf2
	u+l1zXL7FW2FEfbl55fo0S6If4T5+xCGgaqEVm6QU1zGdsN169EaZHkhpG8HZOf2QaYTTwdpLQM
	2TgZF5QpZt3yrO6oYPnZ9rv/AUQfUTwJF4mZXn+338Cs6TCfbsKWsoy8Se8yN/oj6TrPVmuRDP5
	5XED/bUVi7ZfipevVHgA=
X-Google-Smtp-Source: AGHT+IHnCaTt/PjXgficrL39pGhcE2L6yyJvkQieKK32vsywiH1L2LBk23RuW6NeWGc4L/G8Ur3ipA==
X-Received: by 2002:a17:902:d50e:b0:22c:33b2:e420 with SMTP id d9443c01a7336-22dbd401ed7mr5490555ad.7.1745518202886;
        Thu, 24 Apr 2025 11:10:02 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1156:1:1cf1:8569:9916:d71f? ([2620:10d:c090:500::6:c802])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db50e751dsm16782485ad.142.2025.04.24.11.10.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Apr 2025 11:10:02 -0700 (PDT)
Message-ID: <6d9d6ad1-71cc-47f2-b7a8-d61f5ecdfa55@davidwei.uk>
Date: Thu, 24 Apr 2025 11:09:59 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] selftests: iou-zcrx: Get the page size at runtime
To: Simon Horman <horms@kernel.org>, Haiyue Wang <haiyuewa@163.com>
Cc: io-uring@vger.kernel.org, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
 "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20250419141044.10304-1-haiyuewa@163.com>
 <20250424135559.GG3042781@horms.kernel.org>
Content-Language: en-GB
From: David Wei <dw@davidwei.uk>
In-Reply-To: <20250424135559.GG3042781@horms.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-04-24 06:55, Simon Horman wrote:
> On Sat, Apr 19, 2025 at 10:10:15PM +0800, Haiyue Wang wrote:
>> Use the API `sysconf()` to query page size at runtime, instead of using
>> hard code number 4096.
>>
>> And use `posix_memalign` to allocate the page size aligned momory.
>>
>> Signed-off-by: Haiyue Wang <haiyuewa@163.com>
> 
> Reviewed-by: Simon Horman <horms@kernel.org>
> 

Thanks Simon. I'll apply the patch and run the selftest to make sure it
still works.


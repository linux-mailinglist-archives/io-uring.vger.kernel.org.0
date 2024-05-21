Return-Path: <io-uring+bounces-1944-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E8638CB3FE
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 21:05:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CAD47B242ED
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 19:05:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99361142916;
	Tue, 21 May 2024 19:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vv47NXS9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56AE7147C9F
	for <io-uring@vger.kernel.org>; Tue, 21 May 2024 19:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716318314; cv=none; b=s/Oy5fthtELfa0lrCJyS00wN8f7B+rzd5LMJ3p3FrILtNk/01lmgbrbhw1ofqoJXSP/fHiTpABt4+SZ7XI/apwSjqnBIyTKWYU5ihZTh+rZ57q9NPSn3iD5KEMHTQ/mDzioNISc+slAbPlo0KiMC0NqtdP4p41rnYAP9Bf/qMCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716318314; c=relaxed/simple;
	bh=9ig+Kyi/baZpS+645Jg/adbwo2c9nTOBE6Yno5YS9f0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=BtB6xBuZ9z1eJM6ZD4w4hubvo+UotvyBDlq7GSKvMnm+Y1IWhtcRa3+uvbkvk3cw70s5Blg+CP1tqK2tSdSyrYDOU5hsVSq1taf3uSuKhsIWL1XYGNhP3xHsinl604gVpZVzc2PUqkmebHIZyQJv3Hf3tjzE+W1plVIR+g4h+/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vv47NXS9; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3711744c61cso631965ab.1
        for <io-uring@vger.kernel.org>; Tue, 21 May 2024 12:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716318311; x=1716923111; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nRu+e+4ihYIHhqnVRJg1n8yw7RtfPjEVL53AovtGebw=;
        b=vv47NXS9WEtLOsdWpZWJWfwx+BJCB04uie/os0Q8DBoqKC21uKB4AiyqrLWj35QdT+
         iq8X+/hbJYaQp7gcn5AfB/U6fcEeIU1wJUV0kGgohk/AIVseLu0sAcTPO/s6A/WWVxyJ
         SDHte6zV2Qx3j/+ZudezuE4VBSejEACA49RuPm+DgO5ZaMQsCa0tOB8PSH50WPYQRR60
         sqZqCwrd8UgGFqJWayiY8QVPaji/Em2MwKHDmzEKJj083DdeDJQ9F+Wbncv5eDflKBYi
         piIRG8exJ04sSWKO5xxNoMX5x3ByFenw7bHrSeRa36+5WlH1m4YJd1VfgnOXLQ74fGfF
         C0IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716318311; x=1716923111;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nRu+e+4ihYIHhqnVRJg1n8yw7RtfPjEVL53AovtGebw=;
        b=tHwneuMxnNL/ngYcQCnL7+z/5A7WM+OKcosM80yI7nJA9rcRRNSArmQpLwLDR3iTJQ
         CegaRvZkGE0dlClmC2JLaTG4eBzL3s002ADt0Z+Diaju9pQeTFnRClLiSm6lhQwoxnhJ
         2eec0ZYmt3TBEdVMLwZwn8l+CfI5lFbet8jE5RjSCL1FjUHF8/Oazo/gtzGjo1ECN5Zb
         W9uQ/4ag6muL+bpy2AqT/p2Rl4vSyqLX5W+BNRjqivCR3NVCjxhZWcYs1St8fUkqNNrw
         SO6HfbbzOh/7aQ6hZxngr6Yxl0osd7RgL0ZJ8qY0BJp1VuRK7eq5vU8aBITivGgm0wi6
         Hqkg==
X-Forwarded-Encrypted: i=1; AJvYcCXFUh7z43fE+/vv5tI3V8IygWzCt9uMCM0Vrlwr0DU7xzmw+cquU+a1z6V9XUu9gt9YX0oqjvsjYd7Q2UbobpOqxCoQusSHyPc=
X-Gm-Message-State: AOJu0YxpveQ9IVIn5zEttF+qZKq8WteEzQYEjTgkKFAUOJxwZy5qvAgH
	0PPw0zcfeH9m8M6bt2b2068d2G45cgpRjdOILRUGFI7o/Q2AKCxOJ+KSjK+xsiE=
X-Google-Smtp-Source: AGHT+IE85FfzZm1BhB04tBLgcH/K0Mtaq5JAegY01Fm5dtbDRyiqHop3XkES1ZT1sB5tYMocE/6/og==
X-Received: by 2002:a92:c988:0:b0:36c:c86b:9181 with SMTP id e9e14a558f8ab-36cc86b9470mr310516235ab.0.1716318311506;
        Tue, 21 May 2024 12:05:11 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-36db97b8f1bsm37349525ab.73.2024.05.21.12.05.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 May 2024 12:05:10 -0700 (PDT)
Message-ID: <d4cadead-369d-4d94-ac85-58034d75c6c7@kernel.dk>
Date: Tue, 21 May 2024 13:05:08 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] ETXTBSY when running Yarn (Node) since af5d68f
From: Jens Axboe <axboe@kernel.dk>
To: Christian Heusel <christian@heusel.eu>
Cc: Andrew Udvare <audvare@gmail.com>, regressions@lists.linux.dev,
 io-uring <io-uring@vger.kernel.org>
References: <313824bc-799d-414f-96b7-e6de57c7e21d@gmail.com>
 <8979ae0b-c443-4b45-8210-6394471dddd1@kernel.dk>
 <8de221f7-fe5a-4da9-899e-de2a856a4ddc@kernel.dk>
 <yywbp7fjnwgqxvc66zimea4hgdc2eysjx5nezky3vndr7xw25l@jv76rdseqm3e>
 <b8018270-6e9a-4888-87fd-69620d62c4e5@kernel.dk>
 <0ec1d936-ee3f-4df2-84df-51c15830091b@kernel.dk>
Content-Language: en-US
In-Reply-To: <0ec1d936-ee3f-4df2-84df-51c15830091b@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/21/24 12:29 PM, Jens Axboe wrote:
> On 5/21/24 12:25 PM, Jens Axboe wrote:
>> Outside of that, only other thing I can think of is that the final
>> close would be punted to task_work by fput(), which means there's also
>> a dependency on the task having run its kernel task_work before it's
>> fully closed.
> 
> Yep I think that's it, the below should fix it.

Sent it out and also wrote a test case to catch this:

https://git.kernel.dk/cgit/liburing/commit/?id=06c22ef6637284ab1f31ee64f1ee48a829958816

just in case we ever regress in that manner again.

This will go into the 6.10-rc1 release, will ship it to Linus in a day or
two. And then it'll land in the next stable release of 6.9 as well.

Thanks for the report!

-- 
Jens Axboe




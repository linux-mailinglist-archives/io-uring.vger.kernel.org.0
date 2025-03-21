Return-Path: <io-uring+bounces-7163-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62BFEA6BE08
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 16:14:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DEB7F3A84BD
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 15:13:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4AEE1388;
	Fri, 21 Mar 2025 15:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="haUMiZc5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E098A1991CD
	for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 15:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742570039; cv=none; b=WElTB0vAkSIIovOEfvED0XMHIYjABGZKmlNwqrhlIzY9M4HHdRZWDEdGBvbJ8usaolSTBP1245mMzQLXQvXvMJcEbR1N8s2LlVHJW6A8oIvDshjKtsfdYofAf9B8zVtJ+DnpLXa96XtdyW9GB1fGVxIrqT1Qc2FH4ep/vuKPChM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742570039; c=relaxed/simple;
	bh=LdbmPThymWRKSsWY4SsjlWZBhIU45NRyItz6cL+Ooug=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iuOm+T09kTIVObydfqf4AVLwy9XSrGlt2LhZZi/kSghk63bjCUhlfOtyaQjMoLsC00SHH6iNN0VZCej2cAYCZid8rf6ML7pw+QVgh7qlVpe1560Xop95Fu+Z6e9yZWF1vvSb3nWvzk9XYNGa5RY8Zcg1vO3l0NMw82cJNDT+LKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=haUMiZc5; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-85517db52a2so32755139f.3
        for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 08:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742570036; x=1743174836; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PKnSzy24Atn3o3wp3W8Zk7HkRzCeJGCSXH1WiFUigJM=;
        b=haUMiZc5LQic2J3pNXycsAFMW4y3lqFyfchS3/bX9D5MPVNxnrBE2U0nv0TH+UGena
         ydNsuDwChkrLRtIEXwdlF87Cb0o+ZDFeift/jfxRUnrPWTgv6+P7OkEdCz55Ynjq2DXj
         3sZ36ABX1ADEVKcvyZJ5gM+G3N9dcv05XqMayiw8cfgSz0yCCAILyH+140oafhDh4ELu
         Er1FHQAc6qvS34iv4maD6dFo3zIAmkrZUWVx9gkTZGxCUn+KARDOXQRnQ1o/aQC5pdQS
         0twURCyWQx6UZJETJAZ9Yas7AOZrcKfx/OYgAdYixA4LlhAA1SJe5UkG4LkhJ2Ozxwa/
         veVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742570036; x=1743174836;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PKnSzy24Atn3o3wp3W8Zk7HkRzCeJGCSXH1WiFUigJM=;
        b=ThOXdJaiBxpwFch18vaW9nlFTQaxGrliqD+IW5kW7V2eO5MarpSOzNXVf83bGQlSOx
         yixmkLiPYcIPROYGj++YO/XheqMTXw24n/WPAdQzvorkbNpy8oyXrM+ZQVLkQimBgGum
         9och9h0nXsCMpeTvJ4Q99HdGqOSRs9/WDXBy0umNcbCchPpViMsc+syJIG75ZS+6IlrJ
         gk4OaD83jwUn8BBgnmeeFoXGw+2SG5xB0TlucEAhombYrfIHHps0EE6JOiPX9WRVTV/a
         46RJAnkcU42Tw1deBJ7QrKQP4HYI4sOzSI4FQlx3nGv+Ikvrm/j6dUsBEUye4G2Fm0/M
         wwYg==
X-Forwarded-Encrypted: i=1; AJvYcCXVp0JpSOoM1GP+s8U0XklQpufc0VbQmpHcwvxJvYPdOZ9KCxLQUnTOtgKVqVrTN/7W6oeaHJliEw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxhu3OYQ2pyNdNJmqHp9KBSZcWjyIGQnbkDn4yNqZ30Hp5kKZl8
	ebM4q897DV6NSkh7C27OemjG72NyJoOHp8lfGfZegApSdcOLXXx2Rx4MELwFD88=
X-Gm-Gg: ASbGnct7Sd5WUCBcgcocFYcfyFyNN8tdv935rSAXPdJv6kZZjf0Db97mtOwj6s5nQLf
	FtqQthovqYs8vKWXTOiN5LjCeLlxPrl8RWZOxIugcdhzJ1kzOgUuG8tOnwPL2xYl8ThtOK/FRbc
	x+wCrQdCRoYxIx0YB8acu+gMO84eJo0mhwbEZp7pYwpxcQ1KqapDRFiGx+aPkV8steZaZdEGNQv
	YMRUqM/Co6qDqs6RlN5MYbCp/IG+gibniex5BdWaSp+n0KbiTP+ChjuC7AYfst/9hBQ8NkdD4k+
	VWhiIRnlffi4Gy1QU5D/76tQrHlTiPNx25W7bewSFQ==
X-Google-Smtp-Source: AGHT+IGUbEEndpxCFxvcz07Cv1zGfDAjQAQPjCc1fhLEs/UdSCd0ajiAhgc4BbmU/RyyJnMDMcS4xA==
X-Received: by 2002:a05:6e02:188b:b0:3d2:b0f1:f5bd with SMTP id e9e14a558f8ab-3d5960bf875mr32467915ab.3.1742570035873;
        Fri, 21 Mar 2025 08:13:55 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2cbeb11fbsm468438173.117.2025.03.21.08.13.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 08:13:55 -0700 (PDT)
Message-ID: <6abf923e-b58b-4db7-bd35-82864eed053c@kernel.dk>
Date: Fri, 21 Mar 2025 09:13:54 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug] kernel panic when running ublk selftest on next-20250321
To: Ming Lei <ming.lei@redhat.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <Z9140ceHEytSh-sz@fedora>
 <e2a4e9ac-f823-4068-918f-e4ab1180b308@gmail.com>
 <10a64355-92d5-4580-be6c-84da18af22ef@kernel.dk> <Z91_v1Ce2sCFBNSG@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Z91_v1Ce2sCFBNSG@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/21/25 9:03 AM, Ming Lei wrote:
> On Fri, Mar 21, 2025 at 08:40:57AM -0600, Jens Axboe wrote:
>> On 3/21/25 8:40 AM, Pavel Begunkov wrote:
>>> On 3/21/25 14:33, Ming Lei wrote:
>>>> Hello,
>>>>
>>>> When running ublk selftest on today's next tree, the following kernel
>>>> panic is triggered immediately:
>>>
>>> Jens already stumbled on that one, it's likely because the
>>> cached structure is not zeroed on alloc. I believe the
>>> troubled patch is removed from the tree for now.
>>
>> Yep, ran into the same thing this morning, and yep the two last patches
>> in that series got dropped until this is resolved. Ming, if you use my
>> current for-next branch, it should all be good again.
> 
> Yeah, looks everything is good after reverting the following two patches:
> 
> Revert "io_uring/cmd: add iovec cache for commands"
> Revert "io_uring/cmd: introduce io_uring_cmd_import_fixed_vec"
> 
> BTW I feel io_uring_cmd_import_fixed_vec is useful for using ublk
> zc to write stacking target, plain readv/writev works just
> fine without zc.

I think Pavel is looking at the issue right now, so both may get
reintroduced for the 6.15 merge window. That said, we don't strictly
need the caching, we can always pile that on later. The vectored import
is going to be useful, agree, and can stand on its own.

-- 
Jens Axboe


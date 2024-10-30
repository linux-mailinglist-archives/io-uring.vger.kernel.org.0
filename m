Return-Path: <io-uring+bounces-4178-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DC07A9B591F
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 02:29:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F2881F24139
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 01:29:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CAE842A8B;
	Wed, 30 Oct 2024 01:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XlaAi3oV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1552A2C9D;
	Wed, 30 Oct 2024 01:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730251748; cv=none; b=I/ZPrDGR0DJnOToZTb0P6TRO6ppW2aZtRlVGy6wZD7x6oJT5UgD3THavrrTdkHgHFD5tass2DnD0MxR/RzAqcss4Ie2m3PmQ3uK01yUZZYnhsh9pv0CLLYJQ1nxOQF6AC36eXXnR0MGZ+nJfYNlMo66I5wqXYJZ5CvLBeefp4fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730251748; c=relaxed/simple;
	bh=S+KPC2Nmd9zucXPaKWkWc/ok9as1i/YY+LArQv0Fe4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YA/H4FXzst2i0ZDpXghPsNWbEkSTirQ9UOTDkCzQ1Hj8cisK+bWdqQU1VBs8QMMMP9Klaok+5p6yLZJKnzOBFh+4BJ8a5uFqdcp4Vn3G0vRzQM3h3M66YAeRvt573qrVcYbxI7SL6Y2PXxhY+dwTOKyv++1+HZyfh2DUfljUDqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XlaAi3oV; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-37d49a7207cso4286751f8f.0;
        Tue, 29 Oct 2024 18:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730251744; x=1730856544; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/gXJM0sZxpzqYuUj3D3dzxkSZdfl/gQDpCkqkv0KqFc=;
        b=XlaAi3oVwuucYSAeGAPwJRzb8tAqyU2PgDtArv9SV+vTTF/GxoXh5tqlnEwoTa/F1M
         is3QayVDwoOBMdMi31fBorUB0LWew49mGsORy1Vnc5tY0q4Ig+zjDb+pmryuABF8hmKX
         baKJrcwTcCWM+fgzTqL/pdqKq4HBE5qBdvF4amWwCEx1YHi+971nqRUe4y3/63YBnUxY
         s3V3ajvbz6dzcWhf/I02DhwkrSL7fSWNpKarKkfDja0k8eAJJAQzhYwXIauhOR790pcY
         1REfATiBUA97Ezs8qISUUauufjbgQhSMHvD+gk/pR643HKwEJHnru5BthfdYSUYNDaZT
         VCGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730251744; x=1730856544;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/gXJM0sZxpzqYuUj3D3dzxkSZdfl/gQDpCkqkv0KqFc=;
        b=Da2n1HqU9epMGVsBrzxNRYCn5rqCuSNNwF9HvZn3Tn3kCIbMgFvTwHJBzOE85MrwLe
         vnCgDBIu1HKwMnzW6DRgz0GrdE8S5wYwO9hhfsU4tGTahjhQOWUnC9ikBIrE4UIEpxsO
         461nC8cWvD2Zaa2AK6cc4h9DbwgTwXs33As019f0t+9Q5zMjLfekia3CHP++i1ShumlB
         L7zktZg/jy7vcFcXSLITvIEfEArb3R0nSBE1UCyRChijTqf/Bw3TAinXJ7Yib+D0B8qE
         TxdgWKxPw2FSK+SoNxpMx4w7X7FycOouXLl6NxeRr9eEqX86Ax2UJYaKoZV8KMOXCymE
         6NXw==
X-Forwarded-Encrypted: i=1; AJvYcCV/dnkvirkXDQPsCw0RQtTqjqCEa+d4k44s/XjIBs7kHrUBCDk2cERRET0mAtlGu13ECtRHVxQ7IYXbuys=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6Q42SN8jxB3DRceyqdTyB7aW5aJwipiK4GT2ikuG25kSk1iFP
	cL2TyRsHkDNpLPc6E/mZprMR7Kmy3CTvnYm7dAhDiEGxIei/Jymc
X-Google-Smtp-Source: AGHT+IETKdJRz+xL03Dt2rOVv9GSh+/qfCaHGVGhkL7D1O+nIzspDlutYbOQLNZy0jwQYf3kk7/MHw==
X-Received: by 2002:a5d:4f92:0:b0:37d:3985:8871 with SMTP id ffacd0b85a97d-380611dbea7mr9271729f8f.39.1730251744086;
        Tue, 29 Oct 2024 18:29:04 -0700 (PDT)
Received: from [192.168.42.216] ([148.252.146.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd947a9fsm5544445e9.22.2024.10.29.18.29.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2024 18:29:03 -0700 (PDT)
Message-ID: <8890fa84-7fd3-4198-86d6-9da79e7cad07@gmail.com>
Date: Wed, 30 Oct 2024 01:29:22 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 RESEND] io_uring/fdinfo: add timeout_list to fdinfo
To: Jens Axboe <axboe@kernel.dk>, Ruyi Zhang <ruyi.zhang@samsung.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 peiwei.li@samsung.com
References: <CGME20241012091032epcas5p2dec0e3db5a72854f4566b251791b84ad@epcas5p2.samsung.com>
 <e8d1f8e8-abd9-4e4b-aa55-d8444794f55a@gmail.com>
 <20241012091026.1824-1-ruyi.zhang@samsung.com>
 <5d288a05-c3c8-450a-9e25-abac89eb0951@kernel.dk>
 <cdc6a0c4-5ad8-4ad6-9dca-49fa5e44f8dd@gmail.com>
 <09958a6f-4e24-4a18-b6b3-7ea10ea96beb@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <09958a6f-4e24-4a18-b6b3-7ea10ea96beb@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/25/24 00:25, Jens Axboe wrote:
> On 10/24/24 12:10 PM, Pavel Begunkov wrote:
>> On 10/24/24 18:31, Jens Axboe wrote:
>>> On Sat, Oct 12, 2024 at 3:30?AM Ruyi Zhang <ruyi.zhang@samsung.com> wrote:
>> ...
>>>>> I don't think there is any difference, it'd be a matter of
>>>>> doubling the number of in flight timeouts to achieve same
>>>>> timings. Tell me, do you really have a good case where you
>>>>> need that (pretty verbose)? Why not drgn / bpftrace it out
>>>>> of the kernel instead?
>>>>
>>>>    Of course, this information is available through existing tools.
>>>>    But I think that most of the io_uring metadata has been exported
>>>>    from the fdinfo file, and the purpose of adding the timeout
>>>>    information is the same as before, easier to use. This way,
>>>>    I don't have to write additional scripts to get all kinds of data.
>>>>
>>>>    And as far as I know, the io_uring_show_fdinfo function is
>>>>    only called once when the user is viewing the
>>>>    /proc/xxx/fdinfo/x file once. I don't think we normally need to
>>>>    look at this file as often, and only look at it when the program
>>>>    is abnormal, and the timeout_list is very long in the extreme case,
>>>>    so I think the performance impact of adding this code is limited.
>>>
>>> I do think it's useful, sometimes the only thing you have to poke at
>>> after-the-fact is the fdinfo information. At the same time, would it be
>>
>> If you have an fd to print fdinfo, you can just well run drgn
>> or any other debugging tool. We keep pushing more debugging code
>> that can be extracted with bpf and other tools, and not only
>> it bloats the code, but potentially cripples the entire kernel.
> 
> While that is certainly true, it's also a much harder barrier to entry.
> If you're already setup with eg drgn, then yeah fdinfo is useless as you
> can grab much more info out by just using drgn.

drgn is simple, not that harder than patching fdinfo, we can add
liburing/scripts, and push it there so that don't need rewriting
it each time.

> I'm fine punting this to "needs more advanced debugging than fdinfo".
> It's just important we get closure on these patches, so they don't
> linger forever in no man's land.

The only option I see is to dump first ~5 and stop there, but
I still think the tooling option is better.

-- 
Pavel Begunkov


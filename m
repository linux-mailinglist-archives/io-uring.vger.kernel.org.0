Return-Path: <io-uring+bounces-4182-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 519FC9B59F3
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 03:32:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F0D8F1F228C7
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 02:32:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96101CA64;
	Wed, 30 Oct 2024 02:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VN/HoYee"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6237F38C;
	Wed, 30 Oct 2024 02:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730255534; cv=none; b=TZNzGfU11X/2oRXWaklu4SsLkCxPFRhfqTy+Rg5tRR6g7XzTSPfhX4gk1UutxyVylSbn5FPNyIXlUr7QeaNU1c8XwpiB+wFThOrDbW1Bf0SyZ2ZK6H7ngRVtMyh886x/sIRrMekAcme34Uwehhpj95LNbU92bHzKvVDD2K2ZUfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730255534; c=relaxed/simple;
	bh=i4B9qNQf/Qn3Dq4oGdbXgsu9j3kK3nIT3258nCS2rjk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pQnQCgP8WKd+UQDTts/87Ax1DfSacypX2+pkyY4XddqQNOw3wA1tsMYIQzx6JIbomx9PgqYcoXamiNj34riOUgz72H9mUVeN2RFBRGFGMRN9zFKO4ddW+9+xjz02vE7vnndvD3u8tshzT4ofVT8S+c4/df8qEEdodPWvMrLmwe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VN/HoYee; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-431688d5127so58133005e9.0;
        Tue, 29 Oct 2024 19:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730255531; x=1730860331; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2qC9Rpvdq7ExpYLAQvxdxkGUl/SEhvg3K125GnyAPw8=;
        b=VN/HoYeeDSvnB1YgO20CPizcgLwougHytsnah8PKULfysiIFAn7MEcBHXUHLz1GX2b
         0MYTL0dGzZN7CUl+PWXJw1ApUtj/yBOpOza5Rr0ZuuNFJ4IcvIRhjyJqk0pFrgwkxMXs
         LbnQf41KLUFRd0sffOPzkGdhRWJyX+69+n+aFWfkEmWjlsuhrExenEm2ofwErYTQ92KG
         s1PwrLTJc0pF7L3WhF+7+jbX2g/2Ttry6KhYm6clS8jZJ8MFqOJXRfW8/0I/Xh7GiCDU
         ZRfGe6NqIgnV8Yp3xnveTrDmGgZmL6Z9QIcFa8DcnQ8TmYQWhUAk5plTE/aN2qbLHbg+
         jXFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730255531; x=1730860331;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2qC9Rpvdq7ExpYLAQvxdxkGUl/SEhvg3K125GnyAPw8=;
        b=vEoTEWCN9l0gJWZIhCGJhDLAV19SOu9BzJ2++g3/CWBHlZuqWnYwpjg0S9AGunBOtQ
         eIxW+Hky3jlToBX8APDTAE6VaMrbP+y+xeIyZAN3jg0m3WIPllsHp057pT7ipUoV/NYv
         g/ycMAFgqw9o0FBBKx/9S2vDmSolu4+AGPfeatI/pb9VaCSYnx5qbU5ZjNTjZTmCJsuB
         Mb4HUMwOKzgWATRxY8qpMF/JhSKGPMPG1HtUi/TI4HJv5npUykgCX4owWlxJKtfiIu0Q
         y8erMHcrEY+DAXiOTcTAITxgUfYt9EJSxunHgrWHY7OdsQhsqYAcezaC0TlwMQ4d6LhX
         DniQ==
X-Forwarded-Encrypted: i=1; AJvYcCXomQdpnNqi0mjWMPuUw0o0yoicACu2Q5OCzSbRn2qRpspaBhbMyDwrWHi/RnAuEtaHfXk6cAAf8g==@vger.kernel.org, AJvYcCXx5/MPvSyoz1PbD4th6myZ42dxb5WscbEuX6nSSfUdF99VPvizypUT7JUx3G5Zm2clGwP5vurjAw5y/h8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUHz+6vbs0dFF6YndC9E2YB1B8KDyaO1txAUtMnwxgVbVDRIiE
	610TKn3jtj2rXb9yQacKPW4WP0bQo23E6DPEnKgpHN8f0QEDXLsW
X-Google-Smtp-Source: AGHT+IEqIsW/ZLny/zxsqNAQ5tjdtn10e1n0LNz+bx4YE/61WFVLrUIz+D+w3fLbPPtKl8Zzmif7jw==
X-Received: by 2002:a05:600c:5118:b0:42c:de2f:da27 with SMTP id 5b1f17b1804b1-4319ac6f848mr131954485e9.2.1730255530448;
        Tue, 29 Oct 2024 19:32:10 -0700 (PDT)
Received: from [192.168.42.216] ([148.252.146.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd947ddbsm6636155e9.14.2024.10.29.19.32.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2024 19:32:09 -0700 (PDT)
Message-ID: <0c65f585-5b67-4a02-a1e0-e3a6e9220103@gmail.com>
Date: Wed, 30 Oct 2024 02:32:27 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] btrfs: add io_uring command for encoded reads
To: dsterba@suse.cz
Cc: Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20241022145024.1046883-1-maharmstone@fb.com>
 <20241022145024.1046883-6-maharmstone@fb.com>
 <63db1884-3170-499d-87c8-678923320699@gmail.com>
 <20241030012403.GX31418@twin.jikos.cz>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241030012403.GX31418@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/30/24 01:24, David Sterba wrote:
> On Wed, Oct 30, 2024 at 12:59:33AM +0000, Pavel Begunkov wrote:
>> On 10/22/24 15:50, Mark Harmstone wrote:
...
>> It seems we're saving iov in the priv structure, who can access the iovec
>> after the request is submitted? -EIOCBQUEUED in general means that the
>> request is submitted and will get completed async, e.g. via callback, and
>> if the bio callback can use the iov maybe via the iter, this goto will be
>> a use after free.
>>
>> Also, you're returning -EFAULT back to io_uring, which will kill the
>> io_uring request / cmd while there might still be in flight bios that
>> can try to access it.
>>
>> Can you inject errors into the copy and test please?
> 
> Thanks for the comments. I get the impression that there are known
> problems on the io_uring side, so until that is resolved the btrfs part
> may be insecure or with known runtime bugs, but in the end it does not
> need any change. We just need to wait until it's resoved on the
> interface level.

There is nothing wrong with io_uring, it's jumping from synchronous
to asynchronous that concerns me, or more specifically how this series
handles it and all races. Basic stuff like not freeing / changing
without protection memory that the async part might still be using.
That's up to this series to do it right.

> The patches you point to are from FUSE trying to wire up io_uring so
> this looks like an interface problem. We recently have gained a config

That's the easiest part of all, it can only happen when the
task dies and mm becomes unavaliable, sane userspace shouldn't
have problems like that. Mark just needs to include the referred
patch into the series and handle the request as mentioned.

> option level gurard for experimental and unstable features so we can add
> the code but don't have to expose users to the functionality unless they
> konw there are risks or known problems. The io_uring and encoded read
> has a performance benefit and

Good to hear that

> I'd like to get the patches in for 6.13
> but if there's something serious, one option is not add the code or at
> least guard it (behind a config option).

Let's see what Mark replies, I might be missing some things, and
you and other btrfs folks can help to answer the unlock question.

> I'm open to both and we have at least one -rc kernel to decide.

-- 
Pavel Begunkov


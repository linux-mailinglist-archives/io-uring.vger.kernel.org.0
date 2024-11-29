Return-Path: <io-uring+bounces-5151-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85BE19DE853
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 15:18:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22FF91635CD
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 14:18:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87D151F92A;
	Fri, 29 Nov 2024 14:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kRnGrl+V"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF331DA23
	for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 14:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732889880; cv=none; b=g0Qx4TRlLmpvtKL59/Ts+x4ZrBdRNtvQ8iAezINs98JnYiEj3uQfL1AKrXTQWaVTefueKf/JCRMVgJsSLigDaHww+BieYktWFec0mV5s2jSb8PWA2/TMwftyvmIkaiGjQ2IdlDonIKteu5YTuCc/IfKTDOwkW2g9WXJ0fsSTPeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732889880; c=relaxed/simple;
	bh=W0DmtYs/ivDPnZwWHT8UHad7UvF/caiQ/9exehD/LVE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oJl/8LaJ3NVBtQ+UH/HraLknNTnrmN0CPsKpRUeX41KR5e3YIB2FQjU4ZW7vI/SsaRcz8jBD0UrxPBk+dRzYXLQyjwVb/KMFWuDVk8lfqQBMrDMYcXB8w769qZqd/nsqi8jI04pjCeOj/t/0L5K/vsSJhL56Inm475mW/QCt2bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kRnGrl+V; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-7fc340eb006so1476189a12.0
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 06:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732889877; x=1733494677; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qTjLakjVQ8CuPE9b+KJbasKB+qT5ruuRyMKmxE0mpHE=;
        b=kRnGrl+Vc3ICIM0amrhgMkRRqHxAZ+u63GopygY+q2sAJ5JCZ2o5tKakg/wSUL3EzH
         Nl1mu00t47i23HzE8cgE8T4q1WZ4dV3bpQdKYD3wp+9JTPC/pZtUtUbxfO6qkHwdWnEW
         e9EHENf6Wf6PIivyTax2KdDh5/pjMpj5KaOmYAl03Yfo0+muRwIG4DezARl6Kr1JVXwL
         Vo2Gj1RtRvqv68B0OsLn7fDxz8pitq6nDlcdIc9JLM0qXByPLsNDFbnnS6OPaHRhp5we
         kJCJGrarUPtWdGBPXrMGHYgV7nsn7Bq56hCH8a402B+Yyh7ZUv/w0aNWS8wrJ/gofHx1
         bmxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732889877; x=1733494677;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qTjLakjVQ8CuPE9b+KJbasKB+qT5ruuRyMKmxE0mpHE=;
        b=RztY6bR0eFZL+WxaXk7/3rfg963u2KNpVH2Ogh3l1XmT3ND3fOmb4NatDjNJlpC2sZ
         Us3g9F9/By+H/JvthH7FHacuEOmctIQFRXhv2svTHIl7mkagijnPr6M7BqkTFhAra9Fn
         +6EtlLTxh4cbeY8UmZYBYiXvloSJxN15Oys4FHOugRGBkMwoBQGie8CV++pEpyf7HO+U
         bQFAkRRAZ70cVI4VFl8aU1mX7OorhaiQJ5u8S0dQkzo56wHoCKURpGIGglzZG58/X8/B
         4mfaCucTjsb1oRBGWM2gSp6ZFdw+K9K87NMkqQeZuIXb1Ja3v6N8XmQF+b4tg8B4eQAi
         /VQw==
X-Forwarded-Encrypted: i=1; AJvYcCXvDNE7l7HSfB3gXv9yVj1jXZDJJY9kql/TZqlDoId3Saiut8ed91i7FOj/9c+qnnJGvnxH9OzFZw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzl61MHIlZuy0cmq3DP6LN6B2EX9NfpDjwuA7FZ4dYb1z2bP8X6
	CTMYrj/Drc/ZP17spviqPW/FsqBFFg+0d9E/nij0eQkEmcx8Pt5R62RbaUUps6k=
X-Gm-Gg: ASbGncvHyAuWZY8Ob8wcLAFiYQfcEgcr6rjz8UtnPwKOlGtF5nu0su0XQ265gXMm+J3
	DS9mCmF5UP396/qH7lGm5KXC1qJnW6PbxvkdO4dRWhmQWv61ScBqB9ChLVUN8c47YOfXVSgnA/B
	wO9scblRLuiJQKRIfnBPN/PRXyWKesnJ0BuwNouPmqo4uoWkWd9U+w1H/eRDv7b9iIc70Syz1Wp
	5kf+7z+Ad/4YuAKhqWA3nUngdghRTfssX52HBN/z4dYwtI=
X-Google-Smtp-Source: AGHT+IGex/wnF/hyoCx+DzF6xIc9C3Ts1sMz2ZwLBUPzctWWBqn39zKEoU35OVLZuarjSrOdSTzJsA==
X-Received: by 2002:a05:6a20:430d:b0:1d9:3957:8a14 with SMTP id adf61e73a8af0-1e0e0afa6d6mr16379131637.1.1732889877136;
        Fri, 29 Nov 2024 06:17:57 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fc9c30e2d8sm2749399a12.38.2024.11.29.06.17.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Nov 2024 06:17:56 -0800 (PST)
Message-ID: <bc40bd75-7eac-4635-8c91-ccd42c2f1aa6@kernel.dk>
Date: Fri, 29 Nov 2024 07:17:55 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] WARNING in __io_uring_free
To: Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>
Cc: syzbot <syzbot+cc36d44ec9f368e443d3@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <673c1643.050a0220.87769.0066.GAE@google.com>
 <CAG48ez0uhdGNCopX2nspLzWZKfuZp0XLyUk90kYku=sP7wsWfg@mail.gmail.com>
 <Z0kDWtjmlI_LwP5S@casper.infradead.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Z0kDWtjmlI_LwP5S@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/28/24 4:57 PM, Matthew Wilcox wrote:
> On Fri, Nov 29, 2024 at 12:30:35AM +0100, Jann Horn wrote:
>>> ------------[ cut here ]------------
>>> WARNING: CPU: 0 PID: 16 at io_uring/tctx.c:51 __io_uring_free+0xfa/0x140 io_uring/tctx.c:51
>>
>> This warning is a check for WARN_ON_ONCE(!xa_empty(&tctx->xa)); and as
>> Jens pointed out, this was triggered after error injection caused a
>> memory allocation inside xa_store() to fail.
>>
>> Is there maybe an issue where xa_store() can fail midway through while
>> allocating memory for the xarray, so that xa_empty() is no longer true
>> even though there is nothing in the xarray? (And if yes, is that
>> working as intended?)

Heh, I had the exact same thought when I originally looked at this
issue. I did code inspection on the io_uring side and tried with error
injection, but could not trigger it. Hence the io_uring side looks fine,
so must be lower down.

> Yes, that's a known possibility.  We have similar problems when people
> use error injection with mapping->i_pages.  The effort to fix it seems
> disproportionate to the severity of the problem.

Doesn't seem like a big deal, particularly when you essentially need
fault injection to trigger it. As long as the xa_empty() is the only
false positive. I wonder if I should just change the io_uring side to do
something ala:

xa_for_each(&tctx->xa, index, node) {
	WARN_ON_ONCE(1);
	break;
}

rather than the xa_empty() warn on. That should get rid of it on my side
at least.

-- 
Jens Axboe


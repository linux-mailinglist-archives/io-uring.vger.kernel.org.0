Return-Path: <io-uring+bounces-5232-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 563AC9E45B1
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 21:28:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 86F69B3AC41
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 18:01:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D429B1A8F64;
	Wed,  4 Dec 2024 17:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="W7Nak71G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBC214287
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 17:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733333944; cv=none; b=gqCcp7vzTq4jEvh7ixE1DXr/Uz5BTYGoSO4CHU8J2S1iu9MVvq0+WujbvZNRr1I9CjymG3lhusvKkt16MaGbhHTpc77JPAh09m9IhxA/boqB6DsVY4dfN0QApUt+wxsSkveLpnGg772q4/8Znust57c3k5RsMoNhQQwL+7rg49Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733333944; c=relaxed/simple;
	bh=Wv3xb61sc0ZFwM1CF09p6Z+3FQpIIW1chil23ZovVVw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ACQZazakEF0xfd7spBnMiFyVH9UaLFH3wgyUuMqEQgAYd8R/qhCUmX07rR42uB6mphYwi7d6P5uPnVh04Aw8eP5NT4sWTNQc348i6syktvFPFurkwR7djg4FDRg7FYnTsFtsX9siwssestfLLQ05C+ZvxdGwyHfHPYg+3EfsU+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=W7Nak71G; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2155312884fso126475ad.0
        for <io-uring@vger.kernel.org>; Wed, 04 Dec 2024 09:39:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1733333941; x=1733938741; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VFClu+Hvt7amMncVjBqzTSbdie8DwUy5v4UirHChi6g=;
        b=W7Nak71GxErBNvtcimNa4VzT2MQVv8KeCc4r6NA8V5RGLl6W4uH4RqW8dMQpTmj0ms
         N8FLwLqebjg4aNgqfmGgnNfvK1r74p6rpT5YeGrV29Fg5mxeIU19Mxu+ivJf6wTDi5gO
         Cxb1wXFoCIWxD6aGK/uyTxkkKylZ81H9n+CaQlxmp98Srm1OzgZYLD4bi+3lQ8lLx3Zh
         DKRli7GZr+keCcj2W7+yY29+xL3+H3M2uoVERDRug50wgNQ5HMhklatb7kcn0TxNAVpC
         E29z3Hj6BcLobsk3o/qrY81CLe5+prheRkDjedMaQFE9Ydu4i6enyrFa0MyDlzpDct6K
         Ct7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733333941; x=1733938741;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VFClu+Hvt7amMncVjBqzTSbdie8DwUy5v4UirHChi6g=;
        b=o4+QVXZYx/LH8T1mBqF+z6dS1ACTN6AtFJy2KwFkLQau2i9HgeDgt+X5H4IPZqZyw/
         yqZ4Aw/273ajODYozXpn3znLGLh5IHXMMCddCBm1cTPRhJpiPKoKPNKx56dkX8vR355k
         yyAsx6p4UuemnVitcw3y9Rd5I5zyc0kqNayf+baSzd0qNnbrjDPRWt0dValTyhajVNX3
         IqvYWYuztN+CBptnzZURClup5TRcnv4p1j16L+yhGPME45Ig0b+iWV5ZSzy/LlJ4gSwY
         38xWnoBy4yYW7h59foFJZtrNWqEpYQooQ0ErdWGnEcvkyYFBC29QTucakf+LJuQsSQDA
         mr0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXZQL5iEVYdLSkC0+aAmE6vAzyEhV2g/T3d932bqDZhy34ekd/KyMKUrug+rUO1IiuOML4fTfbqPw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyqVLVskrc/XGiZc/r3PLUPvmX7Ynn6BxrYqWu75BACRX44kbsa
	hnVSy1aKK0hjwxa7NJ+rbDaHoFsK9JT8HUfA64iO/qY5+lgkEWoaL0F/eWobx7M=
X-Gm-Gg: ASbGncuLaK/WZH+EpR15glMGivceeK3MA6yzgwnSYSdjxfJ7Ww28aGfTqYpPWJ3gPMI
	t1Pozbvuf1iIfivyj3lty5r8c1r7wZJHq1jMbR0AwQNUVCbpDRg5tM+D9CXK/8PWw2qgZRlDIeV
	s3UzAJxMn7Z7QH2/mc/WCTTgGZQ3CagOCC6ZNzut6W1b1/TLhNpzt0Yd4e+q8F8pV6/g5+8TzlH
	Rjtmr70xdQ1OKfolplQMzmnXwCiYpssZIvSXSpP3O2XColXE5kWewB/Og==
X-Google-Smtp-Source: AGHT+IEWwmwlmTiq2H81pZwumsdyTa//GeiFxgP24xH6IM5xZVH1ovP6c15jfg3covmiQRAdntPWQw==
X-Received: by 2002:a17:902:ce08:b0:212:e29:3b2f with SMTP id d9443c01a7336-215bd250316mr90887145ad.44.1733333941081;
        Wed, 04 Dec 2024 09:39:01 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:122::1:2343? ([2620:10d:c090:600::1:a7a9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-215a6fd3f1esm48257605ad.72.2024.12.04.09.39.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 09:39:00 -0800 (PST)
Message-ID: <3ede47bf-8612-47f7-9851-13c6622ecf44@kernel.dk>
Date: Wed, 4 Dec 2024 10:38:59 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] general protection fault in
 io_sqe_buffer_register
To: Aleksandr Nogikh <nogikh@google.com>
Cc: syzbot <syzbot+05c0f12a4d43d656817e@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <67253504.050a0220.3c8d68.08e1.GAE@google.com>
 <67272d83.050a0220.35b515.0198.GAE@google.com>
 <1ce3a220-7f68-4a68-a76c-b37fdf9bfc70@kernel.dk>
 <CANp29Y5U3oMc3jYkxmnfd_9YYvWK3TwUhAbhA111k57AYRLd+A@mail.gmail.com>
 <9e8ccb61-e77a-4354-a848-81242625658c@kernel.dk>
 <CANp29Y4dWOk3Hk2NJbQSnSE-XoQfCv5vM1FM_FWr5Xbv+d3yFg@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CANp29Y4dWOk3Hk2NJbQSnSE-XoQfCv5vM1FM_FWr5Xbv+d3yFg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 12/4/24 10:34 AM, Aleksandr Nogikh wrote:
> On Wed, Dec 4, 2024 at 6:14 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 12/4/24 10:11 AM, Aleksandr Nogikh wrote:
>>> Hi Jens,
>>>
>>> Just in case:
>>>
>>> Syzbot reported this commit as the result of the cause (bug origin)
>>> bisection, not as the commit after which the problem was gone. So
>>> (unless it actually is a fixing commit) reporting it back via #syz fix
>>> is not correct.
>>
>> The commit got fixed, and hence there isn't a good way to convey this
>> to syzbot as far as I can tell. Just marking the updated one as the
>> fixer seems to be the best/closest option.
>>
>> Other option is to mark it as invalid, but that also doesn't seem right.
>>
>> I'm fine doing whatever to get issues like this closed, but it's not
>> an uncommon thing to have a buggy commit that's not upstream yet be
>> fixed up and hence not have the issue anymore.
> 
> I see. You are right, thanks for the explanation!
> 
> There's indeed no better way to convey this at the moment. I've filed
> https://github.com/google/syzkaller/issues/5567 to discuss what can be
> done.

Thanks! Guess I wasn't totally blind, I did check to see if there was
a better way to do this currently and didn't spot it.

-- 
Jens Axboe



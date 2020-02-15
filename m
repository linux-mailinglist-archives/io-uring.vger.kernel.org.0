Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 824FE15FBDD
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2020 02:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbgBOBKR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 20:10:17 -0500
Received: from mail-pj1-f49.google.com ([209.85.216.49]:40319 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727639AbgBOBKR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Feb 2020 20:10:17 -0500
Received: by mail-pj1-f49.google.com with SMTP id 12so4604271pjb.5
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2020 17:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/mTI6E6fLpY2NIyZT8JE3xLfWsCeI/tqTHXMGsGAJX4=;
        b=QL4RruImS/bxHJMLi+dXRnS6xU0M+GwseGNS+L0myRcC22jb5lJn6HT0NV51loHxNw
         dtFsz8JuRGch/8nVX2xg4PKVhfeiJoMP639V4+BudA4CvL7yZv5Ml2xnF2OQDA+j/aC/
         T8O8EUV1TXfosHkUfwws1NTID3//yCE53WqDYOiCXFl+MMVxxUhfR4RvIaCIeEf4TAUb
         hR3ywxNL+kTo9KQ6e5D26B8I2CsE/3o80lINCxqCxO8tmxM7y2rvXCP/2TqPZSgxmMDT
         qrmeMVnaQORquIY0ckSSr8CEbwqReP2p3gTLcow0SnStaGDT2R5MDfmnr/Rz2MciYTGx
         MYYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/mTI6E6fLpY2NIyZT8JE3xLfWsCeI/tqTHXMGsGAJX4=;
        b=s82cyLbICieENyc0Wd06XPP49poAs7opUiUoFk/04Mrchs/YeeRmnw8CmR4bg+SxEq
         nY9fs1zmg0ZtW+Ke2oYbBKWsoafn5tDp2fHcZSkBafSMkUH0/4XdeYXB+tICiiDguneV
         wKosBI8M/+gkdCTtihu/8XC5arZx9HLnlWrkeV5vFDiMIHcQ+TtAITWlyCvYsXweq83M
         ynh4OGXcj++i65TU9hp24mDy10qwHrTdhqq5u0MIAeS6yKUvUlhVnhGhrSwFPJ2Rs7MX
         SU84CPqXtAT5SlojoKygUCzVNU0tmeg+AMK8hOXbe7wSNlDgTQf5ZYEBGA8maUTUW+R/
         OI/A==
X-Gm-Message-State: APjAAAUjlJY20I4OQAbbFC2FrxriZ7sorL/Isc8Sh5yCDek5T02WH87k
        JS4EeRKh1RY9MxVQQT6hGf15LjTDBk8=
X-Google-Smtp-Source: APXvYqzQ8dnYwdtUvWt1HOQXACOK7PNdP4SMNvi7PSHBqriAcGXiCRgmZTWNSH9SUMBr9TQydozpng==
X-Received: by 2002:a17:90a:6:: with SMTP id 6mr7020835pja.71.1581729015102;
        Fri, 14 Feb 2020 17:10:15 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id e10sm8264002pgt.78.2020.02.14.17.10.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 17:10:14 -0800 (PST)
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
To:     =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
 <8a3ee653-77ed-105d-c1c3-87087451914e@kernel.dk>
 <ADF462D7-A381-4314-8931-DDB0A2C18761@eoitek.com>
 <9a8e4c8a-f8b2-900d-92b6-cc69b6adf324@gmail.com>
 <5f09d89a-0c6d-47c2-465c-993af0c7ae71@kernel.dk>
 <7E66D70C-BE4E-4236-A49B-9843F66EA322@eoitek.com>
 <671A3FE3-FA12-43D8-ADF0-D1DB463B053F@eoitek.com>
 <217eda7b-3742-a50b-7d6a-c1294a85c8e0@kernel.dk>
 <1b9a7390-7539-a8bc-d437-493253b13d77@kernel.dk>
 <20200214153218.GM14914@hirez.programming.kicks-ass.net>
 <5995f84e-8a6c-e774-6bb5-5b9b87a9cd3c@kernel.dk>
 <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
 <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <FA1CECBA-FBFE-4228-BA5C-1B8A4A2B3534@eoitek.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f1610a65-0bf9-8134-3e8d-72cccd2f5468@kernel.dk>
Date:   Fri, 14 Feb 2020 18:10:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <FA1CECBA-FBFE-4228-BA5C-1B8A4A2B3534@eoitek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/14/20 5:16 PM, Carter Li 李通洲 wrote:
> Hello Jens,
> 
> 
>> It's now up to 3.5x the original performance for the single client case.
>> Here's the updated patch, folded with the original that only went half
>> the way there.
> 
> 
> I’m looking forward to it.
> 
> And question again: since POLL->READ/RECV is much faster then READ/RECV async,
> could we implement READ/RECV that would block as POLL->READ/RECV? Not only for
> networking, but also for all pollable fds.

That's exactly the next step. With this, we have a very efficient way of
doing async IO for anything that can be driven by poll. Then we can do it
by default, instead of doing an async punt. Much faster and much more
efficient.

I'll try and work on that next week, I think this could be a real game
changer.

-- 
Jens Axboe


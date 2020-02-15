Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3D9E15FC07
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2020 02:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgBOB1w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 20:27:52 -0500
Received: from mail-pg1-f174.google.com ([209.85.215.174]:45373 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbgBOB1w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Feb 2020 20:27:52 -0500
Received: by mail-pg1-f174.google.com with SMTP id b9so5665255pgk.12
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2020 17:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m7c54tIq0hGX27nQeQQPArBnginH54bHhvOVCS1OsS4=;
        b=ZxJUEXNFZgTzrKfnq8/7/YBkOPWFyd0n6nQigO8v3yKlkt1uiX0z/VV24LHw4snkYl
         aMrUvKGBWVusEWutoedFEQ1vYjAZdQWg9YhG2cQO9kLVVvaBltWKF3uxE3PKqU6r+Uor
         mgJinKiG+anGkauM+LzlKKpbRE3guKbKUro+iJaGmMt21HCir2zTCjiEsxxKB0GiOI7O
         G0U2Vt9X+dYYUSSOaiT8ukIG0SmMd2vSTri03RcAIiO/ist1A4HdJrTeA8ST8SZftztx
         TahfCNljS9sTsgCKNUKRlMHzpKWyjiGlncwVOE5DfVm7E3lyZZzSC/k8YCKm0XMWz2Ll
         OmhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m7c54tIq0hGX27nQeQQPArBnginH54bHhvOVCS1OsS4=;
        b=LYYCr3nTP/k5b1hjlj8pFtAjETiG5fdi6Uu6vocA/mWWdJ7bvCD24earfGP5r4swR8
         CHdHrYjmabtyo45uE0Z50qXsh2S7Or5i9F/DAXbToNbN1IcVLjFvgFiPBc2QCisooOuQ
         q+vm3y/ZbNcnhlELCyjvskiNdug82XKx5zD/9br/2MhZOb5VYeSpuwO34LGEOS0PepHD
         gc+KiRZXISvxDDGTCQRoR2QqUeiwFwCHAD+lRGGfoa+xxzGCAOsmwtP7uMRthJYaCtXk
         0dOPmaTVz8a0vOfrDntqyW2enmrRoEni+/pe1U1c0ahoCrNfI7qFvCHgejBgICw8Wx2q
         ruIQ==
X-Gm-Message-State: APjAAAVS9afZBf4aUZvfGNRg/w1YUOsWjl6smBlsFpSqt3+Du63kKTRz
        Aa6r+grVcLUZSjMNfVxmB7mJXuKCKrI=
X-Google-Smtp-Source: APXvYqyBeLfyqS+yxyUebz3Z2Y0NlMDFPBCI05id1jU/G8UcCO6dILYCnEn5dzFJExx/bwzaRb/paQ==
X-Received: by 2002:a62:7541:: with SMTP id q62mr6186466pfc.248.1581730070259;
        Fri, 14 Feb 2020 17:27:50 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id t19sm8315302pgg.23.2020.02.14.17.27.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 17:27:49 -0800 (PST)
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
 <f1610a65-0bf9-8134-3e8d-72cccd2f5468@kernel.dk>
 <72423161-38EF-49D1-8229-18C328AB5DA1@eoitek.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3124507b-3458-48da-27e0-abeefcd9eb08@kernel.dk>
Date:   Fri, 14 Feb 2020 18:27:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <72423161-38EF-49D1-8229-18C328AB5DA1@eoitek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/14/20 6:25 PM, Carter Li 李通洲 wrote:
> There are at least 2 benefits over POLL->READ
> 
> 1. Reduce a little complexity of user code, and save lots of sqes.
> 2. Better performance. Users can’t if an operation will block without
> issuing an extra O_NONBLOCK syscall, which ends up with always using
> POLL->READ link. If it’s handled by kernel, we may only poll when
> we know it’s needed.

Exactly, it'll enable the app to do read/recv or write/send without
having to worry about anything, and it'll be as efficient as having
it linked to a poll command.


-- 
Jens Axboe


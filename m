Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 623AB174F22
	for <lists+io-uring@lfdr.de>; Sun,  1 Mar 2020 20:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgCATOh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 Mar 2020 14:14:37 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38503 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgCATOg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 Mar 2020 14:14:36 -0500
Received: by mail-pl1-f196.google.com with SMTP id p7so3297421pli.5
        for <io-uring@vger.kernel.org>; Sun, 01 Mar 2020 11:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=lnwCBfe1zZuQobxAOQZzSQec0D6ylnT+NKbdGoIZA+4=;
        b=UKtFK4Ej05UmGNRtJ6At8dFluyaZwv3CO7nBIb2TVzN+c829X9sKd2865+VFlRo0tz
         GsTO2f/vNLNkkk6W4Y1R121Pm5p3zKPQwpk7RU4Vo/swxo1FvHpdKQIPbx7AN00p14aU
         P1/+83+JK+xABEM3FPHZnlSQTCpKzXZzu0MIaRMDJ4QlB09WS9+p74TnqzKi0l6+oe/V
         26Csh5abjDfZfPasEKA6NFPu3f7gVqfZHQy6drTLZrVP/5dTw/2OKIuvBQhGX7Mj2lnn
         /Tp2dnINxau6hBNrubIRyXxAigj0tdRJVzADCXZtbCavacjrfLnUT4eFs+lcIaRO6rF/
         gemg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lnwCBfe1zZuQobxAOQZzSQec0D6ylnT+NKbdGoIZA+4=;
        b=m10UXgnr11mx66t2o2DW1qK2b81skliBvIUKgsvGorI+0fAfrTELAZ5nX7Ho2Z3vaX
         36f90h/pJU0nTPwMwBxR4xaUNsrV3U3/zdaUYGQhBKcCAGvl2OAG35VJhFuAfjT8cEUt
         P60L3cjUoU6Tn1MUUN8u4kqZ63d1qTUFbDp1LkQTjQ1GE6WcT/WisJZGw4yeYrhhVBIx
         SlTW7gGTVQ9h65OO4RiRiQj5EAml3dqvqUxrJBk+lm7hYIsO8XXFd88ij/zoCks/T/7U
         1WMSc7VRMaK3iXqaaViBIIsBPh/59xo1FWrri/ef3OxLEPeKF25AilKSWrFAwcRFjs8B
         1dYg==
X-Gm-Message-State: APjAAAUvTF19KxTJG3JOot699OfnihyAFglkMxJllE+mNV+k5/8O9Ugy
        Q+j8qHddEX1Vrik7lXiBcbh7Gg==
X-Google-Smtp-Source: APXvYqyaB0VEGVMWT1FvewbtBlpm+NJxuPWHbtzlMBQvig84b1p0CLBzjmr2V6uvya1rQJKnJvDQqg==
X-Received: by 2002:a17:90a:d081:: with SMTP id k1mr17440983pju.57.1583090075021;
        Sun, 01 Mar 2020 11:14:35 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id x18sm6135837pfo.148.2020.03.01.11.14.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2020 11:14:33 -0800 (PST)
Subject: Re: [PATCH RFC 0/9] nxt propagation + locking optimisation
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1583078091.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d54ddeae-ad02-6232-36f3-86d09105c7a4@kernel.dk>
Date:   Sun, 1 Mar 2020 12:14:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <cover.1583078091.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/1/20 9:18 AM, Pavel Begunkov wrote:
> There are several independent parts in the patchset, but bundled
> to make a point.
> 1-2: random stuff, that implicitly used later.
> 3-5: restore @nxt propagation
> 6-8: optimise locking in io_worker_handle_work()
> 9: optimise io_uring refcounting
> 
> The next propagation bits are done similarly as it was before, but
> - nxt stealing is now at top-level, but not hidden in handlers
> - ensure there is no with REQ_F_DONT_STEAL_NEXT
> 
> [6-8] is the reason to dismiss the previous @nxt propagation appoach,
> I didn't found a good way to do the same. Even though it looked
> clearer and without new flag.
> 
> Performance tested it with link-of-nops + IOSQE_ASYNC:
> 
> link size: 100
> orig:  501 (ns per nop)
> 0-8:   446
> 0-9:   416
> 
> link size: 10
> orig:  826
> 0-8:   776
> 0-9:   756

This looks nice, I'll take a closer look tomorrow or later today. Seems
that at least patch 2 should go into 5.6 however, so may make sense to
order the series like that.

BTW, Andres brought up a good point, and that's hashed file write works.
Generally they complete super fast (just copying into the page cache),
which means that that worker will be hammering the wq lock a lot. Since
work N+1 can't make any progress before N completes (since that's how
hashed work works), we should pull a bigger batch of these work items
instead of just one at the time. I think that'd potentially make a huge
difference for the performance of buffered writes.

Just throwing it out there, since you're working in that space anyway
and the rewards will be much larger.

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E878315CF2
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 03:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235311AbhBJCKp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 21:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235246AbhBJCJA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 21:09:00 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8617C061574
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 18:08:18 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id j5so201891pgb.11
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 18:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=cG6hVlJXRMql8jAyoIzxnGJBPepPoNmh5vVV97P6qkg=;
        b=JMpUMQwNxissFekQfJIoyW01vtQlLrBGQj95gC6VkrZlsvl8VFSY9V/Fwq6+ug2xnw
         Rn8d+DTG0Yy+Qj9Azi6pJIw6dMxsWb29tMS1QbSb0FIMEoTJEqGzB544AdAC8b8XcRJU
         XKe3edHqrsRzlqWElH9SgMJ9Cc5fAY6ki20TxxSKlo4lSnUIohghqjnFxrZmULZUIghY
         RkTCXtGe5UvfVpys3ufC+VofKGCTBRYb0DHXj4sL1mN2XHQngFJYCg2ibKSQgnTx0gzY
         PqfRlrtlhFDu3IHaIhriDKdliNuejR6M3bkYBLEXT786soZtBK3a6Rbkk0ObrdGPPnkE
         OJEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cG6hVlJXRMql8jAyoIzxnGJBPepPoNmh5vVV97P6qkg=;
        b=jCeXxdUF0oPtMe+zPgewa6vl4c8LQ8v5c78pKbWL/mIQxGBFLzJOlNQqTe94SU1a6B
         9EtKbjH7TwUMxJO9P2DXSf5J2uz9EbjXnyNmIzC/8MHcmMq6C3Ceow4PM3ZVyNiMkgON
         gXVJOWXHdU8hDyGcOLjoeNpBgVrvRvSpsa6lxqSROmOZa/PKnrHnO6PRO9/hUm4JDSOA
         0nCaNxXxmkOqC44s75U9OBzeM+eILKvgCZLio8bulFOD6aF6CsV1p3e6iMKmEiLXCkKl
         ZC7PHo6hNIxnpVsLlsh7La7p2lu1qRR+A0I7YHmFcHrY8ToNyBBhKRyfq+pHvcHHtq2m
         ZuJA==
X-Gm-Message-State: AOAM5301yJauQ5TifTmtKTeqy+ctJnf3RYGfWDQhfwp7p8nrOML1ed8e
        SJiTGuyDsXrjot4icdJG0+Az33de6fpJZQ==
X-Google-Smtp-Source: ABdhPJwl1hST3U75+P38lnuWMipx0LPdWlAn5Jy0qWb1ntUw3XMqp1tMkZ18SIwfPlXG0SEF0NlQtA==
X-Received: by 2002:a62:b515:0:b029:1d6:aba1:e22 with SMTP id y21-20020a62b5150000b02901d6aba10e22mr1010262pfe.47.1612922897886;
        Tue, 09 Feb 2021 18:08:17 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id o14sm222837pgr.44.2021.02.09.18.08.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 18:08:17 -0800 (PST)
Subject: Re: [PATCH RFC 00/17] playing around req alloc
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1612915326.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ffaf0640-7747-553d-9baf-4d41777a4d4d@kernel.dk>
Date:   Tue, 9 Feb 2021 19:08:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1612915326.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/9/21 5:03 PM, Pavel Begunkov wrote:
> Unfolding previous ideas on persistent req caches. 4-7 including
> slashed ~20% of overhead for nops benchmark, haven't done benchmarking
> personally for this yet, but according to perf should be ~30-40% in
> total. That's for IOPOLL + inline completion cases, obviously w/o
> async/IRQ completions.

And task_work, which is sort-of inline.

> Jens,
> 1. 11/17 removes deallocations on end of submit_sqes. Looks you
> forgot or just didn't do that.
> 
> 2. lists are slow and not great cache-wise, that why at I want at least
> a combined approach from 12/17.

This is only true if you're browsing a full list. If you do add-to-front
for a cache, and remove-from-front, then cache footprint of lists are
good.

> 3. Instead of lists in "use persistent request cache" I had in mind a
> slightly different way: to grow the req alloc cache to 32-128 (or hint
> from the userspace), batch-alloc by 8 as before, and recycle _all_ reqs
> right into it. If  overflows, do kfree().
> It should give probabilistically high hit rate, amortising out most of
> allocations. Pros: it doesn't grow ~infinitely as lists can. Cons: there
> are always counter examples. But as I don't have numbers to back it, I
> took your implementation. Maybe, we'll reconsider later.

It shouldn't grow bigger than what was used, but the downside is that
it will grow as big as the biggest usage ever. We could prune, if need
be, of course.

As far as I'm concerned, the hint from user space is the submit count.

> I'll revise tomorrow on a fresh head + do some performance testing,
> and is leaving it RFC until then.

I'll look too and test this, thanks!

-- 
Jens Axboe


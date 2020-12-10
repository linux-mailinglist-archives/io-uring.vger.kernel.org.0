Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91AA72D664E
	for <lists+io-uring@lfdr.de>; Thu, 10 Dec 2020 20:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389053AbgLJTWT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Dec 2020 14:22:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390474AbgLJTWK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Dec 2020 14:22:10 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5024FC0613CF
        for <io-uring@vger.kernel.org>; Thu, 10 Dec 2020 11:21:30 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id q1so6389614ilt.6
        for <io-uring@vger.kernel.org>; Thu, 10 Dec 2020 11:21:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NkJcDJp+JWTsWeBLXa3bcvnsV2pdxmFxdpPlYLoMu8U=;
        b=allGgmdfpdQyUkp9kJoIWela3l0YLQWg1i5zE0W42HOlI9zIq0ydO24/5s63WdbGnc
         oDtbdh7zVxO38mIVbNP5S6JovCiec9aZdiAOJAJfi8Y7ohBXfDuxglTLug6BvidYlQXp
         23+T5EeFPo7227M8xAitGzcDlkNZmAyBp+Fw72rrSKEIkNl1pNVvtCS+RO7DWiAMkyiT
         g6qEtsIkt1hkkPz0di9kSbj9+WbKajgWmRb7lqe6k2R9YbSjeCyYGbwdsn1CVq1XAaMF
         dOlVisEYI8t1pHtyps0XJRpjUSteYyEz548kgNux5JfM2zO+3fEcBC+Y9tCrWgOT3aM4
         GSBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NkJcDJp+JWTsWeBLXa3bcvnsV2pdxmFxdpPlYLoMu8U=;
        b=oGnkr28sp6AS1Q0IVi7vVYTu8SCKKRPGhfMCoO6pUNNvePIV24wCdciWdHrrEShjaI
         4uP4Fa9khIwMKUf9z1142+hsVd8nJnsbDhtV/p4SVC93QCw3mfLo2IbVsH69mN1iqAJt
         y6g/MOlDvdjVdDkIKimmpsSUJ7cYTqRGpnAqOUBSozMq70zzkUiQ3qGa0kOjovYMXQJo
         awznL3s/x7AIiQBpi+p6Gm6v1JZZ8F9MA7I3f9XpClCcS7wm/1k/cbhLINmjlLhlJT43
         qz18QsWyV7EbxIZ2JcIK37muL7gxmHR6HjUhxahvlodGIb7o35UAPEu5Hg7We8DZp8ck
         3MQg==
X-Gm-Message-State: AOAM532X650VFvjyBvGfTJTHuvpgnf7FbAoPAWmxOuHraGvi1FV4yNeS
        IzbVshZHpshUDtal5kvsNS0nOqEgNX1R2A==
X-Google-Smtp-Source: ABdhPJy0rxemf9twqLiD7Vj3SWdE25NQLaFt5KmvP8boROykqirC6dmBZOQYkb5POUvo5LQDOpqUHw==
X-Received: by 2002:a92:15c6:: with SMTP id 67mr10218677ilv.283.1607628089690;
        Thu, 10 Dec 2020 11:21:29 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w9sm3676174ilq.43.2020.12.10.11.21.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Dec 2020 11:21:29 -0800 (PST)
Subject: Re: namei.c LOOKUP_NONBLOCK (was "Re: [GIT PULL] io_uring fixes for
 5.10-rc")
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <6535286b-2532-dc86-3c6e-1b1e9bce358f@kernel.dk>
 <CAHk-=wjrayP=rOB+v+2eTP8micykkM76t=6vp-hyy+vWYkL8=A@mail.gmail.com>
 <4bcf3012-a4ad-ac2d-e70b-17f17441eea9@kernel.dk>
 <CAHk-=wimYoUtY4ygMNknkKZHqgYBZbkU4Koo5cE6ar8XjHkzGg@mail.gmail.com>
 <ad8db5d0-2fac-90b6-b9e4-746a52b8ac57@kernel.dk>
 <d7095e1d-0363-0aad-5c13-6d9bb189b2c8@kernel.dk>
 <CAHk-=wgyRpBW_NOCKpJ1rZGD9jVOX80EWqKwwZxFeief2Khotg@mail.gmail.com>
 <87f88614-3045-89bb-8051-b545f5b1180a@kernel.dk>
 <a522a422-92e3-6171-8a2e-76a5c7e21cfc@kernel.dk>
 <CAHk-=wicKF87YsiQpdK0B26Mk3UhRNrBEcOv7h=ohFKLjRM4DQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4790c746-0911-0bde-06fb-c987d6b0c3af@kernel.dk>
Date:   Thu, 10 Dec 2020 12:21:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wicKF87YsiQpdK0B26Mk3UhRNrBEcOv7h=ohFKLjRM4DQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/10/20 11:55 AM, Linus Torvalds wrote:
> On Thu, Dec 10, 2020 at 9:32 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Here's a potentially better attempt - basically we allow LOOKUP_NONBLOCK
>> with LOOKUP_RCU, and if we end up dropping LOOKUP_RCU, then we generally
>> return -EAGAIN if LOOKUP_NONBLOCK is set as we can no longer guarantee
>> that we won't block.
> 
> Looks sane to me.
> 
> I don't love the "__unlazy_walk vs unlazy_walk" naming - I think it
> needs to be more clear about what the difference is, but I think the
> basic patch looks sane, and looks about as big as I would have
> expected it to be.

Agree, would probably make more sense as __unlazy_walk ->
complete_walk_rcu(), which then also falls out naturally from
complete_walk() being the sole caller of that.

> But yes, I'll leave it to Al.
> 
> And if we do this - and I think we should - I'd also love to see a new
> flag in 'struct open_how' to openat2(), even if it's only to enable
> tests. RESOLVE_NONBLOCK?

Sure, enabling cached opens from userspace through regular openat2().
Let's wrap up this one first though, that needs to be a separate patch
anyway. I'll follow up with that once this is in.

-- 
Jens Axboe


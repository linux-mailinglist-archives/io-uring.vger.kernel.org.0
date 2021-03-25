Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD73E349B25
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 21:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbhCYUmp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 16:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbhCYUmV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 16:42:21 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F70C06175F
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 13:42:21 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id e8so3249609iok.5
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 13:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4nRDXN5ZDY+7KKmxTUW+rmie0dxhoxA0kTC6dcBSgSo=;
        b=RbYghPy1Bm1owuo3tqM6J9zY62L1j8IiWImX4GJ4EsjlHQjZdCJwN/gkI+zkNr3Hx2
         W4/cCQnVuTqPt34gfYrW0pL06I1m6GRYcMPhP7UON1hHHU2a9bvG4COfQDUZKzO6p5mY
         +PskVsjt1dgnXMqJIlywWm+8Glk/7oSAfQwOubTauDPQ+40YbQ2U0soX6ZEbMQyxp9qV
         xEK2yGpoX3fkYWhyje/72gifOtgQFyc0yO9sfW9KuizR6GD4EHikuUaf0wOq4K6qrfkV
         MLttVZSuigaNJ+pvvSzeUVpOEVguinyt+D8+Nxu+kpRluKR6V7h7USDAj+b9Dj/he1VH
         1QGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4nRDXN5ZDY+7KKmxTUW+rmie0dxhoxA0kTC6dcBSgSo=;
        b=VcD19KNiMveIoJTJdst+dTTk9quLqEfqBSpz36wVXbQteXupE6Jl6qc0Ww6F7tbekO
         TYyqQWGX85k1j96XsLxZYFmdguIw+KWiR9cKCQe17a96oFMWfhGZbHvgo2/6KbHrFoD/
         idfA9n/i14NSenMDf9AXmORI1HKxtevxqrpfqZ/iRfeZwZOTKzufy78lOCyeC25Ra4OF
         pvs3wolYDZx0pJZeDqzMY/FvlCjilJJqM3xXI+2tn+4S/cKnUJ7zXDf6QQc7j7AOqhaH
         cIPj5+6/+ufmunGJnQAU+QtB/r5PMvBekHrZXFc80rf6csUbGPgRHAnGwn1a5ELNdrm/
         hPKQ==
X-Gm-Message-State: AOAM5329cTE4iuzoheig++DGrF6VTY+9vzNahoYJHT0qA9Fhqkg42DBL
        8HWZNaxaVVhYfVaKG+3FuQevfw==
X-Google-Smtp-Source: ABdhPJwSc+xRhsScdj9Hyx0g484s2oNErl7cJWixKnaEF+SRQrneGxtBE+goFrn6ODVOHYoSWbp+Fg==
X-Received: by 2002:a05:6638:102f:: with SMTP id n15mr9107540jan.28.1616704940793;
        Thu, 25 Mar 2021 13:42:20 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j6sm2851060ila.31.2021.03.25.13.42.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 13:42:20 -0700 (PDT)
Subject: Re: [PATCH 0/2] Don't show PF_IO_WORKER in /proc/<pid>/task/
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Stefan Metzmacher <metze@samba.org>
References: <20210325164343.807498-1-axboe@kernel.dk>
 <m1ft0j3u5k.fsf@fess.ebiederm.org>
 <CAHk-=wjOXiEAjGLbn2mWRsxqpAYUPcwCj2x5WgEAh=gj+o0t4Q@mail.gmail.com>
 <CAHk-=wg1XpX=iAv=1HCUReMbEgeN5UogZ4_tbi+ehaHZG6d==g@mail.gmail.com>
 <3a1c02a5-db6d-e3e1-6ff5-69dd7cd61258@kernel.dk>
 <m1zgyr2ddh.fsf@fess.ebiederm.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <27a54fc2-865a-d90b-2429-d91170be5873@kernel.dk>
Date:   Thu, 25 Mar 2021 14:42:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <m1zgyr2ddh.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/25/21 2:21 PM, Eric W. Biederman wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 3/25/21 1:42 PM, Linus Torvalds wrote:
>>> On Thu, Mar 25, 2021 at 12:38 PM Linus Torvalds
>>> <torvalds@linux-foundation.org> wrote:
>>>>
>>>> I don't know what the gdb logic is, but maybe there's some other
>>>> option that makes gdb not react to them?
>>>
>>> .. maybe we could have a different name for them under the task/
>>> subdirectory, for example (not  just the pid)? Although that probably
>>> messes up 'ps' too..
>>
>> Heh, I can try, but my guess is that it would mess up _something_, if
>> not ps/top.
> 
> Hmm.
> 
> So looking quickly the flip side of the coin is gdb (and other
> debuggers) needs a way to know these threads are special, so it can know
> not to attach.
> 
> I suspect getting -EPERM (or possibly a different error code) when
> attempting attach is the right was to know that a thread is not
> available to be debugged.

But that's what's being returned right now, and gdb seemingly doesn't
really handle that. And even if it was just a gdb issue that could be
fixed it (it definitely is), I'd still greatly prefer not having to do
that. It just takes too long for packages to get updated in distros, and
it'd be years until it got fixed widely. Secondly, I'm even more worried
about cases that we haven't seen yet. I doubt that gdb is the only thing
that'd fall over, not expecting threads in there that it cannot attach
to.

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 761D91A3D57
	for <lists+io-uring@lfdr.de>; Fri, 10 Apr 2020 02:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgDJA3V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Apr 2020 20:29:21 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:32851 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgDJA3V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Apr 2020 20:29:21 -0400
Received: by mail-pg1-f195.google.com with SMTP id d17so292163pgo.0
        for <io-uring@vger.kernel.org>; Thu, 09 Apr 2020 17:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o5bTxsHNzSFWpkjJ+GjUZfzsw6Rc7hzmDSLj3sdh49E=;
        b=fN3JCMVVBffuFZPbZJR5IwLLjV+JdCBldxtNZuftqTRBaAlUcWUSOHlV5oc1IboQrk
         HguoARQJxf2KTCc+pe8uxGlRpTgt8lU8iCHWtFFlo0ryjhUv9ApHe6+EbMHmIc92Wte3
         YnuT5xkD+apdVUvZKz122OYv4EPl+5ZoCBbeBWH+H984liRqd/lLzzZJCeU0UQ3F32dD
         o89Xe5dHMy1MDL5aSk97C0ToSOvq84FZjkETIZrxdYY2HyxhbNv/VXEk945ooq+SUGP9
         FWNx0V2EnjhsBi/8TEPt3c7nJUgpR/5tgJ4FrbOIuWuTTZhjHDjRnaLJygGbXVg+GTQB
         3VQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o5bTxsHNzSFWpkjJ+GjUZfzsw6Rc7hzmDSLj3sdh49E=;
        b=ehDAcRPfXLp2eC2I3dTXGHqmEWAFEFpdsRRdYM9ldtZisDut9s6zEY6iEsCgZ2XYOF
         ppHCBuzt6x9Lnv7xYRAbort55FHdRFB/3ickLMwIcKUdgZGX6dDVBcwyYe3SXILeb123
         2pRnAyosC5797ciSRTM1zhBqbGYtrEqHUwbdwR/Tl1u9yjQ9Nd1nV01LrSmXGCO1uCyp
         SGA5ObKN7F/Qh+kcqZpDFuaQ9Utb7Fwq20VrDeacEKXET8wwhLZG3nBm+dwCtlM8TG9B
         ZE65kZOdg2V9ju0E+FhDUFr334mLUeyqLJmbmdW1qQlwRDOK96Mp9XOqHKdF/hV3FM/A
         8qFw==
X-Gm-Message-State: AGi0PubzYgkBP4u6Web/vceCOtKX3bUwKdb4S33mYBb5K6FZS2+KnoMA
        eri0ZHek3feYLnqsGdw8ZaqkrQ==
X-Google-Smtp-Source: APiQypKZPqWTuUOi25rFdvLjUZS1HOA5db9C3eYUyPJnPg6nDOz6GuOiqE6dWtyHJbAREEBc0TWXUA==
X-Received: by 2002:a63:fe54:: with SMTP id x20mr1906705pgj.195.1586478560098;
        Thu, 09 Apr 2020 17:29:20 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21c8::13d1? ([2620:10d:c090:400::5:c2d])
        by smtp.gmail.com with ESMTPSA id z15sm257183pfg.152.2020.04.09.17.29.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2020 17:29:19 -0700 (PDT)
Subject: Re: [PATCH 4/4] io_uring: flush task work before waiting for ring
 exit
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     io-uring@vger.kernel.org, viro@zeniv.linux.org.uk,
        Peter Zijlstra <peterz@infradead.org>
References: <20200407160258.933-1-axboe@kernel.dk>
 <20200407160258.933-5-axboe@kernel.dk> <20200407162405.GA9655@redhat.com>
 <20200407163816.GB9655@redhat.com>
 <4b70317a-d12a-6c29-1d7f-1394527f9676@kernel.dk>
 <20200408184049.GA25918@redhat.com>
 <a31dfee4-8125-a3c1-4be6-bd4a3f71b301@kernel.dk>
 <6d320b43-254d-2d42-cbad-d323f1532e65@kernel.dk>
 <20200408201734.GA21347@redhat.com>
 <884c70e0-2ec5-7ae6-7484-2bbbf4aa3e5d@kernel.dk>
 <20200409185041.GA14251@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7f735fcf-488e-2742-b180-4d5e9f6536d5@kernel.dk>
Date:   Thu, 9 Apr 2020 17:29:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200409185041.GA14251@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/9/20 11:50 AM, Oleg Nesterov wrote:
> On 04/08, Jens Axboe wrote:
>>
>> So the question remains, we basically have this:
>>
>> A			B
>> task_work_run(tsk)
>> 			task_work_add(tsk, io_poll_task_func())
>> process cbs
>> wait_for_completion()
>>
>> with the last wait needing to flush the work added on the B side, since
>> that isn't part of the initial list.
> 
> I don't understand you, even remotely :/
> 
> maybe you can write some pseudo-code ?

Sorry, I guess my explanation skills aren't stellar, or perhaps they
assume too much prior knowledge about this.

I just wasted about a day on debugging this because I had Peter's patch
applied, and I should have reviewed that more carefully. So a lot of the
hangs were due to just missing the running of some of the work.

> who does wait_for_completion(), a callback? or this "tsk" after it does
> task_work_run() ? Who does complete() ? How can this wait_for_completion()
> help to flush the work added on the B side? And why do you need to do
> something special to flush that work?

I'll try to explain this. Each io_uring operation has a request
associated with it. Each request grabs a reference to the ctx, and the
ctx can't exit before we reach zero references (obviously). When we
enter ctx teardown, we wait for us to hit zero references. Each ctx is
basically just a file descriptor, which means that we most often end up
waiting for zero references off the fput() path.

Some requests can spawn task_works work items. If we have ordering
issues on the task_works list, we can have the fput() ordered before
items that need to complete. These items are what ultimately put the
request, so you end up in a situation where you block waiting for
requests to complete, but these requests can't complete until the the
current work has completed. This is the deadlock.

Once I got rid of Peter's patch, I solved this by just making the
wait-and-free operation go async. This allows any dependent work to run
and complete just fine. Here's the patch:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.7&id=2baf397719af3a8121fcaba964470950356a4a7a

and I could perhaps make this smarter by checking if current->task_works
!= NULL, but I don't think there's much point to that. The important
part is that we complete the fput() task_work without blocking, so the
remaining work gets a chance to run.

Hope this helps! As mentioned in the commit message, we could have a
separate list of task_works for io_uring, which is what I originally
proposed. But I can also work around it like in the patch referenced
above.

-- 
Jens Axboe


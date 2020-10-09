Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00CA288C76
	for <lists+io-uring@lfdr.de>; Fri,  9 Oct 2020 17:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389236AbgJIPVa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Oct 2020 11:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387664AbgJIPVa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Oct 2020 11:21:30 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3645CC0613D2
        for <io-uring@vger.kernel.org>; Fri,  9 Oct 2020 08:21:28 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g9so7424163pgh.8
        for <io-uring@vger.kernel.org>; Fri, 09 Oct 2020 08:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1l5bQ+lqgCSA/OaJHeyIm/1E5UGT669jRSDiiWTQv9I=;
        b=brT8d82RuNrUqMXWLQfdFIuobfKiEJIqSIwJD8P+BnfqDb3rb8iuhuCoXdtHdH9tFh
         Pva7sJfJoXRCNIb6ZKbIQ2OM+6GTuJbzIijQBwTzaNCUhnq7ovAK6X5WYkV6iVdHb8O7
         biCufPq1qQLyo/3OgQ3z1QqGonl2Ts0G8YtrPjbKVwk7Lq7YydxQ5qDX6mmRGzTlssQU
         EX863ruA2BMcXl2pCSqsVtkJXLQGqw7/L+YGwgg6bdIu3TJLnDn7X39xJ+kvRZjIXYu7
         40ScFjJhy8xgya7iFVHluj7DYlCrkxomHZheUpmww4EnWGLjTc0vSmtz3vMu+CO/AVaQ
         wJMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1l5bQ+lqgCSA/OaJHeyIm/1E5UGT669jRSDiiWTQv9I=;
        b=HA1zCrLzT5WBa2CYjHSOeTa8ErWb2YlB052sUoJ8jEd0cSaQaXqtj9ijtH0qEne8mt
         ac8YU2e0V251ohd7I3NkoqShXa3RhoLGU7ji3kSLv9r6gYDKbZk7T70V/WEMKiTIrwHR
         rK/dMs6YhQ1ypkJfbnIwCQN3moGAWE45vvA+2VUGAeL9e1I0VB3UeGfret5HvBFF0Cbc
         6vWO0hlJwONcbQSe0Zz9qfOaYO5Cf6cdntgoVEFzbiPFQrSuzzMiZsc07bOQcAx1bhRs
         Vv1bwYFgK+63z7ciJQIIj41UsAWVHGy5b7OW+pd99Gwel+/98MCa69x70LjUuy7G2Zjb
         ProA==
X-Gm-Message-State: AOAM531SA4W+xCOpZUf3qENM1eq5VotikyN83B4v7ie7ievMs1NZ1F7G
        vA6/IS/SDwGB4WnLHSQdSUccEw==
X-Google-Smtp-Source: ABdhPJwUMZx9n5iEt9MhvI4G8mWEw6oBLxru3MuJM1VuUFIOvRfTfC6Jet8YwH35gE0WPxK1J+y/Cw==
X-Received: by 2002:a17:90b:4189:: with SMTP id hh9mr5249219pjb.199.1602256887739;
        Fri, 09 Oct 2020 08:21:27 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t13sm11594162pjo.15.2020.10.09.08.21.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 08:21:27 -0700 (PDT)
Subject: Re: [PATCHSET RFC v3 0/6] Add support for TIF_NOTIFY_SIGNAL
To:     Miroslav Benes <mbenes@suse.cz>, Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de,
        live-patching@vger.kernel.org
References: <20201005150438.6628-1-axboe@kernel.dk>
 <20201008145610.GK9995@redhat.com>
 <alpine.LSU.2.21.2010090959260.23400@pobox.suse.cz>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e33ec671-3143-d720-176b-a8815996fd1c@kernel.dk>
Date:   Fri, 9 Oct 2020 09:21:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.2010090959260.23400@pobox.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/9/20 2:01 AM, Miroslav Benes wrote:
> On Thu, 8 Oct 2020, Oleg Nesterov wrote:
> 
>> On 10/05, Jens Axboe wrote:
>>>
>>> Hi,
>>>
>>> The goal is this patch series is to decouple TWA_SIGNAL based task_work
>>> from real signals and signal delivery.
>>
>> I think TIF_NOTIFY_SIGNAL can have more users. Say, we can move
>> try_to_freeze() from get_signal() to tracehook_notify_signal(), kill
>> fake_signal_wake_up(), and remove freezing() from recalc_sigpending().
>>
>> Probably the same for TIF_PATCH_PENDING, klp_send_signals() can use
>> set_notify_signal() rather than signal_wake_up().
> 
> Yes, that was my impression from the patch set too, when I accidentally 
> noticed it.
> 
> Jens, could you CC our live patching ML when you submit v4, please? It 
> would be a nice cleanup.

Definitely, though it'd be v5 at this point. But we really need to get
all archs supporting TIF_NOTIFY_SIGNAL first. Once we have that, there's
a whole slew of cleanups that'll fall out naturally:

- Removal of JOBCTL_TASK_WORK
- Removal of special path for TWA_SIGNAL in task_work
- TIF_PATCH_PENDING can be converted and then removed
- try_to_freeze() cleanup that Oleg mentioned

And probably more I'm not thinking of right now :-)

-- 
Jens Axboe


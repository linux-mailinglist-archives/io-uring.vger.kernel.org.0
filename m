Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E48A1ED660
	for <lists+io-uring@lfdr.de>; Wed,  3 Jun 2020 20:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgFCSuO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Jun 2020 14:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgFCSuO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Jun 2020 14:50:14 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0BC2C08C5C0
        for <io-uring@vger.kernel.org>; Wed,  3 Jun 2020 11:50:13 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id r15so3176037wmh.5
        for <io-uring@vger.kernel.org>; Wed, 03 Jun 2020 11:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z8tDOVt0rhkMdcJxcJyspJUzVLPi4NBwq6IpZU0viTI=;
        b=R+dtNnR890Y+ddXXBPM2h14cmAopONfajCh/7L2aCZsavbSmXEjxDN6eR1LVdxRVVK
         Al4fSd1kSUr1kWG9u1gRdadx4lSjXcyKrbmpNtYICUWiIKlvuenei1LWHY0WEIEqXjwQ
         TcQ8n/zcS7uV7+o6c5MkEn9BDDm7mTN9Q4GcMiydXT8izjHiJOuIb5LdarTzTbcFCRzu
         cu0CaQXWOV4AX83/Kkc9EEt3eL48yEYdX42T5F2KgDRfWLxQ/DMowxIJQqAj+HUyPulZ
         2BF3TQ7rnwSXAp5+9Tin4Vq7ZGurm7/qaCOy2qhem+SAa13cSid3Z/8hr5ephFvtqx7k
         aw5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=z8tDOVt0rhkMdcJxcJyspJUzVLPi4NBwq6IpZU0viTI=;
        b=eiYdJCjeDIyWLMrmzuTwBqUuRuX2Tfob570hFyrAaxdYPJeAH2OKEUghmDBi/KRrgV
         Rd4iWhgSUvUT425/ImXZGTmFFI1SR9/A0h7fz1AK8FZYINu/TsxDJScBOfCo0y0XOMyN
         PRO3Q3zoS/6/13GHUdKfyBfj3xv9fCVn5otRFWNTqFW9NPAT5bP9B8VCFmojx4Xohlpk
         oiTB/RuXnJh1rN1/s/BLYSHVmupfuGTreIK/Bksm+20rGlQtt8EzHari+ZOQya7kvWLC
         ZO5hrE0veXfzApOtIZC3s4iN4MbwnOWbTb2LvulkWDKKJMP+x1OTSJV+MyfhUxbRXHvq
         H9IA==
X-Gm-Message-State: AOAM531wL2TkzXpV3v4Uue0rcVkQBWGo3ugMJici1lJ8WLLCXCy6sXOO
        NK7RdbRYhXvRQ8QoWLNieDvBPw0K
X-Google-Smtp-Source: ABdhPJz4pOJN7VsRMKRxR6rvJuS7fFo4UYVHMOwk0UNtBoglkHauAG3q7c/fSJHMQraupy7UycwKcw==
X-Received: by 2002:a7b:c852:: with SMTP id c18mr496215wml.77.1591210212432;
        Wed, 03 Jun 2020 11:50:12 -0700 (PDT)
Received: from [192.168.43.207] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id b132sm4178545wmh.3.2020.06.03.11.50.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2020 11:50:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com, yujian.wu1@gmail.com
References: <20200520115648.6140-1-xiaoguang.wang@linux.alibaba.com>
 <3bea8be7-2a82-cf24-a8b6-327672a64535@gmail.com>
 <242c17f3-b9b3-30cb-ff3d-a33aeef36ad1@linux.alibaba.com>
 <13dd7a1f-63df-6a0c-74ed-d5ff12a0bf96@gmail.com>
 <c077a2dc-7b69-5ee4-24a3-3dd3df57b201@linux.alibaba.com>
 <e3c81737-ef46-37a1-9c64-b307278ca65f@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: create percpu io sq thread when
 IORING_SETUP_SQ_AFF is flagged
Message-ID: <02fddee0-fc7f-03cd-6864-db78d8749cfa@gmail.com>
Date:   Wed, 3 Jun 2020 21:48:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <e3c81737-ef46-37a1-9c64-b307278ca65f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 03/06/2020 17:47, Pavel Begunkov wrote:
> On 26/05/2020 17:42, Xiaoguang Wang wrote:
>> Yes, I don't try to make all io_uring instances in the system share threads, I just
>> make io_uring instances which are bound to same cpu core, share one io_sq_thread that
>> only is created once for every cpu core.
>> Otherwise in current io_uring mainline codes, we'd better not bind different io_uring
>> instances to same cpu core,  some instances' busy loop in its sq_thread_idle period will
>> impact other instanes who currently there are reqs to handle.
> 
> I got a bit carried away from your initial case, but there is the case:
> Let's we have 2 unrelated apps that create SQPOLL io_uring instances. Let's say they are
> in 2 different docker container for the argument (and let's just assume a docker container
> user can create such).
> 
> The first app1 submits 32K fat requests as described before. The second one (app2) is a
> low-latency app, submits reqs by 1, but expects it to be picked really fast. And let's
> assume their SQPOLL threads pinned to the same CPU.
> 
> 1. old version:
> The CPU spends some time allocated by a scheduler on 32K requests of app1,
> probably not issuing them all but that's fine. And then it goes to the app2.
> So, the submit-to-pickup latency for app2 is capped by a task scheduler.
> That's somewhat fair. 
> 
> 2. your version:
> io_sq_thread first processes all 32K of requests of app1, and only then goes to app2.
> app2 is screwed, unfair as life can be. And a malicious user can create many io_uring
> instances as in app1. So the latency will be further multiplied.
> 
> 
> Any solution I can think of is ugly and won't ever land upstream. Like creating your
> own scheduling framework for io_uring, wiring kindof cgroups, etc. And actually SQPOLL
> shouldn't be so ubiquitous (+needs privileges). E.g. I expect there will be a single
> app per system using it, e.g. a database consuming most of the resources anyway.
> And that's why I think it's better to not trying to solve your original issue.
> 
> 
> However, what the patch can be easily remade into is sharing an SQPOLL thread between
> io_uring instances of a single app/user, like passing fd described before.
> The most obvious example is to share 1 SQPOLL thread (or N << num_cpus) between all
> user threads, so
> - still creating io_uring per thread to not synchronise SQ
> - retaining CPU time for real user work (instead of having N SQPOLL threads)
> - increasing polling efficiency (more work -- less idle polling)
> - and scheduling/task migration, etc.
> 

Just to add a thing, basically this doesn't differ much from having 1 io_uring
per bunch of threads but replacing SQ synchronisation with the round-robin polling.
If going this way, it'd need a thorough evaluation of performance benefits (if any).

> 
> note: would be great to check, that it has all necessary cond_resched()
> 

-- 
Pavel Begunkov

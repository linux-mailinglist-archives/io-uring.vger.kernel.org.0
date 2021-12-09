Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2529046EA8A
	for <lists+io-uring@lfdr.de>; Thu,  9 Dec 2021 16:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238885AbhLIPHI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Dec 2021 10:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239135AbhLIPHI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Dec 2021 10:07:08 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC837C061746
        for <io-uring@vger.kernel.org>; Thu,  9 Dec 2021 07:03:34 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id az34-20020a05600c602200b0033bf8662572so4351712wmb.0
        for <io-uring@vger.kernel.org>; Thu, 09 Dec 2021 07:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=u4RmT8kOFvwcxv7ra0GkwyxAvHqYWTgFswfs1FLH9EM=;
        b=gq0s4CmmyVj8OMppjTCqylYxOVc7VzqcY88y+bhv9qQHblzSHmaUE5lHQBiNuf2XT3
         GQU+d8o8usEWwyJeOciBfDOT/20mh+Tk1B1M6/dvO7VZ7mlpgQKHyli4iXQ60EjKSzVn
         oIX73Pk9FiI4tXFk/CM3bFq+M+9Ry4TYJ6WInKItcmo2yP/DxJaynXXKFsYl39sV2yQQ
         qitfh6T9+jhQC/19aasIQLuI3avtvW31NxLOwulVdFMWC8ousAeg7hIzVBmcV6+33zKF
         j+r0x8Bjk/JopSAu8lTx4CgdUfdOcOp+4oFGsprpfZ7ld+4ApQYMFzR4BXdgpE0ZH1xL
         LSkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=u4RmT8kOFvwcxv7ra0GkwyxAvHqYWTgFswfs1FLH9EM=;
        b=SVNA5CwCEd4ckSgF66FHG9eEVPXGfjB4stGpOQWD92PPOy6oYxwznWwEHR5CZGdmri
         6kTykGTojWnu1Vdofk5Hah84d5WCov9V+8OvmHweuf7fuklwbNoFJjSytvrCBp8wbfMe
         xX2Qkr5KGtuWzyDDZ8VbDbeFSW5LCGEau3+9xA5j7RpBq9zm0rVZIobLntu7hEF3Lf9Z
         HTbfreOwx9y0/JkWVB+chslgRTBXPhe/a/s5LXR9VB2gLF2PRYypsJ6xLQq2kubbNu1a
         VNS2Vp+Xie1ZkVPlCgkw+JliY1M1WZbrzlnZsvlJCMCzwB7uG0ucIldZ160SqZ4xKq9l
         2KKQ==
X-Gm-Message-State: AOAM532K2p+mxkFBWegFQEc9ExRfhgx5wcYmUAWvFTCEcx3f5P9zn1m/
        /LD3MyXue3zhShnFsNgbez7nRVK/c0o=
X-Google-Smtp-Source: ABdhPJxyS7x2/4RC5ndwcSd2SCfM187k3PccFe5GUY+iALF+lJk2KL52/laThwK376Iso2YiOpNRkg==
X-Received: by 2002:a7b:c1d5:: with SMTP id a21mr7967448wmj.14.1639062213440;
        Thu, 09 Dec 2021 07:03:33 -0800 (PST)
Received: from [192.168.43.77] (82-132-228-153.dab.02.net. [82.132.228.153])
        by smtp.gmail.com with ESMTPSA id n184sm9073420wme.2.2021.12.09.07.03.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 07:03:32 -0800 (PST)
Message-ID: <024aae30-1fdc-f51b-7744-9518a39cbb19@gmail.com>
Date:   Thu, 9 Dec 2021 15:02:12 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: happy io_uring_prep_accept_direct() submissions go hiding!
Content-Language: en-US
To:     jrun <darwinskernel@gmail.com>, io-uring <io-uring@vger.kernel.org>
References: <20211208190733.xazgugkuprosux6k@p51>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211208190733.xazgugkuprosux6k@p51>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/8/21 19:07, jrun wrote:
> hello,
> 
> - this may very well be something simple i'm missing so apologies in advance. -
> 
> _some_ calls to io_uring_prep_accept_direct() never make it back from
> kernel! or they seems so... since io_uring_prep_accept_direct() is a new
> introduction to io_uring i thought i check with you first and get some help if
> possible.

Don't see how a CQE may get missing, so let me ask a bunch of questions:

First, let's try out my understanding of your problem. At the beginning you
submit MAX_CONNECTIONS/2 accept requests and _all_ of them complete. In the main
loop you add another bunch of accepts, but you're not getting CQEs from them.
Right?

1) Anything in dmesg? Please when it got stuck (or what the symptoms are),
don't kill it but wait for 3 minutes and check dmesg again.

Or you to reduce the waiting time:
"echo 10 > /proc/sys/kernel/hung_task_timeout_secs"

And then should if anything wrong it should appear in dmesg max in 20-30 secs

2) What kernel version are you running?

3) Have you tried normal accept (non-direct)?

4) Can try increase the max number io-wq workers exceeds the max number
of inflight requests? Increase RLIMIT_NPROC, E.g. set it to
RLIMIT_NPROC = nr_threads + max inflight requests.

5) Do you get CQEs when you shutdown listening sockets?

6) Do you check return values of io_uring_submit()?

7) Any variability during execution? E.g. a different number of
sockets get accepted.


> ---------
> TEST_PROG:
> ---------
> 
> this msg has a git repo bundled which has the crap i've put together where i
> encounter this. to compile/run it do this, save the bundle somewhere, say under
> `/tmp/` and then do:
> 
> ```
> cd /tmp/
> git clone wsub.git wsub
> cd wsub
> # maybe have a look at build.sh before running the following
> # it will install a single binary under ~/.local/bin
> # also it will fire up the binary, the server part, wsub, right away
> sh build.sh
> 
> # then from a different terminal
> cd /tmp/wsub/client
> # in zsh, use seq for bash
> MAX_CONNECTIONS=4; for i in {0..$MAX_CONNECTIONS}; do ./client foo; done
> ```
> 
> srv starts listening on a *abstract* unix socket, names after the binary which
> should turn up in the output of this, if you have ss(8) installed:
> 
> `ss -l -x --socket=unix_seqpacket`
> it will be called `@wsub` if you don't change anything.
> 
> client bit just sends it's first arg, "foo" in this case, to the server, and
> srv prints it out into it's stderr.
> 
> 
> --------
> PROBLEM:
> --------
> 
> every calls to io_uring_prep_accept_direct() via q_accept(), before entering
> event_loop(), main.c:587, get properly completed, but subsequent calls to
> io_uring_prep_accept_direct() after entering event_loop(),
> main.c:487 `case ACCEPT:`,
> never turn up on ring's cq! you will notice that all other submissions inside
> event_loop(), to the same ring, get completed fine.
> 
> note also that io_uring_prep_accept_direct() completions make it once there is a
> new connection!
> 
> running the client bit one-by-one might illustrate the point better.
> 
> i also experimented with using IORING_SETUP_SQPOLL, different articles but same
> result for io_uring_prep_accept_direct() submissions.
> 
> thoughts?
> 
> 
> 	- jrun
> 

-- 
Pavel Begunkov

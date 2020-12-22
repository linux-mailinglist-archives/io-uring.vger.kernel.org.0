Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8852E0D74
	for <lists+io-uring@lfdr.de>; Tue, 22 Dec 2020 17:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbgLVQhp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Dec 2020 11:37:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727696AbgLVQho (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Dec 2020 11:37:44 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6EFC0613D6
        for <io-uring@vger.kernel.org>; Tue, 22 Dec 2020 08:37:03 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id 190so2370037wmz.0
        for <io-uring@vger.kernel.org>; Tue, 22 Dec 2020 08:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3I5jqFQkorC38cPpYAhnM8U9WSeaLTli3FZdxJpsWmw=;
        b=MICL13B/MsJ/AnHEbQS5S4m/dwvd5SPp3RcGYbdj0OoQbxOMmGv1w6M+8FyfHM6lt4
         bjZhtQm5U18fA81jS1u4enUxhHH42VK22qZjckWqqWaEWW45OEFlVtKZlv3GRC3CHQOG
         DEJNTeoxKChuvv8r10mQEiEbTfeiUL+p9E+AnCGYYIbtqaRRfgkhAMMSmGybqY1+JWoU
         9UseBCo1rjvSZ3zlul33SkgKs7Qffmwl3ehqm8U99uUaWDBMZ8fplbZP418KSED3TJC+
         rBrv0yj+mPVMSnbqo0/NIQmqE1cqscKKdJp/k0wPFlvmJtjDheuKb+xUYywKmKpjdy6k
         o5BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=3I5jqFQkorC38cPpYAhnM8U9WSeaLTli3FZdxJpsWmw=;
        b=oBovQWMOOGdfupiBbev2NgVqgURKy1LQ8+P7IGbZo5N3ndKek5BEP9QwjFeKwlOEgA
         9I9aJKeMBcA6zKXhs6E4g3Y99TvYI5gdU5q6O4aojV2TnXc/Z4V5PdxUwJlceGCNqiCQ
         OMHr5/wjiBARvMUGXV5fKEDsqwALVyj9UB0GbbezcQqKixWFCHZlapd+qBLmehzJxyO6
         Gbm4MJmbhz0rjc7/o+bR1YpA5p3kejqh/XDIgbAwW+kcyTF9SRMV/PZ4cm2YnEVdz3H1
         OHl8f0WT5Bhmja0HlOSHDxxgtN1aBgTt6jRyx7vL8RSKTZj+iVInIj6Ak3MiRevmb/A1
         YYfA==
X-Gm-Message-State: AOAM530+2SejnGwbsfLOBanokzhLvSPmICOQhTTaU5rahYSOUUehgtA/
        0+xQLf+h6ZoNCatdq4cJFyUOvted22YXLg==
X-Google-Smtp-Source: ABdhPJxeNqLWh72qP+RbBFEuYxSXeqSTuFAGXJJHfDbdeeQ+knBwNOHjwP5sAI7H8AEKdc6YGeE/KA==
X-Received: by 2002:a1c:7201:: with SMTP id n1mr22311836wmc.139.1608655022153;
        Tue, 22 Dec 2020 08:37:02 -0800 (PST)
Received: from [192.168.8.148] ([185.69.145.156])
        by smtp.gmail.com with ESMTPSA id o83sm27524859wme.21.2020.12.22.08.37.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Dec 2020 08:37:01 -0800 (PST)
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Josef <josef.grieb@gmail.com>,
        Norman Maurer <norman.maurer@googlemail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
 <2B352D6C-4CA2-4B09-8751-D7BB8159072D@googlemail.com>
 <d9205a43-ebd7-9412-afc6-71fdcf517a32@kernel.dk>
 <CAAss7+ps4xC785yMjXC6u8NiH9PCCQQoPiH+AhZT7nMX7Q_uEw@mail.gmail.com>
 <0fe708e2-086b-94a8-def4-e4ebd6e0b709@kernel.dk>
 <614f8422-3e0e-25b9-4cc2-4f1c07705ab0@kernel.dk>
 <986c85af-bb77-60d4-8739-49b662554157@gmail.com>
 <e88403ad-e272-2028-4d7a-789086e12d8b@kernel.dk>
 <2e968c77-912d-6ae1-7000-5e34eb978ab5@gmail.com>
 <CAOKbgA5YD_MxY-RqJzP7eqdkqrnQCgjRin7w29QtszHaCJqwrg@mail.gmail.com>
 <CAOKbgA7TyscndB7nn409NsFfoJriipHG80fgh=7SRESbiguNAg@mail.gmail.com>
 <58bd0583-5135-56a1-23e2-971df835824c@gmail.com>
 <da4f2ac2-e9e0-b0c2-1f0a-be650f68b173@gmail.com>
 <CAOKbgA7shBKAnVKXQxd6PadiZi0O7UZZBZ6rHnr3HnuDdtx3ng@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
Message-ID: <c4837bd0-5f19-a94d-5ffb-e59ae17fd095@gmail.com>
Date:   Tue, 22 Dec 2020 16:33:39 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAOKbgA7shBKAnVKXQxd6PadiZi0O7UZZBZ6rHnr3HnuDdtx3ng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 22/12/2020 11:04, Dmitry Kadashev wrote:
> On Tue, Dec 22, 2020 at 11:11 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
[...]
>>> What about smaller rings? Can you check io_uring of what SQ size it can allocate?
>>> That can be a different program, e.g. modify a bit liburing/test/nop.
> Unfortunately I've rebooted the box I've used for tests yesterday, so I can't
> try this there. Also I was not able to come up with an isolated reproducer for
> this yet.
> 
> The good news is I've found a relatively easy way to provoke this on a test VM
> using our software. Our app runs with "admin" user perms (plus some
> capabilities), it bumps RLIMIT_MEMLOCK to infinity on start. I've also created
> an user called 'ioutest' to run the check for ring sizes using a different user.
> 
> I've modified the test program slightly, to show the number of rings
> successfully
> created on each iteration and the actual error message (to debug a problem I was
> having with it, but I've kept this after that). Here is the output:
> 
> # sudo -u admin bash -c 'ulimit -a' | grep locked
> max locked memory       (kbytes, -l) 1024
> 
> # sudo -u ioutest bash -c 'ulimit -a' | grep locked
> max locked memory       (kbytes, -l) 1024
> 
> # sudo -u admin ./iou-test1
> Failed after 0 rings with 1024 size: Cannot allocate memory
> Failed after 0 rings with 512 size: Cannot allocate memory
> Failed after 0 rings with 256 size: Cannot allocate memory
> Failed after 0 rings with 128 size: Cannot allocate memory
> Failed after 0 rings with 64 size: Cannot allocate memory
> Failed after 0 rings with 32 size: Cannot allocate memory
> Failed after 0 rings with 16 size: Cannot allocate memory
> Failed after 0 rings with 8 size: Cannot allocate memory
> Failed after 0 rings with 4 size: Cannot allocate memory
> Failed after 0 rings with 2 size: Cannot allocate memory
> can't allocate 1
> 
> # sudo -u ioutest ./iou-test1
> max size 1024

Then we screw that specific user. Interestingly, if it has CAP_IPC_LOCK
capability we don't even account locked memory.

btw, do you use registered buffers?

> 
> # ps ax | grep wq
>     8 ?        I<     0:00 [mm_percpu_wq]
>   121 ?        I<     0:00 [tpm_dev_wq]
>   124 ?        I<     0:00 [devfreq_wq]
> 20593 pts/1    S+     0:00 grep --color=auto wq
> 

-- 
Pavel Begunkov

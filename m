Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5A82DF065
	for <lists+io-uring@lfdr.de>; Sat, 19 Dec 2020 17:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgLSQOl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Dec 2020 11:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbgLSQOl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Dec 2020 11:14:41 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E121C0613CF
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 08:14:01 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id r4so3064603pls.11
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 08:14:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M8nCqT9Pcxt3I8pzWGTXiD6Arctbr4Ob7zfGhh5XukU=;
        b=OmJa7G62xRQ48XDA+zbyScct6CtvVnLSl36Jp4a/mgkQrEIfsE0QQtoMVOqVNq8HNn
         +ZNHyrom10J4IcONVMiTCAIXYbxmEr6ZRTAXxVhHviBv9MfH7NYc/Ht5Eb7WUKUAN75s
         k/vO87QV0TSWMXZ/Ee3x02Rtxzmh4kkc/iEP9BdkSp2J5c0kFArVbWUhll3bgM97bp5X
         eBMwvTSp2UHMDWSK2ywlnB77YkVN83JauoHXflzB8zMGLzoKAqfaRx0ovUwMbeIOGJqW
         Dee8BLDLi4/0JzJV+foLiObUhIxrLRTEx8hx4S5zlgoXVE5fp3Y860aE4PQNUTA0fPVG
         oGdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M8nCqT9Pcxt3I8pzWGTXiD6Arctbr4Ob7zfGhh5XukU=;
        b=nIYJuNAztNJM3j8yh21uh6OXd6DoF5IxQFuQ2UkPu2pzd+U25lerjqPI3Ps8xGv1UI
         6YgN7Aefq94foxYghonCqPbQZi7u03myJqZcz6kQmGBrcVyOntHsqeRTM3F/Ti5rfFJB
         iwhxZ5HcwxzT32P4dZsJfgiL0E4DgaeYgTDu5STCSmvDFcuiwb1jVbKOhM1is+ZlOgIj
         7Mynxto/46nBpknkFkJlIzMDw1MA9V0cY5CB3+Y3AL7mxuZxGbViGLBxjEIaOOWUgDtF
         nnExndeFDXQrEHLDWgI8fURAdm7rXiUXmvs9IyvFfMhpsYpO7aKw5LlWTCPpUKTT7d5f
         wM9g==
X-Gm-Message-State: AOAM533u1Lq5yineCbraIwNnofk4mrhuGNX+4gfqQgp03JZd/cEqDpv1
        EbnyVR6+vaF+oki2FZJlOMCcW6sK6bbfXQ==
X-Google-Smtp-Source: ABdhPJzxfyVKNnhoePXZCle4UOMN8a+eVERgk6nzwfpygE9KrCiz77KqGcwwNqQko2/sl8qLQc1ckA==
X-Received: by 2002:a17:90a:cb8b:: with SMTP id a11mr9596939pju.3.1608394439477;
        Sat, 19 Dec 2020 08:13:59 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j1sm11900389pfd.181.2020.12.19.08.13.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Dec 2020 08:13:58 -0800 (PST)
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Josef <josef.grieb@gmail.com>
Cc:     Dmitry Kadashev <dkadashev@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        Norman Maurer <norman.maurer@googlemail.com>
References: <CAOKbgA66u15F+_LArHZFRuXU9KAiq_K0Ky2EnFSh6vRv23UzSw@mail.gmail.com>
 <7d263751-e656-8df7-c9eb-09822799ab14@kernel.dk>
 <CAAss7+oi9LFaPpXfdCkEEzFFgcTcvq=Z9Pg7dXwg5i=0cu-5Ug@mail.gmail.com>
 <caca825c-e88c-50a6-09a8-c4ba9d174251@kernel.dk>
 <CAAss7+rwgjo=faKi2O7mUSJTWrLWcOrpyb7AESzaGw+_fWq1xQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <159a8a38-4394-db3b-b7f2-cc26c39caa07@kernel.dk>
Date:   Sat, 19 Dec 2020 09:13:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+rwgjo=faKi2O7mUSJTWrLWcOrpyb7AESzaGw+_fWq1xQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/18/20 7:49 PM, Josef wrote:
>> I'm happy to run _any_ reproducer, so please do let us know if you
>> manage to find something that I can run with netty. As long as it
>> includes instructions for exactly how to run it :-)
> 
> cool :)  I just created a repo for that:
> https://github.com/1Jo1/netty-io_uring-kernel-debugging.git
> 
> - install jdk 1.8
> - to run netty: ./mvnw compile exec:java
> -Dexec.mainClass="uring.netty.example.EchoUringServer"
> - to run the echo test: cargo run --release -- --address
> "127.0.0.1:2022" --number 200 --duration 20 --length 300
> (https://github.com/haraldh/rust_echo_bench.git)
> - process kill -9
> 
> async flag is enabled and these operation are used: OP_READ,
> OP_WRITE, OP_POLL_ADD, OP_CLOSE, OP_ACCEPT
> 
> (btw you can change the port in EchoUringServer.java)

This is great! Not sure this is the same issue, but what I see here is
that we have leftover workers when the test is killed. This means the
rings aren't gone, and the memory isn't freed (and unaccounted), which
would ultimately lead to problems of course, similar to just an
accounting bug or race.

The above _seems_ to be related to IOSQE_ASYNC. Trying to narrow it
down...

-- 
Jens Axboe


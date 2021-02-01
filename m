Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09EF30A612
	for <lists+io-uring@lfdr.de>; Mon,  1 Feb 2021 12:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbhBALBM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 06:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232946AbhBALBH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Feb 2021 06:01:07 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4E6C061756
        for <io-uring@vger.kernel.org>; Mon,  1 Feb 2021 03:00:22 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id u14so12769644wmq.4
        for <io-uring@vger.kernel.org>; Mon, 01 Feb 2021 03:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BGBR3ebFY2flu6GN3JVVtocVQDlAb812qllUf95BsSE=;
        b=WYdzUkbCuLQtwWExi5/cPBqemV2Jr8cJZArMOoxAGlNRnNa53tMMbaCypOoT9xIjCm
         HA+aYUkuASMx55OUSKqY5YcE7yn5pZ+ALFtYFWOC+l96ybXOIGj1fk15Y6pal2Q0IQ6W
         Iken/FFpWsdge+/kP0GZa2EAfKgkJg1ckEf6IYhfsD9N25dWZ1rsHrysq5Bi78VK5JnG
         BnQVuiEIceb3P22sm7/1Zomv0Q85oELDe9WsE+mA195jCbFsnyiNg2gtJJXxH/Jjpo+9
         XGL6E3TmKtXuimbOpkTlikHJNV1yi1Suv6kqbenuEaAco+cszKSJW0pcxpVbyn72/4dS
         r7lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BGBR3ebFY2flu6GN3JVVtocVQDlAb812qllUf95BsSE=;
        b=TTTYgunRB4Lyoa2yDcWcZRR5dFVmH8zkHI6CzY8CXfnBV61AEYxUtutPxF6v34GJpv
         sHM4OARzReCQtBGqLgDQUg3A3BBvlqMK/Y+kydVQ4qT4/PDUwm4tyC5OohdKaPrubhrj
         vnM3RLRYxAvw0nGTP2Q6ajziLZNwLRbIhD5+3JgmkTILRYi/jXLdSbF/ajmovVlvomU1
         a4djuIdHCaW77boLNmpScu/SkSyZ6aZrT4pDihxaPQOL8MxD9k3PizRNkz9bqrU13GFq
         0aZr/ER1+2N9pBuIgmrgGA+BpvaJ4wLeALcIYZbM2ju5MF/jKmLNXAs39oZmgZOEY3Mc
         bdUA==
X-Gm-Message-State: AOAM533baasq2brLpHqccVPi4X7uHKaDtejCpZDf4eVC8LcgLnIRfM83
        GqR86itdkb6yWUkSdciln3BGxYMLNnQ=
X-Google-Smtp-Source: ABdhPJw22V8+inHzY+SAxoPexmiI0sP0qyGqyO0WUh7H56xI07BJMOSwK+PD9+TtarlrIN+X01jScw==
X-Received: by 2002:a7b:c77a:: with SMTP id x26mr5650455wmk.143.1612177220631;
        Mon, 01 Feb 2021 03:00:20 -0800 (PST)
Received: from [192.168.8.166] ([185.69.145.241])
        by smtp.gmail.com with ESMTPSA id m22sm27059409wrh.66.2021.02.01.03.00.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 03:00:20 -0800 (PST)
Subject: Re: tcp short writes / write ordering / etc
To:     dormando <dormando@rydia.net>, io-uring <io-uring@vger.kernel.org>
References: <855d3bc1-f694-e42e-283e-f8ee8f9c8e6e@rydia.net>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <1334b5e5-5286-6c4e-3125-fa99eaadfba2@gmail.com>
Date:   Mon, 1 Feb 2021 10:56:38 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <855d3bc1-f694-e42e-283e-f8ee8f9c8e6e@rydia.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 31/01/2021 09:10, dormando wrote:
> Hey,
> 
> I'm trying to puzzle out an architecture on top of io_uring for a tcp
> proxy I'm working on. I have a high level question, then I'll explain what
> I'm doing for context:
> 
> - How (is?) order maintained for write()'s to the same FD from different
> SQE's to a network socket? ie; I get request A and queue a write(), later

Without IOSQE_LINK or anything -- no ordering guarantees. Even if CQEs came
in some order actual I/O may have been executed in reverse.

> request B comes in and gets queued, A finishes short. There was no chance
> to IOSQE_LINK A to B. Does B cancel? This makes sense for disk IO but I
> can't wrap my head around it for network sockets.
> 
> The setup:
> 
> - N per-core worker threads. Each thread handles X client sockets.
> - Y backend sockets in a global shared pool. These point to storage
> servers (or other proxyes/anything).
> 
> - client sockets wake up with requests for an arbitrary number of keys (1
> to 100 or so).
>   - each key is mapped to a backend (like keyhash % Y).
>   - new requests are dispatched for each key to each backend socket.
>   - the results are put back into order and returned to the client.
> 
> The workers are designed such that they should not have to wait for a
> large request set before processing the next ready client socket. ie;
> thread N1 gets a request for 100 keys; it queues that work off, and then
> starts on a request for a single key. it picks up the results of the
> original request later and returns it. Else we get poor long tail latency.
> 
> I've been working out a test program to mock this new backend. I have mock
> worker threads that submit batches of work from fake connections, and then
> have libevent or io_uring handle things.
> 
> In libevent/epoll mode:
>  - workers can directly call write() to backend sockets while holding a
> lock around a descriptive structure. this ensures order.
>  - OR workers submit stacks to one or more threads which the backends
> sockets are striped across. These threads lock and write(). this mode
> helps with latency pileup.
>  - a dedicated thread sits in epoll_wait() on EPOLLIN for each backend
> socket. This avoids repeated calls to epoll_add()/mod/etc. As responses
> are parsed, completed sets of requests are shipped back to the worker
> threads.
> 
> In uring mode:
>  - workers should submit to a single (or few) threads which have a private
> ring. sqe's are stacked and submit()'ed in a batch. Ideally saving all of
> the overhead of write()'ing to a bunch of sockets. (not working yet)
>  - a dedicated thread with its own ring is sitting on recv() for each
> backend socket. It handles the same as epoll mode, except after each read
> I have to re-submit a new SQE for the next read.
> 
> (I have everything sharing the same WQ, for what it's worth)
> 
> I'm trying to figure out uring mode's single submission thread, but
> figuring out the IO ordering issues is blanking my mind. Requests can come
> in interleaved as the backends are shared, and waiting for a batch to
> complete before submitting the next one defeats the purpose (I think).
> 
> What would be super nice but I'm pretty sure is impossible:
> 
> - M (possibly 1) thread(s) sitting on recv() in its own ring
> - N client handling worker threads with independent rings on the same WQ
>  - SQE's with writes to the same backend FD are serialized by a magical
> unicorn.
> 
> Then:
> - worker with a request for 100 keys makes and submits the SQE's itself,
>   then moves on to the next client connection.
> - recv() thread gathers responses and signals worker when the batch is
> complete.
> 
> If I can avoid issues with short/colliding writes I can still make this
> work as my protocol can allow for out of order responses, but it's not the
> default mode so I need both to work anyway.
> 
> Apologies if this isn't clear or was answered recently; I did try to read
> archives/code/etc.

-- 
Pavel Begunkov

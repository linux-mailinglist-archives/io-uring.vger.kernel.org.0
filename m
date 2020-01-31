Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 255FB14F3C9
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 22:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgAaVcY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 16:32:24 -0500
Received: from mail-pg1-f171.google.com ([209.85.215.171]:45038 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgAaVcY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 16:32:24 -0500
Received: by mail-pg1-f171.google.com with SMTP id x7so4142442pgl.11
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2020 13:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XyFA36WxUtgN1B6uI/dhE/JlFw5l7tRA6v/t9YsZ+4Y=;
        b=1xEOD17FFwIS8nQeoUgkw25qZ9S3mjwlnxclYFqCV7Mn1dWiDr18EUry59fS4tajRd
         avmrAy7klh6lZK7FgCpyHlMQoQN2qxJ7H/3e8AWJ45qn/irosuPX25rTApTlQA8cT+ZM
         cUNjFlsdbZPm5QJA42yplQgd92FRfZpBhTyP4+DEzD47O+TiM6LjonwmDp2USGbI9JuY
         ZwrT6mYOA7dsGHgTE38y8ChC0iFw0d84lAOkbjE144kve6DZrqBB6GRB+dYcJq65uyxD
         ETQkYjVsB0w1dqU7gwT1/DSHnSN5ypUNoWyBsIXlOfKnUEVa0wOkv4TeeX4WHjHJABoF
         aJVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XyFA36WxUtgN1B6uI/dhE/JlFw5l7tRA6v/t9YsZ+4Y=;
        b=XhAkEuPB+AM+IcWCt8iwHqD3EwATa4ZENAS/yE0y/w2EatGDt14JHvZ4PSlOxyDmZK
         Mwgrz2Nb3QxDLknbsClJjmJi0fuY2CyZFp1V0BnHrrlmuDpFJ5v9MO2CLl1YGACFOUqo
         Q4WIa7RDYGUroRN/ouU+V4jUWfT0WbcEIEaDJhqtd7ZZxOw6n8HhNpGhJtEamcyYleAo
         KYvylUx8gMnfuJdEn2v3Ps6tr8JFxn5QOSgMr5HNZ5xmqfRyqTjNk1Tky4/zPy1B3xkR
         jSy4k/7yy/bCczgfJRhYlp9h4xfGF1MRod7KsGa9RaCMRgcMYOTpVtL8J99gGZ8XW6sI
         0R/Q==
X-Gm-Message-State: APjAAAVvayJUXAr542DccV8hCmDM4wR0a2WpGs/hPdW4hEPNyKq/VXMJ
        v6KDVgt/6wm+A/8BxnuPzrAHrw==
X-Google-Smtp-Source: APXvYqy24Ve1+561kObrRFqRP0GvpY+qJCRm1uwI+US5R1xiDIwpAS6GNLd3Ugtjyfcc/16sAe4VbA==
X-Received: by 2002:a63:5f43:: with SMTP id t64mr12110260pgb.360.1580506343432;
        Fri, 31 Jan 2020 13:32:23 -0800 (PST)
Received: from [172.20.10.2] ([107.72.96.24])
        by smtp.gmail.com with ESMTPSA id h7sm11895854pfq.36.2020.01.31.13.32.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 13:32:22 -0800 (PST)
Subject: Re: [LSF/MM/BPF TOPIC] programmable IO control flow with io_uring and
 BPF
To:     Pavel Begunkov <asml.silence@gmail.com>,
        lsf-pc@lists.linux-foundation.org
Cc:     io-uring <io-uring@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        bpf@vger.kernel.org
References: <e25f7a09-96b2-2288-4777-9f728a8b2c23@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a2975b58-4d53-f13e-841c-04d4075cd0cd@kernel.dk>
Date:   Fri, 31 Jan 2020 14:30:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <e25f7a09-96b2-2288-4777-9f728a8b2c23@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/24/20 7:18 AM, Pavel Begunkov wrote:
> Apart from concurrent IO execution, io_uring allows to issue a sequence
> of operations, a.k.a links, where requests are executed sequentially one
> after another. If an "error" happened, the rest of the link will be
> cancelled.
> 
> The problem is what to consider an "error". For example, if we
> read less bytes than have been asked for, the link will be cancelled.
> It's necessary to play safe here, but this implies a lot of overhead if
> that isn't the desired behaviour. The user would need to reap all
> cancelled requests, analyse the state, resubmit them and suffer from
> context switches and all in-kernel preparation work. And there are
> dozens of possibly desirable patterns, so it's just not viable to
> hard-code them into the kernel.
> 
> The other problem is to keep in running even when a request depends on
> a result of the previous one. It could be simple passing return code or
> something more fancy, like reading from the userspace.
> 
> And that's where BPF will be extremely useful. It will control the flow
> and do steering.
> 
> The concept is to be able run a BPF program after a request's
> completion, taking the request's state, and doing some of the following:
> 1. drop a link/request
> 2. issue new requests
> 3. link/unlink requests
> 4. do fast calculations / accumulate data
> 5. emit information to the userspace (e.g. via ring's CQ)
> 
> With that, it will be possible to have almost context-switch-less IO,
> and that's really tempting considering how fast current devices are.
> 
> What to discuss:
> 1. use cases
> 2. control flow for non-privileged users (e.g. allowing some popular
>    pre-registered patterns)
> 3. what input the program needs (e.g. last request's
>    io_uring_cqe) and how to pass it.
> 4. whether we need notification via CQ for each cancelled/requested
>    request, because sometimes they only add noise
> 5. BPF access to user data (e.g. allow to read only registered buffers)
> 6. implementation details. E.g.
>    - how to ask to run BPF (e.g. with a new opcode)
>    - having global BPF, bound to an io_uring instance or mixed
>    - program state and how to register
>    - rework notion of draining and sequencing
>    - live-lock avoidance (e.g. double check io_uring shut-down code)

I think this is a key topic that we should absolutely discuss at LSFMM.

-- 
Jens Axboe


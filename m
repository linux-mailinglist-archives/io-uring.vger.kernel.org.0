Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD0F1D67DF
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2020 14:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgEQMAb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 May 2020 08:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727893AbgEQMAb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 May 2020 08:00:31 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30CAC061A0C
        for <io-uring@vger.kernel.org>; Sun, 17 May 2020 05:00:30 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id h4so6817225ljg.12
        for <io-uring@vger.kernel.org>; Sun, 17 May 2020 05:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gecH5NXAIrhml7cwGmRUI/z/zBpX0g4JLsJRrrfWNhI=;
        b=WhTDcaaEecOnCyK7ya35eBDwL94PTTcVByo0ooY0TXV6splLDxsXqzU2VwpR4+Ykis
         WB3xdNyrIIOAb6e9mGBiMy+ayafYzeLNj/Ls8mQ7Y6iIZBhi4fB+ciOzqUmDDHQ7Wogb
         T8DeFQekBBcEOAR3Q6vABsx+T1dCRHhKahQcNHP8PiftyZqMlFOF+fba2zZ1a35YvPhV
         0w9SSM72rbHO76bE2y1lQJ/9+qtQpewQBAQii6R8STMLVRzsmgPsgSMwSKAFxOlxRzxk
         M9LQLfu0Z9uZElQCChgBN7Vkbo9ySAcq+0dN1udZ4Bm1UiHEPwvXPxKEAHarPF/UmZ53
         SMFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gecH5NXAIrhml7cwGmRUI/z/zBpX0g4JLsJRrrfWNhI=;
        b=uaLIwuTT9dhTFaCiOGfkm8uafEBjTA5bG+RflxA78JbXZYpNOptsR5ONJA6PvZA/+m
         +5tPYnbkCRS3h/6YfDTN1XH46DyT503QCPX30rMBSi5KSaRj5Mre6KlkL3kIfr5RqCN+
         qvL0enelfPl9v6EddFgE9YgXwhfcX5q6iErZTv0CeKAuCdveKRm/+H2fEhI69XDQ+0sT
         2vPJAZbkaC7t30O2apXz926e6Ck9LrGZvPuFQnyj2g3y19AN14BbGK/qMAcRm2v4i4/J
         80vhwf94yCwN380o+YSoB1RayrZb+5yCp/o/1FJPjjpG4//C+xoQthcnvnAqd5uG1qRf
         FAug==
X-Gm-Message-State: AOAM533h4ZFCfoGLq+Qtwctoz6m4kiwIlgOR8AU6d+nJfTpdv9ftzG/k
        tqodMklfdSbfBeR2Gh5WBd6QbWzZ
X-Google-Smtp-Source: ABdhPJzQusbVOTVc43gq26KxD7AVN0gAvEIOlwXh2OqPGIK8H6sEEo3gLonRgXLzDdqJP++kkXawaQ==
X-Received: by 2002:a2e:8145:: with SMTP id t5mr7478372ljg.291.1589716828881;
        Sun, 17 May 2020 05:00:28 -0700 (PDT)
Received: from [192.168.1.132] ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id l15sm58596ljc.73.2020.05.17.05.00.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 May 2020 05:00:28 -0700 (PDT)
To:     "Richard W.M. Jones" <rjones@redhat.com>, io-uring@vger.kernel.org
References: <20200510080034.GI3888@redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: Questions about usage of io-uring in a network application
Message-ID: <85b1ed9c-74c9-ecb1-2d38-a9a76396cd53@gmail.com>
Date:   Sun, 17 May 2020 14:59:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200510080034.GI3888@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/05/2020 11:00, Richard W.M. Jones wrote:
> Hopefully these questions are not too stupid, but I didn't find any
> answers looking over the archives of this list or in the io_uring.pdf
> document.
> 
> I have an existing C library which is the client part of a
> client/server network service.  It's not exactly the same as HTTP, but
> it could be thought of as like an HTTP network client where we may
> hold a few separate TCP/IP connections open to the same server, and we
> issue multiple requests in flight per TCP connection.  There is one
> pthread per TCP connection usually.
> 
> I want to try to see if io_uring gives us any performance benefit by
> seeing if we can use IORING_OP_SENDMSG/IORING_OP_RECVMSG +
> IOSQE_IO_LINK, as an experiment.
> 
> 
> (1) How many io_urings should we create?
> 
> One ring per process?  All of the connections share the same ring.
> Presumably there would be a lot of contention because I suppose we'd
> need to lock the ring while submitting requests from multiple threads.
> If there are multiple independent libraries or separate of the program
> all trying to use io_uring, should they try to share a single ring?
> 
> One ring per pthread?  It seems we could implement this without locks
> using thread-local storage to hold the the io_uring fd.
> 
> One ring per physical CPU?  (Not sure how to implement this race-free
> in userspace).
> 
> One ring per TCP connection?

It's totally up to a user. Threads can try to share io_uring, but after some
number of IOPS you indeed may find it to be a bottleneck. It rather depends on
your system/workload/etc.

There are 2 more things you may want to consider:
1. only 1 thread can do in-kernel submission (i.e. inside io_uring_enter()) at a
time. And it can take some time, because it can to execute and complete some
requests inline (e.g. doing copying buffers, etc.).

2. there is an option to share internal thread pools between io_uring instances.
If you have multiple io_uring instances, it's a good start point to share a
single thread pool between them. see IORING_SETUP_ATTACH_WQ.

To summarise, for a really high-throughput system, I'd incline using the
per-process scheme with a single shared thread pool, and adjust then. As for
clients, and it's depends on a kind of a client you have, but an average one
would probably not bottleneck there.

I would love to see more comments from guys really using it. E.g. see
https://lore.kernel.org/io-uring/7692E70C-A0EA-423B-883F-6BF91B0DB359@icloud.com/


> 
> (2) The existing API (which we cannot change) takes user-allocated
> buffers for the data to read/write.  We don't know if these were
> allocated using malloc, they might be statically allocated or even
> come from something exotic like mmap of a file.  I understand that we
> cannot register these buffers using IORING_REGISTER_BUFFERS.  But can
> these be passed in the io_uring_sqe->addr field?  ie. Do the same
> restrictions in IORING_REGISTER_BUFFERS also apply to the addr field?

It should work as any other read(2)/write(2)/etc. A simple test with
file-backed buffers works for me.

-- 
Pavel Begunkov

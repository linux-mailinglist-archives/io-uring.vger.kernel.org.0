Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A261AFE9A
	for <lists+io-uring@lfdr.de>; Mon, 20 Apr 2020 00:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbgDSWW6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Apr 2020 18:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725891AbgDSWW5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Apr 2020 18:22:57 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB83C061A10
        for <io-uring@vger.kernel.org>; Sun, 19 Apr 2020 15:22:56 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id k18so3213242pll.6
        for <io-uring@vger.kernel.org>; Sun, 19 Apr 2020 15:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WZGGvjnGunABiy25qrhz6ksRUn1sXB4cu8ILhBoEIw4=;
        b=q361Dw3uF5Qr1t4y5v+dPldxAaxHS8ShKiBGG9s7RVfzTEnTG5VLizSByAFZb1rMpb
         ayBMS4rffRqTEtTGq2GcohUU29nxm4JKb9Jy5YuH4M4v07exxqLF3Ya15BzgFws3bGTa
         cWV1MEg+VFSJUKMHu8BHH6cyJOvBubkmQ2UaSzQFLXCfiapBdMcZb2j7MlepzaTnhlnI
         ROEhJvJXGkqhZ/AjMcEbWz+7k/7F4jFOuj8/yE7edpR+U1yixc08d+SqPbFZtY3Xs4sK
         dsxKekAYVfOXOuF/pdJghZiesUM7RdHfCFYAb1u+pcI/CUtsrY5VVycGGZnrYTGI00Re
         oUqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WZGGvjnGunABiy25qrhz6ksRUn1sXB4cu8ILhBoEIw4=;
        b=sBs/1aiNesW4KikVtd8y8LRv7MuTkwqNr9/sb+T8IQ4ZflQqJNIQPUhV01q9NaqkwB
         pqSxGEzQFXfOv28VZH82t3hZ4OZ1DxHsp6NKiDJYlplbeAdKtal9vUFbX3tveeHcJgsX
         HCOjDkgAtHduxa3ZvlfkfMA1UNWeS8L1AlGSC5prJ43UQbXLiQuXDX3sNM3llg6E05+U
         nYXdtU3kJzDJfXYHKyrHLOf+q5dmd0QIoQXJoWwlFphGMFAmBoPLAM667S7/dpKON4Wg
         d6ou0fHNtHshowmRDbapf/oaj2yjQEXybZ74H9jik8rc08gb1LytMvKyr6M+WZnFM2Tn
         LsKA==
X-Gm-Message-State: AGi0Pua8s8nen1IWcCqJPwxpTkhujAyC7lIn+YVF4XGQPNdTY9vRUWsq
        gbPJxbKxI4yWmnB14bh/n1OJCjhBHPBrbA==
X-Google-Smtp-Source: APiQypLVocmgSAnp2tycKBAS6H3WFAfrUrUN7XSJV8KonygiDW2GikHzh3bDUBJj0YUm49eMWZW93g==
X-Received: by 2002:a17:90a:8d0f:: with SMTP id c15mr16391639pjo.100.1587334975940;
        Sun, 19 Apr 2020 15:22:55 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id e66sm21780994pfa.69.2020.04.19.15.22.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 15:22:55 -0700 (PDT)
Subject: Re: [PATCH v4 2/3] fs: openat2: Extend open_how to allow
 userspace-selected fds
To:     Aleksa Sarai <cyphar@cyphar.com>,
        Josh Triplett <josh@joshtriplett.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
References: <cover.1586830316.git.josh@joshtriplett.org>
 <f969e7d45a8e83efc1ca13d675efd8775f13f376.1586830316.git.josh@joshtriplett.org>
 <20200419104404.j4e5gxdn2duvmu6s@yavin.dot.cyphar.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b7dae79b-4c5f-65f6-0960-617070357201@kernel.dk>
Date:   Sun, 19 Apr 2020 16:22:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200419104404.j4e5gxdn2duvmu6s@yavin.dot.cyphar.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/19/20 4:44 AM, Aleksa Sarai wrote:
> On 2020-04-13, Josh Triplett <josh@joshtriplett.org> wrote:
>> Inspired by the X protocol's handling of XIDs, allow userspace to select
>> the file descriptor opened by openat2, so that it can use the resulting
>> file descriptor in subsequent system calls without waiting for the
>> response to openat2.
>>
>> In io_uring, this allows sequences like openat2/read/close without
>> waiting for the openat2 to complete. Multiple such sequences can
>> overlap, as long as each uses a distinct file descriptor.
> 
> I'm not sure I understand this explanation -- how can you trigger a
> syscall with an fd that hasn't yet been registered (unless you're just
> hoping the race goes in your favour)?

io_uring can do chains of requests, where each link in the chain isn't
started until the previous one has completed. Hence if you know what fd
that openat2 will return, you can submit a chain ala:

<open file X, give me fd Y><read from fd Y><close fd Y>

as a single submission. This isn't possible to do currently, as the read
will depend on the output of the open, and we have no good way of
knowing what that fd will be.

-- 
Jens Axboe


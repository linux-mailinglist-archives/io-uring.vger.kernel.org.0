Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA233F5FE3
	for <lists+io-uring@lfdr.de>; Tue, 24 Aug 2021 16:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237520AbhHXOIi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Aug 2021 10:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235997AbhHXOIi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Aug 2021 10:08:38 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3584C061757
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 07:07:53 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id g9so26503742ioq.11
        for <io-uring@vger.kernel.org>; Tue, 24 Aug 2021 07:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=8VfY5kJYuhhOCjE0zEJRWCnVRM8u7tiJ1Wa689Nowho=;
        b=mQ7e74ied2BPSDGQNQF3nNJD4OpgdcAAm3WnGTgDxTHNifKKXTYDgW51zqRqHxrkIV
         oJUXD5N9l5y71PTtLTBJKLgHn8e9W4BmhHdKl1dT3Cq9gpSwGw2L83sjlWmfiYmTXrq0
         07t7Ga9bW6jfqBQHtjlUS3RimaWnuGZ1A+JYS1uBBIO21qO002IJT5BblyK7QyQkn8Ra
         x16YrB7GB8kynhOSgwJv+q+d+Wqj0AvgQ4XG3gm88ROgt+igqwjH5GOv3wcw2BA78pVq
         sBzcUrVadtMPtUwXGkDyPXQu7HgvaJgeDDN9AhQPHQUg9IFEB8e1sPpf6fW9jweDm6b0
         Wq4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8VfY5kJYuhhOCjE0zEJRWCnVRM8u7tiJ1Wa689Nowho=;
        b=XyBO7a6OsSuRhDijmaPVUgX+KZ3iyjXiu7xFKKJzPPAUdnnkPlyk755tpZNFd7QrIN
         9ZEvYeh2veaQ0aZdaV0OKchxxjAPGxxxzAwlkefQ6C+1t0NTzjy2tbWrfvIeA+AIPM3f
         787ex0UtHlvKXFRhyurYVBudbouMRDg8wUKSE6CDWGgELoo/NVl3RKdb4I8bN7WiESlt
         w8eMYdwwE7oNngCNuUiXUgf+d8aWQibjyZSymaLL/F5sliciSskO6CR6WcMvgTdviIu5
         Y1locVESRXzNLpEAPwgAdr6LEEpj38TeyvpWzPB8u+vYqPfwT9BJGMW7goXcnfqVDEYK
         lonA==
X-Gm-Message-State: AOAM532zr+Jr0Mf/vZcAxNDuTIfA8xJteBL1Q2p62sDLmmq7CzH60ozI
        PrdWm2ooUvI2I5QJA9vq7ZotXFm79U28oA==
X-Google-Smtp-Source: ABdhPJxDmisaknuKIkEQtNuWxMTuVp9l1mnIXVI30KNhx3KI9nR8UTROxSnRnzDhJ5CP8C18e7NsHQ==
X-Received: by 2002:a05:6638:aca:: with SMTP id m10mr13506775jab.22.1629814073202;
        Tue, 24 Aug 2021 07:07:53 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id m18sm9935485ilj.61.2021.08.24.07.07.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 07:07:52 -0700 (PDT)
Subject: Re: [PATCH liburing 0/2] non-root fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1629813328.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <69054979-1df3-8850-986b-41bfee38a0c4@kernel.dk>
Date:   Tue, 24 Aug 2021 08:07:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1629813328.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/24/21 7:57 AM, Pavel Begunkov wrote:
> 1/1 fixes non-root rw tests, and 2/2 makes yet another
> test case to handle non-root users.
> 
> Pavel Begunkov (2):
>   tests: rw: don't exit ring when init failed
>   tests: non-root io_uring_register
> 
>  test/io_uring_register.c | 8 +++++---
>  test/iopoll.c            | 3 +--
>  test/read-write.c        | 4 +---
>  3 files changed, 7 insertions(+), 8 deletions(-)

Applied, thanks.

-- 
Jens Axboe


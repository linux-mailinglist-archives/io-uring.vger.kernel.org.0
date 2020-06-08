Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427E81F1ED0
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2020 20:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgFHSP2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Jun 2020 14:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgFHSPX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Jun 2020 14:15:23 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF744C08C5C2;
        Mon,  8 Jun 2020 11:15:22 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id t18so18465547wru.6;
        Mon, 08 Jun 2020 11:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WUHwJX2N9pIy9QeRXyEGGmeeCpsJdb22/OGUgYWDaZs=;
        b=fk4/Bs3DeNtMcKi5ch5N3gpQpdWFBxPVM5RpcJ9t3FMxoEzjHxmaaepAJ2zymcHdJh
         yXspphw1FR6n2VP/gjGRziTn3+pDXuYrsdHOlip2Wnc5BCa8y+pugec77hOnp2Rvj7hS
         mqD387luzCWwASTbyj8Tf5GSUZgR1ehDBUW75Pcvk7UErUGFeXnJvbZuy3VdX0h3XA6U
         3tpfwxzfzdyysGaEKNBcP/V9egoxB022Jy2HJ0fvM1BMr3MySiYa749JJJ52B79MhP0w
         GbzyVtlx+pjyYwab+AEKZtZrl7zmdG1Xblue0/O7FFw7i2qOi1GAc3/n0d77+npoTtrr
         37tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=WUHwJX2N9pIy9QeRXyEGGmeeCpsJdb22/OGUgYWDaZs=;
        b=FrCMqjM/nWdpjCgTfkbbWRxNb0ni6F7zgjB8tfjudbPbB6B8Mh1p+lwPe2lgeqXm6W
         ab0MwTlH/uGpIHhHSwUG2rtGCEWZhA5p/Ed5hYbbKc6/lbsIcT7TMizDisgoP/3Ga1Zu
         uFJdUMirzzn9hnLN2bcFZVAihqCt61chK1JlT3JU22g9N3MRws3qTL02lzk8Cx3cDxhU
         JQvglvSDKcUqHJHSAfNllhBbhPb1fK2WUr5S6ergrFHmUxL2W6Y6MBzHKWu+XOiTVWPy
         9CbtK/iHeC+xHX+iuKeSCPskPMor71IQ4JLscE1WeRRFrkR+b1Ingsy4R/cX9ZMvFKGk
         IAwg==
X-Gm-Message-State: AOAM531F0FVktxF2frduNIMju9EYDThliYCjOWBO1GuQV5M9V6KBmpab
        EFgLUS+pba77t27KXovJSFpbR/6M
X-Google-Smtp-Source: ABdhPJw1Y9Cnn6+Gh+ZM06NjCC6ogM3zVdBvUQGmts4uKhxrr8q5BZlddYmxosKY33dC7K1RoL4sgQ==
X-Received: by 2002:adf:b198:: with SMTP id q24mr85376wra.368.1591640121560;
        Mon, 08 Jun 2020 11:15:21 -0700 (PDT)
Received: from [192.168.43.208] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id w17sm463831wra.71.2020.06.08.11.15.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2020 11:15:21 -0700 (PDT)
Subject: Re: [PATCH 0/4] remove work.func
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1591637070.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <18e05c85-a626-82a9-b60e-d24d1c40682e@gmail.com>
Date:   Mon, 8 Jun 2020 21:14:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <cover.1591637070.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 08/06/2020 21:08, Pavel Begunkov wrote:
> As discussed, removing ->func from io_wq_work and moving
> it into io-wq.

Xiaoguang Wang, until Jens goes back and picks this up, I'll
also keep the patchset in my github [1]. Just in case you'd
want to play with it.

https://github.com/isilence/linux/commits/rem_work_func

> 
> Pavel Begunkov (4):
>   io_uring: don't derive close state from ->func
>   io_uring: remove custom ->func handlers
>   io_uring: don't arm a timeout through work.func
>   io_wq: add per-wq work handler instead of per work
> 
>  fs/io-wq.c    |  10 ++-
>  fs/io-wq.h    |   7 +-
>  fs/io_uring.c | 221 +++++++++++++++-----------------------------------
>  3 files changed, 74 insertions(+), 164 deletions(-)
> 

-- 
Pavel Begunkov

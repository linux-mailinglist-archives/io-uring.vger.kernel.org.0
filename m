Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C7A3FCB07
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 17:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239594AbhHaPsV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 11:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbhHaPsU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 11:48:20 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D07C061575
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 08:47:24 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id u9so28439600wrg.8
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 08:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MemTxQH9tEUILsNNgs4KovRZ1uSGCB9GsQgQfr+FrKc=;
        b=LZvaKTkvQeQtcjZRZJOKeokfiIChG9ufIWBtD9UuDlKe8q1hjXY7VQNfOO0jKBzM2R
         17WUNcqfBdvK2AlN8s9H+0JkCAIRPQZehnP5Ak+9r9WzKSCKhTd6jVB3CxzPqH+S59tv
         kUv23y2NMYIIYKWoLn1i2kWZvJOWgaCL3upf9cL1tx5XnLQTvuAdywxJvxaaLh/V8izF
         awhq5AoF2vwdFvH14mKZpHl1TmMfeWjgm7jARNYv84DLfr99HnqxXJQCXhUG+F6Aswpc
         mSlV4zCZJZAGJYHznSnBo96Qf6jOGeK/Brcw/Xs/RFfjYO78nkSMkLtIqHo5/w852a2W
         7yrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MemTxQH9tEUILsNNgs4KovRZ1uSGCB9GsQgQfr+FrKc=;
        b=mBz/gZ3GgRWaciRvFk4n2g0DZCQBwteriK7ilhpxRvLqnh0Bk1zV3DRGyNTY76OJGs
         ACYO/rzkPPxWTaA58lwq1pxEQ66Gptj4+v7Z+DUr3dpZjqvCAq9tthViWHc7cJFl8Bcg
         89ENVKe8DQsLriJ68D33Js/2n85XGWOWeHMotG5qIIVkjP/PfDVfRZYfewRpmQHdGkJf
         tdZf+Fmlgt7HDSVezxdrNz17acG24Wq1IgSZq2VrrBkIpd/2KqzXZukM680yVErWIZYO
         g1B/DOrap4ix2TXt+OeQk8M03X4a3d+FiQHZ2iixUwsmDb5y67f3kpiVpa0miIQ6vjzv
         ljcQ==
X-Gm-Message-State: AOAM531BBeSaZUwjFWS8bUxDBRBEAKRKK3hKlNOPTakWsbUQiwjkXNgB
        4VJ76W4SKpS29aPSLVqsusw=
X-Google-Smtp-Source: ABdhPJxONH/J6hzFBIThRiDaHGgBImjeCUsE6IdCQm3bKgxzvpE1wx1Vl9yR2OZqqoT60eaVH9Lv3w==
X-Received: by 2002:adf:dcc7:: with SMTP id x7mr31932647wrm.173.1630424843700;
        Tue, 31 Aug 2021 08:47:23 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.138])
        by smtp.gmail.com with ESMTPSA id b4sm18376814wrp.33.2021.08.31.08.47.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 08:47:23 -0700 (PDT)
Subject: Re: [PATCH liburing v2] liburing: add helpers for direct open/accept
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Hao Xu <haoxu@linux.alibaba.com>
References: <b0f00ddc38cdcf1cdd1c93f7fa36c156b0db7b2e.1630424687.git.asml.silence@gmail.com>
Message-ID: <29386c6f-6e09-1378-3a51-a48d82b2ce96@gmail.com>
Date:   Tue, 31 Aug 2021 16:46:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <b0f00ddc38cdcf1cdd1c93f7fa36c156b0db7b2e.1630424687.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/31/21 4:45 PM, Pavel Begunkov wrote:
> We allow openat/openat2/accept to place new files right into the
> internal fixed table, add helpers.

Err, please ignore this one, will be sent later


-- 
Pavel Begunkov

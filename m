Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82FD51CC235
	for <lists+io-uring@lfdr.de>; Sat,  9 May 2020 16:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgEIOnA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 May 2020 10:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727840AbgEIOnA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 May 2020 10:43:00 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D568C05BD09
        for <io-uring@vger.kernel.org>; Sat,  9 May 2020 07:42:59 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id f7so2490301pfa.9
        for <io-uring@vger.kernel.org>; Sat, 09 May 2020 07:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=8qtmaJLYw4IC+4FDva3MHRax/v6YPJc7TOvGR5mHtPY=;
        b=X9FK/JC5//r6bN8vdxWdP6Knl5vDy4zg+XMFdHWIkRlywRYquT31GmeuUUp+0estnx
         PvZkQoE119/yNyqOE5+6bpy3vJL3qLTdRiBm4JqVkxA2x7S67+ye74gufcsMBjMNsjxM
         CFqx5sx7TR+RtPusFB+CZ2q+RfRdRGsK+c3U5YqsCazDh1zMos2M3/kOD1dVPhc/zq9B
         MG5bUUeoN7mXP1r+eqsZr2kFdFXcVAGIFDyT4WA8LPrbHclWxyx9P+P0A7IxoBxRWBIf
         5siU0VxFuiJ3QvZGEysjwmKkxTdNcn85P+LLdwxuiNu4JcabL03NynLeiQrHdz4hXh0A
         hYGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8qtmaJLYw4IC+4FDva3MHRax/v6YPJc7TOvGR5mHtPY=;
        b=h7QZv1zQWXEuqhwtUBzJNB47kOAH5I/CABlCbPu1hr+FdOgPxcnZQn5ZOpiM7lS5b9
         4HHOF79Xnq/qQeTyGH7GKhZcbHe6Mf9IEnGt82FX6VKvNQy8Bgyrl6R5DFHNtqU6/zOR
         IHoEkkv2DKZ3tVAytNsv/oq5c5Ho/lKuJBB91tWVSW+eNa8cuICSeE1liFWBSOQfz5hU
         j0tpNaMxcDWDqAYQ+7AFecHeLuLv0fb2kiWvl9XNAYthhDFnnZBgvoJvD9s+ALrByMHN
         jaRkTPsTYoVGXAaADcFUSKq1B0je0TCDt8yGrK6Rb911glQ70zmvrX6aDQbQdLvFesg4
         uGmw==
X-Gm-Message-State: AGi0PuaST633cQjztNtxiRQUZSZfcfH1Xjc8dUhldnxVAB909Katqaux
        4uyyHIVkwFsQL10YMamghAOp6g==
X-Google-Smtp-Source: APiQypLeRR1OSt+0AcoaHdeXNyu/1vZfyZ/IXuWQ6Zk+bz9jVct5eEG+6jPSmcmKcQXQaO6L87T43g==
X-Received: by 2002:a63:68c3:: with SMTP id d186mr6829910pgc.269.1589035379319;
        Sat, 09 May 2020 07:42:59 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id w125sm3796396pgw.22.2020.05.09.07.42.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2020 07:42:58 -0700 (PDT)
Subject: Re: [RFC] splice/tee: len=0 fast path after validity check
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <14d4955e8c232ea7d2cbb2c2409be789499e0452.1589013737.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <29de6592-8d62-5b5d-9859-d7adcc58759b@kernel.dk>
Date:   Sat, 9 May 2020 08:42:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <14d4955e8c232ea7d2cbb2c2409be789499e0452.1589013737.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/9/20 2:46 AM, Pavel Begunkov wrote:
> When len=0, splice() and tee() return 0 even if specified fds are
> invalid, hiding errors from users. Move len=0 optimisation later after
> basic validity checks.
> 
> before:
> splice(len=0, fd_in=-1, ...) == 0;
> 
> after:
> splice(len=0, fd_in=-1, ...) == -EBADF;

I'm not sure what the purpose of this would be. It probably should have
been done that way from the beginning, but it wasn't.  While there's
very little risk of breaking any applications due to this change, it
also seems like a pointless exercise at this point.

So my suggestion would be to just leave it alone.

-- 
Jens Axboe


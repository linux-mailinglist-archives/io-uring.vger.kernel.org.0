Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDD235B12F
	for <lists+io-uring@lfdr.de>; Sun, 11 Apr 2021 04:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234944AbhDKCi7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Apr 2021 22:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234680AbhDKCi7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Apr 2021 22:38:59 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA5B8C06138B
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 19:38:43 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id t22so6757383pgu.0
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 19:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=98IZXSmZbipnTh7oHcpBhboPmm97eFehK/7D4mO60rA=;
        b=ixVK70iiBWfJH6jQYjd50nKojVJ1mVxpVqv9wG77lv0ftnKOchhh1xG4hmRBNRZ5lk
         PuaKZ2zfS6l31Rl7AXCQrgnGx4kPm1ULhlHInZ7jnZLwAp5u6nDLYmCq/+mUAYmdLRDI
         2QI3oDA5XI4HtUzzxIRc9z/P4j/8LsQJAjvNOEDds4q+Lo4iMl84HAtY0Z4ZtMnE1B4i
         3qhgXwya5CpPMycDgmCKtA4Ccxt9fXb5L5kDLviaeLbXJNF3Ac+uIgmrGGXX+Eyc9frN
         Dj5ExQO03NlJ7rcczA0yGTBEW/Qbziov1b9UqFa7adh4D7k3qfaEpjwsrDwuILBXF6/1
         lbAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=98IZXSmZbipnTh7oHcpBhboPmm97eFehK/7D4mO60rA=;
        b=Jo9adIOlEAx/MWfCTeWNyZ2xWYEYvMYtZSZUp1fnj5/ZoNir+SuA+H/0/SqybYZhcG
         eoVLCGX7UUZKaMW9xvwPCKbIIv11H7qPBO/FZZYCqtJEQXAdYFaroS376fhySIdNVOaD
         Aepif6UZm19/7Z4wv1G6hF5kGJLMmL5LPVtm8nh1AegeDZtR2sVh9bo2JyWUrEpUtOZy
         cj9UW5Sc0ogzrFSADEtVpIWImXLs51WWgjGiwnMaHalE5lQ9szIb/THprGpgm/fS9DH4
         FhFPzWmPZdDizUXmv+TIoDb/1XOZGeW8s4qMEySliysC3biF+V8p5eJgLO5xwLbuq+/P
         8DoQ==
X-Gm-Message-State: AOAM531AHwyVzy7YKMk9/wveuLVtGqVIQdraHi2ZN3W9mKQR9dViPVo2
        zADoRS2YKQsrY77xYRbn1BWaLJl/Hfdcbg==
X-Google-Smtp-Source: ABdhPJw6JRQlBrpCbMLERc1z5K0mzbSwLtJ/V+aUn5PXd9q4vBGSklpY5Svm79vIyHdnYtkk4+ecSQ==
X-Received: by 2002:a63:e64b:: with SMTP id p11mr19930292pgj.10.1618108722739;
        Sat, 10 Apr 2021 19:38:42 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id em16sm6466564pjb.43.2021.04.10.19.38.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Apr 2021 19:38:42 -0700 (PDT)
Subject: Re: [PATCH 5.13 00/16] random 5.13 patches
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1618101759.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9447a865-cfb0-fa16-f598-67725effb242@kernel.dk>
Date:   Sat, 10 Apr 2021 20:38:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1618101759.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/10/21 6:46 PM, Pavel Begunkov wrote:
> 1-3: task vs files cancellation unification, sheds some lines
> 8-9: inlines fill_event(), gives some performance
> 10-13: more of registered buffer / resource preparation patches
> others are just separate not connected cleanups/improvements
> 
> Pavel Begunkov (16):
>   io_uring: unify task and files cancel loops
>   io_uring: track inflight requests through counter
>   io_uring: unify files and task cancel
>   io_uring: refactor io_close
>   io_uring: enable inline completion for more cases
>   io_uring: refactor compat_msghdr import
>   io_uring: optimise non-eventfd post-event
>   io_uring: always pass cflags into fill_event()
>   io_uring: optimise fill_event() by inlining
>   io_uring: simplify io_rsrc_data refcounting
>   io_uring: add buffer unmap helper
>   io_uring: cleanup buffer register
>   io_uring: split file table from rsrc nodes
>   io_uring: improve sqo stop
>   io_uring: improve hardlink code generation
>   io_uring: return back safer resurrect
> 
>  fs/io_uring.c            | 386 ++++++++++++++++-----------------------
>  include/linux/io_uring.h |  12 +-
>  2 files changed, 163 insertions(+), 235 deletions(-)

Look good to me, and some nice cleanups. Would be nice to get the
mostly two-sided cancelations down to one single thing at some
point.

-- 
Jens Axboe


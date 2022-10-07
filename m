Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEA665F7B2C
	for <lists+io-uring@lfdr.de>; Fri,  7 Oct 2022 18:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiJGQIF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Oct 2022 12:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiJGQIF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Oct 2022 12:08:05 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6F710C4FD
        for <io-uring@vger.kernel.org>; Fri,  7 Oct 2022 09:08:03 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id i25-20020a4a8d99000000b0047fa712fc6dso2616590ook.2
        for <io-uring@vger.kernel.org>; Fri, 07 Oct 2022 09:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/Ic74zB0raxMSIWRj2x8RUW+j0swC5jHR/zgKEbmHCw=;
        b=JnR5HP3mSrSvekPIvmYQ7Y10lQb+wzOPHAUtA7FcKnP503fcqcATkyO3eqI+FnmlIJ
         j1i5k2b6PB+DvJFaffAH3MZaLJP5QsABvaaYXLDAQSLZE0UF4O16JC+xli3y03SYFVfy
         9QJ8uuMrbCpWmoeLo9Naj51GffCwJ43Juyj9I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/Ic74zB0raxMSIWRj2x8RUW+j0swC5jHR/zgKEbmHCw=;
        b=5j97Uh2+P9kiGdsMQ83dWPHly3vK5ohPyUQs3ncM6B5h7PEVO9ycdzZSlBYWrQRHFm
         srK1TfmpfWufD2EtLXMXSRdl2qpiWj80L9HMahZFriIuwQnvIAmvfMslOfAsX7NEGBA/
         X7h78W0L3Uz8LCATMibcClx2YgMekiganO0/ANUGLMxrasf0WRGYTLg96bBK6oJE9OcW
         UZbnMYzos+U2zgyEnHoIW141kZunCDgT5zRq/X0F6hS1k5suesHjG2ZMWTTZP2Njto06
         qbKPCHJmwnlIySwsE5Y1qv1mPl5QrT9l9kMigmyjUTrJV3jrnEL5p1IMiA76+6x9oqds
         wAHg==
X-Gm-Message-State: ACrzQf0cf0j1rPEh7XeQWZh5N3H8UjUhilRKIQtmuifMUJotqmKIUbZV
        cqy6zpI2pWznJqzp+xJ6xwAdnFja7anrYg==
X-Google-Smtp-Source: AMsMyM7/sMbFmwaW5g+Xbu4Tyz/iDV2eADDiS0teNX8G1/vpsDg2/zu1h2R9RJqJ8yyJbrfAgr7j0g==
X-Received: by 2002:a05:6830:280a:b0:65b:f13b:2a44 with SMTP id w10-20020a056830280a00b0065bf13b2a44mr2407874otu.371.1665158882374;
        Fri, 07 Oct 2022 09:08:02 -0700 (PDT)
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com. [209.85.167.176])
        by smtp.gmail.com with ESMTPSA id q19-20020a056870e61300b0011dca1bd2cdsm1589980oag.0.2022.10.07.09.08.01
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Oct 2022 09:08:01 -0700 (PDT)
Received: by mail-oi1-f176.google.com with SMTP id t79so6059878oie.0
        for <io-uring@vger.kernel.org>; Fri, 07 Oct 2022 09:08:01 -0700 (PDT)
X-Received: by 2002:aca:b957:0:b0:351:4ecf:477d with SMTP id
 j84-20020acab957000000b003514ecf477dmr2768305oif.126.1665158881184; Fri, 07
 Oct 2022 09:08:01 -0700 (PDT)
MIME-Version: 1.0
References: <2fad8156-a3ad-5532-aee6-3f872a84e9c2@kernel.dk>
In-Reply-To: <2fad8156-a3ad-5532-aee6-3f872a84e9c2@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 7 Oct 2022 09:07:45 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg1RzrA5dq_9RTz-mhxOPmy7nFap2NiS-Kz6KwpUuDMmg@mail.gmail.com>
Message-ID: <CAHk-=wg1RzrA5dq_9RTz-mhxOPmy7nFap2NiS-Kz6KwpUuDMmg@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring updates for 6.1-rc1
To:     Jens Axboe <axboe@kernel.dk>, Dylan Yudaken <dylany@fb.com>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Oct 3, 2022 at 7:18 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> - Series that adds supported for more directly managed task_work
>   running. This is beneficial for real world applications that end up
>   issuing lots of system calls as part of handling work.

While I agree with the concept, I'm not convinced this is done the right way.

It looks very much like it was done in a "this is perfect for benchmarks" mode.

I think you should consider it much more similar to plugging (both
network and disk IO). In particular, I think that you'll find that
once you have random events like memory allocations blocking in other
places, you actually will want to unplug early, so that you don't end
up sleeping with unstarted work to do.

And the reason I say this code looks like "made for benchmarks" is
that you'll basically never see those kinds of issues when you just
run some benchmark that is tuned for this.  For the benchmark, you
just want the user to control exactly when to start the load, because
you control pretty much everything.

And then real life happens, and you have situations where you get
those odd hiccups from other things going on, and you wonder "why was
no IO taking place?"

Maybe I'm misreading the code, but it looks to me that the deferred
io_uring work is basically deferred completely synchronously.

I've pulled this, and maybe I'm misreading it. Or maybe there's some
reason why io_uring is completely different from all the other
situations where we've ever wanted to do this kind of plugging for
batching, but I really doubt that io_uring is magically different...

                  Linus

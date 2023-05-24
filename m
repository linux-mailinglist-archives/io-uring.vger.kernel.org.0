Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B633370F9C2
	for <lists+io-uring@lfdr.de>; Wed, 24 May 2023 17:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234637AbjEXPGq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 May 2023 11:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbjEXPGk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 May 2023 11:06:40 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DDF9C
        for <io-uring@vger.kernel.org>; Wed, 24 May 2023 08:06:39 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id ca18e2360f4ac-7748ca56133so5188539f.0
        for <io-uring@vger.kernel.org>; Wed, 24 May 2023 08:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1684940799; x=1687532799;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ha6dDQs3x55EMXaIHxI7PHtC2B83b81pLL+ngN6SfKg=;
        b=2lYCCWc1f3wp3qBhASy2+BgLrkVDFPqkCm+3pCP8R9eVtmFXBm+lyHSW5PAX+hO4yS
         eTfNDmkM8Z4d08EOBFFkmDSzU+s0XC3izCX+Y11lRUmrfbmGrwordmLHVOSqZ71+YuUZ
         QwT6gsCmo5+4ENQArxvQRd6dfMtr6hbQqedfzJfi9B+5O7sBNAT90smK1r4v1b2gihSS
         lDvlZseEKK4xiuqOXvnBNQDuN6KMA+4nt/ZG+1uiqFy+Hthg7aZ8HUUB0jrKQt4RVa+s
         C3TGKFP8wFoBpQeNniDEJqbHMv2UIridAoZgdqNDhtbfHBSpgOSC5X8t7TRpQGLmUztf
         FiGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684940799; x=1687532799;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ha6dDQs3x55EMXaIHxI7PHtC2B83b81pLL+ngN6SfKg=;
        b=FrMnCVldBk0LbuY6YJxn9Wpd0vxUzw9RqDk2LyPZ/nrP3eOuTU/Da/njSDR5wY1k8j
         PRVbPC/FfhjlvwXBix0aOwa6IRcTqt5K+GibeaDzULlycmiWHV/rPI+5Y35BonV344fR
         Zwr7uRcnu21oPMFRcuIadNT3QXYR9Uccolqv2hxwmOewz5WdzemkVhzARyxei1+e096h
         qjAb6pPyrgkgVPEp0GznL9u2bxyBQLIWFKtqHynozNwIIk+IU/Kl50ewbpXte5t3Tkcm
         0naGuZLc5CLXtu8NQVz6/pNjZrz2yn2BlH5yqLwXoGWYwn2GyA2pJK4M419QJr9+o842
         //ow==
X-Gm-Message-State: AC+VfDxAgAkix6c5LdqF7hIlBu+3frxpksC3NG8nz47G3qknOy6/uvB/
        Hsa97GJqZyVOjQPcSZBjmn9ggA==
X-Google-Smtp-Source: ACHHUZ7ZUgb3hLc8KdEEgIL+cYKmIb3iG6gr2fwMvEkl8AGfB/FLhLrR+RSjFOJTGLaD+C+q5Cf+3w==
X-Received: by 2002:a6b:3b85:0:b0:774:8d63:449c with SMTP id i127-20020a6b3b85000000b007748d63449cmr2036542ioa.0.1684940798979;
        Wed, 24 May 2023 08:06:38 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id k24-20020a02a718000000b004161ad47337sm3133654jam.158.2023.05.24.08.06.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 May 2023 08:06:38 -0700 (PDT)
Message-ID: <d8af0d2b-127c-03ef-0fe6-36a633fb8b49@kernel.dk>
Date:   Wed, 24 May 2023 09:06:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Protection key in io uring kthread
Content-Language: en-US
To:     Jeff Xu <jeffxu@chromium.org>, io-uring@vger.kernel.org
References: <CABi2SkUp45HEt7eQ6a47Z7b3LzW=4m3xAakG35os7puCO2dkng@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CABi2SkUp45HEt7eQ6a47Z7b3LzW=4m3xAakG35os7puCO2dkng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/23/23 8:48?PM, Jeff Xu wrote:
> Hi
> I have a question on the protection key in io_uring. Today, when a
> user thread enters the kernel through syscall, PKRU is preserved, and
> the kernel  will respect the PKEY protection of memory.
> 
> For example:
> sys_mprotect_pkey((void *)ptr, size, PROT_READ | PROT_WRITE, pkey);
> pkey_write_deny(pkey); <-- disable write access to pkey for this thread.
> ret = read(fd, ptr, 1); <-- this will fail in the kernel.
> 
> I wonder what is the case for io_uring, since read is now async, will
> kthread have the user thread's PKUR ?

There is no kthread. What can happen is that some operation may be
punted to the io-wq workers, but these act exactly like a thread created
by the original task. IOW, if normal threads retain the protection key,
so will any io-wq io_uring thread. If they don't, they do not.

> In theory, it is possible, i.e. from io_uring_enter syscall. But I
> don't know the implementation details of io_uring, hence asking the
> expert in this list.

Right, if the IO is done inline, then it won't make a difference if eg
read(2) is used or IORING_OP_READ (or similar) with io_uring.

-- 
Jens Axboe


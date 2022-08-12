Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9070A5916E7
	for <lists+io-uring@lfdr.de>; Fri, 12 Aug 2022 23:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbiHLVxx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 17:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234943AbiHLVxi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 17:53:38 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13530B4436
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 14:53:35 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id q16so1828065pgq.6
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 14:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=pbdUMAB8JqePEStEepad0cs4Yg8xKFzBoWCVRVNj4Io=;
        b=TjTuZspBuFey59W1U87hr8ojIiSX3CqxPAL+dnOs9DU3P8Os3MPwUffsmhwX28v5O9
         njWmjFJJdpZlQVa50g8KjI+hVLD4OgFvlQJE6+HL0saUJg8c7geNDGwHNihBz3r7Dtf6
         WNeeHfaUg1qsO+vEEiiUHrCDtItM+DmMl1ot4eFICpkfESIJLAOaN/7GpIYh6ZGPthtC
         3ePXu26t8s2rvrT7FiOniHENhcxlL0ubx7ZRVg+P1VsU7iArHBLQdvlt6uUUuLbpyYWO
         MzMoPpp4SoW7SQ0YGyEdHWZ7yQuMB/Y1hK8UM46EQ2C/aMcJjHUepWuPJev3dPxMamhT
         a8Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=pbdUMAB8JqePEStEepad0cs4Yg8xKFzBoWCVRVNj4Io=;
        b=mFxxTe/LJjebQUx79PHmMYLFXFKxHhnuCSUQSg7CE4S/BBNEn1FVRH3FnuhOxOwTSi
         qMivwEPoyhQ/K2B0OeEwqsDR2jfXUuSuqdsGmCFy/hBF6xk//3rmJrwXCp9aTIo6z8my
         vsWH+XLg6SyNxzY+biD4DIuwplmZnAaTnCFaoiKZNSQOskC7+94NOOuq0j3MGuWbVtFb
         hGKWqrZgKLDnTq3ESVac6Tcf/qqYySPXrKMk9ULV+0Ii8s6UXN2JXD8uOK10EkKZ9Uk4
         GpRn/wwPt1hZ2nzTIfMZQ9bxynn0OC5tmrTnJFwvrrFpkiWrzecAr4lHM60XShND3r6J
         rCTQ==
X-Gm-Message-State: ACgBeo0CEIoHe/+u7rz3QgS6X8lO+NzF1z/RiNf4KIFNv6bq7eydxFNn
        niXPRzHesbB+pJ0toUfz02IRiA==
X-Google-Smtp-Source: AA6agR4SJ5OJSuNW+/NhHNqnmA9E+mQ/I9gwxdpDmPdjVaOQ1ybLqPIKpBcz6Pa+Yb+lu4TCaFYyDg==
X-Received: by 2002:a05:6a00:2352:b0:52e:f0bd:981e with SMTP id j18-20020a056a00235200b0052ef0bd981emr5373937pfj.28.1660341215049;
        Fri, 12 Aug 2022 14:53:35 -0700 (PDT)
Received: from ?IPV6:2600:380:7647:2d08:3216:9efb:42c5:74f2? ([2600:380:7647:2d08:3216:9efb:42c5:74f2])
        by smtp.gmail.com with ESMTPSA id b2-20020a170902d50200b0016bef6f6903sm2253772plg.72.2022.08.12.14.53.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 14:53:34 -0700 (PDT)
Message-ID: <06ba27b6-7083-d037-18c7-a38937cff19b@kernel.dk>
Date:   Fri, 12 Aug 2022 15:53:32 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] io_uring fixes for 6.0-rc1
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>
References: <CAHk-=wioqj4HUQM_dXdVoSJtPe+z0KxNrJPg0cs_R3j-gJJxAg@mail.gmail.com>
 <D92A7993-60C6-438C-AFA9-FA511646153C@kernel.dk>
 <6458eb59-554a-121b-d605-0b9755232818@kernel.dk>
 <ca630c3c-80ad-ceff-61a9-63b253ba5dbd@kernel.dk>
 <433f4500-427d-8581-b852-fbe257aa6120@kernel.dk>
 <CAHk-=wi_oveXZexeUuxpJZnMLhLJWC=biyaZ8SoiNPd2r=6iUg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wi_oveXZexeUuxpJZnMLhLJWC=biyaZ8SoiNPd2r=6iUg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/12/22 3:43 PM, Linus Torvalds wrote:
> [ Crossed emails ]
> 
> On Fri, Aug 12, 2022 at 2:34 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Keith brought up a good point, is this some weird randomization of
>> io_kiocb that makes it bigger? struct io_rw is already at 64-bytes as it
>> is, if it gets re-arranged for more padding maybe that's what you're
>> hitting? Is it just io_rw or are you seeing others?
> 
> I think was seeing others (I got hundreds of lines or errors), but now
> that I've blown things away I can't recreate it. My allmodconfig build
> just completed with no sign of the errors I saw earlier.
> 
> I think Keith is right. An allmodconfig build for me has
> 
>   CONFIG_RANDSTRUCT=y
>   CONFIG_GCC_PLUGIN_RANDSTRUCT=y
> 
> and the io_uring "type safety" isn't actually typesafe: it just checks
> the size of types.

I think Keith is right too...

> The other alternative is that we have some build dependency issue, and
> blowing away my old tree fixed things. But that sounds unlikely, we
> haven't had those kinds of issues in a long time.

I would've said we just revert it, but this looks broken now with the
io_cmd_data layout. Before this release, it just would've grown io_kiocb
a bit and spilled into the next cacheline for per-command data. And
while that isn't ideal for performance reasons, it's not like it
wouldn't work. But now we have it specifically set aside 64 bytes for
command data, where it really should be the max any command type would
use rather than a hard-coded 64 bytes. I suspect io_rw is the only one
that'd hit this, exactly because of the randomization in struct kiocb.
If anything else went beyond, we'd find it during development, not while
it was in-tree.

I'll ponder a solution to this...

-- 
Jens Axboe


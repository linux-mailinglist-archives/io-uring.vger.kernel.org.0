Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C30BF59176F
	for <lists+io-uring@lfdr.de>; Sat, 13 Aug 2022 00:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236872AbiHLWxD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 18:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiHLWxD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 18:53:03 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97E18E0E0
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:53:01 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id j8so4257432ejx.9
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=aevIhR3aPYXhKNSnrq3/z5IOse4QSu+JqLr/txijwhg=;
        b=G5H2HGWkHyUqjHg9HT3koS+1/0ybidkSKD3/1Kh699GwS42FKVjLuDQdm0rbHL7qGD
         5ud7ks4cX89pN6K58EauUycl0eCAjRzBmitGSXXMAmurfqxrh/zgjIv9/ZjhXky+n0vm
         54keOTbPmSZ76V8wmyV0h+VWYHlxNKe+bCJus=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=aevIhR3aPYXhKNSnrq3/z5IOse4QSu+JqLr/txijwhg=;
        b=RDMVevv8SnF04csFxhhpotqErVCW+7g5e/pBoWT4/LwC9300CeX0MuHIW7PhlfXIDP
         VTNysqJH2ABF/TtZmd8XZ4s6hmNKghhYO96/AVXD7NZbZibVb19x2zSbJEcTEy4XhyBv
         rJJWYocZgPfC9eP/ztUfL6x1jNNA2ecpIXD93O8TBnvC7j0L+0pvDDr/2qjhMo62vgm/
         C71bc5ZijWjt9BWuUhPUvuwKrhtp1AqLi5lw/p0yJzEZCKsL7SE66fSm83YME5iZEhPk
         at69UfzxtZ35+yIKeHahFauO1f8bV4eM4EQbCbpZDwAAFRmAdunI1Y1oisY3bpDN9bSs
         1pGQ==
X-Gm-Message-State: ACgBeo23qcYJ2ZsVWjN+s4XQ4reRWTSejQoqOx6WtHSC/5+sSiBOQZQj
        Vw2Clmv/uM7105Zirg9/Mac7bFs2N1bzrf2S
X-Google-Smtp-Source: AA6agR4y5/ONTs7JUyJ439GLUjTpyXpurbaTyXfHranEnP3SbG6gwl6ztlKGKW8vRi6Oz90GO227lQ==
X-Received: by 2002:a17:907:7b92:b0:72b:67fb:8985 with SMTP id ne18-20020a1709077b9200b0072b67fb8985mr3817574ejc.569.1660344780276;
        Fri, 12 Aug 2022 15:53:00 -0700 (PDT)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com. [209.85.128.42])
        by smtp.gmail.com with ESMTPSA id e1-20020a170906844100b0072f4f4dc038sm1254419ejy.42.2022.08.12.15.52.59
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 15:52:59 -0700 (PDT)
Received: by mail-wm1-f42.google.com with SMTP id m17-20020a7bce11000000b003a5bedec07bso3172173wmc.0
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:52:59 -0700 (PDT)
X-Received: by 2002:a1c:2582:0:b0:3a5:1453:ca55 with SMTP id
 l124-20020a1c2582000000b003a51453ca55mr9779520wml.68.1660344779450; Fri, 12
 Aug 2022 15:52:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wioqj4HUQM_dXdVoSJtPe+z0KxNrJPg0cs_R3j-gJJxAg@mail.gmail.com>
 <D92A7993-60C6-438C-AFA9-FA511646153C@kernel.dk> <6458eb59-554a-121b-d605-0b9755232818@kernel.dk>
 <ca630c3c-80ad-ceff-61a9-63b253ba5dbd@kernel.dk> <433f4500-427d-8581-b852-fbe257aa6120@kernel.dk>
 <CAHk-=wi_oveXZexeUuxpJZnMLhLJWC=biyaZ8SoiNPd2r=6iUg@mail.gmail.com>
 <CAHk-=wj_2autvtY36nGbYYmgrcH4T+dW8ee1=6mV-rCXH7UF-A@mail.gmail.com>
 <bb3d5834-ebe2-a82d-2312-96282b5b5e2e@kernel.dk> <e9747e47-3b2a-539c-c60b-fd9ccfe5c5e4@kernel.dk>
 <YvbS/OHMJowdz+X3@kbusch-mbp.dhcp.thefacebook.com> <CAHk-=wg0CjDftjxVDGGwfA+rrBsg-nSOsMRS59fAw54W9N53Pw@mail.gmail.com>
 <d5ac5dc5-e477-073d-82cc-a02804c0c827@kernel.dk>
In-Reply-To: <d5ac5dc5-e477-073d-82cc-a02804c0c827@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 12 Aug 2022 15:52:43 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh+8cWCY5axj6VguzuNKgKN0t3u=0h5=OCf9U+cyuhVBQ@mail.gmail.com>
Message-ID: <CAHk-=wh+8cWCY5axj6VguzuNKgKN0t3u=0h5=OCf9U+cyuhVBQ@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fixes for 6.0-rc1
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Keith Busch <kbusch@kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Aug 12, 2022 at 3:38 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 8/12/22 4:35 PM, Linus Torvalds wrote:
> > Honestly, I think maybe we should just stop randomizing kiocb.
>
> That'd obviously solve it... Do you want to commit something like that?
> Or would you prefer a patch to do so?

Please send an updated io_uring pull with that included,

             Linus

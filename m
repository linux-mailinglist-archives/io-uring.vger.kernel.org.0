Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F87A507694
	for <lists+io-uring@lfdr.de>; Tue, 19 Apr 2022 19:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344945AbiDSRe5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Apr 2022 13:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353804AbiDSRew (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Apr 2022 13:34:52 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4155A38DBD;
        Tue, 19 Apr 2022 10:32:09 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id e4so18889590oif.2;
        Tue, 19 Apr 2022 10:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9TRLt0umpK42xe/joZUuCtcbZ6R6cAmp1bJxdUcgm8M=;
        b=XJpQjzjjctWjfGZZgTtSKyIT83IHM45dieg4WsW3ak2hpJ3kPz5fBe7UBbK0wNxoIJ
         ivMYTJzH5nSfURv5rAgqT6W3/nbjOJr+K2C8yMDpYzRAKNtea0GU2KQn1qWFcL5BXG+i
         j3O4+GnfOhQgA4GdyKvqKANlfxsFsCSfIG/uYL+yg/zvZNcUEokQO28bOaFAJcgOSn25
         aMaunSVG5GwIkyUnZCC/xZ/W0HCTmgipivwurrrbRbvCsYM3KAmnuJTz1Po7XK7xT3aW
         WQF5eQ83vqBHR4woYK1i2LaQtI6OjFRYQuFmL3uxFhbr73u1aqNW6CJgmR3PWdWScj2a
         t1vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9TRLt0umpK42xe/joZUuCtcbZ6R6cAmp1bJxdUcgm8M=;
        b=pooYgMkI1s4tz8vGBRCvay0HGQbLTnnfMe90nY3d0OjfyIDYPXsQ6lu/wLDpZWf5B/
         qN1sRiOC16v0/BtXqg59sKOCkztBX4eLRDbSHuMS+oQ8HsSDNNZ51Ti8wZ2QZTxguTaB
         WWNexk0RRzukPBXCA01sbjz4jBeWQvxorwtJLVCFWRr3jrsBrpbzO+rqAvRLh+IL8AaH
         OKLiyQB3uAqu+1O29PlWel7v0M+5EqF0OdUREmydGuiiV9TEPh8hRO0pscbl2Casb+iX
         zojtzWyb3rQ/On/AUu/tLeKexBbtW+gvXDFPVXZDqUPfKxxrsK5J/TUiNThTYlIaROQq
         Kyow==
X-Gm-Message-State: AOAM532n2JaJ3KPqamoC7dn2rnwhDh4Vp/0ZiA2N3Sb+oBQ9CjeLKKRa
        YdHM7M3O5PA/0TNw3mJaw7P/vLTqjvdoXujFdE8=
X-Google-Smtp-Source: ABdhPJzjvbZzKw9AmTVeqJqXQyrX4Xm2mQCN5iTfSaun8qvgGqsIrB7jYyjuk+QaIV2MI5zrGwOmpJwfcJbb0uNqSDw=
X-Received: by 2002:a05:6808:f8f:b0:322:b4ce:a10e with SMTP id
 o15-20020a0568080f8f00b00322b4cea10emr2758955oiw.160.1650389528530; Tue, 19
 Apr 2022 10:32:08 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20220308152729epcas5p17e82d59c68076eb46b5ef658619d65e3@epcas5p1.samsung.com>
 <20220308152105.309618-18-joshi.k@samsung.com> <20220310083652.GF26614@lst.de>
 <CA+1E3rLaQstG8LWUyJrbK5Qz+AnNpOnAyoK-7H5foFm67BJeFA@mail.gmail.com>
 <20220310141945.GA890@lst.de> <CA+1E3rL3Q2noHW-cD20SZyo9EqbzjF54F6TgZoUMMuZGkhkqnw@mail.gmail.com>
 <20220311062710.GA17232@lst.de> <CA+1E3rLGwHFbdbSTJBfWrw6RLErwcT2zPxGmmWbcLUj2y=16Qg@mail.gmail.com>
 <20220324063218.GC12660@lst.de> <20220325133921.GA13818@test-zns>
 <20220330130219.GB1938@lst.de> <CA+1E3r+Z9UyiNjmb-DzOpNrcbCO_nNFYUD5L5xJJCisx_D=wPQ@mail.gmail.com>
 <a44e38d6-54b4-0d17-c274-b7d46f60a0cf@kernel.dk> <CA+1E3r+CSC6jaDBXpxQUDnk8G=RuQaa=DPJ=tt9O9qydH5B9SQ@mail.gmail.com>
 <f3923d64-4f84-143b-cce2-fcf8366da0e6@kernel.dk>
In-Reply-To: <f3923d64-4f84-143b-cce2-fcf8366da0e6@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Tue, 19 Apr 2022 23:01:43 +0530
Message-ID: <CA+1E3rJHgEan2yiVS882XouHgKNP4Rn6G2LrXyFu-0kgyu27=Q@mail.gmail.com>
Subject: Re: [PATCH 17/17] nvme: enable non-inline passthru commands
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Keith Busch <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, Pankaj Raghav <pankydev8@gmail.com>,
        =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,
Few thoughts below toward the next version -

On Fri, Apr 1, 2022 at 8:14 AM Jens Axboe <axboe@kernel.dk> wrote:
[snip]
> >>> Sure, will post the code with bigger-cqe first.
> >>
> >> I can add the support, should be pretty trivial. And do the liburing
> >> side as well, so we have a sane base.
> >
> >  I will post the big-cqe based work today. It works with fio.
> >  It does not deal with liburing (which seems tricky), but hopefully it
> > can help us move forward anyway .
>
> Let's compare then, since I just did the support too :-)

Major difference is generic support (rather than uring-cmd only) and
not touching the regular completion path. So plan is to use your patch
for the next version with some bits added (e.g. overflow-handling and
avoiding extra CQE tail increment). Hope that sounds fine.

We have things working on top of your current branch
"io_uring-big-sqe". Since SQE now has 8 bytes of free space (post
xattr merge) and CQE infra is different (post cqe-caching in ctx) -
things needed to be done a bit differently. But all this is now tested
better with liburing support/util (plan is to post that too).

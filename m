Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F5C591651
	for <lists+io-uring@lfdr.de>; Fri, 12 Aug 2022 22:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238086AbiHLU3V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 16:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235582AbiHLU2c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 16:28:32 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C27DABD71
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 13:28:26 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id z20so2621627edb.9
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 13:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=V7/isdw5RaxnR4x4Z1NEl3zhP71kt9adgt7LrTVuEOM=;
        b=El8VD13nzg3agNljUHLPoHv4wwL+To4mAxMrHxV3SLuFz9WCft48Az/7bBEs/uwZLt
         CN6Nz0qn36aInhx+juIljUkGkGhuB/3FR6nsiASDI1CQg381F3cAcfgUKohL4Sdoc1J0
         Q4Ad7yq+htx+vBs1sPyAVUz7JeBsam+5ldYHE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=V7/isdw5RaxnR4x4Z1NEl3zhP71kt9adgt7LrTVuEOM=;
        b=ZOcll8M351hI8tW3rJppZN8xm8AmSW6VCwIy+nYqQihuAcmBrg5PxbjHJQ6uOUXayX
         8hDzpT465zSsV3IdpIlMUtwIOHIaKkHH+bJKzsInq4LP5SeTjuMaqRpaPwOQ3j5J2U7I
         fcTuLB1H4qZS9ySy4z5cnU0W8/JA2gC2GnldkUJKAKMiPtjSxPar1rFUKoVpUdUMi5Jo
         N0B+7Cxhbo/gldQVqIPf/6t7bzcxUDzf8cM/ru7a3edLIZXsDj5Hcpu0iqJ9Dkfvd8SR
         hGluXBs7jSD7E20uvCqBMHfJ3pozIkFOLBZbxLIdEOG6VHpaIknEv/NdyODs4Sf7m+tP
         wT/Q==
X-Gm-Message-State: ACgBeo0YjB9sx/dJ3BwQAg7ZfTUi+wlWDhAgcZ/5tvzPhZwRMzhxcs48
        ySDabGJ3tUr9YhE4uVgg4TaKLHYV5GC6j8I1
X-Google-Smtp-Source: AA6agR50r6nsaz8El/isXGbxtubAdG8wAN8OQcnfQik6c0S/EL8hOm+Pdz+bdLGgmpZERINndwVxOw==
X-Received: by 2002:a05:6402:430e:b0:43d:1cf6:61ec with SMTP id m14-20020a056402430e00b0043d1cf661ecmr4873594edc.194.1660336104649;
        Fri, 12 Aug 2022 13:28:24 -0700 (PDT)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com. [209.85.128.47])
        by smtp.gmail.com with ESMTPSA id k26-20020a17090646da00b0072b3464c043sm1117065ejs.116.2022.08.12.13.28.24
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 13:28:24 -0700 (PDT)
Received: by mail-wm1-f47.google.com with SMTP id 186-20020a1c02c3000000b003a34ac64bdfso4816064wmc.1
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 13:28:24 -0700 (PDT)
X-Received: by 2002:a05:600c:5013:b0:3a5:d528:9570 with SMTP id
 n19-20020a05600c501300b003a5d5289570mr1763205wmr.8.1660336103804; Fri, 12 Aug
 2022 13:28:23 -0700 (PDT)
MIME-Version: 1.0
References: <b6f508ca-b1b2-5f40-7998-e4cff1cf7212@kernel.dk>
In-Reply-To: <b6f508ca-b1b2-5f40-7998-e4cff1cf7212@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 12 Aug 2022 13:28:07 -0700
X-Gmail-Original-Message-ID: <CAHk-=wioqj4HUQM_dXdVoSJtPe+z0KxNrJPg0cs_R3j-gJJxAg@mail.gmail.com>
Message-ID: <CAHk-=wioqj4HUQM_dXdVoSJtPe+z0KxNrJPg0cs_R3j-gJJxAg@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fixes for 6.0-rc1
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Aug 12, 2022 at 5:46 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> - Small series improving type safety of the sqe fields (Stefan)

This doesn't work AT ALL.

A basic allmodconfig build fails with tons of errors. It starts with

  In function =E2=80=98io_kiocb_cmd_sz_check=E2=80=99,
      inlined from =E2=80=98io_prep_rw=E2=80=99 at io_uring/rw.c:38:21:
  ././include/linux/compiler_types.h:354:45: error: call to
=E2=80=98__compiletime_assert_802=E2=80=99 declared with attribute error: B=
UILD_BUG_ON
failed: cmd_sz > sizeof(struct io_cmd_data)
    354 |         _compiletime_assert(condition, msg,
__compiletime_assert_, __COUNTER__)
        |                                             ^
  ././include/linux/compiler_types.h:335:25: note: in definition of
macro =E2=80=98__compiletime_assert=E2=80=99
    335 |                         prefix ## suffix();
           \
        |                         ^~~~~~
  ././include/linux/compiler_types.h:354:9: note: in expansion of
macro =E2=80=98_compiletime_assert=E2=80=99
    354 |         _compiletime_assert(condition, msg,
__compiletime_assert_, __COUNTER__)
        |         ^~~~~~~~~~~~~~~~~~~
  ./include/linux/build_bug.h:39:37: note: in expansion of macro
=E2=80=98compiletime_assert=E2=80=99
     39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), m=
sg)
        |                                     ^~~~~~~~~~~~~~~~~~
  ./include/linux/build_bug.h:50:9: note: in expansion of macro
=E2=80=98BUILD_BUG_ON_MSG=E2=80=99
     50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: "
#condition)
        |         ^~~~~~~~~~~~~~~~
  ./include/linux/io_uring_types.h:496:9: note: in expansion of macro
=E2=80=98BUILD_BUG_ON=E2=80=99
    496 |         BUILD_BUG_ON(cmd_sz > sizeof(struct io_cmd_data));
        |         ^~~~~~~~~~~~

and goes downhill from there.

I don't think this can have seen any testing at all.

             Linus

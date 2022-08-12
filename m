Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23026591668
	for <lists+io-uring@lfdr.de>; Fri, 12 Aug 2022 22:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbiHLUoY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 16:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbiHLUoX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 16:44:23 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EC491D03
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 13:44:21 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id q19so1891685pfg.8
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 13:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc;
        bh=u8tn7W4R7O7TD8IMKH72/jWBstNz/+3Ad47m6F/q6Hg=;
        b=cCDaqDZk91U41qBNCNfd2vThKYNILQCNIhywyb3y8vHXOsmaXSQ3tLG6gSx0P2afMP
         VZ+hPbkqdCTIW4hpd8f/pmNeO6qxjP0kVMHksMl6A4tNqYrDzfu9vGTK/iOTCS6+RDS1
         sz1zNkEhsx/3NfiwcOfK9H9p/3MrAu1H1Jm+RdQ7DZqN5IsBtJjpkahGpV1dNxu92zVX
         Ift7F3bJNm8CjzkIXGPjj/08h4R4pVHEcTsHYEg8jKqiOnHQAZ/tG4YyiIjVtyUZDejF
         C2hlZ7i9VG06qNJLq0pQMgsUICAnSLay1DSHY/NWebIgdC0/phbCoyuD3cLDlkV1XHoD
         GLdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc;
        bh=u8tn7W4R7O7TD8IMKH72/jWBstNz/+3Ad47m6F/q6Hg=;
        b=wqU4k1/CJ7BWzOSSOCnpObnln4xLf0cjKVg8aohLmgBUbeOH6DMPjLCTEbBC1xl40s
         21RC13IM+JpZ/elI7kBClDRB6co7TpJSwL90730oeAiNKM2L+lPlqoUSV4KEs5NZpkxF
         vCTPcKFiZXTZRkrJzY06hhskJzS0LPQV+PE1AfX9EY0m1Zs3NU+do/kwwE9vQl0FQD4E
         knKx3fgT0Ug1Zysu1dEJbdwtv9pn7FsoXPOTxB6X4GyjpQnKgqBgkxB0UmHrKIIZkBAh
         +G++rCGVu/m42+pOVX5oEF+D+vgxLXlio7jSTzWf2+OBP787caVRTjV8nNJUJyH/o9qq
         /htw==
X-Gm-Message-State: ACgBeo3Fn3qrLeVVg0eDlJdDNoOfiTpIWZxNvpcIlQ5tW2SDHuWdW5X+
        A2546IG5QsGSNT0411a/PS9lYjHCjW3qaA==
X-Google-Smtp-Source: AA6agR6ar6gQThdyXOdesukcQkJMxffExYlLayzMZe0U3XZFVgx6CHVAgO9D6BOd8DZsB0IBnhOnsQ==
X-Received: by 2002:aa7:88cf:0:b0:52f:fdad:9e0 with SMTP id k15-20020aa788cf000000b0052ffdad09e0mr5491579pff.74.1660337061171;
        Fri, 12 Aug 2022 13:44:21 -0700 (PDT)
Received: from smtpclient.apple ([2600:380:764d:1788:51a5:33dc:13d:cd0e])
        by smtp.gmail.com with ESMTPSA id b189-20020a62cfc6000000b0052d1275a570sm2031156pfg.64.2022.08.12.13.44.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 13:44:20 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Jens Axboe <axboe@kernel.dk>
Mime-Version: 1.0 (1.0)
Subject: Re: [GIT PULL] io_uring fixes for 6.0-rc1
Date:   Fri, 12 Aug 2022 14:44:18 -0600
Message-Id: <D92A7993-60C6-438C-AFA9-FA511646153C@kernel.dk>
References: <CAHk-=wioqj4HUQM_dXdVoSJtPe+z0KxNrJPg0cs_R3j-gJJxAg@mail.gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
In-Reply-To: <CAHk-=wioqj4HUQM_dXdVoSJtPe+z0KxNrJPg0cs_R3j-gJJxAg@mail.gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: iPhone Mail (19G71)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,MIME_QP_LONG_LINE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Aug 12, 2022, at 2:28 PM, Linus Torvalds <torvalds@linux-foundation.org> w=
rote:
>=20
> =EF=BB=BFOn Fri, Aug 12, 2022 at 5:46 AM Jens Axboe <axboe@kernel.dk> wrot=
e:
>>=20
>> - Small series improving type safety of the sqe fields (Stefan)
>=20
> This doesn't work AT ALL.
>=20
> A basic allmodconfig build fails with tons of errors. It starts with
>=20
>  In function =E2=80=98io_kiocb_cmd_sz_check=E2=80=99,
>      inlined from =E2=80=98io_prep_rw=E2=80=99 at io_uring/rw.c:38:21:
>  ././include/linux/compiler_types.h:354:45: error: call to
> =E2=80=98__compiletime_assert_802=E2=80=99 declared with attribute error: B=
UILD_BUG_ON
> failed: cmd_sz > sizeof(struct io_cmd_data)
>    354 |         _compiletime_assert(condition, msg,
> __compiletime_assert_, __COUNTER__)
>        |                                             ^
>  ././include/linux/compiler_types.h:335:25: note: in definition of
> macro =E2=80=98__compiletime_assert=E2=80=99
>    335 |                         prefix ## suffix();
>           \
>        |                         ^~~~~~
>  ././include/linux/compiler_types.h:354:9: note: in expansion of
> macro =E2=80=98_compiletime_assert=E2=80=99
>    354 |         _compiletime_assert(condition, msg,
> __compiletime_assert_, __COUNTER__)
>        |         ^~~~~~~~~~~~~~~~~~~
>  ./include/linux/build_bug.h:39:37: note: in expansion of macro
> =E2=80=98compiletime_assert=E2=80=99
>     39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), m=
sg)
>        |                                     ^~~~~~~~~~~~~~~~~~
>  ./include/linux/build_bug.h:50:9: note: in expansion of macro
> =E2=80=98BUILD_BUG_ON_MSG=E2=80=99
>     50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: "
> #condition)
>        |         ^~~~~~~~~~~~~~~~
>  ./include/linux/io_uring_types.h:496:9: note: in expansion of macro
> =E2=80=98BUILD_BUG_ON=E2=80=99
>    496 |         BUILD_BUG_ON(cmd_sz > sizeof(struct io_cmd_data));
>        |         ^~~~~~~~~~~~
>=20
> and goes downhill from there.
>=20
> I don't think this can have seen any testing at all.

Wtf? I always run allmodconfig before sending and it also ran testing. I=E2=80=
=99ll check shortly. Sorry about that, whatever went wrong here.=20


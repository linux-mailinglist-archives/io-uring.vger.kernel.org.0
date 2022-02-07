Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE53D4AC1C1
	for <lists+io-uring@lfdr.de>; Mon,  7 Feb 2022 15:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239356AbiBGOqN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Feb 2022 09:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441833AbiBGOdP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Feb 2022 09:33:15 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DDCC0401C1;
        Mon,  7 Feb 2022 06:33:14 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id o12so27167615lfg.12;
        Mon, 07 Feb 2022 06:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KnaNqe0F/0qK8+8Ot3QUBi9cDcEuhiBIvkTGowrpFEs=;
        b=Pp2Y1sdYIzC+VATQtqdX6bmOnoUIS7hr/RcEeZ0+AeYoQ9S2gTYb4ZXM8iclajmCME
         0r0rXd28riCvI5VWZp41PbGv+sS0prg0MIzKJmnh7kEgQPqdKrmr3ePDYkMigzlPJ5VF
         f5k+/0q0SLCpknP08JXKP1wBTTZ/6iGnMPcvyjBXw3ChCzm7NSnfPc4s8RBtoLcbidlu
         xN/6xfJQflvLWhelC7wQqRJWBO3jCZrxfDWJqp1PAv6Y7wCV2OG0ziCRvbUoNTX9l+xa
         JiF9oXLlfG4DO6CMxkHt4bL6nA51343foGp0u7Ud8bouZ4Pc+DglhhdNTFpuMhQOtG/Q
         nz5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KnaNqe0F/0qK8+8Ot3QUBi9cDcEuhiBIvkTGowrpFEs=;
        b=4HYnGeW7nN9hjpa5FQg/qqfSXfhZHJMIdUxNdZAnN1NxURK++anjEqlZT35VOmH1Ix
         P24aG6aK5rI02XBdhEkTnlMhxTHkYu+ikVXMQfZL5sf6CJX44Url6FoJBMwg1rDvLrk4
         TgLLEW1fZLluOPiVYVk4lv0SBRdcDxHF256FZeKmSiKhhYVKYIO85UKD90HtmzvSc64t
         6JE3slFithlflK99hV0QuU4Wa9L2sFnKmhULg/lTcab+M1SfRRwlRBQTFZS4pfI2KNGV
         suJ+cey7GLzh4qghJo3mn2/5VfE6VEyQW6lu25HJuIMMjq3U9oOvErCgmltwloheIflu
         8wAg==
X-Gm-Message-State: AOAM533NtAdSnUjaKWH8MqUhvJBg4SE9XELBloNhzWvr+njkxyfDKyre
        baaj/Jj/xaR9irWgy26MSlDRoYuD647ba4mbrXc=
X-Google-Smtp-Source: ABdhPJzqYRh55B1K0DlHc0a9idH2yG3fhQdcqL0ycqGvzogj798XtyNELAgH38g/ltV5HyyUsCGJjzLFNXsYU4UEipQ=
X-Received: by 2002:a05:6512:1151:: with SMTP id m17mr8599456lfg.610.1644244393124;
 Mon, 07 Feb 2022 06:33:13 -0800 (PST)
MIME-Version: 1.0
References: <d33bb5a9-8173-f65b-f653-51fc0681c6d6@intel.com>
 <20220207114315.555413-1-ammarfaizi2@gnuweeb.org> <91e8ca64-0670-d998-73d8-f75ec5264cb0@kernel.dk>
 <20220207142046.GP1978@kadam>
In-Reply-To: <20220207142046.GP1978@kadam>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>
Date:   Mon, 7 Feb 2022 21:33:02 +0700
Message-ID: <CAOG64qN1fQ_surhMJSuygyf_emSvFm3HKRgj_JAZteFVjaP3+A@mail.gmail.com>
Subject: Re: [PATCH io_uring-5.17] io_uring: Fix build error potential reading
 uninitialized value
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        "GNU/Weeb Mailing List" <gwml@gnuweeb.org>,
        io-uring Mailing list <io-uring@vger.kernel.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        "Chen, Rong A" <rong.a.chen@intel.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Feb 7, 2022 at 9:21 PM Dan Carpenter <dan.carpenter@oracle.com> wro=
te:
> On Mon, Feb 07, 2022 at 06:45:57AM -0700, Jens Axboe wrote:
> > On 2/7/22 4:43 AM, Ammar Faizi wrote:
> > > From: Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>
> > >
> > > In io_recv() if import_single_range() fails, the @flags variable is
> > > uninitialized, then it will goto out_free.
> > >
> > > After the goto, the compiler doesn't know that (ret < min_ret) is
> > > always true, so it thinks the "if ((flags & MSG_WAITALL) ..."  path
> > > could be taken.
> > >
> > > The complaint comes from gcc-9 (Debian 9.3.0-22) 9.3.0:
> > > ```
> > >   fs/io_uring.c:5238 io_recvfrom() error: uninitialized symbol 'flags=
'
> > > ```
> > > Fix this by bypassing the @ret and @flags check when
> > > import_single_range() fails.
> >
> > The compiler should be able to deduce this, and I guess newer compilers
> > do which is why we haven't seen this warning before.

The compiler can't deduce this because the import_single_range() is
located in a different translation unit (different C file), so it
can't prove that (ret < min_ret) is always true as it can't see the
function definition (in reality, it is always true because it only
returns either 0 or -EFAULT).

>
> No, we disabled GCC's uninitialized variable checking a couple years
> back.  Linus got sick of the false positives.  You can still see it if
> you enable W=3D2
>
> fs/io_uring.c: In function =E2=80=98io_recv=E2=80=99:
> fs/io_uring.c:5252:20: warning: =E2=80=98flags=E2=80=99 may be used unini=
tialized in this function [-Wmaybe-uninitialized]
>   } else if ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_C=
TRUNC))) {
>              ~~~~~~~^~~~~~~~~~~~~~
>
> If you introduce an uninitialized variable bug then likelyhood is the
> kbuild-bot will send you a Clang warning or a Smatch warning or both.
> I don't think anyone looks at GCC W=3D2 warnings.
>

This warning is valid, and the compiler should really warn that. But
again, in reality, this is still a false-positive warning, because
that "else if" will never be taken from the "goto out_free" path.

-- Viro

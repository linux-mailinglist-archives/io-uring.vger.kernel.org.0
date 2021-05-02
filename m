Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0455370DC5
	for <lists+io-uring@lfdr.de>; Sun,  2 May 2021 17:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbhEBP7A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 2 May 2021 11:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbhEBP67 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 2 May 2021 11:58:59 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E152BC06174A;
        Sun,  2 May 2021 08:58:07 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id d15so3937868ljo.12;
        Sun, 02 May 2021 08:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aFpxfTKr2HRrDeHRZnDYfrEggt3RxLhJLELzvPzuWFw=;
        b=j8qSF5iTZ4KST8CIElWxP3hb2rpaKcMJOPH3ZQIEK2zp4DFZpw9xu1B4+i/58Z719m
         iLx+5agUfgiVifedWVMJvoDaE9FG2WZtLv7NGVH5mNa1EEbvt/nIUKJ5SAay/cbNZmGd
         vd19OjcoSXwuUTWIMr43K/gmdczhNtyujPFO1KAI84RjIGLC20peLZnswyfixOgNIxQb
         3B4+vR5BnA2aCJjR1jktJbzCg2uIJLT8PtGxU0Wu+94jYCplNGN8MjvKouLqPk5Ph8zk
         i6fzd34Cx7SD/hsxIi7XJXCtIg4WiHZpcDMbaL1VJeJLlyuR0V41qZofzA3G6HX2oopN
         vsPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aFpxfTKr2HRrDeHRZnDYfrEggt3RxLhJLELzvPzuWFw=;
        b=DHlF6Toj2RfRRHcetxscD8FqKRG3Kzw+tGW5ij2lKrOJQbZ14HfN7TwkZ1GAH9xwmR
         cfFWS0bxBuX70yBmOReC0fcYay4yh7pZ/6EpaolRZU4znAG5/21QxKLE9DYkiyhyKYKA
         P+eBNH3p0Zq3Ho5K0yf+7WXGq9Bc053tZy7c+EM+AwzjMdfPseu6rEqNwEA4mEP7H/Ds
         Zr0VLAhgrNy9VtyybnTVOzXOtAadAGK/MeHbdLHpSEmPCOysPqwHcV9EeW6BzcQrjBnc
         dY+uYvTDl7Vr+DAhFwMf2XkmTpxeA2xE+4eex0d8dTWutrH3G6DmdIFjaRGqegD5Pa5d
         wr0A==
X-Gm-Message-State: AOAM532bhH3ARgIN4ujmBMZaY3WSRwTKOsxJAmMh99kqS+GGfIvlMl9G
        CbwlMquD+fhRgVQts26whq/pN/sNDmYNniJRoA3LMflirgM8JwCV
X-Google-Smtp-Source: ABdhPJx1XbMUECycu+v4o3tcpzIH59tRxyYNnrOP117hrfu1DNdsbN7r7CC9iRVcWbLe+ilczHWt2/iwh+zwFa2pFMw=
X-Received: by 2002:a2e:91d8:: with SMTP id u24mr5778345ljg.471.1619971086404;
 Sun, 02 May 2021 08:58:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAGyP=7exAVOC0Er5VzmwL=HLih-wpmyDijEPVjGzUEj3SCYENA@mail.gmail.com>
 <4b2c435c-699b-b29f-6893-4beae6d004a9@gmail.com> <CAGyP=7cGLwtw=14JSfOd40x08Xsj3T2GCeWTjDf2z2v0nb8e9Q@mail.gmail.com>
 <e968c546-fbfd-2fec-0380-af81df7c791f@gmail.com>
In-Reply-To: <e968c546-fbfd-2fec-0380-af81df7c791f@gmail.com>
From:   Palash Oswal <oswalpalash@gmail.com>
Date:   Sun, 2 May 2021 21:27:54 +0530
Message-ID: <CAGyP=7dnUO2no7MoytuNeQkdKe2H3Tpwh8CvFvAPNURV0n+dqg@mail.gmail.com>
Subject: Re: KASAN: stack-out-of-bounds Read in iov_iter_revert
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, May 2, 2021 at 9:25 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 5/2/21 4:13 PM, Palash Oswal wrote:
> > On Sun, May 2, 2021 at 4:07 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >> May be related to
> >> http://mail.spinics.net/lists/io-uring/msg07874.html
> >>
> >> Was it raw bdev I/O, or a normal filesystem?
> >
> > Normal filesystem.
>
> To avoid delays when I get to it, can you tell what fs it was?
> Just it case it is an fs specific deviation
>
> --
> Pavel Begunkov

root@syzkaller:~# mount
/dev/sda on / type ext4 (rw,relatime)

I used https://github.com/google/syzkaller/blob/master/tools/create-image.sh
to build the qemu image.

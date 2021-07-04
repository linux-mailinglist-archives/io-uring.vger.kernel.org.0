Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A463BAC94
	for <lists+io-uring@lfdr.de>; Sun,  4 Jul 2021 11:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbhGDJxn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Jul 2021 05:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhGDJxm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Jul 2021 05:53:42 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999B6C061762
        for <io-uring@vger.kernel.org>; Sun,  4 Jul 2021 02:51:06 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id w13so19770648edc.0
        for <io-uring@vger.kernel.org>; Sun, 04 Jul 2021 02:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=degennaro-me.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=z4MMvc9fY3jzKX8HfymbV44/glwUcjlquBIRwUvX59s=;
        b=FBaA4Rsyci6gIbw/GO688F3RSbaetyka83AOYWZBInLO1xE138KMUKcXrPwBgWOGsU
         9BkqyZFOMOKsJOaaXZg0EDacTmoShdAm1btUV0XSRCFDJbBBGVVEqAr7iSX/iz11Ts0d
         Be1lkxDh3aKQoHegyHAGS9rMvA4bPnenufyFL5K6X75HI1Di+WDFfuEC4MPmXnDnc1Yu
         RQ+f1YL7zEwlEbMhQNaJK0HX1JUM+vgsg7O1oKd7dNG/JDIyYcqGbwo4pGn06oTafiQo
         G1zr4stvMH3et0utkh78fXY5CPK07Gm2oHQRwXyncSyJhAGRq4Snbr1AQKj78oPfYfGT
         kbrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=z4MMvc9fY3jzKX8HfymbV44/glwUcjlquBIRwUvX59s=;
        b=G9CwaXZh6XJ/6x9T2vZDgCEfnIyjWdwvqCgIArLg4Evcnwc6QAd42YtM7UtGF9xPMr
         Nf2BI4C2664qGuSKwXWwA5UNa0YpYUJx8lYP0PDdryeN8lTcXsKM6kxDmPKGGIOBwkvb
         /8i5AIFvbkySsuBDaAE3/00Fj9N0XbPxK4uxfen3BqC3rjqKDe5YU25VTum4cC7zxILt
         yxVck9Pic6xje+pZ438xSWY+GGS+PimxtTeTZhL3z1x6lrL2fbOJd2jAoLaUbXmM/wh9
         xaY51SF6OW6V0Y2i2SzChKmD7NElEJC7Th/TnXn8FEFtyA0+DhN/AMhnN8eexqlSpYMt
         q3JQ==
X-Gm-Message-State: AOAM53360fDmMchcA0Ik1uF9h2ZvLwiPi/fGpN5CaG8PRxWl8IM5yLB/
        Du2tZ4LZkaQGhQbw5LR52wIoLwejbr8EVkS5h4QLwdplTc9XD7wt
X-Google-Smtp-Source: ABdhPJxIv9CZssidldWRrhi2ulrOw4Z8IX+5ljPLjIfW7tPzDI6xsMGA6YSD39i7rS1n8+qaNd5TvMwmWQ0p+JwNf30=
X-Received: by 2002:aa7:c1da:: with SMTP id d26mr9550510edp.278.1625392265068;
 Sun, 04 Jul 2021 02:51:05 -0700 (PDT)
MIME-Version: 1.0
From:   Mauro De Gennaro <mauro@degennaro.me>
Date:   Sun, 4 Jul 2021 11:50:54 +0200
Message-ID: <CAGxp_yhoUAAvbttOaRvWx3EsmPKZVumFZQz2uQGUPGhuN8AiVQ@mail.gmail.com>
Subject: io_uring/recvmsg using io_provide_buffers causes kernel NULL pointer
 dereference bug
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

First time reporting what seems to be a kernel bug, so I apologise if
I am not supposed to send bug reports to this mailing list as well.
The report was filed at Bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=213639

It happens on 5.11 and I haven't tested the code yet on newer kernels.

Thank you.

Best,
Mauro

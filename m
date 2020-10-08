Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14BF287C24
	for <lists+io-uring@lfdr.de>; Thu,  8 Oct 2020 21:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgJHTNo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Oct 2020 15:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgJHTNo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Oct 2020 15:13:44 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D63C0613D2
        for <io-uring@vger.kernel.org>; Thu,  8 Oct 2020 12:13:43 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id dn5so6939700edb.10
        for <io-uring@vger.kernel.org>; Thu, 08 Oct 2020 12:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MD5qdM4y5+/ccgMrP1k9E25iq0CoiOLNN0HNPRrcG58=;
        b=DpUGB6BQRDH9BaQ/nG5mUoHH829Ux6FtNtcd+nkC8CiUE8c1mEQs7AWde9cccHglT8
         RobwOlxnUx2OXfk4Z26M+CPplbYejMpNczwVzuDRuWRTOvuTeRG+bTkj3lpMYo+BeRrw
         8tgWi5vDC19TLxM+3cUv6svbvUwW08/5agjfPL3zbg/kH0rE6X+fqw9MwSeSd+lKAJN4
         jEzbY08O6moENOKeth0R6XeLpyk1+eeZmDUQiS+O0uvGVujEQZtfdnoGwJ1KTs8VXvhh
         TPZQhFVbTJYG2cEW2sjfOlq5NxTV+aftWRS2CdgEq3G6xCCZ3tcdRFCPPY1BU73uRI3p
         qxzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MD5qdM4y5+/ccgMrP1k9E25iq0CoiOLNN0HNPRrcG58=;
        b=SZct/0rplCQHa5BeAE8zgBSISDFyJl/fV6hVCloRgssnmzAWJWp1gYqjLIL2FA58DU
         7i1ygjxzoAkfSUwgEDC0r8WzeKzJIU2RUFAy0ZpCB/qgFc9AVIJK7RItZdjCr+vH75Ml
         ud8hyOybWmBYX0kd9wzeNUwG3g6b6JO4RZWn7krANx+jWtevk6UXYiV9YIp4rwJ2kcz8
         mpBI9vYXapNvm8PnDTTRcPh4T4IA2AUUumYMT8dN/3v2DOBNUXKSJCYxo7YL9UKW7xyW
         bAGZ9ClmOD9+7h2k7qMfAwtF6s0HhoyAAz0iwPp9+YoIIyKynxI/IuS+0IfpG6EeieD3
         Q+Xg==
X-Gm-Message-State: AOAM5305mfySvV+E74mfxcbwkkPBSLTaAXByb1eyyAEbcle6YWwYEKiP
        0EygN95kKrEFjOGujW5XXj4WwJ2EDAWR5m0XouqsWw==
X-Google-Smtp-Source: ABdhPJxVKRIAyl2fZrCxv9N7Eg/tbxJSi5Z2oIn7bsd9l66WVVHOpypjPgqQjftYXt+nzoF3S1j8JESEXwKTQ2nv25U=
X-Received: by 2002:a05:6402:74f:: with SMTP id p15mr1470411edy.69.1602184422053;
 Thu, 08 Oct 2020 12:13:42 -0700 (PDT)
MIME-Version: 1.0
References: <f7ac4874-9c6c-4f41-653b-b5a664bfc843@canonical.com>
In-Reply-To: <f7ac4874-9c6c-4f41-653b-b5a664bfc843@canonical.com>
From:   Jann Horn <jannh@google.com>
Date:   Thu, 8 Oct 2020 21:13:15 +0200
Message-ID: <CAG48ez1i9pTYihJAd8sXC5BdP+5fLO-mcqDU1TdA2C3bKTXYCw@mail.gmail.com>
Subject: Re: io_uring: process task work in io_uring_register()
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 8, 2020 at 8:24 PM Colin Ian King <colin.king@canonical.com> wrote:
> Static analysis with Coverity has detected a "dead-code" issue with the
> following commit:
>
> commit af9c1a44f8dee7a958e07977f24ba40e3c770987
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Thu Sep 24 13:32:18 2020 -0600
>
>     io_uring: process task work in io_uring_register()
>
> The analysis is as follows:
>
> 9513                do {
> 9514                        ret =
> wait_for_completion_interruptible(&ctx->ref_comp);
>
> cond_const: Condition ret, taking false branch. Now the value of ret is
> equal to 0.

Does this mean Coverity is claiming that
wait_for_completion_interruptible() can't return non-zero values? If
so, can you figure out why Coverity thinks that? If that was true,
it'd sound like a core kernel bug, rather than a uring issue...

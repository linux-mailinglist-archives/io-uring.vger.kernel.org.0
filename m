Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB112DF449
	for <lists+io-uring@lfdr.de>; Sun, 20 Dec 2020 08:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbgLTHOo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Dec 2020 02:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbgLTHOo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Dec 2020 02:14:44 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBE2C0613CF
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 23:14:04 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id 2so4598878qtt.10
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 23:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9A+gmyw763bP7OgyIjglaoixMHn184NLSU84ISVBVJ8=;
        b=ep9F0Xyffu9QhG4pkRzWUZukwTMrdUERpVI715ZgD6ZN0YuwnX1uJbwyIf2VhFVVGk
         G/i8WdaOao3uw4jm1g6Y9bGjeuxpxRlat1EmxraHYgCo50RULAah6MpoqOK/VfeF1bH7
         lM8fYorSIggonj7P4VA5e1qjJ6jmTEKoyrsIP7R7Fv+wzbOOahcut+7IIHRhd8Zju/2z
         IBpqOiyRHrJmGU5yqdBSZY8t4FLTnIE+qSaQ30CS3lZh6S1rgDm8SyFwqXxE1mI/AWvo
         cCp5Ez9qH6GvAamfGW3p1FScF1jW6ZmTbNAHrCL9TZEm13m/5aCXvyWnaf94eCs2hWOc
         pABw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9A+gmyw763bP7OgyIjglaoixMHn184NLSU84ISVBVJ8=;
        b=D0wNMhhjZXLIG4nts55WB6+uoucrj3V/nh/o+hmuPZyngCD21J/cVpZcxNrT+3VHvp
         28z94TwPOWkw1ItkT7JaP3afLZZKn4Mhap6DsQoK92j/dWseaEPQqMJRV6oZZLE8VN3I
         CbBilknHs5CgJBDlmeA90dJv60mYkJIqwqBZQZu1Q96Y9zMLr2pGFFKWk2PIFWxxDIHx
         DdTMhTJMI/+tv9Jd65Y1zgKzIw3IqsnpYHcC0PnpA4Pk+lyIqncPuTg+k5aqsBEl+Dhz
         e+ijkgxZ/BRLSBoHMbksDkwrHLWhrNsWR5genmUNKEj6o6C9gSyRoI5FcXF3zs54Ae2F
         Cu1w==
X-Gm-Message-State: AOAM531uNv1inlTy7NgZ6lHtVA8xpLIeQOA4SyCN/MKDsINe6nYirVEq
        J2PsgqOkFy4rfyS5dtFCr+2gPcK3hzV1PgHA9RI=
X-Google-Smtp-Source: ABdhPJwDIAomFgFB3rCwSiAlmhXGWxJtB+1GExgRuga4yGt+ncPzkuvR27RJkrjZlM2GHiWVYtMQFyhNBhiRnhvCEMc=
X-Received: by 2002:ac8:729a:: with SMTP id v26mr11707899qto.53.1608448443308;
 Sat, 19 Dec 2020 23:14:03 -0800 (PST)
MIME-Version: 1.0
References: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
 <2B352D6C-4CA2-4B09-8751-D7BB8159072D@googlemail.com> <d9205a43-ebd7-9412-afc6-71fdcf517a32@kernel.dk>
 <CAAss7+ps4xC785yMjXC6u8NiH9PCCQQoPiH+AhZT7nMX7Q_uEw@mail.gmail.com>
 <0fe708e2-086b-94a8-def4-e4ebd6e0b709@kernel.dk> <614f8422-3e0e-25b9-4cc2-4f1c07705ab0@kernel.dk>
 <986c85af-bb77-60d4-8739-49b662554157@gmail.com> <e88403ad-e272-2028-4d7a-789086e12d8b@kernel.dk>
 <df79018a-0926-093f-b112-3ed3756f6363@gmail.com>
In-Reply-To: <df79018a-0926-093f-b112-3ed3756f6363@gmail.com>
From:   Josef <josef.grieb@gmail.com>
Date:   Sun, 20 Dec 2020 08:13:52 +0100
Message-ID: <CAAss7+peDoeEf8PL_REiU6s_wZ+Z=ZPMcWNdYt0i-C8jUwtc4Q@mail.gmail.com>
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Norman Maurer <norman.maurer@googlemail.com>,
        Dmitry Kadashev <dkadashev@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> Guys, do you share rings between processes? Explicitly like sending
> io_uring fd over a socket, or implicitly e.g. sharing fd tables
> (threads), or cloning with copying fd tables (and so taking a ref
> to a ring).

no in netty we don't share ring between processes

> In other words, if you kill all your io_uring applications, does it
> go back to normal?

no at all, the io-wq worker thread is still running, I literally have
to restart the vm to go back to normal(as far as I know is not
possible to kill kernel threads right?)

> Josef, can you test the patch below instead? Following Jens' idea it
> cancels more aggressively when a task is killed or exits. It's based
> on [1] but would probably apply fine to for-next.

it works, I run several tests with eventfd read op async flag enabled,
thanks a lot :) you are awesome guys :)

-- 
Josef

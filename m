Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7220734E02F
	for <lists+io-uring@lfdr.de>; Tue, 30 Mar 2021 06:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbhC3Ecs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Mar 2021 00:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhC3Ecd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Mar 2021 00:32:33 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788F6C061762;
        Mon, 29 Mar 2021 21:32:32 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id k3so5694377ybh.4;
        Mon, 29 Mar 2021 21:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8UOjwXmn4nf9zItYG6/NyUPHbJkTPi+XlQ9dAsXztIo=;
        b=OQbe3zjHIQXdkbq3HZvrB6zq9XTTzoAEJLMk/Ec9QK0I9sE+oDczECGTr5B27lMHfn
         EWvrFJDwp5mYxb620BipZXYKNPX7ybdgM+EIEMUx9T13a8AaCp/Wqi90Jzg/5VSI8QhD
         6aWJdKGYYdvdpEleqhVk95ZKHqos96BNQCC8IN8wlD+VxVWZ1AiLZBgcwSOqlGqw9wXv
         HpFcTqsAwsJ8Vix+3+rKYBrfyau5dZeh6rQW0GowMSyyfs0mtSkOKmFPV8w5p2KhD9h8
         p1bDhuV5ozkDW8DiO9OESEBguEVDuaaZuKjU3kQ5B01ameqr4skT1up2535e4/HTJml7
         YpFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8UOjwXmn4nf9zItYG6/NyUPHbJkTPi+XlQ9dAsXztIo=;
        b=ZULkrEuxWfSJBx44mYIfjfJRgoNnQDxrcWm4aelKY++Acu6EKmdVCYrMWOVP1gdCxM
         dKOxxjtnBXTaQ8f3K0OuU/7NT1YddCAmfEJPsFPlLgrQadWGOIojiq5iC4pc7i8BF/SH
         cnlCKoB7tizYx9Ae1HIT8wRdgqN1Szx9IenRL6c95rkOStmvsDqFhiY6cd72llNmXirE
         gH4Y0/YogyvfEkTuzCjF2N55/sayGL5I5pv0jQs0bzd8ZS866RFk4d9jsZnDC5qeD+h/
         qhBJz102G5G7JrCOwZZe9MS++FVtf4UOuvHNhpKbkcVXId4VMT3MldFVy21f2A/uyjWB
         oS/g==
X-Gm-Message-State: AOAM532J8OGm8JAFjhQ/7MJFqtI4vtD58pjXr2n+l2JbTEoBM94sMSgn
        LwGDIcRVO/Sn1HTQIJNRGgIRvFvm6rwlbXiFXFgtZZevdho=
X-Google-Smtp-Source: ABdhPJx2inaN7aos17kqtnO502JmtLoRNxYR++Zm2z9iAv7LgNwkYtCz52p3ANriuzRs+xp1hcxlTfCE79LNsp5WOGY=
X-Received: by 2002:a25:d0c7:: with SMTP id h190mr39450935ybg.428.1617078751736;
 Mon, 29 Mar 2021 21:32:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210202082353.2152271-1-dkadashev@gmail.com> <81aae948-940e-8fd3-7ac8-5b37692a931b@kernel.dk>
In-Reply-To: <81aae948-940e-8fd3-7ac8-5b37692a931b@kernel.dk>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Tue, 30 Mar 2021 11:32:20 +0700
Message-ID: <CAOKbgA4t7dQfptjSDwQEeH9iBhq8k0kHWqC4OTRq-u2QEvCa6A@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] io_uring: add mkdirat support
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 30, 2021 at 3:37 AM Jens Axboe <axboe@kernel.dk> wrote:
> On 2/2/21 1:23 AM, Dmitry Kadashev wrote:
> > Based on for-5.11/io_uring.

Actually this was a typo (copy-n-paste error), it was on top of
for-5.12/io_uring. Doesn't really matter though.

> Can you check if it still applies against for-5.13/io_uring? Both the
> vfs and io_uring bits.

It does not (the io_uring bits), I'll send v3 soon.

-- 
Dmitry Kadashev

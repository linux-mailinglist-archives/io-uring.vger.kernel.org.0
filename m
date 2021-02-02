Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDDE430C7D5
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 18:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbhBBRcq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Feb 2021 12:32:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234191AbhBBRb0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Feb 2021 12:31:26 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3662C061786
        for <io-uring@vger.kernel.org>; Tue,  2 Feb 2021 09:30:46 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id r12so31203822ejb.9
        for <io-uring@vger.kernel.org>; Tue, 02 Feb 2021 09:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X8jwe4D2XOHlStDI5uH+AavaPYTgL/PeKlkIwjG5cKo=;
        b=lGRsgg/u+l2XzVlKCRCG80smlgBS/92yQ1Dl3OZ8sag9ltHpQu1axyd1cRuoz0nvpF
         Dxp1D3P9Ld2v9pDRAMbi5wFnxFUkruqkdVwTDWCrQ4JupFnNrmeOGJkMGLWGVFBzN4M9
         uL8C21CEOqV4fcFZWH6pPpmxSqnE0BLsJrLOSI0Ir/mb0mRGjXpEtTMDH1SrvqehEidL
         EkC00JOgRzFaNZOjAHdFhxtfVzchTIkKmdGz+gpWSjFpQe4cEnTTr6gy1NnHOKdBqrvN
         ootBh9Jmbg4H5GfMOErmtfeuBgBBqSlw/D3SqllJEZDeQsRGfz8bsoKrmtYNnPqEhyI9
         J2yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X8jwe4D2XOHlStDI5uH+AavaPYTgL/PeKlkIwjG5cKo=;
        b=QdSxHH54r9pJpzo0LX2via7GQDikkhnECctNZrXEiJE+IOxZb8rWCfGhucL1cHO97w
         DZHWMawbuR2BMNJGVH4++SOO9gvsUN8/ejGQd3mFARZmfSVl9hoxuElOwKVR4QMmoRj8
         ridHKW60flHg7/CFNyiVrmYKzx0Dpa+/YYY9BAAwjDkbTeEMFhmOoqLNKX7Sf7LeB6qQ
         6PDLXw7zzx4ncXDEMZdaJJEM2jF/aLjKvzWUvjLShVfGTN9+hNwdqMTexd3GYI57CVZy
         2E/e/DLl56Fj4RzAqeRada38mTkeMVfwyPJ2D8Hai7zWlWd6Pn8iK84F3d8FQPDPJcgH
         NYTw==
X-Gm-Message-State: AOAM530TAedSPtYCVZtVBzChWIoUFEBa48hFOhPckVvbkEgjQyEUGIg7
        IEm67D3LDJ7yvIzOKWvnFEAMNJL/s0Xi6XDzxNldnw==
X-Google-Smtp-Source: ABdhPJwNTQF1Xd2yLfKuh/yvrCQ3dOCj6LRte7DZsZw0UgOfaP9OjXz9X0UfYm8JJnlcrbZgQZYeZAqgyouLeC5a8HQ=
X-Received: by 2002:a17:906:c0c9:: with SMTP id bn9mr8505248ejb.318.1612287045512;
 Tue, 02 Feb 2021 09:30:45 -0800 (PST)
MIME-Version: 1.0
References: <CAM1kxwhCXpTCRjZ5tc_TPADTK3EFeWHD369wr8WV4nH8+M_thg@mail.gmail.com>
 <49743b61-3777-f152-e1d5-128a53803bcd@gmail.com> <c41e9907-d530-5d2a-7e1f-cf262d86568c@gmail.com>
 <CAM1kxwj6Cdqi0hJFNtGFvK=g=KoNRPMmLVoxtahFKZsjOkcTKQ@mail.gmail.com> <8a3ba4fc-6e60-a3e7-69f4-0394799e7fd7@gmail.com>
In-Reply-To: <8a3ba4fc-6e60-a3e7-69f4-0394799e7fd7@gmail.com>
From:   Victor Stewart <v@nametag.social>
Date:   Tue, 2 Feb 2021 12:30:34 -0500
Message-ID: <CAM1kxwgOwWhv=O_vOpyQfca-9Vjo4+SrmxPR5MxTGf_9pE4_Gg@mail.gmail.com>
Subject: Re: bug with fastpoll accept and sqpoll + IOSQE_FIXED_FILE
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> There is a change of behaviour, if IORING_FEAT_EXT_ARG is set it
> won't submit (IIRC, since 5.12) -- it's pretty important for some
> multi-threaded cases.
>
> So... where in particular does it say that? In case your liburing
> is up to date and we forgot to remove such a comment.

https://github.com/axboe/liburing/blob/c96202546bd9d7420d97bc05e73c7144d0924e8a/src/queue.c#L269

"For kernels without IORING_FEAT_EXT_ARG (5.10 and older), if 'ts' is
specified, the application need not call io_uring_submit() before
calling this function, as we will do that on its behalf."

and I'm using the latest Clear Linux kernel which is 5.10, so that's
why I wasn't submitting.

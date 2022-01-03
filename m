Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D226A48340C
	for <lists+io-uring@lfdr.de>; Mon,  3 Jan 2022 16:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbiACPSA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Jan 2022 10:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiACPR7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Jan 2022 10:17:59 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CF3C061761
        for <io-uring@vger.kernel.org>; Mon,  3 Jan 2022 07:17:59 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id x7so75655957lfu.8
        for <io-uring@vger.kernel.org>; Mon, 03 Jan 2022 07:17:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ry3k6TMSdh/DK80Rx4rIhtXsJ2SvLfemPDT0neaiOU4=;
        b=W37kuECTvbS1vNsDuS3JXCpVtqICrFAp977bN1fRG0Mz1HvKwbq9TgwEEAiIYbczYD
         v4uV0LmWcZ6fmkei07vokBYVac5FGq2tVpdiA4pFVyT92QNnCFPsdQJkV8siEHCBGkYS
         JVQKKct1+Ndp0N+ObC92AStzKq+D3B/ARUeR1w/MJXRYBzx2GbtIK3QrH2xRWa3VzLye
         MoBrLR2xclB4/y7i+Cltv7pCQWF/v0VX8sAT76uY+ga1q2toX3Dlh9WZ8N6XQB7MIoBn
         sjHtlCg+nPH8I0cbBXj5eXUlN3Bh6fkE37xH/+aNmjyerWPdReKDi1N1dSQpnjtmfi0A
         UX/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ry3k6TMSdh/DK80Rx4rIhtXsJ2SvLfemPDT0neaiOU4=;
        b=NbUK/MZX4YMsiofkdUPfPAJTmxAJAJV8sV79iGflj59/6pS2D3lfRY3vtI8tF6AVVx
         xU0x0OBYWdI6f3RG6cb/T3m63zx7TjC6CbWMRkDxWCeFsMf+KSvjd6JDg220DSzPLa3P
         72n/QTXQcHmuleFUHUGoF24Z9yE81QB6//uHTkbywX8nxVFFkOQ8Mrfqs2ZmviuJV9sI
         3LjbtmB2RIhZIxgcTwjlLDu8f6MKOdmUsGU0Dz6RuBRgbprvOsedYsen/qLF73prnJu7
         pwzqy9qXRNVnNIM84zn+gf0/CKwRdz6fg/tdAwhCchObLplnEhOAp6/j89MwpDHXsZSE
         hJXg==
X-Gm-Message-State: AOAM533mAb/uTsEgc9iX7riIVUVrqcE33aHUXpQP/dBEyv4+aBSgg6rs
        DvO6QH6Lg3+UKsPc1J98y4yFTnnzFM1Xr09QPcga+Q==
X-Google-Smtp-Source: ABdhPJygtMLxs8vYujwNA8bJLtMKxAhntijZICzkrJxSek8Y004N4PXvHfUX27r6UuGE4ezp7ZgyiqNjz7TtifW3zDk=
X-Received: by 2002:a05:6512:22c7:: with SMTP id g7mr40020775lfu.315.1641223077495;
 Mon, 03 Jan 2022 07:17:57 -0800 (PST)
MIME-Version: 1.0
References: <8a9e55bf-3195-5282-2907-41b2f2b23cc8@kernel.dk>
In-Reply-To: <8a9e55bf-3195-5282-2907-41b2f2b23cc8@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Mon, 3 Jan 2022 16:17:31 +0100
Message-ID: <CAG48ez3ndoSC=fRvmzku1hLkO99RPwA3F3PA5mVZ47AkU5q-5A@mail.gmail.com>
Subject: Re: [PATCH RFC] io_uring: improve current file position IO
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Dec 24, 2021 at 3:35 PM Jens Axboe <axboe@kernel.dk> wrote:
> io_uring should be protecting the current file position with the
> file position lock, ->f_pos_lock. Grab and track the lock state when
> the request is being issued, and make the unlock part of request
> cleaning.
>
> Fixes: ba04291eb66e ("io_uring: allow use of offset == -1 to mean file position")
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ---
>
> Main thing I don't like here:
>
> - We're holding the f_pos_lock across the kernel/user boundary, as
>   it's held for the duration of the IO. Alternatively we could
>   keep it local to io_read() and io_write() and lose REQ_F_CUR_POS_LOCK,
>   but will messy up those functions more and add more items to the
>   fast path (which current position read/write definitely is not).
>
> Suggestions welcome...

Oh, that's not pretty... is it guaranteed that the
__f_unlock_pos(req->file) will happen in the same task as the
io_file_pos_lock(req, false), and have you tried running this with
lockdep and mutex debugging enabled? Could a task deadlock if it tried
to do a read() on a file while io_uring is already holding the
position lock?

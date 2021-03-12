Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59293398F9
	for <lists+io-uring@lfdr.de>; Fri, 12 Mar 2021 22:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235183AbhCLVRt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Mar 2021 16:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235116AbhCLVRb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Mar 2021 16:17:31 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26B4C061574
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 13:17:30 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id z25so9046482lja.3
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 13:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j0PmcQ0UkUkJ3bFzFIfD/CBfTRKtcIwYuFTx1v1hauU=;
        b=LOmwLRliI5Ezkfzag/NcWUJdvCj0pvfPDTr5alnalyeVZtg7DWdWfsOmNy6QEozqty
         8XbekoXa6kYFD7jeTBmh0L21SW65oeb1guaKtZTeGgp8cxqRiB/IjJuY8TaxLMoj27vo
         PR9eJVQPVh8O4PWkmdR57H80PrpvL8xf91lRk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j0PmcQ0UkUkJ3bFzFIfD/CBfTRKtcIwYuFTx1v1hauU=;
        b=ABI4D0LDBCEOpnvEamr22AVw9LLzenfPM/KhIfBTZaeK+cftVf1PkGGhUliSYSYZVH
         KwhlbZSNTMlBQGxtrTreHPFPJF3WowdEJpC0J5ZbOF7VBq8mcgC5xpOKwVf4jI0h5MuD
         XOFxAxt9cpFzqbdNz/nupoH+JHQgsM2ul4Om3mfAB9NENyw0KmOM5EZ6LFUGdiJT4Im8
         iLcwmfz10sIkvTeP+6Mp40NbBiQk+LSfTK7iOB01HVGnz00G8Yk4hIXlgf1dQBM9Mq3r
         wqSych0xfsb0Xee1hqErCh/cDpcYrgtF3M2xtYhnDDTZ2ZQIsjb1mQNYbEEOzGW8Cut2
         aDgg==
X-Gm-Message-State: AOAM530BfAqiITkRGNM5JkaqZu4GURngCDqZpqVLro+G/p5TwwzioQA2
        opxn1KWR6l9zoYvPit+wT6jfKWV3EZXtVg==
X-Google-Smtp-Source: ABdhPJyDpFB4NoWlAluHbGfQaFemMn38kNfEnI4Kj0S1dd97t0eaeYX6FGTOms5F14aOwZPhPOdjJA==
X-Received: by 2002:a2e:b5d8:: with SMTP id g24mr3633383ljn.64.1615583849203;
        Fri, 12 Mar 2021 13:17:29 -0800 (PST)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id a1sm2111092ljb.76.2021.03.12.13.17.28
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 13:17:28 -0800 (PST)
Received: by mail-lf1-f48.google.com with SMTP id v9so47479278lfa.1
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 13:17:28 -0800 (PST)
X-Received: by 2002:a05:6512:398d:: with SMTP id j13mr623475lfu.41.1615583848161;
 Fri, 12 Mar 2021 13:17:28 -0800 (PST)
MIME-Version: 1.0
References: <a5447498-4a4c-20b3-ed1a-68b61df8b26b@kernel.dk>
In-Reply-To: <a5447498-4a4c-20b3-ed1a-68b61df8b26b@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 12 Mar 2021 13:17:12 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjpS-kwozJQFNBestco=q5j3bcfXpVXc6uz=9_mmQ7oYg@mail.gmail.com>
Message-ID: <CAHk-=wjpS-kwozJQFNBestco=q5j3bcfXpVXc6uz=9_mmQ7oYg@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fixes for 5.12-rc3
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 12, 2021 at 11:48 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> - Make IO threads unfreezable by default, on account of a bug report
>   that had them spinning on resume. Honestly not quite sure why thawing
>   leaves us with a perpetual signal pending (causing the spin), but for
>   now make them unfreezable like there were in 5.11 and prior.

That "not quite sure" doesn't exactly give my the warm and fuzzies,
but not being new is ok, I guess. But I'd really like you to try to
figure out what is actually going on.

I'm _guessing_ it's just that now those threads are user threads, and
then the freezing logic expects them to freeze/thaw using a signal
machinery or something like that. And that doesn't work when there is
no signal handling for those threads.

But it would be good to _know_.

            Linus

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF7BF23B194
	for <lists+io-uring@lfdr.de>; Tue,  4 Aug 2020 02:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgHDAMA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Aug 2020 20:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728329AbgHDAMA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Aug 2020 20:12:00 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0BBC061756
        for <io-uring@vger.kernel.org>; Mon,  3 Aug 2020 17:12:00 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id x9so41634804ljc.5
        for <io-uring@vger.kernel.org>; Mon, 03 Aug 2020 17:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BJMGz9Kc8WVCp/t/OHF9s3yH7VQ2GD7HHPuH9GhBwQs=;
        b=W94vDVEvD6RunkvlHbkEgBD1oo7wrZKgAqzHxEZ5TGmSkPoskFLl0lduJT1bLMcylJ
         i1qFErpOiOciZfhkkPxUK1SDkfZzxdgDygWPfoKVaHB2rsGxxYYshcNghQNuDF7TETgY
         /NnTENgvzaGKZn83r2WPrXJssI/dZzbilP2+o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BJMGz9Kc8WVCp/t/OHF9s3yH7VQ2GD7HHPuH9GhBwQs=;
        b=HqKi7HAql1QPB7IujruLHnV6BsqBvZ1jv8bewt0EkAuAmyczvJtNeh8oiyYZR1XsyO
         /GDUd8mrVbCaXFpMn+++7JbtN7KPTwxkHaBj8eZhhSh2FLnyL1z5dUA02XGjTXhwWgX4
         VjUTHg1j9scyH7zvXh8ui1k3dyacO+v2bvuIlrOF7OjL99olwm5hzVDGPsb2h+1e+0+3
         bfFMBlzCeSuHaGFESynCRltlAAAEUO4xkLNAxKvEG8QPSqFTnZtP3PBFY1YIWiuXR0bY
         Jw+wX4HT/uNvzMEWwZE2F+CyCAIDxCu+1HpcdIJ1s3OrkphDhtUZ3g+zClf9tDKRYi2E
         fx8w==
X-Gm-Message-State: AOAM533/yP52s5paGyTi8P1glrXlRb4lomH+feRFItxMEioeoADkwhcf
        dvnuFAAHl1MBwReF+XHmWeMVW9k0/xU=
X-Google-Smtp-Source: ABdhPJxlHxWwKLx+/mQmTyz5epmnEFhPI8s8lme4jZhX8jVxlvkUk2IzWpvDr5pVtVp7wEcH3rF6ww==
X-Received: by 2002:a2e:3c16:: with SMTP id j22mr9029466lja.92.1596499918205;
        Mon, 03 Aug 2020 17:11:58 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id i3sm4774427ljj.64.2020.08.03.17.11.56
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 17:11:56 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id x24so4076849lfe.11
        for <io-uring@vger.kernel.org>; Mon, 03 Aug 2020 17:11:56 -0700 (PDT)
X-Received: by 2002:a05:6512:3b7:: with SMTP id v23mr9791274lfp.10.1596499915813;
 Mon, 03 Aug 2020 17:11:55 -0700 (PDT)
MIME-Version: 1.0
References: <50466810-9148-e245-7c1e-e7435b753582@kernel.dk>
 <CAHk-=wgaxWMA7DVTQq+KxqaWHPDrXDuScX9orzRgxdi7SBfmoA@mail.gmail.com>
 <cd478521-e6ec-a1aa-5f93-29ad13d2a8bb@kernel.dk> <56cb11b1-7943-086e-fb31-6564f4d4d089@kernel.dk>
 <025dcd45-46df-b3fa-6b4a-a8c6a73787b0@kernel.dk> <CAHk-=whZYCK2eNEcTvKWgBvoSL8YLT6G0dexVkFbDiVCLN3zBQ@mail.gmail.com>
 <af6b61c1-e98e-f312-3550-deb7972751a9@kernel.dk>
In-Reply-To: <af6b61c1-e98e-f312-3550-deb7972751a9@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 3 Aug 2020 17:11:39 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi0RHwerxA165qshpyET4WgpmrTU7pqxzEaD4J74Y3uww@mail.gmail.com>
Message-ID: <CAHk-=wi0RHwerxA165qshpyET4WgpmrTU7pqxzEaD4J74Y3uww@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring changes for 5.9-rc1
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Aug 3, 2020 at 4:56 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> What I ended up with after the last email was just removing the test
> bit:
>
> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.9&id=cbd287c09351f1d3a4b3cb9167a2616a11390d32
>
> and I clarified the comments on the io_async_buf_func() to add more
> hints on how everything is triggered instead of just a vague "handler"
> reference:
>
> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.9&id=c1dd91d16246b168b80af9b64c5cc35a66410455

These both look sensible to me now.

                  Linus

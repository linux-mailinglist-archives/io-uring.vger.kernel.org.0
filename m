Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C4F3BF029
	for <lists+io-uring@lfdr.de>; Wed,  7 Jul 2021 21:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbhGGTXe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Jul 2021 15:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbhGGTXe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Jul 2021 15:23:34 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799FFC061574
        for <io-uring@vger.kernel.org>; Wed,  7 Jul 2021 12:20:52 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id q18so6909864lfc.7
        for <io-uring@vger.kernel.org>; Wed, 07 Jul 2021 12:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k8sDU1/P1VfuXLXpThIjZK/DKEV3AqnPVmmR6a675sk=;
        b=TL3sOyEcBGu1gEpKYo3+YknZH1bXDiNOt8fLGOSrT7gcTtSYNk2qCAnG4tAmZPO/MZ
         ovzdPXiGVpQUPqvsFEPn66dyk30aOncHb4Jrnhp7MeMmSqHA4sxSIL7b+8LjltgRpdPe
         TdMKVIiIcmlOMLpzKnkw3pfqOHII/epJxAPHE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k8sDU1/P1VfuXLXpThIjZK/DKEV3AqnPVmmR6a675sk=;
        b=Sxz49JooMlPTNX4k/PwKwHKQnvVUtcXcv8VSuDkfT7N0Rv9/bkHfcCsXqhUkdZAJlh
         iv1caoARJLZae3cGOohrDI8cfqnaCt0D5mzS929F6Y0My7y6kQFFJVGXdfzkiJYqkQkc
         krW2BzmAvPJLmCrUTUy+stvL2Afyf7y1YIhq7GkwNm7xlvfuBdBwmONua/zA0hESd4eU
         lEjwQ3FXlHINjdCVsSRCAzmX2l4qWWG8E8CllEV0z3XLzllqY71XeZYulvSyYaeKb84V
         ASlXoNhL3fmSQ5oQAvEl7guGLTTNdpaGvvi2s9IeHdt76IdnejJ/X3Wi352BB+uqGJ5J
         HgSw==
X-Gm-Message-State: AOAM531ZfaTv0xH3Nfcwcq78UxqHl0n6Gwbe3YwNrLUr6PmWfO6GUnpW
        HlHsqtEvsPyhi6aMxZBO3Bf+Qi9UzXvrL+STCoc=
X-Google-Smtp-Source: ABdhPJxEqPRohLBBykeuh6Zrfb12QvmR5yZGUg2WjubuIl/EFBetZXSYaRICW/joRTVuc5CM1rPftg==
X-Received: by 2002:a05:6512:694:: with SMTP id t20mr21129530lfe.344.1625685650620;
        Wed, 07 Jul 2021 12:20:50 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id w24sm1777890lfa.143.2021.07.07.12.20.49
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 12:20:50 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id t17so7014748lfq.0
        for <io-uring@vger.kernel.org>; Wed, 07 Jul 2021 12:20:49 -0700 (PDT)
X-Received: by 2002:a2e:a48c:: with SMTP id h12mr7794800lji.61.1625685649700;
 Wed, 07 Jul 2021 12:20:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210707122747.3292388-1-dkadashev@gmail.com> <20210707122747.3292388-4-dkadashev@gmail.com>
In-Reply-To: <20210707122747.3292388-4-dkadashev@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 7 Jul 2021 12:20:33 -0700
X-Gmail-Original-Message-ID: <CAHk-=wijsw1QSsQHFu_6dEoZEr_zvT7++WJWohcuEkLqqXBGrQ@mail.gmail.com>
Message-ID: <CAHk-=wijsw1QSsQHFu_6dEoZEr_zvT7++WJWohcuEkLqqXBGrQ@mail.gmail.com>
Subject: Re: [PATCH v8 03/11] fs: make do_mkdirat() take struct filename
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 7, 2021 at 5:28 AM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>
> Pass in the struct filename pointers instead of the user string, and
> update the three callers to do the same. This is heavily based on
> commit dbea8d345177 ("fs: make do_renameat2() take struct filename").
>
> This behaves like do_unlinkat() and do_renameat2().

.. and now I like this version too. And that do_mkdirat() could have
the same pattern with a "mkdirat_helper()" and avoiding the "goto
retry" and "goto out_putname" things, and be more understandable that
way.

Again, that could - and maybe should - be a separate cleanup.

             Linus

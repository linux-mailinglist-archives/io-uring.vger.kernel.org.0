Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D908D41E871
	for <lists+io-uring@lfdr.de>; Fri,  1 Oct 2021 09:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352538AbhJAHid (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Oct 2021 03:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352534AbhJAHic (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Oct 2021 03:38:32 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AEAC061775
        for <io-uring@vger.kernel.org>; Fri,  1 Oct 2021 00:36:48 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id dj4so32422521edb.5
        for <io-uring@vger.kernel.org>; Fri, 01 Oct 2021 00:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Zl0atOIB5UNZp3fcHoegj8EoMUM2eCuO8j8FaGlvoU=;
        b=fPbdFHww//z6eAMSvg6+f+1r6nzc6bKlNUIKZaU3BH9UrnF+WW5xRdlpUmpI7Gl3kM
         r7CrQN5gHXD42CfXqDZweBqG98FzwiOxeignbFtyCuC6gOjXL6+6XUevgg00BlkexD7/
         atxZ4XsnkAUErNCQHadCo7LB1OXXj8BFPXNN4mdwtkBlgiTJKSRaSdN/RVNJJ7a1MLCO
         O6H3b4CkZa7rZzVPlhtPxS6YYf3p22gHGRbumpmtv4uowE34+2pQnIrYYlMhRLWdH6Cb
         snHc7T1bCFqLkcOCPpu2GcLHyaV1xAeRwxUtWRM8M5ObKGY0OYbcYyV7XZtxadZhPQRT
         HG0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Zl0atOIB5UNZp3fcHoegj8EoMUM2eCuO8j8FaGlvoU=;
        b=POWOML2LNTFLHAGXfWUGK6+siNS2UhrpS7655teIqA6SCI0miZ3oXGCP7ud+421VKW
         OUGJNSP/qI/MIKgA79YIvNd3hOaukhusfU4lk0R9SntQ10Li/DxmfGNlt3mP4v9miOCZ
         psJUK38gEHxtbSxrhXd1OJABZ9SjZfR2LVpJWDA3pWyCNB4vx3ScFKDZ4nprG3eUBX01
         zkMjic9C9wQdC4UgeH8Ao7djKYNHI6UToxtO6uPo4RcS46+LcUCMvBQ/YfWMFLN0l1NQ
         t68bX5kYWtEOkgRK7fhboe6OOo9qsj20vPf1JNFsQggRRsCHmCR6Xjli4ij6Po4nwlCk
         wV2Q==
X-Gm-Message-State: AOAM532IodvYTp85A4EnjK7Uzcbtii7KwRNKTJg0YD5srUxNi7e3qzFA
        Fvoh2xEvV+pFfTSU/2MpSo/2Otdq5Xaf6oqwrpE2VFvKP2Y/8cCT77Nbuw==
X-Google-Smtp-Source: ABdhPJxc1MkmVA9wnONUkGAle+6m0C/Gwni3wfF6NefZwWvDbLERUnw2uB6or7bXUTtEaOI2G79vI/EKJI2D1XnJ3Rc=
X-Received: by 2002:a17:906:1757:: with SMTP id d23mr4690225eje.102.1633073807128;
 Fri, 01 Oct 2021 00:36:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210929101606.62822-1-ammar.faizi@students.amikom.ac.id>
 <CAGzmLMX5X45jukOgWuT=+FLvh4eq=mRZ54Rgh1J1W2U3f69fPQ@mail.gmail.com> <89cf843d-be43-4bd6-0e20-4fb04a500512@gmail.com>
In-Reply-To: <89cf843d-be43-4bd6-0e20-4fb04a500512@gmail.com>
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Date:   Fri, 1 Oct 2021 14:36:34 +0700
Message-ID: <CAGzmLMVKZMjzfyNX2NNEzU8J4wXqUKhghbZH7=Wh=Ldsb3Cy3A@mail.gmail.com>
Subject: Re: [PATCHSET v1 RFC liburing 0/6] Implement the kernel style return value
To:     Louvian Lyndal <louvianlyndal@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Ammar Faizi <ammarfaizi2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Oct 1, 2021 at 1:44 PM Louvian Lyndal <louvianlyndal@gmail.com> wrote:
> This will add extra call just to wrap the libc. Consider to static
> inline them?
>
> For libc they just check the retval, if it's -1 then return -errno. If
> they are inlined, they are ideally identical with the previous version.
>
> Besides they are all internal functions. I don't see why should we
> pollute global scope with extra wrappers.
>

Yeah makes sense, I will address this for v2. We can have them as
static inline functions in `src/syscall.h`.

> Regards,
>
> --
> Louvian Lyndal

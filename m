Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969883FC6A9
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 14:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhHaLh6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 07:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhHaLh5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 07:37:57 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB09CC061575
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 04:37:02 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id i6so26327903edu.1
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 04:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9OCPHe7ClxwtxqoiLfKVCkiKybH0LSGLvKLPx7M4lDQ=;
        b=SIXg87yzQLddbUvnO0hB7HhCeYoKoyjA29zt7SZ04QOMHYJEfD2w1ihzyrROELm4bE
         jYcT+rUQBlAoy8yBLKL91sOtx6j6/aHX7EHlGHFTAfgFcLhqyq6KDlj16Wnq8X/J9AEF
         shuyahb9QY9snZe61devCwNKUnKzkBo6Spb6HDqTI9CpqynF/6YfCOvEacX9hwYne8+t
         SzxFomhvMwuSpCn54xi2CEEfCTNEJUD/lDT2SuSLzzN5/It3hvvQJf6KHJ4F3XhrUq1J
         AS9Kx8OfGuAsfFofoVafe3K24eLotXrAFKzUY6zIqTG1iAaGGoe92n5dQN7+4l11wLNf
         LIpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9OCPHe7ClxwtxqoiLfKVCkiKybH0LSGLvKLPx7M4lDQ=;
        b=KAVFT41mBU2LeMWbXnBXX3cIgglOp9E+QPeeLINesRt/ftTkaVtd/HoLDoPh02i1b/
         aT5OGF4dSrhlI+/6En/dgbfW40SlbAQ+oYG4O3zTV4ZvH52+msU1LSHFrCuCi7xcETPg
         fIHArPH3K+cipDBYKulpEy7R1BGSyfi8BPj0Qj5HM7sw+rIea/f3j5MTunvEVKd4m2zO
         gG65/Exj8uMYJN6rSwaduFAxKzK6WzORF0EWbPa2k/8JNsPp1lz8siXBlfb+DqOxmY43
         WOLJlV96zQi8EUBXH3G4/FTKdxh8defNg+HtVIaV5nIVYrEZePqgjGpdog4tgxAHfiuV
         wbiA==
X-Gm-Message-State: AOAM533d6VDVrghYPkDp7TegVlU2gN2IEjnnVSmGzm52QmJ1WAwVlgzU
        473fFoFyWphPVlUjEFFN+i0k+FNq+UrS4IabPw7u4WNNeSY88mWo
X-Google-Smtp-Source: ABdhPJzmkxtwkAX/JdomnD6Q/cXL7tamy0C1ja7CxFBA2RBOqAhSR0rmOfKSjNhIVJvQ3Aj2pPpp3UmRReh1r111/8k=
X-Received: by 2002:a05:6402:d6f:: with SMTP id ec47mr28832396edb.95.1630409821055;
 Tue, 31 Aug 2021 04:37:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAM1kxwhHOt1Ni==4Qr6c+qGzQQ2R9SQR4COkG2MXn_SUzEG-cg@mail.gmail.com>
 <CAM1kxwi83=Q1Br46=_3DH46Ep2XoxbRX5hOVwFs7ze87Osx_eg@mail.gmail.com>
 <CAM1kxwiAF3tmF8PxVf6KPV+Qsg_180sFvebxos5ySmU=TqxgmA@mail.gmail.com>
 <1b3865bd-f381-04f3-6e54-779fe6b43946@kernel.dk> <04e3c4ab-4e78-805c-bc4f-f9c6d7e85ec1@gmail.com>
 <b53e6d69-9591-607b-c391-bf5fed23c1af@kernel.dk> <ebf4753c-dbe4-f6b5-e79c-39cc9a608beb@gmail.com>
 <66bf3640-a396-28cf-0b0d-8f3a9622ce2b@kernel.dk>
In-Reply-To: <66bf3640-a396-28cf-0b0d-8f3a9622ce2b@kernel.dk>
From:   Victor Stewart <v@nametag.social>
Date:   Tue, 31 Aug 2021 12:36:50 +0100
Message-ID: <CAM1kxwgKJYUN=-CGT02oK+gxk_u60DchEAykoSYLbHRXfOz0Yg@mail.gmail.com>
Subject: Re: io_uring_prep_timeout_update on linked timeouts
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> > _Not tested_, but something like below should do. will get it
> > done properly later, but even better if we already have a test
> > case. Victor?

sorry been traveling! i can extract out a simple test today...

> FWIW, I wrote a simple test case for it, and it seemed to work fine.
> Nothing fancy, just a piped read that would never finish with a linked
> timeout (1s), submit, then submit a ltimeout update that changes it to
> 2s instead. Test runs and update completes first with res == 0 as
> expected, and 2s later the ltimeout completes with -EALREADY (because
> the piped read went async) and the piped read gets canceled.

...unless?

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4D81F02CE
	for <lists+io-uring@lfdr.de>; Sat,  6 Jun 2020 00:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgFEWOK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Jun 2020 18:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728157AbgFEWOJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Jun 2020 18:14:09 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA25C08C5C2
        for <io-uring@vger.kernel.org>; Fri,  5 Jun 2020 15:14:09 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id 9so11098247ilg.12
        for <io-uring@vger.kernel.org>; Fri, 05 Jun 2020 15:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=Dkff2EYpDKBds4uO94qWqK8MHzC3d5rRSA4J4M7BY5M=;
        b=RGu1ICP6ZkJP5ITkovEkwbNAsbW5Bj1VPWkKso1Fq8Zndo9kG0Wg6htqSZgHs6FLop
         n0og/62o5KU+KCKpkZygOSjuItfpgtURbs91a1b0S/TDWBONecHASDXgAMEAPEOEBtOk
         xVjCfY28gpzj/9OJw41j0G1/VnIoSn+USWimPtiIf+6WJpSNpvn+aBW2ngNne4VMz00w
         ME1K9jaKTwfQDAkAmwi7540SMDECBs08JbuDMKSkuCr2N0achmHOxzoNw4nmRVgtZTHn
         57HS9aZR568HfUlf0Lwc1SLlELAMgkb9j10pa4fvP/SJvddEslDZJ3h+sWDYtaJ1DuUh
         iSrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=Dkff2EYpDKBds4uO94qWqK8MHzC3d5rRSA4J4M7BY5M=;
        b=s3UA5O7lsfIMDoYTTjAN4dJqxHYqUjXJxDY8QXiY1KlPNGbi8ka6Nmwv+c5No+G2xE
         HwG6pM2bKerVoL1KtxOaUiYK6BCTWAh6aH8PoS9Y4AM/e4xOTAHLor+k3uvA/H0IqhNf
         sOweCrKNZhqY/dCVJon/u05p0jK0F2BCX4gGoR0jZ5Jgy4beckUZM5ljtMqDHnEBmtUk
         rzWHI224nSyLcd5ttShPAQmZrNOOpOBWcCL7p3MOKARN926lB8xFiCmpb3l1I7FE5D15
         pg+iAzciCZAqwlD0mFVsjc5vEcPFYOp1vcrK3QHORWcgcFN4xWZO+5RZij+y4kvVVgsD
         T7EQ==
X-Gm-Message-State: AOAM532wmsNwhQDbs7TBjhKczVW8+DbLqQTQDsAkkt8uDRVb/W+AHNeQ
        Taxce0icLhkoWuvUdmZX3eMWFtMtw5tCxbm/MuO++ClVQC8=
X-Google-Smtp-Source: ABdhPJynyzl6hlzSfHEpQFEuJYvK2uhFP8Qdo83nkjTRQYCzCeJEWKuxtKl+BTDqbK1kUKoRziiSGInfbqEhjeIdllc=
X-Received: by 2002:a92:898e:: with SMTP id w14mr10061544ilk.212.1591395249222;
 Fri, 05 Jun 2020 15:14:09 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUXRE+++FbchwF5Rhrj5AeRY=H2T8m07Y8CV5bhu_s5OgA@mail.gmail.com>
In-Reply-To: <CA+icZUXRE+++FbchwF5Rhrj5AeRY=H2T8m07Y8CV5bhu_s5OgA@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Sat, 6 Jun 2020 00:13:57 +0200
Message-ID: <CA+icZUX7jibW9QYDy1Hykwp9cH2GGL9EzR=eDQL8UaH6SY0ASQ@mail.gmail.com>
Subject: Re: [PATCH] io_uring: re-issue plug based block requests that failed
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jun 6, 2020 at 12:05 AM Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> Hi Jens,
>
> with clang-10 I see this new warning in my build-log:
>
> fs/io_uring.c:5958:2: warning: variable 'ret' is used uninitialized
> whenever switch default is taken [-Wsometimes-uninitialized]
>         default:
>         ^~~~~~~
> fs/io_uring.c:5972:27: note: uninitialized use occurs here
>         io_cqring_add_event(req, ret);
>                                  ^~~
> fs/io_uring.c:5944:13: note: initialize the variable 'ret' to silence
> this warning
>         ssize_t ret;
>                    ^
>                     = 0
> 1 warning generated.
>
> Thanks.
>

This siliences the warning:

$ git diff fs/io_uring.c
diff --git a/fs/io_uring.c b/fs/io_uring.c
index d22830a423f1..b94ad5963e41 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5941,7 +5941,7 @@ static bool io_resubmit_prep(struct io_kiocb *req)
 {
        struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
        struct iov_iter iter;
-       ssize_t ret;
+       ssize_t ret = 0;
        int rw;

        switch (req->opcode) {

- Sedat -

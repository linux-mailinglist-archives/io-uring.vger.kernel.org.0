Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53AB62617C8
	for <lists+io-uring@lfdr.de>; Tue,  8 Sep 2020 19:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730976AbgIHRmt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Sep 2020 13:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731833AbgIHRma (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Sep 2020 13:42:30 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A5CC061573
        for <io-uring@vger.kernel.org>; Tue,  8 Sep 2020 10:42:30 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 16so6758137qkf.4
        for <io-uring@vger.kernel.org>; Tue, 08 Sep 2020 10:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E/mgPvL4jB2DhXNBjTqIcE+YX7i/1El/bm0AGxFt15I=;
        b=TdV8B/1Bad6MxKzm7m2CP/Cj32euqLmeqvf0abpMLDphRinFAjAHKrL/ZR4eGU2bSb
         1kkXWJUIVCLdcfJQE2oyxa4ccVrxI5PIajxhNDy3zNyTI9BVMfWrSDVtPvwgqUkqZh+f
         a/mCkMXh4UJdcfBj9i+XyQ4sH8Ct8ItXT+XpsvWI+MRlR86dWXrfu9C2Gp2OakmGYp2U
         RgkT4bTSeDn0yu1FZtSBYbNONt9CgQL6ItuHSZEtDkKutoRmXsc591YWtPXXozicnvac
         mgm4CgGli5NCP/Rfl2cEw1nNEErN4PDYT9eNSjlinlgPHEGiPlWLIWxnN2PygPw/z9uS
         A1iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E/mgPvL4jB2DhXNBjTqIcE+YX7i/1El/bm0AGxFt15I=;
        b=AbeqTNMYj3qMpvrSMbaEwUmKggELMB0ZcE7y3Wx4doQuQ0sMiN5G+YAj5FvP3nE40F
         LJg/UOXC82p3HcFHF+UeUnvCWDcoVDPP3IUzaJvfdi/mpTV8+nWvhLwRquOmABTnMpf3
         fSSbdE2yweBfz1rrumFDc44euSXh7LA/ujewLy+u7o/+pApdLOD1bL8Fu5tjozck42CP
         eQjo54KsGTKQlG7/JrAJWRvO5V+ju4vXkUFNnPAiJ3LyjKI370cBRI+Sqhe6kaLOihtE
         WKyYJb5fsKn27bt8oalO0Eo+wAW073yHtUC7aEZ3IXcZUc3imSRKW6ft8IH9/kD4n4xS
         ZBIQ==
X-Gm-Message-State: AOAM531m7Gt8uFFVgHlXRSYX3TmPi7mtqt6/QmqpiNiOHsyOrfgVviQw
        EXWFlezHVQ3OcPgxz6SUHKlbvTr0z9B5d3/AsjhC2cx8o8LPUw==
X-Google-Smtp-Source: ABdhPJz/z4kPkX9eb31JhHNSN9wXo61BpQij1R9xuU5BU625r0B2/YQ4LYBvOTO/PYqClvf1YaN0Dg0wfrM0tv+k8zc=
X-Received: by 2002:a37:60c5:: with SMTP id u188mr1106826qkb.412.1599586949167;
 Tue, 08 Sep 2020 10:42:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAAss7+p8iVOsP8Z7Yn2691-NU-OGrsvYd6VY9UM6qOgNwNF_1Q@mail.gmail.com>
 <68c62a2d-e110-94cc-f659-e8b34a244218@kernel.dk> <CAAss7+qjPqGMMLQAtdRDDpp_4s1RFexXtn7-5Sxo7SAdxHX3Zg@mail.gmail.com>
 <711545e2-4c07-9a16-3a1d-7704c901dd12@kernel.dk> <CAAss7+rgZ+9GsMq8rRN11FerWjMRosBgAv=Dokw+5QfBsUE4Uw@mail.gmail.com>
 <93e9b2a2-b4b4-3cde-b5a7-64c8c504848d@kernel.dk> <CAAss7+oa=tyf00Kudp-4O=TiduDUFZueuYvwRQsAEWxLfWQc-g@mail.gmail.com>
 <8f22db0e-e539-49b0-456a-fa74e2b56001@kernel.dk> <CAAss7+pjbh2puVsQTOt7ymKSmbruBZbaOvB8tqfw0z-cMuhJYg@mail.gmail.com>
 <cd44ec4a-41b9-0fa0-877d-710991b206f1@kernel.dk> <dd59bd5e-cb81-98c1-4bc8-fa1a290429c2@kernel.dk>
In-Reply-To: <dd59bd5e-cb81-98c1-4bc8-fa1a290429c2@kernel.dk>
From:   Josef <josef.grieb@gmail.com>
Date:   Tue, 8 Sep 2020 19:42:17 +0200
Message-ID: <CAAss7+oJF-KMRAnkjMWmW9Zd-dNnTojFOeC7LR-AoHcJDOc36Q@mail.gmail.com>
Subject: Re: SQPOLL question
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     norman@apache.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> Are you using for-5.10 and SQEPOLL + ASYNC accept? I'll give that a
> test spin.

yes exactly

> This should do it for your testing, need to confirm this is absolutely
> safe. But it'll make it work for the 5.10/io_uring setup of allowing
> file open/closes.
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 80913973337a..e21a7a9c6a59 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6757,7 +6757,7 @@ static enum sq_ret __io_sq_thread(struct io_ring_ctx *ctx,
>
>         mutex_lock(&ctx->uring_lock);
>         if (likely(!percpu_ref_is_dying(&ctx->refs)))
> -               ret = io_submit_sqes(ctx, to_submit, NULL, -1);
> +               ret = io_submit_sqes(ctx, to_submit, ctx->ring_file, ctx->ring_fd);
>         mutex_unlock(&ctx->uring_lock);
>
>         if (!io_sqring_full(ctx) && wq_has_sleeper(&ctx->sqo_sq_wait))
> @@ -8966,6 +8966,11 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
>                 goto err;
>         }
>
> +       if (p->flags & IORING_SETUP_SQPOLL) {
> +               ctx->ring_fd = fd;
> +               ctx->ring_file = file;
> +       }
> +
>         ret = io_sq_offload_create(ctx, p);
>         if (ret)
>                 goto err;
>

sorry I couldn't apply this patch, my last commit is
https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commit/?h=for-5.10/io_uring&id=9c2446cffaf55da88e7a9a7c0a5aeb02a9eba2c0
what's your last commit?

it's a small patch, so I'll try it manually :)

---
Josef

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569836C330D
	for <lists+io-uring@lfdr.de>; Tue, 21 Mar 2023 14:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjCUNis (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Mar 2023 09:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjCUNir (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Mar 2023 09:38:47 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0E424BD0;
        Tue, 21 Mar 2023 06:38:46 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id t15so13714536wrz.7;
        Tue, 21 Mar 2023 06:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679405924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w1E4EyxuuQhu33jdVM+Jw/OPkmkf/7P5zMZl+fnFcQ4=;
        b=W0eGeU42Qg6zMlDDG/UTzi3Bdb+8X9keDYeAeD5lQqqKGevMYV56rz4iQOQ60996xp
         EXK/4sjvngRsW8WPeVVQLx2VhO0BeZPD/FqtqiLrFnnPnbkHxdjhtZW52szVEdWzQn+x
         SY1u6bkQeqmEgF3kwjUwlh1xeXE9nAy+K0XarRGRSmqwre5PuVvbsfIx8HEhIb143Qpf
         T5FpZtH9Y8CLfC036PUTJW/1gcZ5z51DK1yJ/apNcI24TZMB1q3fk1269K9tWVDWv7Nm
         93/0qYC8MsdxVdCv6cp8RvLjx0avjd6lhrhon8gHOvum0+aoLPmIH/5efB4DZRFpuSLs
         gI/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679405924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w1E4EyxuuQhu33jdVM+Jw/OPkmkf/7P5zMZl+fnFcQ4=;
        b=I2vr04+LSGJXm57qgVgjSShSvWggoo0hUZNaBuPSFXEWLEyImZuALJ4Xf2IvAWbSE3
         U7Qi7rIGvGaV9jvtYDrlhuJx59fpN4q/q/iNre0s3HLbZfSRjiScPPkvAVGxztNfmHSR
         2DbHac9Dbkit9mTAXJVuHWvj4WKazNYsMyLppkwMwzinGi1whh+0p37xETaMV+ChZuOb
         PaPGdMBQCF5qArjJOtjD5bErYyETTKE1G05q4FMbO4AxAwPHiyt1GxiYUXKwyAtyl0zn
         JyLN61Srcj63+/kJrNCRFvbYbpcU0Kz7T+HQhiMqesyh5ilGUEJyc/DMsXSTocIUrTPj
         t7yQ==
X-Gm-Message-State: AO0yUKXuP30dFD+suL2gHiAvvx4MxoR3oL0tabSGZu0E/+KF6PBD3DyQ
        BHPgck+Rk97MKQil155IxFIdAzmZ9q7K0Y2s6GMQ9gdesAI=
X-Google-Smtp-Source: AK7set8B3Krh9CeR26QjqCTn7ZuuWgs4eybD3v+ZnYVRNcucqSN9wgYc7RiDZVZd7AZAtt0pTH5Y/fDqyEHFSjZ5YGY=
X-Received: by 2002:a5d:44cd:0:b0:2ce:aaff:2a8c with SMTP id
 z13-20020a5d44cd000000b002ceaaff2a8cmr615482wrr.14.1679405924338; Tue, 21 Mar
 2023 06:38:44 -0700 (PDT)
MIME-Version: 1.0
References: <c56fc63e-7e6b-480e-dfdc-417b00802f11@kernel.dk>
In-Reply-To: <c56fc63e-7e6b-480e-dfdc-417b00802f11@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Tue, 21 Mar 2023 19:08:17 +0530
Message-ID: <CA+1E3rK4kN8gZEzqBThaZRrD_G7JJPeVK8BA57S5OezjC5Jz2w@mail.gmail.com>
Subject: Re: [PATCH] block/io_uring: pass in issue_flags for uring_cmd
 task_work handling
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Ming Lei <ming.lei@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 21, 2023 at 7:37=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> io_uring_cmd_done() currently assumes that the uring_lock is held
> when invoked, and while it generally is, this is not guaranteed.
> Pass in the issue_flags associated with it, so that we have
> IO_URING_F_UNLOCKED available to be able to lock the CQ ring
> appropriately when completing events.
>
> Cc: stable@vger.kernel.org
> Fixes: ee692a21e9bf ("fs,io_uring: add infrastructure for uring-cmd")

While the ability to pass flags seems useful, I am trying to
understand if the tag 'fixes' is a must?
Before this patch, the F_UNLOCKED flag was not used and completions go
to line 1006 (please see below).
After this patch also, completions execute the same code as IOPOLL is not s=
et.
In both cases, ctx->completion_lock is being acquired while posting complet=
ions.
And for polled passthrough IOs, we don't execute this code anway.

999 void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
1000 {
1001         if (req->ctx->task_complete && (issue_flags & IO_URING_F_IOWQ)=
) {
1002                 req->io_task_work.func =3D io_req_task_complete;
1003                 io_req_task_work_add(req);
1004         } else if (!(issue_flags & IO_URING_F_UNLOCKED) ||
1005                    !(req->ctx->flags & IORING_SETUP_IOPOLL)) {
1006                 __io_req_complete_post(req);
1007         } else {
1008                 struct io_ring_ctx *ctx =3D req->ctx;
1009
1010                 mutex_lock(&ctx->uring_lock);
1011                 __io_req_complete_post(req);

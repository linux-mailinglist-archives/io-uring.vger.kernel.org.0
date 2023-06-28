Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610E2741042
	for <lists+io-uring@lfdr.de>; Wed, 28 Jun 2023 13:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjF1LoE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Jun 2023 07:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbjF1LoC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Jun 2023 07:44:02 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1A92D63
        for <io-uring@vger.kernel.org>; Wed, 28 Jun 2023 04:44:00 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-1b06a46e1a9so1183104fac.2
        for <io-uring@vger.kernel.org>; Wed, 28 Jun 2023 04:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687952635; x=1690544635;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=skyq5jJecX8gUzH/HELKhPjfwUeihuLQSPsIi6eg0Xg=;
        b=iuGX6aFPJn1XK8YX0beyt4VacvzRA9ydnbhk5WBXrHAh2Wo1oudvD0e4F1ESAEqgJj
         spcEACZgycsFSEJjftgE9Fw41TjQiYpyLDYtpfZvIdpItH/5hJP6PzYwZ4GDAju/TUe7
         sOBDHjfYjngW5SBp0u9nXTtpxtQGiZkNScVrk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687952635; x=1690544635;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=skyq5jJecX8gUzH/HELKhPjfwUeihuLQSPsIi6eg0Xg=;
        b=GD4jcNy2kYeYSQSdl05ofktsQMt8rZq4PnM59Y116bAX6aK0rBvhl7saaz5XU7uqOO
         mf6eWpOts1OchX7Mk45jRcsisHvEoraSwg8ifUgvOFvng2RhYehbhfMt8LTQzTyNYqpf
         K2LQkNSZ4W1FYEE6xqego7LTHDc96OAVezUVjYbf4Yn4sHXkLibsoxbl77z5HpZHJS7+
         tneVvkMxMpu1PNpcamOf3A9v5ZVJkdDyRQbY1x9BdKKS3h+u9P0ixy4kSTQzNiIswk7T
         XYYIREwtTiquPO5IXLSJz4WMQAlLFx/Iscp5NO/iI+M+a4DOXEu3Yfi4bMITuht0PZ7Q
         0pBA==
X-Gm-Message-State: AC+VfDyW3sAfH8hHbIN2GzDwRkdXW1vJ3VFlLxGaNAIyK8BBARk3+he8
        xuvyu5fxDKYULkjE7yUxlgkKe0tOC14XkN9CGk/K/g==
X-Google-Smtp-Source: ACHHUZ4MvxPSTb6XUhEOvJn1WMKFyfXzHKLlJjpDS6jkZbCGi5Ove+8NBI/3udnLIW9fhxd2PuP2Gg==
X-Received: by 2002:a05:6870:8602:b0:1b0:9b9:60a9 with SMTP id h2-20020a056870860200b001b009b960a9mr8369637oal.1.1687952635483;
        Wed, 28 Jun 2023 04:43:55 -0700 (PDT)
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com. [209.85.160.49])
        by smtp.gmail.com with ESMTPSA id v5-20020a05683011c500b006b867fa10eesm1651263otq.74.2023.06.28.04.43.55
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jun 2023 04:43:55 -0700 (PDT)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-19674cab442so4749825fac.3
        for <io-uring@vger.kernel.org>; Wed, 28 Jun 2023 04:43:55 -0700 (PDT)
X-Received: by 2002:a05:6214:c63:b0:62b:6999:ab7b with SMTP id
 t3-20020a0562140c6300b0062b6999ab7bmr36306952qvj.16.1687952174945; Wed, 28
 Jun 2023 04:36:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230627120058.2214509-1-matteorizzo@google.com>
 <20230627120058.2214509-2-matteorizzo@google.com> <e8924389-985a-42ad-9daf-eca2bf12fa57@acm.org>
 <CAHKB1wJANtT27WM6hrhDy_x9H9Lsn4qRjPDmXdKosoL93TJRYg@mail.gmail.com>
In-Reply-To: <CAHKB1wJANtT27WM6hrhDy_x9H9Lsn4qRjPDmXdKosoL93TJRYg@mail.gmail.com>
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Wed, 28 Jun 2023 13:36:04 +0200
X-Gmail-Original-Message-ID: <CANiDSCvjCoj3Q3phbmdhdG-veHNRrfD-gBu=FuZkmrgJ2uxiJg@mail.gmail.com>
Message-ID: <CANiDSCvjCoj3Q3phbmdhdG-veHNRrfD-gBu=FuZkmrgJ2uxiJg@mail.gmail.com>
Subject: Re: [PATCH 1/1] Add a new sysctl to disable io_uring system-wide
To:     Matteo Rizzo <matteorizzo@google.com>
Cc:     Bart Van Assche <bvanassche@acm.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        jordyzomer@google.com, evn@google.com, poprdi@google.com,
        corbet@lwn.net, axboe@kernel.dk, asml.silence@gmail.com,
        akpm@linux-foundation.org, keescook@chromium.org,
        rostedt@goodmis.org, dave.hansen@linux.intel.com,
        chenhuacai@kernel.org, steve@sk2.org, gpiccoli@igalia.com,
        ldufour@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Matteo

On Tue, 27 Jun 2023 at 20:15, Matteo Rizzo <matteorizzo@google.com> wrote:
>
> On Tue, 27 Jun 2023 at 19:10, Bart Van Assche <bvanassche@acm.org> wrote:
> > I'm using fio + io_uring all the time on Android devices. I think we need a
> > better solution than disabling io_uring system-wide, e.g. a mechanism based
> > on SELinux that disables io_uring for apps and that keeps io_uring enabled
> > for processes started via 'adb root && adb shell ...'
>
> Android already uses seccomp to prevent untrusted applications from using
> io_uring. This patch is aimed at server/desktop environments where there is
> no easy way to set a system-wide seccomp policy and right now the only way
> to disable io_uring system-wide is to compile it out of the kernel entirely
> (not really feasible for e.g. a general-purpose distro).
>
> I thought about adding a capability check that lets privileged processes
> bypass this sysctl, but it wasn't clear to me which capability I should use.
> For userfaultfd the kernel uses CAP_SYS_PTRACE, but I wasn't sure that's
> the best choice here since io_uring has nothing to do with ptrace.
> If anyone has any suggestions please let me know. A LSM hook also sounds
> like an option but it would be more complicated to implement and use.

Have you considered that the new sysctl is "sticky like kexec_load_disabled.
When the user disables it there is no way to turn it back on until the
system is rebooted.

Best regards!

-- 
Ricardo Ribalda

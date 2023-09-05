Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F987792A4B
	for <lists+io-uring@lfdr.de>; Tue,  5 Sep 2023 18:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243798AbjIEQen (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Sep 2023 12:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354794AbjIEOYf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Sep 2023 10:24:35 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BFA197
        for <io-uring@vger.kernel.org>; Tue,  5 Sep 2023 07:24:31 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id 71dfb90a1353d-4935f87ca26so135460e0c.3
        for <io-uring@vger.kernel.org>; Tue, 05 Sep 2023 07:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693923870; x=1694528670; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rtg0JV+CO28r/3TvA7CtNqhGLbhNAM/8Tnh4hPoGQnU=;
        b=cIqGumjZaNP51NtJny7H9KFfgslTyyGhR7EUsN9RApU76ixIAcs5j7OaZqR56bxSPI
         N5MamOmm4vbjRo4LJtYhPmYHajNAQD2XKiUs+xnvC/lIzzduxwjJ6L5QNCopZtoJows8
         J7lgSNT51xUrzJkB4L4lZc85wfWDIAx2PCFAkBwfYY81vFejhbqra7j8fBZ1PI0YV6iR
         B5g/PhdTfvMn6OxPTDMtuuCQ7IBpHIIJnIDETUVBnzb/pwx8gPT4YHgPiZNChvFUoSMg
         RUt+Yxn2CV/XUxXO1unRLjVW0089KKiQnigzI6AKCMXkqrzBNRujVQKcYxF64Ez8wD0N
         f6VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693923870; x=1694528670;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rtg0JV+CO28r/3TvA7CtNqhGLbhNAM/8Tnh4hPoGQnU=;
        b=Qu0Dxy/vuZWkor4NR3JgMQO9m/Hibm1b06QrsZg6lJCIzlW2K1Zn8YO1AK2P5ZL6v6
         KLtQ6c26S5JIyZyx1/rvtQWPl1u1ol42R+AfCFbTUj3RU2PxKjlS9+kYE1nt09BcFcrV
         Hb7OY93r/zryT1I1xcLOhYdW2/HrPorcHMGOxvg4Qst19dpaxGQNcKfJxG91/2SSihSn
         0oe8JdOsKbCgNc4B1Is4Zd+AnoiChHLVgCMNOhsMSRjn8p3kyy/zF0qe2JaH3Uzpy98o
         /l7HtiBVaVsAfHEn5vSLXtUftpaT7bcP7lF4K98Xu94vbovB1PoxatHf5acB2G4IjI9W
         Dd2A==
X-Gm-Message-State: AOJu0Yw2hkc3X172zxYC1+ID/GNYAYCDwP+4IPiHDUnvJtzhEXy3JZBz
        TDwRYvuRzPhqjhqhbIwimYKCl92lMBQX0Mm6p0G++JWINXFy4cwsc20=
X-Google-Smtp-Source: AGHT+IEWoDhzho+yngW0aCmJ/4l2W7ac9+woo+yuM0ML8a0qrzG+hU+odrwxXpclmNhFqwuK8T1fNq4QgGni4tFlVOA=
X-Received: by 2002:a1f:dfc2:0:b0:48d:3434:fe1a with SMTP id
 w185-20020a1fdfc2000000b0048d3434fe1amr11957524vkg.3.1693923870055; Tue, 05
 Sep 2023 07:24:30 -0700 (PDT)
MIME-Version: 1.0
References: <x49y1i42j1z.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49y1i42j1z.fsf@segfault.boston.devel.redhat.com>
From:   Matteo Rizzo <matteorizzo@google.com>
Date:   Tue, 5 Sep 2023 16:24:17 +0200
Message-ID: <CAHKB1wKh3-9icDXK9_qorJr4DZ61Bt7mZznFT75R99a8LeMi_w@mail.gmail.com>
Subject: Re: [PATCH v5] io_uring: add a sysctl to disable io_uring system-wide
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        corbet@lwn.net, akpm@linux-foundation.org, keescook@chromium.org,
        ribalda@chromium.org, rostedt@goodmis.org, jannh@google.com,
        chenhuacai@kernel.org, gpiccoli@igalia.com, ldufour@linux.ibm.com,
        evn@google.com, poprdi@google.com, jordyzomer@google.com,
        krisman@suse.de, andres@anarazel.de, Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi all,

Is there still anything that needs to be changed in this patch? As far as
I can tell all the remaining feedback has been addressed.

--
Matteo

On Mon, 21 Aug 2023 at 23:10, Jeff Moyer <jmoyer@redhat.com> wrote:
>
> From: Matteo Rizzo <matteorizzo@google.com>
>
> Introduce a new sysctl (io_uring_disabled) which can be either 0, 1, or
> 2. When 0 (the default), all processes are allowed to create io_uring
> instances, which is the current behavior.  When 1, io_uring creation is
> disabled (io_uring_setup() will fail with -EPERM) for unprivileged
> processes not in the kernel.io_uring_group group.  When 2, calls to
> io_uring_setup() fail with -EPERM regardless of privilege.
>
> Signed-off-by: Matteo Rizzo <matteorizzo@google.com>
> [JEM: modified to add io_uring_group]
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

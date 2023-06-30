Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485D6743E7B
	for <lists+io-uring@lfdr.de>; Fri, 30 Jun 2023 17:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbjF3PR2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Jun 2023 11:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbjF3PRI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Jun 2023 11:17:08 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E54E44BF
        for <io-uring@vger.kernel.org>; Fri, 30 Jun 2023 08:16:24 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f9b9863bfdso110615e9.1
        for <io-uring@vger.kernel.org>; Fri, 30 Jun 2023 08:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688138180; x=1690730180;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O2hR/KhNASLMJVxFauqxU4XhDOn7bSDTmrq/J7vDv7o=;
        b=TRZxNMjM5RO1JNNZKgZOR5RH0Yv5C4Vn/RneOeTsb/05jK/UeLFCidNiyWhwyUaf5Z
         aupF/jUOf2e3MicdLXmgIL0Ub+YmBEQYQcerycEdzdn2KKJhfmpJqDh7CqFLInXofjtP
         OZXzw+wFgvv6XOU1YSmGEQm+w388OMDhu2eXlR8bp70x8p6OC91xXw3YwfrQggnC9IC9
         WmFbW3TVfFf9vavDHIWsGS928BqHQoqNa/G6UV10Fg8X3Rvaqzy7AQ9kLz3P4VzdQO/k
         0vQSKmKKQJj0qm7Il8kPYMhj/Z7nil2hqR6c2Dhfm315YIX3rNVztxyRHs4/o8MfQDR/
         HHkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688138180; x=1690730180;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O2hR/KhNASLMJVxFauqxU4XhDOn7bSDTmrq/J7vDv7o=;
        b=W7BA41499Yt5IbMwnGNHk7OLOBmjP4K3q+pQP0Oz1w35Vb0nALy4ZvKbW7ZFskITSr
         MB3itnKI6HzZHjXkiXSfnxd+IkKOfdhCaW0XgRa2j1bTIJ8mDaUtTmlm62uwhQjqeizh
         Vga+DWUchVnmiZT9mvymtew1a/DT2+cSPtrPrC3dU70aV+uTAO7EsLyzdRmKn/IznWZ8
         F1kV5bUZIQh4fbA8/VR1rbJt0ZchGRi/dkgjUl82ssVmOZp2YTEjko+iOi9dCCLChvZz
         m99j7GtkVL2vi51MdcHNBpjMDar4isbaQdwyQlH2OPieB4TqzJjhOTRFoHDroV9Y4D+F
         pPIQ==
X-Gm-Message-State: AC+VfDxSGp/ysUeSRT+n9qDcMA+UP+/gvAuJeiSJkCP4u2KWztoir0UN
        T1H+MJ1/KOuK9WmWlbH2tm0JT8rFtRsYl1gAO+vpHQ==
X-Google-Smtp-Source: ACHHUZ57TDCyI6HuFq6itIHyiuswS8qTRk/Uhbs5B8NDAkYH9kZN6vimTj2ZxN5nJTEEDgvzPrpgVVsGwA9BMFbOTJU=
X-Received: by 2002:a05:600c:860c:b0:3f4:fb7:48d4 with SMTP id
 ha12-20020a05600c860c00b003f40fb748d4mr378270wmb.3.1688138180627; Fri, 30 Jun
 2023 08:16:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230630151003.3622786-1-matteorizzo@google.com> <20230630151003.3622786-2-matteorizzo@google.com>
In-Reply-To: <20230630151003.3622786-2-matteorizzo@google.com>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 30 Jun 2023 17:15:44 +0200
Message-ID: <CAG48ez3k2K1_gwxo=ckHQmHxXgV-VfQ897-TXQcJjUcdiyr4Hg@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] io_uring: add a sysctl to disable io_uring system-wide
To:     Matteo Rizzo <matteorizzo@google.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        corbet@lwn.net, akpm@linux-foundation.org, keescook@chromium.org,
        ribalda@chromium.org, rostedt@goodmis.org, chenhuacai@kernel.org,
        gpiccoli@igalia.com, ldufour@linux.ibm.com, evn@google.com,
        poprdi@google.com, jordyzomer@google.com, jmoyer@redhat.com,
        krisman@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jun 30, 2023 at 5:10=E2=80=AFPM Matteo Rizzo <matteorizzo@google.co=
m> wrote:
> Introduce a new sysctl (io_uring_disabled) which can be either 0, 1,
> or 2. When 0 (the default), all processes are allowed to create io_uring
> instances, which is the current behavior. When 1, all calls to
> io_uring_setup fail with -EPERM unless the calling process has
> CAP_SYS_ADMIN. When 2, calls to io_uring_setup fail with -EPERM
> regardless of privilege.
>
> Signed-off-by: Matteo Rizzo <matteorizzo@google.com>
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
> Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

Reviewed-by: Jann Horn <jannh@google.com>

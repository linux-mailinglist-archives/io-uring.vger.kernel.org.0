Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F35CC5A54AE
	for <lists+io-uring@lfdr.de>; Mon, 29 Aug 2022 21:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiH2Tqb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Aug 2022 15:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiH2Tqa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Aug 2022 15:46:30 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C58274DCA
        for <io-uring@vger.kernel.org>; Mon, 29 Aug 2022 12:46:29 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id w19so17807591ejc.7
        for <io-uring@vger.kernel.org>; Mon, 29 Aug 2022 12:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=l3skwgcR8n0TOtdyqt/xNUW8nplEdhTPfhgsXZmnrKQ=;
        b=Yh6+YwaYs1PzKrQTJaAcU09TQYQ2BIGSMNIL6ouglFa+xuasecyb0lSAiJXHeXPe5W
         Bdi1x9neZ+kJNbCdv8uBNAPx+itz6RiwmysKHXqQJwccMnyO+wvtumLBctfPs2L5Mzxc
         lZtZSMj6NEgFT7vYzYwDw9bKvtsJ6ul7lXHFg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=l3skwgcR8n0TOtdyqt/xNUW8nplEdhTPfhgsXZmnrKQ=;
        b=7gFQuxxFhZi6RDe//5vgPMt+bP4iCinyP09uAXjkv92wlWqzM3sg0+rE/hY7mIZ5jG
         +578sZ7tKxcpjR+tGSHXTb8KRZ8TVPyfrqllQF7Zy5njSYHZr9fMmAcDkmHfyUortOKp
         J2+QDelaQsEB/1CubX5XeN3zEPGMhxOYBQb4eG3AGYV6A8ED/+Y49izfRJ8eS36H3hbF
         WNEhpD5H4QyVBvY/PxUVozZbe1VwZ8F5jaARd729pnHAjrkJVI3gBInroi2ybUy/1fVC
         hWkb4wW/8O09+TZtypfyG/P2S454uKYi1LMgpHnS0ah+Rt0MPpRI5QScRxcuN3AULYzh
         pTlQ==
X-Gm-Message-State: ACgBeo1TiGNpxJ3s3r7/fEk1i/3kR4vVWqPo1MDaQgvGMszdBqibADhI
        DctNKkTuZxGav5Y+Opmq6kos7V//MaM38Hj1xDx5yA==
X-Google-Smtp-Source: AA6agR4AEPuuqNAvtj7VH5sf6JPa+hVk/+Aj2e2mnhnqmHmfyg0qi61fsdOXESAcq7oh5B/9ODgKCOxDrbIsiJdwxLQ=
X-Received: by 2002:a17:907:7f0b:b0:731:b81a:1912 with SMTP id
 qf11-20020a1709077f0b00b00731b81a1912mr14735533ejc.8.1661802387869; Mon, 29
 Aug 2022 12:46:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220829030521.3373516-1-ammar.faizi@intel.com> <20220829030521.3373516-2-ammar.faizi@intel.com>
In-Reply-To: <20220829030521.3373516-2-ammar.faizi@intel.com>
From:   Caleb Sander <csander@purestorage.com>
Date:   Mon, 29 Aug 2022 12:46:17 -0700
Message-ID: <CADUfDZpE_gPyfN=dLKB6nu-++ZKyebpWTvYGNOmdP1-c_BLZZA@mail.gmail.com>
Subject: Re: [RFC PATCH liburing v1 1/4] syscall: Add io_uring syscall functions
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Muhammad Rizki <kiizuha@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Aug 28, 2022 at 8:07 PM Ammar Faizi <ammarfaizi2@gnuweeb.org> wrote:
>
> --- a/src/include/liburing.h
> +++ b/src/include/liburing.h
> @@ -202,6 +202,14 @@ int io_uring_register_file_alloc_range(struct io_uring *ring,
>  int io_uring_register_notifications(struct io_uring *ring, unsigned nr,
>                                     struct io_uring_notification_slot *slots);
>  int io_uring_unregister_notifications(struct io_uring *ring);
> +int io_uring_enter(unsigned int fd, unsigned int to_submit,
> +                  unsigned int min_complete, unsigned int flags,
> +                  sigset_t *sig);
> +int io_uring_enter2(int fd, unsigned to_submit, unsigned min_complete,
> +                   unsigned flags, sigset_t *sig, int sz);
> +int io_uring_setup(unsigned entries, struct io_uring_params *p);
> +int io_uring_register(int fd, unsigned opcode, const void *arg,
> +                     unsigned nr_args);

Can we be consistent about using "int fd"? And either standardize on
"unsigned" or "unsigned int"? Looks like syscalls should maybe be
separated by an empty line from the register/unregister functions in
the header file.

> --- /dev/null
> +++ b/src/syscall.c
> @@ -0,0 +1,30 @@
> +/* SPDX-License-Identifier: MIT */
> +
> +#include "lib.h"

Looks like this include is unused?

Other than that,
Reviewed-by: Caleb Sander <csander@purestorage.com>

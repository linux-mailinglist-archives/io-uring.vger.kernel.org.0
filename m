Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25EB65A54CE
	for <lists+io-uring@lfdr.de>; Mon, 29 Aug 2022 21:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbiH2Txb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Aug 2022 15:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiH2Txa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Aug 2022 15:53:30 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE657EFC1
        for <io-uring@vger.kernel.org>; Mon, 29 Aug 2022 12:53:28 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id b44so11493299edf.9
        for <io-uring@vger.kernel.org>; Mon, 29 Aug 2022 12:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=wGECd8qA2RkmX9DUfs/SFtBdSKgbGgulG6ur/Hs/iUk=;
        b=Zmpu1nebw8q0dcKAYgbYOGB98Ujq44adRJiI6eia3u4qwyHqZ+caQlJeRFEwp3dZ7S
         yQEzNM541f62JJcVPwwEVUNnf/U7RSR+NcKSKLCMmk9T2UHXjfXucJXdQUoOHbca1QGK
         DRZ78+wJvCMsu2pK8fBky4HLC7BT2NMb1eh6Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=wGECd8qA2RkmX9DUfs/SFtBdSKgbGgulG6ur/Hs/iUk=;
        b=iFql7jzvRtTAqzx9GSmIVuYSIh0J7qjGh+YNrf5ifxJ7EQ+H6itRpkfSmNLdzUo+56
         YY0c7hNDVtFt3bN4kqfDlPG5+rsr2E5cKXseS9Zu8HYB+my6siGZzCOjuCmmIwFygHaq
         lYL72bjnU8D+qpthhfyefdjMAz4oSdwVPjlyUipY0/cXIAM+436bTMu97IfTDh33V8O0
         r98oJgDw6AmGLykwWL+hyNoH1aaJnEr8zLr770WttrXj2dsND09w4er2Sihp9KXGafa3
         C6Ev4Cpyl1urT784MXkfV85txW/JyWNcdyQaPDhpSO5d/sPniA0GOdE5YiBlm1Oom644
         +0+A==
X-Gm-Message-State: ACgBeo2gWKLp/YwQs1bDHqKPbK9ZEZwcZ6Jpluw5vD1AmSQCF9Mv14kx
        bwiYZkv28opdQQSL0XxpuY7fKdK1wKxQlevLthINjw==
X-Google-Smtp-Source: AA6agR4IFnG81zntzVELOxJweXuAGAArzxxUdF1u/q34z6MCI8p1T90p/XlskewwDa5Q5BLxkcQsi40bL0xY7I29X5s=
X-Received: by 2002:a05:6402:2b91:b0:445:dfdb:778b with SMTP id
 fj17-20020a0564022b9100b00445dfdb778bmr18125839edb.367.1661802807026; Mon, 29
 Aug 2022 12:53:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220829030521.3373516-1-ammar.faizi@intel.com> <20220829030521.3373516-2-ammar.faizi@intel.com>
In-Reply-To: <20220829030521.3373516-2-ammar.faizi@intel.com>
From:   Caleb Sander <csander@purestorage.com>
Date:   Mon, 29 Aug 2022 12:53:16 -0700
Message-ID: <CADUfDZr0mPn_REb24aEPa477T+CYeoV5hcbURqX9kazCUqRp4A@mail.gmail.com>
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

Also, from the io_uring_enter() man page, it appears that "void *"
would be a more appropriate type for the pointer argument in
io_uring_enter2(). And "size_t" for sz.

--Caleb

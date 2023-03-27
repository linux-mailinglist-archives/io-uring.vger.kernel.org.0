Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA90A6CAE4A
	for <lists+io-uring@lfdr.de>; Mon, 27 Mar 2023 21:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbjC0TMw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 15:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232692AbjC0TMc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 15:12:32 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75834469F
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 12:12:20 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id d75a77b69052e-3ddbf70d790so940911cf.1
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 12:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679944339;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hCIxMCtVwvJudjfZUgG2jT2uTyvf4xuZUEIz2rDKMFI=;
        b=NwtDg0rPE+ibvY3zDSxy+0v5POp391qso4fB1BMcg/Ex+IctIn+nYEB6DEfvNSe1mc
         NETxtSk8dJM4AxayzkpUzYWIA+BI02N5f7IyeTsdZ6+qW4aU8zHNbmHAn40YwFI54rXn
         jTr8j8Qp4SdrhU9xAi4Nwkob1DaB6H7WlhcdHSm0z1mpuDOkVfPNPsljVcm+XE06Ffiy
         P1CvL5gVyQV8TsoV06LTDIokTfOuy3EuuuwfBU9eRY2WRLagh9sBc46ow1gu2RTyNXCi
         gZiBpL01x3x3e9E2luH9LssT/L10XPA5r4nhGnTP3SrRrM2X99csrWSimK+6iuAb3HmE
         355Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679944339;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hCIxMCtVwvJudjfZUgG2jT2uTyvf4xuZUEIz2rDKMFI=;
        b=gN8H/2OQg36DcWZT/ueVO9dNXnKMnNW6d6H9TTiXEk12fxigV5Ksq0FnG+9Ps312k5
         piXu6hTK/XazdE/A9OLRyfcxF9OmNUix9J6KjiLfD1tsu+G1eDpj9HF8MkbRoL5Wgojd
         a8OeTFZxeJXliY2gtNxKlI4l9c4+H0OQtDAxtspI+6XEDsDPXp4zb862nUZcnbm8Q71u
         ytypZdUqUbQbOJukssUF1x0C0zWbQWwrBgSzd1ngUhP+7hoSOa9jpY7g1qxKUw2K0Pyu
         hOO51ON84Mea5OTGKwqJwAi2KgyUqneuJHLDJRCE8yaM5mM6H+u4y1r79oS71GXjDj1I
         gySQ==
X-Gm-Message-State: AAQBX9fgSyz4SC3zR8N+T7vBF8lSjT+e6eFxIJvgxdI1weOizCHkpTFh
        Eh0ujz0Bu67IQgp2j+PtKgjEcXHjcW8ZbbJd8XZ99A==
X-Google-Smtp-Source: AKy350ZKQL/fS8u5F0Tn61irzgLpRzanEqu/twC4hgamyI8WQpdRTP9uWs0zLa93gHIPpODnhX0n3WNudWnmPAUK9vg=
X-Received: by 2002:ac8:58cb:0:b0:3bf:b62a:508b with SMTP id
 u11-20020ac858cb000000b003bfb62a508bmr59524qta.12.1679944339546; Mon, 27 Mar
 2023 12:12:19 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000bb028805f7dfab35@google.com> <2309ca53-a126-881f-1ffa-4f5415a32173@kernel.dk>
In-Reply-To: <2309ca53-a126-881f-1ffa-4f5415a32173@kernel.dk>
From:   Aleksandr Nogikh <nogikh@google.com>
Date:   Mon, 27 Mar 2023 21:12:06 +0200
Message-ID: <CANp29Y66H4-+d4hat_HCJck=u8dTn9Hw5KNzm1aYifQArQNNEw@mail.gmail.com>
Subject: Re: [syzbot] Monthly io-uring report
To:     Jens Axboe <axboe@kernel.dk>
Cc:     syzbot <syzbot+lista29bb0eabb2ddbae6f4a@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Mar 27, 2023 at 8:23=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/27/23 5:01?AM, syzbot wrote:
> > 1873    Yes   WARNING in split_huge_page_to_list (2)
> >               https://syzkaller.appspot.com/bug?extid=3D07a218429c8d19b=
1fb25
> > 38      Yes   KASAN: use-after-free Read in nfc_llcp_find_local
> >               https://syzkaller.appspot.com/bug?extid=3De7ac69e6a5d8061=
80b40
>
> These two are not io_uring. Particularly for the latter, I think syzbot
> has a tendency to guess it's io_uring if any kind of task_work is
> involved. That means anything off fput ends up in that bucket. Can we
> get that improved please?

Sure, I'll update the rules and rerun the subsystem recognition.

Currently syzbot sets io_uring if at least one is true
a) The crash stack trace points to the io_uring sources (according to
MAINTAINERS)
b) At least one reproducer has the syz_io_uring_setup call (that's a
helper function that's part of syzkaller).

In general syzbot tries to minimize the reproducer, but unfortunately
sometimes there remain some calls, which are not necessary per se. It
definitely tried to get rid of them, but the reproducer was just not
working with those calls cut out. Maybe they were just somehow
affecting the global state and in the execution log there didn't exist
any other call candidates, which could have fulfilled the purpose just
as well.

I can update b) to "all reproducers have syz_io_uring_setup". Then
those two bugs won't match the criteria.
If it doesn't suffice and there are still too many false positives, I
can drop b) completely.

By the way, should F: fs/io-wq.c also be added to the IO_URING's
record in the MAINTAINERS file?

--
Aleksandr

>
> --
> Jens Axboe
>

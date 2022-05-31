Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6DA8538D3F
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 10:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244992AbiEaIw3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 04:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244913AbiEaIw2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 04:52:28 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F8132EDE
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 01:52:23 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id l30so15252025lfj.3
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 01:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hdz49r3V2X3U4pi1USEl8OmSAZKCJRD+QzfUeTux25s=;
        b=TNJmaOj24mhsrSk94wpVXAbkJKeNJX6tOccrc4N8hmQfoaET8m7TSwEohBoYxRihFU
         vbqzYwYM6Bfo5OSj/gxzloziDoL5C+iVjpqSD2TgFYbXKbnsaizWC0A3pK3nBmnBFY99
         JNcitfsMokb+yCr2wje+baZK13PgiuqCiUf7JYhJ4dJsMpSIy9p5u2HkFJq9ZjpNB/EZ
         qHK1koJrLPlTMCX1w6nixQCbw8fujVWEpYz4+Zrz6YRjWCyV+jq9bnG3bEUi+RyBdgFM
         rTi28iVBAxOryrOwdPZPwNEsco5ixgqLbiaGS5AnyFrLf/G6CT5yArJejo0lLw1FkBmE
         4xUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hdz49r3V2X3U4pi1USEl8OmSAZKCJRD+QzfUeTux25s=;
        b=n8X9L4BlheUHJ9QIHsChYjReSzsNCo7rfAcife+Z7142bCz8+Dc54gbCp3QMi7Jxyt
         iXi4/Kk7BjyV0YD4/b/OsfJn3OU8OdHbRcqdzQfN+QvwSEmlvr/aoLJqmKF6A5oS0nmT
         hh5fGhlxycsyCiaUFbxPUZ20jOdyw8Dy0AKtmJp0P66Da4cn55IIvOYpmeJAMtc7iNWP
         pJf3gQSlRqcscUGMqoJF6xKkF48W4PmXMa/crSUnGx1s+Ss+SqMbsO4FP1I/X8zs7HBC
         qjTJT43bjZEhkNj1OsL5U/ZyBrg97HW4mudyUnnSs9nkePYjKulagmM2SLWqTG9zbyET
         LB5Q==
X-Gm-Message-State: AOAM531s9UrdQUfz/NrQlt14qnh4iemGBKjMjxmDfRWstI5atE6wK1N7
        Zxj8JwN6DrozxzDsDJwwM+M9Gbx8h9gdpDmxlRK+PQ==
X-Google-Smtp-Source: ABdhPJxsZz5kBoL6Ux+Ztj+JLaNa/QWQLcRxB5vCUF6gaZf2nL8wz+TqqWYVegwAVntJ6/Cb0izqUWMvOXaAXf6sUYQ=
X-Received: by 2002:a19:7106:0:b0:478:68b5:86d9 with SMTP id
 m6-20020a197106000000b0047868b586d9mr32260909lfc.417.1653987142058; Tue, 31
 May 2022 01:52:22 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000f0b26205e04a183b@google.com> <3d3c6b5f-84cd-cb25-812e-dac77e02ddbf@kernel.dk>
In-Reply-To: <3d3c6b5f-84cd-cb25-812e-dac77e02ddbf@kernel.dk>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 31 May 2022 10:52:10 +0200
Message-ID: <CACT4Y+ah2r5AVDSyDoz=VA_GO6gtp77JfOqc3RjVzLe3DfRAMw@mail.gmail.com>
Subject: Re: [syzbot] UBSAN: array-index-out-of-bounds in io_submit_sqes
To:     Jens Axboe <axboe@kernel.dk>
Cc:     syzbot <syzbot+b6c9b65b6753d333d833@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 31 May 2022 at 10:45, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 5/31/22 1:55 AM, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    3b46e4e44180 Add linux-next specific files for 20220531
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=16e151f5f00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=ccb8d66fc9489ef
> > dashboard link: https://syzkaller.appspot.com/bug?extid=b6c9b65b6753d333d833
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+b6c9b65b6753d333d833@syzkaller.appspotmail.com
> >
> > ================================================================================
> > ================================================================================
> > UBSAN: array-index-out-of-bounds in fs/io_uring.c:8860:19
> > index 75 is out of range for type 'io_op_def [47]'
>
> 'def' is just set here, it's not actually used after 'opcode' has been
> verified.

An interesting thing about C is that now the compiler is within its
rights to actually remove the check that is supposed to validate the
index because indexing io_op_defs[opcode] implies that opcode is
already within bounds, otherwise the program already has undefined
behavior, so removing the check is that case is also OK ;)

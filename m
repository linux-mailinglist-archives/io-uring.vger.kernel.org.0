Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B3459EB3B
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 20:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbiHWSjz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 14:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiHWSjc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 14:39:32 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8439911559E
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 10:02:58 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id u14so16772769oie.2
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 10:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=5ra72b4qNtNT5/Y8jyxLZXNvJFrA5g4ZvUa/siW8nrc=;
        b=Rg9KqkTbhDsx/lxgn3tH/StZ2ZUh0LEpW0faHIyP8g0kYJTa+Ywx9u/V2wYpJ1V3Al
         KEWkjzcT+JDbL2nzQ3d/L4mTsRM89S9fXveF64lTbLHmCHITSXDz9soOhkQOUOfFjA7K
         se4JbQU3WkjCJCmGwwKzO7Ay94mxODHVwPqmnIlL5s/9YoHgi3hHnxHxgJOhSahkUmjd
         xvmte1qK3TXfAP4aVgf45E3/8/1/LChRhBrbBnnbU7XDbpTYNkX5dm74zHttr8K1T1lg
         3qkdBJ5xnX48IJbFyzWlAmMj+7FIyjNWpVfvPSxKUmi2swMd9PxVysP/f7gVNUBUOCRZ
         PzCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=5ra72b4qNtNT5/Y8jyxLZXNvJFrA5g4ZvUa/siW8nrc=;
        b=s0fhsPKDagjkqUah+kYgmm860TPIUKJQDSBy2RIKRqVGuhNEdbVTOncpkiWCfpdI6n
         1lPPdcFMsRmwRH8Gg7EhQae94YT2pXkz3TGeE8BXrVhIFRlu+FfPVc6/0CW5MCkvymaS
         M2tWJgMvKjX4Uej9/hg1zvgzFjpLoku093IOhP94hP/QpNLgQOi3nhTl07FFnVKsfEf6
         0QQXTQn/dpEUTLuqE1N094lWei33x1grA+ksUEZZrElNR831r0JtCW4Jjwi99QJPAMEE
         ajVWrRmYxc0OyJPbajszHMxp7X/YqOnb9lPglAWyGxUD0WdXjLfxOs8Wahh5NJ5pKElR
         FjhQ==
X-Gm-Message-State: ACgBeo2gcHGR9ZWj7wBg+deMwTPgRTj64UY+k4ulrs07tmhAu/xvS3iv
        PrhqGpSHcxMzdW/N5q6fgUOPUz0xUi3WGUoYJxIM
X-Google-Smtp-Source: AA6agR7t8bOik6TV8VoD43ntts3M9ydgQUxiv64BSr02QdRPvcxKN04bquZG9GJRFCRRtbxhCt2WNmN+BWaOEhhjlmA=
X-Received: by 2002:a05:6808:3a9:b0:343:4b14:ccce with SMTP id
 n9-20020a05680803a900b003434b14cccemr1702207oie.41.1661274174127; Tue, 23 Aug
 2022 10:02:54 -0700 (PDT)
MIME-Version: 1.0
References: <166120321387.369593.7400426327771894334.stgit@olly>
 <166120327984.369593.8371751426301540450.stgit@olly> <YwR41qQs07dYVnqD@kroah.com>
 <d2a66100-6660-8f99-a100-0f3c4f80d0ac@kernel.dk>
In-Reply-To: <d2a66100-6660-8f99-a100-0f3c4f80d0ac@kernel.dk>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 23 Aug 2022 13:02:43 -0400
Message-ID: <CAHC9VhRiTDqL-EtUcJ9y8nzRPk2BAfGzWK97oe56Ld4KyZsmGg@mail.gmail.com>
Subject: Re: [PATCH 3/3] /dev/null: add IORING_OP_URING_CMD support
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        io-uring@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Luis Chamberlain <mcgrof@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 23, 2022 at 9:33 AM Jens Axboe <axboe@kernel.dk> wrote:
> On 8/23/22 12:51 AM, Greg Kroah-Hartman wrote:
> > On Mon, Aug 22, 2022 at 05:21:19PM -0400, Paul Moore wrote:
> >> This patch adds support for the io_uring command pass through, aka
> >> IORING_OP_URING_CMD, to the /dev/null driver.  As with all of the
> >> /dev/null functionality, the implementation is just a simple sink
> >> where commands go to die, but it should be useful for developers who
> >> need a simple IORING_OP_URING_CMD test device that doesn't require
> >> any special hardware.
> >>
> >> Cc: Arnd Bergmann <arnd@arndb.de>
> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> Signed-off-by: Paul Moore <paul@paul-moore.com>
> >> ---
> >>  drivers/char/mem.c |    6 ++++++
> >>  1 file changed, 6 insertions(+)
> >>
> >> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> >> index 84ca98ed1dad..32a932a065a6 100644
> >> --- a/drivers/char/mem.c
> >> +++ b/drivers/char/mem.c
> >> @@ -480,6 +480,11 @@ static ssize_t splice_write_null(struct pipe_inode_info *pipe, struct file *out,
> >>      return splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_null);
> >>  }
> >>
> >> +static int uring_cmd_null(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
> >> +{
> >> +    return 0;
> >
> > If a callback just returns 0, that implies it is not needed at all and
> > can be removed and then you are back at the original file before your
> > commit :)
>
> In theory you are correct, but the empty hook is needed so that
> submitting an io_uring cmd to the file type is attempted. If not it's
> just errored upfront.
>
> Paul, is it strictly needed to test the selinux uring cmd policy? If the
> operation would've been attempted but null doesn't support it, you'd get
> -1/EOPNOTSUPP - and supposedly you'd get EACCES/EPERM or something if
> it's filtered?

I haven't built a kernel without this patch to test, but yes, you are
probably correct that it wouldn't be strictly necessary, but
considering the extreme simplicity of this addition, what is the real
harm here?  Wouldn't it be nice to have a rather simple
IORING_OP_URING_CMD target?

Also, just so we are clear, I didn't mark this patch with the
stable/fixes tags because I don't believe this should go into -stable;
while I believe it is a nice addition, it is definitely not critical.

-- 
paul-moore.com

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B49CD59CBED
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 01:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbiHVXJb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Aug 2022 19:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233927AbiHVXJb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Aug 2022 19:09:31 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D810B24BD5
        for <io-uring@vger.kernel.org>; Mon, 22 Aug 2022 16:09:29 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id t11-20020a05683014cb00b0063734a2a786so8705672otq.11
        for <io-uring@vger.kernel.org>; Mon, 22 Aug 2022 16:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=1TNSDsn5a6YjqytkykGHlEca8O4pUSy2rYwmIIw8EBY=;
        b=tFrKHjzXEuwp616TFpLbx4Xu7i37aqHZStlsMUeBaIN0zpAaFKPx0ZEu3wWQ/iSC9Q
         IcnHPoGDwFDP/UMw3S3W8BW2ycro4vn3Qgrx4+GePG12HVN3PYQZYJqxM19FWk1OxBqG
         JbZC8uE1t/5NPXKDkkwzdMvao/O8ZgYbpO7pCFCX2Mh/7qg2Tbiz86R1nQAvjf03Mdjh
         8spVC3mwqTbRqOSuw+/GEfWEbXohe1E3a5zKjSqSha3N8yZ5Rp465jJks/eo3K1BrR2m
         KdG7Rzo08Y2aDsrHoSAqa6Mn+j92cuYZfWqp63dgEvU99tp+xQGZx6MWxrY5sAqjpWlS
         NlPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=1TNSDsn5a6YjqytkykGHlEca8O4pUSy2rYwmIIw8EBY=;
        b=LQnJlzMZQnSpo/pWJgBAVtSvRXT6YFcNqSSkmxx/qzRqdGkElzuMP9nuy++UThkSge
         hETubviUAWWXsWJXf0c/C/IZ/fWbe3DbDL07KNxCGPJp6WUmglQjTkZ6PwT4cWb2p0Ae
         diemAOuq00qZPdeusE0LtoRAI7aIpa/GHK+liaJMssC8isGKaPSNtJLTr5P/oAUMr5Az
         UxGe9MKkMBCWyGpu4nYpbbbrxv78t3gPCHmBVbwecxtgLD6cf6p8fV2XJNsgSAYJP5bY
         5b9KFEG0IGHrrr5YpHu69k5jeVP6NSr0ihyzcd2Y2DTIod1OfCjnzfu5XhsRjkUeVa3B
         Fe/w==
X-Gm-Message-State: ACgBeo1cLRkD2SuCjvva6WL8fpveBx+TRFUCIY+hft41AggUuR3IU449
        msyddl41i7ggP+QJwQdMhcR262DXWOIKUtfvN5Oa
X-Google-Smtp-Source: AA6agR6YpVoTlJJBzL3/JcnAxD6NnhlOmeNP2E53wlQ7aUoRV3cH3BTsXiJtIxZuTCG84I4+/YB02pOSnuUVH7BDqyg=
X-Received: by 2002:a9d:2de3:0:b0:638:e210:c9da with SMTP id
 g90-20020a9d2de3000000b00638e210c9damr8439945otb.69.1661209769113; Mon, 22
 Aug 2022 16:09:29 -0700 (PDT)
MIME-Version: 1.0
References: <166120321387.369593.7400426327771894334.stgit@olly>
 <166120327984.369593.8371751426301540450.stgit@olly> <1e4dde67-4ac2-06b0-b927-ce4601ed9b30@kernel.dk>
In-Reply-To: <1e4dde67-4ac2-06b0-b927-ce4601ed9b30@kernel.dk>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 22 Aug 2022 19:09:18 -0400
Message-ID: <CAHC9VhQbnN2om-Qt59ZNovEgRAcB=XvcR+AYK8HhLLrPmMjMLA@mail.gmail.com>
Subject: Re: [PATCH 3/3] /dev/null: add IORING_OP_URING_CMD support
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        io-uring@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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

On Mon, Aug 22, 2022 at 6:36 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 8/22/22 3:21 PM, Paul Moore wrote:
> > This patch adds support for the io_uring command pass through, aka
> > IORING_OP_URING_CMD, to the /dev/null driver.  As with all of the
> > /dev/null functionality, the implementation is just a simple sink
> > where commands go to die, but it should be useful for developers who
> > need a simple IORING_OP_URING_CMD test device that doesn't require
> > any special hardware.
> >
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Paul Moore <paul@paul-moore.com>
> > ---
> >  drivers/char/mem.c |    6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> > index 84ca98ed1dad..32a932a065a6 100644
> > --- a/drivers/char/mem.c
> > +++ b/drivers/char/mem.c
> > @@ -480,6 +480,11 @@ static ssize_t splice_write_null(struct pipe_inode_info *pipe, struct file *out,
> >       return splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_null);
> >  }
> >
> > +static int uring_cmd_null(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
> > +{
> > +     return 0;
> > +}
>
> This would be better as:
>
>         return IOU_OK;
>
> using the proper return values for the uring_cmd hook.

The only problem I see with that is that IOU_OK is defined under
io_uring/io_uring.h and not include/linux/io_uring.h so the #include
macro is kinda ugly:

  #include "../../io_uring/io_uring.h"

I'm not sure I want to submit that upstream looking like that.  Are
you okay with leaving the return code as 0 for now and changing it at
a later date?  I'm trying to keep this patchset relatively small since
we are in the -rcX stage, but if you're okay with a simple cut-n-paste
of the enum to linux/io_uring.h I can do that.

> With that:
>
> Acked-by: Jens Axboe <axboe@kernel.dk>

-- 
paul-moore.com

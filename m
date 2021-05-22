Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A8A38D30F
	for <lists+io-uring@lfdr.de>; Sat, 22 May 2021 04:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhEVCiT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 May 2021 22:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbhEVCiS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 May 2021 22:38:18 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E31C061574
        for <io-uring@vger.kernel.org>; Fri, 21 May 2021 19:36:53 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id h16so25359688edr.6
        for <io-uring@vger.kernel.org>; Fri, 21 May 2021 19:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/bYvAACSgc8/uW7uI1cczUf6zncLtiw3niodFFHXbfQ=;
        b=zueRaqvi0ABnvezPF7a/BvC89XCqv9MA5lpZVc06qJfZkfTl6XHxnBOB/b37aSowba
         MvmSbZcggtkx+qjxr+EQ8Vt4UbkoAt9GxSaZcQWxj+cXScSaCGqbmirFZ3ycLfQgLS/9
         WMEhgZTGZ+Jyxu49B0c2KfgCbz4b0bJfFQtZl+2Vauh5sD/CpwxFmg9xTbxyFIE5c6Qq
         a5Oo9V20+jqFrSCcPiFpYwKUeTyINRxOIsc57wXIsZFUmGXsNtcROoIzG3rhmdETAJj3
         XfuB/9Adbbapv5EF6kx5uRfFhVUGUWtZ6qINh5fUAFO5uZJXq2fxmJfHd2s/zAercPZD
         AZpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/bYvAACSgc8/uW7uI1cczUf6zncLtiw3niodFFHXbfQ=;
        b=AO+5viGUi+CE3eSKa6PpV21LaisCHwORPS77hSk1WCWlqHlj36ZBtBl9PO458FAwqz
         sWofqLahiE0pBKODuAALm1Bq0jpoSBn8zUtVTzF2pyDG8WBVGezLCnl6Bq95DZeWG8XZ
         fBswd/wkb2JMidQqpw9/kPK8JlhgxJb/RVdIbGbkMiWFZDbzzq/uv3fdRivg4g48gtek
         DnOMWtJKOS9z27EGiIq4+dAedVYuRvqpncpq+H622NhwCdi6mxmmaMY+unAGoQWPLOWU
         fcPSoZMcL/M32KWjGAU8ujf91LxKpHDCha+31CNEyuScsl0BgRKbroH/ajEz/I1GJDHR
         U11g==
X-Gm-Message-State: AOAM532HiQ5xUjj8KUg47hxWlnyWysTTcvvucLNepqJjmAKysIFO0eC1
        0lyP6YmmO4AQt+afalEorMjQM+H35SuLnO/8fA2d
X-Google-Smtp-Source: ABdhPJz9UvC/faFDkiRLsiBXVJ9IkfixZn9C7UN/IQ22MxEe2N1Eq1BZgP//f1I2SXPZB1KVfu8b/AJWi+UrvHYAZ34=
X-Received: by 2002:aa7:c349:: with SMTP id j9mr13964677edr.135.1621651012073;
 Fri, 21 May 2021 19:36:52 -0700 (PDT)
MIME-Version: 1.0
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <162163379461.8379.9691291608621179559.stgit@sifl> <f07bd213-6656-7516-9099-c6ecf4174519@gmail.com>
In-Reply-To: <f07bd213-6656-7516-9099-c6ecf4174519@gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 21 May 2021 22:36:40 -0400
Message-ID: <CAHC9VhRjzWxweB8d8fypUx11CX6tRBnxSWbXH+5qM1virE509A@mail.gmail.com>
Subject: Re: [RFC PATCH 2/9] audit,io_uring,io-wq: add some basic audit
 support to io_uring
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, May 21, 2021 at 8:22 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> On 5/21/21 10:49 PM, Paul Moore wrote:
> > WARNING - This is a work in progress and should not be merged
> > anywhere important.  It is almost surely not complete, and while it
> > probably compiles it likely hasn't been booted and will do terrible
> > things.  You have been warned.
> >
> > This patch adds basic auditing to io_uring operations, regardless of
> > their context.  This is accomplished by allocating audit_context
> > structures for the io-wq worker and io_uring SQPOLL kernel threads
> > as well as explicitly auditing the io_uring operations in
> > io_issue_sqe().  The io_uring operations are audited using a new
> > AUDIT_URINGOP record, an example is shown below:
> >
> >   % <TODO - insert AUDIT_URINGOP record example>
> >
> > Thanks to Richard Guy Briggs for review and feedback.
> >
> > Signed-off-by: Paul Moore <paul@paul-moore.com>
> > ---
> [...]
> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index e481ac8a757a..e9941d1ad8fd 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -78,6 +78,7 @@
> >  #include <linux/task_work.h>
> >  #include <linux/pagemap.h>
> >  #include <linux/io_uring.h>
> > +#include <linux/audit.h>
> >
> >  #define CREATE_TRACE_POINTS
> >  #include <trace/events/io_uring.h>
> > @@ -6105,6 +6106,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
> >       if (req->work.creds && req->work.creds != current_cred())
> >               creds = override_creds(req->work.creds);
> >
> > +     if (req->opcode < IORING_OP_LAST)
>
> always true at this point

I placed the opcode check before the audit call because the switch
statement below which handles the operation dispatching has a 'ret =
-EINVAL' for the default case, implying that there are some paths
where an invalid opcode could be passed into the function.  Obviously
if that is not the case and you can guarantee that req->opcode will
always be valid we can easily drop the check prior to the audit call.

> > +             audit_uring_entry(req->opcode);
>
> So, it adds two if's with memory loads (i.e. current->audit_context)
> per request in one of the hottest functions here... No way, nack
>
> Maybe, if it's dynamically compiled into like kprobes if it's
> _really_ used.

I'm open to suggestions on how to tweak the io_uring/audit
integration, if you don't like what I've proposed in this patchset,
lets try to come up with a solution that is more palatable.  If you
were going to add audit support for these io_uring operations, how
would you propose we do it?  Not being able to properly audit io_uring
operations is going to be a significant issue for a chunk of users, if
it isn't already, we need to work to find a solution to this problem.

Unfortunately I don't think dynamically inserting audit calls is
something that would meet the needs of the audit community (I fear it
would run afoul of the various security certifications), and it
definitely isn't something that we support at present.

-- 
paul moore
www.paul-moore.com

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B399B40DD31
	for <lists+io-uring@lfdr.de>; Thu, 16 Sep 2021 16:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238768AbhIPOsz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Sep 2021 10:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238871AbhIPOsy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Sep 2021 10:48:54 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E071C061574
        for <io-uring@vger.kernel.org>; Thu, 16 Sep 2021 07:47:33 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id c21so17667239edj.0
        for <io-uring@vger.kernel.org>; Thu, 16 Sep 2021 07:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/LN2BDmi9UsBIWySN0ychwT/uhYm29Xfzmok+wmBDy8=;
        b=AEC8lQsO9zbk8axhvjI03XhRIUJx/B4a9jFhaBa3v37vO8TCEmLvpdoY7wlJ6Lu7S0
         b6bX8mGLqsaqxaE0ks8Jv5N/BgZK/BVnsw9oDjdf33Utbxa/T6L+3MKRLnU1QJo9AiOz
         NAzhoiewaYehtagaq7yLAR1V2QSSkq58aYyVedF6dYoo1iUzhXa2xHOtU+N401lDDaay
         jAPJmKLnpkn9C/CS3vQf0wu+8uGJG8Vjpeig+iaW8iSMyVFeQQaQLz0q5MqxbGgd6Xfb
         MnOllDna+U77qIIxrcmXjPwNWE4hkTidkb3AqcBA5OBq0a4SX6qtK3Sh3g82pNa80m97
         8gsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/LN2BDmi9UsBIWySN0ychwT/uhYm29Xfzmok+wmBDy8=;
        b=b+xbSFpo6xH5yR+V1kGpktzrndqEAqzzwF3S0Hklckq2de5OcSocS1XhbXQZjH4bc/
         ivv6f3A7YzRrIb2norAE0yhDEVl7DnpdGz8O31b9okNlx4m+nDVEUU21TdpJXV0aWVzm
         PZ8qiP8OUFF7DtEHmsUOZM3NIpk7nLLsFONVOwPxkM/Yv8pGyUtIghGjqPKp9pOnjeap
         ZAx57a/gt0YqaNfSnDWeUiKE0kxclObtDgY5gM/HRdTKi73HyJ0KiCrPxGdm9KkxqkeC
         lboTeX8hdnSwT/K9oB2N756LBum64UqUpnqwbXkv97kKelIeVYPOVHKrAxHrxrUimm0G
         39LA==
X-Gm-Message-State: AOAM5305n5BhiuJMPGcXjogOXxjR7mxikOmlWcxYda6voBt3bMhH3V/w
        QI6Z/y6QnCrt+piz9RN99RA6UNT05Lzn1T5r6SjM
X-Google-Smtp-Source: ABdhPJzbE9JbdEMAljCVP0OQkTSQ2+WpTRWjM1H7jtthNk52AzYJG8qEWm1u5LejTzmCtwxSRqQp8HbZECnGpK5a4yY=
X-Received: by 2002:a17:906:686:: with SMTP id u6mr6524873ejb.569.1631803648838;
 Thu, 16 Sep 2021 07:47:28 -0700 (PDT)
MIME-Version: 1.0
References: <163172413301.88001.16054830862146685573.stgit@olly>
 <163172457152.88001.12700049763432531651.stgit@olly> <20210916133308.GP490529@madcap2.tricolour.ca>
 <CAHC9VhSEj8b7+jH9Atkj3FH+SOdc5iwytxhS3_O1HmTahdj3dQ@mail.gmail.com> <20210916141935.GQ490529@madcap2.tricolour.ca>
In-Reply-To: <20210916141935.GQ490529@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 16 Sep 2021 10:47:17 -0400
Message-ID: <CAHC9VhTo8XPEeNPddHzXS8qCvzTvJUnLALF38VxeFEsXJRbn_Q@mail.gmail.com>
Subject: Re: [PATCH v4 2/8] audit,io_uring,io-wq: add some basic audit support
 to io_uring
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 16, 2021 at 10:19 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2021-09-16 10:02, Paul Moore wrote:
> > On Thu, Sep 16, 2021 at 9:33 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2021-09-15 12:49, Paul Moore wrote:
> > > > This patch adds basic auditing to io_uring operations, regardless of
> > > > their context.  This is accomplished by allocating audit_context
> > > > structures for the io-wq worker and io_uring SQPOLL kernel threads
> > > > as well as explicitly auditing the io_uring operations in
> > > > io_issue_sqe().  Individual io_uring operations can bypass auditing
> > > > through the "audit_skip" field in the struct io_op_def definition for
> > > > the operation; although great care must be taken so that security
> > > > relevant io_uring operations do not bypass auditing; please contact
> > > > the audit mailing list (see the MAINTAINERS file) with any questions.
> > > >
> > > > The io_uring operations are audited using a new AUDIT_URINGOP record,
> > > > an example is shown below:
> > > >
> > > >   type=UNKNOWN[1336] msg=audit(1630523381.288:260):
> > > >     uring_op=19 success=yes exit=0 items=0 ppid=853 pid=1204
> > > >     uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0
> > > >     subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
> > > >     key=(null)
> > > >     AUID="root" UID="root" GID="root" EUID="root" SUID="root"
> > > >     FSUID="root" EGID="root" SGID="root" FSGID="root"
> > > >
> > > > Thanks to Richard Guy Briggs for review and feedback.
> > >
> > > I share Steve's concerns about the missing auid and ses.  The userspace
> > > log interpreter conjured up AUID="root" from the absent auid=.
> > >
> > > Some of the creds are here including ppid, pid, a herd of *id and subj.
> > > *Something* initiated this action and then delegated it to iouring to
> > > carry out.  That should be in there somewhere.  You had a concern about
> > > shared queues and mis-attribution.  All of these creds including auid
> > > and ses should be kept together to get this right.
> >
> > Look, there are a lot of things about io_uring that frustrate me from
> > a security perspective - this is one of them - but I've run out of
> > ways to say it's not possible to reliably capture the audit ID or
> > session ID here.  With io_uring it is possible to submit an io_uring
> > operation, and capture the results, by simply reading and writing to a
> > mmap'd buffer.  Yes, it would be nice to have that information, but I
> > don't believe there is a practical way to capture it.  If you have any
> > suggestions on how to do so, please share, but please make it
> > concrete; hand wavy solutions aren't useful at this stage.
>
> I was hoping to give a more concrete solution but have other
> distractions at the moment.  My concern is adding it later once the
> message format is committed.  We have too many field orderings already.
> Recognizing this adds useless characters to the record type at this
> time, I'm even thinking auid=? ses=? until a solution can be found.

You know my feelings on audit record field orderings, so let's not
follow that distraction right now.

Regarding proactively inserting a placeholder for auid= and ses=, I'm
reasonably convinced it is not practical, and likely not possible, to
capture that information for the audit record.  As a result, I see no
reason to waste the space in the record.  However, if you  (or anyone
else for that matter) can show that we can reliably capture that
information then I'm in complete agreement that it should be added.

What I'm not going to do is hold this patchset any longer on a vague
feeling that it should be possible.  On the plus side I'm only merging
this into selinux/next, not selinux/stable-5.15, so worst case you
have a couple more weeks before things are "set".  I realize we all
have competing priorities, but as the saying goes, "it's time to put
up or shut up" ;)

> So you are sure the rest of the creds are correct?

Yes, the credentials that are logged in audit_log_uring() are all
taken from the currently executing task via a call to current_cred().
Regardless of the io_uring calling context (synchronous, io-wq,
sqpoll) the current_cred() call should always return the correct
credentials; look at how io_uring manages credentials in
io_issue_sqe().  While the audit log treats the audit ID just as if it
were another credential on the system, it is definitely not like a
normal credential and requires special handling; this is why there was
the mixup where I mistakenly left it in the audit record, and one of
the reasons why we will not always have a valid audit ID for io_uring
operations.

-- 
paul moore
www.paul-moore.com

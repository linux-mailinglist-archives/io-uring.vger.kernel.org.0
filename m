Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA69C39F728
	for <lists+io-uring@lfdr.de>; Tue,  8 Jun 2021 14:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbhFHM5P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Jun 2021 08:57:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36486 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232644AbhFHM5P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Jun 2021 08:57:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623156922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x+SsMma3Ar3rP8pZze2lcFu2xVDJbqONiUJxA3GUBLM=;
        b=Myb86yrKqksN3EwWRcC67JpzBLu0ntKkiNYRnu9b8hYcOFTZJ4yMR2qOgCmj5yeovWYZyW
        +pzJPuTd2rQHerlF3BfQd/uM903Q0yhQ0GbK1GwrcDff8kI2dY4qGZnhFRJHK+J/YJfvSU
        41iGzoOCDBXO4Tu26vh2DPWg/G2m73M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-544-THXSXa15OuConKqzS8b_Kw-1; Tue, 08 Jun 2021 08:55:20 -0400
X-MC-Unique: THXSXa15OuConKqzS8b_Kw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05E07107ACC7;
        Tue,  8 Jun 2021 12:55:19 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D7DCC5C1D5;
        Tue,  8 Jun 2021 12:55:07 +0000 (UTC)
Date:   Tue, 8 Jun 2021 08:55:05 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Jens Axboe <axboe@kernel.dk>, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-audit@redhat.com,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/2] audit: add filtering for io_uring records, addendum
Message-ID: <20210608125504.GA2268484@madcap2.tricolour.ca>
References: <CAHC9VhTr_hw_RBPf5yGD16j-qV2tbjjPJkimMNNQZBHtrJDbuQ@mail.gmail.com>
 <3a2903574a4d03f73230047866112b2dad9b4a9e.1622467740.git.rgb@redhat.com>
 <CAHC9VhRa9dvCfPf5WHKYofrvQrGff7Lh+H4HMAhi_z3nK_rtoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhRa9dvCfPf5WHKYofrvQrGff7Lh+H4HMAhi_z3nK_rtoA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2021-06-07 19:15, Paul Moore wrote:
> On Mon, May 31, 2021 at 9:45 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > The commit ("audit: add filtering for io_uring records") added support for
> > filtering io_uring operations.
> >
> > Add checks to the audit io_uring filtering code for directory and path watches,
> > and to keep the list counts consistent.
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  kernel/audit_tree.c  | 3 ++-
> >  kernel/audit_watch.c | 3 ++-
> >  kernel/auditfilter.c | 7 +++++--
> >  3 files changed, 9 insertions(+), 4 deletions(-)
> 
> Thanks for pointing these omissions out in the original patch.  When a
> patch has obvious problems generally people just provide feedback and
> the patch author incorporates the fixes; this helps ensure we don't
> merge known broken patches, helping preserve `git bisect`.
> 
> Do you mind if I incorporate these suggestions, and the one in patch
> 2/2, into the filtering patch in the original RFC patchset?  I'll add
> a 'thank you' comment in the commit description as I did to the other
> patch where you provided feedback.  I feel that is the proper way to
> handle this.

I should have been more explicit.  The intent was to have the fixes
incorporated directly into your patches since they aren't committed in
any public tree yet, exactly for bisect reasons.  I didn't add a
"fixes:" tag because it had no public commit hash, but could/should have
instead made a note about it or even used the "fixup:" subject tag.
Posting using the thread as the "in-reply-to:" for this patchset was the
simplest and clearest way to demonstrate the intent and check they were
correct and I was too lazy to add a cover letter explaining that.  There
is also a Co-developed-by: tag that could be used if you feel that is
appropriate, now that you mention it, but that appears to imply a much
stronger equal contribution.

> > diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
> > index 6c91902f4f45..2be285c2f069 100644
> > --- a/kernel/audit_tree.c
> > +++ b/kernel/audit_tree.c
> > @@ -727,7 +727,8 @@ int audit_make_tree(struct audit_krule *rule, char *pathname, u32 op)
> >  {
> >
> >         if (pathname[0] != '/' ||
> > -           rule->listnr != AUDIT_FILTER_EXIT ||
> > +           (rule->listnr != AUDIT_FILTER_EXIT &&
> > +            rule->listnr != AUDIT_FILTER_URING_EXIT) ||
> >             op != Audit_equal ||
> >             rule->inode_f || rule->watch || rule->tree)
> >                 return -EINVAL;
> > diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
> > index 2acf7ca49154..698b62b4a2ec 100644
> > --- a/kernel/audit_watch.c
> > +++ b/kernel/audit_watch.c
> > @@ -183,7 +183,8 @@ int audit_to_watch(struct audit_krule *krule, char *path, int len, u32 op)
> >                 return -EOPNOTSUPP;
> >
> >         if (path[0] != '/' || path[len-1] == '/' ||
> > -           krule->listnr != AUDIT_FILTER_EXIT ||
> > +           (krule->listnr != AUDIT_FILTER_EXIT &&
> > +            krule->listnr != AUDIT_FILTER_URING_EXIT) ||
> >             op != Audit_equal ||
> >             krule->inode_f || krule->watch || krule->tree)
> >                 return -EINVAL;
> > diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> > index c21119c00504..bcdedfd1088c 100644
> > --- a/kernel/auditfilter.c
> > +++ b/kernel/auditfilter.c
> > @@ -153,7 +153,8 @@ char *audit_unpack_string(void **bufp, size_t *remain, size_t len)
> >  static inline int audit_to_inode(struct audit_krule *krule,
> >                                  struct audit_field *f)
> >  {
> > -       if (krule->listnr != AUDIT_FILTER_EXIT ||
> > +       if ((krule->listnr != AUDIT_FILTER_EXIT &&
> > +            krule->listnr != AUDIT_FILTER_URING_EXIT) ||
> >             krule->inode_f || krule->watch || krule->tree ||
> >             (f->op != Audit_equal && f->op != Audit_not_equal))
> >                 return -EINVAL;
> > @@ -250,6 +251,7 @@ static inline struct audit_entry *audit_to_entry_common(struct audit_rule_data *
> >                 pr_err("AUDIT_FILTER_ENTRY is deprecated\n");
> >                 goto exit_err;
> >         case AUDIT_FILTER_EXIT:
> > +       case AUDIT_FILTER_URING_EXIT:
> >         case AUDIT_FILTER_TASK:
> >  #endif
> >         case AUDIT_FILTER_USER:
> > @@ -982,7 +984,8 @@ static inline int audit_add_rule(struct audit_entry *entry)
> >         }
> >
> >         entry->rule.prio = ~0ULL;
> > -       if (entry->rule.listnr == AUDIT_FILTER_EXIT) {
> > +       if (entry->rule.listnr == AUDIT_FILTER_EXIT ||
> > +           entry->rule.listnr == AUDIT_FILTER_URING_EXIT) {
> >                 if (entry->rule.flags & AUDIT_FILTER_PREPEND)
> >                         entry->rule.prio = ++prio_high;
> >                 else
> 
> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635


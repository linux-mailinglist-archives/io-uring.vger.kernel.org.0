Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07DC441D9D
	for <lists+io-uring@lfdr.de>; Mon,  1 Nov 2021 16:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhKAQBv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Nov 2021 12:01:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22467 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230517AbhKAQBv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Nov 2021 12:01:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635782357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xQkLx7oh3Q9/zSm+M/KzPWvOtlAzlPjb3SnLeQCDLIU=;
        b=PGDkstn6yT9OLQgGKgGEVt2vPtwO0L4lKRzGTiH8Usbkgu0YhCLdPqtIpcOypYkFyZYvFU
        d0SmvJbbGz7qEY6ITkJ6J0gjG9gUqSDesjFInLU2jbu/cjDKo7WeodAescFq6LckqbGDFB
        AwO7jyyIiF7BVQaGjkxqbnWMZZZtrxQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578-URtHZyVMOr-fKoSlnbcX_w-1; Mon, 01 Nov 2021 11:59:13 -0400
X-MC-Unique: URtHZyVMOr-fKoSlnbcX_w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA3BE10144E1
        for <io-uring@vger.kernel.org>; Mon,  1 Nov 2021 15:59:12 +0000 (UTC)
Received: from x2.localnet (unknown [10.22.33.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1BC5A5C1C5;
        Mon,  1 Nov 2021 15:58:41 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v3 2/7] add support for the uring filter list
Date:   Mon, 01 Nov 2021 11:58:41 -0400
Message-ID: <2282661.ElGaqSPkdT@x2>
Organization: Red Hat
In-Reply-To: <20211101150549.GG1550715@madcap2.tricolour.ca>
References: <20211028195939.3102767-1-rgb@redhat.com> <2523658.Lt9SDvczpP@x2> <20211101150549.GG1550715@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Richard,

On Monday, November 1, 2021 11:05:49 AM EDT Richard Guy Briggs wrote:
> On 2021-10-29 14:39, Steve Grubb wrote:
> > On Thursday, October 28, 2021 3:59:34 PM EDT Richard Guy Briggs wrote:
> > > Kernel support to audit io_uring operations filtering was added with
> > > commit 67daf270cebc ("audit: add filtering for io_uring records").  Add
> > > support for the "uring" filter list to auditctl.
> > 
> > Might have been good to show what the resulting auditctl command looks
> > like. I think it would be:
> > 
> > auditctl -a always,io_uring  -U  open -F uid!=0 -F key=io_uring
> > 
> > But I wonder, why the choice of  -U rather than -S? That would make
> > remembering the syntax easier.
> > 
> > auditctl -a always,io_uring  -S  open -F uid!=0 -F key=io_uring
> 
> Well, I keep seeing the same what I assume is a typo in your
> communications about io_uring where the "u" is missing, which might help
> trigger your memory about the syntax.

Yeah, but I'm thinking that we can abstract that technicality away and keep 
the syntax the same.

> The io_uring operations name list is different than the syscall list, so
> it needs to use a different lookup table.

Right. So, if you choose an operation that is not supported, you get an 
error. But to help people know what is supported, we can add the lookup to 
ausyscall where  --io_uring could direct it to the right lookup table.

> Have I misunderstood something?

No, but I'm thinking of aesthetics and usability. You already have to specify 
a filter. We don't really need to have completely different syntax in 
addition. Especially since the operations map to the equivalent of a syscall.
 

> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > > docs/audit.rules.7         |  19 ++++--
> > > docs/audit_add_rule_data.3 |   4 ++
> > > docs/auditctl.8            |  10 ++-
> > > lib/flagtab.h              |  11 ++--
> > > lib/libaudit.c             |  50 ++++++++++++---
> > > lib/libaudit.h             |   7 +++
> > > lib/lookup_table.c         |  20 ++++++
> > > lib/private.h              |   1 +
> > > src/auditctl-listing.c     |  52 ++++++++++------
> > > src/auditctl.c             | 121 ++++++++++++++++++++++++++++++++-----
> > > 10 files changed, 240 insertions(+), 55 deletions(-)
> > 
> > <snip a whole lot of documentation>
> > 
> > > diff --git a/lib/libaudit.c b/lib/libaudit.c
> > > index 54e276156ef0..3790444f4497 100644
> > > --- a/lib/libaudit.c
> > > +++ b/lib/libaudit.c
> > > @@ -86,6 +86,7 @@ static const struct nv_list failure_actions[] =
> > > int _audit_permadded = 0;
> > > int _audit_archadded = 0;
> > > int _audit_syscalladded = 0;
> > > +int _audit_uringopadded = 0;
> > > int _audit_exeadded = 0;
> > > int _audit_filterfsadded = 0;
> > > unsigned int _audit_elf = 0U;
> > > @@ -999,6 +1000,26 @@ int audit_rule_syscallbyname_data(struct
> > > audit_rule_data *rule, return -1;
> > > }
> > > 
> > > +int audit_rule_uringopbyname_data(struct audit_rule_data *rule,
> > > +                                  const char *uringop)
> > > +{
> > > +       int nr, i;
> > > +
> > > +       if (!strcmp(uringop, "all")) {
> > > +               for (i = 0; i < AUDIT_BITMASK_SIZE; i++)
> > > +                       rule->mask[i] = ~0;
> > > +               return 0;
> > > +       }
> > > +       nr = audit_name_to_uringop(uringop);
> > > +       if (nr < 0) {
> > > +               if (isdigit(uringop[0]))
> > > +                       nr = strtol(uringop, NULL, 0);
> > > +       }
> > > +       if (nr >= 0)
> > > +               return audit_rule_syscall_data(rule, nr);
> > > +       return -1;
> > > +}
> > > +
> > > int audit_rule_interfield_comp_data(struct audit_rule_data **rulep,
> > > const char *pair,
> > > int flags)
> > > @@ -1044,7 +1065,7 @@ int audit_rule_interfield_comp_data(struct
> > > audit_rule_data **rulep, return -EAU_COMPVALUNKNOWN;
> > > 
> > > /* Interfield comparison can only be in exit filter */
> > > -       if (flags != AUDIT_FILTER_EXIT)
> > > +       if (flags != AUDIT_FILTER_EXIT && flags !=
> > > AUDIT_FILTER_URING_EXIT) return -EAU_EXITONLY;
> > > 
> > > // It should always be AUDIT_FIELD_COMPARE
> > > @@ -1557,7 +1578,8 @@ int audit_rule_fieldpair_data(struct
> > > audit_rule_data
> > > **rulep, const char *pair, }
> > > break;
> > > case AUDIT_EXIT:
> > > -                       if (flags != AUDIT_FILTER_EXIT)
> > > +                       if (flags != AUDIT_FILTER_EXIT &&
> > > +                           flags != AUDIT_FILTER_URING_EXIT)
> > > return -EAU_EXITONLY;
> > > vlen = strlen(v);
> > > if (isdigit((char)*(v)))
> > > @@ -1599,7 +1621,8 @@ int audit_rule_fieldpair_data(struct
> > > audit_rule_data
> > > **rulep, const char *pair, case AUDIT_DIR:
> > > /* Watch & object filtering is invalid on anything
> > > * but exit */
> > > -                       if (flags != AUDIT_FILTER_EXIT)
> > > +                       if (flags != AUDIT_FILTER_EXIT &&
> > > +                           flags != AUDIT_FILTER_URING_EXIT)
> > > return -EAU_EXITONLY;
> > > if (field == AUDIT_WATCH || field == AUDIT_DIR)
> > > _audit_permadded = 1;
> > > @@ -1621,9 +1644,11 @@ int audit_rule_fieldpair_data(struct
> > > audit_rule_data **rulep, const char *pair, _audit_exeadded = 1;
> > > }
> > > if (field == AUDIT_FILTERKEY &&
> > > -                               !(_audit_syscalladded ||
> > > _audit_permadded || -                               _audit_exeadded ||
> > > -                               _audit_filterfsadded))
> > > +                               !(_audit_syscalladded ||
> > > +                                 _audit_uringopadded ||
> > > +                                 _audit_permadded ||
> > > +                                 _audit_exeadded ||
> > > +                                 _audit_filterfsadded))
> > > return -EAU_KEYDEP;
> > > vlen = strlen(v);
> > > if (field == AUDIT_FILTERKEY &&
> > > @@ -1712,7 +1737,8 @@ int audit_rule_fieldpair_data(struct
> > > audit_rule_data
> > > **rulep, const char *pair, }
> > > break;
> > > case AUDIT_FILETYPE:
> > > -                       if (!(flags == AUDIT_FILTER_EXIT))
> > > +                       if (!(flags == AUDIT_FILTER_EXIT ||
> > > +                             flags == AUDIT_FILTER_URING_EXIT))
> > > return -EAU_EXITONLY;
> > > rule->values[rule->field_count] =
> > > audit_name_to_ftype(v);
> > > @@ -1754,7 +1780,8 @@ int audit_rule_fieldpair_data(struct
> > > audit_rule_data
> > > **rulep, const char *pair, return -EAU_FIELDNOSUPPORT;
> > > if (flags != AUDIT_FILTER_EXCLUDE &&
> > > flags != AUDIT_FILTER_USER &&
> > > -                           flags != AUDIT_FILTER_EXIT)
> > > +                           flags != AUDIT_FILTER_EXIT &&
> > > +                           flags != AUDIT_FILTER_URING_EXIT)
> > 
> > This is in the session_id code. Looking at the example audit event:
> > 
> > https://listman.redhat.com/archives/linux-audit/2021-September/msg00058.h
> > tml
> > 
> > session_id is not in the record.
> 
> Fair enough.  It can be re-added if we are able to reliably report it.

Thanks.

> > > return -EAU_FIELDNOFILTER;
> > > // Do positive & negative separate for 32 bit systems
> > > vlen = strlen(v);
> > > @@ -1775,7 +1802,8 @@ int audit_rule_fieldpair_data(struct
> > > audit_rule_data
> > > **rulep, const char *pair, break;
> > 
> > > case AUDIT_DEVMAJOR...AUDIT_INODE:
> > ^^^ Can you audit by devmajor, devminor, or inode in io_ring?
> 
> Should be able to monitor files.  The old "-w" syntax is not supported
> but path= and dir= should be.

But that's not what this is. These is for:
 -F dev_major=
 -F dev_minor=
 -F inode=

It dates back to before watches were possible. In any event, this is being 
allowed when I suspect it shouldn't.

-Steve




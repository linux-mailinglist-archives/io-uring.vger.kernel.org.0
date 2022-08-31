Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0BF05A823D
	for <lists+io-uring@lfdr.de>; Wed, 31 Aug 2022 17:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbiHaPv0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 Aug 2022 11:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbiHaPvZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 Aug 2022 11:51:25 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329AFA2DA6
        for <io-uring@vger.kernel.org>; Wed, 31 Aug 2022 08:51:22 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-3413ad0640dso155906977b3.13
        for <io-uring@vger.kernel.org>; Wed, 31 Aug 2022 08:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=3PvMR/XycqORFlizT6CxByuKDuIxggxJlBTQLJTuWPk=;
        b=Gmi2UWcvzrmJ8zqM8a6qsIyzbaP0psVzRrmiTQDUFQ+boYUpfinXOhH3kKBy2TxbXZ
         ygeIkKnogCEEVHtGen8PFLpJpXJGU25o+NTwvzI5jnj72uy5Cjchmk9EqNZ81045MM9h
         yDzJSkpnZyziYqR1UQHXQzYV+X7WIdCFOpC8nEcu7lVMc9hTpLbs9tE+UmhjTrN9guKQ
         3p6amlVDRlBQ5pch2LYuRNd6kUSpn4yqk5Fz4R7rna8xmxeC2DA0L1p+VaF6BXU7aFkO
         GgWG+nRtC8kNNs87CPZsk886FgCnJcaZKKpO+18aXX3VN29LAEX04NpAfjzZUKRWKsQN
         tnsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=3PvMR/XycqORFlizT6CxByuKDuIxggxJlBTQLJTuWPk=;
        b=tLVKMlNBmaI15toV/3bMlxCanA2JCBNrimjb35rXZHZKBadayNsAPNC2hSMf0lLvbd
         WmSSQApk0lzlB/qIWLqQwIiu/dc5Bb9UGP10EcV/VcHLvUvA+ncXcI/vnrMAwNimnrzy
         nJ1CIF2jAFvbICxAk6wNBWtqAkxsXKEHVm67QOJDLfZ5IhIYcg3Sxzt4TLfWBgVQy3vD
         jhoKU1hRAJ01yA4Mz29KIdBDFWTvCpkMcCMFfIGbr9ZxyvS3lmtwGM5zpoQOTjJgptBi
         0NoS4nu4dKHo+c1iOMlpmew/5dWagCTITYEn/6LquQimRlOLcYITqeHEp9ucru3f9ffA
         731w==
X-Gm-Message-State: ACgBeo1xpv8ng/N9Ggqdx9fTAxIbewKNv3SzS3q/wAaJtpPQGztMfZw4
        uym0kso/B4kR8/ctYGceLGUNgrIvcS69QAFbvBzwFg==
X-Google-Smtp-Source: AA6agR4/rLQr0otczemJmDvQiUx5/CSiDqYtOQdmANq0z9zivATwFqNAF4tlP4F5nNTDABcpDpeH4KIX3SY4Iha+WMk=
X-Received: by 2002:a0d:cd02:0:b0:341:a401:4630 with SMTP id
 p2-20020a0dcd02000000b00341a4014630mr4588576ywd.293.1661961081082; Wed, 31
 Aug 2022 08:51:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com> <20220830214919.53220-23-surenb@google.com>
 <CACT4Y+ZX3U1=cAPXPhoOy6xrngSCfSmyFagXK-9fWtWWODfsew@mail.gmail.com>
In-Reply-To: <CACT4Y+ZX3U1=cAPXPhoOy6xrngSCfSmyFagXK-9fWtWWODfsew@mail.gmail.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Wed, 31 Aug 2022 08:51:10 -0700
Message-ID: <CAJuCfpEQJe7HiNXhv+fH3auvr_-M6VpxhgWTj9q6e5GLkd+8Uw@mail.gmail.com>
Subject: Re: [RFC PATCH 22/30] Code tagging based fault injection
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Mel Gorman <mgorman@suse.de>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <liam.howlett@oracle.com>,
        David Vernet <void@manifault.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, mcgrof@kernel.org,
        masahiroy@kernel.org, nathan@kernel.org, changbin.du@intel.com,
        ytcoode@gmail.com, Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Benjamin Segall <bsegall@google.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Christopher Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, 42.hyeyoo@gmail.com,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>, arnd@arndb.de,
        jbaron@akamai.com, David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan@google.com>,
        Kalesh Singh <kaleshsingh@google.com>,
        kernel-team <kernel-team@android.com>,
        linux-mm <linux-mm@kvack.org>, iommu@lists.linux.dev,
        kasan-dev@googlegroups.com, io-uring@vger.kernel.org,
        linux-arch@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-bcache@vger.kernel.org, linux-modules@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 31, 2022 at 3:37 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Tue, 30 Aug 2022 at 23:50, Suren Baghdasaryan <surenb@google.com> wrote:
> >
> > From: Kent Overstreet <kent.overstreet@linux.dev>
> >
> > This adds a new fault injection capability, based on code tagging.
> >
> > To use, simply insert somewhere in your code
> >
> >   dynamic_fault("fault_class_name")
> >
> > and check whether it returns true - if so, inject the error.
> > For example
> >
> >   if (dynamic_fault("init"))
> >       return -EINVAL;
>
> Hi Suren,
>
> If this is going to be used by mainline kernel, it would be good to
> integrate this with fail_nth systematic fault injection:
> https://elixir.bootlin.com/linux/latest/source/lib/fault-inject.c#L109
>
> Otherwise these dynamic sites won't be tested by testing systems doing
> systematic fault injection testing.

Hi Dmitry,
Thanks for the information! Will look into it and try to integrate.
Suren.

>
>
> > There's no need to define faults elsewhere, as with
> > include/linux/fault-injection.h. Faults show up in debugfs, under
> > /sys/kernel/debug/dynamic_faults, and can be selected based on
> > file/module/function/line number/class, and enabled permanently, or in
> > oneshot mode, or with a specified frequency.
> >
> > Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> > ---
> >  include/asm-generic/codetag.lds.h |   3 +-
> >  include/linux/dynamic_fault.h     |  79 +++++++
> >  include/linux/slab.h              |   3 +-
> >  lib/Kconfig.debug                 |   6 +
> >  lib/Makefile                      |   2 +
> >  lib/dynamic_fault.c               | 372 ++++++++++++++++++++++++++++++
> >  6 files changed, 463 insertions(+), 2 deletions(-)
> >  create mode 100644 include/linux/dynamic_fault.h
> >  create mode 100644 lib/dynamic_fault.c
> >
> > diff --git a/include/asm-generic/codetag.lds.h b/include/asm-generic/codetag.lds.h
> > index 64f536b80380..16fbf74edc3d 100644
> > --- a/include/asm-generic/codetag.lds.h
> > +++ b/include/asm-generic/codetag.lds.h
> > @@ -9,6 +9,7 @@
> >         __stop_##_name = .;
> >
> >  #define CODETAG_SECTIONS()             \
> > -       SECTION_WITH_BOUNDARIES(alloc_tags)
> > +       SECTION_WITH_BOUNDARIES(alloc_tags)             \
> > +       SECTION_WITH_BOUNDARIES(dynamic_fault_tags)
> >
> >  #endif /* __ASM_GENERIC_CODETAG_LDS_H */
> > diff --git a/include/linux/dynamic_fault.h b/include/linux/dynamic_fault.h
> > new file mode 100644
> > index 000000000000..526a33209e94
> > --- /dev/null
> > +++ b/include/linux/dynamic_fault.h
> > @@ -0,0 +1,79 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +
> > +#ifndef _LINUX_DYNAMIC_FAULT_H
> > +#define _LINUX_DYNAMIC_FAULT_H
> > +
> > +/*
> > + * Dynamic/code tagging fault injection:
> > + *
> > + * Originally based on the dynamic debug trick of putting types in a special elf
> > + * section, then rewritten using code tagging:
> > + *
> > + * To use, simply insert a call to dynamic_fault("fault_class"), which will
> > + * return true if an error should be injected.
> > + *
> > + * Fault injection sites may be listed and enabled via debugfs, under
> > + * /sys/kernel/debug/dynamic_faults.
> > + */
> > +
> > +#ifdef CONFIG_CODETAG_FAULT_INJECTION
> > +
> > +#include <linux/codetag.h>
> > +#include <linux/jump_label.h>
> > +
> > +#define DFAULT_STATES()                \
> > +       x(disabled)             \
> > +       x(enabled)              \
> > +       x(oneshot)
> > +
> > +enum dfault_enabled {
> > +#define x(n)   DFAULT_##n,
> > +       DFAULT_STATES()
> > +#undef x
> > +};
> > +
> > +union dfault_state {
> > +       struct {
> > +               unsigned int            enabled:2;
> > +               unsigned int            count:30;
> > +       };
> > +
> > +       struct {
> > +               unsigned int            v;
> > +       };
> > +};
> > +
> > +struct dfault {
> > +       struct codetag          tag;
> > +       const char              *class;
> > +       unsigned int            frequency;
> > +       union dfault_state      state;
> > +       struct static_key_false enabled;
> > +};
> > +
> > +bool __dynamic_fault_enabled(struct dfault *df);
> > +
> > +#define dynamic_fault(_class)                          \
> > +({                                                     \
> > +       static struct dfault                            \
> > +       __used                                          \
> > +       __section("dynamic_fault_tags")                 \
> > +       __aligned(8) df = {                             \
> > +               .tag    = CODE_TAG_INIT,                \
> > +               .class  = _class,                       \
> > +               .enabled = STATIC_KEY_FALSE_INIT,       \
> > +       };                                              \
> > +                                                       \
> > +       static_key_false(&df.enabled.key) &&            \
> > +               __dynamic_fault_enabled(&df);           \
> > +})
> > +
> > +#else
> > +
> > +#define dynamic_fault(_class)  false
> > +
> > +#endif /* CODETAG_FAULT_INJECTION */
> > +
> > +#define memory_fault()         dynamic_fault("memory")
> > +
> > +#endif /* _LINUX_DYNAMIC_FAULT_H */
> > diff --git a/include/linux/slab.h b/include/linux/slab.h
> > index 89273be35743..4be5a93ed15a 100644
> > --- a/include/linux/slab.h
> > +++ b/include/linux/slab.h
> > @@ -17,6 +17,7 @@
> >  #include <linux/types.h>
> >  #include <linux/workqueue.h>
> >  #include <linux/percpu-refcount.h>
> > +#include <linux/dynamic_fault.h>
> >
> >
> >  /*
> > @@ -468,7 +469,7 @@ static inline void slab_tag_dec(const void *ptr) {}
> >
> >  #define krealloc_hooks(_p, _do_alloc)                                  \
> >  ({                                                                     \
> > -       void *_res = _do_alloc;                                         \
> > +       void *_res = !memory_fault() ? _do_alloc : NULL;                \
> >         slab_tag_add(_p, _res);                                         \
> >         _res;                                                           \
> >  })
> > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > index 2790848464f1..b7d03afbc808 100644
> > --- a/lib/Kconfig.debug
> > +++ b/lib/Kconfig.debug
> > @@ -1982,6 +1982,12 @@ config FAULT_INJECTION_STACKTRACE_FILTER
> >         help
> >           Provide stacktrace filter for fault-injection capabilities
> >
> > +config CODETAG_FAULT_INJECTION
> > +       bool "Code tagging based fault injection"
> > +       select CODE_TAGGING
> > +       help
> > +         Dynamic fault injection based on code tagging
> > +
> >  config ARCH_HAS_KCOV
> >         bool
> >         help
> > diff --git a/lib/Makefile b/lib/Makefile
> > index 99f732156673..489ea000c528 100644
> > --- a/lib/Makefile
> > +++ b/lib/Makefile
> > @@ -231,6 +231,8 @@ obj-$(CONFIG_CODE_TAGGING) += codetag.o
> >  obj-$(CONFIG_ALLOC_TAGGING) += alloc_tag.o
> >  obj-$(CONFIG_PAGE_ALLOC_TAGGING) += pgalloc_tag.o
> >
> > +obj-$(CONFIG_CODETAG_FAULT_INJECTION) += dynamic_fault.o
> > +
> >  lib-$(CONFIG_GENERIC_BUG) += bug.o
> >
> >  obj-$(CONFIG_HAVE_ARCH_TRACEHOOK) += syscall.o
> > diff --git a/lib/dynamic_fault.c b/lib/dynamic_fault.c
> > new file mode 100644
> > index 000000000000..4c9cd18686be
> > --- /dev/null
> > +++ b/lib/dynamic_fault.c
> > @@ -0,0 +1,372 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +
> > +#include <linux/ctype.h>
> > +#include <linux/debugfs.h>
> > +#include <linux/dynamic_fault.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/seq_buf.h>
> > +
> > +static struct codetag_type *cttype;
> > +
> > +bool __dynamic_fault_enabled(struct dfault *df)
> > +{
> > +       union dfault_state old, new;
> > +       unsigned int v = df->state.v;
> > +       bool ret;
> > +
> > +       do {
> > +               old.v = new.v = v;
> > +
> > +               if (new.enabled == DFAULT_disabled)
> > +                       return false;
> > +
> > +               ret = df->frequency
> > +                       ? ++new.count >= df->frequency
> > +                       : true;
> > +               if (ret)
> > +                       new.count = 0;
> > +               if (ret && new.enabled == DFAULT_oneshot)
> > +                       new.enabled = DFAULT_disabled;
> > +       } while ((v = cmpxchg(&df->state.v, old.v, new.v)) != old.v);
> > +
> > +       if (ret)
> > +               pr_debug("returned true for %s:%u", df->tag.filename, df->tag.lineno);
> > +
> > +       return ret;
> > +}
> > +EXPORT_SYMBOL(__dynamic_fault_enabled);
> > +
> > +static const char * const dfault_state_strs[] = {
> > +#define x(n)   #n,
> > +       DFAULT_STATES()
> > +#undef x
> > +       NULL
> > +};
> > +
> > +static void dynamic_fault_to_text(struct seq_buf *out, struct dfault *df)
> > +{
> > +       codetag_to_text(out, &df->tag);
> > +       seq_buf_printf(out, "class:%s %s \"", df->class,
> > +                      dfault_state_strs[df->state.enabled]);
> > +}
> > +
> > +struct dfault_query {
> > +       struct codetag_query q;
> > +
> > +       bool            set_enabled:1;
> > +       unsigned int    enabled:2;
> > +
> > +       bool            set_frequency:1;
> > +       unsigned int    frequency;
> > +};
> > +
> > +/*
> > + * Search the tables for _dfault's which match the given
> > + * `query' and apply the `flags' and `mask' to them.  Tells
> > + * the user which dfault's were changed, or whether none
> > + * were matched.
> > + */
> > +static int dfault_change(struct dfault_query *query)
> > +{
> > +       struct codetag_iterator ct_iter;
> > +       struct codetag *ct;
> > +       unsigned int nfound = 0;
> > +
> > +       codetag_lock_module_list(cttype, true);
> > +       codetag_init_iter(&ct_iter, cttype);
> > +
> > +       while ((ct = codetag_next_ct(&ct_iter))) {
> > +               struct dfault *df = container_of(ct, struct dfault, tag);
> > +
> > +               if (!codetag_matches_query(&query->q, ct, ct_iter.cmod, df->class))
> > +                       continue;
> > +
> > +               if (query->set_enabled &&
> > +                   query->enabled != df->state.enabled) {
> > +                       if (query->enabled != DFAULT_disabled)
> > +                               static_key_slow_inc(&df->enabled.key);
> > +                       else if (df->state.enabled != DFAULT_disabled)
> > +                               static_key_slow_dec(&df->enabled.key);
> > +
> > +                       df->state.enabled = query->enabled;
> > +               }
> > +
> > +               if (query->set_frequency)
> > +                       df->frequency = query->frequency;
> > +
> > +               pr_debug("changed %s:%d [%s]%s #%d %s",
> > +                        df->tag.filename, df->tag.lineno, df->tag.modname,
> > +                        df->tag.function, query->q.cur_index,
> > +                        dfault_state_strs[df->state.enabled]);
> > +
> > +               nfound++;
> > +       }
> > +
> > +       pr_debug("dfault: %u matches", nfound);
> > +
> > +       codetag_lock_module_list(cttype, false);
> > +
> > +       return nfound ? 0 : -ENOENT;
> > +}
> > +
> > +#define DFAULT_TOKENS()                \
> > +       x(disable,      0)      \
> > +       x(enable,       0)      \
> > +       x(oneshot,      0)      \
> > +       x(frequency,    1)
> > +
> > +enum dfault_token {
> > +#define x(name, nr_args)       TOK_##name,
> > +       DFAULT_TOKENS()
> > +#undef x
> > +};
> > +
> > +static const char * const dfault_token_strs[] = {
> > +#define x(name, nr_args)       #name,
> > +       DFAULT_TOKENS()
> > +#undef x
> > +       NULL
> > +};
> > +
> > +static unsigned int dfault_token_nr_args[] = {
> > +#define x(name, nr_args)       nr_args,
> > +       DFAULT_TOKENS()
> > +#undef x
> > +};
> > +
> > +static enum dfault_token str_to_token(const char *word, unsigned int nr_words)
> > +{
> > +       int tok = match_string(dfault_token_strs, ARRAY_SIZE(dfault_token_strs), word);
> > +
> > +       if (tok < 0) {
> > +               pr_debug("unknown keyword \"%s\"", word);
> > +               return tok;
> > +       }
> > +
> > +       if (nr_words < dfault_token_nr_args[tok]) {
> > +               pr_debug("insufficient arguments to \"%s\"", word);
> > +               return -EINVAL;
> > +       }
> > +
> > +       return tok;
> > +}
> > +
> > +static int dfault_parse_command(struct dfault_query *query,
> > +                               enum dfault_token tok,
> > +                               char *words[], size_t nr_words)
> > +{
> > +       unsigned int i = 0;
> > +       int ret;
> > +
> > +       switch (tok) {
> > +       case TOK_disable:
> > +               query->set_enabled = true;
> > +               query->enabled = DFAULT_disabled;
> > +               break;
> > +       case TOK_enable:
> > +               query->set_enabled = true;
> > +               query->enabled = DFAULT_enabled;
> > +               break;
> > +       case TOK_oneshot:
> > +               query->set_enabled = true;
> > +               query->enabled = DFAULT_oneshot;
> > +               break;
> > +       case TOK_frequency:
> > +               query->set_frequency = 1;
> > +               ret = kstrtouint(words[i++], 10, &query->frequency);
> > +               if (ret)
> > +                       return ret;
> > +
> > +               if (!query->set_enabled) {
> > +                       query->set_enabled = 1;
> > +                       query->enabled = DFAULT_enabled;
> > +               }
> > +               break;
> > +       }
> > +
> > +       return i;
> > +}
> > +
> > +static int dynamic_fault_store(char *buf)
> > +{
> > +       struct dfault_query query = { NULL };
> > +#define MAXWORDS 9
> > +       char *tok, *words[MAXWORDS];
> > +       int ret, nr_words, i = 0;
> > +
> > +       buf = codetag_query_parse(&query.q, buf);
> > +       if (IS_ERR(buf))
> > +               return PTR_ERR(buf);
> > +
> > +       while ((tok = strsep_no_empty(&buf, " \t\r\n"))) {
> > +               if (nr_words == ARRAY_SIZE(words))
> > +                       return -EINVAL; /* ran out of words[] before bytes */
> > +               words[nr_words++] = tok;
> > +       }
> > +
> > +       while (i < nr_words) {
> > +               const char *tok_str = words[i++];
> > +               enum dfault_token tok = str_to_token(tok_str, nr_words - i);
> > +
> > +               if (tok < 0)
> > +                       return tok;
> > +
> > +               ret = dfault_parse_command(&query, tok, words + i, nr_words - i);
> > +               if (ret < 0)
> > +                       return ret;
> > +
> > +               i += ret;
> > +               BUG_ON(i > nr_words);
> > +       }
> > +
> > +       pr_debug("q->function=\"%s\" q->filename=\"%s\" "
> > +                "q->module=\"%s\" q->line=%u-%u\n q->index=%u-%u",
> > +                query.q.function, query.q.filename, query.q.module,
> > +                query.q.first_line, query.q.last_line,
> > +                query.q.first_index, query.q.last_index);
> > +
> > +       ret = dfault_change(&query);
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       return 0;
> > +}
> > +
> > +struct dfault_iter {
> > +       struct codetag_iterator ct_iter;
> > +
> > +       struct seq_buf          buf;
> > +       char                    rawbuf[4096];
> > +};
> > +
> > +static int dfault_open(struct inode *inode, struct file *file)
> > +{
> > +       struct dfault_iter *iter;
> > +
> > +       iter = kzalloc(sizeof(*iter), GFP_KERNEL);
> > +       if (!iter)
> > +               return -ENOMEM;
> > +
> > +       codetag_lock_module_list(cttype, true);
> > +       codetag_init_iter(&iter->ct_iter, cttype);
> > +       codetag_lock_module_list(cttype, false);
> > +
> > +       file->private_data = iter;
> > +       seq_buf_init(&iter->buf, iter->rawbuf, sizeof(iter->rawbuf));
> > +       return 0;
> > +}
> > +
> > +static int dfault_release(struct inode *inode, struct file *file)
> > +{
> > +       struct dfault_iter *iter = file->private_data;
> > +
> > +       kfree(iter);
> > +       return 0;
> > +}
> > +
> > +struct user_buf {
> > +       char __user             *buf;   /* destination user buffer */
> > +       size_t                  size;   /* size of requested read */
> > +       ssize_t                 ret;    /* bytes read so far */
> > +};
> > +
> > +static int flush_ubuf(struct user_buf *dst, struct seq_buf *src)
> > +{
> > +       if (src->len) {
> > +               size_t bytes = min_t(size_t, src->len, dst->size);
> > +               int err = copy_to_user(dst->buf, src->buffer, bytes);
> > +
> > +               if (err)
> > +                       return err;
> > +
> > +               dst->ret        += bytes;
> > +               dst->buf        += bytes;
> > +               dst->size       -= bytes;
> > +               src->len        -= bytes;
> > +               memmove(src->buffer, src->buffer + bytes, src->len);
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static ssize_t dfault_read(struct file *file, char __user *ubuf,
> > +                          size_t size, loff_t *ppos)
> > +{
> > +       struct dfault_iter *iter = file->private_data;
> > +       struct user_buf buf = { .buf = ubuf, .size = size };
> > +       struct codetag *ct;
> > +       struct dfault *df;
> > +       int err;
> > +
> > +       codetag_lock_module_list(iter->ct_iter.cttype, true);
> > +       while (1) {
> > +               err = flush_ubuf(&buf, &iter->buf);
> > +               if (err || !buf.size)
> > +                       break;
> > +
> > +               ct = codetag_next_ct(&iter->ct_iter);
> > +               if (!ct)
> > +                       break;
> > +
> > +               df = container_of(ct, struct dfault, tag);
> > +               dynamic_fault_to_text(&iter->buf, df);
> > +               seq_buf_putc(&iter->buf, '\n');
> > +       }
> > +       codetag_lock_module_list(iter->ct_iter.cttype, false);
> > +
> > +       return err ?: buf.ret;
> > +}
> > +
> > +/*
> > + * File_ops->write method for <debugfs>/dynamic_fault/conrol.  Gathers the
> > + * command text from userspace, parses and executes it.
> > + */
> > +static ssize_t dfault_write(struct file *file, const char __user *ubuf,
> > +                           size_t len, loff_t *offp)
> > +{
> > +       char tmpbuf[256];
> > +
> > +       if (len == 0)
> > +               return 0;
> > +       /* we don't check *offp -- multiple writes() are allowed */
> > +       if (len > sizeof(tmpbuf)-1)
> > +               return -E2BIG;
> > +       if (copy_from_user(tmpbuf, ubuf, len))
> > +               return -EFAULT;
> > +       tmpbuf[len] = '\0';
> > +       pr_debug("read %zu bytes from userspace", len);
> > +
> > +       dynamic_fault_store(tmpbuf);
> > +
> > +       *offp += len;
> > +       return len;
> > +}
> > +
> > +static const struct file_operations dfault_ops = {
> > +       .owner  = THIS_MODULE,
> > +       .open   = dfault_open,
> > +       .release = dfault_release,
> > +       .read   = dfault_read,
> > +       .write  = dfault_write
> > +};
> > +
> > +static int __init dynamic_fault_init(void)
> > +{
> > +       const struct codetag_type_desc desc = {
> > +               .section = "dynamic_fault_tags",
> > +               .tag_size = sizeof(struct dfault),
> > +       };
> > +       struct dentry *debugfs_file;
> > +
> > +       cttype = codetag_register_type(&desc);
> > +       if (IS_ERR_OR_NULL(cttype))
> > +               return PTR_ERR(cttype);
> > +
> > +       debugfs_file = debugfs_create_file("dynamic_faults", 0666, NULL, NULL, &dfault_ops);
> > +       if (IS_ERR(debugfs_file))
> > +               return PTR_ERR(debugfs_file);
> > +
> > +       return 0;
> > +}
> > +module_init(dynamic_fault_init);
> > --
> > 2.37.2.672.g94769d06f0-goog
> >

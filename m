Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 306FD5A924B
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 10:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbiIAInp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 04:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234263AbiIAIno (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 04:43:44 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7F81314D9
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 01:43:40 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id bn9so17124339ljb.6
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 01:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=VH72CkJdWHRYjuIFqG3YYZtTrJw2Fhi5jnFxkucPCHY=;
        b=q7AjWjhmnd64a4Ge80aSMXzM40DYISK3cXmW/EibDBVwJ+8k/kXbGydZOb9luK+PIZ
         Ht/KjsMCWD5TF/twQCHm6itfvd6g64oIsvl5c5eKge4E9VhNnF7iOxqToHuyozIfoFb1
         5I88bd1UfHObAquK0acXH+XbI6Py13HNPo09dD+NGiTxpVgIr43RQcU5305AlaqKPpll
         qwKybw5Q2+9d/Onlv8u1vDEdJlLQ1JUMSCRevC4eAiHePyL2wzZzh3KSvr/OLrTmD05T
         eLyu3SeubEOLjLKn16wG4v4TsahkBmU2CrHwp0/PiiByarcOmjtEcsv6KWve7EKHFu99
         DiuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=VH72CkJdWHRYjuIFqG3YYZtTrJw2Fhi5jnFxkucPCHY=;
        b=31M6ho9c8LGdO2CU4yi8swr/NqKkc7N5o+FXyUTZgEnUmjJj4BTDUUeogD/cSfVhh9
         v5k/ze6oej1PKE08H07uXLjML43g0YrzBo67i4dIjVy44RHzal2NvBMN20AepC4Y2yQR
         lzVjVlziJBYDYdLAinquOTtIW1QADxGN8ouL4d+/ZHkZ1UIUdfqDn9C6uxZ+9XD+4K/M
         Kz12Xuz9mzEcYTuwSu5tCF2xpLsG81XjuigYPq5m04IZfAWZ2VEPeFroZjrIjjf/h9Ub
         2P9hNYY7yasDZLI+9yRYp50gPjW0tc656gcz1YLTOLKQqKdgYqx1+60SFQP9LlDfu+UZ
         koEQ==
X-Gm-Message-State: ACgBeo2iGDmuRMwIV7vHve+YDfkrWIIXp2lsfjiO0kXQu300uqIbmi9x
        71UhZMssCUIW1eRl+mw1bFwnNSZgKqoMfJ+qSBpN+w==
X-Google-Smtp-Source: AA6agR4BjD3DwjS+CZ4CCVxEVQ6+miy/r1+fo/IQYDRJogJb7LowD/eAhVezdlkQzk6xOh63IrvI7g9qP1YqXlNutus=
X-Received: by 2002:a2e:be88:0:b0:25f:e9a8:44b8 with SMTP id
 a8-20020a2ebe88000000b0025fe9a844b8mr8851946ljr.92.1662021818766; Thu, 01 Sep
 2022 01:43:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com> <20220830214919.53220-23-surenb@google.com>
 <CACT4Y+ZX3U1=cAPXPhoOy6xrngSCfSmyFagXK-9fWtWWODfsew@mail.gmail.com> <20220831173010.wc5j3ycmfjx6ezfu@moria.home.lan>
In-Reply-To: <20220831173010.wc5j3ycmfjx6ezfu@moria.home.lan>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 1 Sep 2022 10:43:26 +0200
Message-ID: <CACT4Y+bMeqvWQwqzG3nfcf0-VOjU7usxht5mKgUwMcOpWKRjxQ@mail.gmail.com>
Subject: Re: [RFC PATCH 22/30] Code tagging based fault injection
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org,
        mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org,
        roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net,
        willy@infradead.org, liam.howlett@oracle.com, void@manifault.com,
        peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com,
        peterx@redhat.com, david@redhat.com, axboe@kernel.dk,
        mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org,
        changbin.du@intel.com, ytcoode@gmail.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, bristot@redhat.com,
        vschneid@redhat.com, cl@linux.com, penberg@kernel.org,
        iamjoonsoo.kim@lge.com, 42.hyeyoo@gmail.com, glider@google.com,
        elver@google.com, shakeelb@google.com, songmuchun@bytedance.com,
        arnd@arndb.de, jbaron@akamai.com, rientjes@google.com,
        minchan@google.com, kaleshsingh@google.com,
        kernel-team@android.com, linux-mm@kvack.org, iommu@lists.linux.dev,
        kasan-dev@googlegroups.com, io-uring@vger.kernel.org,
        linux-arch@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-bcache@vger.kernel.org, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

 On Wed, 31 Aug 2022 at 19:30, Kent Overstreet
<kent.overstreet@linux.dev> wrote:
> > > From: Kent Overstreet <kent.overstreet@linux.dev>
> > >
> > > This adds a new fault injection capability, based on code tagging.
> > >
> > > To use, simply insert somewhere in your code
> > >
> > >   dynamic_fault("fault_class_name")
> > >
> > > and check whether it returns true - if so, inject the error.
> > > For example
> > >
> > >   if (dynamic_fault("init"))
> > >       return -EINVAL;
> >
> > Hi Suren,
> >
> > If this is going to be used by mainline kernel, it would be good to
> > integrate this with fail_nth systematic fault injection:
> > https://elixir.bootlin.com/linux/latest/source/lib/fault-inject.c#L109
> >
> > Otherwise these dynamic sites won't be tested by testing systems doing
> > systematic fault injection testing.
>
> That's a discussion we need to have, yeah. We don't want two distinct fault
> injection frameworks, we'll have to have a discussion as to whether this is (or
> can be) better enough to make a switch worthwhile, and whether a compatibility
> interface is needed - or maybe there's enough distinct interesting bits in both
> to make merging plausible?
>
> The debugfs interface for this fault injection code is necessarily different
> from our existing fault injection - this gives you a fault injection point _per
> callsite_, which is huge - e.g. for filesystem testing what I need is to be able
> to enable fault injection points within a given module. I can do that easily
> with this, not with our current fault injection.
>
> I think the per-callsite fault injection points would also be pretty valuable
> for CONFIG_FAULT_INJECTION_USERCOPY, too.
>
> OTOH, existing kernel fault injection can filter based on task - this fault
> injection framework doesn't have that. Easy enough to add, though. Similar for
> the interval/probability/ratelimit stuff.
>
> fail_function is the odd one out, I'm not sure how that would fit into this
> model. Everything else I've seen I think fits into this model.
>
> Also, it sounds like you're more familiar with our existing fault injection than
> I am, so if I've misunderstood anything about what it can do please do correct
> me.

What you are saying makes sense. But I can't say if we want to do a
global switch or not. I don't know how many existing users there are
(by users I mean automated testing b/c humans can switch for one-off
manual testing).

However, fail_nth that I mentioned is orthogonal to this. It's a
different mechanism to select the fault site that needs to be failed
(similar to what you mentioned as "interval/probability/ratelimit
stuff"). fail_nth allows to fail the specified n-th call site in the
specified task. And that's the only mechanism we use in
syzkaller/syzbot.
And I think it can be supported relatively easily (copy a few lines to
the "does this site needs to fail" check).

I don't know how exactly you want to use this new mechanism, but I
found fail_nth much better than any of the existing selection
mechanisms, including what this will add for specific site failing.

fail_nth allows to fail every site in a given test/syscall one-by-one
systematically. E.g. we can even have strace-like utility that repeats
the given test failing all sites in to systematically:
$ fail_all ./a_unit_test
This can be integrated into any CI system, e.g. running all LTP tests with this.

For file:line-based selection, first, we need to get these file:line
from somewhere; second, lines are changing over time so can't be
hardcoded in tests; third, it still needs to be per-task, since
unrelated processes can execute the same code.

One downside of fail_nth, though, is that it does not cover background
threads/async work. But we found that there are so many untested
synchronous error paths, that moving to background threads is not
necessary at this point.



> Interestingly: I just discovered from reading the code that
> CONFIG_FAULT_INJECTION_STACKTRACE_FILTER is a thing (hadn't before because it
> depends on !X86_64 - what?). That's cool, though.

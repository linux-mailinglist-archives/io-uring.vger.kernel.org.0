Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED5475AD8D8
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 20:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiIESIw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 14:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbiIESIf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 14:08:35 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67863606AE
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 11:08:33 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id m16so1932043ilg.3
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 11:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=hbTvjCqXtfZwCNAPDugxhLvbO4tPW4uXsytclFMPf88=;
        b=BWl6tEU0Jv/5Ok7izOy2X+2XFHIjW2yJwE8yMIwADusWnEOeQC8si1U6iks3IFTXtR
         5tbbeyYCmyTiKFNMcU3D2cV+gb/s5ohOcUII9kU6FU7ji/Zh8BrlwKsCQaRcerXV6BGZ
         8PlGGmZZYHPvdH+WgSsyR10w9r/j2bW/3D0lAGkx1tIn87fB5RB3pcjDyqMnvPGCsyas
         uH/yoycyrf5kaO5p9L7J37V/vDYJvxKCrEBpA8AorAMThecIv/vXA5VLdyTk9mhWPhlm
         xhk4J8Awk+fBDhqAh5Kc3xuDELqvWV7xGoRQ08TJNeQzRqgNOVW6ruxsZF0Lyj7+Dw3B
         m0Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=hbTvjCqXtfZwCNAPDugxhLvbO4tPW4uXsytclFMPf88=;
        b=sEuyeeu7UlS03xqlFcyRQL6qP7V9rOJxzC63O/NuzGfqA+rNE2c1HI0iOgCl2R9nuP
         0y6VsSITGeWMKGULjdacCbLzA+k66ty2j0XI6ELEc1X89+YTfoBxH9Pt4nU+cCuX5Jmm
         qHK8/SoIfKyz/qZ9JxH0gX2rRKFJyRaVMyeUgcJi4spuqmN3gVVGzwnA6u9+7M43AO1i
         EhZNT92M8ew46jLxwIraPfL0Ps7sLMMX3+CJ5/oxOCV9fS8sgoGlCS/ZI9sgMHS1Mo/M
         UnbACfcBeJMK9fqP7iCtuGoAfNzpnk6z+DXk9nOwnHKsJokKd7QgLyCP9UbY2vrmOZuF
         zviQ==
X-Gm-Message-State: ACgBeo1Ry5axlUhz5fKanN2OJUqwR0a402UzQ+tKmgWbxd4Fb7a4Rwvg
        GpdSDIahJf4/OUzsmTYb04C2ASPB1sCUcy3D/XDBnQ==
X-Google-Smtp-Source: AA6agR4Rv/lC85vS43o4ySf3NvmJunla0lbszDaoWXhv+p4vulk9P6WBBoE0T5B+Wry+ZoXPm1CE94n4VZxipIKzyxQ=
X-Received: by 2002:a92:ca06:0:b0:2eb:391a:a2a4 with SMTP id
 j6-20020a92ca06000000b002eb391aa2a4mr16719486ils.199.1662401312639; Mon, 05
 Sep 2022 11:08:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com> <Yw8P8xZ4zqu121xL@hirez.programming.kicks-ass.net>
 <20220831084230.3ti3vitrzhzsu3fs@moria.home.lan> <20220831101948.f3etturccmp5ovkl@suse.de>
 <Yw88RFuBgc7yFYxA@dhcp22.suse.cz> <20220831190154.qdlsxfamans3ya5j@moria.home.lan>
 <YxBc1xuGbB36f8zC@dhcp22.suse.cz> <CAJuCfpGhwPFYdkOLjwwD4ra9JxPqq1T5d1jd41Jy3LJnVnhNdg@mail.gmail.com>
 <YxEE1vOwRPdzKxoq@dhcp22.suse.cz> <CAJuCfpFrRwXXQ=wAvZ-oUNKXUJ=uUA=fiDrkhRu5VGXcM+=cuA@mail.gmail.com>
 <20220905110713.27304149@gandalf.local.home>
In-Reply-To: <20220905110713.27304149@gandalf.local.home>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Mon, 5 Sep 2022 11:08:21 -0700
Message-ID: <CAJuCfpF-O6Gz2o7YqCgFHV+KEFuzC-PTUoBHj25DNRkkSmhbUg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/30] Code tagging framework and applications
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Michal Hocko <mhocko@suse.com>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <liam.howlett@oracle.com>,
        David Vernet <void@manifault.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, mcgrof@kernel.org,
        masahiroy@kernel.org, nathan@kernel.org, changbin.du@intel.com,
        ytcoode@gmail.com, Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Benjamin Segall <bsegall@google.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Christopher Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, 42.hyeyoo@gmail.com,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
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

On Mon, Sep 5, 2022 at 8:06 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Sun, 4 Sep 2022 18:32:58 -0700
> Suren Baghdasaryan <surenb@google.com> wrote:
>
> > Page allocations (overheads are compared to get_free_pages() duration):
> > 6.8% Codetag counter manipulations (__lazy_percpu_counter_add + __alloc_tag_add)
> > 8.8% lookup_page_ext
> > 1237% call stack capture
> > 139% tracepoint with attached empty BPF program
>
> Have you tried tracepoint with custom callback?
>
> static void my_callback(void *data, unsigned long call_site,
>                         const void *ptr, struct kmem_cache *s,
>                         size_t bytes_req, size_t bytes_alloc,
>                         gfp_t gfp_flags)
> {
>         struct my_data_struct *my_data = data;
>
>         { do whatever }
> }
>
> [..]
>         register_trace_kmem_alloc(my_callback, my_data);
>
> Now the my_callback function will be called directly every time the
> kmem_alloc tracepoint is hit.
>
> This avoids that perf and BPF overhead.

Haven't tried that yet but will do. Thanks for the reference code!

>
> -- Steve

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8FBD5AD92B
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 20:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbiIESpI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 14:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbiIESpG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 14:45:06 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DB11EAD6;
        Mon,  5 Sep 2022 11:45:01 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id 145so9264911pfw.4;
        Mon, 05 Sep 2022 11:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date;
        bh=bp7uubPhvNdLHMSt0aPBCCek7261kdyNq09tUdxS+hw=;
        b=piwDQu/IQn+iTyDmrFAKLLGug2/KVIY0wExpws2cTzWbVzQSAeP21bPvOiuaRqDs2W
         JQoerfe3i4QQz7Cj1GsYnZVIR1xKCKWMECDAl3eXr+TOFn09Ud17TXz2OPRBNMzXaQ00
         bRAB2djvvnCoTXv68Ow/gDY8gNR87B3UphTOmg/nkljGpBLK2Kru1ca9zKlDPQvntNjO
         mMIzgSHR8yf5hPReChlBzaYVsZgAt1UFpnPZ3NTnb1GPzkwb3HG7zv/BZtSipedU5QQ3
         aVcP2YbTWfY0XZEJvLhnxRCKUAZXjcy0d3SAOSR8rLFHgESMgNsb387q+JmPGxUvicyP
         hisw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=bp7uubPhvNdLHMSt0aPBCCek7261kdyNq09tUdxS+hw=;
        b=pv8M6OMlkxMUvla4xOHTdhCTZ0jY7h9PT0oZeMjlpgZ9Xj49WB1ecxCKqeEmrZc9Y3
         30H13ObTX5wZWkjARbZ3g4B8iSGdycvH7XxtBNs21hEhA4edBJkZ/XSrly6YBPD1LYak
         xPJBzK0zfFluuyC0jBPbpTKQv4c7LvAjYLl8jrJOKsYhvypBxnOvp8UzzDc5aL4+adM6
         XdXQnA5yP21z/+vrOPJXaaeouQLJe9//UoASTQQwQhB0YyFCWqB6yXJNMmQViIDQSywE
         ckOvheDkcw4QcMmp6mg5VkTx8sxxrk9DC1KrolVE6LXe7aK59t4I0Y2q18LPzIQc3x6R
         w6lQ==
X-Gm-Message-State: ACgBeo1BJyvFLExgzzBywBO0vW+cnuoWWBxCIV7nsRPYBftqOwQ9fgKs
        c9s9AuY3DaJEz8DWJXFCtMs=
X-Google-Smtp-Source: AA6agR5Z0n78WBJ+tl3rvbtMAHs4LRm2iBpVTL/7lQ4Vdk+FtE7G2db+zR5YWnYqEMH87O6DNCB35w==
X-Received: by 2002:a65:6cc8:0:b0:3fe:2b89:cc00 with SMTP id g8-20020a656cc8000000b003fe2b89cc00mr43555470pgw.599.1662403500241;
        Mon, 05 Sep 2022 11:45:00 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id u15-20020a170903124f00b00176ba091cd3sm1910534plh.196.2022.09.05.11.44.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Sep 2022 11:44:59 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [RFC PATCH 00/30] Code tagging framework and applications
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20220831101948.f3etturccmp5ovkl@suse.de>
Date:   Mon, 5 Sep 2022 11:44:55 -0700
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        Peter Zijlstra <peterz@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, roman.gushchin@linux.dev,
        dave@stgolabs.net, Matthew Wilcox <willy@infradead.org>,
        liam.howlett@oracle.com, void@manifault.com, juri.lelli@redhat.com,
        ldufour@linux.ibm.com, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, mcgrof@kernel.org,
        masahiroy@kernel.org, nathan@kernel.org, changbin.du@intel.com,
        ytcoode@gmail.com, vincent.guittot@linaro.org,
        dietmar.eggemann@arm.com, Steven Rostedt <rostedt@goodmis.org>,
        bsegall@google.com, bristot@redhat.com, vschneid@redhat.com,
        cl@linux.com, penberg@kernel.org, iamjoonsoo.kim@lge.com,
        42.hyeyoo@gmail.com, glider@google.com,
        Marco Elver <elver@google.com>, dvyukov@google.com,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Arnd Bergmann <arnd@arndb.de>, jbaron@akamai.com,
        David Rientjes <rientjes@google.com>, minchan@google.com,
        kaleshsingh@google.com, kernel-team@android.com,
        Linux MM <linux-mm@kvack.org>, iommu@lists.linux.dev,
        kasan-dev@googlegroups.com, io-uring@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>,
        xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
        linux-modules@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <8EB7F2CE-2C8E-47EA-817F-6DE2D95F0A8B@gmail.com>
References: <20220830214919.53220-1-surenb@google.com>
 <Yw8P8xZ4zqu121xL@hirez.programming.kicks-ass.net>
 <20220831084230.3ti3vitrzhzsu3fs@moria.home.lan>
 <20220831101948.f3etturccmp5ovkl@suse.de>
To:     Mel Gorman <mgorman@suse.de>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Aug 31, 2022, at 3:19 AM, Mel Gorman <mgorman@suse.de> wrote:

> On Wed, Aug 31, 2022 at 04:42:30AM -0400, Kent Overstreet wrote:
>> On Wed, Aug 31, 2022 at 09:38:27AM +0200, Peter Zijlstra wrote:
>>> On Tue, Aug 30, 2022 at 02:48:49PM -0700, Suren Baghdasaryan wrote:
>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>>>> Code tagging framework
>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>>>> Code tag is a structure identifying a specific location in the =
source code
>>>> which is generated at compile time and can be embedded in an =
application-
>>>> specific structure. Several applications of code tagging are =
included in
>>>> this RFC, such as memory allocation tracking, dynamic fault =
injection,
>>>> latency tracking and improved error code reporting.
>>>> Basically, it takes the old trick of "define a special elf section =
for
>>>> objects of a given type so that we can iterate over them at =
runtime" and
>>>> creates a proper library for it.
>>>=20
>>> I might be super dense this morning, but what!? I've skimmed through =
the
>>> set and I don't think I get it.
>>>=20
>>> What does this provide that ftrace/kprobes don't already allow?
>>=20
>> You're kidding, right?
>=20
> It's a valid question. =46rom the description, it main addition that =
would
> be hard to do with ftrace or probes is catching where an error code is
> returned. A secondary addition would be catching all historical state =
and
> not just state since the tracing started.
>=20
> It's also unclear *who* would enable this. It looks like it would =
mostly
> have value during the development stage of an embedded platform to =
track
> kernel memory usage on a per-application basis in an environment where =
it
> may be difficult to setup tracing and tracking. Would it ever be =
enabled
> in production? Would a distribution ever enable this? If it's enabled, =
any
> overhead cannot be disabled/enabled at run or boot time so anyone =
enabling
> this would carry the cost without never necessarily consuming the =
data.
>=20
> It might be an ease-of-use thing. Gathering the information from =
traces
> is tricky and would need combining multiple different elements and =
that
> is development effort but not impossible.
>=20
> Whatever asking for an explanation as to why equivalent functionality
> cannot not be created from ftrace/kprobe/eBPF/whatever is reasonable.

I would note that I have a solution in the making (which pretty much =
works)
for this matter, and does not require any kernel changes. It produces a
call stack that leads to the code that lead to syscall failure.

The way it works is by using seccomp to trap syscall failures, and then
setting ftrace function filters and kprobes on conditional branches,
indirect branch targets and function returns.

Using symbolic execution, backtracking is performed and the condition =
that
lead to the failure is then pin-pointed.

I hope to share the code soon.


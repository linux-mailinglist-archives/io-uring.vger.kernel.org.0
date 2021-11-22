Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B289E4597E4
	for <lists+io-uring@lfdr.de>; Mon, 22 Nov 2021 23:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbhKVW5D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Nov 2021 17:57:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbhKVW5C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Nov 2021 17:57:02 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C871CC061574;
        Mon, 22 Nov 2021 14:53:55 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id x7so15061457pjn.0;
        Mon, 22 Nov 2021 14:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NquELzBjcT3sMLblVcPvV1MkAki2ZKYx67AnRd0Qf8A=;
        b=RqibWQqgGJCuoquY7Q4pOisIBklt4ZDnKgNkY2YF9knvRg2uhbfpYPWiR20pGCVwDd
         nREAPtC456erGB7zRHPwY8t/HJHCtONdfgfAAZzgZfuE1jP2WyCw54qoBz8Gd/WJaQKk
         TJGlPPx3WCWdn4T5oj8qBiZrmJidJ0SDSmbnhgQs5M6B5UOQOiSkHLecOjvbOlWj10JW
         K+L6ltzcUOIxfNXrwUDcNIFueKMnNSZsHB15QW+MXEeUjLH1hNjFxpA+L+b4EEq2wwEZ
         4X7oerIUP+kIIY0VIAimSBTv9yF/DHqAHzI8dOvg+TNtYGWKsejWoZj/IRga2c5podSx
         dbpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NquELzBjcT3sMLblVcPvV1MkAki2ZKYx67AnRd0Qf8A=;
        b=GKUx0W1CAPDT2ncXANW8VwzGbLjbluQt87Xe5FYDapD4FOMty8HVR/O849bokg4Zoa
         D6arj1Fzz9J2wtH/khjLYHR9917zaFPu1FfaMwtMlRe5D4Xz6M2lCYYIclIwPWXxo5ke
         b4FMSL3g4aImDvFP5SHs+YB4FU63wYJ2dn8HpcT4dbd4K7c4IxZ5SsRPjHjvXmFglPpV
         00QKbTVXxgH/mabspZ+tunqeyI681ITWbjM2YIruN2RMxN83fVhMn9b1gbkJQDcVT7px
         iecl6Me1puO/AipJOulV+PE9XR//p/ShPReEUteq6xwWNioyuPU+RyaqgVNHbHhsvXmO
         6DFw==
X-Gm-Message-State: AOAM533M9QdUN02gSHcWme4hBOCMDjV7zXx7paGkCt9wR5D+1lUVh53c
        t7+gx0Oph2MooJ2r0Qq3tL0gx0QeqKM=
X-Google-Smtp-Source: ABdhPJw+mWuoBoclb8H/VdY6vQocKMpB6Hla4TsgdQUN156AIotMSzeH+4B+IHo1vLWFaHr68z+MPg==
X-Received: by 2002:a17:90b:1d07:: with SMTP id on7mr36899741pjb.45.1637621634720;
        Mon, 22 Nov 2021 14:53:54 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id s19sm5176126pfu.104.2021.11.22.14.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 14:53:54 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH bpf-next v2 00/10] Introduce BPF iterators for io_uring and epoll
Date:   Tue, 23 Nov 2021 04:23:42 +0530
Message-Id: <20211122225352.618453-1-memxor@gmail.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5451; h=from:subject; bh=Eda6ob2x7nQ6hY//FPXuD76ZZeY2klQq3Fmn+F68dDY=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhnBrLyOHFtho5EXaBVpkGjCxPpNihOutcHsk9xVum i8Yp8KaJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYZwaywAKCRBM4MiGSL8RynIID/ 93rxxX5PPbLd1+xXtyr5UhiRSp49LRTAKhd9dIydQanqDFi21spyu3WK4VlZIWLQtfRtJe+8L3Ofzw q/FH2gffjO7+ndDmhWAaxgnuxgeQJuLqfSFKoaGL8kOABenH9vcbjB5emduLDEzHi9TIaelvxuFg0c z35BCzvqUg3FlLqv4c9AcRmWKjF7azsnGJNHbMwk43E5lMLBu7LSdrBZ14o0vmGcUmlffWT9QvRUw5 mwFVJbKq8pTND1Z62q7gclMbhJ1ypJFbuHl78RPmwEjdwtKbzywfkZpAmETMvEjOfAuWdwNXCuFLrb domQQO9jaiECh+nr3xBMYmg1m2iIsOdJHzAucDpyZ7b+kekRUOfinAknTMRzSbPUmhWkIwe3Mw6JcA 0yBTZCK7YHooen5pwfOMRtj1Sz9QhiKbsWVP/nPYE9sbqc1OWP2QcgsIqHUrsKRRFsQs9+G45mIWK3 /gJXU5mrxeY5zqIoz3fRGd0mx0cEb9I3tDO8CNPCDAqrRsyk/dsMk+uvAZZiUoJczCvsIbtiRZUDGf BMNJrKenBYc6UNqNC54W/hBocg5ThiVU/2Hq5v3OI3ErmvQmI1tqUI7ydHqBbxS5s14RSBx3FmyksW HR/lxyKV4/HqqVTntH2bzeTPI+dt8Ed5LAzSJMDQ7YLpdht9jH5Pd+MsYcaw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The CRIU [0] project developers are exploring potential uses of the BPF
subsystem to do complicated tasks that are difficult to add support for in the
kernel using existing interfaces.  Even if they are implemented using procfs,
or kcmp, it is difficult to make it perform well without having some kind of
programmable introspection into the kernel data structures. Moreover, for
procfs based state inspection, the output format once agreed upon is set in
stone and hard to extend, and at the same time inefficient to consume from
programs (where it is first converted from machine readable form to human
readable form, only to be converted again to machine readable form).  In
addition to this, kcmp based file set matching algorithm performs poorly since
each file in one set needs to be compared to each file in another set, to
determine struct file equivalence.

This set adds a io_uring file iterator (for registered files), a io_uring ubuf
iterator (for registered buffers), and a epoll iterator (for registered items
(files, registered using EPOLL_CTL_ADD)) to overcome these limitations.  Using
existing task, task_file, task_vma iterators, all of these can be combined
together to significantly enhance and speed up the task dumping procedure.

The two immediate use cases are io_uring checkpoint/restore support and epoll
checkpoint/restore support. The first is unimplemented, and the second is being
expedited using a new epoll iterator. In the future, more stages of the
checkpointing sequence can be offloaded to eBPF programs to reduce process
downtime, e.g. in pre-dump stage, before task is seized.

The io_uring file iterator is even more important now due to the advent of
descriptorless files in io_uring [1], which makes dumping a task's files a lot
more harder for CRIU, since there is no visibility into these hidden
descriptors that the task depends upon for operation. Similarly, the
io_uring_ubuf iterator is useful in case original VMA used in registering a
buffer has been destroyed.

The set includes an example sample showing how these iterator(s) along with
task_file iterator can be useful to restore an io_uring instance, implementing a
simplified version of the code we are planning to adopt for CRIU. Patch 10 is
not meant for submission, only exposition. It implements all the missing
features noted in [2].

Please see the individual patches for more details.

[ Note (for Yonghong): I am still unusure what will be useful in show_fdinfo,
  fill_link_info for epoll, so that has been left out. I was reminded that
  io_uring now uses anon_inode_getfile_secure, which we also use in CRIU to
  determine source fd of ring mapping, so this should be enough to identify
  the io_uring fd in userspace, hence I implemented it for io_uring in v2.   ]

  [0]: https://criu.org/Main_Page
  [1]: https://lwn.net/Articles/863071
  [2]: https://github.com/checkpoint-restore/criu/pull/1597

Changelog:
----------

v1 -> v2:
v1: https://lore.kernel.org/bpf/20211116054237.100814-1-memxor@gmail.com

 * Add example showing how iterator is useful in C/R of io_uring (Alexei)
 * Change type of index from unsigned long to u64 (Yonghong)
 * Fix build error for CONFIG_IO_URING=n (Kernel Test Robot)
  * Move bpf_page_to_pfn out of CONFIG_IO_URING (Yonghong)
 * Add comment to bpf_iter_aux_info for map member (Yonghong)
 * show_fdinfo/fill_link_info for io_uring (Yonghong)
 * Fix other nits

Kumar Kartikeya Dwivedi (10):
  io_uring: Implement eBPF iterator for registered buffers
  bpf: Add bpf_page_to_pfn helper
  io_uring: Implement eBPF iterator for registered files
  epoll: Implement eBPF iterator for registered items
  bpftool: Output io_uring iterator info
  selftests/bpf: Add test for io_uring BPF iterators
  selftests/bpf: Add test for epoll BPF iterator
  selftests/bpf: Test partial reads for io_uring, epoll iterators
  selftests/bpf: Fix btf_dump test for bpf_iter_link_info
  samples/bpf: Add example to checkpoint/restore io_uring

 fs/eventpoll.c                                | 196 ++++-
 fs/io_uring.c                                 | 345 +++++++++
 include/linux/bpf.h                           |  16 +
 include/uapi/linux/bpf.h                      |  18 +
 kernel/trace/bpf_trace.c                      |  19 +
 samples/bpf/.gitignore                        |   1 +
 samples/bpf/Makefile                          |   8 +-
 samples/bpf/bpf_cr.bpf.c                      | 185 +++++
 samples/bpf/bpf_cr.c                          | 686 ++++++++++++++++++
 samples/bpf/bpf_cr.h                          |  48 ++
 samples/bpf/hbm_kern.h                        |   2 -
 scripts/bpf_doc.py                            |   2 +
 tools/bpf/bpftool/link.c                      |  10 +
 tools/include/uapi/linux/bpf.h                |  18 +
 .../selftests/bpf/prog_tests/bpf_iter.c       | 387 +++++++++-
 .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
 .../selftests/bpf/progs/bpf_iter_epoll.c      |  33 +
 .../selftests/bpf/progs/bpf_iter_io_uring.c   |  50 ++
 18 files changed, 2020 insertions(+), 8 deletions(-)
 create mode 100644 samples/bpf/bpf_cr.bpf.c
 create mode 100644 samples/bpf/bpf_cr.c
 create mode 100644 samples/bpf/bpf_cr.h
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_epoll.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_io_uring.c

-- 
2.34.0


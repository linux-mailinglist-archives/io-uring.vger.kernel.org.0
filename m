Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23664645DA
	for <lists+io-uring@lfdr.de>; Wed,  1 Dec 2021 05:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346545AbhLAE1B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Nov 2021 23:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhLAE06 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Nov 2021 23:26:58 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8305FC061574;
        Tue, 30 Nov 2021 20:23:37 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id u17so16655408plg.9;
        Tue, 30 Nov 2021 20:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bUNS+Sa8lyKiGCkA+yHXnwWVJUVBTnwtTeWAMPi77yU=;
        b=AUPrMX2FYEVyWVtXZF8Mq1+JnAUt7vxT1USS8RlM6Y2qeM16AaTrc1LIFFqXIgH4Xz
         n1yXFrn/zYsO1AoQxcHdf6JkD80NRfgEfAOsnaTPwHuh0eDXvRSG7T5PBFRjPuHBKfDv
         Gc/cjpeyzTZ3QDnDN3Yi0rkmgdN+CUqnD/rmIWm8CZvFvAAOLLYvF5oq8pHZ1C6iS8Hj
         Ly5gnVIEcmIHcUunnj90/EQ4OPhQqPO+C/FnAV5Sa3s6nrK1rP+63zI6Jlcm8GMsO3/T
         nwQeEvOWakHYjhC/3/PBxxFXQAg2xHQ6zukKYBeGygsu0bluatriZC2BSNV2l9HwcKDW
         mUlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bUNS+Sa8lyKiGCkA+yHXnwWVJUVBTnwtTeWAMPi77yU=;
        b=wdgg3h6JmXOVBQKYciN5XwaY/wepIhq7TXoGAdeR1eMKxBYsk/u9CThE+KRqfBkzsY
         wXRQjb+XLyHQBmIIG3+6AZM2z9pbUDzKZ27OxqtrZjWGvpsekiuSa6Y431tiX4HeSB+3
         t0Tx49jAMAiSDlnygc/le6pQKGNiEwnsLIjBfNeIO/J0+CqMUH2UAmL0ECwuoPQgFDLQ
         MfmGAcSHkMyGoxTr/k6RcxAkoZE2xADjFUxApPiwxs8q0CMyRPbKZVx1kS3J6Bd7W+xr
         XQ+k5j2ZMgJnbRIzVsuh6gx9ZnYOMdzoPbbmjVWYGzBqInXwCZBVfUDNt+WIEm3tWYM8
         ABzw==
X-Gm-Message-State: AOAM533ob83kg48/bVLDbEJCdLECdSUnB9mx2zRM3M7pZGJo/r8JCY9W
        GV+6PbF7bdQu8S+ag0CM2RMjMcVWlgU=
X-Google-Smtp-Source: ABdhPJzsEXToPhYGsoz+kClFoqPOupoKGXO57zQ2W/4x2taxvfdw8IUT5ugl1N7Eikqqyz19bTyVKg==
X-Received: by 2002:a17:90a:fe0a:: with SMTP id ck10mr4400247pjb.216.1638332616806;
        Tue, 30 Nov 2021 20:23:36 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id j1sm21330637pfe.158.2021.11.30.20.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 20:23:36 -0800 (PST)
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
Subject: [PATCH bpf-next v3 00/10] Introduce BPF iterators for io_uring and epoll
Date:   Wed,  1 Dec 2021 09:53:23 +0530
Message-Id: <20211201042333.2035153-1-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5748; h=from:subject; bh=78j4YRjD1ivrtgADq/aBU0z1jmIS5yDNBh6P6aC15iE=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhpvYxUM1Dy/xAourqI/VAL5JiyFeJL5BD/eBYJet/ +XPkbeeJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYab2MQAKCRBM4MiGSL8Rysc5D/ 47yUGjwZcGdDvkiIfUKjBSxSB+C6/R6f1rwOWZyp/13XsPvJkppU06j5+yKLATMPTfFiBt7zG7ONzS IXsLB4Fi3o6HkPt+Y4X0q9/BaECD34r/0+wCnz+q/Hq4JnUsRRej9ZOOdNjDs+4zHCfvFDcxsLYTxg jCecWe/sP2JcXzUbQxtK9V/aa700Q5hl92a6v8zwEjKFpC36NrB/njmlYMk+udgBR0P4yFsdhiqzxI QhaK6DS6mMdKLR7+XNs4egILTLlVT///H3np0SK2t3w0E2w9AaTUvEnCJtFbZuDAhhQE0RiN9E9mog 1/RNi3/0jUqq+WzI+tTpnGQyQknPKW19OQTAywWE4ndj02XIySQfGEbReIRDfCwCum0MQymlyRy1P2 xf9yXH2fZSy+hGQu4Sh04MUaXOfvVd1oZfKLz7luh7HSRVP86OsKZtGSmHAcRbhkKWU1Zr71/n9Ohv bZ7MPV5H8qhU0Nl9K4u1VRVfL3KWw8V/JqPNH1S/1RzI/70x5UMBnZimAGipu/L5HJ2HYYT0/2zyYB sBQNxkVZoDGar4AG8GfpMbEkRXlFQkhmJHXP3URPu8gwaZK95mtQCzYM6YZaXWXXOo1N8BnFxn3s+D iFDaDAZxLg3pLXKD4Qpt0MZRmdTAclqoUeYYkvED+FPDlWMg+91gxRFoexDw==
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
not meant for submission, only exposition, hence explicitly marked RFC. It
implements the missing features noted in [2].

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
v2 -> v3:
v2: https://lore.kernel.org/bpf/20211122225352.618453-1-memxor@gmail.com

 * Make show_fdinfo/fill_link_info functions static (Kernel Test Robot)
 * Minor memory leak fixes for bpf_cr
 * Use proper names instead of -2, -1 for denoting epoll iterator state

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

 fs/eventpoll.c                                | 201 ++++-
 fs/io_uring.c                                 | 345 +++++++++
 include/linux/bpf.h                           |  16 +
 include/uapi/linux/bpf.h                      |  18 +
 kernel/trace/bpf_trace.c                      |  19 +
 samples/bpf/.gitignore                        |   1 +
 samples/bpf/Makefile                          |   8 +-
 samples/bpf/bpf_cr.bpf.c                      | 185 +++++
 samples/bpf/bpf_cr.c                          | 688 ++++++++++++++++++
 samples/bpf/bpf_cr.h                          |  48 ++
 samples/bpf/hbm_kern.h                        |   2 -
 scripts/bpf_doc.py                            |   2 +
 tools/bpf/bpftool/link.c                      |  10 +
 tools/include/uapi/linux/bpf.h                |  18 +
 .../selftests/bpf/prog_tests/bpf_iter.c       | 387 +++++++++-
 .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
 .../selftests/bpf/progs/bpf_iter_epoll.c      |  33 +
 .../selftests/bpf/progs/bpf_iter_io_uring.c   |  50 ++
 18 files changed, 2027 insertions(+), 8 deletions(-)
 create mode 100644 samples/bpf/bpf_cr.bpf.c
 create mode 100644 samples/bpf/bpf_cr.c
 create mode 100644 samples/bpf/bpf_cr.h
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_epoll.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_io_uring.c

-- 
2.34.1


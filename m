Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEF7452A28
	for <lists+io-uring@lfdr.de>; Tue, 16 Nov 2021 06:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240297AbhKPGBs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Nov 2021 01:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240160AbhKPGBm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Nov 2021 01:01:42 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED89C06122F;
        Mon, 15 Nov 2021 21:42:40 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso1281638pji.0;
        Mon, 15 Nov 2021 21:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZiJH60W16gunzDy5ORNJzHgGIx+W/lmdguHzEJZNQTc=;
        b=O85NyUsoiW6yAvdHx9ILdEwQiPiLRH/dVfS3A6VoLliYaupHGM4tClqLJ95tJa45ZE
         7Zj7NyFUvbae52r7+ITMxeVdy1Od1yfztC7YDCYULqbajuP/cM0I/fyU91I7uzxkPZkb
         IpF80167wo19h1x5d8aCyIKYNMgRheqIVC/GMg/UPqe1mjxk1S/5seWWEEwoAUKXj8DX
         /3eDmrNIEi0u+yP1Qbd8RAV7g2tbMgM8FLa71CTiEZ+fKgyAGQMuUYJHpFq48BnIyIA7
         YEkzbkwoP8reew3Vtdl8Y50FZAnLV3oQtH1lxN7UjsMMYavYvOUzCdhcxl6lyRnrtwvh
         CwfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZiJH60W16gunzDy5ORNJzHgGIx+W/lmdguHzEJZNQTc=;
        b=owzKa6djrj4ZeUSnuCS0dqlOgDnZhEcOcY9quBjM8oFUiNzajVQgZ7Y9l2sEgRud2B
         eP29UGZCDg8jRANXusMiQ2M/I/K2NHCXPgRisaetKNYj4wMc7TK+FZ8fT/ssUq4yrrdt
         2WCvRjPR+ZKCexFhE2vEwbHpn2CvvJAPwm+ncAVR492PaqZ+hKm/GpB2krSr6yIMSX1P
         5aGHIGu4X8dQGt/66cJHs+28N6kp044XTLqqqgQ/jSi8Qd5fpWshhGnBwwj9h2xU278d
         vVr+MvT6Idp1Lui2c6FgvNeeeMGTc7IsuhZc0+C19LISz+xAiyYpukOlkno2TvsDOvpk
         TbWA==
X-Gm-Message-State: AOAM532/CEeNE3MKiUfFwHEBFbNH+qkoLp0buRtNUhKXkImFXeedcVKN
        VTK8kTkryPvIsEnGhj7E9WPTSOl/y6E=
X-Google-Smtp-Source: ABdhPJz3CAzWCScgu+wjIIaTr/6w+pL0qeMP/zUB+sZ54+WOpBoLekkuYi1hyqCE6LN1W5FhUR1vXw==
X-Received: by 2002:a17:902:bc85:b0:143:954e:8548 with SMTP id bb5-20020a170902bc8500b00143954e8548mr40988891plb.82.1637041359666;
        Mon, 15 Nov 2021 21:42:39 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id n1sm16753963pfj.193.2021.11.15.21.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 21:42:39 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mihalicyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH bpf-next v1 0/8]  Introduce BPF iterators for io_uring and epoll
Date:   Tue, 16 Nov 2021 11:12:29 +0530
Message-Id: <20211116054237.100814-1-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3556; h=from:subject; bh=SlD5HGZzKxuIYkJkdaUqV0OTyvwRfj3yhC7ub0JOPQw=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhk0S6c8t+Ojz65eZNTVAFmrDa1s2rNuMB8kElx5ev mbNO73GJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYZNEugAKCRBM4MiGSL8RyminEA C0NadbANkkUkEjQcUwGjmXCSUIzxBrkI2yWAd/PMxxJzh24HSDYrJN79DMwQT7D6Kx/haZDhrWKhnE ciYBGgj+mvOzeunr1YNqER2UQAJCdhvPle9gQj2GhKgwfA46JBrtNJq5wwJhmZ3xUC9YH44ZKpb0yp lf3nD8Jf0IctZdz84xjAmGjzRwT5ztQL4e/DqSlBGFKXLLyKwaThpACzs1GCGib2ypazD9M+N3JfQ/ eRTZhzaiiwgaq5dRIQH/WPRYMOwCzgSDEci4QxXk7oNpHbe5EVTwjtsrGK28V4uGvnlKNUgruJn/FW e34WK2Nm/jcYeaiv/k0VqDiS2TST0cntKcI0xLFilO7c9Er1PEcGi6QwRCLl+YW0C5MabPW9BAQPMs buUZzIYmgezL/uHdz3PxGVhl+RHh/twYXbHmj97TpUnlmf89Hhoi92MP48TdiI5RnDBYxBZkPKmlwG 1765ZPSMPelJEWvtASTZnYM/WISA0d9zmnTXwLMEF1oo9onifadKMEwhBWpODCDUcW1gC+/EBujB3S Lf5/z9cvfnOFTFFJdPSBTp1z4dFB7hHc3AU/pNPv/8PONA2+K7Vnp1vTD+diQRGoKUjUcpURcbnG5X VbWv1Vajnha14dBkwK8/hr62tXkAdnkmfW1ztg+OtFzDLylI0hb+fNQCaZZg==
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

 Please see the individual patches for more details.

   [0]: https://criu.org/Main_Page
   [1]: https://lwn.net/Articles/863071

Kumar Kartikeya Dwivedi (8):
  io_uring: Implement eBPF iterator for registered buffers
  bpf: Add bpf_page_to_pfn helper
  io_uring: Implement eBPF iterator for registered files
  epoll: Implement eBPF iterator for registered items
  selftests/bpf: Add test for io_uring BPF iterators
  selftests/bpf: Add test for epoll BPF iterator
  selftests/bpf: Test partial reads for io_uring, epoll iterators
  selftests/bpf: Fix btf_dump test for bpf_iter_link_info

 fs/eventpoll.c                                | 196 +++++++++-
 fs/io_uring.c                                 | 334 ++++++++++++++++
 include/linux/bpf.h                           |   6 +
 include/uapi/linux/bpf.h                      |  15 +
 kernel/trace/bpf_trace.c                      |   2 +
 scripts/bpf_doc.py                            |   2 +
 tools/include/uapi/linux/bpf.h                |  15 +
 .../selftests/bpf/prog_tests/bpf_iter.c       | 362 +++++++++++++++++-
 .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
 .../selftests/bpf/progs/bpf_iter_epoll.c      |  33 ++
 .../selftests/bpf/progs/bpf_iter_io_uring.c   |  50 +++
 11 files changed, 1015 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_epoll.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_io_uring.c

-- 
2.33.1


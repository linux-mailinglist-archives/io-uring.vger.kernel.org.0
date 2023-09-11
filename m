Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8319C79BC85
	for <lists+io-uring@lfdr.de>; Tue, 12 Sep 2023 02:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240902AbjIKWJ5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Sep 2023 18:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236408AbjIKKeb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Sep 2023 06:34:31 -0400
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BEEE5F;
        Mon, 11 Sep 2023 03:34:25 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-99bdeae1d0aso543476766b.1;
        Mon, 11 Sep 2023 03:34:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694428464; x=1695033264;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RuxWzi0SpMhBfa5qiwgBKVDj1sBIBDVRjmMU4662HK8=;
        b=SQbuzEmyic9K5mXSE3/2mx4IMzJF/HmbjQ/3zXMKqoMtscI8hQhEX7xDDA8Gf1twUv
         jNTsUEvJg/DRp9t71tWrRzg2JMTNcYwmXnXFU3omTjtwdmvwwsM4BTy72rcw4LHJ8t7F
         ZIYkq/yIDJ2q2Cw4bD4dwJnhzioeXgxw/mja6uu6d8Z2g52krVVdVMxzR4LI6mD13y1m
         yrk5IoSoBfZnQq4YXCRLdYbAga5S41BqlLkO4m+UqyT5koKpKJh9BVZ3pCW7XZbDZH1u
         ZOT9Qc3wbUvXKXVsO9cdDi/ZwxeqY2Q70Ph/KoUFbOto3d9s61V7mn0e8ki32Ywn3O7d
         MekA==
X-Gm-Message-State: AOJu0YymrcdeaOUHwzFMzyj6hPdFY8+qzA9Vbgdv7g9lpXdYfpTTYKJy
        DCZFSWG+kRIODj2RHGcQId4=
X-Google-Smtp-Source: AGHT+IFHynsKgWq4NgUjq4OKLyUzMvXPVvvjbbjYd6PD4qMpJEvDfhgLeYH8m3839btK71/4rp846Q==
X-Received: by 2002:a17:906:8b:b0:9a2:1ce5:1243 with SMTP id 11-20020a170906008b00b009a21ce51243mr8687836ejc.60.1694428463664;
        Mon, 11 Sep 2023 03:34:23 -0700 (PDT)
Received: from localhost (fwdproxy-cln-019.fbsv.net. [2a03:2880:31ff:13::face:b00c])
        by smtp.gmail.com with ESMTPSA id hb5-20020a170906b88500b009828e26e519sm5079289ejb.122.2023.09.11.03.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 03:34:23 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        martin.lau@linux.dev, krisman@suse.de
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, pabeni@redhat.com
Subject: [PATCH v5 0/8] io_uring: Initial support for {s,g}etsockopt commands
Date:   Mon, 11 Sep 2023 03:33:59 -0700
Message-Id: <20230911103407.1393149-1-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patchset adds support for getsockopt (SOCKET_URING_OP_GETSOCKOPT)
and setsockopt (SOCKET_URING_OP_SETSOCKOPT) in io_uring commands.
SOCKET_URING_OP_SETSOCKOPT and SOCKET_URING_OP_GETSOCKOPT implement generic
case, covering all levels and optnames (a change from the previous
version, where getsockopt was limited to level=SOL_SOCKET).

In order to keep the implementation (and tests) simple, some refactors
were done prior to the changes, as follows:

Patch 1-2:  Remove the core {s,g}etsockopt() core function from
__sys_{g,s}etsockopt, so, the code could be reused by other callers,
such as io_uring.

Patch 3: Pass compat mode to the file/socket callbacks

Patch 4: Move io_uring helpers from io_uring_zerocopy_tx to a generic
io_uring headers. This simplify the test case (last patch)

Patch 5: Protect io_uring_cmd_sock() to not be called if CONFIG_NET is
disabled.

Important to say that userspace pointers need to be alive until the
operation is completed, as in the systemcall.

These changes were tested with a new test[1] in liburing, LTP sockopt*
tests, as also with bpf/progs/sockopt test case, which is now adapted to
run using both system calls and io_uring commands.

[1] Link: https://github.com/leitao/liburing/blob/getsock/test/socket-getsetsock-cmd.c

RFC -> V1:
	* Copy user memory at io_uring subsystem, and call proto_ops
	  callbacks using kernel memory
	* Implement all the cases for SOCKET_URING_OP_SETSOCKOPT

V1 -> V2
	* Implemented the BPF part
	* Using user pointers from optval to avoid kmalloc in io_uring part.

V2 -> V3:
	* Break down __sys_setsockopt and reuse the core code, avoiding
	  duplicated code. This removed the requirement to expose
	  sock_use_custom_sol_socket().
	* Added io_uring test to selftests/bpf/sockopt.
	* Fixed compat argument, by passing it to the issue_flags.

V3 -> V4:
	* Rebase on top of commit 1ded5e5a5931b ("net: annotate data-races around sock->ops")
	* Also broke down __sys_setsockopt() to reuse the core function
	  from io_uring.
	* Create a new patch to return -EOPNOTSUPP if CONFIG_NET is
	  disabled
	* Added two SOL_SOCKET tests in bpf/prog_tests/sockopt.

V4 -> V5:
	* Do not use sockptr anymore, by changing the optlen getsock argument
	  to be a user pointer (instead of a kernel pointer). This change also drop
	  the limitation on getsockopt from previous versions, and now all
	  levels are supported.
	* Simplified the BPF sockopt test, since there is no more limitation on
	  the io_uring commands.
	* No more changes in the BPF subsystem.
	* Moved the optlen field in the SQE struct. It is now a pointer instead
	  of u32.

Breno Leitao (8):
  net/socket: Break down __sys_setsockopt
  net/socket: Break down __sys_getsockopt
  io_uring/cmd: Pass compat mode in issue_flags
  selftests/net: Extract uring helpers to be reusable
  io_uring/cmd: return -EOPNOTSUPP if net is disabled
  io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
  io_uring/cmd: Introduce SOCKET_URING_OP_SETSOCKOPT
  selftests/bpf/sockopt: Add io_uring support

 include/linux/io_uring.h                      |   1 +
 include/net/sock.h                            |   5 +
 include/uapi/linux/io_uring.h                 |  10 +
 io_uring/uring_cmd.c                          |  41 +++
 net/socket.c                                  |  89 ++++--
 tools/include/io_uring/mini_liburing.h        | 292 ++++++++++++++++++
 .../selftests/bpf/prog_tests/sockopt.c        |  95 +++++-
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/io_uring_zerocopy_tx.c      | 268 +---------------
 9 files changed, 497 insertions(+), 305 deletions(-)
 create mode 100644 tools/include/io_uring/mini_liburing.h

-- 
2.34.1


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC8E7CAABB
	for <lists+io-uring@lfdr.de>; Mon, 16 Oct 2023 16:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbjJPOBq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Oct 2023 10:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbjJPOBh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Oct 2023 10:01:37 -0400
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9658CAC;
        Mon, 16 Oct 2023 07:01:34 -0700 (PDT)
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5384975e34cso8162188a12.0;
        Mon, 16 Oct 2023 07:01:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697464893; x=1698069693;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K+vz+RhpX8IapoVrGDcBGs5+y+fGXCtRk6K6ExAlVio=;
        b=pI+H6gOSgQ6beOgPoCSQwzzzHIFWa7zz3b5q4it26ZET9NIIMZV42gKlGYVnZe/4w3
         +ctPsDUieuW8usxO0MBUZmepABppV+fh6wEFqWUuEi++vj7iSFxwe8GVGdH6CXEl9DJN
         YARiIBeKx+ExrDzliSElrlmrc04HpuNJ+yYJz9weDiF4yRyb6QQUopsx0g9/hlaayyVk
         VddHzWyS7RRRZGKnfkhJAkd7E9LECVRpG4NQBeanEJzlXtdeZcObtZws04hMH0nKDMpB
         CY4QiidOt80AxEjDqTBhPOrjvJfSU7YVmK1ejDQAOgslFTOwjXhuev1C1JzI3qhFgrVc
         5G0w==
X-Gm-Message-State: AOJu0YwQKWzGJBUxZOM0VnKrW/hHIHCZWmDgAuv4b+UPTT5hbkGp96Rx
        REWIiCJZz5rb7R26WrYY8Ek=
X-Google-Smtp-Source: AGHT+IGxhTzT8TXN4hkrB/CggwoI9BfAgVK6NaXYMJoWmUypn51PMTBTCXHP1YpiFMAXS8xJGiDJ2Q==
X-Received: by 2002:a50:c058:0:b0:53e:455c:6273 with SMTP id u24-20020a50c058000000b0053e455c6273mr7409252edd.2.1697464892721;
        Mon, 16 Oct 2023 07:01:32 -0700 (PDT)
Received: from localhost (fwdproxy-cln-116.fbsv.net. [2a03:2880:31ff:74::face:b00c])
        by smtp.gmail.com with ESMTPSA id a23-20020a50ff17000000b005342fa19070sm15672646edu.89.2023.10.16.07.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 07:01:32 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        pabeni@redhat.com, martin.lau@linux.dev, krisman@suse.de
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH v7 00/11] io_uring: Initial support for {s,g}etsockopt commands
Date:   Mon, 16 Oct 2023 06:47:38 -0700
Message-Id: <20231016134750.1381153-1-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patchset adds support for getsockopt (SOCKET_URING_OP_GETSOCKOPT)
and setsockopt (SOCKET_URING_OP_SETSOCKOPT) in io_uring commands.
SOCKET_URING_OP_SETSOCKOPT implements generic case, covering all levels
and optnames. SOCKET_URING_OP_GETSOCKOPT is limited, for now, to
SOL_SOCKET level, which seems to be the most common level parameter for
get/setsockopt(2).

In order to keep the implementation (and tests) simple, some refactors
were done prior to the changes, as follows:

Patches 1-2: Make BPF cgroup filters sockptr aware

Patches 3-4: Remove the core {s,g}etsockopt() core function from
__sys_{g,s}etsockopt, so, the code could be reused by other callers, such as
io_uring.

Patch 5: Pass compat mode to the file/socket callbacks

Patch 6-7: Move io_uring helpers from io_uring_zerocopy_tx to a generic
io_uring headers. This simplify the test case (last patch). Also copy the
io_uring UAPI to the tests directory.

Patch 8: Protect io_uring_cmd_sock() to not be called if CONFIG_NET is
disabled.

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
	  disabled.
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

V5 -> V6:
	* Removed the need for #ifdef CONFIG_NET as suggested by Gabriel
	  Krisman.
	* Changed the variable declaration order to respect the reverse
	  xmas declaration as suggested by Paolo Abeni.

V6 -> V7:
	* Changed the optlen back to a value in the SQE instead of
	  user-pointer. This is similar to version 4.
	  [https://lore.kernel.org/all/20231009095518.288a5573@kernel.org/]
	* Imported the io_uring.h into tools/include/uapi/linux to be able to
	  run the tests in machines without liburing.
	  [https://lore.kernel.org/all/77405214-ae42-d58b-1d40-c639683a0cb1@linux.dev/]

Breno Leitao (11):
  bpf: Leverage sockptr_t in BPF getsockopt hook
  bpf: Leverage sockptr_t in BPF setsockopt hook
  net/socket: Break down __sys_setsockopt
  net/socket: Break down __sys_getsockopt
  io_uring/cmd: Pass compat mode in issue_flags
  tools headers: Grab copy of io_uring.h
  selftests/net: Extract uring helpers to be reusable
  io_uring/cmd: return -EOPNOTSUPP if net is disabled
  io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
  io_uring/cmd: Introduce SOCKET_URING_OP_SETSOCKOPT
  selftests/bpf/sockopt: Add io_uring support
Breno Leitao (11):
  bpf: Add sockptr support for getsockopt
  bpf: Add sockptr support for setsockopt
  net/socket: Break down __sys_setsockopt
  net/socket: Break down __sys_getsockopt
  io_uring/cmd: Pass compat mode in issue_flags
  tools headers: Grab copy of io_uring.h
  selftests/net: Extract uring helpers to be reusable
  io_uring/cmd: return -EOPNOTSUPP if net is disabled
  io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
  io_uring/cmd: Introduce SOCKET_URING_OP_SETSOCKOPT
  selftests/bpf/sockopt: Add io_uring support

 include/linux/bpf-cgroup.h                    |   9 +-
 include/linux/io_uring.h                      |   1 +
 include/net/sock.h                            |   6 +-
 include/uapi/linux/io_uring.h                 |   8 +
 io_uring/uring_cmd.c                          |  53 ++
 kernel/bpf/cgroup.c                           |  25 +-
 net/core/sock.c                               |   8 -
 net/socket.c                                  | 103 ++-
 tools/include/io_uring/mini_liburing.h        | 282 +++++++
 tools/include/uapi/linux/io_uring.h           | 757 ++++++++++++++++++
 .../selftests/bpf/prog_tests/sockopt.c        | 113 ++-
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/io_uring_zerocopy_tx.c      | 268 +------
 13 files changed, 1300 insertions(+), 334 deletions(-)
 create mode 100644 tools/include/io_uring/mini_liburing.h
 create mode 100644 tools/include/uapi/linux/io_uring.h

-- 
2.34.1


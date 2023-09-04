Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49E5A791B6B
	for <lists+io-uring@lfdr.de>; Mon,  4 Sep 2023 18:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237318AbjIDQZ1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Sep 2023 12:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbjIDQZ1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Sep 2023 12:25:27 -0400
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642B79D;
        Mon,  4 Sep 2023 09:25:22 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-50078e52537so2714723e87.1;
        Mon, 04 Sep 2023 09:25:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693844720; x=1694449520;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rab+89a7ppccDrPhsU3srYQ+2Bi0KqvP8hKK2Yo3mZY=;
        b=Y12beX/HXkemzNtO4WMLeIdiWWMvWlz5Cojys+Oy7gAlC1oNbV9Xm1AMiDAxU/QF5a
         jOls81AdjBoq+loNs0WjiIjO4iCSR09qBT+eyQtuBEhPn81yM2aRGfRtSH9e4LtW2tSu
         SqdTv5/ME4vfxaelaFfv3w9TXFfxqMgbs4DKMkpj7WkUThE1se/SBQOI0fV9tRkIhxdJ
         a6K/j8C+40z8mFTPHnGcexHtyMy7KwxY81gTaTQvkR2EsxV5BWsJS8yvhCzbC9IVzivh
         n+WGjuC76BLeysYYXZsh7b64lBYMBIOPC8hGjltAl8B/yjNOYce2dv/Ri7sorolnOZC8
         soJQ==
X-Gm-Message-State: AOJu0YyeHKxC1zr6RzAosippql9Vtl5uVp0YGsy6X076eCAn1hY3JAtJ
        VlwJfVj9/ucyIhZsA5hzvm4=
X-Google-Smtp-Source: AGHT+IHb074QO5C12hx+sMgcR3kkjiZTT11rDD49xwqi4n8yKeVoo15uK8eTgDKgEdG9I+1j4x6byw==
X-Received: by 2002:a05:6512:3148:b0:500:79a9:d714 with SMTP id s8-20020a056512314800b0050079a9d714mr5984203lfi.65.1693844719409;
        Mon, 04 Sep 2023 09:25:19 -0700 (PDT)
Received: from localhost (fwdproxy-cln-116.fbsv.net. [2a03:2880:31ff:74::face:b00c])
        by smtp.gmail.com with ESMTPSA id bm26-20020a0564020b1a00b005288f0e547esm6075885edb.55.2023.09.04.09.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 09:25:18 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, martin.lau@linux.dev,
        krisman@suse.de
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH v4 00/10] io_uring: Initial support for {s,g}etsockopt commands
Date:   Mon,  4 Sep 2023 09:24:53 -0700
Message-Id: <20230904162504.1356068-1-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
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

Patches 1-2: Modify the BPF hooks to support sockptr_t, so, these functions
become flexible enough to accept user or kernel pointers for optval/optlen.

Patch 3-4:  Remove the core {s,g}etsockopt() core function from
__sys_{g,s}etsockopt, so, the code could be reused by other callers,
such as io_uring.

Patch 5: Pass compat mode to the file/socket callbacks

Patch 6: Move io_uring helpers from io_uring_zerocopy_tx to a generic
io_uring headers. This simplify the test case (last patch)

Patch 7: Protect io_uring_cmd_sock() to not be called if CONFIG_NET is
disabled.

PS1: For getsockopt command, the optlen field is not a userspace
pointers, but an absolute value, so this is slightly different from
getsockopt(2) behaviour. The new optlen value is returned in cqe->res.

PS2: The userspace pointers need to be alive until the operation is
completed.

These changes were tested with a new test[1] in liburing, LTP sockopt*
tests, as also with bpf/progs/sockopt test case, which is now adapted to
run using both system calls and io_uring commands.

[1] Link: https://github.com/leitao/liburing/blob/getsockopt/test/socket-getsetsock-cmd.c

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
	* Added two SOL_SOCKET tests in bpf/prog_tests/sockopt.c

Breno Leitao (10):
  bpf: Leverage sockptr_t in BPF getsockopt hook
  bpf: Leverage sockptr_t in BPF setsockopt hook
  net/socket: Break down __sys_setsockopt
  net/socket: Break down __sys_getsockopt
  io_uring/cmd: Pass compat mode in issue_flags
  selftests/net: Extract uring helpers to be reusable
  io_uring/cmd: return -EOPNOTSUPP if net is disabled
  io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
  io_uring/cmd: Introduce SOCKET_URING_OP_SETSOCKOPT
  selftests/bpf/sockopt: Add io_uring support

 include/linux/bpf-cgroup.h                    |   9 +-
 include/linux/io_uring.h                      |   1 +
 include/net/sock.h                            |   4 +
 include/uapi/linux/io_uring.h                 |   8 +
 io_uring/uring_cmd.c                          |  55 ++++
 kernel/bpf/cgroup.c                           |  25 +-
 net/core/sock.c                               |   8 -
 net/socket.c                                  | 102 ++++---
 tools/include/io_uring/mini_liburing.h        | 282 ++++++++++++++++++
 .../selftests/bpf/prog_tests/sockopt.c        | 113 ++++++-
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/io_uring_zerocopy_tx.c      | 268 +----------------
 12 files changed, 544 insertions(+), 332 deletions(-)
 create mode 100644 tools/include/io_uring/mini_liburing.h

-- 
2.34.1


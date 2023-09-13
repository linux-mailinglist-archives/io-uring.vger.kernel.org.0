Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9041A79ECCE
	for <lists+io-uring@lfdr.de>; Wed, 13 Sep 2023 17:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbjIMP2H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Sep 2023 11:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjIMP2F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Sep 2023 11:28:05 -0400
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E581BC6;
        Wed, 13 Sep 2023 08:28:01 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-9ad810be221so288255566b.2;
        Wed, 13 Sep 2023 08:28:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694618880; x=1695223680;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XbHM2NAzX89/YGfOI9fGVWUqll7zX9HRYixE0CiaEic=;
        b=amrAmVchPnonggk2kwYDAGcR8vpCvpPC+oz9pw5YpwiTf82Apy7CnxBapFOPJdJIjy
         6m792BQROjRUzYxhR6iYmsPQOKxkk+5HRpLFU6Gdh0wB712bzts9K4XFE1Ya6gPDhJqL
         66wcLm+T+keajbK7pt1fhUrm1GsrZFjxrAeHME0FlD5elx9t2fk9NYrSbMjZMo/NiV2S
         xHmfkd/+BG9CZ1RMtnT279diElrH4otrpczBLwf3U8hnxHotRICsenpUKcEa41C62Sl2
         NRljxSfU9b9gTkYei7CQLgdOxDqS61qP9+20yu/4crqeNdY7q5KIbeZ9ltvob/Tse+Om
         tNSQ==
X-Gm-Message-State: AOJu0YzwyZXy5xcq9SnMEGlWa7NJpFaZG5k7zQmT+cqRKGpd90ILQIvk
        LLsmqMJEv9HpbY/kMmI4EYY=
X-Google-Smtp-Source: AGHT+IFW/YM3vbwQkx6qo2tVcSp414LxDhv6Kd3ehhhK5r6QzI47TnRjUxS/qD4Yz4lM08Q2AZpoOA==
X-Received: by 2002:a17:906:18aa:b0:9a1:c42e:5e5e with SMTP id c10-20020a17090618aa00b009a1c42e5e5emr2354685ejf.42.1694618879486;
        Wed, 13 Sep 2023 08:27:59 -0700 (PDT)
Received: from localhost (fwdproxy-cln-021.fbsv.net. [2a03:2880:31ff:15::face:b00c])
        by smtp.gmail.com with ESMTPSA id dx22-20020a170906a85600b0099d959f9536sm8712216ejb.12.2023.09.13.08.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 08:27:59 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        pabeni@redhat.com, martin.lau@linux.dev, krisman@suse.de
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH v6 0/8] io_uring: Initial support for {s,g}etsockopt commands
Date:   Wed, 13 Sep 2023 08:27:36 -0700
Message-Id: <20230913152744.2333228-1-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patchset adds support for getsockopt (SOCKET_URING_OP_GETSOCKOPT)
and setsockopt (SOCKET_URING_OP_SETSOCKOPT) in io_uring commands.
SOCKET_URING_OP_SETSOCKOPT and SOCKET_URING_OP_GETSOCKOPT implement generic
case, covering all levels and optnames.

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

PS: The userspace pointers need to be alive until the operation is
completed.

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
 io_uring/uring_cmd.c                          |  35 +++
 net/socket.c                                  |  86 ++++--
 tools/include/io_uring/mini_liburing.h        | 292 ++++++++++++++++++
 .../selftests/bpf/prog_tests/sockopt.c        |  95 +++++-
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/io_uring_zerocopy_tx.c      | 268 +---------------
 9 files changed, 490 insertions(+), 303 deletions(-)
 create mode 100644 tools/include/io_uring/mini_liburing.h

-- 
2.34.1


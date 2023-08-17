Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31F2F77F9D4
	for <lists+io-uring@lfdr.de>; Thu, 17 Aug 2023 16:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352210AbjHQO42 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Aug 2023 10:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352491AbjHQO4Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Aug 2023 10:56:24 -0400
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F193D3592;
        Thu, 17 Aug 2023 07:56:08 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-99bf8e5ab39so1048319566b.2;
        Thu, 17 Aug 2023 07:56:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692284167; x=1692888967;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3SQ2mdlJ/zc4OpHFZ3If0GuAfTpQpt1yP+BpEHXI8MY=;
        b=AQq0iF2VMg5/I+Ak/DZq/HpMby7RwpupgIzDtnSz2UmJi+wON31Wa5fgSUUuTRjeMQ
         JQY4qHUdHsqNJxzohrDDqsMV31y7esVT200mpYTZ/JN/QiMnKfDKlGyDHkmQBTFleGwD
         FG8ZlpEKhm/mxupcoEGhjQNRKdX2A8PPnsErGkAGyDld526cZk+Ns/tALVu6Mw4ReiMm
         q1rJQpCYhi5t8YSQ035lL3/FrOUWwUkByjkGk2y/E3nXgbFIcF09k/ChwIeT7JetuXv3
         Uq85XfcMNUlzhDAKNbZoDC/AcQSNoXr+oNBgSB6Mp2ZMQuoPDjI2Sx6AZMQiZSo1gPfT
         Ny/g==
X-Gm-Message-State: AOJu0Yy1wT4KiD9gbsrh0cJzMUsj4qlCJcg+up+Dfuv0p6tHUfSiR/Wj
        a0crVO9ikcnDqHes7IFInmI=
X-Google-Smtp-Source: AGHT+IHWC6ovjf9IAZiRk3LF0fppYKcG2xDzkIn/xXKUECNjYSgjfkL/ElFpHWg5oAIQoR3oQkdkBA==
X-Received: by 2002:a17:907:784b:b0:988:9b29:5653 with SMTP id lb11-20020a170907784b00b009889b295653mr3565597ejc.77.1692284167180;
        Thu, 17 Aug 2023 07:56:07 -0700 (PDT)
Received: from localhost (fwdproxy-cln-020.fbsv.net. [2a03:2880:31ff:14::face:b00c])
        by smtp.gmail.com with ESMTPSA id b21-20020a170906195500b0099df2ddfc37sm2433123eje.165.2023.08.17.07.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Aug 2023 07:56:06 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, martin.lau@linux.dev
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, krisman@suse.de
Subject: [PATCH v3 0/9] io_uring: Initial support for {s,g}etsockopt commands
Date:   Thu, 17 Aug 2023 07:55:45 -0700
Message-Id: <20230817145554.892543-1-leitao@debian.org>
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
and optnames. SOCKET_URING_OP_GETSOCKOPT is limited, for now, to SOL_SOCKET
level, which seems to be the most common level parameter for get/setsockopt(2).

In order to keep the implementation (and tests) simple, some refactors were done
prior to the changes, as follows:

Patches 1-2: Modify the BPF hooks to support sockptr_t, so, these functions
become flexible enough to accept user or kernel pointers for optval/optlen.

Patch 3: Extract the core setsockopt() core function from __sys_setsockopt, so,
the code code could be reused by other callers, such as io_uring.

Patch 4: Pass compat mode to the file/socket callbacks.

Patch 5: Move io_uring helpers from io_uring_zerocopy_tx to a generic io_uring
headers. This simplify the testcase (last patch)

PS1: For getsockopt command, the optlen field is not a userspace
pointers, but an absolute value, so this is slightly different from
getsockopt(2) behaviour. The new optlen value is returned in cqe->res.

PS2: The userspace pointers need to be alive until the operation is
completed.

These changes were tested with a new test[1] in liburing, as also with
bpf/progs/sockopt test case, which is now adapted to run using both system
calls and io_uring commands.

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
	  duplicated code. This removed the requirement to export
	  sock_use_custom_sol_socket() as done in v2.
	* Added io_uring test to selftests/bpf/sockopt.
	* Fixed "compat" argument, by passing it to the issue_flags.

Breno Leitao (9):
  bpf: Leverage sockptr_t in BPF getsockopt hook
  bpf: Leverage sockptr_t in BPF setsockopt hook
  net/socket: Break down __sys_setsockopt
  io_uring/cmd: Pass compat mode in issue_flags
  selftests/net: Extract uring helpers to be reusable
  io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
  io_uring/cmd: Introduce SOCKET_URING_OP_SETSOCKOPT
  io_uring/cmd: BPF hook for getsockopt cmd
  selftests/bpf/sockopt: Add io_uring support

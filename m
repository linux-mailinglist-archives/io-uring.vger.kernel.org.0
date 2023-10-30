Return-Path: <io-uring+bounces-6-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 609EF7DBBE3
	for <lists+io-uring@lfdr.de>; Mon, 30 Oct 2023 15:36:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DA5A4B20A47
	for <lists+io-uring@lfdr.de>; Mon, 30 Oct 2023 14:36:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56D6A182A7;
	Mon, 30 Oct 2023 14:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Oi/FIA2o"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA76179B9
	for <io-uring@vger.kernel.org>; Mon, 30 Oct 2023 14:36:08 +0000 (UTC)
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE33ACC
	for <io-uring@vger.kernel.org>; Mon, 30 Oct 2023 07:36:06 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id ca18e2360f4ac-7a680e6a921so42065639f.1
        for <io-uring@vger.kernel.org>; Mon, 30 Oct 2023 07:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1698676566; x=1699281366; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WRF7KBxEIr5q3m7YS3wnXEuJXgYqEzP+MH/CutDhgt0=;
        b=Oi/FIA2o+5uJifpF/AE2mAOgKZHBd/k2QMnLDavfwhi/465Q8LshJYgI6XseM/R+WR
         8KZCSC4N9Z18g40ypA2Wfck8T1IVo4qH/a3TMcehRk98zishxhEnNfYj8DcjoG7z+G3V
         nUPrAs5G+vD037Ap1L7LEbjHyktqm0FTAgqyzhBfyY6oiQACjPehPhYnMTXB8oPBE4+d
         HSFKEV3gGNh6XqMMnlmVOwUMshcU2RC9BDgA5UkokPPapc8XgAPfHrMzJRACgJYgKW4i
         hAJGVrzmefODu19E2B1vENkJSImTyij7nwkBAcxEnTQxYFf6KBecXmMg+tdxMjCy4I7H
         pxWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698676566; x=1699281366;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WRF7KBxEIr5q3m7YS3wnXEuJXgYqEzP+MH/CutDhgt0=;
        b=oDlUIkrZ9/nyvJB+md0saoNHsYFl8Yq9Xw384iTt/hD1wPgsNwgOZ0+pRc59t17Twp
         J3mVCLNVJSwHPUJ6ijxNCXy3ny06EN69E7JGAtpnaQnxN3YZaxdiuNYbF/U2Uf5ltp5A
         /ITgZ7ljD936vSr6XLCRUmFpQdvy3UTghh42fPBsu1Jo1T4XFmNUvIgJ9Fd0IHIMGD9f
         yVyi/1/VKmR9lC5zy+GDU22rJWTtnZmI+bTO7NOGR4FrYnYv6ucAl7I2pyR/IBz8w+/d
         KmysJaHK15sM9Z3YfjjwxseHwATAcmtWzxnA6/njIegFkeqMBIq/+IpAHAnVQ4rdwkC3
         TfoQ==
X-Gm-Message-State: AOJu0YwJX/9ZkfKQW0z5RwdHJj8aSnxLTyot4fGP38+htMdxrTyx7zFU
	zeAdTP6qgX28OG6Du96JumNtyRC4B0sm9aJl8SsxrQ==
X-Google-Smtp-Source: AGHT+IGp4SAo0gHbOV4Z1SWgnbYAOANapzL+PoJVVlvKzi7CWV1F9WGf0pDKi4LNyW+Sq6Fu9bQMXw==
X-Received: by 2002:a05:6e02:3212:b0:34e:2a69:883c with SMTP id cd18-20020a056e02321200b0034e2a69883cmr12883918ilb.1.1698676566293;
        Mon, 30 Oct 2023 07:36:06 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 20-20020a0566380a5400b0042b03d40279sm2187636jap.80.2023.10.30.07.36.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Oct 2023 07:36:05 -0700 (PDT)
Message-ID: <7a0893f0-bae8-4aee-9e05-7c81354fc829@kernel.dk>
Date: Mon, 30 Oct 2023 08:36:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
 Breno Leitao <leitao@debian.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring support for get/setsockopt
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

On top of the core io_uring changes, this pull request adds support for
using getsockopt and setsockopt via io_uring. The main use cases for
this is to enable use of direct descriptors, rather than first
instantiating a normal file descriptor, doing the option tweaking
needed, then turning it into a direct descriptor. With this support, we
can avoid needing a regular file descriptor completely.

The net and bpf bits have been signed off on their side.

Please pull!


The following changes since commit 6ce4a93dbb5bd93bc2bdf14da63f9360a4dcd6a1:

  io_uring/poll: use IOU_F_TWQ_LAZY_WAKE for wakeups (2023-10-19 06:42:29 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.7/io_uring-sockopt-2023-10-30

for you to fetch changes up to b9ec913212e6e91efa5a0a612c4a8ec4cf5da896:

  selftests/bpf/sockopt: Add io_uring support (2023-10-19 16:42:04 -0600)

----------------------------------------------------------------
for-6.7/io_uring-sockopt-2023-10-30

----------------------------------------------------------------
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

 include/linux/bpf-cgroup.h                         |   9 +-
 include/linux/io_uring.h                           |   1 +
 include/net/sock.h                                 |   6 +-
 include/uapi/linux/io_uring.h                      |   8 +
 io_uring/uring_cmd.c                               |  53 ++
 kernel/bpf/cgroup.c                                |  25 +-
 net/core/sock.c                                    |   8 -
 net/socket.c                                       | 104 ++-
 tools/include/io_uring/mini_liburing.h             | 282 ++++++++
 tools/include/uapi/linux/io_uring.h                | 757 +++++++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/sockopt.c   | 113 ++-
 tools/testing/selftests/net/Makefile               |   1 +
 tools/testing/selftests/net/io_uring_zerocopy_tx.c | 268 +-------
 13 files changed, 1301 insertions(+), 334 deletions(-)
 create mode 100644 tools/include/io_uring/mini_liburing.h
 create mode 100644 tools/include/uapi/linux/io_uring.h

-- 
Jens Axboe



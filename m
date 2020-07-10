Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2188621B83C
	for <lists+io-uring@lfdr.de>; Fri, 10 Jul 2020 16:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgGJOUF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jul 2020 10:20:05 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:60838 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727818AbgGJOUD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jul 2020 10:20:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594390801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=S/hfdY2jn078JPQClgP6PouoRBDjiWkYV+fASuPUqJA=;
        b=Vlpha8W+gfVSUDC8sJdYzNMYLSJbDGwtrnPJ1dIvei+SFgUNTxb/9rQJ7/2dDegtVprlf6
        Cn9TVwZF+8TgvegnCilmVTSlqK9NxdGE/1QUt2EDDlSLbGeZRHvzpEeMvRAX+Xgib02tdR
        XO8q0aTjWi+KGitg8Bt04X1daD5hBjA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-Ur_35eYIO8ykayRn1yNGQw-1; Fri, 10 Jul 2020 10:19:57 -0400
X-MC-Unique: Ur_35eYIO8ykayRn1yNGQw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 128B11B18BC0;
        Fri, 10 Jul 2020 14:19:55 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-112-4.ams2.redhat.com [10.36.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF67B5C1D6;
        Fri, 10 Jul 2020 14:19:46 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Sargun Dhillon <sargun@sargun.me>,
        Kees Cook <keescook@chromium.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Jann Horn <jannh@google.com>, Aleksa Sarai <asarai@suse.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        io-uring@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH RFC 0/3] io_uring: add restrictions to support untrusted
 applications and guests
Date:   Fri, 10 Jul 2020 16:19:42 +0200
Message-Id: <20200710141945.129329-1-sgarzare@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Following the proposal that I send about restrictions [1], I wrote a PoC with
the main changes. It is still WiP so I left some TODO in the code.

I also wrote helpers in liburing and a test case (test/register-restrictions.c)
available in this repository:
https://github.com/stefano-garzarella/liburing (branch: io_uring_restrictions)

Just to recap the proposal, the idea is to add some restrictions to the
operations (sqe, register, fixed file) to safely allow untrusted applications
or guests to use io_uring queues.

The first patch changes io_uring_register(2) opcodes into an enumeration to
keep track of the last opcode available.

The second patch adds IOURING_REGISTER_RESTRICTIONS opcode and the code to
handle restrictions.

The third patch adds IORING_SETUP_R_DISABLED flag to start the rings disabled,
allowing the user to register restrictions, buffers, files, before to start
processing SQEs.
I'm not sure if this could help seccomp. An alternative pointed out by Jann
Horn could be to register restrictions during io_uring_setup(2), but this
requires some intrusive changes (there is no space in the struct
io_uring_params to pass a pointer to restriction arrays, maybe we can add a
flag and add the pointer at the end of the struct io_uring_params).

Another limitation now is that I need to enable every time
IORING_REGISTER_ENABLE_RINGS in the restrictions to be able to start the rings,
I'm not sure if we should treat it as an exception.

Maybe registering restrictions during io_uring_setup(2) could solve both issues
(seccomp integration and IORING_REGISTER_ENABLE_RINGS registration), but I need
some suggestions to properly extend the io_uring_setup(2).

Comments and suggestions are very welcome.

Thank you in advance,
Stefano

[1] https://lore.kernel.org/io-uring/20200609142406.upuwpfmgqjeji4lc@steredhat/

Stefano Garzarella (3):
  io_uring: use an enumeration for io_uring_register(2) opcodes
  io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
  io_uring: allow disabling rings during the creation

 fs/io_uring.c                 | 155 ++++++++++++++++++++++++++++++++--
 include/uapi/linux/io_uring.h |  59 ++++++++++---
 2 files changed, 194 insertions(+), 20 deletions(-)

-- 
2.26.2


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39906230EA5
	for <lists+io-uring@lfdr.de>; Tue, 28 Jul 2020 18:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731176AbgG1QB2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jul 2020 12:01:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28639 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731212AbgG1QBZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jul 2020 12:01:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595952084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=0fc1uAttsGy8w1em246ZebEdbW8vUt+X7/u6oIFpaS0=;
        b=MTBCNFvUe4/uZ7qwXhVRKam7rtDay6GM224dcpEZLVunXzTwdum6/JzbJyqnSMT0veqh2y
        IL6X1W2rkG5QCH7OJeZIo6m2bkCpZZVKlEHvVFtbsMDQ+uk4p608/pSxckv3hy7De4or1Z
        /X2hK36HTXr4nXBWu86CWOb1O72b85w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-JNkooa47PDmLLs1bZyICfw-1; Tue, 28 Jul 2020 12:01:20 -0400
X-MC-Unique: JNkooa47PDmLLs1bZyICfw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9CCA419200D5;
        Tue, 28 Jul 2020 16:01:18 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-112-109.ams2.redhat.com [10.36.112.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C1C475D9CD;
        Tue, 28 Jul 2020 16:01:02 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Jeff Moyer <jmoyer@redhat.com>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aleksa Sarai <asarai@suse.de>,
        Sargun Dhillon <sargun@sargun.me>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>
Subject: [PATCH v3 0/3] io_uring: add restrictions to support untrusted
 applications and guests
Date:   Tue, 28 Jul 2020 18:00:58 +0200
Message-Id: <20200728160101.48554-1-sgarzare@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

v3:
 - added IORING_RESTRICTION_SQE_FLAGS_ALLOWED and
   IORING_RESTRICTION_SQE_FLAGS_REQUIRED
 - removed IORING_RESTRICTION_FIXED_FILES_ONLY opcode
 - enabled restrictions only when the rings start

RFC v2: https://lore.kernel.org/io-uring/20200716124833.93667-1-sgarzare@redhat.com

RFC v1: https://lore.kernel.org/io-uring/20200710141945.129329-1-sgarzare@redhat.com

Following the proposal that I send about restrictions [1], I wrote this series
to add restrictions in io_uring.

I also wrote helpers in liburing and a test case (test/register-restrictions.c)
available in this repository:
https://github.com/stefano-garzarella/liburing (branch: io_uring_restrictions)

Just to recap the proposal, the idea is to add some restrictions to the
operations (sqe opcode and flags, register opcode) to safely allow untrusted
applications or guests to use io_uring queues.

The first patch changes io_uring_register(2) opcodes into an enumeration to
keep track of the last opcode available.

The second patch adds IOURING_REGISTER_RESTRICTIONS opcode and the code to
handle restrictions.

The third patch adds IORING_SETUP_R_DISABLED flag to start the rings disabled,
allowing the user to register restrictions, buffers, files, before to start
processing SQEs.

Comments and suggestions are very welcome.

Thank you in advance,
Stefano

[1] https://lore.kernel.org/io-uring/20200609142406.upuwpfmgqjeji4lc@steredhat/

Stefano Garzarella (3):
  io_uring: use an enumeration for io_uring_register(2) opcodes
  io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
  io_uring: allow disabling rings during the creation

 fs/io_uring.c                 | 167 ++++++++++++++++++++++++++++++++--
 include/uapi/linux/io_uring.h |  60 +++++++++---
 2 files changed, 207 insertions(+), 20 deletions(-)

-- 
2.26.2


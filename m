Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB09425481B
	for <lists+io-uring@lfdr.de>; Thu, 27 Aug 2020 16:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgH0O67 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Aug 2020 10:58:59 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35884 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728039AbgH0O6r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Aug 2020 10:58:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598540323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=hzfczoY08KCAOXrJ4QPUBcOl3kLlAqwyM9dLVlxgAlg=;
        b=XUB4mNqpQVGX1lJOTw7ArMwptRJKdM8lobpXI/acVB9WOQX4mUptM1HhIKECvN5IoS89nq
        DstFmxawp/RVa/5fEgiICJWEsvkK2pRX+xRBQNF/gRoZ0T0Aj0h6rze2JZlFLVGIdCkZyN
        8nXnCITRriEBwucli6TqjO6JeO3NQEE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-OgZhy-oMOZaq0ggeHWE2Pg-1; Thu, 27 Aug 2020 10:58:41 -0400
X-MC-Unique: OgZhy-oMOZaq0ggeHWE2Pg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85FA08018A4;
        Thu, 27 Aug 2020 14:58:39 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-96.ams2.redhat.com [10.36.113.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D6495C1C2;
        Thu, 27 Aug 2020 14:58:32 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
        Aleksa Sarai <asarai@suse.de>,
        Sargun Dhillon <sargun@sargun.me>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: [PATCH v6 0/3] io_uring: add restrictions to support untrusted
 applications and guests
Date:   Thu, 27 Aug 2020 16:58:28 +0200
Message-Id: <20200827145831.95189-1-sgarzare@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

v6:
 - moved restriction checks in a function [Jens]
 - changed ret value handling in io_register_restrictions() [Jens]

v5: https://lore.kernel.org/io-uring/20200827134044.82821-1-sgarzare@redhat.com/
v4: https://lore.kernel.org/io-uring/20200813153254.93731-1-sgarzare@redhat.com/
v3: https://lore.kernel.org/io-uring/20200728160101.48554-1-sgarzare@redhat.com/
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

 fs/io_uring.c                 | 172 ++++++++++++++++++++++++++++++++--
 include/uapi/linux/io_uring.h |  60 +++++++++---
 2 files changed, 215 insertions(+), 17 deletions(-)

-- 
2.26.2


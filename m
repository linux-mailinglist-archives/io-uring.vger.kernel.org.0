Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B10243C8E
	for <lists+io-uring@lfdr.de>; Thu, 13 Aug 2020 17:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgHMPdr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Aug 2020 11:33:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56115 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726730AbgHMPdq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Aug 2020 11:33:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597332825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=U+DZxetMKI4jVQKv/cLX0z4HNCC6l+3oyJGtLYHcX8o=;
        b=XAWewq3B9ffElLPLK8aqXEdtA0lEYNv0TEcNPEvzuPpuKkqxxXovnF9IBkamQqxqnwOH5d
        vbaiYgvvqm0SkxTxkI0w1i/SA50l6SAEi0TPTa0z0WXMiD5c3dNd4H8VCRVQTV4MerO89+
        qCIVor4oyVizlmurC+dje/EROwsSDUU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-rFiyPInxM7CpmkqnLbRD4g-1; Thu, 13 Aug 2020 11:33:19 -0400
X-MC-Unique: rFiyPInxM7CpmkqnLbRD4g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDC1910060C3;
        Thu, 13 Aug 2020 15:33:17 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-140.ams2.redhat.com [10.36.113.140])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3F4360C04;
        Thu, 13 Aug 2020 15:33:02 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
        linux-fsdevel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Aleksa Sarai <asarai@suse.de>,
        io-uring@vger.kernel.org
Subject: [PATCH v4 0/3] io_uring: add restrictions to support untrusted
 applications and guests
Date:   Thu, 13 Aug 2020 17:32:51 +0200
Message-Id: <20200813153254.93731-1-sgarzare@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

v4:
 - rebased on top of io_uring-5.9
 - fixed io_uring_enter() exit path when ring is disabled

v3: https://lore.kernel.org/io-uring/20200728160101.48554-1-sgarzare@redhat.c=
om/
RFC v2: https://lore.kernel.org/io-uring/20200716124833.93667-1-sgarzare@redh=
at.com
RFC v1: https://lore.kernel.org/io-uring/20200710141945.129329-1-sgarzare@red=
hat.com

Following the proposal that I send about restrictions [1], I wrote this series
to add restrictions in io_uring.

I also wrote helpers in liburing and a test case (test/register-restrictions.=
c)
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

[1] https://lore.kernel.org/io-uring/20200609142406.upuwpfmgqjeji4lc@steredha=
t/

Stefano Garzarella (3):
  io_uring: use an enumeration for io_uring_register(2) opcodes
  io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
  io_uring: allow disabling rings during the creation

 fs/io_uring.c                 | 160 ++++++++++++++++++++++++++++++++--
 include/uapi/linux/io_uring.h |  60 ++++++++++---
 2 files changed, 203 insertions(+), 17 deletions(-)

--=20
2.26.2


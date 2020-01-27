Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD07714A7E9
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2020 17:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729735AbgA0QRK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 11:17:10 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54491 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729505AbgA0QRJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 11:17:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580141828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NPHIDBHIHn19+j0f45CcKBBFeX5G7EU5YQsaBeUB+i0=;
        b=gTtanwRKWQ6Crq1Pv7qo/v0+Q05D2TtA5rTm8wmnVjp+dMGOPLTHUCtRUnLihENvXmyYNg
        LkQV1tKfiGm7YVfQy2K6bCIQ3TAfhvq7vChTMX7qwg+fe0XahVdf6oD3clXyffKj9w7vtz
        aAp8v1X0nixqXkGyTkIZc9LOGWMgdG4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-q64UPdiXOzamvKKWjkGniw-1; Mon, 27 Jan 2020 11:17:03 -0500
X-MC-Unique: q64UPdiXOzamvKKWjkGniw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2E85108597A;
        Mon, 27 Jan 2020 16:17:02 +0000 (UTC)
Received: from steredhat.redhat.com (unknown [10.43.2.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C84288832;
        Mon, 27 Jan 2020 16:17:01 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH liburing 0/1] test: add epoll test case
Date:   Mon, 27 Jan 2020 17:17:00 +0100
Message-Id: <20200127161701.153625-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,
I wrote the test case for epoll.

Since it fails also without sqpoll (Linux 5.4.13-201.fc31.x86_64),
can you take a look to understand if the test is wrong?

Tomorrow I'll travel, but on Wednesday I'll try this test with the patch
that I sent and also with the upstream kernel.

Thanks,
Stefano

Stefano Garzarella (1):
  test: add epoll test case

 .gitignore    |   1 +
 test/Makefile |   5 +-
 test/epoll.c  | 307 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 311 insertions(+), 2 deletions(-)
 create mode 100644 test/epoll.c

--=20
2.24.1


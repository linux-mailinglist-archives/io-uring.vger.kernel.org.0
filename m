Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDC71DA42B
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2020 23:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725998AbgESV6U (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 May 2020 17:58:20 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54727 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725885AbgESV6T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 May 2020 17:58:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589925498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=6hfGJBDits8dEf1jDzo78leH9mA3RNXGA7WhYwfYSwU=;
        b=Mii/iDOJ/o2wn7tGYJvoyAXknIjSJTwtZI9OPmWLkbJ64b+5wYddTHsNn94M0mly0/1k4G
        mwCvDBqDlcT07qZqMgsXAN0S6PvtYnuxnRvGKW8P+845y9Q21MS53ixvf0gu6hh1uWQlIU
        z8Pkg9gCa5WU/X4Q0xPrDi2fWL5h7ec=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-Ce9D1wSAMqujz9aVoRpR3g-1; Tue, 19 May 2020 17:58:16 -0400
X-MC-Unique: Ce9D1wSAMqujz9aVoRpR3g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13C061009460;
        Tue, 19 May 2020 21:58:15 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 86C795C1D4;
        Tue, 19 May 2020 21:58:14 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: liburing 500f9fbadef8-test test failure on top-of-tree
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Tue, 19 May 2020 17:58:13 -0400
Message-ID: <x49d06zd1u2.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This test case is failing for me when run atop a dm device.  The test
sets up a ring with IO_SETUP_IOPOLL, creates a file and opens it with
O_DIRECT, and then issues a writev.  The writev operation is returning
-22 (-EINVAL).  The failure comes from this check inside io_import_iov:

	/* buffer index only valid with fixed read/write, or buffer select  */
        if (req->rw.kiocb.private && !(req->flags & REQ_F_BUFFER_SELECT))
                return -EINVAL;

req->rw.kiocb.private is being used by the iomap code to store a pointer
to the request queue.  The sequence of events is as follows:

io_write is called in the context of the system call, it calls
call_write_iter, which returns -EAGAIN.  The I/O is punted to a
workqueue.

The work item then tries to issue the I/O after clearing IOCB_NOWAIT,
and for some reason fails again with -EAGAIN.

On the *third* call to io_write, the private pointer has been
overwitten, and we trigger the above -EINVAL return.

I have no idea why we're getting EAGAIN on the first call in the
workqueue context, so I'm not sure if that's the problem, of if we
simply can't use the kiocb.private pointer for this purpose.  It seems
clear that once we've called into the iomap code, we can't rely on the
contents of kiocb.private.

Jens, what do you think?

-Jeff


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C041CC90A
	for <lists+io-uring@lfdr.de>; Sun, 10 May 2020 10:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgEJIAm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 May 2020 04:00:42 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22713 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726321AbgEJIAm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 May 2020 04:00:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589097641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=DGbJ2kfZ4c+0JwYrD2lo2jh2OWRT/B1FkLV9ZED4Yf4=;
        b=CV6mBCeAttPP205AVxlirF/TsrCVN1bcg99LBcW5pM4rMRKtGEzotztvkE57CSUsd1tYmZ
        AbN8LMoiddqMnvTFjvWjWUYdmHt+8951oNLW3WJg3bofahNYoypkx8J5uFT+qMChY+umoH
        8Jos8iKuGRn6ACmU67XBpuwIQO16IFY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-e3AV0qG0OXqi6rTIpldJTQ-1; Sun, 10 May 2020 04:00:37 -0400
X-MC-Unique: e3AV0qG0OXqi6rTIpldJTQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CA158015CE
        for <io-uring@vger.kernel.org>; Sun, 10 May 2020 08:00:36 +0000 (UTC)
Received: from localhost (ovpn-112-30.ams2.redhat.com [10.36.112.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8BA71001925
        for <io-uring@vger.kernel.org>; Sun, 10 May 2020 08:00:35 +0000 (UTC)
Date:   Sun, 10 May 2020 09:00:34 +0100
From:   "Richard W.M. Jones" <rjones@redhat.com>
To:     io-uring@vger.kernel.org
Subject: Questions about usage of io-uring in a network application
Message-ID: <20200510080034.GI3888@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hopefully these questions are not too stupid, but I didn't find any
answers looking over the archives of this list or in the io_uring.pdf
document.

I have an existing C library which is the client part of a
client/server network service.  It's not exactly the same as HTTP, but
it could be thought of as like an HTTP network client where we may
hold a few separate TCP/IP connections open to the same server, and we
issue multiple requests in flight per TCP connection.  There is one
pthread per TCP connection usually.

I want to try to see if io_uring gives us any performance benefit by
seeing if we can use IORING_OP_SENDMSG/IORING_OP_RECVMSG +
IOSQE_IO_LINK, as an experiment.


(1) How many io_urings should we create?

One ring per process?  All of the connections share the same ring.
Presumably there would be a lot of contention because I suppose we'd
need to lock the ring while submitting requests from multiple threads.
If there are multiple independent libraries or separate of the program
all trying to use io_uring, should they try to share a single ring?

One ring per pthread?  It seems we could implement this without locks
using thread-local storage to hold the the io_uring fd.

One ring per physical CPU?  (Not sure how to implement this race-free
in userspace).

One ring per TCP connection?


(2) The existing API (which we cannot change) takes user-allocated
buffers for the data to read/write.  We don't know if these were
allocated using malloc, they might be statically allocated or even
come from something exotic like mmap of a file.  I understand that we
cannot register these buffers using IORING_REGISTER_BUFFERS.  But can
these be passed in the io_uring_sqe->addr field?  ie. Do the same
restrictions in IORING_REGISTER_BUFFERS also apply to the addr field?


Thanks,
Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-p2v converts physical machines to virtual machines.  Boot with a
live CD or over the network (PXE) and turn machines into KVM guests.
http://libguestfs.org/virt-v2v


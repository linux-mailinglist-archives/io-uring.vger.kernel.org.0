Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464DD266264
	for <lists+io-uring@lfdr.de>; Fri, 11 Sep 2020 17:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgIKPpf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Sep 2020 11:45:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28903 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726506AbgIKPpX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Sep 2020 11:45:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599839122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=km+FzpMDMUl1+KOAqJz8eNRM7mE9gcgaHkUuiY2+brw=;
        b=b4rDz/Qn5CpgLivkiRAHIPFVyEdUlVcg7f3pLxsosWuZRSfbFnnLRKYjDTE6OyLrJmGxTn
        kXA6SAoqPEXeE/5GzPVRF+f0PZxnOgH/ru2IN6YVhyIkYSjN3SrAO5yp6McSZ/pFwJVWGC
        46R160MNMpLjKz1K4Cfcouwea6Knw7c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-F64GRIynMPaUw9byndbO2w-1; Fri, 11 Sep 2020 09:34:11 -0400
X-MC-Unique: F64GRIynMPaUw9byndbO2w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4793B801AB9;
        Fri, 11 Sep 2020 13:34:10 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-89.ams2.redhat.com [10.36.114.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 791375D9E8;
        Fri, 11 Sep 2020 13:34:09 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: [PATCH liburing 0/3] Add restrictions stuff in the man pages
Date:   Fri, 11 Sep 2020 15:34:05 +0200
Message-Id: <20200911133408.62506-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,
this series adds description of restrictions, how to enable io_uring
ring, and related errors in the man pages.
The patches are also available here:

https://github.com/stefano-garzarella/liburing (branch: restrictions-man-pages)

I didn't put the details of struct io_uring_restriction and
IORING_RESTRICTION_* op codes.
Do you think I should put the definition of the structure and opcodes in
man/io_uring_register.2?

I know I'm not very good at writing documentation, so tell me what to change
or write better ;-)

Thanks,
Stefano

Stefano Garzarella (3):
  man/io_uring_setup.2: add IORING_SETUP_R_DISABLED description
  man/io_uring_register.2: add description of restrictions
  man/io_uring_enter.2: add EACCES and EBADFD errors

 man/io_uring_enter.2    | 18 ++++++++++
 man/io_uring_register.2 | 79 +++++++++++++++++++++++++++++++++++++++--
 man/io_uring_setup.2    |  7 ++++
 3 files changed, 102 insertions(+), 2 deletions(-)

-- 
2.26.2


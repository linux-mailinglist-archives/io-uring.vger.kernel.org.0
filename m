Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2CD27CF07
	for <lists+io-uring@lfdr.de>; Tue, 29 Sep 2020 15:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbgI2NXq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Sep 2020 09:23:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28094 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729906AbgI2NXq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Sep 2020 09:23:46 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601385825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=MtXlOll3j/uXmEn4qkjIpbCwwx4F2e2lW9m/qZTwc5Q=;
        b=XAl7zUa8yGeTG4pFPHHngf/8uDbQ1PP/igWtNEWFf1raN0YplU2ws0LVkOwmnrmhr0za3P
        Nfk77v2F3dm3jfvea0QSxgVi0JYFmvOJyFKQTYrVNBE1NE5a9OUaRM/EUkAHB535BLL0hH
        oCFBjXcmaG04lv6dsceGQ6Pa+6aOF6E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-dGkxXLtENjulM6-NfePb9g-1; Tue, 29 Sep 2020 09:23:42 -0400
X-MC-Unique: dGkxXLtENjulM6-NfePb9g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A5EB10BBEC8;
        Tue, 29 Sep 2020 13:23:41 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-58.ams2.redhat.com [10.36.114.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2D7361983;
        Tue, 29 Sep 2020 13:23:40 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: [PATCH liburing v2 0/3] Add restrictions stuff in the man pages
Date:   Tue, 29 Sep 2020 15:23:36 +0200
Message-Id: <20200929132339.45710-1-sgarzare@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,
this series adds description of restrictions, how to enable io_uring
ring, and related errors in the man pages.
The patches are also available here:

https://github.com/stefano-garzarella/liburing (branch: restrictions-man-pages)

v2:
  - rebased on master after the split of ERRORS section in man/io_uring_enter.2
  - Patch 2: fixed grammar issues [Jens]
  - Patch 3: put the errors in right section

v1: https://lore.kernel.org/io-uring/20200911133408.62506-1-sgarzare@redhat.com

Thanks,
Stefano

Stefano Garzarella (3):
  man/io_uring_setup.2: add IORING_SETUP_R_DISABLED description
  man/io_uring_register.2: add description of restrictions
  man/io_uring_enter.2: add EACCES and EBADFD errors

 man/io_uring_enter.2    | 17 +++++++++
 man/io_uring_register.2 | 79 +++++++++++++++++++++++++++++++++++++++--
 man/io_uring_setup.2    |  7 ++++
 3 files changed, 101 insertions(+), 2 deletions(-)

-- 
2.26.2


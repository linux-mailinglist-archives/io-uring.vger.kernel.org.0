Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1B623FD01
	for <lists+io-uring@lfdr.de>; Sun,  9 Aug 2020 08:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgHIGau (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 9 Aug 2020 02:30:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52787 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725988AbgHIGau (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 9 Aug 2020 02:30:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596954649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2qDBS5d6Q0gEY+bHXuulW7mVau/4p+SJT0xaNESHjYc=;
        b=BRP6ultZHAUgfz6w2RsX6l4aFGTcpMVroD0bS1cB9+2bRRiQRBmH+jvvlgmYYFpN4g5Phv
        cWpwlQvjLA2whZhL4Q04uQMVm3mW9xLkJe4FRvVvNB9VqsOlhS84a5RbICKEOu0BG5dn3c
        CRhTW+vGLRZXlcOFJiLVg948UD3EoR4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-pbfF6HrCM_2ePmjdxPuwkQ-1; Sun, 09 Aug 2020 02:30:47 -0400
X-MC-Unique: pbfF6HrCM_2ePmjdxPuwkQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1CC0480183C;
        Sun,  9 Aug 2020 06:30:46 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-12-33.pek2.redhat.com [10.72.12.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 886731C4;
        Sun,  9 Aug 2020 06:30:44 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     io-uring@vger.kernel.org, jmoyer@redhat.com
Subject: [PATCH v2 0/4] fsstress,fsx: add io_uring test and do some fix
Date:   Sun,  9 Aug 2020 14:30:36 +0800
Message-Id: <20200809063040.15521-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patchset tries to add new IO_URING test into fsstress [1/4] and fsx [4/4].
And then do some changes and bug fix by the way [2/4 and 3/4].

fsstress and fsx are important tools in xfstests to do filesystem I/Os test,
lots of test cases use it. So add IO_URING operation into fsstress and fsx
will help to cover IO_URING test from fs side.

I'm not an IO_URING expert, so cc io-uring@ list, please feel free to
tell me if you find something wrong or have any suggestions to improve
the test.

V2 did below changes:
1) 1/4 change the definition of URING_ENTRIES to 1
2) 2/4 change the difinition of AIO_ENTRIES to 1, undo an unrelated changed line
3) 4/4 turn to use io_uring_prep_readv/io_uring_prep_writev, due to old
       liburing(0.2-2) doesn't support io_uring_prep_read/io_uring_prep_write.

Thanks,
Zorro




Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906EC25EF64
	for <lists+io-uring@lfdr.de>; Sun,  6 Sep 2020 19:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbgIFRz0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Sep 2020 13:55:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29490 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726209AbgIFRzY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Sep 2020 13:55:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599414922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=i2fzJoK/5rqCoc2fDEyi/R2ZRblVt7u5wMJFb4+7B7o=;
        b=GfmiETTKweqYf4XtrYBWBiHMor6Qe/QjGPeynViHSY76/sPmfvpFyHKXAN+5VNgFPcYDcO
        HJFEA5zM5ZX6eA/NPItRadrMjIhxQW43UQHTvCsdriffsleSDIg07b2oAxf4kXISeVTbLL
        BIAdzD0URnKMJqozHyjELzbQa0wqW6M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-5t8XIlnpNOq0G76iEUrC5g-1; Sun, 06 Sep 2020 13:55:18 -0400
X-MC-Unique: 5t8XIlnpNOq0G76iEUrC5g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F765802B5C;
        Sun,  6 Sep 2020 17:55:17 +0000 (UTC)
Received: from bogon.redhat.com (ovpn-12-98.pek2.redhat.com [10.72.12.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCF589CBA;
        Sun,  6 Sep 2020 17:55:15 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     bfoster@redhat.com, io-uring@vger.kernel.org
Subject: [PATCH v4 0/5] fsstress,fsx: add io_uring test and do some fix
Date:   Mon,  7 Sep 2020 01:55:08 +0800
Message-Id: <20200906175513.17595-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patchset tries to add new IO_URING test into fsstress [1/5] and fsx
[4/5 and 5/5]. And then do some changes and bug fix by the way [2/5 and 3/5].

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

V3 changed io_uring_submit(&ring) to io_uring_submit_and_wait(&ring, 1). I'm
not sure if this's the real mean of Jens Axboe's review point, please check.
  https://marc.info/?l=fstests&m=159811932808057&w=2

V4 did below changes:
1) 1/5 change the "goto" related code of do_uring_rw()
2) 3/5 similar change as above
3) 4/5 new patch, separated from original 4/4 patch
3) 5/5 change #elif to #else
4) 5/5 change __uring_rw to uring_rw.
5) 5/5 change the loop logic in uring_rw().

Thanks for Brian's review points.

Thanks,
Zorro




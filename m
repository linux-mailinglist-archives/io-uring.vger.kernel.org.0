Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD08724EBD1
	for <lists+io-uring@lfdr.de>; Sun, 23 Aug 2020 08:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725648AbgHWGap (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Aug 2020 02:30:45 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51718 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725771AbgHWGap (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Aug 2020 02:30:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598164243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sS28LezY+j684F/FAJU1lZqJ92idSz1MMbcwM9ODCXg=;
        b=TFafd/FF9Z263X+mQDqgsbK2fIzbKlOK6/Gl7m4krtZzhXerzFrudBgjUWQaWqv4s7Fob5
        Dkd5S8TNN08uHFHvtumU/BG9LvlwZLpk6W+M9ivILOSKBeQoGWGTcNCfyqmX8uJJHBEkpU
        uQiNMDgQdzsvJWz38HtIfxnDLRn20mA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-0JD-FRMHOQapgFQS43AeQA-1; Sun, 23 Aug 2020 02:30:39 -0400
X-MC-Unique: 0JD-FRMHOQapgFQS43AeQA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DE34425CD;
        Sun, 23 Aug 2020 06:30:38 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-12-77.pek2.redhat.com [10.72.12.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A095460F96;
        Sun, 23 Aug 2020 06:30:36 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: [PATCH v3 0/4] fsstress,fsx: add io_uring test and do some fix
Date:   Sun, 23 Aug 2020 14:30:28 +0800
Message-Id: <20200823063032.17297-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

V3 changed io_uring_submit(&ring) to io_uring_submit_and_wait(&ring, 1). I'm
not sure if this's the real mean of Jens Axboe's review point, please check.
  https://marc.info/?l=fstests&m=159811932808057&w=2

Thanks,
Zorro




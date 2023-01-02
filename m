Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F273165B4CE
	for <lists+io-uring@lfdr.de>; Mon,  2 Jan 2023 17:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236472AbjABQJv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Jan 2023 11:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236448AbjABQJt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Jan 2023 11:09:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0028EAE72
        for <io-uring@vger.kernel.org>; Mon,  2 Jan 2023 08:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672675744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QOMPjn0dUYaEDmDsmFebFjuVPC7wNzFHjtW1BGxF+HA=;
        b=MLDb9UYh3B9YsOCV5Sxht+FKmyeOcv9dqRycd/n1nd7u7KlJ5vOWy20d3uKAv/WIcY7hTq
        LFTXaYVqan6+o/sSl9D5kpBrCk08SVYAHyKB9xOG4qpnhyVp764ZZJhHvBH0N6a/NKwi8p
        qcbPUTFGWI2DVWyu2IxvaodZQC+mDdM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-513-HJLq6KMLO_-iX_0gFzvgfQ-1; Mon, 02 Jan 2023 11:09:01 -0500
X-MC-Unique: HJLq6KMLO_-iX_0gFzvgfQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4FD8318A6460;
        Mon,  2 Jan 2023 16:09:00 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.193.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF57C51E5;
        Mon,  2 Jan 2023 16:08:57 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Pitre <nico@fluxnic.net>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH mm-unstable v1 0/3] mm/nommu: don't use VM_MAYSHARE for MAP_PRIVATE mappings
Date:   Mon,  2 Jan 2023 17:08:53 +0100
Message-Id: <20230102160856.500584-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Trying to reduce the confusion around VM_SHARED and VM_MAYSHARE first
requires !CONFIG_MMU to stop using VM_MAYSHARE for MAP_PRIVATE mappings.
CONFIG_MMU only sets VM_MAYSHARE for MAP_SHARED mappings.

This paves the way for further VM_MAYSHARE and VM_SHARED cleanups: for
example, renaming VM_MAYSHARED to VM_MAP_SHARED to make it cleaner what
is actually means.

Let's first get the weird case out of the way and not use VM_MAYSHARE in
MAP_PRIVATE mappings, using a new VM_MAYOVERLAY flag instead.

I am not a NOMMU expert, but my basic testing with risc64-nommu with
buildroot under QEMU revealed no surprises.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>

RFC -> v1:
* Rebased, retested
* "drivers/misc/open-dice: don't touch VM_MAYSHARE"
 -> Added; as VM_MAYSHARE semantics are now clearer, it makes sense to
    include this change in this series.

David Hildenbrand (3):
  mm/nommu: factor out check for NOMMU shared mappings into
    is_nommu_shared_mapping()
  mm/nommu: don't use VM_MAYSHARE for MAP_PRIVATE mappings
  drivers/misc/open-dice: don't touch VM_MAYSHARE

 drivers/char/mem.c       |  2 +-
 drivers/misc/open-dice.c | 14 ++++-----
 fs/cramfs/inode.c        |  2 +-
 fs/proc/task_nommu.c     |  2 +-
 fs/ramfs/file-nommu.c    |  2 +-
 fs/romfs/mmap-nommu.c    |  2 +-
 include/linux/mm.h       | 20 +++++++++++++
 io_uring/io_uring.c      |  2 +-
 mm/nommu.c               | 62 +++++++++++++++++++++++-----------------
 9 files changed, 68 insertions(+), 40 deletions(-)

-- 
2.39.0


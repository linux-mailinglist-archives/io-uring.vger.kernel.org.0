Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 438BB651071
	for <lists+io-uring@lfdr.de>; Mon, 19 Dec 2022 17:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbiLSQbS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Dec 2022 11:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbiLSQbJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Dec 2022 11:31:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC76D10050
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 08:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671467424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QBdeoAN+MduRpz5Invgp6CatIcsWWzCUyVqTEr/eOQo=;
        b=fbboh5Yb0uU0JDt57Ac51Ww5s8z5prq0akwS5s7cRN0kvZAtB/R/PV3UGDLj97bwwQ/E1A
        Gg0wMbXt/9Bwgbug22UmoPPeKBazBDfD/tNOXLAjoSq3YMYG79i+/MDk0oSt35jj93lXao
        0UYqF6NhXO5gSaf2OvfkBM7WnSa2M5w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-oH3lA0ujOL-DL8Cnt7igAQ-1; Mon, 19 Dec 2022 11:30:19 -0500
X-MC-Unique: oH3lA0ujOL-DL8Cnt7igAQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA7CE858F0E;
        Mon, 19 Dec 2022 16:30:18 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.194.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 951E040C945A;
        Mon, 19 Dec 2022 16:30:14 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Pitre <nico@fluxnic.net>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH mm-stable RFC 0/2] mm/nommu: don't use VM_MAYSHARE for MAP_PRIVATE mappings
Date:   Mon, 19 Dec 2022 17:30:11 +0100
Message-Id: <20221219163013.259423-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
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

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>

David Hildenbrand (2):
  mm/nommu: factor out check for NOMMU shared mappings into
    is_nommu_shared_mapping()
  mm/nommu: don't use VM_MAYSHARE for MAP_PRIVATE mappings

 drivers/char/mem.c    |  2 +-
 fs/cramfs/inode.c     |  2 +-
 fs/proc/task_nommu.c  |  2 +-
 fs/ramfs/file-nommu.c |  2 +-
 fs/romfs/mmap-nommu.c |  2 +-
 include/linux/mm.h    | 20 ++++++++++++++
 io_uring/io_uring.c   |  2 +-
 mm/nommu.c            | 62 +++++++++++++++++++++++++------------------
 8 files changed, 62 insertions(+), 32 deletions(-)

-- 
2.38.1


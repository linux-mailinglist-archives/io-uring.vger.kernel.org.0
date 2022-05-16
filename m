Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E12C0528A28
	for <lists+io-uring@lfdr.de>; Mon, 16 May 2022 18:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbiEPQV0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 May 2022 12:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiEPQVZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 May 2022 12:21:25 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC4D28E3A
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:21:23 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id y12so8147908ior.7
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d7XA22wvXPOXpq7o6xI1nGmlR+x21dbu+LPhmMYD7Jg=;
        b=qi49WaYYtSt8bfyAn8KL8abvNYI64hIVncTv6t7y5+I6/EfmuRXdpbL0/Fcev0e0Nc
         PbICse7LthjvV+nEhpmAHJJ1IrKGBV1lImXqsv+pW8DiVIplF58GjmgnnRWBBpKZ4/Ds
         Kh9PvytG1tLTUVpiSP5/TvgDztDyoVuqSrvUQjE6IT1CMDjDqcok/6mfWSPaajybCqQ2
         PFtVt71+xxEsOemFqtWa1xVFAKccsHuykBJpVTo1fSTAOiQCWMJ1eXAJNrH8WXm6ebKQ
         C0QWmZdnWdq999Rcz3RbXgJo83WpfI+sKQVfKpDkkSC/auzuGOxeEoke5iPFv9ovopCy
         20dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d7XA22wvXPOXpq7o6xI1nGmlR+x21dbu+LPhmMYD7Jg=;
        b=b/TA2Ew6AGKatsAAqtxvenZOEaw4+zz24QBnnftZVrbcKtnPopwNLJ8WX/jdO6iUh2
         nbtJD3MkVoogVmC8THv04BAqJwXiy4iR+m+NUR70CNbcDBDRnczRjWHsHacB8ZzXQYCC
         Pckkd9Q2u1jQSZZUwdkGlST2ctIbC+LIyTe2RQidtCDWvIJ3kXItELsoQOs1t/jN5su1
         t8TMS4kTBF+o5nhFOivlANAeKi9ipanuh/vtI7xZNhhRdIsCCSD4KsComV+1HB0U1yBZ
         UDnIFRa4veSxnI4Y8xCGx7MZDk6HBe6zV6TEf5PmYwMX94cg/2a3wYJIja5ojc7ddtn5
         ogsA==
X-Gm-Message-State: AOAM530HozVIyc3KNALydxs/5RZ+//x0Uf3DcE/TbOd/tmgNwbt+RRlL
        SlNfy+30lMBIiHZDNm8Vu3Fu4ymCSmdlag==
X-Google-Smtp-Source: ABdhPJyZ3GHwdOLrO57VM+v2Jw+dMEpbD+okHcnGu2S25kUmHdmw6z6EEW6D6vm+/mg9sY26ufmIzA==
X-Received: by 2002:a05:6602:490:b0:65d:cfc5:9221 with SMTP id y16-20020a056602049000b0065dcfc59221mr8121058iov.0.1652718082363;
        Mon, 16 May 2022 09:21:22 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id l9-20020a92d8c9000000b002d0ebe7c14asm2740ilo.21.2022.05.16.09.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 09:21:21 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCHSET v6 0/3] Add support for ring mapped provided buffers
Date:   Mon, 16 May 2022 10:21:15 -0600
Message-Id: <20220516162118.155763-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This series builds to adding support for a different way of doing
provided buffers, which is a lot more efficient than the existing scheme
for high rate of consumption/provision of buffers. The interesting bits
here are patch 3, which also has some performance numbers an an
explanation of it.

Patch 1 adds NOP support for provided buffers, just so that we can
benchmark the last change.

Patch 2 just abstracts out the pinning code.

Patch 3 adds the actual feature.

This passes the full liburing suite, and various test cases I adopted
to use ring provided buffers.

v6:
- Change layout so that 'head' overlaps with reserved field in first
  buffer, avoiding the weird split of first page having N-1 buffers and
  the rest N (Dylan)
- Rebase on current kernel bits
- Fix missing ring unlock on out-of-bufs
- Fix issue in io_recv()

Can also be found in my git repo, for-5.19/io_uring-pbuf branch:

https://git.kernel.dk/cgit/linux-block/log/?h=for-5.19/io_uring-pbuf

and there's an associated liburing branch too:

https://git.kernel.dk/cgit/liburing/log/?h=huge

 fs/io_uring.c                 | 323 +++++++++++++++++++++++++++++-----
 include/uapi/linux/io_uring.h |  36 ++++
 2 files changed, 319 insertions(+), 40 deletions(-)

-- 
Jens Axboe



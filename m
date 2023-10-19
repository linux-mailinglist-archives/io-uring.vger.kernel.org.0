Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B6D7CF202
	for <lists+io-uring@lfdr.de>; Thu, 19 Oct 2023 10:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbjJSIHf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Oct 2023 04:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbjJSIHe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Oct 2023 04:07:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F041911F
        for <io-uring@vger.kernel.org>; Thu, 19 Oct 2023 01:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697702811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=Efx2jgt68kmyzY4d5jU5kSGARJlRs4cJsmB+qOe7vww=;
        b=N8kwEeNIto9tybrHs/DGybubrMv/1J1bnG6HjGukCbxl3B0vGJFI3jGXv5J8g2WGhaIxwh
        ORyPmNMpx4rBPA7egn0Fu7v/fXUkOWAluuuvrsCpQBxJo0TNnVwywQi0BaXTZzZK0EZXOc
        jRNV+AYlprY3JkyRrKBolvTYzElqEK4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-dTShRh8zMF-ieTWs2FGw4A-1; Thu, 19 Oct 2023 04:06:36 -0400
X-MC-Unique: dTShRh8zMF-ieTWs2FGw4A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DED9488B771;
        Thu, 19 Oct 2023 08:06:35 +0000 (UTC)
Received: from fedora (unknown [10.72.120.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 15564C15BB8;
        Thu, 19 Oct 2023 08:06:32 +0000 (UTC)
Date:   Thu, 19 Oct 2023 16:06:28 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     ming.lei@redhat.com, Guang Wu <guazhang@redhat.com>
Subject: [v6.4 Regression] rust/io_uring: tests::net::test_tcp_recv_multi
 hangs
Message-ID: <ZTDjhCk8TC47oBdZ@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Jens,

Guang Wu found that tests::net::test_tcp_recv_multi in rust:io_uring
hangs, and no such issue in RH test kernel.

- git clone https://github.com/tokio-rs/io-uring.git
- cd io-uring
- cargo run --package io-uring-test

I figured out that it is made by missing the last CQE with -ENOBUFS,
which is caused by commit a2741c58ac67 ("io_uring/net: don't retry recvmsg()
unnecessarily").

I am not sure if the last CQE should be returned and that depends how normal
recv_multi is written, but IORING_CQE_F_MORE in the previous CQE shouldn't be
returned at least.


Thanks,
Ming


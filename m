Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C9948B8BF
	for <lists+io-uring@lfdr.de>; Tue, 11 Jan 2022 21:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243820AbiAKUjw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jan 2022 15:39:52 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60627 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233821AbiAKUjv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jan 2022 15:39:51 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9E64A5C0251
        for <io-uring@vger.kernel.org>; Tue, 11 Jan 2022 15:39:44 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 11 Jan 2022 15:39:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rydia.net; h=
        date:from:to:subject:message-id:mime-version:content-type; s=
        fm3; bh=JjVW8Sv/MNRxW5JpkaKIn/1jaDEI8ZMlLIKVbIOeLLQ=; b=dsWMwbOb
        VkFYwWvGyxuXaDY4SQ0XAjvLnFywDLFC6Gmb+fHNvAJCwAnStoG4GA0hwAgR25xY
        sUeAvXmZ+bRY7uzRnG6wP+v2ywRbVdp1A0FPNIoqecSAHnL+K6yKIcsa1LReFKZj
        b+5BNmU5zPPDE6+PhmYyViNEp5KHShyv9sqfhOTkngukJB4SbndCvzzBvLMXlQdR
        /7rphffmmZWrbmurEEs4RgZGLQpeT56ibFq6t95uKZePhDFwTerVA4Foo8YRdaq2
        s9r/FKAUOpos2IS4s/GnS5aqjMhfD0JovIp/fHt3KFJoc7nAWby7usJ/e4KWuRVa
        0h+U17eE9TzcVA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm1; bh=JjVW8Sv/MNRxW5JpkaKIn/1jaDEI8
        ZMlLIKVbIOeLLQ=; b=TaVSidx2hkfp3cFQPktyVR9i1PCwOJfk4VNQjvnjp21tx
        Q9ldshZM7fR7B+fisLVcOk60iQ9En5bk6nI6o48/mcYFG+0q36n7lbOd0vcsxceD
        bPcWz/sEqgxp+O0vUT0/uexmoDHzb0vNxKQCY83unEW2pWrwMUTv/ndXMW/K0hsn
        WdYTMBuzqvJGSy1wOze+Z+wgbtXD2iAXiFYZHMM4Gk3fMnIwfcwVGsULrWzqksyG
        6wIF7gC+/Je/gzlGBWm2ZRK637QPa68DoU07WTnMvPimfRxJBp96OkIW3nMTrvri
        tANuqGOMlohGImwlOPsK5MJK9bDlfkjqCU2Jr4OiA==
X-ME-Sender: <xms:EOvdYfGQqreSle197Ws5Xfv05HhAxxhb_9v5TKOOCxnYKENUBwhZ-w>
    <xme:EOvdYcVY-lV9XIsKel84NpIC8dRIMJOUCFVJlsGglN4FGuWKYD8NqUnGLOGIfHbVI
    HjO8B2CWtQwAXAUO1U>
X-ME-Received: <xmr:EOvdYRIiVSpA70TKgHL0lyQlqcNY3O1ryYnMgMk6dqanyMsICqG267GfuKvEmyBcmySq-N1xn5FBSzM_SVjJ72e3ThqjXUbMUEbuBrtJbTn9yA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrudehfedgudeflecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfggtgesthdtredttd
    dtvdenucfhrhhomhepughorhhmrghnughouceoughorhhmrghnughosehrhiguihgrrdhn
    vghtqeenucggtffrrghtthgvrhhnpedtkedvjeffvefhleeuueegvdeggeektdduueeile
    fghffgledvtefgfeejlefhffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpeguohhrmhgrnhguohesrhihughirgdrnhgvth
X-ME-Proxy: <xmx:EOvdYdEZV8zG3lCbtQE_3AXD7-3nyMArxDpBkGp04lUW3jD3gaAy5g>
    <xmx:EOvdYVWIN4kHCFX9G9lykK5jkuSaL-IGgsrq5XNdnyiBedfnx1Vg5A>
    <xmx:EOvdYYMGZDbmh3C8ZaULXxbcd88b3ImtkjW6VEm2CCh3lUXDq6djYg>
    <xmx:EOvdYUD_pDGXldH9TXy8NbAk6dU0-dlRCkD2qFBYJxO6JBYki45vfA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <io-uring@vger.kernel.org>; Tue, 11 Jan 2022 15:39:44 -0500 (EST)
Date:   Tue, 11 Jan 2022 12:39:43 -0800 (PST)
From:   dormando <dormando@rydia.net>
To:     io-uring@vger.kernel.org
Subject: User questions: client code and SQE/CQE starvation
Message-ID: <e354897-adca-114-3830-4cc243f99fc1@rydia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hey,

Been integrating io_uring in my stack which has been going well-ish.
Wondering if you folks have seen implementations of client libraries that
feel clean and user friendly?

IE: with poll/select/epoll/kqueue most client libraries (like libcurl)
implement functions like "client_send_data(ctx, etc)", which returns
-WANT_READ/-WANT_WRITE/etc and an fd if it needs more data to move
forward. With the syscalls themselves externalized in io_uring I'm
struggling to come up with abstractions I like and haven't found much
public on a googlin'. Do any public ones exist yet?

On implementing networked servers, it feels natural to do a core loop
like:

      while (1) {
          io_uring_submit_and_wait(&t->ring, 1);

          uint32_t head = 0;
          uint32_t count = 0;

          io_uring_for_each_cqe(&t->ring, head, cqe) {

              event *pe = io_uring_cqe_get_data(cqe);
              pe->callback(pe->udata, cqe);

              count++;
          }
          io_uring_cq_advance(&t->ring, count);
      }

... but A) you can run out of SQE's if they're generated from within
callbacks()'s (retries, get further data, writes after reads, etc).
B) Run out of CQE's with IORING_FEAT_NODROP and can no longer free up
SQE's

So this loop doesn't work under pressure :)

I see that qemu's implementation walks an object queue, which calls
io_uring_submit() if SQE's are exhausted. I don't recall it trying to do
anything if submit returns EBUSY because of CQE exhaustion? I've not found
other merged code implementing non-toy network servers and most examples
are rewrites of CLI tooling which are much more constrained problems. Have
I missed anything?

I can make this work but a lot of solutions are double walking lists
(fetch all CQE's into an array, advance them, then process), or not being
able to take advantage of any of the batching API's. Hoping the
community's got some better examples to untwist my brain a bit :)

For now I have things working but want to do a cleanup pass before making
my clients/server bits public facing.

Thanks!
-Dormando

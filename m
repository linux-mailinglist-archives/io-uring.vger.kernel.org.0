Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA70C5ED971
	for <lists+io-uring@lfdr.de>; Wed, 28 Sep 2022 11:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbiI1JuX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 05:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbiI1JuU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 05:50:20 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A486BA1A67
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 02:50:15 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id s206so11767807pgs.3
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 02:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bnoordhuis-nl.20210112.gappssmtp.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=7NNOkhT3jLkaFmZ+vmNWMBSFKFWUDRyQAnKuVTvzA7g=;
        b=ngRpqflSjPcSxgrKseKgMJRUDuQd4TxUrrKoluHAyfyZSpnGf6z3HbMsGx28ThMQIM
         HlPUv6hybuz5IxTQBFNScPFPJM/uL3CdVbQozOjzTW1DC0hepB2PJchky9tXh4q4gn1M
         vxJxjJplwfAjdGaRz7zDjKIobJmYwCr2gyuYLGW+BjgfZ79yF5QugMAwIjxqAXitdYlf
         1HjQQdSLkpa08V2+bvMmiozmehGPN5ePflu2qKyiuCDGqUER38tg8ZsQGrylun3hSeDM
         kL19EhYLrl8s8s6qaUSRvvEVXX4ksnfqMTBbPD+i5/zVliTkfsioflHHfPhCLPTlXgXt
         poyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=7NNOkhT3jLkaFmZ+vmNWMBSFKFWUDRyQAnKuVTvzA7g=;
        b=yMXkdTyYsu33hOuMTtkwJKr+h+9HfAdMCBKJgFiddaIyBRT8LQqp6dpbXOnDXpDuqR
         WCQk+IXeoXBm9T4qZn6O31c6O82aYIGMUXaRj/kKoGxVcJKH9HTBh4ak48FUOhRjZqk8
         IA/SrPdBfT2cQRuFTfgVdjWL3F6j0ARpSqDNsFm7ZtAuTJHMcKyYoe3TLAf6fCguF5DJ
         cugdVQFz601bTnIoLVmZ3d4jV3yFChl26Ydn8jOL9f0SiN6RiG+UnmncTxx87LP8vlLR
         8LW6TRKttJ8cO3c0HnWpOBdfzQrLxSIpk5i9uoENhrNsOukJl9BwKLI+GkIbKCAZ2svi
         yH7g==
X-Gm-Message-State: ACrzQf2dx7L+ZDW2qiYJjnzHh1vtEXSKUJelo0v7pc3YcaAD3sGYsqm0
        fSJrVQOCYc3/kMkvS0KAh00sfK4OPn6oINqP0m8SVQfBFB0=
X-Google-Smtp-Source: AMsMyM4iEajR1FeGhD/P8uAFLaIoNEdSBdsMRfwQq8P4tJ4mPMYAQu8AXfU2hvPpEmi+GGx5OF6b6rfHmLTTQv1lPmc=
X-Received: by 2002:a63:2215:0:b0:43b:e00f:7c7b with SMTP id
 i21-20020a632215000000b0043be00f7c7bmr28693514pgi.511.1664358614374; Wed, 28
 Sep 2022 02:50:14 -0700 (PDT)
MIME-Version: 1.0
From:   Ben Noordhuis <info@bnoordhuis.nl>
Date:   Wed, 28 Sep 2022 11:50:03 +0200
Message-ID: <CAHQurc-0iK9zawpc_k_-wSUVMp_+v14K+t-EJEDXL0pYkzD80A@mail.gmail.com>
Subject: Chaining accept+read
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I'm trying to chain accept+read but it's not working.

My code looks like this:

    *sqe1 = (struct io_uring_sqe){
      .opcode     = IORING_OP_ACCEPT,
      .flags      = IOSQE_IO_LINK,
      .fd         = listenfd,
      .file_index = 42, // or 42+1
    };
    *sqe2 = (struct io_uring_sqe){
      .opcode     = IORING_OP_READ,
      .flags      = IOSQE_FIXED_FILE,
      .addr       = (u64) buf,
      .len        = len,
      .fd         = 42,
    };
    submit();

Both ops fail immediately; accept with -ECANCELED, read with -EBADF,
presumably because fixed fd 42 doesn't exist at the time of submission.

Would it be possible to support this pattern in io_uring or are there
reasons for why things are the way they are?

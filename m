Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D15A20559A
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2020 17:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732868AbgFWPQi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Jun 2020 11:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732781AbgFWPQh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Jun 2020 11:16:37 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B053C061573
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2020 08:16:36 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id c75so19647013ila.8
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2020 08:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XilykYzRaqLqQ4j6NoG0WyE0Ftb87ahndcM6wFElAsA=;
        b=G6QqDp/JmXxfgc+BVrxjDJ2V+PmDoRLX6KUzQdd24OvGrR5CdN0rdV4K5e7kz4oEcV
         eEpacBR+sSoswWgxA1L3t9sGzuqRXzZ9gphRXiqcTUkHqxbtMfGrJZ2NWiVRAe/wYG+x
         QtONsBDdAtonflX9oiTr9cexLORrh3WpBZiuUlHwFSWZ4NgD97Z0Y+PAWDgyZDCd2JYt
         kYf+68qAPGorCGOHN+h98HQ/9Qw168+gpH8DVXjuMDe6KG6CQRiKWyjnKvD1OD5GKGuK
         L7Be8DU+s/vu59NkU41lrvWPVqYy8tPngDP0bazrhO0w3TlLl2KwI3Dp0FmLePx+y6Ec
         L8Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XilykYzRaqLqQ4j6NoG0WyE0Ftb87ahndcM6wFElAsA=;
        b=Z1b1fD76TKz7TpvdkRwmwdWSEE7C2qcD1bdgJ12SBSA67BIEPqFZrZ4kv/mD/2u58K
         873U+qcuOJdf9fJ6sq6UAc2NtkSE6w7o4FFT1dilOVibVZlJIxN46IT3fqX7nIFisfDV
         EmDz1UYEbTdENPTGfndsWWfKMQY/pzck+qKzi/XXD1AaE1mRbzQl5uXdBcFhsTFl6Dzv
         aK5wNSWK/YI74PZyXaY8FBGdYi8STwdhP2h6WuFCBtH7r4xfZqwXmqNhlUJdxsx8e7Jo
         RrFYqXflwtYJowWPlH2i60DqEu07uZS8i7BK2xsDu1irxP/EMR2rqqx9LYC3EDX1nOI+
         ZLwg==
X-Gm-Message-State: AOAM533pEOYCkc58+k+xhSesH0JvjpbPHY01Pzt6ZPz8EMzo6UiT7Tcp
        0JGy/Fm7o9Nuk/gzskN9LGpZi6Lqy3c=
X-Google-Smtp-Source: ABdhPJzkLj+i5JnmL8+xc9qGgLll3q5h+pEbmKnXh97keKgqaCp+Eg9LBnhdIjCJMGNv4JxfbZsOEA==
X-Received: by 2002:a05:6e02:542:: with SMTP id i2mr23754706ils.203.1592925394462;
        Tue, 23 Jun 2020 08:16:34 -0700 (PDT)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k1sm4275180ilr.35.2020.06.23.08.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 08:16:33 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     xuanzhuo@linux.alibaba.com, Dust.li@linux.alibaba.com
Subject: [PATCHSET 0/5] Allow batching of inline completions
Date:   Tue, 23 Jun 2020 09:16:24 -0600
Message-Id: <20200623151629.17197-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As Xuan Zhuo <xuanzhuo@linux.alibaba.com> reported here:

https://lore.kernel.org/io-uring/34ecb5c9-5822-827f-6e7b-973bea543569@kernel.dk/T/#me32d6897f976e8268284ff5cbdb3696010c2b7ba

we can do a bit better when dealing with inline completions from the
submission path. This patchset cleans up the standard completion
logic, then builds on top of that to allow collecting completions done
at submission time. This allows io_uring to amortize the cost of needing
to grab the completion lock, and updating the CQ ring as well.

On a silly t/io_uring NOP test on my laptop, this brings about a 20%
increase in performance. Xuan Zhuo reports that it changes his SQPOLL
based UDP processing (running at 800K PPS) profile from:

17.97% [kernel] [k] copy_user_generic_unrolled
13.92% [kernel] [k] io_commit_cqring
11.04% [kernel] [k] __io_cqring_fill_event
10.33% [kernel] [k] udp_recvmsg
 5.94% [kernel] [k] skb_release_data
 4.31% [kernel] [k] udp_rmem_release
 2.68% [kernel] [k] __check_object_size
 2.24% [kernel] [k] __slab_free
 2.22% [kernel] [k] _raw_spin_lock_bh
 2.21% [kernel] [k] kmem_cache_free
 2.13% [kernel] [k] free_pcppages_bulk
 1.83% [kernel] [k] io_submit_sqes
 1.38% [kernel] [k] page_frag_free
 1.31% [kernel] [k] inet_recvmsg

to

19.99% [kernel] [k] copy_user_generic_unrolled
11.63% [kernel] [k] skb_release_data
 9.36% [kernel] [k] udp_rmem_release
 8.64% [kernel] [k] udp_recvmsg
 6.21% [kernel] [k] __slab_free
 4.39% [kernel] [k] __check_object_size
 3.64% [kernel] [k] free_pcppages_bulk
 2.41% [kernel] [k] kmem_cache_free
 2.00% [kernel] [k] io_submit_sqes
 1.95% [kernel] [k] page_frag_free
 1.54% [kernel] [k] io_put_req
[...]
 0.07% [kernel] [k] io_commit_cqring
 0.44% [kernel] [k] __io_cqring_fill_event

which looks much nicer.

Patches are against my for-5.9/io_uring branch.

-- 
Jens Axboe



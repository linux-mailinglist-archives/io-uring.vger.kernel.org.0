Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E611CFF26
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2020 22:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgELUVf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 May 2020 16:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgELUVf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 May 2020 16:21:35 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08E6C05BD0B
        for <io-uring@vger.kernel.org>; Tue, 12 May 2020 13:21:34 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id s186so13237292qkd.4
        for <io-uring@vger.kernel.org>; Tue, 12 May 2020 13:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=+nb789dMIvQBamk/G/HIyXlHAqwX3FVkDcpLN6tnxzM=;
        b=jgCUzg2xZhGi9WNB2KWn4fobziRoxR9D6v9sDU6d3cMk6JmhXL4HxnlfVkWFubJecL
         AQ+FRgK3WdouibXMFYG8SqtvGbnNXwNX96ksGIMKQDdiunKHgj/Q0AF2RSEPoUdUmk/G
         G5LIr5qVJjQevm3IhUT5J72QjraqRjJ76yzrfaVXXIl/YSdtKqSIBR9s/E/ji77NMwhK
         z+0MVRw9smklMHH6pk0JMiN047AhSqPlWWDlY5IkHjPGvm76WZpt8m7DtGgR9RXl2L93
         Mp4V0CLg/lD8P0J9FtO+6rolxPxNh6GYH8Ip4Uw9LnBYetBHwK1kniBHYWPqZZDYq3Xl
         CX7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=+nb789dMIvQBamk/G/HIyXlHAqwX3FVkDcpLN6tnxzM=;
        b=LfaxYqrmm//RG5mq+NUh+KHiGqm5ElpHbc8S6eKc7ZW6UjMbhm+Kwng+hQ4h5r2+pc
         dyWuhh+Mt7ZJWPce8t5nJwOGJPGPB8gHsRTskFnH0r2KRBJPu0ch2A6CjQbquR64IS7P
         1L7uNDJIhrOUwoKA4DGKrSY2n7GkhBcnfFZ0ygtF+GMONUf/cu2bpVBlMlu1f+xzfVql
         JuSVWNsao/GpYHJe5xsIu545EkPaajrmWl9v1b9oau3PZdTsKTXVFXJZwafxT+EwLjZP
         3KdrCJxbhWGWr3JaB0/gzD0u20pVmx81OrJYkPjpUnHTxV/41D75oZbM1eqSEP2YTl2K
         /S1g==
X-Gm-Message-State: AGi0PuY38ditw0BVYTRYIpbp6nZPi4D7v0OO4fpaDDUYwHQx1K6aURzV
        NPm6BVJnTMM22LJAP3nRUZczopFsCJW4HYqOHXX6QlDVMGcOZYg=
X-Google-Smtp-Source: APiQypIIttHKzFB1YU4pMSH8dcrfs7/vKK7v7tu0yqpZtFbTAZXEtk+4Kp1oSy4bs1HH6JQor3OFYaMCUz07TSty+Vc=
X-Received: by 2002:a37:4e11:: with SMTP id c17mr12511710qkb.25.1589314893897;
 Tue, 12 May 2020 13:21:33 -0700 (PDT)
MIME-Version: 1.0
From:   Dmitry Sychov <dmitry.sychov@gmail.com>
Date:   Tue, 12 May 2020 23:20:57 +0300
Message-ID: <CADPKF+ene9LqKTFPUTwkdgbEe_pccZsJGjcm7cNmiq=8P_ojbA@mail.gmail.com>
Subject: Any performance gains from using per thread(thread local) urings?
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

I'am writing a small web + embedded database application taking
advantage of the multicore performance of the latest AMD Epyc (up to
128 threads/CPU).

Is there any performance advantage of using per thread uring setups?
Such as every thread will own its unique sq+cq.

My feeling is there are no gains since internally, in Linux kernel,
the uring system is represented as a single queue pickup thread
anyway(?) and sharing a one pair of sq+cq (through exclusive locks)
via all threads would be enough to achieve maximum throughput.

I want to squeeze the max performance out of uring in multi threading
clients <-> server environment, where the max number of threads is
always bounded by the max number of CPUs cores.

Regards, Dmitry

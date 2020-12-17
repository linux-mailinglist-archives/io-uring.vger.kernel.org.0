Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40862DCD94
	for <lists+io-uring@lfdr.de>; Thu, 17 Dec 2020 09:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgLQIUu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Dec 2020 03:20:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgLQIUu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Dec 2020 03:20:50 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BF3C061794
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 00:20:10 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id r9so26687847ioo.7
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 00:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=1lePQlU3TyS05qFR7jGqlF+GZBT4MGrGZwsbhpWETmY=;
        b=W3oGaD/yocXuRiR1y2xxbGWowsvP2ku+r4mrnlAULKUVYU5Agp7ZxlPZ403TUsIl64
         FLX795F0Hznvlq9cMyvhvoYEZ1/Y3vcdQDSDTCWo0DhQtziE9C4nC4P7VCIP1keM5IO2
         V3kfWn+iuCU+/WBft+tjXV6G07tM1d6naqkzEkfpAvyGN2XNdVOL0wtyXPR3j3F2BFX6
         Uzqj3lFWd7xLOrRUfaajzzIbCPlvGO4c8ldoChR2gEzVZWlP0yIZcrXANIyDzKPtoA8s
         Grm7uu2Qzqnf3dLckvtnOVuQcf8HHARQd4peSRsnUHXRJ0tJ48IoSU+OtK7zNXG518BU
         3JqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=1lePQlU3TyS05qFR7jGqlF+GZBT4MGrGZwsbhpWETmY=;
        b=pHjkZUQ/2pk5Ix7GoXRxsxqnf1uaM3UZkRdpqhi28yzKpdZJr54TN7L0oMPZhFzEzy
         pQsZFhc2mwHAhmAs3B/2DB0Hpwo6LffQklzH/UIYHV2txD9JZhjosCsLifIrJIg4VzZd
         hPx+DdMm7XrCPTfvXAa76WKoWZAxCcid0jtqieVMn1JL4cHBGmg2bDBN3Hh4A1y5dsBv
         EBG0oQsaeVS/MwRYh9M2wNaMzLGFinsNYJP0COY7vCu87rpkXkprYsNIP/RZzAgKLViQ
         UNAbI21+lZOI+SACeVs+OW68eBbcGxnUaUQ+kOV60etDVW8kpB9j9haoQ0NJLu0Pfrmw
         p6aQ==
X-Gm-Message-State: AOAM530e3/zXxv3aM8xYNSpTG6+Iu6AvyhL4rJuWQFYZJo91tnhe4hFx
        g/rvR7A31fYbo/AMr31xceUQZS/LcWVpr3bnoWv6eQQLPjVUTw==
X-Google-Smtp-Source: ABdhPJxCIwO0ksMZyHqRoaaFkn3Bc39GGbJvq+JDD5ZoeagemZkV94UV3Y2PMBqIfbGZUE+t0XvY3UcKljazB1RoSEQ=
X-Received: by 2002:a02:cd87:: with SMTP id l7mr46483246jap.117.1608193209154;
 Thu, 17 Dec 2020 00:20:09 -0800 (PST)
MIME-Version: 1.0
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Thu, 17 Dec 2020 15:19:58 +0700
Message-ID: <CAOKbgA66u15F+_LArHZFRuXU9KAiq_K0Ky2EnFSh6vRv23UzSw@mail.gmail.com>
Subject: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

We've ran into something that looks like a memory accounting problem in the
kernel / io_uring code. We use multiple rings per process, and generally it
works fine. Until it does not - new ring creation just fails with ENOMEM. And at
that point it fails consistently until the box is rebooted.

More details: we use multiple rings per process, typically they are initialized
on the process start (not necessarily, but that is not important here, let's
just assume all are initialized on the process start). On a freshly booted box
everything works fine. But after a while - and some process restarts -
io_uring_queue_init() starts to fail with ENOMEM. Sometimes we see it fail, but
then subsequent ones succeed (in the same process), but over time it gets worse,
and eventually no ring can be initialized. And once that happens the only way to
fix the problem is to restart the box.  Most of the mentioned restarts are
graceful: a new process is started and then the old one is killed, possibly with
the KILL signal if it does not shut down in time.  Things work fine for some
time, but eventually we start getting those errors.

Originally we've used 5.6.6 kernel, but given the fact quite a few accounting
issues were fixed in io_uring in 5.8, we've tried 5.9.5 as well, but the issue
is not gone.

Just in case, everything else seems to be working fine, it just falls back to
the thread pool instead of io_uring, and then everything continues to work just
fine.

I was not able to spot anything suspicious in the /proc/meminfo. We have
RLIMIT_MEMLOCK set to infinity. And on a box that currently experiences the
problem /proc/meminfo shows just 24MB as locked.

Any pointers to how can we debug this?

Thanks,
Dmitry

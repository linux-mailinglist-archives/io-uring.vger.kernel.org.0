Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4BCD2DECC4
	for <lists+io-uring@lfdr.de>; Sat, 19 Dec 2020 03:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgLSCuP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 21:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbgLSCuP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 21:50:15 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433D0C0617B0
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 18:49:35 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id h19so2832267qtq.13
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 18:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fw4UYcmr/Xn2GxNN7nytp7j+Ty9FdqrsI5GjpPR4KU4=;
        b=oxJoYm1QtIa4MTktkSNlJ4fVgXxV7qtKjo43bW1JUhgYT+4NMvV6u8+GpZOkulysjO
         KGZUydhz1UZOIgVPI711hIpv6zZ1/mnm9gfZbsL14zG+J7krY7kU7o15rAv9pr2OmyEg
         2uEi8z0uIXJ9E0+qMNIN42ebKPzDtZFShZANUb94i//bdbS548UEv+8sbrZOafH45Rju
         9QLB25XWOsI1cVEDYEFg9MqA+OziVq1R6w4ODlIX89lmhuZdAFbRc6XRqlDt1zLhKFx7
         Mvt9tCxqc+EW84Y2WUgv+EUXy4tDrGLWZUPitZMTmh73jOC4w6vCsJgrSE1CywVNkAsD
         xsyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fw4UYcmr/Xn2GxNN7nytp7j+Ty9FdqrsI5GjpPR4KU4=;
        b=R9pvlSGmDOh/QXEtu6de6f296KQeDugqNxfk6s+wk1lXPTsW/XQOyTgfAEWhx1PNTC
         7XdFJ+pmeDyzP9vP/4NqU9Kc0PnIqHs9Qs6Z2iISBvoTM5pNxf77fE19WDPqdGMOJSpJ
         iuDR0gpA1EWRoXrvDOnW6CjsCtlO8j6N2jQ7NimxFHPNr4wBF9quNvx1m/NqJ5WMVjHe
         F/4lf6mhDmjh8GkhEp6JTbz+uhWcJwLQumBOR9SKv7VD91TtnI5xxYf9T3WR5y8uErGW
         TT66xkN0g0O0wKD2F1zEhfe3RyvgMrLFwEPFTgTMO1gJYakMXB9wulX7vCzZI4N2Jqki
         4jpw==
X-Gm-Message-State: AOAM533XxWb/yUfmPqRq0ZKq88iH873IL8LOvD8drH/5tLSnR6CwYq4G
        K/ANTfkZUbUhEcK32OkJ0DcdRjhoBxovK7sOaXTdIb9udTdjszS/
X-Google-Smtp-Source: ABdhPJzDnC82xKAKHG+zMtMgRBabl3hP8IHIGEf+J64BOuOpgBrOBPByUgbJxN7OkiBsnmbC0bQ1C+mdiWpNivf5rXM=
X-Received: by 2002:ac8:4e1c:: with SMTP id c28mr7087559qtw.67.1608346174249;
 Fri, 18 Dec 2020 18:49:34 -0800 (PST)
MIME-Version: 1.0
References: <CAOKbgA66u15F+_LArHZFRuXU9KAiq_K0Ky2EnFSh6vRv23UzSw@mail.gmail.com>
 <7d263751-e656-8df7-c9eb-09822799ab14@kernel.dk> <CAAss7+oi9LFaPpXfdCkEEzFFgcTcvq=Z9Pg7dXwg5i=0cu-5Ug@mail.gmail.com>
 <caca825c-e88c-50a6-09a8-c4ba9d174251@kernel.dk>
In-Reply-To: <caca825c-e88c-50a6-09a8-c4ba9d174251@kernel.dk>
From:   Josef <josef.grieb@gmail.com>
Date:   Sat, 19 Dec 2020 03:49:23 +0100
Message-ID: <CAAss7+rwgjo=faKi2O7mUSJTWrLWcOrpyb7AESzaGw+_fWq1xQ@mail.gmail.com>
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Dmitry Kadashev <dkadashev@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        Norman Maurer <norman.maurer@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> I'm happy to run _any_ reproducer, so please do let us know if you
> manage to find something that I can run with netty. As long as it
> includes instructions for exactly how to run it :-)

cool :)  I just created a repo for that:
https://github.com/1Jo1/netty-io_uring-kernel-debugging.git

- install jdk 1.8
- to run netty: ./mvnw compile exec:java
-Dexec.mainClass="uring.netty.example.EchoUringServer"
- to run the echo test: cargo run --release -- --address
"127.0.0.1:2022" --number 200 --duration 20 --length 300
(https://github.com/haraldh/rust_echo_bench.git)
- process kill -9

async flag is enabled and these operation are used: OP_READ,
OP_WRITE, OP_POLL_ADD, OP_CLOSE, OP_ACCEPT

(btw you can change the port in EchoUringServer.java)

-- 
Josef

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A839351833
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 19:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236279AbhDARoR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 13:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234647AbhDARi4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 13:38:56 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D9DC02FEB2
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 09:25:16 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id m12so3674247lfq.10
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 09:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zqCMOBypWMQrFbhLJ32mebAruTX9rIeMsT/rUeGN8s4=;
        b=MJa57M9nPQRBm1aVYcjskVj7GsuwnBIkQ2OKLCY1TaQbheJTjtHLCiiLXpyBtHdYnG
         GYn1R3QF5JvAJ5heSIw+Xkj46s7bdiCDIIabYjiWbgc3bwnaKSuzjz32xAyKWQwckGQR
         o+BzYcd/n0S6QJ/6MepO2U9OBI0Wt1MFV7qT8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zqCMOBypWMQrFbhLJ32mebAruTX9rIeMsT/rUeGN8s4=;
        b=Tew5A+LfhHGn7NoOGhdkevcsYv2F6Enqd6sGjrKOgi/Yh3PkcIiNlv3ztVt32qdB3E
         OC46B4/XQ1coVFpVDdeQY7zVUG4N7KtAoSSC7w82J4ex8Sd1W5ruoSjO2GSuUuoJ1sVo
         cCyT242tRv8bCcFLbtqy1nQFjdCsUa4WR540Ic/vj66r3eJnW6UxNNtiUCIJvn4q2a8p
         cWuZ9UP4og3zSs9AOwvOqiSAFHM3AQuvcGkMy07Z7wb3XQqv2kLmjrtrt4CjaET70pX5
         W2GWlY9+yNl0RqxqjciFti4c/nHhHJ4DXM5M3wsVsv55EO+BAg+5FbY0N0QXwkVEoSzw
         epBA==
X-Gm-Message-State: AOAM532m0MuySlXHvXQMPkdDWiUKCP9r1nvzLlcevDstjJFKRm7y7h7n
        060Ggc42BfJ5F9wYc26pnB788KJjaPy5rPe8
X-Google-Smtp-Source: ABdhPJzp02E0UyFwgoJWCGoVQ2pKGith7vodCAspE8r1ZcBPPdwuVyY2WlRwSvfGrHalB7O4v9FTDg==
X-Received: by 2002:a05:6512:208b:: with SMTP id t11mr5634017lfr.131.1617294314163;
        Thu, 01 Apr 2021 09:25:14 -0700 (PDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id e20sm601396lfc.20.2021.04.01.09.25.13
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 09:25:13 -0700 (PDT)
Received: by mail-lf1-f44.google.com with SMTP id q29so3692761lfb.4
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 09:25:13 -0700 (PDT)
X-Received: by 2002:a05:6512:3ba9:: with SMTP id g41mr5782359lfv.421.1617294313081;
 Thu, 01 Apr 2021 09:25:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210326003928.978750-1-axboe@kernel.dk> <e6de934a-a794-f173-088d-a140d0645188@samba.org>
 <f2c93b75-a18b-fc2c-7941-9208c19869c1@kernel.dk> <8efd9977-003b-be65-8ae2-4b04d8dd1224@samba.org>
 <358c5225-c23f-de08-65cb-ca3349793c0e@samba.org> <5bb47c3a-2990-e4c4-69c6-1b5d1749a241@samba.org>
 <CAHk-=whEObPkZBe4766DmR46-=5QTUiatWbSOaD468eTgYc1tg@mail.gmail.com> <2d8a73ef-2f18-6872-bad1-a34deb20f641@samba.org>
In-Reply-To: <2d8a73ef-2f18-6872-bad1-a34deb20f641@samba.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 1 Apr 2021 09:24:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh-VE=4puZ+r-Mo0GcAUou3aKrvnNsU3JxjnMXNcJOoug@mail.gmail.com>
Message-ID: <CAHk-=wh-VE=4puZ+r-Mo0GcAUou3aKrvnNsU3JxjnMXNcJOoug@mail.gmail.com>
Subject: Re: [PATCH 0/6] Allow signals for IO threads
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 1, 2021 at 9:00 AM Stefan Metzmacher <metze@samba.org> wrote:
>
> I haven't tried it, but it seems gdb tries to use PTRACE_PEEKUSR
> against the last thread tid listed under /proc/<pid>/tasks/ in order to
> get the architecture for the userspace application

Christ, what an odd hack. Why wouldn't it just do it on the initial
thread you actually attached to?

Are you sure it's not simply because your test-case was to attach to
the io_uring thread? Because the io_uring thread might as well be
considered to be 64-bit.

> so my naive assumption
> would be that it wouldn't allow the detection of a 32-bit application
> using a 64-bit kernel.

I'm not entirely convinced we want to care about a confused gdb
implementation and somebody debugging a case that I don't believe
happens in practice.

32-bit user space is legacy. And legacy isn't io_uring. If somebody
insists on doing odd things, they can live with the odd results.

                  Linus

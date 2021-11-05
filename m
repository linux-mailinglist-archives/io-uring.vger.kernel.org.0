Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE962446B46
	for <lists+io-uring@lfdr.de>; Sat,  6 Nov 2021 00:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbhKEXir (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Nov 2021 19:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbhKEXir (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Nov 2021 19:38:47 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3A3C061570
        for <io-uring@vger.kernel.org>; Fri,  5 Nov 2021 16:36:06 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id r12so38249274edt.6
        for <io-uring@vger.kernel.org>; Fri, 05 Nov 2021 16:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AAOPEd8l4rwxaVgWxxVBtFNi0CnTYQV8QwVbp1ube3M=;
        b=V6HbH+Gv0TpnkdyhJjKoEP1CfgwoBLpKXTY+9IatoqKXWzdi1CP9f42ULB64az0f9q
         y8CKAA8n+vRJCQJKU/ldA6IomjSlNhANGDEgt4PxzLQlY6qWAcGMH9SM3zie3VfvmHQH
         a1mJwIqguRrtIow5T4bRwXcEB1f5bt3SS+A0KDSUnr+LE7EBffJNtA4RL6w+0atY5l/4
         tZK4XBvgDirz8NeWnRN9iKft24UIVWFlg4JaZ7S7vus7yrRtxoJUEHochRe27Y8aGYOX
         kJNJHYkC8EUFyvul6KaVvH+QnOxRkkpWiQrkM2BPeSOnkh50TU7sWOe+Yb+5bgMYuxIM
         eiSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AAOPEd8l4rwxaVgWxxVBtFNi0CnTYQV8QwVbp1ube3M=;
        b=7yIuXPFXHIhQST7SLir+HX44paXxhHg77v+upDHvjsggezd31KXuJU2ESYQtigksUZ
         MVFS5m+TyeY2/cRDPtMJYC40lCoG5Rpni1jac0AuxDeUURi2y7sRn2h3LfG38gBJoLZK
         1Fhc1mQl1mF0W8nldM9OXvpZ3Qf2E7/QpTgp6ZLGuHPG/Uwx94y8B+LVYgERiNZzBH10
         6eKlfJn+3q579B0vaZxHybCt/aA1w9cSpJls7DDFfxM7eNn3+E5hCishwFv0cQVr+oYf
         pDnPkPo+uZehgzKGPTP26++fwPvCLcUHhYdmw+Azbl3CI+KWBaAizL5DIQ4JqLmiK9yA
         +hxQ==
X-Gm-Message-State: AOAM530bKZfvfDwgMWsykcVMmI+M/tTsVr0TAWG2h4G6MbhLXltP472p
        uqrzPjLNr1noh0L4Rv/VKZ+7Kcs1gzW/ZPnRJbro4g==
X-Google-Smtp-Source: ABdhPJygQ+pDV2vzrnSNgfASRhK60OCfSNl99SuJfIQPctO9afyVT4S8NtRnVg6Q7a7LH7dB8i/aQHseAZfQgoVPywg=
X-Received: by 2002:a50:e145:: with SMTP id i5mr82013114edl.16.1636155365274;
 Fri, 05 Nov 2021 16:36:05 -0700 (PDT)
MIME-Version: 1.0
References: <jVMSI0NVN7BJ-ammarfaizi2@gnuweeb.org> <ECikfVpksVU-ammarfaizi2@gnuweeb.org>
In-Reply-To: <ECikfVpksVU-ammarfaizi2@gnuweeb.org>
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Date:   Sat, 6 Nov 2021 06:35:53 +0700
Message-ID: <CAGzmLMVvhkanBZYq-4PU0NeiPH8K8jhRBH+koqf-1gGrzXGjxg@mail.gmail.com>
Subject: Re: [PATCH v2 liburing] test: Add kworker-hang test
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Oct 20, 2021 at 7:52 PM Ammar Faizi
<ammar.faizi@students.amikom.ac.id> wrote:
>
> Add kworker-hang test to reproduce this:
>
>   [28335.037622] INFO: task kworker/u8:3:77596 blocked for more than 10 seconds.
>   [28335.037629]       Tainted: G        W  OE     5.15.0-rc4-for-5.16-io-uring-00060-g4922ab639eb6 #4
>   [28335.037637] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>   [28335.037642] task:kworker/u8:3    state:D stack:    0 pid:77596 ppid:     2 flags:0x00004000
>   [28335.037650] Workqueue: events_unbound io_ring_exit_work

Hi Jens, will you take this patch? If yes, I will spin the v3 because
this one no longer applies since the test/Makefile changed.

This kworker hang bug still lives in Linux 5.15 stable anyway.
-- 
Ammar Faizi

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41AAB487967
	for <lists+io-uring@lfdr.de>; Fri,  7 Jan 2022 16:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347951AbiAGPAv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Jan 2022 10:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347948AbiAGPAu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Jan 2022 10:00:50 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B512AC061574;
        Fri,  7 Jan 2022 07:00:50 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id y130so17422488ybe.8;
        Fri, 07 Jan 2022 07:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=zBP2UiF21UFw2eESSHmBXsLTbX6dsMz14iTZzwr956s=;
        b=IlbJ4ap/sZZsQIwZlAl1lMs5jHWkMxQGF1Ko4cquETHIAGml1rPCAn2/bhJ8CSqrhU
         81sHiXmjkfhv3IvxQhpYGvqtUB4GqJyiukyNePOz95O2INrvBD+xTGhKdEyx4cKrN1FS
         Xjiw2YbQJnha1b5zYORXiLP4kNjkHWwtDXkIIFieBZJ8V3IIaqNH4bnzMz164VMNO47n
         UhSK9iyGfS03MdDOnDeXn4lrcXXbwQc9gr3YPtSGikOH3OuANt4quh3j8uUC6c0vlkX5
         jaHE6HRTlf5vVxy9IkTHutkQ8VV7kiP5ZeSKNhVtDf8TXdfCWOuXsx771PpqOerXPMvu
         boEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=zBP2UiF21UFw2eESSHmBXsLTbX6dsMz14iTZzwr956s=;
        b=1QfkAhcRL66NF6rXE9OnAsFyovTaceTj1WcVJCFPE6uPmuoXn4GxATymulFxGzmQv7
         Q6cVlR0qWXrh+mL+R1ZoXd/dYUP7OgRMH1EF8X1iURpQJy5kMlh7rCy9gPleYhvf6yoe
         RWPO3irZd8axls691zH8uCB+QMcFnY2UYPLeWJ+kucdxe3WhjM5TjuT3gjR6ZHrRZL6u
         vTvWj96H+W47EjDb3tPuRBMyRPofleZtc6P0LcKmW1CJwM0rLshcsGGgxz9r+oOOp5cM
         iTchVEvHR1tN5Vo+wQsZ90YoHpS1awbrvuAu/FcVzNK/qdISOOG+1opBPSk/CVVbPca0
         iL1g==
X-Gm-Message-State: AOAM532F353K/IrXZVRegui5+CS7H6pycGunJTew3Sy8YjkUlQI+i68j
        OqILiTWfgnGuD7gpU3X/Z4Ivaf7j0AJ56wIPnwQFjZBoonw=
X-Google-Smtp-Source: ABdhPJz3k7QzMxTOfHoyGZtOuExUCU4D18eWUERoGbJWm01EdLQlvhmuola1tIB7FAwEZJ7SlnijbWS/UFVqNUgOV9I=
X-Received: by 2002:a25:500f:: with SMTP id e15mr78539623ybb.312.1641567649858;
 Fri, 07 Jan 2022 07:00:49 -0800 (PST)
MIME-Version: 1.0
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Fri, 7 Jan 2022 16:00:39 +0100
Message-ID: <CAKXUXMzHUi3q4K-OpiBKyMAsQ2K=FOsVzULC76v05nCUKNCA+Q@mail.gmail.com>
Subject: Observation of a memory leak with commit e98e49b2bbf7 ("io_uring:
 extend task put optimisations")
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Dear Pavel, dear Jens,

In our syzkaller instance running on linux-next,
https://elisa-builder-00.iol.unh.edu/syzkaller-next/, we have been
observing a memory leak in copy_process for quite some time.

It is reproducible on v5.15-rc1, v5.15, v5.16-rc8 and next-20220106:

https://elisa-builder-00.iol.unh.edu/syzkaller-next/crash?id=1169da08a3e72457301987b70bcce62f0f49bdbb

So, it is in mainline, was released and has not been fixed in linux-next yet.

As syzkaller also provides a reproducer, we bisected this memory leak
to be introduced with commit e98e49b2bbf7 ("io_uring: extend task put
optimisations").

Could you please have a look how your commit introduces this memory
leak? We will gladly support testing your fix in case help is needed.


Best regards,

Lukas

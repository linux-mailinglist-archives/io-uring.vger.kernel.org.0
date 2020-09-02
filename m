Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0592125AE6F
	for <lists+io-uring@lfdr.de>; Wed,  2 Sep 2020 17:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgIBPJ3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Sep 2020 11:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbgIBPHr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Sep 2020 11:07:47 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16D3C061245
        for <io-uring@vger.kernel.org>; Wed,  2 Sep 2020 08:07:44 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id n22so5273740edt.4
        for <io-uring@vger.kernel.org>; Wed, 02 Sep 2020 08:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iqtdMv3abzowF/OEz4wcuhtXvzAi2z9jpfg2F4BfYcQ=;
        b=WFazUa4N61ifRJlnYQHi8O9S3VgAQMEPTdQEauJq7V2cJtliBhrn7WCgagzenlabh4
         1gyL9aY8crPhiyzjc4af1FEWfM/i9SIIo/I2RHggzET3mAElA8fGdMwWqCHOyf3U7O6u
         Ox0xXERxUlpdf3k+sXglb6ZstIzJuZBn1x2r8/gki55tbfJlgC15saOfBdVXAqVb3+9h
         kL1HEYIPU7O4wZMJtrGoXgyjkYSf8OV2E0mBNOX+KuYEGx2eLgkuuXTH791x5ObpQewF
         aWWYtrIabLPO96AyUveKawZcylp0oO2ZYryhleKlGtWX78aAyfGcbeH2h15f739ZsiBC
         KexQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iqtdMv3abzowF/OEz4wcuhtXvzAi2z9jpfg2F4BfYcQ=;
        b=f29xxeML5J7hi/00cI5cLMhL4eJj/TyXrhBQBvexISN7OKDqUeVE6n8ItbXH7SQN6m
         wE9eB4dKyJfF5z0ESYMUd5ORnB/UczqS75AFqEbHePO97nZc6ef1qKr8tuVJ37TdZNR7
         Hlm4ilMBIJDg9/E9hqjKF36QzT8GMPQv+FOdH8ixClgnBWqQzahOAo7dXbSZ7d10TSeB
         NqtWkVXfQE4jQrhIOuqIOBPcEI4TwovYO/yYufqvVb0ICbOMfss+6w7v1IoFK2NmiqEs
         Amw1uXb2mUtaiPJKtTokrBZIPplXumXeAlnSZzbB5WqiBiz8GpBNCijL9cyrA/FPRTjZ
         VNhQ==
X-Gm-Message-State: AOAM532AiMF0wruyTAyk2mdZrO532CRZb4WAHMwL8roIr3/W9asfwGm3
        QGchF0cDscP9zH8eusOHdNuL0Y/8rZznq3iEUPGWtesbNXM=
X-Google-Smtp-Source: ABdhPJx3oPrgloSJR/eq46KKD2oHcFLZPUHKiGlAscJwY6J2sF2WA0sH/SCWXnxKSFhupXpvVv/x5Ynz0s8G3eMIfgM=
X-Received: by 2002:aa7:d4cb:: with SMTP id t11mr473083edr.223.1599059260713;
 Wed, 02 Sep 2020 08:07:40 -0700 (PDT)
MIME-Version: 1.0
References: <1599040779-41219-1-git-send-email-jiufei.xue@linux.alibaba.com> <c278224e-314d-e810-67f3-f5353daf9045@kernel.dk>
In-Reply-To: <c278224e-314d-e810-67f3-f5353daf9045@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 2 Sep 2020 17:07:14 +0200
Message-ID: <CAG48ez1MLMDPLA28HhRLcp+skk8KBawMq7qLv91kNY_prkZ4uw@mail.gmail.com>
Subject: missing backport markings on security fix [was: [PATCH] io_uring: set
 table->files[i] to NULL when io_sqe_file_register failed]
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Sep 2, 2020 at 4:49 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 9/2/20 3:59 AM, Jiufei Xue wrote:
> > While io_sqe_file_register() failed in __io_sqe_files_update(),
> > table->files[i] still point to the original file which may freed
> > soon, and that will trigger use-after-free problems.
>
> Applied, thanks.

Shouldn't this have a CC stable tag and a fixes tag on it? AFAICS this
is a fix for a UAF that exists since
f3bd9dae3708a0ff6b067e766073ffeb853301f9 ("io_uring: fix memleak in
__io_sqe_files_update()"), and that commit was marked for stable
backporting back to when c3a31e605620 landed, and that commit was
introduced in Linux 5.5.

You can see at <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/fs/io_uring.c?h=linux-5.8.y#n6933>
that this security vulnerability currently exists in the stable 5.8
branch.

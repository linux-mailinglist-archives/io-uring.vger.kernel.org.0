Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C6844B925
	for <lists+io-uring@lfdr.de>; Tue,  9 Nov 2021 23:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238599AbhKIXBg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Nov 2021 18:01:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242326AbhKIXBY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Nov 2021 18:01:24 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D358BC061234
        for <io-uring@vger.kernel.org>; Tue,  9 Nov 2021 14:58:14 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id w1so2627904edd.10
        for <io-uring@vger.kernel.org>; Tue, 09 Nov 2021 14:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mariadb.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=piVw7EQFiHd4yQr382mTiOSVMWD2myq2lpTp7X6eA3k=;
        b=O9CVHBq6fW+VYtGUwY7auFg42mdgiZ6EoM67vnO7Hnhax3TN4kIevGCFBAJvT9EunP
         26OsuxNhaTTNJUfY8PyTws2pMxGcU4PZlQp5J7S61j4fuCKeoiT85ON25cJKEy6P9S0Y
         afPCgJ0ZxvqgMBq8E1ZbhQwWUDGq5CEd0eRtINKk9nCoCuQSQaCbCDQkC3hsa+y6NxMt
         ilWyv/7z0LyQb/f/nSh9OmYhNXTNzap1QBKbMexdmH0wYndHv+VV4kkqTXiwPwYOvgdg
         aTKVFEOhNXGqQL3st+oyNekNX28t4y2y/h6RCtEWJqu8+60beAZLIfyGws8DPfpKTlkX
         UVdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=piVw7EQFiHd4yQr382mTiOSVMWD2myq2lpTp7X6eA3k=;
        b=i/LB9jvQEqJYvSeNJuQSudSE6bGARh71HdT9FNj7m57Y1wwO/FjVfeEQdq3/hkYIZ2
         kTKohuy30IyC5TKkia0EeO2wEnR4xdtzqP8nI1bZazuiDhb2PP6DNTmmtK7wQtiGzHrS
         LfG8A9hSSTEbFL7jre3OI/i7LEDDm0QhNYQzZWEskOt6gStiP4cF5SWUk53hifKVaBw2
         uKIdG4TJUIgwZEjdmXjT9d47NdCJX6bJeR5e8M/L3Ob1WxX5q0eHd0+xnTSvO+ni4kba
         9c3WmFQ5qnQejg3v3wKsWDG/a/CbWycTfKHn17iGVLjgTKZhEhs4+lecuz2T5vhiKwYY
         dP+w==
X-Gm-Message-State: AOAM532TcUXfvWygCtDX0ZCiPZQoGIQ9K5e2BB4RFpWldjB0IZoRuPaB
        LVgOxvmTZcutl9VCPnTljuHySQcEc2oRGPtoQI6w+4y+Jw1qJw==
X-Google-Smtp-Source: ABdhPJzlwcZnxz7msbWulktUOOQ9sLZGkeFb0OLKMvRh0D/3C7m/Xg2Ze/gLLrInjFuqa48yUkcnt3S5mV8QbwryQEg=
X-Received: by 2002:a17:906:ff47:: with SMTP id zo7mr14675046ejb.148.1636498693361;
 Tue, 09 Nov 2021 14:58:13 -0800 (PST)
MIME-Version: 1.0
References: <CABVffENnJ8JkP7EtuUTqi+VkJDBFU37w1UXe4Q3cB7-ixxh0VA@mail.gmail.com>
 <77f9feaa-2d65-c0f5-8e55-5f8210d6a4c6@gmail.com> <8cd3d258-91b8-c9b2-106c-01b577cc44d4@gmail.com>
 <CABVffEOMVbQ+MynbcNfD7KEA5Mwqdwm1YuOKgRWnpySboQSkSg@mail.gmail.com>
 <23555381-2bea-f63a-1715-a80edd3ee27f@gmail.com> <YXz0roPH+stjFygk@eldamar.lan>
 <CABVffEO4mBTuiLzvny1G1ocO7PvTpKYTCS5TO2fbaevu2TqdGQ@mail.gmail.com>
In-Reply-To: <CABVffEO4mBTuiLzvny1G1ocO7PvTpKYTCS5TO2fbaevu2TqdGQ@mail.gmail.com>
From:   Daniel Black <daniel@mariadb.org>
Date:   Wed, 10 Nov 2021 09:58:02 +1100
Message-ID: <CABVffEMy+gWfkuEg4UOTZe3p_k0Ryxey921Hw2De8MyE=JafeA@mail.gmail.com>
Subject: Re: uring regression - lost write request
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> On Sat, Oct 30, 2021 at 6:30 PM Salvatore Bonaccorso <carnil@debian.org> wrote:
> > Were you able to pinpoint the issue?

While I have been unable to reproduce this on a single cpu, Marko can
repeat a stall on a dual Broadwell chipset on kernels:

* 5.15.1 - https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.15.1
* 5.14.16 - https://packages.debian.org/sid/linux-image-5.14.0-4-amd64

Detailed observations:
https://jira.mariadb.org/browse/MDEV-26674

The previous script has been adapted to use MariaDB-10.6 package and
sysbench to demonstrate a workload, I've changed Marko's script to
work with the distro packages and use innodb_use_native_aio=1.

MariaDB packages:

https://mariadb.org/download/?t=repo-config
(needs a distro that has liburing userspace libraries as standard support)

Script:

https://jira.mariadb.org/secure/attachment/60358/Mariabench-MDEV-26674-io_uring-1

The state is achieved either when the sysbench prepare stalls, or the
tps printed at 5 second intervals falls to 0.

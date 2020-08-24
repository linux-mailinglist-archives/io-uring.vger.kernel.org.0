Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE41524FBAF
	for <lists+io-uring@lfdr.de>; Mon, 24 Aug 2020 12:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgHXKlQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Aug 2020 06:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727768AbgHXKlK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Aug 2020 06:41:10 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E8CC061755
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 03:41:06 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id s15so3471072qvv.7
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 03:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=nrgPYb9eYYRB4kqx8NyxdoJAys+pE6Xw0XKKImlMci0=;
        b=HkZg5FCC91ITjsk2L5OTsdqKOPBVfSnUeTfPOpIpgadjtpMwRY6ni6K3zHwrHMZZKz
         ymnZ5OexkScOuiO1tFwcq30MV+6o7pjAQcpovvWGmzaEohvhFFQQDwoBM6cEBGkSHSLk
         2Gvvgb2RZzgb7OD//twFMhMNq9Lt85kjhrmzqxPWrq0P/vCome3PqjyhQnEkD9nIA4/J
         i7uoBqt9XrmPerDBD3VRIxvfe+HzHNsKaNbpbRzzmMGMueDFucPtl+pX8a0UVXOjW7Ya
         3x0VaxxQtEqxT1ZlC3GpK8p4XvqbnqU8fIZDcVnpvE5Gg4wp6TniPful1wVaVMv+ljc9
         D4Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=nrgPYb9eYYRB4kqx8NyxdoJAys+pE6Xw0XKKImlMci0=;
        b=lyoZzcv3kEZOb3SUdCktq9jDqnMbuKxDeL6y2mzBbc63ZefPI142j964RJr+z2YoSj
         npKIyZxnX7lRFLAeWO93ggbOWnyAtLKr1Oodk3yU5TaF19/3tfktJ5GtWEuJY6HaIQTi
         6G946+bSFQlpz4//3HK4Bpr6VubEAscbDdrQRPJYGuGXJGjf25FfVXpXubDHJkst95LF
         0CntBK9cufvtHN1u49eWkDa4lEEEf3Kzo/nU8tli6t3CGX8dsFj2rFYlNinPOCimsPaZ
         39Lfv16GA3BMmiV7aBm5rmMTU6ea908Ik4Fi4w9ZRhsKh+pbMlBK3+awupzHNgVLHx2k
         OvuA==
X-Gm-Message-State: AOAM531nQlOFA5ZQgNNbJbWVCKCAISsy9kZfZPrwgNATJ5Lz51Gbn0vj
        aO8uct5Mt+bjRO9tndMhpPtuJTeAU+UNutFSvb5T/DppWuFexA==
X-Google-Smtp-Source: ABdhPJzDN4NgVWWablvRzWs7neLubbNBUEGw97bVhYEXFm/KDk9Wsj2ybUeuNuMoy2Ur9alKeTO1A3K6RarerJoWZqc=
X-Received: by 2002:a05:6214:12b4:: with SMTP id w20mr4177711qvu.32.1598265664320;
 Mon, 24 Aug 2020 03:41:04 -0700 (PDT)
MIME-Version: 1.0
From:   Dmitry Shulyak <yashulyak@gmail.com>
Date:   Mon, 24 Aug 2020 13:40:52 +0300
Message-ID: <CAF-ewDqBd4gSLGOdHE8g57O_weMTH0B-WbfobJud3h6poH=fBg@mail.gmail.com>
Subject: Large number of empty reads on 5.9-rc2 under moderate load
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In the program, I am submitting a large number of concurrent read
requests with o_direct. In both scenarios the number of concurrent
read requests is limited to 20 000, with only difference being that
for 512b total number of reads is 8millions and for 8kb - 1million. On
5.8.3 I didn't see any empty reads at all.

BenchmarkReadAt/uring_512-8              8000000              1879
ns/op         272.55 MB/s
BenchmarkReadAt/uring_8192-8             1000000             18178
ns/op         450.65 MB/s

I am seeing the same numbers in iotop, so pretty confident that the
benchmark is fine. Below is a version with regular syscalls and
threads (note that this is with golang):

BenchmarkReadAt/os_512-256               8000000              4393
ns/op         116.55 MB/s
BenchmarkReadAt/os_8192-256              1000000             18811
ns/op         435.48 MB/s

I run the same program on 5.9-rc.2 and noticed that for workload with
8kb buffer and 1mill reads I had to make more than 7 millions retries,
which obviously makes the program very slow. For 512b and 8million
reads there were only 22 000 retries, but it is still very slow for
some other reason.

BenchmarkReadAt/uring_512-8  8000000       8432 ns/op   60.72 MB/s
BenchmarkReadAt/uring_8192-8 1000000      42603 ns/op 192.29 MB/s

In iotop i am seeing a huge increase for 8kb, actual disk read goes up
to 2gb/s, which looks somewhat suspicious given that my ssd should
support only 450mb/s. If I will lower the number of concurrent
requests to 1000, then there are almost no empty reads and numbers for
8kb go back to the same level I saw with 5.8.3.

Is it a regression or should I throttle submissions?

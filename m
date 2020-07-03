Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688A3213FA2
	for <lists+io-uring@lfdr.de>; Fri,  3 Jul 2020 20:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgGCSsj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Jul 2020 14:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgGCSsj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Jul 2020 14:48:39 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7AAC061794
        for <io-uring@vger.kernel.org>; Fri,  3 Jul 2020 11:48:38 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f18so25671975wrs.0
        for <io-uring@vger.kernel.org>; Fri, 03 Jul 2020 11:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=fnaq+4JzEEM5eIoG/yGUElJ8ggwK5uFxmVYorNjjoFU=;
        b=fSJwmiq7SmnmSChZz3AGny22WKLnv0H/xUkCiYysGnxn8vafgzQUqttS43Xej3g1VK
         raNpitdlWxDuGQogkdGBU5nQKcInHisTAfcHQ8UdHWD4nelxA1D3G6/ZAd2Fq0TTqRFi
         ZI9Tj3vB3n/3pFSrpMJGSe8Hg8SI218gra2aV0r93pjf0z3mXkJfDaYjBKBYJacA4jlg
         LB+9a4+lLIv8kFEZotz8PI/Glsy/DZldJ9sGKnwqqLau8uy4Xsy1SQhomlPzB1fbpSVQ
         XcDVMHSfq/eCHRvIliSRqH4Ryg92tt1sbicCaHBeP+NWnCvK7fqeB0geZbRdaZEqHCT6
         mG2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=fnaq+4JzEEM5eIoG/yGUElJ8ggwK5uFxmVYorNjjoFU=;
        b=Pe4Mn66y6hQLxE3mqqfpru09jQmY0n3luWo37g5Hen1L158KoTHg2EH8SyFzZ/9GGJ
         IHn01/Y7W8jhTyTBX8mtaKumzULY0vgU0LBXz8VeY6UuXyuasitjPDdeKJu17Df82Wmw
         fC8z18VYVKKx8yDWK4c/K9s14GBr4w8HA84qhtHLoCrAn90vAl8qpPFSBxg9Cji2eYL4
         BtKOcjXPjB8CJdAcz5QenO0vAjWMNBuXIUWESczong/tltpGC4CXx5W2bGlGAC3O3Bja
         iPS0XwXGNeBHpF2T+Gw3gITngL0kr4DXrARNWw/eeo47kAd+eU3jg4h5K8AugDbokgwL
         XKEA==
X-Gm-Message-State: AOAM531tYqy9Fzf8Y85BmKvvZOgrJ9Tmx8Y+KP8KoRVuoty8XvH/nfGY
        wIuY4Bxlu5Nd8PWYZ2YC1DLVn5me5qAmMR2ZgnzDrHESmDM=
X-Google-Smtp-Source: ABdhPJyFsp6+hVW8SoizumHr+W2Y4A8D67PZnrXgLSg/dqf5dJ/u3LZOBP56Q5/gUveKt36WhKHeJ5KeDv1zZltRhLg=
X-Received: by 2002:adf:f083:: with SMTP id n3mr38279246wro.297.1593802117084;
 Fri, 03 Jul 2020 11:48:37 -0700 (PDT)
MIME-Version: 1.0
From:   Daniele Salvatore Albano <d.albano@gmail.com>
Date:   Fri, 3 Jul 2020 20:48:10 +0200
Message-ID: <CAKq9yRg1NkEOei-G8JKMMo-cTCp128aPPONeLCGPFLqD5w+fkA@mail.gmail.com>
Subject: Keep getting the same buffer ID when RECV with IOSQE_BUFFER_SELECT
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

I have recently started to play with io_uring and liburing but I am
facing an odd issue, of course initially I thought it was my code but
after further investigation and testing some other code (
https://github.com/frevib/io_uring-echo-server/tree/io-uring-op-provide-buffers
) I faced the same behaviour.

When using the IOSQE_BUFFER_SELECT with RECV I always get the first
read right but all the subsequent return a buffer id different from
what was used by the kernel.

The problem starts to happen only after io_uring_prep_provide_buffers
is invoked to put back the buffer, the bid set is the one from cflags
>> 16.

The logic is as follow:
- io_uring_prep_provide_buffers + io_uring_submit + io_uring_wait_cqe
initialize all the buffers at the beginning
- within io_uring_for_each_cqe, when accepting a new connection a recv
sqe is submitted with the IOSQE_BUFFER_SELECT flag
- within io_uring_for_each_cqe, when recv a send sqe is submitted
using as buffer the one specified in cflags >> 16
- within io_uring_for_each_cqe, when send a provide buffers for the
bid used to send the data and a recv sqes are submitted.

If I drop io_uring_prep_provide_buffers both in my code and in the
code I referenced above it just works, but of course at some point
there are no more buffers available.

To further debug the issue I reduced the amount of provided buffers
and started to print out the entire bufferset and I noticed that after
the first correct RECV the kernel stores the data in the first buffer
of the group id but always returns the last buffer id.
It is like after calling io_uring_prep_provide_buffers the information
on the kernel side gets corrupted, I tried to follow the logic on the
kernel side but there is nothing apparent that would make me
understand why I am facing this behaviour.

The original author of that code told me on SO that he wrote & tested
it on the kernel 5.6 + the provide buffers branch, I am facing this
issue with 5.7.6, 5.8-rc1 and 5.8-rc3. The liburing library is built
out of the branch, I didn't do too much testing with different
versions but I tried to figure out where the issue was for the last
week and within this period I have pulled multiple times the repo.

Any hint or suggestion?


Thanks!
Daniele

Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8071543866D
	for <lists+io-uring@lfdr.de>; Sun, 24 Oct 2021 05:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbhJXDZq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Oct 2021 23:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbhJXDZq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Oct 2021 23:25:46 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1A1C061764
        for <io-uring@vger.kernel.org>; Sat, 23 Oct 2021 20:23:25 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id r28so2965675pga.0
        for <io-uring@vger.kernel.org>; Sat, 23 Oct 2021 20:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q2uaKgg4TCzVF+cRh9oxDgLRgxuU0wzNZt0+uOs53yA=;
        b=XKhUG+hS8p4a8WijYCNHh4N3sLXIfsUJAZyHLTLaaf8PaIf1sOPI3mJxz9+AKu26ML
         OH5fRUP8UUnbFSOn5EWZBIz0erK4Zq+hmi+KOdlHjBMuRCXaLTPAh+S1R0YkTfZr36Cr
         /tPNMZ5LvjopgiNwI3EPWLLH5YEizNN/Ei9JEoHGjSu4jYm68WquI6flgTVoXOfTLf9L
         GnDs2wwCASWLO+mSgHtW0AM7wUB3I4zMNfBStX7FJtR0Hnfu+FpMTeUSbIFzucV86GUK
         bWmm0TNjmnRrIpGhbArIu+XjOn5E1O/8YcRH0djb0SYUZiJL4E/OSB/Ynj6uUWcoocqr
         c0SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q2uaKgg4TCzVF+cRh9oxDgLRgxuU0wzNZt0+uOs53yA=;
        b=RukNctAqe5uYb1yecEmg776JPdR2P/ECb1Z9R5IuVkbi0gtNeltuXHiY+geDwTGwFy
         wVf4OD4wo+S/+ijMgmYwnDTHUnkoyEd/2b5bmnuyxjiKZpGZphbAbx4BvZYwQNacg1M2
         eQrWPSpyIGuI6JhbYv8AvzvSQa14U9OxMkJPzN3sOFpF4tFXSzVUjORZOPaiUfmIzfo6
         Ydg146ArrP7AdhARun3lOLv9TRa44CiEFdwE6aMAdh3Ub2iXXwvGu7LjwRzMBo4TUBAN
         dm4JnRxU7YiF7HNiq0Yd1RdxzTggquPUiqHwBqn16UtQtslbDnaBBWzV1j0uQ6se2DOS
         2ZCg==
X-Gm-Message-State: AOAM530zKHoc09OUOKrvUenlohuU2S5UunN5awsOwfjFJZlb5ni22zNv
        ZhE9LXRay9AdAajfSKr0UyhzmQ==
X-Google-Smtp-Source: ABdhPJwYbqnbJzPOaXw4sERygvezx3e+Y4kc4QuRO2W8gYbZDe/YreP2Kx2Gkdmia+OcAprSNll21A==
X-Received: by 2002:a63:7881:: with SMTP id t123mr7041622pgc.150.1635045804354;
        Sat, 23 Oct 2021 20:23:24 -0700 (PDT)
Received: from integral.. ([182.2.37.49])
        by smtp.gmail.com with ESMTPSA id 129sm985243pgd.3.2021.10.23.20.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Oct 2021 20:23:23 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Praveen Kumar <kpraveen.lkml@gmail.com>, io-uring@vger.kernel.org
Subject: Re: io-uring
Date:   Sun, 24 Oct 2021 10:22:03 +0700
Message-Id: <31ae179c-818e-5232-f035-64047ede0d65@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <4a8f1917-e5af-b4a8-9938-e129987adc92@kernel.dk>
References: <e17b443e-621b-80be-03fd-520139bf3bdd@gmail.com>, <4a8f1917-e5af-b4a8-9938-e129987adc92@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Sat, 23 Oct 2021 09:02:24 -0600, Jens Axboe wrote:
>On 10/23/21 2:08 AM, Praveen Kumar wrote:
>> Hello,
>> 
>> I am Praveen and have worked on couple of projects in my professional
>> experience, that includes File system driver and TCP stack
>> development. I came across fs/io_uring.c and was interested to know
>> more in-depth about the same and the use-cases, this solves. In
>> similar regards, I read https://kernel.dk/io_uring.pdf and going
>> through liburing. I'm interested to add value to this project.
>> 
>> I didn't find any webpage or TODO items, which I can start looking
>> upon. Please guide me and let me know if there are any small items to
>> start with. Also, is there any irc channel or email group apart from
>> io-uring@vger.kernel.org, where I can post my queries(design specific
>> or others).
>
>Great that you are interested! It's quite a fast moving project, but
>still plenty of things to tackle and improve. All discussion happens on
>the io-uring mailing list, we don't have a more realtime communication
>channel. Might make sense to setup a slack channel or something... But
>for now I'd encourage you to just participate on the mailing list, and
>question there are a good way to do it too.
>

Hello,

We have several unresolved issues on liburing GitHub repo. Maybe they
can be the TODO list?

Most of them are kernel side issue, so they need to be resolved from
io_uring.

Link: https://github.com/axboe/liburing/issues

I would love to contribute too. But my experience in kernel space
programming is not yet ready for that. I can test the patches. I
can also integrate the feature with liburing, create regression test,
and some userspace stuff work.

Recently, I nudged this one:
  https://github.com/axboe/liburing/issues/397

The work is to add recvfrom() and sendto() operation. You can CC me if
you're willing to pick up this work. I can do the liburing part and
create the test.

-- 
Ammar Faizi

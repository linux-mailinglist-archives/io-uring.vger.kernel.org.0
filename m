Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A78946DBCA
	for <lists+io-uring@lfdr.de>; Wed,  8 Dec 2021 20:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbhLHTLA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Dec 2021 14:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbhLHTK7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Dec 2021 14:10:59 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEBBC061746
        for <io-uring@vger.kernel.org>; Wed,  8 Dec 2021 11:07:27 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id l5so3112743ilv.7
        for <io-uring@vger.kernel.org>; Wed, 08 Dec 2021 11:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=hSP1nAh6k7DSBYeomu2TmgC5KMietK7YFB6eywMFEiE=;
        b=UOXEEPT8I97djbVypBJUXdbpR9GWlk/rOSl4jtwUE2s7IQXgCtNC+o2nt1NYArJiC+
         CUOn3bMcofbwa0tTNV44Hd1kBriPFNg4HfdSJn/RUZbxvjcdhSkG2iKt0Qttt6Rt+B2B
         Kl1y4fYQTOHR4gQ48yfB0etS1DBMHpga5zvi07lwZvJWlyIFszB1QdOW8EtRvqcAU4NQ
         VgAk7prEvIuxxokC+hVbn68qW0yuLklTOKbVuGjiHiVrQPAWos9hqnHr9Bsei9X7adwV
         HCsWcZ8E325sP6AtntcYFPgvS7jhzaA5LbRnHQSyEy+Dgl+XVZrLCnPjCYs7SC8eAQfD
         SFhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=hSP1nAh6k7DSBYeomu2TmgC5KMietK7YFB6eywMFEiE=;
        b=fh2CPl5hyPQe4rLkkKc56jhGYobzPoj6jAggwc6VsAx3M7GqZgCn0F0OITrgchga/a
         mXNeyFIp7q4BG2sbQUjVbq0iZ9zM9pfqBb2aoGn6LJGcLH/o0lGTfWuuWybJKX1Lr+Z3
         JLRvCThHY1zWAuONx/9QfF9eLtlq/OuxwFkbjn3vLaNhxTIm7zoGyYELU8GNEDlu4Heq
         eE8LmH9gFCTZE6X/f34FrxIV+1Uee2C4R22HOcwE2qK5k2Sb4aH67Ts9BJCAgqhEXBsh
         IrL5wKgQe5pMyPlzXGPRNWmIP5tsNuTa8SN6qresY4PJ8OOnGEG7kq+v1BSwCMgmaSS3
         nnlg==
X-Gm-Message-State: AOAM533wAqa6uW/BqvAzHz4TrLtDepEnlYez1CerpaI8fRwa7SRl3B0c
        oaG++jrFZHRMkiQ0fe3OQlEXckYGZoM=
X-Google-Smtp-Source: ABdhPJxDLf3ArqBsmz+yhDtNKe++TVTk3ZpChLK/CbudJ2fidNTTsl2lFfrswvUUSZ0Tp1dzPEnQOw==
X-Received: by 2002:a05:6e02:20ed:: with SMTP id q13mr1635101ilv.253.1638990447221;
        Wed, 08 Dec 2021 11:07:27 -0800 (PST)
Received: from p51.localdomain (bras-base-mtrlpq4706w-grc-05-174-93-161-243.dsl.bell.ca. [174.93.161.243])
        by smtp.gmail.com with ESMTPSA id b6sm2499613ilv.56.2021.12.08.11.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 11:07:26 -0800 (PST)
Received: by p51.localdomain (Postfix, from userid 60092)
        id 31D5B11B7BA3; Wed,  8 Dec 2021 14:07:33 -0500 (EST)
Date:   Wed, 8 Dec 2021 14:07:33 -0500
From:   jrun <darwinskernel@gmail.com>
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>
Subject: happy io_uring_prep_accept_direct() submissions go hiding!
Message-ID: <20211208190733.xazgugkuprosux6k@p51>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hello,

- this may very well be something simple i'm missing so apologies in advance. -

_some_ calls to io_uring_prep_accept_direct() never make it back from
kernel! or they seems so... since io_uring_prep_accept_direct() is a new
introduction to io_uring i thought i check with you first and get some help if
possible.


---------
TEST_PROG:
---------

this msg has a git repo bundled which has the crap i've put together where i
encounter this. to compile/run it do this, save the bundle somewhere, say under
`/tmp/` and then do:

```
cd /tmp/
git clone wsub.git wsub
cd wsub
# maybe have a look at build.sh before running the following
# it will install a single binary under ~/.local/bin
# also it will fire up the binary, the server part, wsub, right away
sh build.sh

# then from a different terminal
cd /tmp/wsub/client
# in zsh, use seq for bash
MAX_CONNECTIONS=4; for i in {0..$MAX_CONNECTIONS}; do ./client foo; done
```

srv starts listening on a *abstract* unix socket, names after the binary which
should turn up in the output of this, if you have ss(8) installed:

`ss -l -x --socket=unix_seqpacket`
it will be called `@wsub` if you don't change anything.

client bit just sends it's first arg, "foo" in this case, to the server, and
srv prints it out into it's stderr.


--------
PROBLEM:
--------

every calls to io_uring_prep_accept_direct() via q_accept(), before entering
event_loop(), main.c:587, get properly completed, but subsequent calls to
io_uring_prep_accept_direct() after entering event_loop(),
main.c:487 `case ACCEPT:`,
never turn up on ring's cq! you will notice that all other submissions inside
event_loop(), to the same ring, get completed fine.

note also that io_uring_prep_accept_direct() completions make it once there is a
new connection!

running the client bit one-by-one might illustrate the point better.

i also experimented with using IORING_SETUP_SQPOLL, different articles but same
result for io_uring_prep_accept_direct() submissions.

thoughts?


	- jrun

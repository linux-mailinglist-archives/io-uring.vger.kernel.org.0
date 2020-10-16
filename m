Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C983290910
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 18:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409115AbgJPQCc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 12:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409137AbgJPQCa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 12:02:30 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21ECBC061755
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:29 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id gv6so1761634pjb.4
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dkCKRq5TDtmI1XdxL+jJgGQqqvF6gKpOdqxciHVS1EE=;
        b=ZT3IH2MXKuOORkgptoJSAiWIAE2e6lHz/cDzGPABHSAENMUdij2yz8Tn/79SU/49rT
         x1oQ9VSMyhlfDEihf6OV3dFyKk+Tq4k+2+2AGqUdki2jfAjsT3a/uzYz6UvcFaKWP8Sc
         v8tCOkFeZXeB34YtWuCh4YYUqAGtLuM+TsS+6iUH9HhssAfZu4tZ7A9KRZxVbrSKhKlH
         qOfXUl65ta55AQhb7JyMYm5MYu43ZapdfeIjHj5k3UngqeEBG98vjHJOzyRuJxWcN2Jd
         tDyMQIiyPS1sT+ixEFN8rTsRBf1xRjMtoDhTMe1r8MWwtABGukQp6WMOYA4X+QshoNAN
         6MIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dkCKRq5TDtmI1XdxL+jJgGQqqvF6gKpOdqxciHVS1EE=;
        b=tua6xA5kd3U0IUSCh8B02857+GnoldKukuhjWY2VHabGjidREuM4VVlVIN13jaWbYt
         YhfHzA6VEOov20RKNBm/Ur8TAEkjkFG3ZnwDFv+2Etu2ZTfxxwhDQ1Xbskh8K0AKwBnz
         F+9FuYw1YLmpLU/ghGKmUFRHKiXAdo3Fkpkfo9GhrQ2hirU+OrEqpPfKnDRU3xGwGjD6
         LAs+DU5/RZQpN3YmcYLXeUkck/iA8gaI2KvyJ+ZDrlH67cPJ2MJxeYBVzcRa0N5vFEAE
         u6USsVXBpDQBdagGA3kgw5kwG/GiD7hNJYdT9gB/jgtrUj46BCimG7MxQH5Q691uheEq
         dK5A==
X-Gm-Message-State: AOAM533ZL5toLtvsXN5ZpVlaYaOyTJhAwzZDQakbiBzmBfGcdvi3FdNh
        mM3DlzzM8jpVe0kVwIv/sxhDV3FSD9b98ERi
X-Google-Smtp-Source: ABdhPJzhnbD5HfGNjCh0V/EUfBCJuKeReOfLLqwoi9ReUdOYhntCyIa9dMt33acqOYeZGjONMyOc2g==
X-Received: by 2002:a17:90b:3902:: with SMTP id ob2mr4961658pjb.178.1602864148378;
        Fri, 16 Oct 2020 09:02:28 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t13sm3190109pfc.1.2020.10.16.09.02.27
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 09:02:27 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHES 0/10] Fixes queued up for 5.10
Date:   Fri, 16 Oct 2020 10:02:06 -0600
Message-Id: <20201016160224.1575329-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

These are items that weren't quite ready for the initial merge window,
or fixes for merge window (or other issues).

- Series from Pavel fixing up REQ_F_COMP_LOCKED
- read-ahead improvement
- Revert of a bad __read_mostly commit from the merge window
- Fix for a merge window regression with file registration
- Fix for NUMA node locality for io-wq
- Addition of io_identity to store any identity information, and moving
  of state to there. This is both a cleanup series and prep for adding
  more items there, as needed.
- Use percpu_counter for inflight tracking instead of separate
  issued/completed atomic counts


 fs/io-wq.c               |  41 +--
 fs/io-wq.h               |  18 +-
 fs/io_uring.c            | 619 +++++++++++++++++++++++----------------
 include/linux/io_uring.h |  23 +-
 mm/readahead.c           |  22 +-
 5 files changed, 423 insertions(+), 300 deletions(-)

-- 
Jens Axboe



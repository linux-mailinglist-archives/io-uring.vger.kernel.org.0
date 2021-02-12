Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B5431A05A
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 15:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbhBLOJW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Feb 2021 09:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbhBLOJN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Feb 2021 09:09:13 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446B0C061574
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 06:08:33 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id m20so8203483ilj.13
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 06:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=4yLdmEfsOqQtkf+ITcJlib5SajgXGGnW36StIPCW4CM=;
        b=e7MmlWkqxBjub+KZntgQ/qZ+BwwY1TSoEC8T9zgo3mqjteHnkqExJejEqftsd9evYn
         43iiadLIjAx2niYfJsitdPS1B15xoGx50Ql2Q2YAJqBd+B462z6z3xA5HLLZCX0Zd/rN
         bbjD33GfYtxven/44fpyaSxF4ouRDXSnIxhgn3d5mFuoHZb0IdJfdoH8cel4EoN/Z1BG
         3HsGMDbR8MJVsIXwWT4m6oshS4y7FoG7fXXqVVUHdyr8ujeXpowMCeGzSInvsPDN3HW3
         EGYZyyHMOufbrpjukOzQB/v6UEmiuwmS8PrUNre91q0e7XpLJLw3TZTAlo6hQMjDP77F
         1M3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=4yLdmEfsOqQtkf+ITcJlib5SajgXGGnW36StIPCW4CM=;
        b=dDF+ISIeI5tYVpacHeT0ppHzA4uu4V1NHb0PlQrwayWDsg6SgkNennP0XUhgnFp+Bh
         L6bGsAp1SpWkgenGNc37kx6z+F+Al1XcaK7G174xzouC5RYekrdb7flB8jsuFeBEFI+l
         5DbPuQMcc1P/np5l90DYXAO3+/GPHuwlFWrvlMzISJVpKqu2TMtYtGeVo4F6oGQoCkAg
         vxhywqUnUI/Bw+dbsP4ZKvAGxpLZJi7lFSWujz+XQF2yaqcHoEKdxw0mOR9NIU5g/ZH6
         JqN97XEFng3HgkUBs0FAdNFL2nRtqLoxrJtL0sqGZt5N8u5goruc8RETmpCf2gqACqnE
         0cqg==
X-Gm-Message-State: AOAM532SgDxlkWkTWdDqd6nKdpj8gkLWbiAmhe39F+Hx7/atFcH76VL5
        3Z7L2KEckLx4CpRhY5CY3lY3dzxxzn+nq1DS
X-Google-Smtp-Source: ABdhPJzpERecDGui2yVx7eQcW8jTvXRtUC387FQB9f8sBu+Zgh4E9+a38Awq5bc7iyxTwl8UVXwj9Q==
X-Received: by 2002:a05:6e02:1c8d:: with SMTP id w13mr2471587ill.301.1613138912413;
        Fri, 12 Feb 2021 06:08:32 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w1sm2178462ilv.52.2021.02.12.06.08.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 06:08:31 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 5.11 final
Message-ID: <a1f5c4b9-5c5d-a184-7ede-78739e1c01c6@kernel.dk>
Date:   Fri, 12 Feb 2021 07:08:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Revert of a patch from this release that caused a regression. Please
pull!


The following changes since commit aec18a57edad562d620f7d19016de1fc0cc2208c:

  io_uring: drop mm/files between task_work_submit (2021-02-04 12:42:58 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.11-2021-02-12

for you to fetch changes up to 92c75f7594d5060a4cb240f0e987a802f8486b11:

  Revert "io_uring: don't take fs for recvmsg/sendmsg" (2021-02-10 12:37:58 -0700)

----------------------------------------------------------------
io_uring-5.11-2021-02-12

----------------------------------------------------------------
Jens Axboe (1):
      Revert "io_uring: don't take fs for recvmsg/sendmsg"

 fs/io_uring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

-- 
Jens Axboe


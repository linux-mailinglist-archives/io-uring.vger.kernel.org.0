Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B661C214C95
	for <lists+io-uring@lfdr.de>; Sun,  5 Jul 2020 15:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgGENFx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Jul 2020 09:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgGENFw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Jul 2020 09:05:52 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D29FC08C5DE
        for <io-uring@vger.kernel.org>; Sun,  5 Jul 2020 06:05:52 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id e8so17181200pgc.5
        for <io-uring@vger.kernel.org>; Sun, 05 Jul 2020 06:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=hUG7wwDDkhtMducaWVZ0O0Oom1LcQiUMTGXQXJrxsz4=;
        b=mN+s6EMeW/Us0EwzKFvefY+QMVbP3m5P9hkpsM6Uj5kjai7ofDa/SuVK3T64HWpFYC
         /eF/N+M8vybQ7Tuiasu4dHF/MtgfPoXEqE4hAu1rEI0MpGlzO6hSQd85LOdR650SoQxn
         CoVdZwxse3ed3FiA/pNDMvo0G0CVCXFRP52j3h0ge3rbI6Kg+nqLuzxicaLf/XAAxkdM
         hm7n8GSrHD0vPG7Uz8LIVVZnqB7Qj1BLqNMSLlJRxzrSviMvnLL2AY8ATheVpJDtlhvD
         7b1CvzRfsKzv18RmFBRrY865Kk3DLnasJ8V/oJ1/6ogPiK3AnVbRmftPuRLcbxawUKRe
         Ggig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=hUG7wwDDkhtMducaWVZ0O0Oom1LcQiUMTGXQXJrxsz4=;
        b=cg32Ilq8VJrgY1XNqVjzFjHyyf/exy7cTLmhkr/wQqrVK38CodiWXDknbSPaP8KU0k
         8tBI3NwM3x26883Q99F6EPQtrDlkuI9+tCxHjIV5jCfrr9ufKtbWAxCJLz79H6QV19xC
         vNeXYFY6sQ96C30I+SKR0Sb8lhnE784yP6vXXoM2VrBX3IcKZK7ufHDUWjHsggbSHFkY
         UHhIm/ws2Og5zpy4Fy1edBz1+MKSG1VOx20imGQaft/JsgbHZ/w1hvMBvnQDVfrxYYjq
         4VlAmedZMBcBzJTp/N7X26RQRfAv/OhlzBhEmFiHfTHSC7D5Hgwg3EiNh2I6cPrMKTJ1
         GQJA==
X-Gm-Message-State: AOAM5326TMd/72mrapVDOTjCcBxq9zsJSXVIR+LiCmsM4YV620qOwDzu
        xOW5ESaLGRx4z2HymDe28o8SHA==
X-Google-Smtp-Source: ABdhPJy3PO49E0KDQtPtq5ASvGq8Y4zwJ94qgE77HcE0epmBG2nam8BwHd2KKLxXQEQZokSLRtDm7A==
X-Received: by 2002:a63:441c:: with SMTP id r28mr34871342pga.372.1593954351017;
        Sun, 05 Jul 2020 06:05:51 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id g8sm16342989pgr.70.2020.07.05.06.05.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 06:05:50 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 5.8-rc4
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <39012c6d-b53c-703f-218d-9d8fddd9871f@kernel.dk>
Date:   Sun, 5 Jul 2020 07:05:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Andres reported a regression with the fix that was merged earlier this
week, where his setup of using signals to interrupt io_uring CQ waits no
longer worked correctly. Fix this, and also limit our use of TWA_SIGNAL
to the case where we need it, and continue using TWA_RESUME for
task_work as before.

Since the original is marked for 5.7 stable, let's flush this one out
before -rc4 is tagged.

Please pull!


The following changes since commit ce593a6c480a22acba08795be313c0c6d49dd35d:

  io_uring: use signal based task_work running (2020-06-30 12:39:05 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.8-2020-07-05

for you to fetch changes up to b7db41c9e03b5189bc94993bd50e4506ac9e34c1:

  io_uring: fix regression with always ignoring signals in io_cqring_wait() (2020-07-04 13:44:45 -0600)

----------------------------------------------------------------
io_uring-5.8-2020-07-05

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: fix regression with always ignoring signals in io_cqring_wait()

 fs/io_uring.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

-- 
Jens Axboe


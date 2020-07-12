Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0E821CA25
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2020 18:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbgGLQao (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jul 2020 12:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728859AbgGLQan (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Jul 2020 12:30:43 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5F5C08C5DB
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 09:30:43 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id o22so4982182pjw.2
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 09:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=fduEEX0FvmLvbjM6DjKUizgxNHtjjRTc20Yn5n2GOU4=;
        b=uF/QHLQpIEkXpsDzG6f4pmhhE6qd8Z/6Z1lxRzQNgJES9td/xuPCsUWjaFhAlRoGqv
         Kr10QnkY9xqNmEu++t1ZGnBUXDpGTw0i8nQrxwLGrm8IT/wcJXGtx3cDvFfLirVv/RRt
         /xGMIujy+bPfN2tgXps+2+sid/uBaRwmZ49ZerJSk6VNeuftQP/y/6qPQqgcz/4V4YYL
         WlwE/eiSuGFKqg6c3aEMg7l9p9Ti9D9MBTFSmuT6xlqiECAkCYWDomuUVEyPh+CSy4Jh
         VkQ44y3grWAO7hLcaMg+fxkvEO5W/aq8zyoSQIltKTNC9yCKoOGN9+t4v5dn1r/60xDl
         JTzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=fduEEX0FvmLvbjM6DjKUizgxNHtjjRTc20Yn5n2GOU4=;
        b=A25KbSjMXTKgZLHqwFslyFVhmSZwCobmVW22zyauvz0HF+AKrcixF+uRRvZdF+bmyn
         H3d+yizQkdKjzJI8/aEheESzGMWMmxWPhhS9aaUs21J36Xj20w2Guz6DB/BzMdRO5Qdl
         NEMKzOUagzgsaK34OQGxlJuIK1VIXm3vKeHNMz41xDmfyhcBcsDZCMHGyRxARFzut3GP
         XUZ9u6UDrli/KnlrzzRUv0ag5tZ72ea43TRlzPInkRen6iKdNdqrV2prLLcfWSvymiGV
         DAZk9tGTRVoOLcXekhQbuxAnWfveiWljKluHFx+6AeB6gTbr8ET8KH7MhCmjRnIjhVOC
         sl+A==
X-Gm-Message-State: AOAM533uD0tnBVgmlKYURmhsfg+pW2LFEjSJrdyW5kz+JxtufcPYQ4vn
        gc9pPXoE4hr/2MQw1QW6wDZkdw==
X-Google-Smtp-Source: ABdhPJwdHApLEQXID+EPdWAxQbWH/w7vmc3jSPVQLWW6Te77B3fnsXw+3basNFqIrvxZNLWQ0CJAMQ==
X-Received: by 2002:a17:90a:30c2:: with SMTP id h60mr15281620pjb.23.1594571442362;
        Sun, 12 Jul 2020 09:30:42 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id n2sm11176025pgv.37.2020.07.12.09.30.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2020 09:30:41 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.8-rc5
Message-ID: <4583056e-bec6-f26a-5194-1add6f2b619f@kernel.dk>
Date:   Sun, 12 Jul 2020 10:30:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Two late fixes again, but they should make -rc5.

- Fix missing msg_name assignment in certain cases (Pavel)

- Correct a previous fix for full coverage (Pavel)

Please pull!


The following changes since commit 309fc03a3284af62eb6082fb60327045a1dabf57:

  io_uring: account user memory freed when exit has been queued (2020-07-10 09:18:35 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.8-2020-07-12

for you to fetch changes up to 16d598030a37853a7a6b4384cad19c9c0af2f021:

  io_uring: fix not initialised work->flags (2020-07-12 09:40:50 -0600)

----------------------------------------------------------------
io_uring-5.8-2020-07-12

----------------------------------------------------------------
Pavel Begunkov (2):
      io_uring: fix missing msg_name assignment
      io_uring: fix not initialised work->flags

 fs/io_uring.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

-- 
Jens Axboe


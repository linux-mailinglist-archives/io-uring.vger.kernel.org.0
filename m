Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A973722CB6D
	for <lists+io-uring@lfdr.de>; Fri, 24 Jul 2020 18:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgGXQtR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jul 2020 12:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgGXQtQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jul 2020 12:49:16 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99ABEC0619D3
        for <io-uring@vger.kernel.org>; Fri, 24 Jul 2020 09:49:16 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gc15so6088880pjb.0
        for <io-uring@vger.kernel.org>; Fri, 24 Jul 2020 09:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=GQt2Z1ws/WfONIjOWp9AeuItjf9hMkR3TALYfXb7u3I=;
        b=O106MpoVjd9OAiNYoACBwGCFb/AqfJ74hf/aLS68KdQRU8QBBf2kXmGt3dlG8EFmZl
         tldbLqhbWpOl5KlqmMM//KMcNHYUTrcc01KlUPSOrLtlgwPNG05TXn93742HCOY38kio
         c5G8Lm966mtk3iXaGFW0iNPgW9UqpvUL8LzVRXJHMtgmWOsY89xgTvyZlqH+QKIUrxsw
         MzVBZ1JEu+zoV6bNeZvhRIMsUkyrmpFIK2T0ewM1hALHofP3gliEyj9cjmzS1wlFZfQS
         3ODloyX3PAhNaBgj/J0MNOFOEMvW6IaYZV7rfJltMYcZ9xxj7xvrIlKoUlr0HwdnWyR5
         lblg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=GQt2Z1ws/WfONIjOWp9AeuItjf9hMkR3TALYfXb7u3I=;
        b=dJp9WCxnj9eb7IBsMEOyI/1+XY2qB4O+ghE6KUSz6kq0PC2x85Y7r3Wa0oPhB4jsf3
         8PfFBqYRf1WOrjO0WoZH5UCqx8OHe7vQ+J3SaP05V9GP+mzvW167FC/ouBrNL7sO7/X9
         YjWRPRnW6jVyxoujHDUZKgsBUFcHOLbCOLEgXEuMO1NGTsehuqoQWxqZunyWVs3QJPKa
         X9lVTf0wGmNZQdCCvV7OdppiTinUZ1fiXc2pVigoBivzUMyoGKm4hls+rQRTYm7mTVcI
         IFxihQwuDMEYX1lLe80dsRLV4o2sXyPdtExXRTxRQHES1DBUE2cZv8N8BH5hpfofsSEc
         DbEA==
X-Gm-Message-State: AOAM532P0au9/UtGpd+1Aiesyq2HVcuEq/+ch3jbp0pc9hx6GW5Ine+3
        7BhHqknxUDxQNOJI10xD0vtk3A==
X-Google-Smtp-Source: ABdhPJyEn8R5pCXQtGwr5zjilHrF158dQmMATZYqIqSDms0Uoe+gVM8JOFPE2S1JajDB3gKMHMlgYQ==
X-Received: by 2002:a17:90a:ebc7:: with SMTP id cf7mr6279349pjb.207.1595609356077;
        Fri, 24 Jul 2020 09:49:16 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id w20sm6797797pfn.44.2020.07.24.09.49.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2020 09:49:15 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.8-rc7
Message-ID: <c07ebe12-2b16-3811-9abc-d3e8d99b54db@kernel.dk>
Date:   Fri, 24 Jul 2020 10:49:14 -0600
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

- Fix discrepancy in how sqe->flags are treated for a few requests, this
  makes it consistent (Daniele)

- Ensure that poll driven retry works double waitqueue poll users

- Fix a missing io_req_init_async() (Pavel)

Please pull!


The following changes since commit 681fda8d27a66f7e65ff7f2d200d7635e64a8d05:

  io_uring: fix recvmsg memory leak with buffer selection (2020-07-15 13:35:56 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.8-2020-07-24

for you to fetch changes up to 3e863ea3bb1a2203ae648eb272db0ce6a1a2072c:

  io_uring: missed req_init_async() for IOSQE_ASYNC (2020-07-23 11:20:55 -0600)

----------------------------------------------------------------
io_uring-5.8-2020-07-24

----------------------------------------------------------------
Daniele Albano (1):
      io_uring: always allow drain/link/hardlink/async sqe flags

Jens Axboe (1):
      io_uring: ensure double poll additions work with both request types

Pavel Begunkov (1):
      io_uring: missed req_init_async() for IOSQE_ASYNC

 fs/io_uring.c | 61 +++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 36 insertions(+), 25 deletions(-)

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D05052C759
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 01:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiERXM3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 19:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiERXMX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 19:12:23 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5334FE276B
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 16:11:49 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id r71so3508013pgr.0
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 16:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=Ui5TJP+UkyKc2uJ/+g4588aSW0ivTWVZkdqqBhvQMC0=;
        b=TvLzxnCTyB1NhugzhADUU4m5ig6LOqOqe5enbrf9ccI4KYuVu5KgkUUzprXgPvRyb0
         +9T9XBFsjJ72gKF5tzgLQ4i5Ku4EHa0Jqy9KMJFBQ2p9e/c982ZM6DyfEx9FBiQzN6zV
         H20G4pVmS/bO54OKDr6DKqZ7JWkObbD6jG2H+a0eXGu0T1oO7LrOCqTa7s/FCEFVQQ6h
         7vqdJfVPvPU2c+JhOX6J98fyESvJjG03gidjHz4RQXNB/rkeQRIGg0SOS27NQHafUzMn
         BbatDzysQECEGMp0zUq9c0H5UBRSJ0fd0lN9wsmRuEXRLkMHPkeEcQ5J1Qk4MtUl6LIX
         13ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:content-language:content-transfer-encoding;
        bh=Ui5TJP+UkyKc2uJ/+g4588aSW0ivTWVZkdqqBhvQMC0=;
        b=h9H900yZ9m6UAcKUdK5I7n726/N+Lt5tYN70saTAySlMimwqD0teZoro+SL5Lzpcsk
         CfTvboXbmlsFiaYkj5h6Fx4xcyuHyTWOWE9AxstBgkqhVdVhQH0zr5DK+4LTyOt9RPHi
         JojgMbV537jCOs+17D9zUCl3ne3v6pDhrUlICP6WVb9aL4oc8UVMh9bMXfbg9kawPRs+
         D8FMj0GoxG3RpA43IeRPUNAEYPYIE3DgUEvnLJvDewVRSSQIyTdb+EzGDofmTw6wnMPh
         9Qldh3EFOlht0D3ZMxBMmsmTHiRfYPbya205Vf7Fi2DM6EJz/TSmwTVmNMcqlRkG1OME
         xjYg==
X-Gm-Message-State: AOAM531NJs7qr7ty+qjChlB8WMeE4M4ZyNa9MbTzW8ZcnUvoYSc7xb53
        SC1r9OjPrE6Lli2xNkaE3kt3ZfBKkEY9KA==
X-Google-Smtp-Source: ABdhPJwh8bSp3QNw2Pti3kttBUraQmSHjz1P0X+TKB84Nl/3CHe0KL1DCYIOxcBneeAFmenzfVv0dA==
X-Received: by 2002:a05:6a00:1a86:b0:50f:f4fd:c9a7 with SMTP id e6-20020a056a001a8600b0050ff4fdc9a7mr1679893pfv.46.1652915508762;
        Wed, 18 May 2022 16:11:48 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id r12-20020a170903020c00b0015e8d4eb2d2sm2230750plh.284.2022.05.18.16.11.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 16:11:48 -0700 (PDT)
Message-ID: <4db3b8db-7fea-f366-0c55-a5a68c6cc0ec@kernel.dk>
Date:   Wed, 18 May 2022 17:11:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.18-final
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Two small changes fixing issues from the 5.18 merge window:

- Fix wrong ordering of a tracepoint (Dylan)
- Fix MSG_RING on IOPOLL rings (me)

Please pull!


The following changes since commit a196c78b5443fc61af2c0490213b9d125482cbd1:

  io_uring: assign non-fixed early for async work (2022-05-02 08:09:39 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.18-2022-05-18

for you to fetch changes up to aa184e8671f0f911fc2fb3f68cd506e4d7838faa:

  io_uring: don't attempt to IOPOLL for MSG_RING requests (2022-05-17 12:46:04 -0600)

----------------------------------------------------------------
io_uring-5.18-2022-05-18

----------------------------------------------------------------
Dylan Yudaken (1):
      io_uring: fix ordering of args in io_uring_queue_async_work

Jens Axboe (1):
      io_uring: don't attempt to IOPOLL for MSG_RING requests

 fs/io_uring.c                   | 3 +++
 include/trace/events/io_uring.h | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

-- 
Jens Axboe


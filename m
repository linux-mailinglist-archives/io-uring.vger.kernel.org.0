Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0867F675E80
	for <lists+io-uring@lfdr.de>; Fri, 20 Jan 2023 21:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjATUCI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Jan 2023 15:02:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjATUCH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Jan 2023 15:02:07 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDE515CB2
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 12:02:06 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id f3so4969087pgc.2
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 12:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eatz6QpA8+HMqi2Y6hJrQTSjs1H1Xjf9wO/dcEandlE=;
        b=ghhPxXexOlmsbaGphniLpQP5g9bBkRECGO5dJbgu0SQLB4ru4dWqmbVCQ9exWR0RPd
         ATfibSuOC8FNHYY8h9aVEjPZMN2teDA88+0OB/55fJOjLBZAClhiwpujkoRd5r4QDmTj
         tEqo60EVSVEwZQtjf2Am61X/CUfxILPemC5PeIhvBoMdWMq9mOfBFeejMyzT3ZycYEbD
         J1+jkhn/EEXoTrqA7W5YYxOq1R1mh0r9ChethcH3uFc4D6JxX5JIeLX7l7a95V1bK1LL
         jRLGvSg1CC3yQbfM6jQR6IZjII7bqPCgEY+mPGJtywLxx9u1ekFcL1vwuXTGqmjlwM0B
         yMiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Eatz6QpA8+HMqi2Y6hJrQTSjs1H1Xjf9wO/dcEandlE=;
        b=tg6rYC2QtfuwXwZYvGL0V+7f/ZV3jzUQHvmzIqNI1n+bbxfTThBxdxPts+hYvmfGvZ
         r4OCPs+NLzFZdBIaXBXigfTd7sp8X91mNldPAiB+4ysjzvvLJcISs8JEBD9dQX49JX7Q
         OS8pSgOUBUs6WxcW9YDKJnb+I/xH34BzWpgysiAhbsZVwt5IyZgn1fFqvTM+R41xji7g
         a2kiW4ePmrXodaSaTO/T9jTyLzV6CG0yCG5+ndrG/uIknWtxk/Yue5Fi960ZQuEviLEK
         bQT/sHaXXGm1ogeW1aK6k5IAXF66ekFL57MD1NWyjZukTxVRsi3LABSTRgnP9BAxB+gM
         aDWQ==
X-Gm-Message-State: AFqh2kpd5IPIqKdVuqIPc2FzlqFrUXfNDN0A/pAUXvyPNHB59YkPb0nU
        mDJwXyKKTA5toXb7stL7X9k+fOCzbWJKRg1J
X-Google-Smtp-Source: AMrXdXuoLHcoUSd1Sd+QhBetydzCsFsmB+T3l3aTDWe1iFSchXdqMq4DonrkEYhnPW1kJPyAaB7y/A==
X-Received: by 2002:a62:e919:0:b0:58d:be61:7d9e with SMTP id j25-20020a62e919000000b0058dbe617d9emr3784413pfh.0.1674244925950;
        Fri, 20 Jan 2023 12:02:05 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u197-20020a6279ce000000b005855d204fd8sm26495326pfc.93.2023.01.20.12.02.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 12:02:05 -0800 (PST)
Message-ID: <0fc64186-588b-76b8-0683-b03df9be9ee5@kernel.dk>
Date:   Fri, 20 Jan 2023 13:02:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.2-rc5
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Just fixes for the MSG_RING opcode. Nothing really major:

- Fix an overflow missing serialization around posting CQEs to the
  target ring (me)

- Disable MSG_RING on a ring that isn't enabled yet. There's nothing
  really wrong with allowing it, but 1) it's somewhat odd as nobody can
  receive them yet, and 2) it means that using the right delivery
  mechanism might change. As nobody should be sending CQEs to a ring
  that isn't enabled yet, let's just disable it (Pavel)

- Tweak to when we decide to post remotely or not for MSG_RING (Pavel)

Please pull!


The following changes since commit 544d163d659d45a206d8929370d5a2984e546cb7:

  io_uring: lock overflowing for IOPOLL (2023-01-13 07:32:46 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.2-2023-01-20

for you to fetch changes up to 8579538c89e33ce78be2feb41e07489c8cbf8f31:

  io_uring/msg_ring: fix remote queue to disabled ring (2023-01-20 09:49:34 -0700)

----------------------------------------------------------------
io_uring-6.2-2023-01-20

----------------------------------------------------------------
Jens Axboe (2):
      io_uring/msg_ring: move double lock/unlock helpers higher up
      io_uring/msg_ring: fix missing lock on overflow for IOPOLL

Pavel Begunkov (2):
      io_uring/msg_ring: fix flagging remote execution
      io_uring/msg_ring: fix remote queue to disabled ring

 io_uring/io_uring.c |   4 +-
 io_uring/msg_ring.c | 130 +++++++++++++++++++++++++++++++++-------------------
 2 files changed, 84 insertions(+), 50 deletions(-)

-- 
Jens Axboe


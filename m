Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822CA4A0343
	for <lists+io-uring@lfdr.de>; Fri, 28 Jan 2022 23:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242174AbiA1WDu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Jan 2022 17:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiA1WDu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Jan 2022 17:03:50 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F58C061714
        for <io-uring@vger.kernel.org>; Fri, 28 Jan 2022 14:03:50 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id q63so7739751pja.1
        for <io-uring@vger.kernel.org>; Fri, 28 Jan 2022 14:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=nA03+1lp3EH1KU4vRbyXbF/ubGJQZpEGNE+JWPfHJRw=;
        b=vI5OS8p7j6gXT36N44cmdpREOguPRpF7UhzbK6Q7BxejpHX7mwmX2cWvIUfIle7s7K
         FHjqUz7lTFcPPYHRFZKUHJCiXSw3yoKaH+cxACzM47cvaokAku19a2D+QPxNnHZL7glw
         mslOwY+Oow0fBfI5IcrUzNj5svlnp5ZkR4FnwkGXfAj2dyzHrm7dEO/u/pEXC1R2hRJV
         /O6c8Ku9c1eMIyvdIK2Vamr4F2t0cH14ZG3DA12AXOiluItqRmaTswsxzplj8i4+gwKr
         eg0lllqhoQiVZntFchMQxW1b8FoffqdTpOdeCifJbD7UJ6iOT1hJJy20YyVRs6/ehXfw
         5owQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=nA03+1lp3EH1KU4vRbyXbF/ubGJQZpEGNE+JWPfHJRw=;
        b=DuThVtVSgLWq02DP2LTHR9FQVzj1dPgcra0eCrZJatUh2QumYjypbsf/R+ZoQhtpt/
         sEtKk7skgPAp/QU87oQircO65K9UGKE4L+kloS4uSOoCX1SoX3Bjt5/QZVK/9YOfi1cm
         EE4l4KZjK64VyT59d0W92CGTaWk0aQUSxfkyz8GI7bKDdRCa3w7y76FLKtz86tCFa0Vm
         do9oB390U3CisWjoBLabvmWHUI8rhEh15wcdlct1gzdYd+rtIL286iSpYGKGJZAxv2tF
         boI86C0I7lU/982jEqOefB8HYZa5GOLlPrUht6qw+E2Ba7ek5/qnAXFgUgUCaIQcIgKK
         eLzw==
X-Gm-Message-State: AOAM530Y+L6G8XuZldFxfGBzuULu4w2uxWIHseYYkQbnMF4WL/zafCtO
        dW0RTikM2lRX5kjSSyORZpFdGeNoANCXwQ==
X-Google-Smtp-Source: ABdhPJycZzjJhex711BSa8PPYtyeWMZxwjsyvD4anNkyZkRXHXONFjmZL/rlmfK0QEwetYSeEI5vbQ==
X-Received: by 2002:a17:90a:f485:: with SMTP id bx5mr21914414pjb.46.1643407429296;
        Fri, 28 Jan 2022 14:03:49 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id y18sm11707768pgh.67.2022.01.28.14.03.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jan 2022 14:03:48 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.17-rc2
Message-ID: <86d85ee1-3fea-bb62-b1b2-f0459f3d2371@kernel.dk>
Date:   Fri, 28 Jan 2022 15:03:48 -0700
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

Just two small fixes this time:

- Fix a bug that can lead to node registration taking 1 second, when it
  should finish much quicker (Dylan)

- Remove an unused argument from a function (Usama)

Please pull!


The following changes since commit dd81e1c7d5fb126e5fbc5c9e334d7b3ec29a16a0:

  Merge tag 'powerpc-5.17-2' of git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux (2022-01-23 17:52:42 +0200)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.17-2022-01-28

for you to fetch changes up to f6133fbd373811066c8441737e65f384c8f31974:

  io_uring: remove unused argument from io_rsrc_node_alloc (2022-01-27 10:18:53 -0700)

----------------------------------------------------------------
io_uring-5.17-2022-01-28

----------------------------------------------------------------
Dylan Yudaken (1):
      io_uring: fix bug in slow unregistering of nodes

Usama Arif (1):
      io_uring: remove unused argument from io_rsrc_node_alloc

 fs/io_uring.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

-- 
Jens Axboe


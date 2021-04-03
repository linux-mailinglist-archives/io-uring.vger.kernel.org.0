Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202DC35357C
	for <lists+io-uring@lfdr.de>; Sat,  3 Apr 2021 22:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236684AbhDCUDm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 3 Apr 2021 16:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbhDCUDm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 3 Apr 2021 16:03:42 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B11C0613E6
        for <io-uring@vger.kernel.org>; Sat,  3 Apr 2021 13:03:39 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id a12so5684984pfc.7
        for <io-uring@vger.kernel.org>; Sat, 03 Apr 2021 13:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=NYJjEHhWTk8HEKDfMYoYU+aes+7Tqv1HAAWPkt79HII=;
        b=RDNv3un1du3bBbhh+FXdr/toVtFvt6e+fC2o5bm7c7WbD0VdN8WU3z768Lvl/iJLlP
         pMU200jYfyjqlRGaJBQfjHa/PLXWBqN60n7am8P2al0iY7Nbp2PaZvxI6b2XyJvLg1hV
         OG/0nsmQeAwBY1MMFHv0cCEWOInRcqbRkvE/VQ3iIVMwP42fVyWobsDaYxcQZOjcHStF
         axlpISWHJ/tHfk1UMy15Egn0Cx/1FUQQ92a/ArokNxVY2b+xjHLwgA5h60vdzmqSB1Xz
         2mHovN4WokfjGbI4Blx4OTMbBN/4C6MoCqcdR6EvOahzOJe9JeMrwqGpwkcVHoGtak7Q
         zP1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=NYJjEHhWTk8HEKDfMYoYU+aes+7Tqv1HAAWPkt79HII=;
        b=fvpzAj+YYcTkuj5vzeQblU4UiL/bQhXDZ+mE+563dXMVbjLTLEIATdH6Tgd6RQMvk/
         hXvT6AYV/AUnz1qzIdRE+p3VjPQqhAqgkeBJsbDnlpd+JKdRmfiLVVIjOe2lG5FBNN4E
         dw9zUHF5+ayokHkba0grC4blVkpRCPy5t35MLZ+YViBfc8Gw938xekzd68nYTK4tpJHm
         TP3c3P32VAA6mJEi2W7VyZBQoUS/hHGJupXfHDCVyRPTevAiuWpgpzEJoIY/KnvIrOXJ
         FGXDtKL3NX3N92No4g/Q2jL5nb9FSK6C35NBrStyJma7t60jnoAUOeXM6j3Ex2bJPhgS
         H4Eg==
X-Gm-Message-State: AOAM530XyLUa4l20bBq5KMjRlOwUpMYckQJ/TZtdXXdMnG1m69gNks8k
        IerdBb7FUvz3rVXTpt4BG8Ll+KaSiXXlAg==
X-Google-Smtp-Source: ABdhPJyAB9Xkbvk5scEGm8LkJ6IMJulCbygWBH5aRn4BRp0c/SVCn7T3NvJG9Rkt6XXvs6fGHYcY2w==
X-Received: by 2002:a63:d009:: with SMTP id z9mr10617046pgf.16.1617480218202;
        Sat, 03 Apr 2021 13:03:38 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q15sm12904373pje.28.2021.04.03.13.03.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Apr 2021 13:03:37 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] Single io_uring fix
Message-ID: <54a39886-5560-66fb-e6bc-d049010fe3dc@kernel.dk>
Date:   Sat, 3 Apr 2021 14:03:36 -0600
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

Just fixing a silly braino in a previous patch, where we'd end up
failing to compile if CONFIG_BLOCK isn't enabled. Not that a lot of
people do that, but kernel bot spotted it and it's probably prudent to
just flush this out now before -rc6.

Sorry about that, none of my test compile configs have !CONFIG_BLOCK.

Please pull!


The following changes since commit 230d50d448acb6639991440913299e50cacf1daf:

  io_uring: move reissue into regular IO path (2021-04-02 09:24:20 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.12-2021-04-03

for you to fetch changes up to e82ad4853948382d37ac512b27a3e70b6f01c103:

  io_uring: fix !CONFIG_BLOCK compilation failure (2021-04-02 19:45:34 -0600)

----------------------------------------------------------------
io_uring-5.12-2021-04-03

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: fix !CONFIG_BLOCK compilation failure

 fs/io_uring.c | 5 +++++
 1 file changed, 5 insertions(+)

-- 
Jens Axboe


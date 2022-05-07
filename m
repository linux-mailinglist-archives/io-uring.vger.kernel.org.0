Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0801351E37A
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 04:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392516AbiEGCOo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 22:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348537AbiEGCOk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 22:14:40 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0565D5E5
        for <io-uring@vger.kernel.org>; Fri,  6 May 2022 19:10:55 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id i1so9052794plg.7
        for <io-uring@vger.kernel.org>; Fri, 06 May 2022 19:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=pRfbXIpmjam33AzOXOGFwUnUp1P3ZX/ow2iGzI0Hl6o=;
        b=XDw53i6Mkt/0bvIRm5783T4nrOTgLpd/tMPVsfEy/DFcTcBrqxseYKR2mc6oPJr1e3
         OM4o5rj5ndGZoz5SV4ECUV12N0DVy55VMtnYSOqyFGQBa6K8lTc8M3i52oz78802HwyS
         n2csVYrh++V52ISOgpVnqTT8lXFY+4iHe1TBcDYD+Hg8zMQnLH0/Gjglvti3d3St0w3G
         HArEe7/qIVUulEbzUVqum5UlNQZglEMA7PW0ZWF8Ex5OpBSMfvkOoHkgd2v1f10lPEU5
         cS+X/pF4/0VSCXt+/33uk+4/fa9nA/QBXHgNOk/tOPq2+QYBLFpC8GQP4ot3Q02vfXbf
         MU0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=pRfbXIpmjam33AzOXOGFwUnUp1P3ZX/ow2iGzI0Hl6o=;
        b=HLXEXX77rCvZ/KXP80ldUeDbY2MTuidspKwJIA3wqnon6WQvcn48v0/pFg2+gH8Hsk
         bsWOGMCQ5zecZMT6jLnSoSiDqVeQnbI+ts61oyYYWdDJ+IqASpO2R5BWgQ9SB6P7andD
         erOWim0aPuJpuWEaq2NFf9OO7Q/ItZXpWLtCe7RaYOcUWlJJegmuQpMDgmd7N4EqJpWZ
         1uF5X5b0eAxp0ZgY0JqbVXAeccHp2oTAaN21qiLR2yOHNF/IL8kw83J/3E/oi62J+vxx
         lcnVcI2B1Gtdxva6qpAHf1cizOKAbb/elzWm97aPpeXivZgywshE9j1cv5PSCib/3gGa
         0vOQ==
X-Gm-Message-State: AOAM531ci5bMhzleUZCyHHyybqfbsOLkKQ97sRwwaFA9bN3urJZoL+GZ
        XOLi6LrTzKcT/iyJoRzTOOZZTIwnGv4FiQ==
X-Google-Smtp-Source: ABdhPJyKX8bctlw4JIzlXy2zz40K3CPlvVR4qcNlRZi55/xdab5lTbU+LIJ38RNYRUK5+ev1gJhK/A==
X-Received: by 2002:a17:902:dac1:b0:15e:9faa:e926 with SMTP id q1-20020a170902dac100b0015e9faae926mr6597032plx.61.1651889454513;
        Fri, 06 May 2022 19:10:54 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id bi8-20020a170902bf0800b0015eafc485c8sm2426297plb.289.2022.05.06.19.10.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 19:10:53 -0700 (PDT)
Message-ID: <f492cd49-43e6-b66d-d7bb-958eb717e569@kernel.dk>
Date:   Fri, 6 May 2022 20:10:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 5.18-rc6
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

Just a single file assignment fix this week. Please pull!


The following changes since commit 303cc749c8659d5f1ccf97973591313ec0bdacd3:

  io_uring: check that data field is 0 in ringfd unregister (2022-04-29 08:39:43 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.18-2022-05-06

for you to fetch changes up to a196c78b5443fc61af2c0490213b9d125482cbd1:

  io_uring: assign non-fixed early for async work (2022-05-02 08:09:39 -0600)

----------------------------------------------------------------
io_uring-5.18-2022-05-06

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: assign non-fixed early for async work

 fs/io_uring.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B3056CF2D
	for <lists+io-uring@lfdr.de>; Sun, 10 Jul 2022 14:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiGJMiG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Jul 2022 08:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGJMiF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Jul 2022 08:38:05 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B5911149
        for <io-uring@vger.kernel.org>; Sun, 10 Jul 2022 05:38:04 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id x184so2733352pfx.2
        for <io-uring@vger.kernel.org>; Sun, 10 Jul 2022 05:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=lJQaXu88xTKAnojVexYE+gE99onAq9BeD7mFyKMQJQc=;
        b=biIcBsftsWvBlN2tOGiL/SgA3CwkrCbUY9MYmpNkLx2BfLQUrTYoJpecq6N0w9yWXo
         NxykTnU/cQMoYE4mbsDiN5wIgdjtKzx8ekmob7FQbF82Ia0mdye+qOrwk9ixPndmP6Rj
         BX5a4ibeVVKsCFMaJVynbvkhgDKgtuRqsBbu2m89Q3Tkd8Yp1ZKaebqB1502LSuyAhm6
         V9dh1FylMVIKFLTxkeZ8v9KakEjk58jhlhuQSS4KwiC86i/9VIt8DrZknGwxLuWK331s
         6tkMYq/LNEqOuq7LZVEsFLHxLX1mJ25J1iM9KAyV8v9SmdHE2l65oP2r0zr9qshGjRJM
         Nlhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=lJQaXu88xTKAnojVexYE+gE99onAq9BeD7mFyKMQJQc=;
        b=IhOxv18Nz51pgx6lCkeydTLd6Xppw4Vx6YgE15W2HV+GEr6ip2rHVWDnBeW9t/QBTV
         hPXtqELJsJAqM5PIxB911RPctPP2umDqFLWAZsSbZcPBfh6OCe+CMiEUpv1q8CRMGdhS
         tTXKjPoqeqT2tqRb4tK+DLNmSrjJzc56kSWBqdwEGX/+cwLbau/6HDkuw6a5l+wjNksR
         dhpLh+Ba4Qd3JpT2vINqFqrH67sJUAPv1+3P9roLqAiVynT6IVQLmZSEeW8fjVkSBe7a
         IlsPhu6HdAn/M7pzHkeyYJis8WGXIMxPmIIbXd9IJbbHahkFt34I070MMsC7nMdpeHDv
         AsDg==
X-Gm-Message-State: AJIora+DYb4qsI1LDnAh2xA+7wuiuVte05AKGF2N5CVKAmskC9zfWi+s
        53/cbIwb/4Xr/e6gkd/oB1Hg2yB5MSW8HQ==
X-Google-Smtp-Source: AGRyM1v1aS8vh5LzGvaQOHbnzBmTRSizDNeWVNyCGzfbKBEkpSiW2XOAza5IDyLdpZCKF1SkABVg3g==
X-Received: by 2002:a63:eb0c:0:b0:415:c521:4bf with SMTP id t12-20020a63eb0c000000b00415c52104bfmr8269330pgh.25.1657456683818;
        Sun, 10 Jul 2022 05:38:03 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l11-20020a170902f68b00b0016372486febsm2632590plg.297.2022.07.10.05.38.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jul 2022 05:38:03 -0700 (PDT)
Message-ID: <ee0e6d42-3726-22c0-bfc9-7e7384f5e4ff@kernel.dk>
Date:   Sun, 10 Jul 2022 06:38:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] Follow up pull for 5.19-rc6 io_uring
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

Followup pull request for 5.19-rc6, with a single fix for an issue that
came up yesterday that we should plug for -rc6. This is a regression
introduced in this cycle.

Please pull!


The following changes since commit bdb2c48e4b38e6dbe82533b437468999ba3ae498:

  io_uring: explicit sqe padding for ioctl commands (2022-07-07 17:33:01 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.19-2022-07-09

for you to fetch changes up to d785a773bed966a75ca1f11d108ae1897189975b:

  io_uring: check that we have a file table when allocating update slots (2022-07-09 07:02:10 -0600)

----------------------------------------------------------------
o_uring-5.19-2022-07-09

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: check that we have a file table when allocating update slots

 fs/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 293245ECBB1
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 19:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiI0RyT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Sep 2022 13:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232435AbiI0RyS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Sep 2022 13:54:18 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454996B8EC
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 10:54:17 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id b23so10330168pfp.9
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 10:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date;
        bh=RESMSLHojzH95y+phw86H5QYpVU422VHLJS5NcPvz6A=;
        b=0J8uypRsbNpKUcgRp9UWyZSFObpkWf8fOblXrP3BVL4fWIgwk3pO09PHV/BvEsbdck
         hnCZjP7pLaIN/mxc/xO3FzUdkauFGGT+cYIIElRKinNrhSya/vejWBy0yyaCJCbwVnM8
         YnKb7NOtn6PEZ5jgc5R33RNUY0YEQ+rnpKyUczucyAWeHoXW1cuxWFvLnQ+q+opjZyR1
         x+o998G9pQj73h9aKbdugsQycAGHoXEeAMAtL4B8Nf3L7b2Pev3R+XBrCXyf0ffhuXPx
         Src43BxCaDMJXDXQPMysepKc+hOeJEa+ZwLjfC+OawdIWY/ndIAio8244bYDJkQBjAZA
         OSbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=RESMSLHojzH95y+phw86H5QYpVU422VHLJS5NcPvz6A=;
        b=6O+zg94w+/tZQzt1kKHxsm3GJrS27QjDVQI+aonupwe7AFwh5IvmN+jNp29r/6Lxgm
         q75i2TZcSBHH2dU7y8jwTps3ACTdYucwvRVm/0hkAGs/LrOV/3wCLpjWiyz+UlkJGolr
         wXbldXmGzZEWeaSjzqlNPro6+B8BcOQTkLpvU3qxN+z4mvfL2gWHNzuPeOt6S88r43/M
         dEheWILwa7XRItbn88lkJVeuojL8fogPM+87yHJ3e2fgGGHFVOYaJshoz/hxjyP2CLdx
         byHAGffCALeEoU2NshD1ror9pXdNQGN+BbCTIFIZNmIzypYmoJ4ziLJzFfORhASYOT5V
         tRAg==
X-Gm-Message-State: ACrzQf3BLFTQx4csuMLnOQvaKWPp/kmaHRBPy6q66h7pxKssTv5vn9sy
        1sYk1Ftj8f8mhQ0kSGvGNqlDs5WxwcGBZA==
X-Google-Smtp-Source: AMsMyM4d9QB+Dg7BtlEq1L50BWXufyzEq6HWClgSUxl2bDvR20rzFdw+FkT/35aJ9HtVp+12aEwe3g==
X-Received: by 2002:a63:77c4:0:b0:435:4224:98b6 with SMTP id s187-20020a6377c4000000b00435422498b6mr26029175pgc.94.1664301256491;
        Tue, 27 Sep 2022 10:54:16 -0700 (PDT)
Received: from [127.0.0.1] ([2620:10d:c090:400::5:de02])
        by smtp.gmail.com with ESMTPSA id z12-20020a170902cccc00b00174f7d10a03sm1851042ple.86.2022.09.27.10.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 10:54:15 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4794c23f60a3a0f4c5f6e83af4598eca47dda68a.1664292508.git.asml.silence@gmail.com>
References: <4794c23f60a3a0f4c5f6e83af4598eca47dda68a.1664292508.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] tests: a small fix for zc tests
Message-Id: <166430125543.155979.1140079173404994058.b4-ty@kernel.dk>
Date:   Tue, 27 Sep 2022 11:54:15 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 27 Sep 2022 16:28:59 +0100, Pavel Begunkov wrote:
> 


Applied, thanks!

[1/1] tests: a small fix for zc tests
      (no commit info)

Best regards,
-- 
Jens Axboe



Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574CB536A20
	for <lists+io-uring@lfdr.de>; Sat, 28 May 2022 04:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351982AbiE1COW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 May 2022 22:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiE1COV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 May 2022 22:14:21 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31BA35FF3E
        for <io-uring@vger.kernel.org>; Fri, 27 May 2022 19:14:20 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id x12so5361300pgj.7
        for <io-uring@vger.kernel.org>; Fri, 27 May 2022 19:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=ZT+WoV+uB7k9vADqq0AldkNF/2qFfZlzXS9NX44RLa0=;
        b=dAKWXAG56OFa5SBzzTBDff6cGU268HfEhNLzFtaU/WfgwgLtc9oMFTfP+ViDGWBR3I
         1cBhY/ztS0CJkgVNH0Cr0ev0AFrXEU05+zBAr1iDHIpzARSP97j7Fsf0olf7U6OHHk9S
         HtPuC2XSwzbRzWu9rft6GGyfxVV45l6Y4RIyFCGJSkPZx1a/A8p639wu5m8sZhFBMdPi
         uxn4aH3RPOt7Sx8I4oZ/3LmntfWyiwGDx/Zj3aeOUIAL+F3AZwkGs2hVuuKQ/zBwKQdT
         4YU7i8InUcLxywyigQCJgUTg5MjnQ/r9BP8YgXWzx7R9MEkQCBWOqTOm2lYoG+E5MDg4
         qkKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=ZT+WoV+uB7k9vADqq0AldkNF/2qFfZlzXS9NX44RLa0=;
        b=P8qsqqXQJ3hkTgFspCIKF4i5wnd9Klm9clRCBdTZwnlZUPHPRxUHz97PuMvidL+C00
         CBuqa4HVPgYzdZ3RfI2LDOOw2m2sgJe/4fndONgNvFVA9EiQDArnKenHT8x8q7DeFJg/
         hBO8e/IiNJ9PnUTbvVY0yoBYdxkezn5YL57nKpc0mQ9whwJYV5jRyggMHpFRdJ5uaR7M
         iyXXX6pvCRv7Gke0hnQHA980dSp9iVfnSX4OU0VQmvPampwUUHYLL0AgWchusSdDNPNh
         OYlH3yQt5reQxl3+H+uPLXDGuauGLfWQucICuuf29ZI3GsfUTV1asao59TUnElEkvVtQ
         RxTA==
X-Gm-Message-State: AOAM532QyCaGnhLDYi5NeacvHGbABvIlV0kkBGM9TIkdeTKxFcKaA0HW
        R28QDn6LUaDh6nJR8K4ODdgszc0BazdL6w==
X-Google-Smtp-Source: ABdhPJzJpKho3dudDExNFPnwvrENFGncGDgtGatOdaiksACKfhv0GkxAomjmcffmD4K9ZRNUsXTCRQ==
X-Received: by 2002:a05:6a02:11a:b0:3fb:d90c:b3f8 with SMTP id bg26-20020a056a02011a00b003fbd90cb3f8mr657379pgb.192.1653704059496;
        Fri, 27 May 2022 19:14:19 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h24-20020aa796d8000000b0050df474e4d2sm4137599pfq.218.2022.05.27.19.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 19:14:18 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, xiaoguang.wang@linux.alibaba.com
Cc:     asml.silence@gmail.com
In-Reply-To: <20220527025400.51048-1-xiaoguang.wang@linux.alibaba.com>
References: <20220527025400.51048-1-xiaoguang.wang@linux.alibaba.com>
Subject: Re: [PATCH] io_uring: ensure fput() called correspondingly when direct install fails
Message-Id: <165370405851.572238.16555901056195715889.b4-ty@kernel.dk>
Date:   Fri, 27 May 2022 20:14:18 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 27 May 2022 10:54:00 +0800, Xiaoguang Wang wrote:
> io_fixed_fd_install() may fail for short of free fixed file bitmap,
> in this case, need to call fput() correspondingly.
> 
> 

Applied, thanks!

[1/1] io_uring: ensure fput() called correspondingly when direct install fails
      commit: 1c145c7f3616ec48725edeac8edf26ee6ed4b661

Best regards,
-- 
Jens Axboe



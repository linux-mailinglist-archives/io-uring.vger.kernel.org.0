Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 997AA5F0186
	for <lists+io-uring@lfdr.de>; Fri, 30 Sep 2022 01:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiI2XrY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 19:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiI2XrX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 19:47:23 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5E91F34A1
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 16:47:21 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id z3so1601945plb.10
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 16:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date;
        bh=t35BZcZkzyh/GRIN+tvZc+wR6c+kizCSpDQzVcJ4wpY=;
        b=VNFNmWXXLHKcqNGUCAQRCK2AXnmcOfOgsHACPcI8SlQZ4MdI/Hz+XIbm+YLk0FFk5J
         qpCvpBMfXXKjk9VQE95o5e0/s+GFpBxLToesHGcXbuHLASuNCDueAWEgFsGtfuchQzdn
         5Dw0P4/0Ith0DQfgC27YHwPr1+lenSPVK/3vnKzV1y98gtqq/pMbuAj2KQJao5yLd9tY
         mIakx4rRK41H7pQEpbUA49aIgDsElgqkm8sQPe5d2U8PwfkMtyNOsWmdpcaSh3WMMMVc
         2FCgfDSy4erbtpeXcWQRuG3RLi5ZoO865/0hBgbdqPEnqZFaFrSzlfQ/QZ+7nP4DFBW8
         b+Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=t35BZcZkzyh/GRIN+tvZc+wR6c+kizCSpDQzVcJ4wpY=;
        b=uh4Qu5pIAxz6JFeD0GiptjngMqCWP6q+Op30Kk31JCCce+ctaSITvs+DLkLlca8Rx1
         +sFzILOr7e1oyNQV+3rP/HFgPkpqPPQRQt1mHd1DzhFkvyQ3uH01kDjabWzlNQ/6K0hp
         aKAnGSapWiRfvi51u9Ti0xQKNWcrlUvuVt1FuTDxorIjVONaS8NOS5oz+iTIsWaNjB3k
         Q6+ToZfy9i9RWnvY0i7pvUgCNtTOlJkMVWtZXSVUvshA6dzDm9G1vM5ffe4jgH2XVUaJ
         uNQAm2129AIQQww1grsfHjYhj9Upv8O2CttbiIhDHU44rCAXUCKdeP/iN8Q/Z9MNqkvC
         V0kw==
X-Gm-Message-State: ACrzQf0ok6Wie/cvzjp28tILFfqpU7CLbqKyiQ+oDTbWWAcTtRCpa8nz
        0GcZwu36qDgrE9vfZTkaFEabr06BV7ZTdw==
X-Google-Smtp-Source: AMsMyM6TSvP9ApECUq9QA/kHpoq3vbwF2OVrH5S4ozBnyocy7KP9WWnC9rpriiPux899NQz9524seg==
X-Received: by 2002:a17:90b:388d:b0:202:be54:1691 with SMTP id mu13-20020a17090b388d00b00202be541691mr6513368pjb.31.1664495240772;
        Thu, 29 Sep 2022 16:47:20 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id w18-20020a170902e89200b00176b63535ccsm440370plg.193.2022.09.29.16.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 16:47:20 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1664486545.git.asml.silence@gmail.com>
References: <cover.1664486545.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/2] net fixes
Message-Id: <166449523995.2986.3987117149082797841.b4-ty@kernel.dk>
Date:   Thu, 29 Sep 2022 17:47:19 -0600
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

On Thu, 29 Sep 2022 22:23:17 +0100, Pavel Begunkov wrote:
> two extra io_uring/net fixes
> 
> Pavel Begunkov (2):
>   io_uring/net: don't update msg_name if not provided
>   io_uring/net: fix notif cqe reordering
> 
> io_uring/net.c | 27 +++++++++++++++++++++------
>  1 file changed, 21 insertions(+), 6 deletions(-)
> 
> [...]

Applied, thanks!

[1/2] io_uring/net: don't update msg_name if not provided
      commit: 6f10ae8a155446248055c7ddd480ef40139af788
[2/2] io_uring/net: fix notif cqe reordering
      commit: 108893ddcc4d3aa0a4a02aeb02d478e997001227

Best regards,
-- 
Jens Axboe



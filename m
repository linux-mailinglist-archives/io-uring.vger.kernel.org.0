Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E48562426
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 22:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236652AbiF3UdA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 16:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236559AbiF3Uc7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 16:32:59 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E56A377D4
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 13:32:58 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 128so470604pfv.12
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 13:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=LulNcga0J/kwd5A4TwuWcomyjOM1kf/vizR4Sa7IHTc=;
        b=YBTWEboonx2M1rFjKnka+q8N9w6L0MWqjV95Pvoged1enHQtm962yL3TC2lQ6eWxsy
         LMP00EmKfkaHlD1R8Xz3vnch39AgjV3XZPIdQJcq+Z0badbIqSZCMs2obZGX+Cgu/G9y
         X+GeUYlMegBBDAdket3yhvZbh0dI1dem9joSMWslPXK9maGpWP5ZszKXhdNSmXdG1yt8
         g+niekEr4Lvqv++ZOoIiI0pGjOgdqDQNNjZPrdlp/TyxqZeEBpf7ZX7XRIXfWQF4I6RY
         62OqyEeiG0eU/0coUSEwcp5+iqLNEB3C2BR5dwfP8ANHSOSijb93GfBg/LRfgMoITbSc
         0cLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=LulNcga0J/kwd5A4TwuWcomyjOM1kf/vizR4Sa7IHTc=;
        b=aECvLlmSUPo0nSVa6YIDZ9zkV5OUjlzXLY9iMxuM9Qome4xKnzRkIsY5q/5/fnwm8o
         K8rm+FCio17uDR0jHzmBHB5nl0YdeKCyltqxZ7nYnQ8ukM+xVUKBL2aQBiO6cKBFJmlw
         BuW3bQ0sRLvzbNYWIlSnxcvpzTiY5EIeGf85BLB7+IGpZT+U0OweRnSJvL0SVwtrAE24
         dy8rsp8tT1jYKOEYw2ZFOyYzo+U79OBqQjDJS1n55G82Jsoz3HxKXc3X9AtEkNHnaY6U
         B6i+Wfu1rGqFvKQeniDDiQRIwVdLMzxhRuvbuNUY+nrUK02+FlV3Zs8UQjXQvTjiA3kg
         G6KA==
X-Gm-Message-State: AJIora/Vwub5K6ijZEiq0Yo34txuCsbuFdgSxCNkRXVcXY15KGOb+qj9
        e8pGag8gGhAZgz6hqGIABCui7g==
X-Google-Smtp-Source: AGRyM1tNCVFllq0X174CF3Xo4LSUS8NwEzFm38o5tucF0PhydAvUObGJI7+Li+sRxUv4hXu7cA6eYw==
X-Received: by 2002:a63:3fce:0:b0:40c:23a5:2827 with SMTP id m197-20020a633fce000000b0040c23a52827mr9255451pga.314.1656621178072;
        Thu, 30 Jun 2022 13:32:58 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a3-20020aa780c3000000b0050dc76281f8sm13979093pfn.210.2022.06.30.13.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 13:32:57 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     dylany@fb.com, io-uring@vger.kernel.org
Cc:     kernel-team@fb.com, asml.silence@gmail.com
In-Reply-To: <20220630164918.3958710-1-dylany@fb.com>
References: <20220630164918.3958710-1-dylany@fb.com>
Subject: Re: [PATCH v3 liburing 0/7] liburing: multishot receive
Message-Id: <165662117728.56263.14485865037387492984.b4-ty@kernel.dk>
Date:   Thu, 30 Jun 2022 14:32:57 -0600
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

On Thu, 30 Jun 2022 09:49:11 -0700, Dylan Yudaken wrote:
> This adds an API, tests and documentation for the multi shot receive functionality.
> 
> It also adds some testing for overflow paths in accept & poll which previously was
> not tested.
> 
> Patch 1 adds a helper t_create_socket_pair which provides two connected sockets
> without needing a hard coded port
> 
> [...]

Applied, thanks!

[1/7] add t_create_socket_pair
      commit: 9167905ca187064ba1d9ac4c8bb8484157bef86b
[2/7] add IORING_RECV_MULTISHOT to io_uring.h
      commit: 791fc0998b0bdb913f71320caf3128aae23d8f39
[3/7] add io_uring_prep_(recv|recvmsg)_multishot
      commit: 5279d6abefcdb3eedfbcae87559cfdda0ec6e94b
[4/7] add IORING_RECV_MULTISHOT docs
      commit: 8e182bbdff0f5d6e1640190f713ed11060470b5f
[5/7] add recv-multishot test
      commit: b367a5273328d05b8e118bdaf1e87c0c8d9f8606
[6/7] add poll overflow test
      commit: 4218ad94b03db5f9109f02db3ba45bebd55eb744
[7/7] add accept with overflow test
      commit: afc6be1619b4d9eeda5a432353fd7285a543640f

Best regards,
-- 
Jens Axboe



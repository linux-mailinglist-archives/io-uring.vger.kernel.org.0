Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9C66E238D
	for <lists+io-uring@lfdr.de>; Fri, 14 Apr 2023 14:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjDNMow (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Apr 2023 08:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbjDNMjn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Apr 2023 08:39:43 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D38B471
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 05:39:31 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-6324024411aso1082977b3a.1
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 05:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681475971; x=1684067971;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LOGYPXOvqYS9vKedkjy/9CW+33EyqssIfBuYPJDBaR4=;
        b=jvd22BLSTfelPVNaIO50s8TEZdDyCJI3Xl/qZRCdoPxgGFAtH7pSC2lN+RCNK26Lja
         BT88HomzIeo48ao+FxjuBmgBRvbhBfvbDsQC6hYKIqi2ZzkWd9SN3g8ALYIabBI0nUJZ
         ByyhPiqANMoHsu3t38HnRxiw3QMxE9PlMZgX8doq1ldpjM5K3bvkkZgw65gXrjjO43aK
         yY74trnGW8f1EEQsOQmCQPssG4hEQsdQaWP4a2xoqedfUEw1+6Y9bzTiPwaQbDQBb8BW
         1GYQjNIPVizETXNriEMGmPlwk+jjQShe3KAZbdwceB/xTBMMsSk+7L2bTuxz4KErTCof
         rqpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681475971; x=1684067971;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LOGYPXOvqYS9vKedkjy/9CW+33EyqssIfBuYPJDBaR4=;
        b=Q/pgKgHuYZfE09vTWcpFbfg0jAcdyaHgnIdvHfxXnHlKKv5FnPz+R8dMqSQ8DKWFCA
         FDvGJQoU5PVab43DyW/GPEVSqBuMUeK7SW6HVviCY4WQaCbdrUKXDw5j9X+tzc/BSglH
         RjEYVkqnGTs1+ToC8owXV1JDOBXptTaVDlfbu8IaXQsMK9UBv5g1EhcYJ0YyV2ntVjUH
         sgo/wjrlfymUhry/1Qw7xoTgncqKm1nsS7VKeykC1iF4yAoy/nMHze1Jt7aDWhjLlLDQ
         nL989tn0Ko76VqeRxZ4RhxT9IWVI8URXf4YUzoQjJAsuxANsDXTky8F6xqI80+AO7O1O
         Nwpg==
X-Gm-Message-State: AAQBX9cEJXaAZ9RvvbuhSPWCc8Q1wT/JpiM92JelKVf9Z68zPbTZFjeR
        T8AuXRgzFaDqfRxyZAD0eviibfAPAx9n0HwkqoQ=
X-Google-Smtp-Source: AKy350Z1R1rt/oemO/nUeck+ddw0mx8iCKKauVkBF//24ZCYTCHcufd/AXJvXItZC+NwyDrTPlA5iQ==
X-Received: by 2002:a17:90a:1955:b0:247:1369:fb47 with SMTP id 21-20020a17090a195500b002471369fb47mr2028799pjh.0.1681475970997;
        Fri, 14 Apr 2023 05:39:30 -0700 (PDT)
Received: from [127.0.0.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id r23-20020a632b17000000b0051416609fb7sm2749097pgr.61.2023.04.14.05.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 05:39:30 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20230414075313.373263-1-ming.lei@redhat.com>
References: <20230414075313.373263-1-ming.lei@redhat.com>
Subject: Re: [PATCH] io_uring: complete request via task work in case of
 DEFER_TASKRUN
Message-Id: <168147597029.10931.17453459008729661162.b4-ty@kernel.dk>
Date:   Fri, 14 Apr 2023 06:39:30 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-00303
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Fri, 14 Apr 2023 15:53:13 +0800, Ming Lei wrote:
> So far io_req_complete_post() only covers DEFER_TASKRUN by completing
> request via task work when the request is completed from IOWQ.
> 
> However, uring command could be completed from any context, and if io
> uring is setup with DEFER_TASKRUN, the command is required to be
> completed from current context, otherwise wait on IORING_ENTER_GETEVENTS
> can't be wakeup, and may hang forever.
> 
> [...]

Applied, thanks!

[1/1] io_uring: complete request via task work in case of DEFER_TASKRUN
      commit: 860e1c7f8b0b43fbf91b4d689adfaa13adb89452

Best regards,
-- 
Jens Axboe




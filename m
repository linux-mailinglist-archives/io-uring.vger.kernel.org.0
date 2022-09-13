Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B741F5B76B8
	for <lists+io-uring@lfdr.de>; Tue, 13 Sep 2022 18:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbiIMQth (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Sep 2022 12:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbiIMQtM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Sep 2022 12:49:12 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80C3844D0
        for <io-uring@vger.kernel.org>; Tue, 13 Sep 2022 08:43:19 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id v185-20020a1cacc2000000b003b42e4f278cso10653444wme.5
        for <io-uring@vger.kernel.org>; Tue, 13 Sep 2022 08:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date;
        bh=PNUop9wzkrl205kt1PFyyUHEjZzMpaJTpUhi0Rg63yE=;
        b=CiayYDwXafv8cgRkWA0uJ7ol2jQmCXYq1PTflRtNSxhYB4Wx+qxVONMjOUV1FYJYli
         XiiJPvgbsYrVENILgPOrdnPc9qz4DV38VKLpRj3fY+qgYhDMILcQc37YBD7qkzW+/G9f
         RF7F3m5dcMnixI4qw5eTtNCuf8DLGA09xcYBbtX51Bic+kjzomeQNfUMY5CqDOpgdjbv
         1cxKLU3NZi3t2kfOjjW7hIGetuGhgezfmv5RQ7Ut1gM3JC719/0BNxwCdEtoujPjuRrg
         +J1xQoRdpbFrEbTj4p4QfGcydqAtCmrmYBhW94GWjDDOzfcshlxxRE+m14l1S9biDH4V
         +N4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=PNUop9wzkrl205kt1PFyyUHEjZzMpaJTpUhi0Rg63yE=;
        b=hVXb12KJ6SCQ2wLI9JAGPSShmjeykgSXTuSitO4UVRr22IsZvtDhSapVXg/bBw4GAj
         q0fc/E1M78pmhyZmYC8xa7NbS5K2Xut6hhXutCh1awnWq84rA+zxViqaN4LQWoE5a+O0
         iEIwBv6dzGJERl1FUQTnqv/YljKqnS1pp9+pQR9o5AqeX0cz+wnpRWLQlrTek79emBSo
         PkmOfUnKORxe7pE3AzZ7RTkp3PnhJY4MuidIppp5Nzf1/N0RpVlOTxW0Wly56J30LHyH
         uVGZIC9/moinSmldEgjeUdHjrCwbcTExd0QZf498S9lG5C3TC3KRlh0BJgFMBTFq6s3A
         nBUA==
X-Gm-Message-State: ACgBeo27b+MmYYFFgdmpIEBaanRKY2sDPs4zYphOQIht3h2YSz3C3cYN
        A4dOQ6qEPbXVXJcYiPbkxu/NIAY/dwHKwdBf
X-Google-Smtp-Source: AA6agR6VxaJ/1JfpH+3+XMCKZMjAHOevX67LQMIZ915lGaN+GCoiWVPQ2tIzHenozqRSfRPJLysnGA==
X-Received: by 2002:a1c:7213:0:b0:3b3:4065:66cc with SMTP id n19-20020a1c7213000000b003b3406566ccmr2905914wmc.184.1663082623913;
        Tue, 13 Sep 2022 08:23:43 -0700 (PDT)
Received: from [127.0.0.1] ([185.122.133.20])
        by smtp.gmail.com with ESMTPSA id u14-20020a05600c19ce00b003b4931eb435sm4334017wmq.26.2022.09.13.08.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 08:23:43 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <2ed8db2b22f7840977bdc58b6d282be750c878bb.1662900803.git.asml.silence@gmail.com>
References: <2ed8db2b22f7840977bdc58b6d282be750c878bb.1662900803.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] tests: fixup defer-taskrun.c after api change
Message-Id: <166308262318.27067.7371790942437307726.b4-ty@kernel.dk>
Date:   Tue, 13 Sep 2022 09:23:43 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-95855
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 13 Sep 2022 13:07:11 +0100, Pavel Begunkov wrote:
> 


Applied, thanks!

[1/1] tests: fixup defer-taskrun.c after api change
      commit: 2fadaf2ca667fc62f2275e21c229411d0834ec4b

Best regards,
-- 
Jens Axboe



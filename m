Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA09A4E5566
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 16:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238023AbiCWPlX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 11:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238016AbiCWPlW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 11:41:22 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E6C0286EC
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:39:52 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id e22so2105769ioe.11
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=43WkpJP25aIZkeNGASt1F5vPG495UN+qIW5EegL5P0s=;
        b=ALkygK4XatHWLqsX4UWRvyhcHb0HRFBLbUHk3qxDJ8+1UxnUo/Gk8Sjb6CI6tBCgpM
         PGVaey7xhw1xMJBJYMJJs1lt4KnsxLI2L/0tO0O7PntX85N6paV6jcOWRkrp2yHs/rw0
         pOkZAUArTt4j7jVpTBNjIpCeZKePpHWyZIlAKnbEdiDxTzgKoJb5wKfj4DXZYJzv7gE3
         vJG/ixgDC8eOh5wWZnaSdsnQs4UQDANo/8xvFvvLSOstRbvl4HS71+ow4NB94VacWOhJ
         MJ4Zc1vjLbbY81gWhM/KqpTLZGSLHLgiJ+kco2ASV9+D+TrrGdGZSRNgFvwHJer9WkYz
         GjNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=43WkpJP25aIZkeNGASt1F5vPG495UN+qIW5EegL5P0s=;
        b=yW7sjamHg4fC0CLhmGKyBsJMAfyj9nK5gyYh6WUkkrHgG5wLDIG0HiFVkqsfhVfSyr
         Yjqs65r8hMB0X4aUV76nkstKTvwqBLP8pSfYVHF0/f3/titr+lWbwlbSFvxxmzf7PHFw
         Qgfh5Q4YtKDMjNK8En3AGn8IrB6bIw69OhUFk48Cu6eYd9lybvhRzb4cOrT2Ji1uzxF+
         sRBLfnHcNOZB6aGpP5GQ1LZNTDliAoxv3DZhRo2a978wv5Y/t6LzcnYWDHDfI4s49vuK
         jEi4kKvgDCqYiLXiF9IwhhkXZJUeXyOyFHhsMK50dY1FreSbmnkoW+YljUnp3UA3an2/
         qXew==
X-Gm-Message-State: AOAM532kOtZHSE7XoURk8PUGJeDpkFRZdHL8yqQJETMJTuWZlzBc+4EB
        KZ2QTj90cSeC4J84CfvxixdJkuIcHK35PtiJ
X-Google-Smtp-Source: ABdhPJyeXllRLV8jposk2UkWdp5Dq2NyE0iOOpgMLOZDiGFD/5MVlflzLec56wNOAVEixpdJv6FjHA==
X-Received: by 2002:a05:6638:3e88:b0:321:34f4:8e32 with SMTP id ch8-20020a0566383e8800b0032134f48e32mr260642jab.56.1648049991756;
        Wed, 23 Mar 2022 08:39:51 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s10-20020a6b740a000000b006413d13477dsm124365iog.33.2022.03.23.08.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 08:39:51 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     constantine.gavrilov@gmail.com
Subject: [PATCHSET 0/2] Fix MSG_WAITALL for IORING_OP_RECV/RECVMSG
Date:   Wed, 23 Mar 2022 09:39:45 -0600
Message-Id: <20220323153947.142692-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

If we get a partial receive, we don't retry even if MSG_WAITALL is set.
Ensure that we retry for the remainder in that case.

The ordering of patches may look a bit odd here, but it's done this way
to make it easier to handle for the stable backport.

-- 
Jens Axboe



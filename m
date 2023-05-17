Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A96CB70719B
	for <lists+io-uring@lfdr.de>; Wed, 17 May 2023 21:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjEQTMR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 May 2023 15:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjEQTMQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 May 2023 15:12:16 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409B81713
        for <io-uring@vger.kernel.org>; Wed, 17 May 2023 12:12:10 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id e9e14a558f8ab-3357fc32a31so351915ab.1
        for <io-uring@vger.kernel.org>; Wed, 17 May 2023 12:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1684350728; x=1686942728;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=y7uBSF+pe8IN2dTuaW+PMEiYENlS9+cc0fi24hdSJWc=;
        b=z9JPJMQw8paBoFobyfFe4hlLrZ7f9SUoS2TUCZh4LwajhBzisACNVd8ulwg7OCRInS
         OSEJPMA2L69mOnw9phqujGHX5CTtGbL9hP35lRMbskGNdku4yame45T/+Ua1OHwhTStH
         6VgjKcVE3LCz/x5kEegw8tMh6JbBuZfqQrcpOzJuMhegZGlzzlCpHDd1yocmqlKmwYuT
         A99QEWm0RCbtw1PSsgdt6EMCd3RVnnKDDCpotMNwIxyDXp4Gzl3f/EMYq//FIYGX+urG
         a705ALy6iLQ2g7kB6Y+pcvlakUbdGW2K9QiijiXAQVdOwNIX6GAYjDajopr6brOItpEK
         FLfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684350728; x=1686942728;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y7uBSF+pe8IN2dTuaW+PMEiYENlS9+cc0fi24hdSJWc=;
        b=NXemYnmh9RpekmW5y4oSmBYGSrILXpmGJdmlWwzIDAZc5JkqoXtnkHlRJVWWhy+xF5
         eI2UzCkJzC/cyf9beZh5MPxzTHJ+tdne7YBdFKc5YBo4Exemc+aCLX+sOoW4phEdHD5j
         KoPP3CaOEBi9L4ymXuSyxZ/65XHXzBV0xd8VjuRQimhCCjhAekNIoeGAic5kF9+jmd06
         haBiFi+eFxL3O/ZSVtEFauwWoqjy6wZe0rb3Q56zdGOqTiVrtjSwBy7CE0B5HMFq70KA
         V89Hcf3oNqfw0NE6yckUSyrYSMCGAZwJyhjlP4iFP8ofcHlHrZMOwcwVCCPQcjgmRvdF
         yzkQ==
X-Gm-Message-State: AC+VfDzrzhgbZC/jg6a15nnQ8PAjA9VibmL3HsstO8kQ1gkYeCsudb00
        JGFIVcGZIsO3LnknWbCTOs9qk+2U4h8xdPRMjS8=
X-Google-Smtp-Source: ACHHUZ6BjU2+v1HYtRhyHQAFrEX4U39wYQoOdCZ2C8fRo3RXcoLtcIYxZWbmyjLv8CkDEP0sI+1FfA==
X-Received: by 2002:a05:6e02:1243:b0:331:30ac:f8fe with SMTP id j3-20020a056e02124300b0033130acf8femr1736247ilq.3.1684350728246;
        Wed, 17 May 2023 12:12:08 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b16-20020a92db10000000b0033827a77e24sm628996iln.50.2023.05.17.12.12.05
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 12:12:05 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0.4] Reduce overhead of multishot recv/recvmsg
Date:   Wed, 17 May 2023 13:11:59 -0600
Message-Id: <20230517191203.2077682-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
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

With the way that the multishot variants of recv and recvmsg currently
work, we always end up doing two sock_recvmsg() call for each subsequent
receive outside of the initial receive. That is obviously extra overhead,
and to make matters worse, that also involves picking and recycling an
appropriate buffer for those operations.

For protocols that sanely pass back whether a socket has more data
after a receive, we can rely on that hint to avoid iterating over
recvmsg/buffers an extra time per receive.

Patches 1..3 are prep patches, patch 4 has the logic mentioned above.

-- 
Jens Axboe



Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC347416FB
	for <lists+io-uring@lfdr.de>; Wed, 28 Jun 2023 19:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbjF1RKF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Jun 2023 13:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbjF1RJ6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Jun 2023 13:09:58 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C70910C
        for <io-uring@vger.kernel.org>; Wed, 28 Jun 2023 10:09:57 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-785d3a53ed6so2166339f.1
        for <io-uring@vger.kernel.org>; Wed, 28 Jun 2023 10:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687972196; x=1690564196;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=XplAgkI4QKZPCNDN0FcW7g0pJTRgMWJuwYlb2+rUbEk=;
        b=rGpAfBx7lLURSFvIyAd6vI5RU3F12S232Kt0/XvYWNlGwING89qrJtsRx3orKjprqE
         v16jRrhWBCVY3gWiC0USHlsOJF+7cV9bNrvH9kAi3HeJQvaB95DeXB+IuVTUX5AmkUB/
         iUl0l14DiozzBzO0sixuXBWj0JkYG2pnA2sf7QvaSSl/ILNSGUtWLUt7weUDV6Ij214Q
         E8SWljzXEyiChA5JzE7Z68uRSdv+9TotqP97TOzJcyHYrPAlA6oXqQeqLb5cv1oWhDvA
         iSWNRUTME4m+BOCp2xqHVOwm8BwHLxtjhVlEUvM1yCxOJEoXMClVNW/cl/MlRLvQKmA1
         VdXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687972196; x=1690564196;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XplAgkI4QKZPCNDN0FcW7g0pJTRgMWJuwYlb2+rUbEk=;
        b=fcW7WiwPUFtHWkEfZ7AxEpqM9xc64+jI8WKF86G5OYMAkm+ZRXXl+sAa1GB7gVhBz+
         g0z0qTwRO4s9NQPpPPp9TWL5SU0VlJbgWQg94VW/HdcVJ/UNq9tAYVZ/jr2urYWGlnRe
         eq6WX14iO9s4RJbqv0vICbeh4CxlWmUqZ0bCZE6vIcqDW6G7xx5iuD4+ycp8k4wpdcU6
         RRExbkqmVEslUjJZSwguvgG+z/qCYJYbjHh67L4ybYgZc4rd7ZD7JyML82SlUIiy2uyh
         C9eEDysJ9oSuUaGve37NagIT+hkz+e1kWLhFLi0uuKLsnE7R4gP5Mgd02CWKjpsf7yiw
         nHvQ==
X-Gm-Message-State: AC+VfDx6R+F+7lt4OStAXmRTX/PgTWE0eQWqH4kQ//3jkx0REGB7oFb5
        uBUxQDlfsJ5Wjp7nmxHYoduxEYwkeSfCl6CV254=
X-Google-Smtp-Source: ACHHUZ6u2TUMVgOXbgBQN+4r1ZCfwJcy0qmch/rxuq+q3HiOKQSf83YzsaaUSoU7cNKG7FvZO+e6zg==
X-Received: by 2002:a6b:1495:0:b0:780:d65c:d78f with SMTP id 143-20020a6b1495000000b00780d65cd78fmr16316681iou.2.1687972196103;
        Wed, 28 Jun 2023 10:09:56 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t11-20020a02c48b000000b0042aecf02051sm708342jam.51.2023.06.28.10.09.55
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jun 2023 10:09:55 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/3] Misc 6.5 fixes
Date:   Wed, 28 Jun 2023 11:09:50 -0600
Message-Id: <20230628170953.952923-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
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

One fix for the wrong type/value used for msg_inq as Linus complained
about, and then a fix for making io_uring a bit nicer in flushing out
pending task_work if we're trying to run it and the task is exiting.

-- 
Jens Axboe



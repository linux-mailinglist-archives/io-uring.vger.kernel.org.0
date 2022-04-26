Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD917510715
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 20:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351409AbiDZShB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 14:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233081AbiDZSg5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 14:36:57 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B197346141
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 11:33:49 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id g21so21319152iom.13
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 11:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e72UetNf02qbfF2TYZSxX0kCgMWKXcLJvkGdf32o76o=;
        b=ndf/30Cqewh+/aQnrG58DQbO68hhHGbw/BuF1IQdow6hLLysS6Ylk/ipukpJRfvgrw
         n4ogO6MDg3ZvGN9XidB5ieAU2gsGS56VluD0J8Ndn233GrV6TlP6lrT2o7c7sdu+pbwT
         94fKXUjwW5F5gzOaeE3Y+Jk+xXZEuRGWjiJ6JG3Zr+Pbt6xSzQHiqt2Xr6ddfvrJoO4l
         02MPwaF//Cuwz/Pre5aDKgYfdDKV2Ub4mFmNWqyEd4hwWq6xT1Cr4TmfhyxCHy6Jkm4Y
         8fRse4R2LI+UYgPjiJ8ElpSRTaACcumMlvk8vR4u0F9DY9RzyhdlX3fPAXMPj0qT4ba1
         iElg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e72UetNf02qbfF2TYZSxX0kCgMWKXcLJvkGdf32o76o=;
        b=8KR2ptfs4Hm4jaMKmU1/xuXhXTfpYs4WH8oCJkfWujKDu+OBUtIFXsUaPuOcfYK3LW
         sqIBqUC3dzM5hIusHen/mhPXgbTGCTlqp2AV9OCBTIAWqjfAVuBbr/FAlDH5TmLCsJ19
         AesIZJaBgKTEAdL7J8aNIwsKAWHD6bzgie7z6V11dPm06QR0jQTw4rvtnovKINyXz4MP
         shck4W8km0xNqUWicGp1doKaylenOk/ceu0zNBrizy0ferGZY0gOJ6wRrOs1uu4CSf5c
         foKSN4lfgKR5bn0KYrUvfO1a+n9tNCNI2pTr3qCi6OGkQegg2Ho9/xjxhalRxXmudqqr
         N7Fw==
X-Gm-Message-State: AOAM531dKB92kSKaWweD2bGC52LpQbJW7lms+5rdfY7TQchNEGGH71XL
        iqgiiSOW8GFthu9WOm3dGk/HWYN+KcnOkg==
X-Google-Smtp-Source: ABdhPJwbaBwxr8A1ikF4505OlgYS3qIxPjeMKX6yglY6MmNkmd+/f+yIoGiyXq9aWUXIxNjRwXybow==
X-Received: by 2002:a92:c269:0:b0:2cc:505f:d963 with SMTP id h9-20020a92c269000000b002cc505fd963mr10162320ild.118.1650998028619;
        Tue, 26 Apr 2022 11:33:48 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o7-20020a92d387000000b002cbec1ecc60sm8227524ilo.86.2022.04.26.11.33.48
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 11:33:48 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET RFC 0/4] Add support for IOSQE2_POLL_FIRST
Date:   Tue, 26 Apr 2022 12:33:39 -0600
Message-Id: <20220426183343.150273-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

For some workloads, it's not at all uncommon that every request will end
up using the internal poll feature to trigger the successful execution of
a request. This is quite common for network receive, where the application
doesn't expect any data to be immediately available. Yet we still attempt
to do this receive, then get -EAGAIN, arm poll, and trigger the retry
based on poll.

This can be quite wasteful, and particularly so for cases where we
expect to arm poll basically 100% of the time.

This series builds to adding support for asking io_uring to arm poll
first, rather than first attempt an IO, and finally adds support for
this feature to send/sendmsg and recv/recvmsg (with the two latter ones
being the most useful, imho).

Given that most requests don't support IO priorities, a new flags2 field
is added using that same space. The last bit we have in sqe->flags is
added to say that "ioprio is really flags2". This does mean that any
IOSQE2_ flags added cannot be used with IO priorities.

-- 
Jens Axboe



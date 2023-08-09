Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92FED7768FE
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 21:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjHITnP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 15:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjHITnN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 15:43:13 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F6A10DA
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 12:43:12 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1bc83b24ae2so501645ad.0
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 12:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691610191; x=1692214991;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=IH5nOy1S/9Tx3zBrkR8FJX5dBw6Ryk/Zm4l/EWBJoAY=;
        b=2fA3i21v+F9RYL58qCH/A/vVIdoOoPhejs0LcFUk2qAwOvaXKBOSHQcRE9aiQtRT5z
         qqmXlm2TyPcIIgLlU05rLXM0vxpCuazC4ylA6iNWr3VOT0RnYM0D6x2sFlK2H5V/USg0
         /zczomZHvrevyeWV8PS7kxdoHSofiijVM1o91HaD0YrJ7DBWHT8Ck+hLI3vSM6pE9yyY
         8j1/4PeygGg1nCR+0gw63K56cFnGQeQlYj5SIA8EzFYoayLpfAieK4fVJ+bSFpcLJ3iV
         N510VgPMyMXfWUj970SKDIXSgutmy9mYDRbGxRUFjidW97Owc/UAZNuQ06J45XY27np5
         zXug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691610191; x=1692214991;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IH5nOy1S/9Tx3zBrkR8FJX5dBw6Ryk/Zm4l/EWBJoAY=;
        b=IEBrxPCcn1aHwoc66hJd68fOk++JETeEQozxLTE+c815ZkLOKQwDg5dhWOX1zpCKYp
         gdF0vt51W4QtIBogFNjVnGfkx9DSHmN4H2FIIkfIakLKhykU1BJQOtZz6GQo1nCdcoF0
         viadr4XhyVVvaGnk3RJQDgTui9GUtQWAz+8G4W7GXv0R2vSKaNlZ28S8yNcX9ltvBZu9
         lxBhc/5IEUfMjge2xo/2bknOIYnsd16W4SvrgcAy52f2P0FhDMVniH4BkbYlDw/u6ovR
         Pr1/jvU1e3gEUY7GG4/nuJNNuE4h7nueUSsqiJBurPIGP0Icm5NPDpagsUlz9VUCwUOs
         g6iQ==
X-Gm-Message-State: AOJu0Yz3vGAzX9E+6/EImeayoOA6+6P29MS4omZSJQJtAUhFElRiu7yG
        oMVT/QhVtpJjLUuxPjOCdJ6ZllurHnZS2gtJ1M0=
X-Google-Smtp-Source: AGHT+IEjtUnQ7oJq8ehgtwtFB9DOPHHW8sXZf7uhF+t8tE27uyBUz4SJ5fjbgOx+UdohLe1K/7/h/w==
X-Received: by 2002:a17:903:22c1:b0:1b8:2ba0:c9a8 with SMTP id y1-20020a17090322c100b001b82ba0c9a8mr103789plg.2.1691610190852;
        Wed, 09 Aug 2023 12:43:10 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l19-20020a170902eb1300b001b8953365aesm11588919plb.22.2023.08.09.12.43.09
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 12:43:10 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/3] io-wq locking improvements
Date:   Wed,  9 Aug 2023 13:43:03 -0600
Message-Id: <20230809194306.170979-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

In chatting with someone that was trying to use io_uring to read
mailddirs, they found that running a test case that does:

open file, statx file, read file, close file

The culprit here is statx, and argumentation aside on whether it makes
sense to statx in the first place, it does highlight that io-wq is
pretty locking intensive.

This (very lightly tested [1]) patchset attempts to improve this
situation, but reducing the frequency of grabbing wq->lock and
acct->lock.

The first patch gets rid of wq->lock on work insertion. io-wq grabs it
to iterate the free worker list, but that is not necessary.

Second patch reduces the frequency of acct->lock grabs, when we need to
run the queue and process new work. We currently grab the lock and check
for work, then drop it, then grab it again to process the work. That is
unneccessary.

Final patch just optimizes how we activate new workers. It's not related
to the locking itself, just reducing the overhead of activating a new
worker.

Running the above test case on a directory with 50K files, each being
between 10 and 4096 bytes, before these patches we get spend 160-170ms
running the workload. With this patchset, we spend 90-100ms doing the
same work. A bit of profile information is included in the patch commit
messages.

Can also be found here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-wq-lock

[1] Runs the test suite just fine, with PROVE_LOCKING enabled and raw
    lockdep as well.

-- 
Jens Axboe



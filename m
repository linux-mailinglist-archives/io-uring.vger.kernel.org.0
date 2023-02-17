Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B8C69AFEE
	for <lists+io-uring@lfdr.de>; Fri, 17 Feb 2023 16:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjBQP4j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Feb 2023 10:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjBQP4i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Feb 2023 10:56:38 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB584711B9
        for <io-uring@vger.kernel.org>; Fri, 17 Feb 2023 07:56:07 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id s10so557996iop.4
        for <io-uring@vger.kernel.org>; Fri, 17 Feb 2023 07:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=sE08O1tjyA/vVPffiHUkuc/f1TYte2T8Pb3AfAFhvSU=;
        b=AVJ4GPkdHgISnSkiSqs9446juNp47p+JoplGCGmw/7MNXBpUuohZCzCWPLlyOj8g2b
         MfePjAyvU/o+ub2r5+u9cNRVF3ZrnKhzgAv7+sCEV8/DTMonlo7eBTSkUmvb1BOV8OTb
         GnJyjG61ygkGBaASf7j4GeXPWe9Kq1+lY9AO3tMsuUJiLHcsKUu14Y47vUnfFkVzGsb0
         0l4gg1+hi0ARcBBdvK1ZrxetwxqJDQKj4Ma7IHTCK7+4DnVpQ4ud5pMm7rZilGyfi9kb
         XErthlp0el5utoj+H0Amy9kJ6pQDK00AmWtDTKMxe6CCSI4l+HkskBnDTp5uUBstZvHS
         wMnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sE08O1tjyA/vVPffiHUkuc/f1TYte2T8Pb3AfAFhvSU=;
        b=r79dQn95Vr8ZIHaslScqt7P7tCY/yW1uiftH2yd0VKV2Ot8ikf9FqM5aNgC2JmRHXK
         OQS+1CjlhPtRzzQVHCaaVBs5H+ByNsCh5Ca7PKdk7Nsw3IH3svJz865eTOpfue1QBUTu
         skrLEvPLz8zaeCeITwkQOtbY892wGrCMLcsztLg5MZAxXLXbqRlLs8BM2gmOXP90zc00
         JdqDZB5jrA0GYTiU6nxCxlzmzEqJg9EZ70FAdEwmtMxLJvE4dkS9Ff3w+OE+EV8qcNHa
         1UhHIIaQ6+JFgl6OqaCZsYZaK3vgutu3yqJ8Bl+XaHhdRf4S7lPMJrT77ocA7CrFqKgM
         6Omg==
X-Gm-Message-State: AO0yUKWoYyxP7jp18gC9cZtpNZW5f9bFWmuLYFLXjPs4Y8NRjAlRyf8B
        DO66YNPMMV87BtrHDkgx0eCTcizkkuHmaJyu
X-Google-Smtp-Source: AK7set+TGAzMbK759R65vnAOGmcDcshG8wKoorKua/Y7eZ8QCgZvUoUCH44iEC7SdiHYXc459RLJdw==
X-Received: by 2002:a6b:d111:0:b0:707:d0c0:1bd6 with SMTP id l17-20020a6bd111000000b00707d0c01bd6mr1079344iob.1.1676649365402;
        Fri, 17 Feb 2023 07:56:05 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d22-20020a0566022d5600b007046e9e138esm1551156iow.22.2023.02.17.07.56.04
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 07:56:04 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCH 0/4] Cache tctx cancelation state in the ctx
Date:   Fri, 17 Feb 2023 08:55:56 -0700
Message-Id: <20230217155600.157041-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.1
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

One of the more expensive parts of io_req_local_work_add() is that it
has to pull in the remote task tctx to check for the very unlikely event
that we are in a cancelation state.

Cache the cancelation state in each ctx instead. This makes the marking
of cancelation (and clearing) a bit more expensive, but those are very
slow path operations. The upside is that io_req_local_work_add()
becomes a lot cheaper, which is what we care about.

-- 
Jens Axboe



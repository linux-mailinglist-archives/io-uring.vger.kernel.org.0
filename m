Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC0663157D
	for <lists+io-uring@lfdr.de>; Sun, 20 Nov 2022 18:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiKTR2N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Nov 2022 12:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiKTR2M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Nov 2022 12:28:12 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561E426A
        for <io-uring@vger.kernel.org>; Sun, 20 Nov 2022 09:28:11 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id k2-20020a17090a4c8200b002187cce2f92so7237336pjh.2
        for <io-uring@vger.kernel.org>; Sun, 20 Nov 2022 09:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=UGrjqFZsD9Qmh4/moaIV1TqQGAGeDguHw70F2mLBKKw=;
        b=h64TozVOpepo9VC5bvoDSTJFKCrIHrfMERWWODnqbp7CidM76wsxi4l/xz9cuPSMBT
         zxJdY7Up1XLNvcTyY7N1mEgn4VNAuHZBwChvhi4B8L17fo+QDklJRkfIQMmuF1adPSe/
         bC/IauYFW7frVcryjKa5VBqKb3E0Aedt2KEICLD5o37RXtvTsPTFO5Vy8XkVbRJrfq7p
         mELmu9vXVSi3O0fbPVYCG1pXEv56MYsM3RywDAyRvO4QnUcTSy+Siv37zkS0VErIVzwN
         LIrDorqaoJ6gp2WcFhBoC2+351BBKVhKjvJRRd/nrsF5eR13RCR0OfWYfkJ1iinmCcaM
         jdog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UGrjqFZsD9Qmh4/moaIV1TqQGAGeDguHw70F2mLBKKw=;
        b=1WumQmm2ugq/PpiiIyjmp4WnPlvWRsi7pGjAuRLpTl7wANWEAvVSg08bjpw5KMxQP0
         KUmzAe5xpZAI2Hh1/bw7SqO0QannnGbrwRTkqUwi+N3LPmZ3cGh+Q+Lwhmp6vAikkoI5
         GueF0IP9pFSaAzhedsX+CTt4NQEJ3RtwE+XBeZWShUFHRU2uc81YaslCM0F/qZBI63rB
         7yHfM38cXhAOpxBfm0q5VmkxPlHf8vZERK9BXNpaacinqy7HvHKHKTDMSTk8HBs52jn6
         Mx4S1OdFGx5iLk8heg6NiLGMkbUX7HbC08ntG/VvsPZO+8TotwpdVgl+FtfPqNDW0bpM
         hJpQ==
X-Gm-Message-State: ANoB5pl9/RkxrGbK7jXLW3RPmY0xHrmKZp7tH8utDg49A7YlSBCuUGCH
        4EbIwEr4Ktyq17eQgSbxALJ9cHuABdmlvw==
X-Google-Smtp-Source: AA0mqf7nBFPb6sdXsM44dPktPh8cio2xzYYhIfuFFR3NKlLvsGdlVq8juHH+EhxIwYe2G9drt81dEg==
X-Received: by 2002:a17:90b:f04:b0:218:8ec2:a4e2 with SMTP id br4-20020a17090b0f0400b002188ec2a4e2mr10167090pjb.174.1668965290509;
        Sun, 20 Nov 2022 09:28:10 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d12-20020a170903230c00b0017e9b820a1asm7876953plh.100.2022.11.20.09.28.09
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Nov 2022 09:28:09 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/4] Terminate multishot early on dependencies
Date:   Sun, 20 Nov 2022 10:28:03 -0700
Message-Id: <20221120172807.358868-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

We had a fix for -rc5 which resolved multishot dependencies for polling
on the io_uring fd itself, but we can also have dependencies with eventfd
(if it's registered as the ring eventfd), or epoll if an io_uring fd is
added to an epoll context and io_uring arms a multishot poll for the epoll
context.

Try and cover this generically rather than need to special case file
types.

-- 
Jens Axboe



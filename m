Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF67674073
	for <lists+io-uring@lfdr.de>; Thu, 19 Jan 2023 19:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjASSCg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Jan 2023 13:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjASSCe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Jan 2023 13:02:34 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F233C90860
        for <io-uring@vger.kernel.org>; Thu, 19 Jan 2023 10:02:28 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id b127so1327148iof.8
        for <io-uring@vger.kernel.org>; Thu, 19 Jan 2023 10:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IvlyFxk0cNA+UMCcOxvJcY/Gh8e9hsVwV5Z0I7XRXkM=;
        b=ejQmnUWe7xXiFtLiriDcGIonVJrZK0PoV0GjfgfOhQnpoJh6LiMrqDO3yYeK2qR+xE
         HxLSlXscb9XJugw9krMVCfcP4Uy5Yb9FkZnC0fsbp8nqA2wktODgasX9wGvFGdrx9Cph
         uVqGJsnUFHgD8oJ3Y89paq1XotT4JLqtMJn4s85tnM1VBuZPMCZzPyUPsn4n4Fceqocq
         4Yo7Z7XxgQ5T2HyP/VskUgDDbwApgrCp9WwPJetTvh7k7/FknezXAGj4Y+4Tbcg3nRyg
         v1PFFDZkEP9mQapi5E2naAruURGS1/fYaoJ3T2B5MzptVPhi2LX2ciek1IZFb6ABowmm
         A/KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IvlyFxk0cNA+UMCcOxvJcY/Gh8e9hsVwV5Z0I7XRXkM=;
        b=AcAJMM4XxOJQzPnlzDyVAvYvxdhMswW4qZdO2pXgzSoVjolkv1/l32Lnxbu1rg9hS6
         q/yDtjl/kNVK5nPgpt8geapePEWDsc8mrl8TMjtk3CaVvBOcrkKcKkvcTJXHKSFBo34a
         tklIWwTjEDJMPIZs3Sn+aTELY5GGs0SxxdPh1m5s8Ti8rCJfT0Dr520jXtT0ZFNCZIdL
         4As9Wpzir1LgSK4+QtYJX1akz7bNY1gyg0zqyIQU82lTL/mriHOrCmWZwvJG6RHWZ3zn
         Hz2ltK5ImByLJu0O5c0c4EwNHJfj6dIhJDU9DW4LFGTjCQokYZQAvcOqC2rvcNdrGY8H
         l9AQ==
X-Gm-Message-State: AFqh2kqQDKz4Qj52ACTABbeCMfekTDtMKSEa0pNeJ2LA7PEE99nohNgf
        i9cTAN9+tTBmXJEoThFNen9BA7PTt2AGhmG6
X-Google-Smtp-Source: AMrXdXukVu5/PwHhqzqCs/2i7SXVTZBM7NRltCJeAuVDEdEDrh0n+LonqUrnCb5p76NUucNXrruJ7A==
X-Received: by 2002:a6b:8fcd:0:b0:704:d16d:4a59 with SMTP id r196-20020a6b8fcd000000b00704d16d4a59mr1541620iod.2.1674151347868;
        Thu, 19 Jan 2023 10:02:27 -0800 (PST)
Received: from m1max.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d3-20020a0566022be300b00704d1d8faecsm2354914ioy.48.2023.01.19.10.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 10:02:27 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 0/2] Fix locking for MSG_RING and IOPOLL targets
Date:   Thu, 19 Jan 2023 11:02:23 -0700
Message-Id: <20230119180225.466835-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.0
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

First patch is just a prep patch, patch two adds conditional locking
for posting CQEs to an IOPOLL based target.

-- 
Jens Axboe



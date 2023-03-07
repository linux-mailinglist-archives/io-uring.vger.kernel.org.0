Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A5A6AE98D
	for <lists+io-uring@lfdr.de>; Tue,  7 Mar 2023 18:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbjCGRZl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Mar 2023 12:25:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbjCGRZM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Mar 2023 12:25:12 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ECA1A2F1C
        for <io-uring@vger.kernel.org>; Tue,  7 Mar 2023 09:20:22 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id i5so14895460pla.2
        for <io-uring@vger.kernel.org>; Tue, 07 Mar 2023 09:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678209621;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=dLoB7xqcbq2D/9EuKOfTh5Aky6biZ6xDYbDnw2JzEq4=;
        b=yCMuN5QpF6F8x7tzPPMVTle1TkAXahuai/5ScNH8qcZxtLsY0LY3EnY4oqj5IxyBpK
         qjR3aHTrHyXCGESRKUNkyiIycDwirn1STeR+2SWNv4cK7ROgSDf93lAst4nMkm7zPlEX
         GdrTSsm4IsWYfsmx2PAXdq6CAQLrJmpft5CMYI9JGCyWgP4lwiwsjwPJ8vNvi127sebR
         ueCn6r/r/ftBl2B5PzZCj2+hXkqgJdGk5ZwMgQ4kVO4ND6PQ/r5K+aY8uJCxpGhUmHWQ
         NeaFvLIvS71UEhLT5bQqyxIgWk5+rnm/6gJvoIW345E+6UBFbCw6/wvGriNv5M/S84XG
         M36A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678209621;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dLoB7xqcbq2D/9EuKOfTh5Aky6biZ6xDYbDnw2JzEq4=;
        b=h/pYdptXJWpVBH2bJD7QmfJOu0fr5XxNGHf1ux+yynl4KdSi+JYEFTyoeX9VTSG0qm
         qX0Mu2GreVx7O/yrPWCsV02RRDU4F8rPBVKmksdFpbFnpzL5TN5YNV26l7HQ6KIsbtE7
         XgjvlojK0Ew+gTUggsLnNPjM0ykxkF4oad7B72LhDQVV1eSax+O5y2d/gj7Mh+icWmI8
         yprmvFVLJzIJEE5ntWaInjwjUEsIl1+p59SlbTo9Hh4Q4ZH0y61VF/jon4ppKuqepOdn
         tzAiL0PoTgEnxqmnSRgQl6A8szOiYchZqrGKyN2hUfYbmxmiPdYNZoItblfAW6D3ggO0
         rkBA==
X-Gm-Message-State: AO0yUKUIU85zIi+kxQNsQmuWTTuANJNtMGWgsnhMqYhXtgKiAitjgPx/
        nCGbtq4LeMQfP1+0ZSBNDtZBtUmk8Bs0axgMbd8=
X-Google-Smtp-Source: AK7set8rDGYZOIgkIwn4GSWtWuoEh/oVIqQ7Cvp4xVlIHUntM7PhsBFAFUDiLHlQuD6P7d05dsSzVA==
X-Received: by 2002:a17:902:cec7:b0:19e:4cda:513 with SMTP id d7-20020a170902cec700b0019e4cda0513mr15454468plg.5.1678209621418;
        Tue, 07 Mar 2023 09:20:21 -0800 (PST)
Received: from localhost.localdomain ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id c17-20020a170903235100b0019e76a99cdbsm8651390plh.243.2023.03.07.09.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 09:20:20 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: [PATCHSET for-next 0/2] Flag file systems as supporting parallel dio writes
Date:   Tue,  7 Mar 2023 10:20:13 -0700
Message-Id: <20230307172015.54911-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This has been on my TODO list for a while, and now that ext4 supports
parallel dio writes as well, time to dust it off and send it out... This
adds an FMODE flag to inform users that a given file supports parallel
dio writes. io_uring can use this to avoid serializing dio writes
upfront, in case it isn't needed. A few details in patch #2, patch 1 does
nothing by itself.

-- 
Jens Axboe




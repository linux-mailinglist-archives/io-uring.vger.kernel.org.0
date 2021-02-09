Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1BC315698
	for <lists+io-uring@lfdr.de>; Tue,  9 Feb 2021 20:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbhBITOI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 14:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233272AbhBITFc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 14:05:32 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98236C061797
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 11:04:23 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id e1so17153018ilu.0
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 11:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KeMQp8Ytdi1QlxzNEcDsOSyikmpFUwRNGeKh9p4oClE=;
        b=avFWrQa+NrUN2NXo9iZcWDNr8gQdUQKlxR9SbK9faenh/xrcPoBSn611cj7+5Acj1V
         5D1zeKbrx7TmhCSpx9KmjmIsjZeXLGBAGcoVxDPr5XjCVNpw3AxpB3iZaHUFwke46UWF
         8DCyJ8CbBlr8dowBhZfiZdywLyIfXbJsnOZXK/AD1X4QjXH3s+FsyTkz+rICOZ/dwnue
         VSVNQ+HGrYrY8MTAOHOl30nyvYQbsv3VaEkUraq62G9YW1Q5X3xpuduJksnWjjokSQWi
         aBurgMB2O0hi2K/tnONmDz3Dnl9sTTzjzNCjfMo9S13TtdeEwCuwiNtjFqAkooT/QlNB
         +sZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KeMQp8Ytdi1QlxzNEcDsOSyikmpFUwRNGeKh9p4oClE=;
        b=ZWZLwvVWVQEF6fNk0YsdQv0PCNco6srboWm04LPiYE8XeBHtmtdYOFHcUpD7w2UF2O
         wSRvAKsb6V1/n7sP6GIXTNtYaJDpAO6h+RflfNMDxNBV0c2GYF7QFDTVWG5gauYkaDpM
         NwRpLdlyNvbImXKRDQo0aWV+6SUJLtaN/YwHnnHhsn4jjdrZvvSnA8HIneQCeSY0Kk43
         r/1YKC/TG4JTS9zsLo230pYeWb6BySpE9mB5ZkRbxgarweGkvsSjEmGaaiby9warYyal
         C1C7aDODf2XnuN7+Jh11IFb8NRfWYWu9V80RdWqggNzH3gfFeET0MLTsDD+/D4eyEV0x
         MErg==
X-Gm-Message-State: AOAM530wI6scACtc4VLgz401SHb6jLpWw+Vw47zhcOq6d/OSL0gOb/BT
        TuOo7BGPuHMbm5ur4KuPW4OiAgQxCmUrcS70
X-Google-Smtp-Source: ABdhPJyldwDMbFFTfgx4iySFJFwzrkS2SK1Ew/s8X74qTG7oFDYqeK0IL8T3P/0YuQmxNirFuu+Opg==
X-Received: by 2002:a05:6e02:12e2:: with SMTP id l2mr21444933iln.91.1612897462796;
        Tue, 09 Feb 2021 11:04:22 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i8sm10645554ilv.57.2021.02.09.11.04.21
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 11:04:22 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/3] req alloc and task_work speedups
Date:   Tue,  9 Feb 2021 12:04:15 -0700
Message-Id: <20210209190418.208827-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This small series ensures persistent req allocations across invocations
of io_uring_enter(). It's sitting on top of the 4 patches from Pavel
that move the submit/completion state cache into the ctx itself.

-- 
Jens Axboe



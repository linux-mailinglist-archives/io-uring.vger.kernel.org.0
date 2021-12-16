Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F962477957
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 17:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbhLPQjE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 11:39:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233079AbhLPQjE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Dec 2021 11:39:04 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA18C06173E
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 08:39:03 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id x15so11093432ilc.5
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 08:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WuiksDPLX46rGvth8ZoLiIY5pKEIITYAcJQliALs1ec=;
        b=4kV/CAF4VTowFvtMxlL6qG65R7GTZCDJGnm57mJgsFe2IxB8sjZV4ldX32hYm+sutJ
         ucztWjponY482RE/7JFN9AFRkvMCKrbTQBjmmmfo1NMXX9S9YNdPU+CHcwGfQQUEoK2y
         W5bBpg2mcTEHGWaFOM2ES0EXhlrl95fUuwxsBEFoF4DvK3iP2gVzj3ho5eiy79YnfA2+
         +cBkEY26aWtKl7wG9lvddzHhQiClvUjIzl1MIYODSvVSchKeXNmLZeuZE71Gd5P/NRyt
         LeTY6kB4GSzQnzW72FYH5tFp/kSUKMoOpfnPjuLM6O8OxaePESKHpUF7djO+Q3dci1p/
         yvRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WuiksDPLX46rGvth8ZoLiIY5pKEIITYAcJQliALs1ec=;
        b=BKPv2kViCt501KYkma1gT0cZmTpVVzIpcOrFz5lk2ghere5Zhxb7Z+jL7MMzSq0HyN
         apKG18gA79OwllP/LbDRs/ct3N6ha6ZsVgDoH6dUjOzt9B4/Kkpk5cxB7cERAkVPnekT
         bKHFlNjOvFpMctA9MeboR6doIwmXQ491noMd3bFbgVti8hUH1CpKqvuqJ9RUxvdkN8mE
         ghKSKJpSKiwMpUYkV/YfncepPHZPkRzMNzPNZrqK0mTxs1xR2uAbTJoE46aIndGzRDp+
         XsNf7a2I+cjGJlVjdyQIRS9ZLVL3nPR19CUvBjfgEaVzAlvFT/lLFeg2JIRXaD6bcb4b
         /eaQ==
X-Gm-Message-State: AOAM530Z/aDeJfyhqLE8Wby+S31OySUnRvnnYdMEWyHNOZPEE96N4V5w
        n7kwV/IWP6OIR+hdgz4Dt78WM9JGH1fz5Q==
X-Google-Smtp-Source: ABdhPJye2SGmV1G1NKox7Eax5N3l1SrMAtCAMBAWdWiCRRAjLXyT7evL1MC0E1nB77hJVO4q9ObJ9g==
X-Received: by 2002:a92:cdaa:: with SMTP id g10mr9703007ild.142.1639672743161;
        Thu, 16 Dec 2021 08:39:03 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id t17sm71816ilm.46.2021.12.16.08.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 08:39:02 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: [PATCHSET v5 0/4] Add support for list issue
Date:   Thu, 16 Dec 2021 09:38:57 -0700
Message-Id: <20211216163901.81845-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

With the support in 5.16-rc1 for allocating and completing batches of
IO, the one missing piece is passing down a list of requests for issue.
Drivers can take advantage of this by defining an mq_ops->queue_rqs()
hook.

This implements it for NVMe, allowing copy of multiple commands in one
swoop.

This is good for around a 500K IOPS/core improvement in my testing,
which is around a 5-6% improvement in efficiency.

Note to Christoph - I kept the copy helper, since it's used in 3
spots and I _think_ you ended up being fine with that...

Changes since v4:
- Get rid of nvme_submit_cmd()
- Check for prev == NULL for batched issue



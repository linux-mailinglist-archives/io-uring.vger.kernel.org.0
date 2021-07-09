Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2993C27D2
	for <lists+io-uring@lfdr.de>; Fri,  9 Jul 2021 18:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhGIRAS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jul 2021 13:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhGIRAR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jul 2021 13:00:17 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37831C0613DD
        for <io-uring@vger.kernel.org>; Fri,  9 Jul 2021 09:57:34 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id k16so13110866ios.10
        for <io-uring@vger.kernel.org>; Fri, 09 Jul 2021 09:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=H4LDaWUGEaDKw0Ax+G7pyjMnHQ5u6gDzjWtMFzsvKug=;
        b=JVD98tQi4HGAIiD1eoS6EdKx45WBTwncHbLO3N2xEcpnnoi//U4Jb31V44spseiKei
         +mFECBUeqFtrqhwmLihxXlF086mjRAGV+kOcRSbxqoFcOts11iI2f1uA39FP1hH4KxwL
         oUXEWjYPz+Q5wjJH9UVuFgD/H0Lus5sCaD2q9r8mRNOt4bbw6N5Jn2LQpRlIzQzvsPlz
         +t6sdsR6mHvuskGibhu5sOswLJnU1fsLc5VOWUIe2fcHCF1R3oSSg7JL26gQEz+VFFFi
         fOIngCYvNgKF/EA3UNaQpwIo71Xi/tgXWc/rMbQGbo6Z+cKTyLunTFJg9JBIuTC0nf9L
         nCOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=H4LDaWUGEaDKw0Ax+G7pyjMnHQ5u6gDzjWtMFzsvKug=;
        b=sSNYMMbjV/5S7pjccwW+WkySCSZB9eJtE6f2eiJ8b1mu+NWxuBIomXa9efvUD7uYZF
         m0WmrXx7ZN2kuGQu3dfjjqNRrMcfsyTfAksbEhsARUZExucjfZ5cpizM8PmjsgOPdaqc
         PkubC3CzolqFzK614jr+p2BwbIMFjo3bsot2jwl8kJpQADlTOIDVdaeiN1GJTQZ3efv5
         AugWHXnjT0N2FyH8Jybd6nw4cu17f5+G1u5hn9kHf+GchH3easaK7sllTlbI7ZtjBjFR
         s1NBLuF7FjutIxyL/Lc0XdhLHbTk//IDRaJV4qZCQfHsC4Vtlf1R/Bgh68nIF8UuleiX
         ccTw==
X-Gm-Message-State: AOAM532t9biZPLKNKl4opeK8QuUJ0zEDLOpDjI/Hf5iVIcFT2rTQwFgw
        uzmU/nEIr+9qfYj1yqNfdBi9dcu+z8sNSg==
X-Google-Smtp-Source: ABdhPJzjR/w1jNfv2DcZwyuC2UzLtb34K9KfG/LXNIW5YiIFAvFRtim8AyF74yhr6ukHY6nB0pCfHA==
X-Received: by 2002:a05:6602:2cc8:: with SMTP id j8mr13587123iow.141.1625849853524;
        Fri, 09 Jul 2021 09:57:33 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id c19sm3170961ili.62.2021.07.09.09.57.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jul 2021 09:57:33 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.14-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Message-ID: <118a849b-d742-ff20-9815-6c226b8518e7@kernel.dk>
Date:   Fri, 9 Jul 2021 10:57:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

A few fixes that should go into this merge. One fixes a regression
introduced in this release, others are just generic fixes, mostly
related to handling fallback task_work.

Please pull!


The following changes since commit c288d9cd710433e5991d58a0764c4d08a933b871:

  Merge tag 'for-5.14/io_uring-2021-06-30' of git://git.kernel.dk/linux-block (2021-07-01 12:16:24 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.14-2021-07-09

for you to fetch changes up to 9ce85ef2cb5c738754837a6937e120694cde33c9:

  io_uring: remove dead non-zero 'poll' check (2021-07-09 08:20:28 -0600)

----------------------------------------------------------------
io_uring-5.14-2021-07-09

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: remove dead non-zero 'poll' check

Pavel Begunkov (5):
      io_uring: fix stuck fallback reqs
      io_uring: simplify task_work func
      io_uring: fix exiting io_req_task_work_add leaks
      io_uring: fix drain alloc fail return code
      io_uring: mitigate unlikely iopoll lag

 fs/io_uring.c | 191 +++++++++++++++++++++-------------------------------------
 1 file changed, 68 insertions(+), 123 deletions(-)

-- 
Jens Axboe


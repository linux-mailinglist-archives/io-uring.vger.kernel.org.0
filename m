Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128743D4874
	for <lists+io-uring@lfdr.de>; Sat, 24 Jul 2021 17:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhGXPMr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 24 Jul 2021 11:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhGXPMq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 24 Jul 2021 11:12:46 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972EBC061575
        for <io-uring@vger.kernel.org>; Sat, 24 Jul 2021 08:53:17 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id g23-20020a17090a5797b02901765d605e14so7927936pji.5
        for <io-uring@vger.kernel.org>; Sat, 24 Jul 2021 08:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=OFCeIutVSRUqeCi0YdmxrozpTf/UGBFpiQNJEBEM+JU=;
        b=ZCRUDNp+D5c7ylWwZAEt1XHns99ppaWZ/CDA+m/Xm/7LIQnSGq4nLRIqW4Vo+ZEpie
         Bj6JU2ASjX+uIuv6L/Db7zkRPpx9z/wUQ/lJj+iqkqpIxJkCrkmqZQFEla9TOSqIi1AH
         RHXTrHrhaWICAoTTyLFm5Brlv+DsDgX/yjwKz8AAl3C25dnWw6rkvMby+AXiy+JNm8tB
         WgbVueKA12vJCxUs2yzJBb+K8sYVL+JZYjJkQ0Io3n4BbNQtVdmNNRL7tnfxfLxLQ4Kl
         6LDg2o29G6NxOmc9xedlypeF1xLdc6mLNfiR5LrEnXd3PaQugUglC2YR1FkWaf0GZgCg
         LCwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=OFCeIutVSRUqeCi0YdmxrozpTf/UGBFpiQNJEBEM+JU=;
        b=IsfNH9IzjS0rbV1g5XduTM5m3+OYPrTvnXPCtKS2bwc/jGipC9S3G8QK0eXY8lMJlS
         9yvrLqintP7iV0VR2OMFlnSIPRTutoR8ttMRhtbaCzOeAU4s6JJrA0vjN6D6OnOy+oY+
         MNlv2Y2AGKSOv9vttjVxD34RxxacC1v+pIcVfUJZHocLHKT5dXs3aukrxXcMN0J01zak
         13KFCihskrh8/UGaejmf3z3hvazs+7dgWvcyyenmRdTImhqcM35Owoa+h4tDfTNG+N8M
         Wjg7Z0OhFhmotEx+PkuM/IA+yf9/cNKJiefIFPELVAf7AcGWOrWEZg8S0Ed0Lbu0AAZD
         Lljw==
X-Gm-Message-State: AOAM531Cg73JF+TsiKrYhpNWWANueQwfb/YApRyP3bxVT/YaxuYtW5dR
        6pLNlbui53EEkAQ46QEyxYkv/i6QGrALLtI0
X-Google-Smtp-Source: ABdhPJwk7cheFTgM7fHej+x79XekecLN2JvozUoMoIkF3N/bjrSAJ4IqlZFlaC61uZBh8KpCREoX9Q==
X-Received: by 2002:a65:615a:: with SMTP id o26mr10132933pgv.177.1627141996873;
        Sat, 24 Jul 2021 08:53:16 -0700 (PDT)
Received: from [192.168.1.187] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id 37sm24974623pgt.28.2021.07.24.08.53.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Jul 2021 08:53:16 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.14-rc3
Message-ID: <06134f44-1dc8-e5c3-4697-84401b9d7c8f@kernel.dk>
Date:   Sat, 24 Jul 2021 09:53:15 -0600
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

A few io_uring fixes that should go into 5.14-rc3:

- Fix a memory leak due to a race condition in io_init_wq_offload (Yang)

- Poll error handling fixes (Pavel)

- Fix early fdput() regression (me)

- Don't reissue iopoll requests off release path (me)

- Add a safety check for io-wq queue off wrong path (me)

Please pull!


The following changes since commit 1b48773f9fd09f311d1166ce1dd50652ebe05218:

  io_uring: fix io_drain_req() (2021-07-11 16:39:06 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.14-2021-07-24

for you to fetch changes up to 991468dcf198bb87f24da330676724a704912b47:

  io_uring: explicitly catch any illegal async queue attempt (2021-07-23 16:44:51 -0600)

----------------------------------------------------------------
io_uring-5.14-2021-07-24

----------------------------------------------------------------
Jens Axboe (3):
      io_uring: fix early fdput() of file
      io_uring: never attempt iopoll reissue from release path
      io_uring: explicitly catch any illegal async queue attempt

Pavel Begunkov (2):
      io_uring: explicitly count entries for poll reqs
      io_uring: remove double poll entry on arm failure

Yang Yingliang (1):
      io_uring: fix memleak in io_init_wq_offload()

 fs/io-wq.c    |  7 ++++++-
 fs/io_uring.c | 55 +++++++++++++++++++++++++++++++++++++++----------------
 2 files changed, 45 insertions(+), 17 deletions(-)

-- 
Jens Axboe


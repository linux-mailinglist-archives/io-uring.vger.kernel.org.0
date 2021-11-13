Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4404C44F435
	for <lists+io-uring@lfdr.de>; Sat, 13 Nov 2021 17:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235226AbhKMQvH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 13 Nov 2021 11:51:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbhKMQvF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 13 Nov 2021 11:51:05 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB937C061766
        for <io-uring@vger.kernel.org>; Sat, 13 Nov 2021 08:48:12 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id l19so12128874ilk.0
        for <io-uring@vger.kernel.org>; Sat, 13 Nov 2021 08:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=YMw+/xHSBXiW4uvrHmjjWa2ZQAXIFhC4l11l4bFQ3SE=;
        b=G7YW6rCX5hB4ZhOfIi6Wq2bD9/WPOCSo+SsZY6/VMerNsIS3oIYXPl/PjghKYwYHey
         mNHe4gsDLbsQoO243w4XEv7QhHaMmpJ3RktE9OcRPNmqQBbUt9COrr22soWbT/bxeHpR
         2G+DlIdgRACZRl2cfn6/tGaFNhMTIQbipfb4yPQWG81z5woOoIxQdRC5byEeVpbjDp2m
         B4fiZiuDbMM2CmOhV3FXF/465K2MJ+4gEgmz1qF5T9L2hPBPFkx2+WI0Ra2JSpJWv+eJ
         r3w9RHv5aOrDOf9i8AMXgLGyhK0dX21Hk0rnadHJbhQVhZlc8ZC5BYRbNzP4iacbFodf
         1gow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=YMw+/xHSBXiW4uvrHmjjWa2ZQAXIFhC4l11l4bFQ3SE=;
        b=p23EOzls9h+Pgwp7YuOD8fS6tm36fVhKTeVkbE/qTJsJ5QoaUR0piWbdSJiYtG03c3
         764UEvTo1tW9xpOHYOQq/S6OAps5xpjwc00M4ekwiIXXlnytL2lrvr82TpH8fJOW0Abx
         dAtFUugUN0dhyw0wUcGGG+L/L9uavD2//irsfP+8lXOrJ66slpARZLFg99T/TcN1RZ8I
         JX5JyU1NBTdlZ4pWJjRUBlCocrQaivvlh88vjzumADSvgt/0TdDPVZZa01WuiXOhFOg6
         OIAhdGCch1VKjKLaw6DPix+H28rNOygp32rrLsoWo2mERK0pA4JhLbpwLJZxcfryOL7s
         oXjQ==
X-Gm-Message-State: AOAM531Ue/utVBTOQPtmNaXFRBBnFFNkEpo8IPEtYYggyQe0tEKI9MwV
        kdrkgQhudB/jtKftOzBMua4+kdQkye+2QOKf
X-Google-Smtp-Source: ABdhPJzLfi79I2jY4QMZmKp4W+hKwl6yTEGN3BxTbn/vYfuH/mZYQ2QnTcqrfWNdzvvdcGFN/LIang==
X-Received: by 2002:a05:6e02:164e:: with SMTP id v14mr14130675ilu.144.1636822091820;
        Sat, 13 Nov 2021 08:48:11 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id w5sm6200625ilv.83.2021.11.13.08.48.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Nov 2021 08:48:11 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 5.16-rc1
Message-ID: <6b7088c9-fe17-1d29-44d9-6920050241b2@kernel.dk>
Date:   Sat, 13 Nov 2021 09:48:07 -0700
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

Just a single fix here for a buffered write hash stall, which is also
affecting stable. Please pull!


The following changes since commit bad119b9a00019054f0c9e2045f312ed63ace4f4:

  io_uring: honour zeroes as io-wq worker limits (2021-11-08 08:39:48 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.16-2021-11-13

for you to fetch changes up to d3e3c102d107bb84251455a298cf475f24bab995:

  io-wq: serialize hash clear with wakeup (2021-11-11 17:39:46 -0700)

----------------------------------------------------------------
io_uring-5.16-2021-11-13

----------------------------------------------------------------
Jens Axboe (1):
      io-wq: serialize hash clear with wakeup

 fs/io-wq.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

-- 
Jens Axboe


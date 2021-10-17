Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAAC9430949
	for <lists+io-uring@lfdr.de>; Sun, 17 Oct 2021 15:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242331AbhJQNTF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Oct 2021 09:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236593AbhJQNTF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Oct 2021 09:19:05 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B864AC061765
        for <io-uring@vger.kernel.org>; Sun, 17 Oct 2021 06:16:55 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id y67so13131924iof.10
        for <io-uring@vger.kernel.org>; Sun, 17 Oct 2021 06:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=pik7y/oyiqrq7HFKdqdITg2/Ef/03PIXAlSOSXwclU8=;
        b=hWESzmDnvYQPdCWv/oJ5W6tLdKG/vTnwI2O15yO1sSxkOAA+EQMmVSpJyz5shzhSOK
         P6VlRaHoqsJ9l01q8cX1jYSEzjKRKhgcnzDRVv0E5pNy027PufcbHhqqMY6iSVX3BpPf
         4VxWfx/1GtDWqjiUAay7NmEfb0of+ANj4SBNzh4zGs6F+3rpW1MyoQAeY7wGY8PjpSjg
         UGH4gOvRv0OYM8d1bZhSY7J1HSsVOH90EDwaievTY8lfxT2WbrbR59DtSDsMmz8YTT4g
         WnNAsQ8LsgR3v9Xsh4k+2+0r/5SVukUkLZJHsq+lGjTGkMZmugxTfKjMUyXu2Mf3tqj3
         2eHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=pik7y/oyiqrq7HFKdqdITg2/Ef/03PIXAlSOSXwclU8=;
        b=GK2YxG0uE/kQN44W0jAT8kX9bqDyARPR3mgPqcXxDZfmet9/XudZYqd7pnxD+RxC4c
         iRnHNqcZB3OUniLiZi2eGpbAXgxMn1cfsDW5fNufzDIrI8ALT5W3ebsfgyURsSQpg36y
         k8ibd6x2m7hf554APXMN/557GBZAKhDmej0BlWOFd/n6wHQBSBnZXtFt6nhDbqmubtzU
         jUkp0Nt6N/jKSbkEV3qu8kaBvtj5U+FMgjPTWiZVrgXMQ6LmvWvVjntYbsbRuLEKypQx
         52GbkttHWZrnLGTEebhLdw9u5Hhv/ZWMDUTGLlCf8O9SofLVWSDH9EY7QGJyckX9Blek
         47+g==
X-Gm-Message-State: AOAM532oKCjKMlx8l+Qiqi/K6tgkVhXvkyrcY/o5/x8e6e91djo3sn0x
        uvtdusKnQQuQT3VWSoq+m5UsOtAAVZ4gJw==
X-Google-Smtp-Source: ABdhPJycpvWgGAOvJIMYr8gD9/ysI8xydd/boYUkeEfqcntySOVM/WkGXdAH44iOwOrdvukz/F4/UA==
X-Received: by 2002:a02:a409:: with SMTP id c9mr15132448jal.39.1634476614997;
        Sun, 17 Oct 2021 06:16:54 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id y5sm5501071ilg.58.2021.10.17.06.16.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Oct 2021 06:16:54 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 5.15-rc6
Message-ID: <9d69d148-95be-c698-3394-f42cec90b49e@kernel.dk>
Date:   Sun, 17 Oct 2021 07:16:53 -0600
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

Just a single fix for a wrong condition for grabbing a lock, a
regression in this merge window. Please pull!


The following changes since commit 3f008385d46d3cea4a097d2615cd485f2184ba26:

  io_uring: kill fasync (2021-10-01 11:16:02 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.15-2021-10-17

for you to fetch changes up to 14cfbb7a7856f190035f8e53045bdbfa648fae41:

  io_uring: fix wrong condition to grab uring lock (2021-10-14 09:06:11 -0600)

----------------------------------------------------------------
io_uring-5.15-2021-10-17

----------------------------------------------------------------
Hao Xu (1):
      io_uring: fix wrong condition to grab uring lock

 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Jens Axboe


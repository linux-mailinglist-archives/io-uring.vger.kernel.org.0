Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726407463BC
	for <lists+io-uring@lfdr.de>; Mon,  3 Jul 2023 22:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbjGCUNR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Jul 2023 16:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbjGCUNQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Jul 2023 16:13:16 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14194E4E
        for <io-uring@vger.kernel.org>; Mon,  3 Jul 2023 13:13:02 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-656bc570a05so1009892b3a.0
        for <io-uring@vger.kernel.org>; Mon, 03 Jul 2023 13:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1688415181; x=1691007181;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xq8E1HhhX6LdA1bfwruCeiA9duIvdS1reZ9dGW2pxEg=;
        b=WQWHdEFLu1hWXHEhVvSzIokh4j0CpN60hP/K1JxNFMiqjxly3udnEE+SI+I6ONm1/C
         NO7x0wuF8W5IBaFkhX/2MZ8EPh3lAwnrSGCOGTBqf0v6aMHf9bswQ+tDDFt19oetnfsG
         QkWLHwha0v3TU0NSdqretgYeeBltAHzx/UP7t9svDiVLLLHTOM0gIJj7l/qtDODE/QsX
         3tqTSrmVdcK2kz8aTE1McZQtBfVyZ4fN5esj7wKwiFq9HdU9ZrN/RatB68eJiA6Yi2li
         9+Am0yfNsxAtm0JBqI9azqpE7zopdiCvdDTLJroIKS59YdY7A6xBpqIT27VIqW9osA6P
         +dOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688415181; x=1691007181;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xq8E1HhhX6LdA1bfwruCeiA9duIvdS1reZ9dGW2pxEg=;
        b=hEiQxM1kqutGLMAZP/gI5Rlj9ZXjPj9ihsLG5xguNqWD1UjMwF9ZU/kwBu2q7xpnrO
         vZvehAoRW8ty4ja2X0eX8DwxmUTK79BYL1PJmEEw1casY5k7FrMMfo84OhAWua9PUh4q
         vNZdhx5G7Lv2JVtB6yuHcwCdOI/qI3rB76C5SvN7HQrs+BKKjNiL79KCt4VorEReLJq3
         1zhg8k5AejZj7PnDiPhPcJu0X+rZ/GvCMSGYX5L80BQGXzjF9XYEuEWdQmViRj1bs+K/
         tTmFEcsOeecNNMMY+iEGKp1vsAKVNm2aioxegqU2FIY3qci4Docu8AEtfa9naHSkD4j0
         A85A==
X-Gm-Message-State: ABy/qLYejdmcqdIM2S33aYfWmOFQKyHoMbGt9G4wPHSdSCC/h7Me8Gat
        0ya3aHXMtQ9Wg8v/horSgfJemo7ysPl0aiJbMlM=
X-Google-Smtp-Source: APBJJlEjofaa1WLRwuqD91dtRjjbFfg23LobSHSwrfUAZz1J3qdabUwkZD/aVtawCgV3kRU7q3jjBQ==
X-Received: by 2002:a05:6a00:280a:b0:676:2a5c:7bc5 with SMTP id bl10-20020a056a00280a00b006762a5c7bc5mr12707729pfb.1.1688415181526;
        Mon, 03 Jul 2023 13:13:01 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j5-20020a62b605000000b00640f51801e6sm14352933pff.159.2023.07.03.13.13.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jul 2023 13:13:00 -0700 (PDT)
Message-ID: <f866804b-759f-b2b1-a47e-7183de80da7b@kernel.dk>
Date:   Mon, 3 Jul 2023 14:13:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.5-rc1
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

This pull request has a fix for the msghdr->msg_inq assigned value being
wrong, using -1 instead for the signed type. And then a fix for ensuring
when we're trying to run task_work on an exiting task, that we wait for
it. This is not really a correctness thing as the work is being
canceled, but it does help with ensuring file descriptors are closed
when the task has exited.

Please pull!


The following changes since commit 1ef6663a587ba3e57dc5065a477db1c64481eedd:

  Merge tag 'tag-chrome-platform-for-v6.5' of git://git.kernel.org/pub/scm/linux/kernel/git/chrome-platform/linux (2023-06-26 20:12:07 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.5-2023-07-03

for you to fetch changes up to dfbe5561ae9339516a3742a3fbd678609ad59fd0:

  io_uring: flush offloaded and delayed task_work on exit (2023-06-28 11:06:05 -0600)

----------------------------------------------------------------
io_uring-6.5-2023-07-03

----------------------------------------------------------------
Jens Axboe (3):
      io_uring/net: use proper value for msg_inq
      io_uring: remove io_fallback_tw() forward declaration
      io_uring: flush offloaded and delayed task_work on exit

 io_uring/io_uring.c | 49 ++++++++++++++++++++++++++++++++-----------------
 io_uring/net.c      |  8 ++++----
 2 files changed, 36 insertions(+), 21 deletions(-)

-- 
Jens Axboe


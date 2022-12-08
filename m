Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 430E164779E
	for <lists+io-uring@lfdr.de>; Thu,  8 Dec 2022 22:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiLHVBi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Dec 2022 16:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiLHVBh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Dec 2022 16:01:37 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D146148
        for <io-uring@vger.kernel.org>; Thu,  8 Dec 2022 13:01:32 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id i83so996319ioa.11
        for <io-uring@vger.kernel.org>; Thu, 08 Dec 2022 13:01:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YCC9TqYauZI8rQqUKCy57gN+qnO2BzvXECI5YxR/NNA=;
        b=urnWhEFyaX1FySkBWzm4eYQSPzRerVokg5HpwTNBCzmRy6FJ0HXHJ2rmjEpkvfj2eD
         JldSKj7bu98slq+ljVxdszEDGsBLvQNRa/byGsdKX7y2x6rCMifMnsKXbomuaXgM/e0H
         IUVb8wH59LIp8eehi+3kts2MCPiqu1eaxqQTUl/QfcAx3+Fgk/wPhZROBJvPcMUruVa3
         /zQxeKFRYZSz2ppqRgzL1wjsQW0Vi/CWrjldmsJE5ypUXVXSXHpppKrpey4QUY8zPSjm
         ErMUxdOT4BsHCRvy5W7x4pzES/TcCwzwpDMK4Pf0VfMHBzbksJcPkJaIgjMIvY/Y72gv
         icow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YCC9TqYauZI8rQqUKCy57gN+qnO2BzvXECI5YxR/NNA=;
        b=ohBdRnd3D7dDevtqC23rS0DEldJlVoVFU1TAfwiadbs0Wu3v1Jh9uG69R/DJV/hj9l
         ddBh0b21E6DV0aNi8KrGaowuBhmhBkGVzYemxn0+kG28VAEDpIL9hTC4mXAPGdWwA4Wc
         AqDk2hc8gb5x1n5yWtRRRiJ0pnfRH1/4kckU59lcRYq1GtJNUy1PbL7qKB9amBUNAFb/
         AH/Fvpy+rJD8GUPG16s1ItbeHVmJtgqT1YMg+Xtx6wUirAl/oo91/hWUOj+JO0kCElSx
         PdfutWJe8D0YFtr9uTrAmkYmFsMbfg4PM4EYW+qanYT6Z5GUQeVzOkWzuW7StlxkMAbs
         VGUw==
X-Gm-Message-State: ANoB5pmvh+h2I19BWsWiavik6CZu0IgoUsAQmPey5IKKV+1cYyPqildh
        51y4BvstKwg1a2xsye8BYdzwQw==
X-Google-Smtp-Source: AA0mqf5HbGSQhsQkZRYQm1AXyxlt0wbcS1wCrMxOqT+aIwnkCJZ7Jv4ykJ5tSYzBM/XW0wY9aXBpQw==
X-Received: by 2002:a05:6602:2143:b0:6bc:6352:9853 with SMTP id y3-20020a056602214300b006bc63529853mr41723402ioy.65.1670533291569;
        Thu, 08 Dec 2022 13:01:31 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w8-20020a0566022c0800b006de73a731dbsm9422937iov.51.2022.12.08.13.01.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 13:01:31 -0800 (PST)
Message-ID: <a1f469a9-5272-ffa6-892d-21014efb3312@kernel.dk>
Date:   Thu, 8 Dec 2022 14:01:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 6.1-final
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Just a single small fix for an issue related to ordering between
cancelation and current->io_uring teardown. Please pull!


The following changes since commit 7cfe7a09489c1cefee7181e07b5f2bcbaebd9f41:

  io_uring: clear TIF_NOTIFY_SIGNAL if set and task_work not available (2022-11-25 10:55:08 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.1-2022-12-08

for you to fetch changes up to 998b30c3948e4d0b1097e639918c5cff332acac5:

  io_uring: Fix a null-ptr-deref in io_tctx_exit_cb() (2022-12-07 06:45:20 -0700)

----------------------------------------------------------------
io_uring-6.1-2022-12-08

----------------------------------------------------------------
Harshit Mogalapalli (1):
      io_uring: Fix a null-ptr-deref in io_tctx_exit_cb()

 io_uring/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A05A6D23EB
	for <lists+io-uring@lfdr.de>; Fri, 31 Mar 2023 17:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbjCaP0G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Mar 2023 11:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbjCaP0F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Mar 2023 11:26:05 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41C91D871
        for <io-uring@vger.kernel.org>; Fri, 31 Mar 2023 08:26:03 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 98e67ed59e1d1-24044eb4064so44620a91.1
        for <io-uring@vger.kernel.org>; Fri, 31 Mar 2023 08:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1680276363;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pjwkyrCsUL3hzpM6/ls4IKTVUOgF0rZEiIZVIM/K+8A=;
        b=4Y16BB51w4O4TGHq/yM1qY90x7CgR6w7Dy0JKd4EBe7uy61iZHK9xXuETM7awVWwld
         dl5nqwKVeT61OnnIGLx1YXBXFE2OCyiITYZKsGU5/Rjnd+1B4M4bAZHg3hfy2i7eJ5mT
         qkzfEHq9CM6oXLlo7+8VLqKok8Ju583c/wXRHm3ToZxM+GaUgX8i4v6MiSXBMWdKfqaL
         3jtqehlA0GwBiehfT9oRU6amea78eSw0guCvpx/XwPKUmu1PxSyTw6jZ+tI48aodE2EY
         O2ES6D76qlboAmZ04XOxro7LVJTjwx1tCeaNHJM3AQQ+0E4IWBPD8igAHOAApHPI2pRa
         WuCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680276363;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pjwkyrCsUL3hzpM6/ls4IKTVUOgF0rZEiIZVIM/K+8A=;
        b=LivCeDpHm8SnfiG1lF4e8HBStwmDdXrDp5udfVFsqWOKZPaxZzAT84acWWzPEZl2ba
         6fOSt1e4M+acdoWauUrv5AmosXca9fPqYPxNkQ89uyHlRh5BXFd1XCh3DWIAmvO09gH8
         /QrkSfBCgsi1fS5ZEpTYpG8rxW76n1Oi4NspTYooBaZq/GzxsX+HkvDbQh4GZT7zWMVC
         +1VX6Sw5MDVJ8YB015/7L8r1ZNQUjAWEft04E+FRCxLwyjtwyZ7S4aQ7PIfXeXqfu5nT
         qKmj2r5LBWavWDRnuXfTx/boGOyGS0Ul7oFkN7b6Tpbh7IAphwqloP4OZn8psDnuZli/
         WmlA==
X-Gm-Message-State: AAQBX9fV6KV2zKMVdBRe1aGuj4w5iT4vo4lShTCU55LYXUmL+Gf3o8ph
        7OJwWTkrHLERiTxoaUJUDUo6ZUEyxKYLLm8waOLMWA==
X-Google-Smtp-Source: AKy350ZVaupUUfNMEXve9aGZYUDyJ+tWzIPC0MyFI2XUdPCRm+LPwAFr6DUPdolLxpEXSJFF7AWLpw==
X-Received: by 2002:a17:903:647:b0:19a:7217:32af with SMTP id kh7-20020a170903064700b0019a721732afmr6638667plb.5.1680276363171;
        Fri, 31 Mar 2023 08:26:03 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 4-20020a170902ee4400b001a240f053aasm1698147plo.180.2023.03.31.08.26.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 08:26:02 -0700 (PDT)
Message-ID: <64cfabee-4458-5ce1-4415-f392262f34ec@kernel.dk>
Date:   Fri, 31 Mar 2023 09:26:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.3-rc5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=3.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

A few minor fixes that should go into 6.3-rc5:

- Fix a regression with the poll retry, introduced in this merge window
  (me)

- Fix a regression with the alloc cache not decrementing the member
  count on removal. Also a regression from this merge window (Pavel)

- Fix race around rsrc node grabbing (Pavel)

Please pull!


The following changes since commit 02a4d923e4400a36d340ea12d8058f69ebf3a383:

  io_uring/rsrc: fix null-ptr-deref in io_file_bitmap_get() (2023-03-22 11:04:55 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.3-2023-03-30

for you to fetch changes up to fd30d1cdcc4ff405fc54765edf2e11b03f2ed4f3:

  io_uring: fix poll/netmsg alloc caches (2023-03-30 06:53:42 -0600)

----------------------------------------------------------------
io_uring-6.3-2023-03-30

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/poll: clear single/double poll flags on poll arming

Pavel Begunkov (2):
      io_uring/rsrc: fix rogue rsrc node grabbing
      io_uring: fix poll/netmsg alloc caches

 io_uring/alloc_cache.h |  1 +
 io_uring/poll.c        |  1 +
 io_uring/rsrc.h        | 12 +++++-------
 3 files changed, 7 insertions(+), 7 deletions(-)

-- 
Jens Axboe


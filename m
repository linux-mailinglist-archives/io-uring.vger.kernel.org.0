Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F50B630043
	for <lists+io-uring@lfdr.de>; Fri, 18 Nov 2022 23:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiKRWnc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Nov 2022 17:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiKRWna (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Nov 2022 17:43:30 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44630CF4
        for <io-uring@vger.kernel.org>; Fri, 18 Nov 2022 14:43:26 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id 130so6189269pfu.8
        for <io-uring@vger.kernel.org>; Fri, 18 Nov 2022 14:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KSrDX46nB02h+DblJi10xI5/0KMa3qB7ljPfbZFIoc8=;
        b=WAMg2jKpsx8TpLqrZHAHFTP8GPRCwJWjh/B/TXZYNlpvGEN/Z3iig3aYkF4PASakHm
         eAryfjWqsIPE9lISYKoa7Z6+U2uaIlaF1ID6obOWSmgdmULkbk9dFCvziVyt7QZYwK6V
         YdPh/5PX0difNv2tmxg9ZYSmbQbQy2feqzi0/ksIlLuQ8BzvtQ1PZ0QNtN1cdt8suoMt
         0DSim5BN9ZvXtW2y9f+Gf73dSSFKYWTwBmzR4/Zc5Xh4QKnSBZsteN3Unu0+LoZgXvZ3
         ULhO8xQxQk08qYRUjr1pfmbkvEubKLIRmXJeJUMCXRtiPsMNdlTp7Rj4eGglrE6e8APW
         4Fiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KSrDX46nB02h+DblJi10xI5/0KMa3qB7ljPfbZFIoc8=;
        b=BIxzYVyN8O5z7LGcR7WrC5P35R4CBYyfS5hlTycECyyuuLDcVT6F29fvMao7jFK5cG
         Ds5FSxzuKiKzQ3vBFPGPn8CUcWjOp3RuvDxUTcKPG+0GFsIKYqYoOp7lYi0qtuYjN5Ow
         0VzYySn6ANbDL1PKn5AtXJZIW2zgTxkdVR/9pSlwEFq9wyp7qg7lfa+TkXlc6gxcwriD
         tRP/ur4pmpt2Wxax6LMtQ+mz7kFvlDY/yjRmorI2L+WrvNgB8AI2l/xTgxsYCqHNPbii
         5Zui9BrwbfbTQ8iDvVm6+v9os2nZZ7AtQ0uV70j14fHjxPM+4G4KnB0BzhGCx+V+SdaM
         Ow+g==
X-Gm-Message-State: ANoB5pkZjKayxf821KlJbK2Fh3pFt0kVlugUaXiNh7MyjfYnNbop59JB
        VIJquyF+vE+/IeMipOWbK4xK6TFK6NOulA==
X-Google-Smtp-Source: AA0mqf65XLO72ccsInKXcypRJ0C9IjRdKsHGdEU+rNm8WCoLf9GoyIXDdPtqANQSbLrrSMmogsT5fw==
X-Received: by 2002:a05:6a00:1145:b0:562:7bed:9676 with SMTP id b5-20020a056a00114500b005627bed9676mr9981608pfm.13.1668811405591;
        Fri, 18 Nov 2022 14:43:25 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f18-20020a170902ce9200b00176ea6ce0efsm4292197plg.109.2022.11.18.14.43.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 14:43:25 -0800 (PST)
Message-ID: <8858bc05-6020-09e9-d17a-28655c738c78@kernel.dk>
Date:   Fri, 18 Nov 2022 15:43:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.1-rc6
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Fixes for io_uring that should go into the 6.1 kernel release. This is
mostly fixing issues around the poll rework, but also two tweaks for the
multishot handling for accept and receive. All stable material.

Please pull!


The following changes since commit 5576035f15dfcc6cb1cec236db40c2c0733b0ba4:

  io_uring/poll: lockdep annote io_poll_req_insert_locked (2022-11-11 09:59:27 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.1-2022-11-18

for you to fetch changes up to 7fdbc5f014c3f71bc44673a2d6c5bb2d12d45f25:

  io_uring: disallow self-propelled ring polling (2022-11-18 09:29:31 -0700)

----------------------------------------------------------------
io_uring-6.1-2022-11-18

----------------------------------------------------------------
Pavel Begunkov (5):
      io_uring: update res mask in io_poll_check_events
      io_uring: fix tw losing poll events
      io_uring: fix multishot accept request leaks
      io_uring: fix multishot recv request leaks
      io_uring: disallow self-propelled ring polling

 include/linux/io_uring.h |  3 +++
 io_uring/io_uring.c      |  2 +-
 io_uring/io_uring.h      |  4 ++--
 io_uring/net.c           | 23 +++++++++--------------
 io_uring/poll.c          | 12 ++++++++++++
 5 files changed, 27 insertions(+), 17 deletions(-)

-- 
Jens Axboe

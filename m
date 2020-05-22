Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A3A1DEDEE
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2020 19:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730706AbgEVRMK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 May 2020 13:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbgEVRMJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 May 2020 13:12:09 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56B0C061A0E
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 10:12:09 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id t7so4639844plr.0
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 10:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=au66aCmkNZdUso8VD+hhjc+/Z5cTkw3y2pbuXSRv11U=;
        b=iFrJXYQkikhGJHkcdcYaoQqyBhxWgMBCrf2TBz/ZnecY7uADnvEchQj6zvOQd6E+qh
         VW20ErnATyJu64r3YcuREf7cqp+uWHalZx6NAP9RJaEx/aShAbMnt9251ogcaIS1ux1H
         cf4q0knpekBwwBEyu/+VQTHtnhP3pVNnLKl57kNGYcOXDeMyfB/pm8lKvSOQj3YsVM/i
         Cos0pb7GRiCRSxpCqpDf/dVxMwih1JGT2qJG8uwEvNpbizDqEzgxP/LKwmWi6ZuXfYKz
         JU7vwuDFjMNekDRelms4m1quBx8zGk7lwuSITLv+00djRXZ93QgRCnW8PmShue+QIenQ
         7QRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=au66aCmkNZdUso8VD+hhjc+/Z5cTkw3y2pbuXSRv11U=;
        b=ORHo8f03F4TQyNtZsTUUmMiXYvCJCSZi8dEGHaxNO6x09a3XnEzgNDOhF8vXhWS4/x
         m2sR7RpOyhWXMhJeVVA3Clwv1iOJe2CtpwHPOhNCJqA1+af5QhM6ZhgJk94D3WyHv0Y+
         z2BylxcxSFYYR03bpoeYxHgUmVITcKKRKkeFKhLhyV0qQOlUx8W+ayXcURNPFD+2buKu
         +6iQ2ff/eNxs4Ud5wUcWbfizVhldlcWC6BJXL8MZLys/4XM0sAGg+KJ0guDKLnZGaWWj
         6ujJjm94V/8dKOnz9efELQEUiSaBFK81yR9Jy2j2fd3YcIEj7xbEhVL8x42T97PkHmmD
         qJKg==
X-Gm-Message-State: AOAM533QHCwcPI2c4xPc4asQ1/RZXt/V9Nq9KzQV0BE4WLl5dfX0LA0Z
        cEfvCwQSDoUDYpkD5RHswAiU9g==
X-Google-Smtp-Source: ABdhPJyX2F3dnRNFNe70jHpyTkPIiKBj16QeddfybWWJdivDgnh9B0wMZSH6jx8LzvhRk2i1Q951DA==
X-Received: by 2002:a17:90a:26b0:: with SMTP id m45mr5618036pje.234.1590167529063;
        Fri, 22 May 2020 10:12:09 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:892a:d4e5:be12:19f? ([2605:e000:100e:8c61:892a:d4e5:be12:19f])
        by smtp.gmail.com with ESMTPSA id k65sm7325165pfd.156.2020.05.22.10.12.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2020 10:12:08 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.7-rc
Message-ID: <89dab0b5-a43d-fd21-e22d-8d5d4c2ae510@kernel.dk>
Date:   Fri, 22 May 2020 11:12:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

A small collection of small fixes that should go into this release:

- Two fixes for async request preparation (Pavel)

- Busy clear fix for SQPOLL (Xiaoguang)

- Don't use kiocb->private for O_DIRECT buf index, some file systems use
  it (Bijan)

- Kill dead check in io_splice()

- Ensure sqo_wait is initialized early

- Cancel task_work if we fail adding to original process

- Only add (IO)pollable requests to iopoll list, fixing a regression in
  this merge window.

Please pull!


  git://git.kernel.dk/linux-block.git tags/io_uring-5.7-2020-05-22


----------------------------------------------------------------
Bijan Mottahedeh (1):
      io_uring: don't use kiocb.private to store buf_index

Jens Axboe (4):
      io_uring: initialize ctx->sqo_wait earlier
      io_uring: remove dead check in io_splice()
      io_uring: cancel work if task_work_add() fails
      io_uring: don't add non-IO requests to iopoll pending list

Pavel Begunkov (2):
      io_uring: don't prepare DRAIN reqs twice
      io_uring: fix FORCE_ASYNC req preparation

Xiaoguang Wang (1):
      io_uring: reset -EBUSY error when io sq thread is waken up

 fs/io_uring.c | 60 +++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 34 insertions(+), 26 deletions(-)

-- 
Jens Axboe


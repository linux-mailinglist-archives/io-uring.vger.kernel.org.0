Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFE61AE0DD
	for <lists+io-uring@lfdr.de>; Fri, 17 Apr 2020 17:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgDQPQp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Apr 2020 11:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728272AbgDQPQm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Apr 2020 11:16:42 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191E1C061A0C
        for <io-uring@vger.kernel.org>; Fri, 17 Apr 2020 08:16:42 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id d24so1065291pll.8
        for <io-uring@vger.kernel.org>; Fri, 17 Apr 2020 08:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=YXR192pJ0exfYgl5biCYmiq8w0qm6d+pqJxZoijZXpM=;
        b=WETNw5cjPKEZXdPr4UHoLTfslN5t+iZ3Lz4PInGXGGIn0Rq4Acr8uQ5HigeEMhJ2fO
         mgbRUONJMqlCM0fEKUu5DQgokOZVPlfxZFvZ1cA4SsAYFxyQ5B8ovjpz+zcCFn4ygZeS
         3NBv/N+NIgt3jpUwFE7REfsOvZIDLS2yt3S6VmFGFrB+5ScAU7py0F64usy65mYrB6qY
         RT1cgbB/EdVBaiKxxCln6Ax052S1xRURHWkDUy0PF59h/LILN9IT46sb/psv9N4rh+GZ
         ulRnqsyz8b+jwyeqSPdRocao6Uy0al72x9f98632KSYV8NJifn3+qqu3NeqcqKFwGPKM
         E7IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=YXR192pJ0exfYgl5biCYmiq8w0qm6d+pqJxZoijZXpM=;
        b=B3Bek6AqygpAgiFVgpqmvcj/JRcDaVZn/D/qvlM0o3A4QTZ9kdOdc9aOZRYmWbGtYO
         0li2tYXw0CI7SrqVKrq0HyLFNhGns15tGdvuJ1F4dTp93e0YFEoqNohL7ljZX0+ll5DT
         5cDhqiaJua7djbGFR09e4Wq6J/j0NyiUqeXtsepYFyrG569zX7cNr+6M3G+4IONuVjc9
         BU6f7wwy1TWxGxdtvD7K5sJXxUR4eJD1J4OPBSzXuA7q2VaYRuyYs0L9PjWFoKPb7e10
         m7+JKX3d8zhqADxUSayWsaC6VyJ/TzdPEHcsWAPeQEnm00GeHJTKy+bXLbN5eRe2Q0Mn
         aH2w==
X-Gm-Message-State: AGi0PubO8lkuKjVF0jkjwiBAimFtrUbTMREZ357nyZBOPmHIEXfIhKcx
        jwg5GbdOTW+wV7hjkAGcVxNxUaoRKr+PZw==
X-Google-Smtp-Source: APiQypIYts3zNYQ2qzCLlhtBdzBnl1UQdUdvk2IzdQmqGvmKKz/8pfPFk+wflUPTHjShsmnV/NqJwQ==
X-Received: by 2002:a17:90a:af8c:: with SMTP id w12mr4948192pjq.37.1587136600941;
        Fri, 17 Apr 2020 08:16:40 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id y26sm14710926pfq.107.2020.04.17.08.16.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2020 08:16:39 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.7-rc
Message-ID: <2750fd4f-8edc-18c2-1991-c1dc794a431f@kernel.dk>
Date:   Fri, 17 Apr 2020 09:16:38 -0600
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

- Series from Pavel, wrapping up the init/setup cleanup.

- Series from Pavel fixing some issues around deferral sequences

- Fix for splice punt check using the wrong struct file member

- Apply poll re-arm logic for pollable retry too

- Pollable retry should honor cancelation

- Fix for setup time error handling syzbot reported crash

- Work restore poll cancelation fix


  git://git.kernel.dk/linux-block.git tags/io_uring-5.7-2020-04-17


----------------------------------------------------------------
Jens Axboe (4):
      io_uring: correct O_NONBLOCK check for splice punt
      io_uring: check for need to re-wait in polled async handling
      io_uring: io_async_task_func() should check and honor cancelation
      io_uring: only post events in io_poll_remove_all() if we completed some

Pavel Begunkov (8):
      io_uring: remove obsolete @mm_fault
      io_uring: track mm through current->mm
      io_uring: early submission req fail code
      io_uring: keep all sqe->flags in req->flags
      io_uring: move all request init code in one place
      io_uring: fix cached_sq_head in io_timeout()
      io_uring: kill already cached timeout.seq_offset
      io_uring: don't count rqs failed after current one

Xiaoguang Wang (1):
      io_uring: restore req->work when canceling poll request

 fs/io_uring.c | 301 +++++++++++++++++++++++++++++++---------------------------
 1 file changed, 162 insertions(+), 139 deletions(-)

-- 
Jens Axboe


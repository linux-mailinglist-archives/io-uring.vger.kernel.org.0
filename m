Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5825F16909D
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2020 18:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgBVRFd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 22 Feb 2020 12:05:33 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43790 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgBVRFd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 22 Feb 2020 12:05:33 -0500
Received: by mail-pl1-f195.google.com with SMTP id p11so2198732plq.10
        for <io-uring@vger.kernel.org>; Sat, 22 Feb 2020 09:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Ar43/pIEDTuzXkqZAaJR3YM1BZfZyVYtyTj0Sx88Fts=;
        b=Ro51XH06xPU2FxAhIjNX5OSNDvjJkYl9w9QUX4+23kDBCaGRB2hd3uxOay0J5dfcaX
         4JBzuFgRWGnO0Of8H7FYnllj4jj3s14+f/vQ7L+nf5vh70/6EJ3QKrz9ir+H8K1D7MMn
         S3vLxRNvsTXuCOZdF4/lCFIcLxLdWrdx0khle71GBGuTKIuBtnqUsYwwMVM4C4/u9MHi
         FgXJ01bzGAXgUixp+fNoK51Fg0XzXtqbAHwVA2izAovyf5q785LmWBNQ2F3jiZSU0ZJZ
         5GSihRmZAY5hix+RxNZiHTfkCJgLX22TQwsuooIrgJxKbiEOlZv6KFZp5JdqF0i9tgOY
         a+eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Ar43/pIEDTuzXkqZAaJR3YM1BZfZyVYtyTj0Sx88Fts=;
        b=SoE+2xFcDl9kjvZ/U8Iv5H+zhbFlUHm0YajaZ8uut+1B8faatqI0v78WQVK2fvY4ul
         9bwXoSSbmsRXKgBTYZpgL1CtFn6SZF7rTiRQte3CRlnWMqY776OVLGILOhXUQY4L7GSx
         9zHMwEDj85wZaCSN3p0SM+36N/TJA3V7UrnTMO+OdD2wG3g7osk2oEaf9Io4C8FT7MlP
         +DuNGb5l+see8v/gaemOO5Usl0KYRRoO4Y27YSUGJRPvVqdyoaMwtExHOM/2KCot+ltz
         1fnfoArt9ftlD6zrF7qKlUFKlAxMdxhtjA0Q+dSmrywEQVaJ6mTrLz1rtnQUqccZiBJ0
         lGVQ==
X-Gm-Message-State: APjAAAXkalSkQecZKRZ3c1SmCH2ee1x/dZRmtLc4qPUzT7JDyxTewMxT
        6QcmnUWF+Ag4QfeWkLM5mNmLdOdZAow=
X-Google-Smtp-Source: APXvYqy4MdZ9sr7ap6ZA6+hwn3NQQbOGOOi/z1blhPzoD8hhWy8LO5RhzOkrYC3+nJWQWCqFh4JzMw==
X-Received: by 2002:a17:90a:8001:: with SMTP id b1mr10064966pjn.39.1582391132757;
        Sat, 22 Feb 2020 09:05:32 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:a99e:da38:67d8:36ae? ([2605:e000:100e:8c61:a99e:da38:67d8:36ae])
        by smtp.gmail.com with ESMTPSA id c15sm6786491pfo.137.2020.02.22.09.05.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Feb 2020 09:05:32 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.6-rc3
Message-ID: <fdbadf53-2421-d0a7-8883-059c34608cd0@kernel.dk>
Date:   Sat, 22 Feb 2020 09:05:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Been mostly away this week, but here's a small collection of fixes that
were queued up for -rc3. This pull request contains:

- Remove unnecessary NULL check (Dan)

- Missing io_req_cancelled() call in fallocate (Pavel)

- Put the cleanup check for aux data in the right spot (Pavel)

- Two fixes for SQPOLL (Stefano, Xiaoguang)

Please pull!


  git://git.kernel.dk/linux-block.git tags/io_uring-5.6-2020-02-22


----------------------------------------------------------------
Dan Carpenter (1):
      io_uring: remove unnecessary NULL checks

Pavel Begunkov (2):
      io_uring: add missing io_req_cancelled()
      io_uring: fix use-after-free by io_cleanup_req()

Stefano Garzarella (1):
      io_uring: prevent sq_thread from spinning when it should stop

Xiaoguang Wang (1):
      io_uring: fix __io_iopoll_check deadlock in io_sq_thread

 fs/io_uring.c | 65 +++++++++++++++++++++++++++--------------------------------
 1 file changed, 30 insertions(+), 35 deletions(-)

-- 
Jens Axboe


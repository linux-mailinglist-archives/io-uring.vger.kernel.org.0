Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84E4A173FCE
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2020 19:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbgB1Smr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 13:42:47 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:36385 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgB1Smq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 13:42:46 -0500
Received: by mail-il1-f194.google.com with SMTP id b15so3598990iln.3
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2020 10:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=VCbaNY4wBYVaCiMegreK3IyuJnq8p/jIOFknVGfbhLc=;
        b=IACH2A5rT5y+8kIpFNw5as0ou+ITV+tKeAc3h+7qwsaKmpUfpjdpVI+4wPdHBiN20q
         kqMSDa7CJ2dUesZlZOUo9uFYz6+v73GCWYrh90Rqd0whM+V85npOFdTYySvyTtGjeiRm
         +1YjJGfnNK3jK0jRBpYbxwCXQScmOM46/P9lZcjgQpYvTjzdKMcBh0FSpL4CnTwFsCXk
         6WdlrtXDG0NzREDUppHL9nxPYJNM4brMbKF59oYz8B5vxDnuhjh8mtF5QkWguJK8x15k
         /r4uBRIb/eD3us7ddsswEugJyfu0MDPW4ZBY0ishIh3G8Nf0J80Ea2eGneaqOa63x2ow
         DB3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=VCbaNY4wBYVaCiMegreK3IyuJnq8p/jIOFknVGfbhLc=;
        b=AS0b946YRBsMdR3SoCSKRNRkqVyhVjFKlDqZ88gIUP/EQKNHfOZY3JFlQYhlJPC6ol
         YInyN66A+z6J+x+HYzTlkwDdoL0yfUmVzwpDf/AEmntIx8dNO92oV3HSDf7UGHE8xJGx
         4R1Kp88ukgAbSpnMMIgoPg9poJkL2TO/zdUxMM6bh5EEwx2uA7FvO1xu1MS+aDs0qFLY
         I0Tni2thksAMEjBr6A4BynzCfpL4pEaURWFekWWgBb5oS/AYfOUquom0IhKj7u/YKYU+
         szejLjmc7M4zsVWe+Tll8b+fFxV1iWorUUtlsFxwwyymGZX1yChTOiDRzhIha6cr0wV3
         7I5A==
X-Gm-Message-State: APjAAAX5SA1PKdW5fx8DFD/kR+0xsmT97MWJHNioPevKr/Q1O+Mol/be
        rwJ9/9UVvBoa83n/CSxS7106yX3oEx8=
X-Google-Smtp-Source: APXvYqxd+kzpCQ9k7q5es4g3sHk7SVLKRk6gOXzbRYOn5D3lcn7MCel9o98wkFhvi9+VnOTPE5dJxw==
X-Received: by 2002:a92:50a:: with SMTP id q10mr5913018ile.294.1582915366218;
        Fri, 28 Feb 2020 10:42:46 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t15sm3314670ili.50.2020.02.28.10.42.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 10:42:45 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.6-rc
Message-ID: <d91f851a-97e6-cb5f-23f6-3de0ce93e4dc@kernel.dk>
Date:   Fri, 28 Feb 2020 11:42:44 -0700
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

Set of fixes for io_uring that should go into this release. This pull
request contains:

- Fix for a race with IOPOLL used with SQPOLL (Xiaoguang)

- Only show ->fdinfo if procfs is enabled (Tobias)

- Fix for a chain with multiple personalities in the SQEs

- Fix for a missing free of personality idr on exit

- Removal of the spin-for-work optimization

- Fix for next work lookup on request completion

- Fix for non-vec read/write result progation in case of links

- Fix for a fileset references on switch

- Fix for a recvmsg/sendmsg 32-bit compatability mode

Please pull!


  git://git.kernel.dk/linux-block.git tags/io_uring-5.6-2020-02-28


----------------------------------------------------------------
Jens Axboe (8):
      io_uring: handle multiple personalities in link chains
      io_uring: fix personality idr leak
      io-wq: remove spin-for-work optimization
      io-wq: ensure work->task_pid is cleared on init
      io_uring: pick up link work on submit reference drop
      io_uring: import_single_range() returns 0/-ERROR
      io_uring: drop file set ref put/get on switch
      io_uring: fix 32-bit compatability with sendmsg/recvmsg

Tobias Klauser (1):
      io_uring: define and set show_fdinfo only if procfs is enabled

Xiaoguang Wang (1):
      io_uring: fix poll_list race for SETUP_IOPOLL|SETUP_SQPOLL

 fs/io-wq.c    |  19 ---------
 fs/io-wq.h    |  14 ++-----
 fs/io_uring.c | 132 +++++++++++++++++++++++++++++++---------------------------
 3 files changed, 74 insertions(+), 91 deletions(-)

-- 
Jens Axboe


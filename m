Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAE00149CAC
	for <lists+io-uring@lfdr.de>; Sun, 26 Jan 2020 21:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgAZUCU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 26 Jan 2020 15:02:20 -0500
Received: from mail-pf1-f177.google.com ([209.85.210.177]:43559 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgAZUCU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 26 Jan 2020 15:02:20 -0500
Received: by mail-pf1-f177.google.com with SMTP id s1so3289744pfh.10
        for <io-uring@vger.kernel.org>; Sun, 26 Jan 2020 12:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=hAj2qkKHbDn4W5gqS8ibjJvnqiiOc0xEaLINRRkxATg=;
        b=Nu1YG3iqUH0dAt8AsWKqFlWxEyW/kqj3FhH3vwJMBAUQyygJG/Txs4TmdYCVZZBGy4
         qkBfLPim/Rxa5XcUn9+3fmirDTRaG6nknZzNiTY138AISAx4iL4G3hapcLSIQY2P7AJ7
         ijHsB/8BaOwmnY8Qm5DQw0UEA7Rx5lTl35kfiKgQrlhj+aXzVnvR+hQR2twiWNDLdqEl
         Ih1ZQUdeE6vAMzl9lY4c6TNrc7ZKZTnf9fXrfslGuwrDlP1zkyM+Xp1PuB9imtGoIWIN
         LZIcz5Dn2HIar9j0YeXvledJ+n5pOVHq2vTPhZ5hEem8PufW2qlNchWVTpOT8Z/sP1+f
         i9gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=hAj2qkKHbDn4W5gqS8ibjJvnqiiOc0xEaLINRRkxATg=;
        b=THZBokNAEx/aJAVPBtuehG3Ajv04xu/03y4J1b581QKc641OG5aH6hzy5YCNzrQxl1
         7VGdlOVyrjrsNHOhY/zmKCwSDhFNLddnQloBNY0k75OcwBvhOrhMcIhiaVF6FXr5p6iO
         +bHYdfSuFNJFtsOs1i3WbJgW1Np2tm2sIe0kLMtlVsUJmeL5R1Ew1wPqodfbx16EjIE8
         MuGpaERGlkPKqAxpvGU3CFJL9e5NQvg7Y5bKQm61jiqiycp6V3F/EY3A3vYXb7zJ7gcV
         4ZfNRCxSs+rZth1DM/gkLWXc4n3NlNRovcZrRzRPpXDOEAB052xp5QYD7PuqyQv/Vv9K
         mSdQ==
X-Gm-Message-State: APjAAAX+kPILmEJDIGusCv9Iw7XB56TDUnnGNNcr0G+I2zAzKFJ0mpXy
        z8WCWN8pyR9FS1lVmzwt2JrK8xWYEaQ=
X-Google-Smtp-Source: APXvYqx80UScOhO1FzTCUp1Pb5pqJs7Ahum36LsqCG3g8dSsw7q4jwqzn23HXVSueO6SagG1FxSLhg==
X-Received: by 2002:a62:83c5:: with SMTP id h188mr13177144pfe.0.1580068939147;
        Sun, 26 Jan 2020 12:02:19 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id p5sm13861976pga.69.2020.01.26.12.02.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2020 12:02:18 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.5-final
Message-ID: <97fc142a-5f87-57f5-67fd-a146996a7ff1@kernel.dk>
Date:   Sun, 26 Jan 2020 13:02:16 -0700
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

Fix for two regressions in this cycle, both reported by the postgresql
use case. One removes the added restriction on who can submit IO, making
it possible for rings shared across forks to do so. The other fixes an
issue for the same kind of use case, where one exiting process would
cancel all IO.

Please pull!


  git://git.kernel.dk/linux-block.git tags/io_uring-5.5-2020-01-26


----------------------------------------------------------------
Jens Axboe (2):
      Revert "io_uring: only allow submit from owning task"
      io_uring: don't cancel all work on process exit

 fs/io_uring.c | 10 ----------
 1 file changed, 10 deletions(-)

-- 
Jens Axboe


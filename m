Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1248D2CFF55
	for <lists+io-uring@lfdr.de>; Sat,  5 Dec 2020 22:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725270AbgLEVnW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Dec 2020 16:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgLEVnW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Dec 2020 16:43:22 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A27C0613CF
        for <io-uring@vger.kernel.org>; Sat,  5 Dec 2020 13:42:42 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id t7so6326237pfh.7
        for <io-uring@vger.kernel.org>; Sat, 05 Dec 2020 13:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=8hD72W6/niki8BLg6kIRriVcv3S5fB4wBGM6Drucy/4=;
        b=Q4ofta/3hNIjLXdl/vT8SQfLt3TSI07K+lh47dLY9pOALs/0q2cn11gf35dZlxEnKS
         DUMgIwAcAP8m8/2YXRlTNIZ1z1tBpq9VVQgXiXh4Kp8Oki5LYciVsQILgJMtxQUc8+GE
         1hBdDhq1RqHf0+EFFMXuHM/7QCWxK3zSby+1l2e2ZmrIJ1gNsnA1tDbx4PIeQiB0f1wV
         n2BuJcpqt1DIxEUcPc2KcNm13E8mbbmOTXL7SjFkAFv1cHU03rZ7hJPxK6Tr47PfNQuk
         DCX91z0udxg0kM8z7CwEBTBLtuwk51CoEhdL2AB2r1oZO2sgTAmUx/ugLxg/yp7Aqjws
         mXqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=8hD72W6/niki8BLg6kIRriVcv3S5fB4wBGM6Drucy/4=;
        b=JlS7sv6qugTaMBNo7EF0fBlKlOQaonh81joaArIFiV7zSZLwzsbMNWnqEzYtj1nEpl
         XbHY7pk9KuKgq11M46bmV3hQgcJSgEQomuv7cczRNRyfgLWLZdGTGMZAbMogxWkw5God
         E38LP9NrT6gq4/rcC5p9uCSIdlIzMQkY2IJiS7ghjqHbdms4MLQnn1J1fqAkJjt03Z0Y
         yToPVfFlln7jemQPuNlZAmoEih9CZ9XX7oidlwClUAar+qjMCmyCajw8m8riMHjn4rv8
         JF2sl0nWZd0Q9s10vHeB0+LNjeFlqc8StNH1SyXQbSqlsrcHPPGguMLJ4QiIYnZkDMtU
         auzQ==
X-Gm-Message-State: AOAM533fskoDOXG9UXbNXcA62mj2YxDCWKNbNy7LWynkGvFQyaaDuD70
        vSWM10y2x7MKP+7vlhMYtih3EHvCPOvFdw==
X-Google-Smtp-Source: ABdhPJxyLLTsnqX/HyIAAWzFfpsFJu5zhxyCYpLCXqBgXsTP1CagtHTRr6R3sJkCsERZpQC0W6G48A==
X-Received: by 2002:a62:aa06:0:b029:19d:f4d3:335e with SMTP id e6-20020a62aa060000b029019df4d3335emr314380pff.60.1607204561437;
        Sat, 05 Dec 2020 13:42:41 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id k189sm10473341pfd.99.2020.12.05.13.42.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Dec 2020 13:42:40 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 5.10-rc
Message-ID: <80f174fa-70b6-827e-17b9-e120cb65ec34@kernel.dk>
Date:   Sat, 5 Dec 2020 14:42:42 -0700
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

Just a small fix this time, for an issue with 32-bit compat apps and
buffer selection with recvmsg.

Please pull.


The following changes since commit af60470347de6ac2b9f0cc3703975a543a3de075:

  io_uring: fix files grab/cancel race (2020-11-26 08:50:21 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-12-05

for you to fetch changes up to 2d280bc8930ba9ed1705cfd548c6c8924949eaf1:

  io_uring: fix recvmsg setup with compat buf-select (2020-11-30 11:12:03 -0700)

----------------------------------------------------------------
io_uring-5.10-2020-12-05

----------------------------------------------------------------
Pavel Begunkov (1):
      io_uring: fix recvmsg setup with compat buf-select

 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
Jens Axboe


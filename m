Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B4B2D840F
	for <lists+io-uring@lfdr.de>; Sat, 12 Dec 2020 03:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407003AbgLLC5f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Dec 2020 21:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728474AbgLLC53 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Dec 2020 21:57:29 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BCBDC0613CF
        for <io-uring@vger.kernel.org>; Fri, 11 Dec 2020 18:56:49 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id f14so3170157pju.4
        for <io-uring@vger.kernel.org>; Fri, 11 Dec 2020 18:56:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=jFVvAXefyN820h6eVrJGt2ocUYtQ6/awONBUJZq1gUo=;
        b=aur4V1pblNA3W+wCQlXO0oEClDFyUfLU7XrtvTwgTufIaYuHwcyK08OR5cFuiJdrAO
         cgn9lyKjLcByHZvu0CuSiuMYrmU5aKOh5fFArw6nIDZ2X+FZGFWykEntuZDXQedSq7QX
         zpTKpYkeEr0sk2J00Myq2t/L1NSN2O7vFqZOsFmgPNykSqX8Sx01nv7QrjA724uMyhxb
         VsxY28RFoqDDxIaMT9h/qP5K3Gj5P3M9sQKnZwSgFQKLynAoEQkPS9bvHjfQX3vr8e46
         w6a257AsF4te1RlqRnWnOSW65mJO1NrNiANCBamLe/vGo64u4Bg+eoOP541MugPUcoLM
         7uJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=jFVvAXefyN820h6eVrJGt2ocUYtQ6/awONBUJZq1gUo=;
        b=VsmjTAYwNqsQszbSz+ziRsuOAKi/KEf7tI5FEv0iIojYCIxGe1a5jx/+TjtDgbVXmN
         FcYG3LyGveDOHS6PPkJHbjMXJLHy8y619p+NENVdwIOr4+HXj3bUwfSU+UWEBrGAtE2Z
         NJu/vXKICC9Yj0+pWkXxKuLC9Ll4ptZoaOCrlTMMqIObL8EG8ZoNW8HJreZHmrp4UYDk
         ZzY8hTgLqrurxtcCfGbOE0Wh4yk2NHlBjGb/M7fvmN73licv+a9Y9N/QhIr0nvB5Jc4w
         dmzxjbQ2xAHNM3G10qlmT1vqBkkW14Wt4uavtlykSiKmJrejZCSN5L/KjznNkOJbZXaZ
         9Zaw==
X-Gm-Message-State: AOAM532GiABdR5QYihFlPEogMHDFM/ql37L8mtOlmmnXxm4/WqSU8krQ
        H0E1nWna8RzhPG5MaqQXTnoe/9NnHE7QYw==
X-Google-Smtp-Source: ABdhPJx02IbLvzSXaEjnlJArkwC8e2PvV643HIdcDyfPx9crPXvwKc+0lLFRDL4INF44qeqPL5wkLQ==
X-Received: by 2002:a17:90b:4a0d:: with SMTP id kk13mr15553918pjb.23.1607741808133;
        Fri, 11 Dec 2020 18:56:48 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id s5sm11996765pfh.5.2020.12.11.18.56.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Dec 2020 18:56:47 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.10 final
Message-ID: <38c1cb1b-3d6f-037c-4596-5b8d94076654@kernel.dk>
Date:   Fri, 11 Dec 2020 19:56:46 -0700
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

Two fixes in here, fixing issues introduced in this merge window. Please
pull!


The following changes since commit 2d280bc8930ba9ed1705cfd548c6c8924949eaf1:

  io_uring: fix recvmsg setup with compat buf-select (2020-11-30 11:12:03 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-12-11

for you to fetch changes up to f26c08b444df833b19c00838a530d93963ce9cd0:

  io_uring: fix file leak on error path of io ctx creation (2020-12-08 08:54:26 -0700)

----------------------------------------------------------------
io_uring-5.10-2020-12-11

----------------------------------------------------------------
Hillf Danton (1):
      io_uring: fix file leak on error path of io ctx creation

Pavel Begunkov (1):
      io_uring: fix mis-seting personality's creds

 fs/io_uring.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

-- 
Jens Axboe


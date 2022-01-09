Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03789488AA8
	for <lists+io-uring@lfdr.de>; Sun,  9 Jan 2022 17:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbiAIQrd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 9 Jan 2022 11:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbiAIQrc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 9 Jan 2022 11:47:32 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A182C06173F
        for <io-uring@vger.kernel.org>; Sun,  9 Jan 2022 08:47:32 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id d14so9357598ila.1
        for <io-uring@vger.kernel.org>; Sun, 09 Jan 2022 08:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=xWI3vNvmJfkrk5zSMMt3m4H8NBhpSTby79+KRMrIVro=;
        b=tTCcfQ3wUNKqEYSJ9hV+mo0+y/rj6IlemkWzjotqMkznRlVmfJvV84Sqm63cu3Jbz2
         1zffd7b1HsctsXx3LxpZ2v4Hg9gKa5JTDJ+rCiEygv076Q2BJ3atIInp5rTpzVIqBPnQ
         lnXz6+F5E7bNRxYZKaPyl97CM64oY2Ac6vXcAHemCEkSonz0qbuQeiyrQSrjAmLYVr87
         uv6isgv5uLP+UoTzpHXCGVM7iTvg+Z6iQAmpAatofz+AdTLsV/6nZyL9rb6rGwC5EomS
         shoFji/9ZXDKEWWT8IUJQ6/Iz++4apR5zIhdmN/BAn9EnBKQ1zrdJ6Vjg2ZRm+TmWJJn
         lgMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=xWI3vNvmJfkrk5zSMMt3m4H8NBhpSTby79+KRMrIVro=;
        b=DZHJ95Un+RY2+1eHVGGO5oL0oZFXcODrFSxwO7vFSFT03jj/4QRRLrrSNbtUM+Jzlv
         uPceDX++p3ApYlWTrNDRqE6Fiuupe1J/jWs4zq2HSH9tMp6aZSPfOzSPL8tLXPgLanu+
         UA+hRtJqM69TJU9ckTv+ds4APEFf+kPrKkJZzihJY2VqXib+EUGbg5GtCPa/jZKMFyov
         fxyYDiyfBVWtEHnnGkX10ldrEoBAuuLR232p1p59vwa2VcyGnI2ws45LsQPNkpnepSkF
         aj3JQkJ+oT/Ncmbya+b4iyWFkcfG6oBuLh+R1A7w+lqc+cWgi7hrq1c0uZ8Usl1FKizT
         RqqQ==
X-Gm-Message-State: AOAM533XOfC6p+91pc2qJmyUwWXPxaqxKfulGVzqHP7/FbgN8KY0J6ZJ
        +WFfL93JZGu+FiaDabCYE1QxQw==
X-Google-Smtp-Source: ABdhPJykikycN3zW/Nq4TrdDL2iDS6cvHhZXqzgLY5rS7vpDWVxnYs8pnnu4lp5MFstYan62jrTEMw==
X-Received: by 2002:a92:d34d:: with SMTP id a13mr7838543ilh.266.1641746851830;
        Sun, 09 Jan 2022 08:47:31 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id v5sm2773135ilu.77.2022.01.09.08.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 08:47:31 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Ammar Faizi <ammarfaizi2@gmail.com>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
In-Reply-To: <20220107130218.1238910-1-ammarfaizi2@gnuweeb.org>
References: <20220107130218.1238910-1-ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing 0/3] Fix undefined behavior, acessing dead object
Message-Id: <164174685029.72168.15306294752052885000.b4-ty@kernel.dk>
Date:   Sun, 09 Jan 2022 09:47:30 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 7 Jan 2022 20:02:15 +0700, Ammar Faizi wrote:
> This series fixes undefined behavior caused by accessing local
> variables that have been out of their scope.
> 
> FWIW, compile the following code with gcc (Ubuntu 11.2.0-7ubuntu2) 11.2.0:
> ```
> #include <stdio.h>
> 
> [...]

Applied, thanks!

[1/3] test/socket-rw-eagain: Fix UB, accessing dead object
      commit: 5ee4feeac88d42c8c4cadee1f242279ff5fc0277
[2/3] test/socket-rw: Fix UB, accessing dead object
      commit: e5bb9f3e65f0e18132b27ba0322e2419d87f4f92
[3/3] test/socket-rw-offset: Fix UB, accessing dead object
      commit: 3f10277e6412d56cb52424d07f685128112498fa

Best regards,
-- 
Jens Axboe



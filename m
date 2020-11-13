Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556E02B2672
	for <lists+io-uring@lfdr.de>; Fri, 13 Nov 2020 22:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgKMVUS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Nov 2020 16:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbgKMVTD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Nov 2020 16:19:03 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53EDC0613D1
        for <io-uring@vger.kernel.org>; Fri, 13 Nov 2020 13:19:01 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id h16so4039573pgb.7
        for <io-uring@vger.kernel.org>; Fri, 13 Nov 2020 13:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=MJk7fY5RNiLFYMXIeJDK6yzoMfnkDiuk/4js7yWfhIA=;
        b=bHwpc6g2wCI+0hQsT4JMv8ukjEqVquB4r7flIaJBYwiBapxcvuQYVBYHtbRVUZIyuF
         fafsmLx1VM4yNg9OkBwEZAhAXAABYPxS9eMRG3LTSWz2cEvyWz9HO+CA+5W+CPdBQ/cE
         gyAt4MpV40Yfl7dA4lDTFrxYpCqKxOAH6+lNZvzSyfuNeX1Fiferr/JqEq6jYr/pG7Ix
         elPTOtRDMUdwWzj0QyXe3FbnL++s1ZmY0MHW4GNiP+PDOxc9z2oEaJevY63g3tio11Tt
         Rs+ThwJFdnis66gYpJGUN6+sYuJrlXGEqLelQkvfDYQiDN1dCx3IIvfLGhyv+jPZuu9E
         HapA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=MJk7fY5RNiLFYMXIeJDK6yzoMfnkDiuk/4js7yWfhIA=;
        b=Y7rR6GP5xKtgwNxo6gzFWmZKXtODqAAGf36ANlMZn/SjSxKTU7c/RAzElapd1OZAkN
         hes1pWsSWAbKImdng3sPD2bKDFtb6lhxCN/EiYIP9EZDwEmoKkGe/oSUq5NmV+/HZe45
         81qa5wAv/pn3vTAtJiVqfURVg2X814PlW/zv0GZ8KhOhzmYn5x6zcJJaFqcLayRpejjj
         uoIpQzj9EVlcdkRu2FfNQ1Y6xScd0pv9Q+T6vm1Ye4DOejpzQUDs2OUJbTSp/OEPxjcm
         LRbPq+U29tgQMTrZjAXb4tQWqT5q1midhr9HrRowwrB3nqzHurrRcJx05wb1xYyAo0yK
         jECg==
X-Gm-Message-State: AOAM533ZD5PaWXEHz1DCVeMcnMeFXY8HGy0lv9hG9wiroEy2xm0leU/O
        QVtasw+f4keQOXbl9IF6DHTUv8zyTpec8A==
X-Google-Smtp-Source: ABdhPJyEdZ/S5OfQCwt2wl+L5GWgTjP+kq2DeSp2c/DFihogGSqvQz3BTgKSxZTgnNsTrn7xOFLAiA==
X-Received: by 2002:a63:1553:: with SMTP id 19mr3574682pgv.317.1605302340877;
        Fri, 13 Nov 2020 13:19:00 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q6sm9890449pfu.23.2020.11.13.13.18.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 13:19:00 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.10-rc
Message-ID: <f3788725-f153-93d9-8d05-d48a8526ecd1@kernel.dk>
Date:   Fri, 13 Nov 2020 14:18:58 -0700
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

Single fix in here, for a missed rounding case at setup time, which
caused an otherwise legitimate setup case to return -EINVAL if used with
unaligned ring size values. Please pull!


The following changes since commit 9a472ef7a3690ac0b77ebfb04c88fa795de2adea:

  io_uring: fix link lookup racing with link timeout (2020-11-05 15:36:40 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-11-13

for you to fetch changes up to 88ec3211e46344a7d10cf6cb5045f839f7785f8e:

  io_uring: round-up cq size before comparing with rounded sq size (2020-11-11 10:42:41 -0700)

----------------------------------------------------------------
io_uring-5.10-2020-11-13

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: round-up cq size before comparing with rounded sq size

 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Jens Axboe


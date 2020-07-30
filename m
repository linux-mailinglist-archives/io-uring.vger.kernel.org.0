Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEFC7233532
	for <lists+io-uring@lfdr.de>; Thu, 30 Jul 2020 17:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbgG3PTE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 11:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgG3PTD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 11:19:03 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD867C061574
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 08:19:03 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id s189so21350430iod.2
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 08:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=YRVr6+LsW8TI2o5l1MEv+Y0iX3K3Ofd5Gm14iF8XXOE=;
        b=tv3wyIC2zqPiNbVud6Vc9pXqXwQh5wscx3PydlKNz8KTSPwdHLYlK+aXKvbKw+0Sxl
         rhz5ucyVRGA3UAZZT+nz5e2JNN0MUrcBysJOxQUF72rGJNNF5AOAq4Ma3qsnYeqk0wga
         GVjVr6P9CAzkqG2FswVpu9GMx3CND6L9W+dVQoDR+574t/zWrmvBrvNYzfU0rCVjkGRZ
         P1XzewfvwEa+MDAgtuYGwU3rhYXMQkS3cXvasuzP4Ui5YvNbAkJef86uNTUff2uYbz6z
         +JGpcpUArgqhBQh/hq4Wdri29+eNZSf7ggVepy+iWQK+JpYXryd9OapV5Nnh6G1oYyhu
         MWew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=YRVr6+LsW8TI2o5l1MEv+Y0iX3K3Ofd5Gm14iF8XXOE=;
        b=tchvv+T8OXFtqzlmGOYCrikl+GBtCCmhdBFk3EAg+AtakwLyg5JXxlrOs8BD038pQh
         jtnyitmeeQ2KXeImFmLDdk6ajCp0NiKlxKFDF94I4+1bGy1bVSqk3k+e+eBw4HQf/QLR
         7iP96/JUXsKc5WKAc6J0Dd+y+QDD3uXN/3J6FdZYabJXHOCU2dPwGG4KMpuGMHv6cn0R
         UxfhMcFBTTZFqbzw9mCHMyE6GJX+A9qzNemBcyp4+YOhnro41DvnjFhQbc7m/KahLbWi
         OBs11+r0rAm7ZWsM9ZiFvKCE1BE289vc54NtpyK73e7+uxvxyAQDCOxnsePXZF5jqbsB
         wgQg==
X-Gm-Message-State: AOAM532h2+M4ZWdouaU9mqYLUa2vIBsZSvhRh5ZLR+hMl7DerqntLLV6
        JO0NWEmP5EnKSylRGPREEJj01g==
X-Google-Smtp-Source: ABdhPJx8lHfXK97Mnupynh3VELyYrkIil1dt9uVCQvqixWS7wQ6lzgIbHECTmacot5B1Ma+m8Cg64g==
X-Received: by 2002:a6b:6509:: with SMTP id z9mr30119919iob.127.1596122343105;
        Thu, 30 Jul 2020 08:19:03 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i8sm3053552ilq.67.2020.07.30.08.19.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 08:19:02 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.8-rc
Message-ID: <c3965487-1654-17e8-0d7e-9e8078d5dd6e@kernel.dk>
Date:   Thu, 30 Jul 2020 09:19:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Two small fixes for this release, fixing corner/error cases.

Please pull!


The following changes since commit 3e863ea3bb1a2203ae648eb272db0ce6a1a2072c:

  io_uring: missed req_init_async() for IOSQE_ASYNC (2020-07-23 11:20:55 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.8-2020-07-30

for you to fetch changes up to 4ae6dbd683860b9edc254ea8acf5e04b5ae242e5:

  io_uring: fix lockup in io_fail_links() (2020-07-24 12:51:33 -0600)

----------------------------------------------------------------
io_uring-5.8-2020-07-30

----------------------------------------------------------------
Pavel Begunkov (2):
      io_uring: fix ->work corruption with poll_add
      io_uring: fix lockup in io_fail_links()

 fs/io_uring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

-- 
Jens Axboe


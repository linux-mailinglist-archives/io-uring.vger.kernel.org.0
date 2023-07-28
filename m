Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76F69767023
	for <lists+io-uring@lfdr.de>; Fri, 28 Jul 2023 17:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237138AbjG1PHn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Jul 2023 11:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235260AbjG1PHn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Jul 2023 11:07:43 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD4A3ABA
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 08:07:39 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id ca18e2360f4ac-7835bbeb6a0so32156139f.0
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 08:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690556858; x=1691161658;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vlKC6oW0UabaNM1ZW6KEoORm/ix63MBZdxzRJf+OzBg=;
        b=efEUNCjgec6Y+k8boWoFbSS9Q81L3DBk1eIH6QCGJyeZd4Bf1vlxaeHneNhDgPtU+N
         sRNtHr0zxYVVLWw2djs+zF5A0oE7B9znxzl13KaKRTDDBAS9DiyQMa2yeDA6GlAeFri4
         wUDM+9/XvfVXg8loQMo/IKfOMqXllS3O5Avutkwj7UWU2Fw7QDOLqT/WfGQGP/ZYiECv
         wAUHP492auVEgd9YKvQxLXH2uVSk0wWDreebmIYqjAkviJaKUenxqrNIvPhH7SCLJPJE
         lHgEMCim8FuvMEB9S15ef1Qli5UY/tXEjEODjX6orbB4vR+2kDXe4FgWo0Eo1bUIrIcU
         CkvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690556858; x=1691161658;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vlKC6oW0UabaNM1ZW6KEoORm/ix63MBZdxzRJf+OzBg=;
        b=WGH1mgxzOIJRWWwGtrD/WMpbAL7E5rkmcq0Vk4ENbBAypcwTJLE7RxrrTlPFnP84PG
         fiiPDTRw5Ug9h6JmHYBJG+U2MaJe0TWOxDVZEyTBK4GfKNTjg4E3TEeFnV/jHQJt4TSn
         Bf6SJppeh26Cscy8VDnJRF5a1cNQTmStiw5XDAHbcOcuhmhym81lyDwS64Ig8ebxLHFz
         xZHDm+sOJK/EO7nuvMUOtC4P+oqKH5uVOMeuqNu+XlTwE9eQaE+SG8NOXiw1m3qbZY3H
         9X0xpRlm5hvM62D1FNb9IAzNYAsp2yWPG8B5Ij871sW00mclt8azQ5roUkRbb/FC5Sbj
         x/uA==
X-Gm-Message-State: ABy/qLbS/T5KxgKQkyj7Ak6CXs/IRtDKpEO1HuVr/yrcCNzH+EJWrAwX
        9qudqZtwYd1x47Z52gokO4BLHxyEHITflMc1KKc=
X-Google-Smtp-Source: APBJJlH3+E/q0fraVn6mtbTt0FTdd9c2Xv9eikmpsT65Llx7xKC/2elBj3iuwLWZJ2h8Z6k175UsqQ==
X-Received: by 2002:a6b:b294:0:b0:780:c6bb:ad8d with SMTP id b142-20020a6bb294000000b00780c6bbad8dmr3544527iof.0.1690556858598;
        Fri, 28 Jul 2023 08:07:38 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l10-20020a02cd8a000000b0042b149aeccdsm1173727jap.104.2023.07.28.08.07.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jul 2023 08:07:38 -0700 (PDT)
Message-ID: <624c12e5-2ce8-852b-c235-0835b97d199a@kernel.dk>
Date:   Fri, 28 Jul 2023 09:07:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 6.5-rc4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Just a single tweak to a patch from last week, to avoid having idle
cqring waits be attributed as iowait.

Please pull!


The following changes since commit 07e981137f17e5275b6fa5fd0c28b0ddb4519702:

  ia64: mmap: Consider pgoff when searching for free mapping (2023-07-21 09:41:35 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.5-2023-07-28

for you to fetch changes up to 7b72d661f1f2f950ab8c12de7e2bc48bdac8ed69:

  io_uring: gate iowait schedule on having pending requests (2023-07-24 11:44:35 -0600)

----------------------------------------------------------------
io_uring-6.5-2023-07-28

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: gate iowait schedule on having pending requests

 io_uring/io_uring.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22589754350
	for <lists+io-uring@lfdr.de>; Fri, 14 Jul 2023 21:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236284AbjGNTje (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Jul 2023 15:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235931AbjGNTje (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Jul 2023 15:39:34 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B097A2119
        for <io-uring@vger.kernel.org>; Fri, 14 Jul 2023 12:39:28 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id ca18e2360f4ac-7748ca56133so20804839f.0
        for <io-uring@vger.kernel.org>; Fri, 14 Jul 2023 12:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689363568; x=1691955568;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MWzhG8+GY4hViPukWPiWZRq+N25+GfMzWl3VIaEsAt0=;
        b=2fEN0uiFjeFOX9ee5hjmmS3TBSfaEoNjYNen1+aXJRZ+jRFqj8TOTQC6pXe8WZNvhM
         6xwb5yvV0oUnYJDzDWStIdELRNmfZtFhqtRTIle++wpN3WBKWVRgNz2DLuK0tzljPxMv
         aRFiUsTIyzBR9ZtKmpMySkC9QB0WIZb+9sWPrOGmh4M0NrI+lRIGbT2CERRm4NYd9wwM
         +0wRZpss9vG8NL+zDRelgVlIQBe/G9GozWd07YdEtx9sSeGuVIgIYvrilZ3kYJx/rKMT
         HvabqA1BN0zw6ET074VlfhVbuN3SRwhbi5Z3YaRHGZeNmdI7Yhk6eMXT1DPmGkI+p7U9
         lLkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689363568; x=1691955568;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MWzhG8+GY4hViPukWPiWZRq+N25+GfMzWl3VIaEsAt0=;
        b=ktVRYzNOmdwRXBdg73bZoA8yMoVcZF37HlYYp+a6VPhye0SZFBGU8z3KGDlo4eY8Xf
         qFh1gyKHq4XoXgU2vXqmFba1kSatfTcHMyIEdUzxliHFP4I6MIFY0FoVNsG0GyxtqGOO
         sD4SPLJFYIMqzDxWXjYbvn5QefRJjhs9Sy0+uVczFuzWL8trz7nhW8R/u17YYspGu6q3
         Nn/4WzLuPhaFX+/3bvwJ9qZyaZWZNAiDBGtYB++olcQs78J57DcCkxuHS+8TJO1r4MYL
         p4f+dfQgHQTH8AnAVLhGk+8ndigUqtdZpaTRfiuXv5vah1eHyVrf+i0J+2GGbH/0in20
         isaQ==
X-Gm-Message-State: ABy/qLYTU3pUfD27xTHYnz631/B/2+BKhCDmwtcTktfsgPyFFe3KQG9n
        C6DQ9czj0IwokD8vVDU9E4g2TyrGNdjaRyHBVkw=
X-Google-Smtp-Source: APBJJlGqzj+aSTYR5IZ2cZ3j9JzWff6pd2R1cDMrU5rCtJ76Z1014JHJeh27I6dB8ibeThw0r6Jq4w==
X-Received: by 2002:a05:6602:4a07:b0:780:cde6:3e22 with SMTP id eh7-20020a0566024a0700b00780cde63e22mr147032iob.0.1689363568073;
        Fri, 14 Jul 2023 12:39:28 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id p5-20020a0566380e8500b0042b068d921esm2803609jas.16.2023.07.14.12.39.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jul 2023 12:39:27 -0700 (PDT)
Message-ID: <b4ba0b17-cf57-58b8-14c1-fda1b209c2bd@kernel.dk>
Date:   Fri, 14 Jul 2023 13:39:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 6.5-rc2
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

Just a single tweak for the wait logic in io_uring. Please pull!


The following changes since commit dfbe5561ae9339516a3742a3fbd678609ad59fd0:

  io_uring: flush offloaded and delayed task_work on exit (2023-06-28 11:06:05 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.5-2023-07-14

for you to fetch changes up to 8a796565cec3601071cbbd27d6304e202019d014:

  io_uring: Use io_schedule* in cqring wait (2023-07-07 11:24:29 -0600)

----------------------------------------------------------------
io_uring-6.5-2023-07-14

----------------------------------------------------------------
Andres Freund (1):
      io_uring: Use io_schedule* in cqring wait

 io_uring/io_uring.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

-- 
Jens Axboe


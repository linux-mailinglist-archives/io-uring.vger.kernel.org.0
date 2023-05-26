Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C8D712B7F
	for <lists+io-uring@lfdr.de>; Fri, 26 May 2023 19:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjEZRMx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 May 2023 13:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbjEZRMv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 May 2023 13:12:51 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7469FE69
        for <io-uring@vger.kernel.org>; Fri, 26 May 2023 10:12:28 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id ca18e2360f4ac-7747f082d98so6592539f.1
        for <io-uring@vger.kernel.org>; Fri, 26 May 2023 10:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1685121143; x=1687713143;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VzwR+X8RgQmAxvclGvgOkGYJWYoPRb7tvq+CGH6JEyE=;
        b=VlqwBn1Op5MkSnONgrj10AmXQTYMiJHG7EXB65nL6z+9urMI8twh3GVBCI/quwjCT+
         QpyF8KqihQXsaci8Qw6hqajb80dpP332NuFCw0xoGvpikI0b7jDUWYkdkmS9IXgAdV9/
         mnRMqKi8uAlgoP8JaxNpK3YZWVw9NtQM13cFSabn7Y7lQYjAGodkZUDMNdWEEDqX83qH
         8gSNMQm2HdsPNctldLLO+5qRM4ms8AcTK6ghTsol4SHYzAnYTklc8E5/EX+LqH4EVYmr
         ihVPrV0hFr/G+H4zHF5EtB/ZAr1ZgQw3hLUeikz2VCSYnNa/Q+v2vLMi83WtN17w21qH
         TnQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685121143; x=1687713143;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VzwR+X8RgQmAxvclGvgOkGYJWYoPRb7tvq+CGH6JEyE=;
        b=ckirg96ijymIO/aVphcNRtfR9ghnaEa2+sakpXzY5ryXqyan0gZ+8/n/rElIzbVDka
         i+ZYF3ZT81Z1t52xhrIa1myuaG/oBARhzpkL8ccg2sc8RsB9IUHPZ954UnSnloude8Gm
         9PM96GALt+n844DkSf334fyZupBAioCxVAPw3KqcWpw6m9aS0jH5OKAsOVsIIfms+J61
         H3fu6GAj0hxqHVXcBFS8XDQMa0kV/azgzzfTpgb91b8ycL0G/EPtNCevyyAfX23XB7tW
         VSuxO15s1dAgDI8W167h5sTmNA72VkbRR1WUlG/khygixppwau+CymnywL7FXlXiexHy
         xxDQ==
X-Gm-Message-State: AC+VfDwjtrfJBPO9VQGdkl5xzblD5igttZNStTqiD1Hw0A57Sfk9nbGw
        p1T+ASVZybhOpZs1WftbAcACJm7gazz8GfgC9MA=
X-Google-Smtp-Source: ACHHUZ5TiKDmC3Q0QrcM3ur0ZYwgY4xtYZEqNfemL2TnUZdwpyZ0IbNDRNYbWGoP0TLaRwjDeqmDVg==
X-Received: by 2002:a6b:3b8d:0:b0:774:9337:2d4c with SMTP id i135-20020a6b3b8d000000b0077493372d4cmr1181203ioa.1.1685121142732;
        Fri, 26 May 2023 10:12:22 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id m13-20020a0566380acd00b0041a8df29ad7sm1197841jab.38.2023.05.26.10.12.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 May 2023 10:12:22 -0700 (PDT)
Message-ID: <ffbf62dc-4f6b-aad6-28d5-52443f55ac81@kernel.dk>
Date:   Fri, 26 May 2023 11:12:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 6.4-rc4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Just a single fix for the conditional schedule with the SQPOLL thread,
dropping the uring_lock if we do need to reschedule.

Please pull!


The following changes since commit 293007b033418c8c9d1b35d68dec49a500750fde:

  io_uring: make io_uring_sqe_cmd() unconditionally available (2023-05-09 07:59:54 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.4-2023-05-26

for you to fetch changes up to 533ab73f5b5c95dcb4152b52d5482abcc824c690:

  io_uring: unlock sqd->lock before sq thread release CPU (2023-05-25 09:30:13 -0600)

----------------------------------------------------------------
io_uring-6.4-2023-05-26

----------------------------------------------------------------
Wenwen Chen (1):
      io_uring: unlock sqd->lock before sq thread release CPU

 io_uring/sqpoll.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

-- 
Jens Axboe


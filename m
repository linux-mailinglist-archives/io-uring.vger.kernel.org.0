Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF6796E2ED7
	for <lists+io-uring@lfdr.de>; Sat, 15 Apr 2023 05:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjDODnC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Apr 2023 23:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjDODnB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Apr 2023 23:43:01 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2E25270
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 20:42:59 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-63b5312bd34so355627b3a.0
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 20:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681530179; x=1684122179;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6HeyjJdAwFslf8Lpta8Pywj6nowlrBJdqE5SFB3Qz3s=;
        b=EgbWg3G/uK3ld+7UAjWGYVjubCR5XDDRbKUvRVsqmWF7EXwBVvW9sfIRWTgKiAi+ol
         inSei/KFX/ExiHUd0kQ1fDdFqOyd21I8EMxPX66aZVk1eKMAqGQ9q/tvdpmngsVwfiam
         4c1dPhBGQpuBjYL8kfaRMzfTODt78bOXvlVe9QZdSvKVLZetq1NEcmtZ669Ul2FSnLlL
         XQ9u/p/1gR37kEdlDMZlZEQh+UiwojOun5k+J9gU4kw/tnJhhrLr1G1nhvW0gmquzUUi
         4t2tWn4km5JM20wBeafF2kX6ZbuFMdl7IOlagcP0fjapEHi7UqXIDGgJxhS0AkHil1q+
         A0jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681530179; x=1684122179;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6HeyjJdAwFslf8Lpta8Pywj6nowlrBJdqE5SFB3Qz3s=;
        b=BM4EIk4HgNHQFceXlsDJmgEfN4taRqMt96L09F73sdexuPeYaZM0Q1PNFiLeE9Pg26
         EdXjFrGBDXIwFtp3owhCVyey7+PYHTa7rbVqdkMCNB+62CLcza2xijYX1/7Tp+Z/q+/B
         6CyC2oVbnFyQBAB3DQEVU0f96G0S42XoaaIyjFCG7ZiJ2bh78c7UfGSfpsXhIwm0lcez
         cF2t0mI67AlrXcA6Rjq9TfSf8R6V6MQJFiRayVCvDZFOYsWzEy+w5yXl0rjP5lEE8IQc
         cyRYMzi6+vpGl76oxPIhoLJQ8fcsOqvnZvCnVfApRkwZzASZtL2rKq0kLhSoupzewzIv
         bZig==
X-Gm-Message-State: AAQBX9e+ZkrnjSDFZ0F1buuum/2B/OOvqMdY8mQFUTmb9Ba91rAP/ebf
        +IpjZC+nl0Zfp6xoJt+v6aZz3ifB+KnEMK9K7E8=
X-Google-Smtp-Source: AKy350ZtzXVSjG5mf146tPbpF5eX9jgnIDtwwx+WY0MCqyg3ks+k35AVR7OoVst8HAm6dJLUQCSH+Q==
X-Received: by 2002:a05:6a00:1f0d:b0:5e2:3086:f977 with SMTP id be13-20020a056a001f0d00b005e23086f977mr5058652pfb.2.1681530179080;
        Fri, 14 Apr 2023 20:42:59 -0700 (PDT)
Received: from [192.168.4.201] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id u23-20020a62ed17000000b0062d7c0dc4f4sm3696650pfh.80.2023.04.14.20.42.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 20:42:58 -0700 (PDT)
Message-ID: <b2b5b5dc-d849-d4ba-4f18-08d6869db9c2@kernel.dk>
Date:   Fri, 14 Apr 2023 21:42:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 6.3-rc7
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

Just a small tweak to when task_work needs redirection, marked for
stable as well. Please pull!


The following changes since commit b4a72c0589fdea6259720375426179888969d6a2:

  io_uring: fix memory leak when removing provided buffers (2023-04-01 16:52:12 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.3-2023-04-14

for you to fetch changes up to 860e1c7f8b0b43fbf91b4d689adfaa13adb89452:

  io_uring: complete request via task work in case of DEFER_TASKRUN (2023-04-14 06:38:23 -0600)

----------------------------------------------------------------
io_uring-6.3-2023-04-14

----------------------------------------------------------------
Ming Lei (1):
      io_uring: complete request via task work in case of DEFER_TASKRUN

 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Jens Axboe


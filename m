Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71AA267697A
	for <lists+io-uring@lfdr.de>; Sat, 21 Jan 2023 21:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjAUU4t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Jan 2023 15:56:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjAUU4s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Jan 2023 15:56:48 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49973244A9
        for <io-uring@vger.kernel.org>; Sat, 21 Jan 2023 12:56:45 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id x4so6323187pfj.1
        for <io-uring@vger.kernel.org>; Sat, 21 Jan 2023 12:56:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qr6ks/yZ+Ciafiukn+0PVrOsv0nWxtX6OOCWcB5l51s=;
        b=Nj5LSpNd81xa6DIOs/1qFeyuBWPFm9kewk40HoxB/oWR4tzNtWhzBwvWb09Ka57Js2
         uVQ35nGJqWuJfghTuGR4YSp1CbUs9fHJDpIVIwOFol7CBpFNOoJxxYGaq4zk/djS+Yvf
         0Jdvh38tD/5jullWRnPQctJDvm+ufTJ75mIlV1eRwnLYgLX8fwlNKn7Xlokm4xRxk82y
         MgxL76mI3YLL4ylIbFiTCHDymJNwNTO24Tlms4YHGak1ORVjwb9lTUlreFt5/WuZLJc6
         B/tVRK459WRwOADFXrBXgAyaUrFzH46lbKZPZ144CoO/7Gs3/jCGAPOhMhJVXAb72fmj
         Mv1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qr6ks/yZ+Ciafiukn+0PVrOsv0nWxtX6OOCWcB5l51s=;
        b=bSPhwPVfjU2hODKYABd6+k78EX4u3wHK+MP6Vjkd8L4BAMIfVFpAi/I5Dcr7UWn7Jn
         qfmfMaO0FnpaZ3w1BnhTpRDbmlDP6eXhx8YQcQ2Hvs0XynLeU4f0EY8CkFdI719AlDc2
         6O5gkCX3fmErbM0+LhJASFgxJj2tcwAjrE1h7pjaVMPmlY79Vt+JR5QZcCcvoMqQ4H3f
         CwtIMwcM9SOcd+j3nMlHWRby7Kh7lhANABRn0SRxgUSoszRaomGLOURSaWkDJIUEPcX6
         nupaeRiyr8Auaarro7IBjLGgL5rGUL8hBqle6zbSG8ofyL07sXGs6u/2LAT88HANMjX3
         wTdw==
X-Gm-Message-State: AFqh2koa7vdNoAHJypzlK6TYMyzsrgsF7FVxa5Fu0y258qG8lotuggxQ
        UPPivW9E3pNTF/T74SVdbMOB4eLzmmWVgrli
X-Google-Smtp-Source: AMrXdXt3yxrnEAWpwQxanVUx4pu3v0geUl0xoOqOGXAFC7cEaWiIJ30AhGMBdfzL06SGdEffuTb0NQ==
X-Received: by 2002:a05:6a00:188a:b0:58b:453e:d12d with SMTP id x10-20020a056a00188a00b0058b453ed12dmr5022948pfh.1.1674334604460;
        Sat, 21 Jan 2023 12:56:44 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y30-20020aa793de000000b00589d8cbd882sm22845450pff.150.2023.01.21.12.56.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Jan 2023 12:56:43 -0800 (PST)
Message-ID: <116e2c78-4fe8-928c-636d-b514ce1299e3@kernel.dk>
Date:   Sat, 21 Jan 2023 13:56:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] Followup pull request for io_uring for 6.2-rc5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Just a single fix for a regression that happened in this release due to
a poll change. Normally I would've just deferred it to next week, but
since the original fix got picked up by stable, I think it's better to
just send this one off separately.

The issue is around the poll race fix, and how it mistakenly also got
applied to multishot polling. Those don't need the race fix, and we
should not be doing any reissues for that case. Exhaustive test cases
were written and committed to the liburing regression suite for the
reported issue, and additions for similar issues.

Please pulL!


The following changes since commit 8579538c89e33ce78be2feb41e07489c8cbf8f31:

  io_uring/msg_ring: fix remote queue to disabled ring (2023-01-20 09:49:34 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.2-2023-01-21

for you to fetch changes up to 8caa03f10bf92cb8657408a6ece6a8a73f96ce13:

  io_uring/poll: don't reissue in case of poll race on multishot request (2023-01-20 15:11:54 -0700)

----------------------------------------------------------------
io_uring-6.2-2023-01-21

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/poll: don't reissue in case of poll race on multishot request

 io_uring/poll.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

-- 
Jens Axboe


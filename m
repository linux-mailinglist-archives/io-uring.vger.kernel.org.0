Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDAA72030F
	for <lists+io-uring@lfdr.de>; Fri,  2 Jun 2023 15:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236174AbjFBNTE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Jun 2023 09:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236148AbjFBNTB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Jun 2023 09:19:01 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E06E78
        for <io-uring@vger.kernel.org>; Fri,  2 Jun 2023 06:18:31 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id ca18e2360f4ac-7747f082d98so9818639f.1
        for <io-uring@vger.kernel.org>; Fri, 02 Jun 2023 06:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1685711911; x=1688303911;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jvjhR++NBSnO6+SF1oz4r0utQAjJZJI5UIW0hRbWLHs=;
        b=J1CJE0do4x554sn9gHbTBrZzrQICQSkxdTPiVXTWI5x2aeoYFYgI8cWyd2NonYFymy
         V/+bg77LGvEtQE/kPDFXuSDh1Awp3alRJvpR1fIgvqEZEMhK6s0wBhmTd0dsGlbBZJ1O
         9NXm8Px9hFbAonmxPFlAvCswyWAKONhv0ZtvAFeA3IGXreGgROQPmCWVwK2EOzo1YyNx
         M7+Rm1yrXRVYvU50+wthq8UpBc4rc352WN1D64elYazPahVlboJdsJPEvRmuViyN88Qz
         spHJhvCzNuDxsPcyHc5l4ZVgVGc8QyrdXJThTboGwAJ0aTKrqTY0hd0JPXlHKuwHIVAB
         NwSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685711911; x=1688303911;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jvjhR++NBSnO6+SF1oz4r0utQAjJZJI5UIW0hRbWLHs=;
        b=JNfpr86DEnjrq0RwckbpaBd4Z3BLKlst3V9cKHNHHUMsENdgAVfoNo1eYypKM3z1OD
         PuTg6zPzOQSLbfsE2wWLgwu8OJuh3XlXl6J14lyiZEGcv/62tyI/CBQi207xgveRUgxj
         HRfX73L4elS/7Nyg7HGadG/HNNE9YjMrtNsUVi2GU4F8fHqMZQ9xI6SQasoGeYfI9IQJ
         TtWu5x/dReo9iHSMqUkPbenzNAsURQijcMDYWmzAOgHEp9lHzKHSL/A3Zfc85i6pXndO
         hfIj6P54S71fLgUp8CPiwxhEij9NttL3g36s2AahWo8xcT1pn+8qyyEwunUOFYw4kGZo
         iwWw==
X-Gm-Message-State: AC+VfDwJQCrJuLGPfUgjlySUcZJct9eGUaSgv5eS8hwhkiUertBy+7J+
        z9hH7G19D9R/U+JBVooXOQrMsfVBMASaFErv434=
X-Google-Smtp-Source: ACHHUZ61UlbTZdOmSbMwC7F7O5vbf0XcW+mipiy9hAV+L5USku0QoQ4YjCHtWxtc5IXJTduNFhIg/w==
X-Received: by 2002:a05:6602:2d8b:b0:774:9337:2d4c with SMTP id k11-20020a0566022d8b00b0077493372d4cmr10081110iow.1.1685711910977;
        Fri, 02 Jun 2023 06:18:30 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l30-20020a02cd9e000000b0040fad7eb910sm278884jap.176.2023.06.02.06.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jun 2023 06:18:30 -0700 (PDT)
Message-ID: <ce81810d-3fc3-29c5-a6ff-246f080a880f@kernel.dk>
Date:   Fri, 2 Jun 2023 07:18:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 6.4-rc5
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

Just a single revert in here, removing the warning on the epoll ctl
opcode. We originally deprecated this a few releases ago, but I've since
had two people report that it's being used. Which isn't the biggest
deal, obviously this is why we out in the deprecation notice in the
first place, but it also means that we should just kill this warning
again and abandon the deprecation plans.

Since it's only a few handfuls of code to support epoll ctl, not worth
going any further with this imho.

Please pull!


The following changes since commit 533ab73f5b5c95dcb4152b52d5482abcc824c690:

  io_uring: unlock sqd->lock before sq thread release CPU (2023-05-25 09:30:13 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.4-2023-06-02

for you to fetch changes up to 4ea0bf4b98d66a7a790abb285539f395596bae92:

  io_uring: undeprecate epoll_ctl support (2023-05-26 20:22:41 -0600)

----------------------------------------------------------------
io_uring-6.4-2023-06-02

----------------------------------------------------------------
Ben Noordhuis (1):
      io_uring: undeprecate epoll_ctl support

 io_uring/epoll.c | 4 ----
 1 file changed, 4 deletions(-)

-- 
Jens Axboe


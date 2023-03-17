Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90DE86BEEDA
	for <lists+io-uring@lfdr.de>; Fri, 17 Mar 2023 17:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjCQQwL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Mar 2023 12:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjCQQwK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Mar 2023 12:52:10 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633BAB1EE5
        for <io-uring@vger.kernel.org>; Fri, 17 Mar 2023 09:52:08 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id j13so5851556pjd.1
        for <io-uring@vger.kernel.org>; Fri, 17 Mar 2023 09:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679071928; x=1681663928;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q043sfeNA0KZ9TfF0fn+1Bi2hO41fh/LXDUG6Df4uzw=;
        b=JpdSZ5T5iEYVdjkN9jv0BZwZMIt6SjVwZcHB2QBiiIsRz6CWUFTY9sscCYVrCQaIDL
         x/yMJLIx3rQWl0AP76YWqAd+BJ6xvc3WKaFO6XTZykMeIkPUYp/Ubyx6OALSbsL4FQbo
         wZQ47YfWCHaIpm53QvqdvKpYdGPhkbr2fY+X6iF8W/hHokXNkiSqMAJ5PD2SaoqLGEfc
         w4B8TD4JCCIpFyd3ox42aHvC4ZHD25QE562yR7qnR+U6eunnXOOHXvK1KzjIvUKArhXH
         cG5qWbnELKJe3JQSjiW9SQTN43nTcDq6gl8zO12Hb63/9sdz9WZw9S0eEkrTxm505xK+
         zfCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679071928; x=1681663928;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Q043sfeNA0KZ9TfF0fn+1Bi2hO41fh/LXDUG6Df4uzw=;
        b=0d3YYZsoFXzCDnvA/0JYHIH6ZCv4ZI6o0ZGuIcgxz3GOQtfmIaqIV798ZQ1+IoE6PX
         8Ml4sWOjlLi/POVj8s6QWxK36Ok4+P7QNu7FqiX0vzlK76Yhsu/oq3KMSbvP3GC+pLud
         jlBGgNS3ZlDaILBMOQ4NCmHT10vNzOU+vYd0BcQE8rUoEOzAp5tFCnXX9NXEzDhZbT7O
         nZZ8+NcZURHynQvpQMnTOUEOda6Z4Ryz7jd7dgLE7EeJFd8IL3JUd4vobMT05HZeArUD
         P0Kv6DJtkM+hFo7CFaLLPWE+nok2gmEp7PI92rhjUax9ox6zlqD3G0D5/T1NGntvowFI
         5tPg==
X-Gm-Message-State: AO0yUKXs10nTtG+n0HE9GLowFdRDlyyzGn2EoFvXoWEgrotaB3u2ZChZ
        Ba5outkdfRAxHH9oyiWxeFkgqGyq9ioJKJ4n7echAA==
X-Google-Smtp-Source: AK7set/VwD3Qch5BkON9lYX5u+aMM7uWf4lYhzl0ZouwUy8a2bA3nLJJx9gQRt/n005gfvv0WeMdvg==
X-Received: by 2002:a05:6a20:841c:b0:d3:a13a:4c06 with SMTP id c28-20020a056a20841c00b000d3a13a4c06mr12402891pzd.2.1679071927538;
        Fri, 17 Mar 2023 09:52:07 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21cf::1749? ([2620:10d:c090:400::5:1473])
        by smtp.gmail.com with ESMTPSA id n3-20020a62e503000000b005b6f63c6cf4sm1798296pff.30.2023.03.17.09.52.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 09:52:07 -0700 (PDT)
Message-ID: <2be663d0-1b55-5c4d-a66e-a612c1177b69@kernel.dk>
Date:   Fri, 17 Mar 2023 10:52:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.3-rc3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Set of fixes for io_uring that should go into the 6.3-rc3 release:

- When PF_NO_SETAFFINITY was removed for io-wq threads, we kind of
  forgot about the SQPOLL thread. Remove it there as well, there's even
  less of a reason to set it there (Michal)

- Fixup a confusing 'ret' setting (Li)

- When MSG_RING is used to send a direct descriptor to another ring,
  it's possible to have it allocate it on the target ring rather than
  provide a specific index for it. If this is done, return the chosen
  value in the CQE, like we would've done locally (Pavel)

- Fix a regression in this series on huge page bvec collapsing (Pavel)

Please pull!


The following changes since commit fa780334a8c392d959ae05eb19f2410b3a1e6cb0:

  io_uring: silence variable ‘prev’ set but not used warning (2023-03-09 10:10:58 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.3-2023-03-16

for you to fetch changes up to d2acf789088bb562cea342b6a24e646df4d47839:

  io_uring/rsrc: fix folio accounting (2023-03-16 09:32:18 -0600)

----------------------------------------------------------------
io_uring-6.3-2023-03-16

----------------------------------------------------------------
Li zeming (1):
      io_uring: rsrc: Optimize return value variable 'ret'

Michal Koutný (1):
      io_uring/sqpoll: Do not set PF_NO_SETAFFINITY on sqpoll threads

Pavel Begunkov (2):
      io_uring/msg_ring: let target know allocated index
      io_uring/rsrc: fix folio accounting

 io_uring/msg_ring.c |  4 +++-
 io_uring/rsrc.c     | 10 ++++++++--
 io_uring/sqpoll.c   |  1 -
 3 files changed, 11 insertions(+), 4 deletions(-)

-- 
Jens Axboe


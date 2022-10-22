Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7633608E88
	for <lists+io-uring@lfdr.de>; Sat, 22 Oct 2022 18:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiJVQcG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 22 Oct 2022 12:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiJVQcF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 22 Oct 2022 12:32:05 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A71187DCC
        for <io-uring@vger.kernel.org>; Sat, 22 Oct 2022 09:32:03 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id a5-20020a17090aa50500b002008eeb040eso6913154pjq.1
        for <io-uring@vger.kernel.org>; Sat, 22 Oct 2022 09:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M2Jc4GHX1sN1ev0WI/u/Jl74D7OBcZM+CK87OFUa8Oo=;
        b=dn+95klZCwLQytb0tSAuTT/F5lvbK/KNJA0bPssmQFCpLKPd/7Rudg0sBH5ilp+8aa
         UaibUXuP+aSQp9mabULzqATwWqSDPea4Ng/R8HPQ9V+aYw6CbMj8LCD5g0Spien5w8Gm
         EXtk0ZJntQYL29pFgYP+2YcvWyBM6sfDlHM+osN3akKAeSh7JWjKE6mgm1AFuh0SSOJK
         eh7NeREUE4Tql7TbcqW4Jb3uMG8OPlAZhlh1p4Te+PEqfkNtSssZb66nqNmCw3KOdTCz
         X6M/ll56DIp82gWdQqUI7nEXrs7gRITJh0kJLpj32pj+d8N0sXNtSnCR7yRSmvXGDBuo
         C07Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=M2Jc4GHX1sN1ev0WI/u/Jl74D7OBcZM+CK87OFUa8Oo=;
        b=thsNbyRC5h3Ecrz+1hJHJmTX5CVICN07yaHRn1QcxdtBQ1vYLD7bFRMa+wYPHqqzRy
         TGC+D1+u+8ZVDn4mAIgTwm7ynDJENFs50BhInuAzXE/wCcXHuywP4LgzS9ZzWBycRseK
         QW1BMc27CjG6ANmZ5adbpR56mScE3hojm85krunDfmpAoksL5plVkg6azFzxPngSukle
         kK5qbKVQBQRi7+7J/J9LgpN4xHhTlMBm72acJhSvPwUt0KfOuMJKhs1eaPChHWAh53Zs
         cpLf9tmR+osS2nN7rPenVLzutRRMrONd/TYfgYUOoMXKR8TOlLVlc1oJMkEmlkHpyht3
         3esg==
X-Gm-Message-State: ACrzQf0K8A19ZzAc89gUuJfPCqAzMCt5UO7antByNe4Is9QzCA/O9tIq
        LhMDyRuR5lJ/1stXDNZdvG6PY8dK6EffIDVM
X-Google-Smtp-Source: AMsMyM7c4MnW1lDWBzbZtVV/3mx9MKOQOQooId0szsRpGRKA4drtzJGo5+RmCdUIk/GaFN9V8+r+4Q==
X-Received: by 2002:a17:902:f682:b0:185:45e8:2223 with SMTP id l2-20020a170902f68200b0018545e82223mr24730879plg.151.1666456322725;
        Sat, 22 Oct 2022 09:32:02 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a15-20020a170902710f00b0017f8290fcc0sm16504175pll.252.2022.10.22.09.32.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Oct 2022 09:32:02 -0700 (PDT)
Message-ID: <b9bc8682-1d86-ad68-68da-8b6b275e756b@kernel.dk>
Date:   Sat, 22 Oct 2022 10:32:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] Followup io_uring pull for 6.1-rc2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Was going to delay this one for the potential batch next week, but turns
out it's more convenient for the networking side to get this into -rc2
as it'll conflict with a patch going into net-next also adding a socket
bit. Jakub has signed off on the net change.

Currently the zero-copy has automatic fallback to normal transmit, and
it was decided that it'd be cleaner to return an error instead if the
socket type doesn't support it. It does work with UDP and TCP, it's more
of a future proofing kind of thing (eg for samba).

Please pull!


The following changes since commit 996d3efeb091c503afd3ee6b5e20eabf446fd955:

  io-wq: Fix memory leak in worker creation (2022-10-20 05:48:59 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.1-2022-10-22

for you to fetch changes up to cc767e7c6913f770741d9fad1efa4957c2623744:

  io_uring/net: fail zc sendmsg when unsupported by socket (2022-10-22 08:43:03 -0600)

----------------------------------------------------------------
io_uring-6.1-2022-10-22

----------------------------------------------------------------
Pavel Begunkov (3):
      net: flag sockets supporting msghdr originated zerocopy
      io_uring/net: fail zc send when unsupported by socket
      io_uring/net: fail zc sendmsg when unsupported by socket

 include/linux/net.h | 1 +
 io_uring/net.c      | 4 ++++
 net/ipv4/tcp.c      | 1 +
 net/ipv4/udp.c      | 1 +
 4 files changed, 7 insertions(+)

-- 
Jens Axboe

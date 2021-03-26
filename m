Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41762349E24
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 01:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhCZAlR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 20:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbhCZAkp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 20:40:45 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA614C06175F
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 17:40:45 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id h8so74754plt.7
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 17:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QHq95NfXxuIqOyKzK+5jC8knS8SaNoe+HdWTjOZyJ2I=;
        b=Q3txB0CM2DZK2O1MQD0z+Rx088W+dw2gTnjE+mXUczbF2WxfpkKvioKgzWxSakQ6TF
         ez/lQqqpTo4YYN3zxGrCbKs8ixLMoGfT+4vLnM7BGsa4uyTMYD94pbQjOoDpwsQxxEhn
         k9vw3F5y5iWcsCM8ZXHSC3AIj4cm3fJ62B5EACmJxe4AT1lzMKno5UZL0faTaH0lM8Er
         WrNr47mad9tm5x/tKYBhhInB4oxZeQPqLt34tnbqLrgeTovzg7UJFERT0Xgi0Y7xBv9L
         fzeqr9/aZ9X4VZb/hyCKV7ccsy5SWSNAnBIcesohjQqqEV5DL7FeCSwqrchR0iKCnl7m
         wzng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QHq95NfXxuIqOyKzK+5jC8knS8SaNoe+HdWTjOZyJ2I=;
        b=LKWh0LPZKFZiWTwe6aQLtCCHghwk7Y53bF51IOENXfF6dpIRJJJ9PWfx3WHtZ/lrbq
         7uwzvbkQRp6baNTXykZ/JhSBDzt03kw03Y5s6M50uvXsUfzUQ8obEFJFPi2yjtKlhaj5
         qSncS5BgWO4ASYT2Aqj1lYrBqC6CStesLLOeug4BS+KW/VU8B036dIYIrGVr+wHj7LiT
         phDnebKTImNU4pDFTPS3tkaMVplXAa/cOYCY6l3xTjFLOxxArjs2zSovgRW9o7zLrhh9
         PRC/ZKo331NnLHzVp/SwBPmv4T93dv9DCQmvtGPc6YOX2N44Ip4o8z6lkV1mFi/2BSuY
         Lufg==
X-Gm-Message-State: AOAM533Ri5hk7Hxnx7pU/tNZmFUSD+Odsr+lmAbjzxpnZhvkDB3qCx0F
        zXErmmuRq50bzm7KgTuCGpG+skLfgxDh1A==
X-Google-Smtp-Source: ABdhPJzJkAntAC8/msvqU0fv/j5DHC7sWLhEQAxva1RVY07UK1qyshtxnY0DJLrTa1AWPxLqJ1cgng==
X-Received: by 2002:a17:90a:2e0d:: with SMTP id q13mr11597598pjd.225.1616719244782;
        Thu, 25 Mar 2021 17:40:44 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id c128sm6899448pfc.76.2021.03.25.17.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 17:40:44 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] Allow signals for IO threads
Date:   Thu, 25 Mar 2021 18:39:23 -0600
Message-Id: <20210326003928.978750-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

As discussed in a previous thread today, the seemingly much saner approach
is just to allow signals (including SIGSTOP) for the PF_IO_WORKER IO
threads. If we just have the threads call get_signal() for
signal_pending(), then everything just falls out naturally with how
we receive and handle signals.

Patch 1 adds support for checking and calling get_signal() from the
regular IO workers, the manager, and the SQPOLL thread. Patch 2 unblocks
SIGSTOP from the default IO thread blocked mask, and the rest just revert
special cases that were put in place for PF_IO_WORKER threads.

With this done, only two special cases remain for PF_IO_WORKER, and they
aren't related to signals so not part of this patchset. But both of them
can go away as well now that we have "real" threads as IO workers, and
then we'll have zero special cases for PF_IO_WORKER.

This passes the usual regression testing, my other usual 24h run has been
kicked off. But I wanted to send this out early.

Thanks to Linus for the suggestion. As with most other good ideas, it's
obvious once you hear it. The fact that we end up with _zero_ special
cases with this is a clear sign that this is the right way to do it
indeed. The fact that this series is 2/3rds revert further drives that
point home. Also thanks to Eric for diligent review on the signal side
of things for the past changes (and hopefully ditto on this series :-))

-- 
Jens Axboe



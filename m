Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC2B3CB8A2
	for <lists+io-uring@lfdr.de>; Fri, 16 Jul 2021 16:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbhGPOZN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Jul 2021 10:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbhGPOZM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Jul 2021 10:25:12 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2353EC06175F
        for <io-uring@vger.kernel.org>; Fri, 16 Jul 2021 07:22:17 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id n24-20020a4ad4180000b029025bcb88a40eso2466618oos.2
        for <io-uring@vger.kernel.org>; Fri, 16 Jul 2021 07:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=+7fCKrO1jFI9Yh5rO9a3BmJRcg7EW2ud4WjZSA8BWE4=;
        b=feADZKkP9IP01Nfhg8RbYNULS+wUzfmssN5NBkyBdeVnxycQcRHkozBF6/lo+HmVXh
         3dyShIUcBmRUamkPXtFUxe52PulShFfqZt2wC1BjUtuA1ZISeKkQG4H1GHreNi5NX/Wh
         1D4W0Foyx7EULkW/FBP7m2zIGN+dVZo7GHSRiy23kMKPpFrR/XXgRHgCL/3HuL/U7FhR
         CQzPm3Mun5NMgBMdgQs2GTbUDYlmSPdAfiYYL5QQN2bfPxK0+HGSE6YkECMyEjLwhuQa
         +Bb5Dif3E5ag5CJtQAk8Jn+8nIlRE6r8bxykQ69yzHlRk9HqtEvipXqJ9tsPVB9dhrmk
         ZPgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=+7fCKrO1jFI9Yh5rO9a3BmJRcg7EW2ud4WjZSA8BWE4=;
        b=gqZBxOIk6Q5NfDI+Wx4tnnn76XvVrMvHoW9mBANHYqiFNwTvqdScTAstAGyhqYe0rB
         /Qu+9OiRfxfkytzjLlTkK3TthZFddncmb//yRfnGlWMROIQ17aNATG2Tx1fQATyxfh+b
         jf1rO/+dqK5yxhS4MHg3z+8nxi1oGETfVf0d/ZQsLhfjoo78pJtkMmpVKfk8NLJJLHLT
         aRzMxhKQYbXZLts+foouTE/mjsGq+2wVTZJvc0JMViZqH2NWPupombyUTRbX0RGdj1qJ
         iQRlo/igePBO7euT2JzKQdOSwFhidUrFPx+yw3LloTlKwZrIuR5h3qwLM8GxXGv2Jiy1
         Hlbg==
X-Gm-Message-State: AOAM531gBM2T06WqoFVbfhZG8cEigWNiAba2SLC9QTDboArC527LJOFm
        YXLRNKku9BzWJarkqesmpdlnVULvaQI0saEj
X-Google-Smtp-Source: ABdhPJxjCrdXBBP6355SshwnRS1S5GoxAO5f2FFBtVfig1YYa6SvUTV5hsGe0crJgtjGVFYfc/rjJw==
X-Received: by 2002:a4a:a542:: with SMTP id s2mr4599595oom.78.1626445336043;
        Fri, 16 Jul 2021 07:22:16 -0700 (PDT)
Received: from [192.168.1.187] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id 59sm1918530oto.3.2021.07.16.07.22.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 07:22:15 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.14-rc
Message-ID: <a74e6303-202e-20b5-2e0d-5cea2f33f95a@kernel.dk>
Date:   Fri, 16 Jul 2021 08:22:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Two small fixes for the 5.14 series, one fixing the process target of a
check, and the other a minor issue with the drain error handling.

Please pull!


The following changes since commit e73f0f0ee7541171d89f2e2491130c7771ba58d3:

  Linux 5.14-rc1 (2021-07-11 15:07:40 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.14-2021-07-16

for you to fetch changes up to 1b48773f9fd09f311d1166ce1dd50652ebe05218:

  io_uring: fix io_drain_req() (2021-07-11 16:39:06 -0600)

----------------------------------------------------------------
io_uring-5.14-2021-07-16

----------------------------------------------------------------
Pavel Begunkov (2):
      io_uring: use right task for exiting checks
      io_uring: fix io_drain_req()

 fs/io_uring.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

-- 
Jens Axboe


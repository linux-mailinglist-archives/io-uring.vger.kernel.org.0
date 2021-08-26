Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8443F8A48
	for <lists+io-uring@lfdr.de>; Thu, 26 Aug 2021 16:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242852AbhHZOmE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 Aug 2021 10:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbhHZOmE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 Aug 2021 10:42:04 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4838C0613C1
        for <io-uring@vger.kernel.org>; Thu, 26 Aug 2021 07:41:16 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id a21so4055280ioq.6
        for <io-uring@vger.kernel.org>; Thu, 26 Aug 2021 07:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=HKG7oHXbkw9fh+XNTL7j0xwuGqGIdaztPjxo/ZkPxdg=;
        b=GFEtdQKcWG2hq27mANMQLkPgsbGWgB6NX4EVawUx9iRCWuTqgSDqeh5vQoP1YpbBZ7
         4QfDYH41x+oXDNEUznBSL1C4wKCJnPXq8nlyOnm7wKEBDVzjPd4R4TLHs3DNvYbhf84y
         7ZIQ5jxVhe0zBBsShuUqRngos7EBcUKNfBDG3DdzHceYCedOnrWNzfmj4DXu35kwxQRt
         0rWe5RNbCIMsrDT0Zi3rSdA95Saf2LlosEm2WpEU91wO/3ERKGWb2RalJUbcVtUrJaJ2
         FRJeVX3CT7NQ0JmZ9xOIsMUm5bO5f4+BZPZeEXCZEQZTOQpdJD4jJ5ddGc/KEWLLBSJD
         Nbrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HKG7oHXbkw9fh+XNTL7j0xwuGqGIdaztPjxo/ZkPxdg=;
        b=XJTGMXQUJjippdHLAT1uPrrWu95urIVQHzZG3eaPhkr4p0nt4BmidNpax5tD5QBoSW
         Ka/m5HHUPD+3D2TXVqnBy7jZrNw9uYxi54g1ffMJm2q/oiEwiPRq6QC3Akh/kmzTJudB
         9cbUQ2zFC/SyXYmTI7HzHkcg/6niWcPo3I7g5kYMKy+Jwllm4qGD7dG7v6S9tYlUFZDE
         6ElUli5vAsz1oyf/eYbQjpuTwAPTwiKFoIfPjzLq20yRRRz1pdWpUU81r4LlkPwqoSdA
         LuoqbHXLgTonOgSRZ+Ad75VvuTdLtsOb7Qb6z0b8N/TxbkffTynQJECIlRRb+ytk5pHK
         ZiiA==
X-Gm-Message-State: AOAM530coOnsDIw7oCjFwVoZiOqNPyOBVRVFRyA8G4teW4hZK1u0o2kp
        9Ns0k40N+eUhCXzvLxm5ve6Avl5Lg65M9Q==
X-Google-Smtp-Source: ABdhPJw455fjR2HvpYmQadDG9dWalYyn9Lw+Lq9qjIfFTiOclaUF3Wtt2elTOjFZbIe5lS3Dy7KNXQ==
X-Received: by 2002:a5d:9d01:: with SMTP id j1mr3344354ioj.27.1629988876000;
        Thu, 26 Aug 2021 07:41:16 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id e14sm1836516ilr.62.2021.08.26.07.41.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Aug 2021 07:41:15 -0700 (PDT)
Subject: Re: [PATCH liburing 1/1] io_uring: update buffer update feature
 testing
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <de5fd2626bd4eabd0eec3eb8310888b4eb1a2539.1629976377.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <32e289c7-58a4-70d6-d091-9ef253c6d316@kernel.dk>
Date:   Thu, 26 Aug 2021 08:41:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <de5fd2626bd4eabd0eec3eb8310888b4eb1a2539.1629976377.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/26/21 5:13 AM, Pavel Begunkov wrote:
> IORING_FEAT_RSRC_TAGS came late, and it's the best way to check if a
> ring supports resource (i.e. buffer or file) tagging and dynamic buffer
> updates.

Applied, thanks.

-- 
Jens Axboe


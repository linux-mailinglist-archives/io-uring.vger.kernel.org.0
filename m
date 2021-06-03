Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD8339A623
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 18:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbhFCQrr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 12:47:47 -0400
Received: from mail-il1-f182.google.com ([209.85.166.182]:34432 "EHLO
        mail-il1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbhFCQrr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 12:47:47 -0400
Received: by mail-il1-f182.google.com with SMTP id r6so6206201ilj.1
        for <io-uring@vger.kernel.org>; Thu, 03 Jun 2021 09:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=MNdMhrQAerKs21fXTdCLWaCZbpJU6Xs9cnqkVNsAZR0=;
        b=0f5AlEEDVWmFK8idmYkwpPx0+claMuUODgNFq4/Eg7N/L0I7VuuwJiCRDxOhLFHDrU
         MMaA4i2AMm0+dX2esFqqvZFbAVX9z3n0dZXpFBmYMOI3WmdACjW4Zp/yIytmJ+pPDwa7
         29acn5UYKzBW3DaZMuADIug7Xlm4+pHpVzrLg3MaGCTsgzmwLSjrNkA9UwUV3AJ/WbN/
         EuungwxUbMcdhnSZBwZdcxjjoLZJh5zRUDqsAHa602hgH4BlGGH8e9iNknqBcQ8USUBx
         Gug6jMgSNqDVn5CrbaBOnvyPDAJCf5sVuodoqf+bv3k+xZqje3KWwJ7Rc45v5MyR4yYm
         MItQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=MNdMhrQAerKs21fXTdCLWaCZbpJU6Xs9cnqkVNsAZR0=;
        b=NxzBWOPHk/HPUxYEumAPlME3mbKUE7LH07ya+3C4SjKqNV7oryp/9rcYhQnLTcaH/p
         /ztgKvLkdGv8ZFH1DJtgRDulLGQoxpYAbUAQ+Q9MkuqweW4gCdrjWBM5j3tmN6FaacxR
         gJ/OQjp5uvtFnTXTzC7kVNZtysbLlS4PCG1T1BPSGLBCSymdw8zGhsCfMTs9315+xtFU
         /mGPkxvsZnls6OyWZouSbm1nU+MSGMqcBcYEg4j7OfpJD60jCcStzRPnTZM4iEDN54AU
         PtpYnC2cgMyDhog4Dx0HIf0qCTHsP2pSIOSMZXGDPA65HocBsk1zFFqxDGQknuV4M8Rx
         MunQ==
X-Gm-Message-State: AOAM531wd2OGWA3iD5+B0NG1kZizmrPsbjlQcHk4q9C5st37zNgR39J3
        AY1MKQ0vmCVx0nv9+5f36s/EPeQbvmQbkraU
X-Google-Smtp-Source: ABdhPJxd729t1NXJAQCHwx9jO4U4QwIfYXHN5L1GFyYYSFOPZ8RqK7in5CRlHKVVNObQLMb76rnQRg==
X-Received: by 2002:a92:d24a:: with SMTP id v10mr228973ilg.246.1622738701888;
        Thu, 03 Jun 2021 09:45:01 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c2sm2234802ils.72.2021.06.03.09.45.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 09:45:01 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 5.13-rc5
Message-ID: <5a3c06eb-eb89-bc0a-7d89-b6c8420bffce@kernel.dk>
Date:   Thu, 3 Jun 2021 10:45:00 -0600
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

Just a single one-liner fix for an accounting regression in this
release. Please pull!


The following changes since commit b16ef427adf31fb4f6522458d37b3fe21d6d03b8:

  io_uring: fix data race to avoid potential NULL-deref (2021-05-27 07:44:49 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.13-2021-06-03

for you to fetch changes up to 216e5835966a709bb87a4d94a7343dd90ab0bd64:

  io_uring: fix misaccounting fix buf pinned pages (2021-05-29 19:27:21 -0600)

----------------------------------------------------------------
io_uring-5.13-2021-06-03

----------------------------------------------------------------
Pavel Begunkov (1):
      io_uring: fix misaccounting fix buf pinned pages

 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE5551B7D79
	for <lists+io-uring@lfdr.de>; Fri, 24 Apr 2020 20:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgDXSDa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Apr 2020 14:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726908AbgDXSDa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Apr 2020 14:03:30 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E5CC09B048
        for <io-uring@vger.kernel.org>; Fri, 24 Apr 2020 11:03:30 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id y26so1426308ioj.2
        for <io-uring@vger.kernel.org>; Fri, 24 Apr 2020 11:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=l9DZkzCjHWvWpAFUFEboMfl5JVZotMAsYoNk7iZWJS0=;
        b=MUKlal7f0QTMDIbBD8mwNCPDsD4bz887lRmnK33mEet2P64rMi8Vdt/2i9wnUocIyI
         XuuV8O8JLZM4TxpdTeaM6BzaVw2V3bIbeNprvtXp0QsdlQe9z+PyTQbZ6394kJ2tlf0r
         wMNlD88pAn1GCrzaHbDY9MiyovI+WDXb70koPCM/7N3yIwXC24BfdxKgcj5gNZaRE4xD
         9mDNc8xTTvOj7wQ27RdvrSPMxgT+dlxPvVhIJ6oB/EAp8mIBn/y1V4k5sHBFBj4taT21
         jlirb9cG3XjaNWCBY6u/xNiEvOAPibinQFajatGA4cpvFm/xQlRMmuuSF6p81PgiiAzB
         vIGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=l9DZkzCjHWvWpAFUFEboMfl5JVZotMAsYoNk7iZWJS0=;
        b=fE2OE+WeVinUvRXUsE2JFw7ik4laH6Rrz9BZdyPav9XGWebsmvtg6SPKUip3OikRYr
         U1F26vvW6WnvAr5mbiobs0aU8buxZJMRtNt7rlB7zyr2EOzcd4zmw5aoCv/CZKzxo3We
         4WDKmzp2+gzZhGzCJKkHtBFO8BeuR+ZvTmvFnlNWo0CbrPWsEmEPYN9Xyj5EsKVOBLnn
         Q1vUqIFtXLp5E+jHOYgd14CIYtl/FhEWB9I3yi4Lz0ksexCKwP1jAAJVmdew9ksy0ic1
         WLxYITAdhZgXbRbjRsRY0wjm757ivR4RE+M+uSkiz2or1te9HaM+/FY680tMbFsPQbjN
         z9zg==
X-Gm-Message-State: AGi0PuYOiPCQ4fdZBg5PKoUahm2luGUqMUhbtyoGItObgXxan+ZKDMNL
        5HLzhhJdGdyPDjWtMa6/5IEEoNGg9pYkgQ==
X-Google-Smtp-Source: APiQypLiBb6pQAayp6kyLN7BnySABnVTZSw+CHHuZ4vQXAsd/3B4Bc5CFHJtmvahPb0r6NhZxQdEiQ==
X-Received: by 2002:a02:a90e:: with SMTP id n14mr9230294jam.97.1587751409829;
        Fri, 24 Apr 2020 11:03:29 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g90sm2329941ila.19.2020.04.24.11.03.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2020 11:03:29 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 5.7-rc3
Message-ID: <156f8353-5841-39ad-3bc2-af9cadac3c71@kernel.dk>
Date:   Fri, 24 Apr 2020 12:03:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Single fixup for a change that went into -rc2, please pull.


  git://git.kernel.dk/linux-block.git tags/io_uring-5.7-2020-04-24


----------------------------------------------------------------
Xiaoguang Wang (1):
      io_uring: only restore req->work for req that needs do completion

 fs/io_uring.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

-- 
Jens Axboe


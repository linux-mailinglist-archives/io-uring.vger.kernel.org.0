Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1F03460B7
	for <lists+io-uring@lfdr.de>; Tue, 23 Mar 2021 14:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbhCWN7X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Mar 2021 09:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232089AbhCWN7H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Mar 2021 09:59:07 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173D2C061763
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 06:59:07 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id e8so17766480iok.5
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 06:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=QmGmorsZ3uWXV6V2bIx2C7e1778VbasbJ6q3lPceZHc=;
        b=hauhv4gcfma+k/tVhHSLMAEZ3g7jfQtIBEj6clWfrrD4+Qif6UTXqSCrCoi8b+FIwb
         Luh9TlUEx0VfWi9MjfnTvZsosm0Uh8SyHynOuY1D25pRISwwQVin3v5uHUeSIw7YWNWd
         bo2KHITDwfItpYl5xRT40kqXhny16Qgs1KuE3PRM7enU1rZ7cOslCcbR/ZXxB/h18cS/
         +aqinV2z//Jq+xMk5ASl+wFp5UZbyzTfE7dymxlZkFn5qFOmsyQubqZ7KpPT0sfp4LMh
         jmXB95NG1nbCAFsrgzj2jENStA+eiyWAmlhh22ZS7SlIXAWOKRVMMPogOWsxPz+6khTR
         bNdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QmGmorsZ3uWXV6V2bIx2C7e1778VbasbJ6q3lPceZHc=;
        b=TuMqrI0Gl45Hi5qNNXmZKPSfWzSlNPCh5k1CJwwcOWt1IFzAXb77yBmk1GO1jqUIBz
         2UnF8xFRG0hlxoUIZr5JCw3BLNvUWWTUpt9ogXCzfn9QSQev/B7Z5TXTOT9zJyA6iUPR
         0m3wnAe82Asm90wi3eY3nA7RzbyV/MYl+G/omrCaFH1Uv0PMgwD8HLMXVEFSWACHhCf5
         UejiGZeeq0Ni6k6TByfmDkTDEsREB/rHQgIMer5Aqyvz/3a5IAvhEVLzwkTKlqSz3zC+
         PWyG5afpRuT9XraT255mEhPQQGCLr6tWo2r+5EjGFcCPC7dcXETjMW5cSL8HIu+R7qbf
         ytBQ==
X-Gm-Message-State: AOAM5319cI9qwRHJwPaomQnuDYtDZ7JjersZ1pn30c0qiAhZG8N0guPB
        SKqcweF27yEgbLByaRsoG0t3sQ==
X-Google-Smtp-Source: ABdhPJxemjx6fLssTgbfLIb/YalUsh6ozffPoZbHbfN/wUgRY6oK3A6IGpkP9A/sj70LMp74UnrcvQ==
X-Received: by 2002:a5e:8902:: with SMTP id k2mr4398137ioj.48.1616507945796;
        Tue, 23 Mar 2021 06:59:05 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k12sm9180045ios.2.2021.03.23.06.59.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 06:59:05 -0700 (PDT)
Subject: Re: [syzbot] WARNING in io_wq_destroy
To:     syzbot <syzbot+831debb250650baf4827@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000077ef5d05be23841a@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e339a963-8ccf-eb47-c155-640b848f29a7@kernel.dk>
Date:   Tue, 23 Mar 2021 07:59:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <00000000000077ef5d05be23841a@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

#syz test: git://git.kernel.dk/linux-block wq-no-manager

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7951569CA
	for <lists+io-uring@lfdr.de>; Sun,  9 Feb 2020 10:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgBIJZH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 9 Feb 2020 04:25:07 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35507 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgBIJZH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 9 Feb 2020 04:25:07 -0500
Received: by mail-lj1-f196.google.com with SMTP id q8so3792788ljb.2
        for <io-uring@vger.kernel.org>; Sun, 09 Feb 2020 01:25:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=pU5TDhLWBeUO+uU4r1uIheviJ3XNxen/j06LtX2Qy7w=;
        b=J5pReuB8BDnuCdm/NyNgltzMzzTIWUkY3jsVZ0Ybg8PEyaKhHE9v11HE7pc8NeW10r
         ygINW2mOpLgDr5/wjwGrBfPdCelDz1h6eUtTunj5A0Shiwr39lPEhOh4QNKEYH650WhK
         z2YWhdKCwlvLllmMMPCoIaxDMKoYFKFQqHTujFfYvSIlkUfkClSnQegFLp9Mp9Rmimon
         g2pP7EodNrh7v578eH/UaPVVtGfTknGl9Xk7Bo/vba4wJhEQgMDNgdE4ttTrA/PvSM2L
         pjlq6B0Z3ybp007kI+86/aMEJ5MV6jb/I2zEbfba7CoqbFqCCpne7oUmRA2Xzq3whzj0
         CEgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=pU5TDhLWBeUO+uU4r1uIheviJ3XNxen/j06LtX2Qy7w=;
        b=P8H4iwzvZ7ddfaVtVbIiwnIg5cA1YZvm5qXOAH9+ov8h4diHfSEOe/+71BxItacZ58
         dczI6jEJLtDIIS0iCiEj+CiwVttV02KHUNgbiM01vnFbappdyCbPkIQ+KgFlYbGdbti+
         QUK8juPDiXfZfAGu/wATglLLb3Ch2dxHn/sstbH+BacT44T610nBzpkPwwOGUsXWoJtW
         Jk2LKvAvpXELMFpoUM/P7pky37v4dk6UFiqmmJlBAWOd9pFRGPKgH85onRWQyk8Iq01e
         DUQHCatd2qTQfG3ztRsXDXgQjLMJ3KgVddNW1PL6FRh7EWDmDs8w+/9WFhtP1AW37Ulp
         H4Wg==
X-Gm-Message-State: APjAAAVcOUl2NWP20JGtqhYrJdwJMzLA6+C9Vgc+rEvgOHRaJS3WRtwa
        Pkb/WrigY7RjDw2mFStiko0F0ejTn6Q=
X-Google-Smtp-Source: APXvYqwNaiawiXskNMi9KYzhJ0uZmvpGiyEAnm/MZnb1BW0DVFPcDtCePuYM1hCg/CPDa4qPTlCwXQ==
X-Received: by 2002:a2e:8758:: with SMTP id q24mr4813717ljj.157.1581240305159;
        Sun, 09 Feb 2020 01:25:05 -0800 (PST)
Received: from [192.168.1.169] (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id u24sm4282091ljo.77.2020.02.09.01.25.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Feb 2020 01:25:04 -0800 (PST)
To:     axboe@kernel.dk, io-uring@vger.kernel.org
From:   Jonas Bonn <jonas@norrbonn.se>
Subject: sendmsg fails when it 'blocks'
Message-ID: <6b909e30-c31c-b7f0-fa3a-d30d287ce427@norrbonn.se>
Date:   Sun, 9 Feb 2020 10:25:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

I've been trying to use io_uring to flood a network link with UDP 
packets.  Essentially, the program just pushes a series of sendmsg() 
calls through the SQE ring and keeps topping it up with new calls as 
soon as the completions come in.

When the sendmsg() calls complete immediately then everything works 
fine; however, when the calls 'block' and get queued up in the kernel 
then the calls return either errno 97 or 22 when they're retried through 
the workqueue (effectively, bad address or invalid iovec length).

My gut-feeling is that there's some issue copying the msghdr struct so 
that the call that's retried isn't exactly the same one that was 
requested.  I looked into the kernel code a bit, but couldn't really 
make heads or tails of it so I though I'd ask for some input while I 
keep investigating.

I noticed that liburing has a simple test for sendmsg that sends a 
single message; the 'punted' case doesn't seem to be tested.  Is this 
something you've tried?

Tested on kernels 5.3 to 5.6-pre and the behaviour's pretty much the 
same with regards to the above.

Any help greatly appreciated.

Best regards,
Jonas

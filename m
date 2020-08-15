Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7940F2454A8
	for <lists+io-uring@lfdr.de>; Sun, 16 Aug 2020 00:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgHOWfF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 18:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgHOWfE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Aug 2020 18:35:04 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DABC061786
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 15:35:04 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id kr4so5976329pjb.2
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 15:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j/sU35HCkWWZOIZQlsEn2q5VqwHb4S143hXRigp+iok=;
        b=r0jk8+5axvRErT2hEKPKLTXmuvmSj0Uf6Z0zvipwp2VEyLzZ4Ajv83f+j6HmQZjUlR
         +G7dNhJY6TDaevLEEhlKulcN4pmZqwzsgHQUtTbguH5Lb2d2fk3G7s/dsBeD8CvcRgDv
         RNtZGcRE1t6Uq2/taxoWbovqaYHvuv9AhzQgPrMTmJw+BVQ7Z65/RZB9NVEZYom/Qf5g
         wejbQtcKTpYvSuc1dFgBlNbVZRlx2wHoHvsw7qKXo7+OkXdgayoRJIWIplvh0eC/6Ibd
         SubgQO2NO2ATxkeeOCwVVm0FIwCWEU43qg5XVO41/y1WHZEjmZ7lPtfYLwZnnvq59vz1
         82UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j/sU35HCkWWZOIZQlsEn2q5VqwHb4S143hXRigp+iok=;
        b=P2O+ZtP2JHU95ntfzmco3JfXnGdt5Dm6i8TCqHKIGdLEdEDBGo0KyO7KO+43mWWyL8
         VljB56GDQWTRB/YbhxcNSc5oVoz4tSpEiTKQvkMgb43cJOvyXOCMx8po5U1ebPcnBB1y
         1hMDW6uTJ5EDBiaSqHszHduZ73ugjqlgTp1AFQR1wX9XlHF2azLzRgrLYxxqgrSiUDk3
         /s686v4ILZEUgNEr0oh6JN7aRFN3lLGl5/TFviiPa4DRGIpzOXLWBEmuRCmXbaoVoDNJ
         6iEIBa3fQeHzY96ajHnc+BS+L/i4bxi8UP+ZIcYqp2iHMTIzNJkrsxY7JH/WIxulnaTA
         Gn3g==
X-Gm-Message-State: AOAM532jioh9amIY42wCPLZ83XUO/NYU98v+7u5g38bpOzMs5RFGs2qx
        vIN+iinmlmdhMDGopaw/x+pHx6quXiuZAQ==
X-Google-Smtp-Source: ABdhPJzQhbVwcpcA3n0m3zC/pSDgD9CNwNL4qJOpUAgRVt24dgImXVVhjgisF3o8Mg3SZPOTTmkDiw==
X-Received: by 2002:a17:902:8601:: with SMTP id f1mr6323242plo.272.1597530902315;
        Sat, 15 Aug 2020 15:35:02 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:6299:2df1:e468:6351? ([2605:e000:100e:8c61:6299:2df1:e468:6351])
        by smtp.gmail.com with ESMTPSA id y1sm14157445pfr.207.2020.08.15.15.35.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2020 15:35:01 -0700 (PDT)
Subject: Re: io_uring process termination/killing is not working
To:     Josef <josef.grieb@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     norman@apache.org
References: <CAAss7+pf+CGQiSDM8_fhsHRwjWUxESPcJMhOOsDOitqePQxCrg@mail.gmail.com>
 <dc3562d8-dc67-c623-36ee-38885b4c1682@kernel.dk>
 <8e734ada-7f28-22df-5f30-027aca3695d1@gmail.com>
 <5fa9e01f-137d-b0f8-211a-975c7ed56419@gmail.com>
 <d0d1f797-c958-ac17-1f11-96f6ba6dbf37@gmail.com>
 <d0621b79-4277-a9ad-208e-b60153c08d15@kernel.dk>
 <bb45665c-1311-807d-5a03-459cf3cbd103@gmail.com>
 <d06c7f29-726b-d46a-8c51-0dc47ef374ad@kernel.dk>
 <63024e23-2b71-937a-6759-17916743c16c@gmail.com>
 <CAAss7+qGqCpp8dWpDR2rVJERwtV7r=9vEajOMqbhkSQ8Y-yteQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fa0c9555-d6bc-33a3-b6d1-6a95a744c69f@kernel.dk>
Date:   Sat, 15 Aug 2020 15:35:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+qGqCpp8dWpDR2rVJERwtV7r=9vEajOMqbhkSQ8Y-yteQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/15/20 2:43 PM, Josef wrote:
> it seems to be that read event doesn't work properly, but I'm not sure
> if it is related to what Pavel mentioned
> poll<link>accept works but not poll<link>read -> cqe still receives
> poll event but no read event, however I received a read event after
> the third request via telnet
> 
> I just tested https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commit/?h=io_uring-5.9&id=d4e7cd36a90e38e0276d6ce0c20f5ccef17ec38c
> and
> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commit/?h=io_uring-5.9&id=227c0c9673d86732995474d277f84e08ee763e46
> (but it works on Linux 5.7)

I'll take a look. BTW, you seem to be using links in a funny way. You set the
IOSQE_IO_LINK on the start of a link chain, and then the chain stops when
you _don't_ have that flag set. You just set it on everything, then
work-around it with a NOP?

For this example, only the poll should have IOSQE_IO_LINK set, accept
and read should not.

This isn't causing your issue, just wanted to clarify how links are
used.

-- 
Jens Axboe


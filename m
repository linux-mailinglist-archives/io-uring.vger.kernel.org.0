Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101092459D3
	for <lists+io-uring@lfdr.de>; Mon, 17 Aug 2020 00:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbgHPWRb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Aug 2020 18:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbgHPWRb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Aug 2020 18:17:31 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD32C061786
        for <io-uring@vger.kernel.org>; Sun, 16 Aug 2020 15:17:30 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id g7so5407293plq.1
        for <io-uring@vger.kernel.org>; Sun, 16 Aug 2020 15:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0PIjtU76QMFymGa/Gzz2lsam6AFoot0XwLF7rVK2HiA=;
        b=FOoHa43tZ9t6D+xXyQKFHUeEJI3gIAsYkoTZCHCIKMBy5orgHoJCzlSxTsNJJxRYki
         9OkQlOvPJ6cQRKcrOxkRSTVdpiN1xI3yWwVcQhPx+fo2H+vW4zu2EfwnBUBmBgnf60G1
         JamPqarto70A8jDs0wW1JtFNIDJJPVsHCIuwjx0WpJKCz9NlQM4uWpZ93+KGUx+Jkpao
         iRn9adYJ+AHUN7n5WGvAo4W8a4aZtmBPcS+IaPBg4Aqto0aspHwm1q7IswpaDrnkCne7
         1ZAWZ+1UeKY0lKPG1zTNGEcQojwivsXu0Xho6S7xYpVd1Uj+Em1INCyw3fVpm9gyj+s5
         wawg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0PIjtU76QMFymGa/Gzz2lsam6AFoot0XwLF7rVK2HiA=;
        b=uIcLZhnikKG70Poi/DHkPovKfuKiMh6YE6BUphSPQ9lp3rJl4N4BEcM1yHw7lItSJN
         Yi/iKly6JTElANVN1Mtq3e5P9Za6uIZXWCsk2VLkpZl8poPpkO/urpy+kGtgQWjGUbCu
         y/8utItl3x6paD9PHeThYW87s39+ynBKBIEm9aYdtEorBiYwPHMVknZ+3VwnBrj9ph0n
         /e55/ot+WH8vgJhuSyZZryVuaQ1nFgon0sVw1ZzQTJo6bZio4pJokccNmLQMtpM+u7j9
         P4OZKixQZ2DPaPccjAwK4ZOLkiZIHq9kUMq6ArRxtb2N7qd0/wZIqHEzYcBLfY69JvZW
         LNWQ==
X-Gm-Message-State: AOAM532blOur37HImVhq8qzS9bnGXdEVSmOeVSFHJPeCEBYh44Pn4nop
        BshyK50HaYzstS36kXMqqSJ+Bg==
X-Google-Smtp-Source: ABdhPJyl0J/UuszAym7nxsQ1ewZbUQ3S/M3jEK5TRL+JBtQZ7WIptObSWaM+b/9hUEjxpdfrozxYGQ==
X-Received: by 2002:a17:90b:391:: with SMTP id ga17mr10110495pjb.75.1597616250380;
        Sun, 16 Aug 2020 15:17:30 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ea1b:63b0:364:3a3b? ([2605:e000:100e:8c61:ea1b:63b0:364:3a3b])
        by smtp.gmail.com with ESMTPSA id f195sm15767278pfa.96.2020.08.16.15.17.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2020 15:17:29 -0700 (PDT)
Subject: Re: io_uring process termination/killing is not working
To:     Josef <josef.grieb@gmail.com>, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     norman@apache.org
References: <CAAss7+pf+CGQiSDM8_fhsHRwjWUxESPcJMhOOsDOitqePQxCrg@mail.gmail.com>
 <8e734ada-7f28-22df-5f30-027aca3695d1@gmail.com>
 <5fa9e01f-137d-b0f8-211a-975c7ed56419@gmail.com>
 <d0d1f797-c958-ac17-1f11-96f6ba6dbf37@gmail.com>
 <d0621b79-4277-a9ad-208e-b60153c08d15@kernel.dk>
 <bb45665c-1311-807d-5a03-459cf3cbd103@gmail.com>
 <d06c7f29-726b-d46a-8c51-0dc47ef374ad@kernel.dk>
 <63024e23-2b71-937a-6759-17916743c16c@gmail.com>
 <CAAss7+qGqCpp8dWpDR2rVJERwtV7r=9vEajOMqbhkSQ8Y-yteQ@mail.gmail.com>
 <fa0c9555-d6bc-33a3-b6d1-6a95a744c69f@kernel.dk>
 <904b4d74-09ec-0bd3-030a-59b09fb1a7da@kernel.dk>
 <CAAss7+r8CZMVmxj0_mHTPUVbp3BzT4LGa2uEUjCK1NpXQnDkdw@mail.gmail.com>
 <390e6d95-040b-404e-58c4-d633d6d0041d@kernel.dk>
 <63b47134-ad9c-4305-3a19-8c5deb7da686@kernel.dk>
 <CAAss7+o+py+ui=nbW03V_RADxnTE6Dz9q229rnpn+YeWu5GP=w@mail.gmail.com>
 <689aa6e9-bfff-3353-fc09-d8dec49485bd@kernel.dk>
 <b35ac93e-cf5f-ee98-404d-358674d51075@kernel.dk>
 <CAAss7+qHUNSX7xxQE6L1Upc2jYj-jLPaGMH+O1e30oF2nrmjCw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e51a81ed-075c-d90f-96cc-995d89f15143@kernel.dk>
Date:   Sun, 16 Aug 2020 15:17:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+qHUNSX7xxQE6L1Upc2jYj-jLPaGMH+O1e30oF2nrmjCw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/16/20 2:09 PM, Josef wrote:
>> BTW, something I think you're aware of, but wanted to bring up
>> explicitly - if IORING_FEAT_FAST_POLL is available in the ring features,
>> then you generally don't want/need to link potentially blocking requests
>> on pollable files with a poll in front. io_uring will do this
>> internally, and save you an sqe and completion event for each of these
>> types of requests.
>>
>> Your test case is a perfect example of that, neither the accept nor the
>> socket read would need a poll linked in front of them, as they are both
>> pollable file types and will not trigger use of an async thread to wait
>> for the event. Instead an internal poll is armed which will trigger the
>> issue of that request, when the socket is ready.
> 
> I agree as well I don't need a poll linked in font of read event, but
> not for the non blocking accept event because of this fix in Linux
> 5.8:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.8&id=e697deed834de15d2322d0619d51893022c90ea2
> I receive an immediate response to tell if there's ever any data
> there, same behaviour like accept non blocking socket, that’s why I
> use poll link to avoid that

Gotcha, yes for that case it can be useful.

-- 
Jens Axboe


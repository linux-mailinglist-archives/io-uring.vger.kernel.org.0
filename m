Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 891031FF53D
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2020 16:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgFROqC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Jun 2020 10:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731163AbgFROpv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Jun 2020 10:45:51 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFBA7C0613EE
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 07:45:50 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id a45so3465262pje.1
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 07:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:reply-to:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6TJGIJvxRU3/FP2D5UWHIPKUljwj6FtPSf0qcsjhvug=;
        b=LAeJhpPiAtrpepJIiAaLY0wLXiK4u2+g3dQkSC7lKAz3rdC/cnOg8aVrqdF285hT8g
         i8rg5B8ADSy1tNrRdakuAhVapyGbryTTpQPW6Hp3ur50Mcqex364RhE/PTUR9Fn/D/Ix
         cDov7gxVNuys85ikoqma/FU1D0BwVQjtSsVymDD2hEfiKA6ZvQ1/yhSriDNO4ZkWvHht
         GhQlhcSV4aZkLXflV8vPz3RGO8R/SBn/4aL3dJ5fQY8qSDcL3GIlLS6t4m6nuJuaUAtq
         u3xifsGPLcPYkFMJ0Rk0ggiuwj7q8oC8uwGOcHiGYc6rmxlAoGmJHBbbdDcsz6g9RbFA
         uqMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:reply-to:references
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=6TJGIJvxRU3/FP2D5UWHIPKUljwj6FtPSf0qcsjhvug=;
        b=Gup8Gyoi+w+ltgbCTMkNJRz+Q5Ttt/Lt+OfcQ2YLHNxPcb9YEJJOqyyTEbg1jXd907
         wT0TXN+paQeV4XY1piVQ300HYTYu2UuKwqAwivOzIlhA4VubXa9s6Agf99RdgQAeXaay
         dpN7YrnjWVJ3JcYSIxEzDq/XcesiMxW7si/Hp6IUNVypu/mSMYY18dRsfLkTBHH4G278
         YwwYVyP89+PjDBdIEmBIo+W2pURc78hK5Rwv5rEJsAKhe8IGHA8wkJjtF2ed+MCuvZSE
         soh5vB/OoehfMSWGCwAM9IUO+bSh0jcxcgmYVUCoKXepNvbsiptQNJ9PqeEgA4yHsxVS
         LelQ==
X-Gm-Message-State: AOAM531m7/gIsNnGPkr1NMCukSqT1+YswESWWFXLhryMe9EDL0vAtDJ/
        BsQguXb9kk0MilmzlrXFooIriA==
X-Google-Smtp-Source: ABdhPJww4iAnPdbI25dLZRoS1xt8Bv1S8uiS5WUlFuHWiU/e5DpdHUErjsapzN/iQPLkpsAfxAGqZw==
X-Received: by 2002:a17:902:b284:: with SMTP id u4mr1639733plr.236.1592491548672;
        Thu, 18 Jun 2020 07:45:48 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y136sm3280004pfg.55.2020.06.18.07.45.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 07:45:48 -0700 (PDT)
Subject: [PATCHSET v7 0/12] Add support for async buffered reads
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org
Reply-To: "[PATCHSET v7 0/15]"@vger.kernel.org, Add@vger.kernel.org,
          support@vger.kernel.org, for@vger.kernel.org,
          async@vger.kernel.org, buffered@vger.kernel.org,
          reads@vger.kernel.org
References: <20200618144355.17324-1-axboe@kernel.dk>
Message-ID: <e8081674-00e8-e129-21c4-8d05d4e4ce4c@kernel.dk>
Date:   Thu, 18 Jun 2020 08:45:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200618144355.17324-1-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/18/20 8:43 AM, Jens Axboe wrote:
> We technically support this already through io_uring, but it's
> implemented with a thread backend to support cases where we would
> block. This isn't ideal.

Apparently I'm cursed when I send these out, corrected the subject
line to indicate this is v7 of the series...

-- 
Jens Axboe


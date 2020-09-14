Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03422699A4
	for <lists+io-uring@lfdr.de>; Tue, 15 Sep 2020 01:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgINX0w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Sep 2020 19:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbgINX0t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Sep 2020 19:26:49 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789F1C06174A
        for <io-uring@vger.kernel.org>; Mon, 14 Sep 2020 16:26:49 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id v14so747960pjd.4
        for <io-uring@vger.kernel.org>; Mon, 14 Sep 2020 16:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6pCCOzEE9dEFQrQzi8p67AcleJM9Eir1kWdBwug67hI=;
        b=g86WFEp5HbEZSrcXqeOVxKQ9EI7cY8l7AYpupxJiL8p69DfZDmHtPoe3Y0PP1ZjZaR
         DJXJ4PeRmwCYoHXVtLtLJurnTuBS+kpCf0SJ0LJeNTNFfZdQht/BakKsvpXJGMcBUWg/
         D5EwP8Tq9th1QUAIisFbByyOuY6fmSfNrHJs2Fa91VF3mSf7sSNuIxbYgw+a4/1R4HRa
         5JBeAaO8it15qY6Q/VVzTD70OuBXG8MaKwimKwIy4FTAiUszYahDxpLRNSZax+sVY6sZ
         psJwM+Uy7ApSTtZ1JfrqTw3i9znkSbSt3X12SlmElXAltTkPtvxTPFLDJyLdS+klXT3H
         eYmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6pCCOzEE9dEFQrQzi8p67AcleJM9Eir1kWdBwug67hI=;
        b=XjbKYvPwGk5Jie2d20WGyPazM3Wl0ThMVClGctD0X9NfhKV+YFCjGlGoX7VO3VGx4O
         FH0KYYlyAbhICbZc48JtRYPXL8JgFwWKAINSayGv6cddJl7KIPtEC+wDeDLx9AtW2QvO
         8TWD8t86YFQwg5BwgnP7CCLrp+PLh2fhoziLKAC/XzWNAnoDFyqoK9w7wyJw4TTwPNfc
         WwheLTgSsxc9s1IqEadx96rEBHBFU8cAwtgKZfrBnejjS7jpexQtup8peuZmmFzDeXOt
         guptvGhhGTytijWM6EeXVTerK3noclXCXXouYwTQ24Z2Y/CmphrGpw8gIi2jReId8/eT
         ujdA==
X-Gm-Message-State: AOAM530vHYqtzdJRDr71swrwo2H8DS11iIpx833ic4EA23w/ZoKDzoB1
        DJzIAxzApdM1NHDCaw5CngZ7qQ==
X-Google-Smtp-Source: ABdhPJzb/9/UoL/tiIlli8ekjPDg359tokMA8KR6qJJ55jjIThBK/tM0G8FxnAY+6looFESb5UnU1g==
X-Received: by 2002:a17:90a:4d84:: with SMTP id m4mr1476917pjh.59.1600126008933;
        Mon, 14 Sep 2020 16:26:48 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id fs24sm10127592pjb.8.2020.09.14.16.26.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2020 16:26:48 -0700 (PDT)
Subject: Re: [RFC PATCH for-next] io_uring: clear IORING_SQ_NEED_WAKEUP for
 all ctxes accordingly when waken up
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, joseph.qi@linux.alibaba.com
References: <20200913134427.1592-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b1ecef07-8a9f-96d4-7035-27d63bf0f897@kernel.dk>
Date:   Mon, 14 Sep 2020 17:26:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200913134427.1592-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/13/20 7:44 AM, Xiaoguang Wang wrote:
> When poll thread is waken up, should clear all ctxes' IORING_SQ_NEED_WAKEUP
> flag, otherwise apps will always enter kernel to submit reqs.

Thanks, I'm going to fold this in, as I folded in the referenced fix
as well.

-- 
Jens Axboe


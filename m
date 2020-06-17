Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7551FD0D3
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2020 17:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgFQPXw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Jun 2020 11:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbgFQPXv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Jun 2020 11:23:51 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C144C06174E
        for <io-uring@vger.kernel.org>; Wed, 17 Jun 2020 08:23:51 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id k6so1074828pll.9
        for <io-uring@vger.kernel.org>; Wed, 17 Jun 2020 08:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Lw00I39tMMHoHHOPSgKttYErvt005RuGUQAb9q20a8A=;
        b=PwuULeo6Tx+uQ03j/9akMN5V2BXuJjbCsr/knfYOcunAdXjiqENTtNuzVnTaJWf8dD
         35bEpl1eMoZ9DQHJfRWiTP2Hk38Ggu4F4mpgcEatZ9iiIKb47A8u3RL9opqlCG0XMhAe
         RGYFXBYgRjJrAhslad0b1pf/z0tw7oGDjOKjm4RZYD0klf93OzjBodAcbhvnu6+DAlkT
         UWHu+hBTZ8MHIaQzuwXebdlvCOIXwG5brfCOgEGc1LD7gHBHSNCTaJ3X26Wk9J8IkbXj
         YNdqDSsX3jNZ2c77QOeYSgZ/ZZW+/UvAab7CEChPgjvTkxxZW9VNVNCd7lG0FYMg3iqv
         wp9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Lw00I39tMMHoHHOPSgKttYErvt005RuGUQAb9q20a8A=;
        b=hgp3m7CTzR0uVT3X2jsyZ80cD9S1jgkOWMHAYNPbS/nT9ogWX0yRgbtYU0Gy6eLDwA
         Lw7XvURYs8uGGx723DwVUBBxjhydOl2T7DvGddB7GeA840Kz6Gz2CjfzweA1l9N9My7a
         oy/JivHj04QDk0TKUaNrd16npYFajU2yv4tkxYWPl8tMcNXtbBO8zpXcq+c0P9eFgvOS
         cvA++Uu3V3FXF04Pqq32SPzNDLL37ZvkldveJ+4+wjNkd0MBHmr4T5Tn+WOVS+wO/5DG
         x+5Sa39KHtHXmbKZUZrk+4Y33DndVmpaZxZ19NSYwZHQ797w7zP3+3HtG7KCAxxHs/Oe
         lMAA==
X-Gm-Message-State: AOAM5323MFidvqsKkZlH3z6yPGxtKwn9cq8+xj4cr9vcFx+f18TEnaJO
        2QwCjHlkT1bIyK1SItPgkCvEhEvP/RMZIA==
X-Google-Smtp-Source: ABdhPJwiIEmcZmmJg1jLbboAt7jJnAuBWyMTjhYlSPz2B2gvYsfDfRbSkaZ+ohei1fB3yW1Jel7sLw==
X-Received: by 2002:a17:90a:24a4:: with SMTP id i33mr9053467pje.102.1592407430452;
        Wed, 17 Jun 2020 08:23:50 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d25sm227852pgn.2.2020.06.17.08.23.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 08:23:49 -0700 (PDT)
Subject: Re: [PATCH v2] change poll_events to 32 bits to cover EPOLLEXCLUSIVE
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <1592388799-102449-1-git-send-email-jiufei.xue@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <822a990d-da0f-6eb8-e372-5a287195d155@kernel.dk>
Date:   Wed, 17 Jun 2020 09:23:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1592388799-102449-1-git-send-email-jiufei.xue@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Applied, thanks.

-- 
Jens Axboe


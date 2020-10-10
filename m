Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C0328A3F3
	for <lists+io-uring@lfdr.de>; Sun, 11 Oct 2020 01:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730298AbgJJWzg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Oct 2020 18:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730325AbgJJSt6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Oct 2020 14:49:58 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D226C05BD39
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 11:49:53 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 34so10118485pgo.13
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 11:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BysODuNQoR0TQQ9MOChKMm3d+TeWdeGngEJ/MiHdwQg=;
        b=0vFVms3TqGaWU/x1vZklAiYSy59yMCc5avtcbXMNCW2ebjW8eU3OoNwm9e2nLzTLpA
         5Bs5UTy39Kuyk3cmZgGBS1QVtyCoj4J+bi9YWO9oo/84UiqnoSvf5JL/JhP6fSxndaFw
         oHlj2URxhSsVOtn5M8EvRlCCO2bCu6PiLk48OQ001/Bpm1cflq25Y+XUJZVnvx6DsSK0
         0FayqHHk+kL8i32Le4itCWYhEwlDGADc2S9sTj4BtngHdPJrXn8sd5UQ2+1SDZh4Zd4f
         sC7IXJpuSmZwLChYGykZpS+coTniim4Yk3/R+4HgPSU16xRuUGTRwyPdWjhI+cy0pOYo
         6neg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BysODuNQoR0TQQ9MOChKMm3d+TeWdeGngEJ/MiHdwQg=;
        b=dUS+hn+xMTlBsLzaHTF7vCJDXTQLwYnfjOlebEhFnDAOTgRpf/a4uYycCZyIdu8ez+
         6eVyNYtbTUixMkU2DT5Y/srbjwl6o04vFdFvXNwlW2F2E4oKg02VBBkjCzUiajFBuL1f
         dqxNOEq5tXhYYO+gjSUYVGQ1gaPAztn1Ppa8mTF1nASgZl4TmgYJMJNM57Q5f2cAos7c
         Vhv68PO6VVprp5cPahieaaRywjdB/fXO78ePJIJZb77h5QzzpTEs/4wFsa1H0Ta37H0t
         HPE6zVTpEENRULClEOrCHB0INxHbSyH7CzPrRjv/GFs1JgbBb9x1HoC75vSbnqLy8whH
         6G5g==
X-Gm-Message-State: AOAM533dn7NIEP4iHWRg0Ksxc5vhO2G5L442a5dwo9vyRVAXryIZs2r5
        g/M2nF2/r4VErP8eVpCWt6V/CQ==
X-Google-Smtp-Source: ABdhPJxSlE+CLHlZoMaFBnpn+A0//iloOZZtN7C8iUDJxwzu7N65VaAvE9ULFRbaZAdG6VBL9JFVBw==
X-Received: by 2002:a05:6a00:887:b029:142:2501:396f with SMTP id q7-20020a056a000887b02901422501396fmr17424278pfj.52.1602355792643;
        Sat, 10 Oct 2020 11:49:52 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id f12sm8629313pju.18.2020.10.10.11.49.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Oct 2020 11:49:52 -0700 (PDT)
Subject: Re: [PATCH 01/12] io_uring: don't io_prep_async_work() linked reqs
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     "Reported-by : Roman Gershman" <romger@amazon.com>
References: <cover.1602350805.git.asml.silence@gmail.com>
 <26fb33734fee5294f3d20b8be9cf52848056a630.1602350805.git.asml.silence@gmail.com>
 <4b92981a-5469-615f-02e6-6f3f75d7ff3f@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0100dd0b-41fa-08c0-7644-5a06b9553a1e@kernel.dk>
Date:   Sat, 10 Oct 2020 12:49:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4b92981a-5469-615f-02e6-6f3f75d7ff3f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/10/20 12:45 PM, Pavel Begunkov wrote:
> On 10/10/2020 18:34, Pavel Begunkov wrote:
>> There is no real reason left for preparing io-wq work context for linked
>> requests in advance, remove it as this might become a bottleneck in some
>> cases.
>>
>> Reported-by: Reported-by: Roman Gershman <romger@amazon.com>
> 
> It looks like "Reported-by:" got duplicated.
> 
> s/Reported-by: Reported-by:/Reported-by:/

I fixed it up.

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3254F417C0E
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 21:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348267AbhIXUAt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 16:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345980AbhIXUAr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 16:00:47 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FC8C061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 12:59:14 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id x2so11718717ilm.2
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 12:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=d3qq5fNU/Ns39N/51oFbK5cijKTzpyvFIJGR5hAwMf0=;
        b=49gJzfBRPhzrHan/nzlbaZaRxz3tWCZFdasDsLTqal1fo3Kjhk0o1jePVTnNuof1Qm
         uH2+8kRLrry63D0HleWV5Es+9OrTgXcP5Q6hr0/4CzjhNsCokZ7Sz/6GQXv6MovwuLCL
         zDolzcMaFNCgQ17UyIjzwZwDgvJVruZRsH/lcJb2hEXRXsAdhcY/v0NUxXdZjyUEmYnb
         SXywIAhO8hdQIPM40O5/tidd1dUq+DaA56QkeiBE1sF6gmNcSdKSPqggd2P3kch2W1G1
         m9uO7XIStXHviRHshilnQzGGEE9cg4gzNLngDcsMcbnk3nxnxHtElVAtkpFRCTJp7XQj
         qKeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d3qq5fNU/Ns39N/51oFbK5cijKTzpyvFIJGR5hAwMf0=;
        b=zbb0JicmCMFD/eGM8KqF4lTuC1VHc86EzoPBYyw7NNRXRY6t7Ty/FqV6qsoknd7ksG
         xvxAArtadNwx8hEhe30Ts+I41CGG/4unl+TSGIuJ0t2+bFeU2FXPCY1v9YkCTn7mQdJl
         sOTvpI/+/GYFDX01rXDqqrS6VDSt15s+Ju3b1nOy6p1gGAjaBFxDG5seFbPTHVk4ID4U
         Sf9ppIQWe5ytoJpKtNSuqLquIT9bwKBRxjFiKk4VjgtDNZuRagJch68HYPrghOqCtYyM
         FVc6F2CBYlB6r7g6q2oukWrTYrU4sgYYyASKxzC6f9xORDbiGfzqOugGiY1fcDpl3MLK
         6o6A==
X-Gm-Message-State: AOAM532QQa/sqibFv6N0IqX98zGK4mHG5AT/GWi7J7zCc3aa4VDMbbtV
        vbkBeP6PlM9wtFHG9NZvcvbROqHLxQPDeXoutHc=
X-Google-Smtp-Source: ABdhPJxy7eGnmyQ+yVpACfNKOHxjXVe+kONqAj9EkOVG/iUGaUD6YN2ADc9QVTkEi6FGQkpotg+DxA==
X-Received: by 2002:a05:6e02:1aa5:: with SMTP id l5mr9444904ilv.73.1632513553186;
        Fri, 24 Sep 2021 12:59:13 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r11sm4507856ila.17.2021.09.24.12.59.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 12:59:12 -0700 (PDT)
Subject: Re: [PATCH] io_uring: make OP_CLOSE consistent direct open
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <2b8a74c47ef43bfe03fba1973630f7704851dbdc.1632510251.git.asml.silence@gmail.com>
 <8a673462-9ad2-75c7-b7c2-5bdadadb09ac@kernel.dk>
Message-ID: <765726fb-245e-5876-17fb-f6e743b5a33f@kernel.dk>
Date:   Fri, 24 Sep 2021 13:59:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8a673462-9ad2-75c7-b7c2-5bdadadb09ac@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/24/21 1:58 PM, Jens Axboe wrote:
> On 9/24/21 1:04 PM, Pavel Begunkov wrote:
>> From recently open/accept are now able to manipulate fixed file table,
>> but it's inconsistent that close can't. Close the gap, keep API same as
>> with open/accept, i.e. via sqe->file_slot.
> 
> Applied, thanks.

Wrong message I replied to, that was for the 2 liburing test
improvements!

-- 
Jens Axboe


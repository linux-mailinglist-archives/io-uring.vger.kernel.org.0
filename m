Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4DE364917
	for <lists+io-uring@lfdr.de>; Mon, 19 Apr 2021 19:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239744AbhDSRfc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Apr 2021 13:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239743AbhDSRfc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Apr 2021 13:35:32 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35EF9C06174A
        for <io-uring@vger.kernel.org>; Mon, 19 Apr 2021 10:35:01 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id l19so25913356ilk.13
        for <io-uring@vger.kernel.org>; Mon, 19 Apr 2021 10:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YzamsHI6GibHhkEOBpDY0TcEeZnq+4o0JuC/zTfbpX8=;
        b=gJ97dVgAAkVsrG8b72JaQWK34ma5FhlvnLjWeO2HMAPI0x6vLTMt2wDOsoIQPBoEUf
         w/3QL3xnZO3ggTBnRkpNbX3wa9dq/m6Q1wj1W7SetxaKsh838uB5xLck4Kwx9Bt8/K29
         boktKtaA/zwBunDjpNdvUmC6F9fMw1i1ArDRT5ZOYB40Y4e919XeIanNyaQiX9e2FgBk
         d+/qBFldD0J4wehI1vhdiKLle7ZEsq6a32lAywKO9iIwgs6oazoHMGaC231l/mAghRKV
         vJTDuayxzcb/1lkyR40Di1YpO82BLYOSfRLujIjNbZmtsG+uU1gv/yrSQt4kOepICmgv
         XfXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YzamsHI6GibHhkEOBpDY0TcEeZnq+4o0JuC/zTfbpX8=;
        b=JXEVgkIjgutbCfLa2RD0cANiP9FXYku08Jqk5A3e+pU4TnQiQK+NeplIo1GU32VhID
         kChyFTljUnhiKpY0ufvowPmJwccy4ffwKd5i//n0FOyxn6zaGEbxy5RckyKPqS8ziiES
         I45OzEHa7+WS8XmrKnpbCnY91xrLII+xlfZRskbNMd/GlXhU6jen007p4RThHX28iE+V
         MVIqJjq2zn6mMpbtJ1W5t+6ZV78vEsg+zchsMud/6/WjQzrg5afzvYxQz15bifExmSMu
         2KmlkIAqDPAQ0tBZ2clV4ZSqwbhfODMpsFSzkklQByG3zRfMMq5H4J0R4R5HPbtU0+9G
         TOzA==
X-Gm-Message-State: AOAM5302IdnfwFgvoKoZNBxGoUGcwSgcozRNR8Ij7zgWO7uCPPGh2g1z
        PPw/YSt0cwSsSbEItcqxl1golvprnnON4w==
X-Google-Smtp-Source: ABdhPJx4TtlIDjd9JZ/UOCZYQWUyGw9dcI1VHSc+DZVcqIko03OvQpmzNmHE9BA+yjGI6iUmNLmN3Q==
X-Received: by 2002:a92:340e:: with SMTP id b14mr19048427ila.285.1618853700033;
        Mon, 19 Apr 2021 10:35:00 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b9sm3926827ils.44.2021.04.19.10.34.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 10:34:59 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] fix hangs with shared sqpoll
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Joakim Hassila <joj@mac.com>
References: <cover.1618752958.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <338ee408-8c52-6e0b-0346-7f3c0d9502d0@kernel.dk>
Date:   Mon, 19 Apr 2021 11:34:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1618752958.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/18/21 7:52 AM, Pavel Begunkov wrote:
> Jens' reproducers catches shared sqpoll hangs, address them.
> 
> v2: do full cancel, and remove ctx from the sqd_list _after_ running
>     sqpoll cancel as it depends on it.

Tests good for me, applied for 5.13 - thanks!

-- 
Jens Axboe


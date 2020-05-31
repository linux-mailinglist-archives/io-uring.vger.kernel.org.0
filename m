Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1981E9838
	for <lists+io-uring@lfdr.de>; Sun, 31 May 2020 16:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgEaOqH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 31 May 2020 10:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgEaOqH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 31 May 2020 10:46:07 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20BF4C061A0E
        for <io-uring@vger.kernel.org>; Sun, 31 May 2020 07:46:06 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id e9so1129176pgo.9
        for <io-uring@vger.kernel.org>; Sun, 31 May 2020 07:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1J0YsXEWc1YmWvz99yP3kWaZPcNCIYYtbsT6gH5AFY8=;
        b=mDEi1/EWb3wd8+5BTfpa2+eGOUDm/ih4/a7kEMrejrbPC9Y9wSER6Ttwk3nU6l+90S
         7JtY1hvLR1crQtfCS1lA9uB+anZsEUBtuqRSgW9ET/eOY3BUcdy9fF4aPI4hcUv90aWr
         j3RI6iJclQyW4gtrBMQXBCk6ny+t4aAJnNfRHLNFb+XHdFtsls8btENdDgMUpxSHAahv
         wEXcUtJx08eADa18PA/PhnHNbasO/evh8b+qdYExXX/YCzUluoOOtSi9zCZglWzaCqui
         58ouLPi8qBE+u4KhKmd0+sQNXBMq+LWstC4Mwz0pcIvKTDqfRnZdxFMUWceF+sc7dgsm
         8Alg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1J0YsXEWc1YmWvz99yP3kWaZPcNCIYYtbsT6gH5AFY8=;
        b=U6zqOu6ZBjFhsAGdk0xegVU6LxUPm4QC1Zo+75tk1mzhtQ8nSog7JN2HHZ3CEPLhHb
         Jyot5pTe+ovkX5Pnm9ewkEnvQFWsFYlyC7spisYNQxFjo1UaDhPYu7vgoNYLwWTqbiz8
         4KdizY/Ygf0KnRS3w+gS++pZQffbArk0xiwyKeC+/jRBl+uM54SJodOdSBroquf8BPPN
         qTI8clOwo6uUtjj4c99Pv11d6sOhB0pdZy98kL7b3ROIEcTh1ODrxM5TGjxtVLo8v+6D
         4aKjLTAYY9RrbvfH3rJGGqp7fe+vrgKTIUM0O98z3pnP+4CSNaGfi5n0vQSKIf/erpsJ
         FuDA==
X-Gm-Message-State: AOAM531zdxDSzThuCx0qL0pZG4S0nTXxDYyLKAzdS+Q3DwyM1S0Ke8Sv
        rfu7y6nRo70MLWZU66t1UAlXNwrR6NMeEg==
X-Google-Smtp-Source: ABdhPJybn0EWdoFh3NQShuTrzJJt4XIpH7Y0A8CKIgeTRMshqDR9X3BzKIdedZftMix2tfmdMwh8pQ==
X-Received: by 2002:a62:ab04:: with SMTP id p4mr17150181pff.254.1590936365115;
        Sun, 31 May 2020 07:46:05 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id h13sm5651591pfk.25.2020.05.31.07.46.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 May 2020 07:46:04 -0700 (PDT)
Subject: Re: IORING_OP_CLOSE fails on fd opened with O_PATH
To:     Clay Harris <bugs@claycon.org>, io-uring@vger.kernel.org
References: <20200531124740.vbvc6ms7kzw447t2@ps29521.dreamhostps.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5d8c06cb-7505-e0c5-a7f4-507e7105ce5e@kernel.dk>
Date:   Sun, 31 May 2020 08:46:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200531124740.vbvc6ms7kzw447t2@ps29521.dreamhostps.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/31/20 6:47 AM, Clay Harris wrote:
> Tested on kernel 5.6.14
> 
> $ ./closetest closetest.c
> 
> path closetest.c open on fd 3 with O_RDONLY
>  ---- io_uring close(3)
>  ---- ordinary close(3)
> ordinary close(3) failed, errno 9: Bad file descriptor
> 
> 
> $ ./closetest closetest.c opath
> 
> path closetest.c open on fd 3 with O_PATH
>  ---- io_uring close(3)
> io_uring close() failed, errno 9: Bad file descriptor
>  ---- ordinary close(3)
> ordinary close(3) returned 0

Can you include the test case, please? Should be an easy fix, but no
point rewriting a test case if I can avoid it...

-- 
Jens Axboe


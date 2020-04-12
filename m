Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 883D81A5F32
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2020 17:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgDLPaF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Apr 2020 11:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbgDLPaF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Apr 2020 11:30:05 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99150C02A1A2
        for <io-uring@vger.kernel.org>; Sun, 12 Apr 2020 08:23:24 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id h11so2541905plk.7
        for <io-uring@vger.kernel.org>; Sun, 12 Apr 2020 08:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RTj0VEX5TNqzrqwsQNvi0lYaU3YprHALdXBJBp1u/JI=;
        b=O5Ue/2t4RngZU62hTmQrNo88logu66R+UrpS1WoZBldh2oQE18EqtWNa5URxBY9F6b
         ttLZvyNe+Sedp8nK8f2ytarB/uAtDiKbO5jZ5CZuODbxP532IQlYl5twFsnA7n5qhrBQ
         GxYxBRr67aHmShmrmuyImH67C1swvFPkRqpwQcy5Tmu35pt9AbHOfw6syTaGpW4WBqmM
         T0wQAobQY2U+48OxHck2YqCcZQ4r+1uA+g4NqzvcbMuH/fpdx4bGGSlFSrL9YED9IRpi
         Ppr5+D3+IOhtVGzdC08j0yWYdWOab0tVdy8dB2zjoAhYVkydt7aH3VlCsKmbXeNTVBTS
         Gt3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RTj0VEX5TNqzrqwsQNvi0lYaU3YprHALdXBJBp1u/JI=;
        b=EzkcICemL7eoc50T6Mhwgrj8J7tLdsRiidgvd035GWk2WEIpXQ7/UT9FIDK53guUdX
         VZRjmtZBO8jmN5VYXeU93r6WqqCr9yFdOvoBNjQymigCTz+4gnFkBOh3zUpHnmiKvIej
         TxL+jSAPVpXzFv5NFWLYlQrczVwATv5eEXcXtq6NCXgQPDEtvYDPET05XO/jxje5+xJ4
         ZxktZd5t56GylYthd1EymuI4Vf7Noe33FFTJccsL+l3TTRlNWenv4XHhODT5bAEhB4Fq
         qZD2qJg3W9qY3nD6JMwNWqitMojB9VOKqYkGwPtZCwQJWlS4GnuO+8i8IEpcd8kOp2DA
         TjkA==
X-Gm-Message-State: AGi0PuYicEew9p8+nM8MAyOJZNiUB17ziXCI15cYm3cbxZTihtdQH3Q+
        kpy+ZaU9gzOxj5GDplEoumEWeg==
X-Google-Smtp-Source: APiQypKB0lpn8rFhNs5oVR4P3kxoprX32HoiM0wISUKUdvUOemY0m4maLN7a6x7QKaVt0V79QuZthA==
X-Received: by 2002:a17:90a:3343:: with SMTP id m61mr17721046pjb.112.1586705001312;
        Sun, 12 Apr 2020 08:23:21 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id n21sm6152771pgf.36.2020.04.12.08.23.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Apr 2020 08:23:20 -0700 (PDT)
Subject: Re: [PATCH 0/5] submission path refactoring pt.2
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1586645520.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <774f0f44-d6d8-6a5a-4808-090f69781e4c@kernel.dk>
Date:   Sun, 12 Apr 2020 09:23:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <cover.1586645520.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/11/20 5:05 PM, Pavel Begunkov wrote:
> The 2nd and last part of submission path refactoring. This moves
> request initialisation bits into io_init_req(), doing better job
> logically segmenting the code. Keeping negative diffstat as a bonus.
> 
> Pavel Begunkov (5):
>   io_uring: remove obsolete @mm_fault
>   io_uring: track mm through current->mm
>   io_uring: DRY early submission req fail code
>   io_uring: keep all sqe->flags in req->flags
>   io_uring: move all request init code in one place
> 
>  fs/io_uring.c | 196 +++++++++++++++++++++++---------------------------
>  1 file changed, 90 insertions(+), 106 deletions(-)

Looks good, applied. Thanks!

-- 
Jens Axboe


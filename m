Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394211CDE17
	for <lists+io-uring@lfdr.de>; Mon, 11 May 2020 17:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730007AbgEKPEQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 May 2020 11:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729999AbgEKPEQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 May 2020 11:04:16 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38972C05BD09
        for <io-uring@vger.kernel.org>; Mon, 11 May 2020 08:04:16 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id w65so4852878pfc.12
        for <io-uring@vger.kernel.org>; Mon, 11 May 2020 08:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OHJUJ17/FC2dTwIgyVRhAvuaLoEHHB7DiP06YRCuurY=;
        b=W3Wyw/BUOFmcN5z76mdD+d+AeYX5Q0cmBijeoqCywy8tYJ3IBFQaqDiQ0DBOeAMKw7
         1P/0/r46pvYDxyvlYRqxrVxdypSk3TOTiwTbHstWNTuX5UB5ytnVMGF88fosyXZfi+kP
         eGqJEFO32NTM9OVlqFPg5UJAKjrpQsScFR+27sPkHu1WEPclfyOVdBvnC834jRM9ODQP
         qiUHnzvdDY4p6IZhunNByn5DzR8foi2gwsALibAOd4xVUhdRJjNId94vOx4L2ceDBK6I
         uTSWBJmP9KC3YASV6qXD1a4J7gmCAtxrvOIKaPKrGW6ok6f4OP7DeJMj2i0oTW0Y+SeD
         J6Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OHJUJ17/FC2dTwIgyVRhAvuaLoEHHB7DiP06YRCuurY=;
        b=Axkm96gbglICBu3f5e8iobu2xTIjotoPqwkFZZLIfDXey9DtPVI5Gfv4ndvn/12/ZH
         6ewZl+/vKS5LRIa9S2EeUms0s//dIhBg3isjgLRsdv597J+Oi8DHTZfZ5IaMGzy6eh0a
         Y4xuOdBEqx0CSQhNitlSNfuXATv+b3pLQly8ynSBpO0t2or2ue+GDOX55PziwjMLN9iR
         6VvFw0vdxUWg5jxpkg8ENrAdYUuhluXPJ7QuuUwtRoeWrOKlworvAiv6IAW3quGSHogW
         IftooFyHhGO3L0Okop+g1kiN7FN3JnvJPo2aBljUPUdjkx+RyVDaltFiyEWRb2MZqU3K
         C5CA==
X-Gm-Message-State: AGi0PuaOITK0X5v3+y82DJ5a9hvpKELIxMgfiLHotD6BkJmphK1S+QEu
        mDJkjEDCKxGio4sfD44V1uKaEA==
X-Google-Smtp-Source: APiQypJP/+pPEqvkAfi8g+IHjolppYyg14pV7OIOuz2+kkHrLUoxUsD6RhBmqj/GotdKeMJPQVmcsA==
X-Received: by 2002:a63:6fce:: with SMTP id k197mr15097130pgc.431.1589209455711;
        Mon, 11 May 2020 08:04:15 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:2dd6:4c58:486d:263e? ([2605:e000:100e:8c61:2dd6:4c58:486d:263e])
        by smtp.gmail.com with ESMTPSA id h13sm8108267pgm.69.2020.05.11.08.04.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 08:04:14 -0700 (PDT)
Subject: Re: [PATCH] fs:io_uring:Remove duplicate semicolons at the end of
 line
To:     Xiaoming Ni <nixiaoming@huawei.com>, viro@zeniv.linux.org.uk
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, wangle6@huawei.com
References: <1589196343-84741-1-git-send-email-nixiaoming@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4dda3bd2-595f-9cdb-a22f-3b56d6ba16c2@kernel.dk>
Date:   Mon, 11 May 2020 09:04:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1589196343-84741-1-git-send-email-nixiaoming@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/11/20 5:25 AM, Xiaoming Ni wrote:
> Remove duplicate semicolons at the end of line in fs/io_uring.c

Applied, thanks.

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601BA2DD89B
	for <lists+io-uring@lfdr.de>; Thu, 17 Dec 2020 19:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbgLQSqN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Dec 2020 13:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727260AbgLQSqN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Dec 2020 13:46:13 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2247DC061794
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 10:45:33 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id p187so28521072iod.4
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 10:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A6o/HShdjh1MTE3FfeawCvYDUJ84obUDWQS4C9nsRsU=;
        b=akR5o6npnw2uNVR8DxhTEQ5Byq+v8Ip6bx4Ykl2928HxlKhX11TNfdEDS5uqu5sAb5
         gzZAcQH1un47fhjlsaPFrrDFnzDPHeIMBWvsRaRuFFBtVtIwwBghScfLnYlbXnl9y075
         bd47p9p6plSiCLuclTW77uMm6fHwXtdNLHXmnn0+IAu5PTLjHt+JgFejob6zOe9BGu63
         7JwCMzZ+4CqpCHQSiuFC56Y6pBKwsQXQCbU9p8HD0ZYSbB6bGHDBOI20DUJfN3DnIdwp
         A0Om0vNR5oAe61o1OIwCh/DT09npM2xStNp37S+U3Y79KJwoD29eADtPBr32FIqEJrLe
         FUDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A6o/HShdjh1MTE3FfeawCvYDUJ84obUDWQS4C9nsRsU=;
        b=MtAKvHbRfmVOVX6EuyC103mQtjFB2150p1OnBNk9qMZiBxCp3ZHtJ7ScBuBKX2HZLJ
         ypb/+OvDJetprXDhwaps9Lm7y+iEwrlTJRTY74mGZIdDt0m+GIzui7DM6X+9k3Q8c0b7
         +NCrOW435xOXkHy6sPKmqHCr87/u200m8mxfv69w7hGklxUqRxkP8TvDeB2381BdjZsz
         iSZurB7uK2DTnLS4+jZC20XhSARyo24N0CAJUHzxiCnbArcOX3FfV0bnD6Jrxcp87TnF
         fgw2UofgQEBojlZRFfXQUzbzqutuSXv/hplKpIxHgezi7Ft8saHyH7vvMHzGBA/hQZya
         0XjQ==
X-Gm-Message-State: AOAM5328XguQy8lsJ9vtVSeDrzWiWUW2X58L+h6+fFazm24P3+KZQiG1
        1+xa4O5nm1Ce+jRt+x5Z+dsN9g==
X-Google-Smtp-Source: ABdhPJx/X0dZC8j8qf25uH8fLhPFSUU2bJ3w3zo1l5fvhkQM6pw/SKyGglqqe8ndU6h+EXnkcoiLZA==
X-Received: by 2002:a5d:9a82:: with SMTP id c2mr462367iom.38.1608230732355;
        Thu, 17 Dec 2020 10:45:32 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r3sm3684592ilt.76.2020.12.17.10.45.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Dec 2020 10:45:31 -0800 (PST)
Subject: Re: [PATCH net-next v5] udp:allow UDP cmsghdrs through io_uring
To:     Victor Stewart <v@nametag.social>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        netdev <netdev@vger.kernel.org>
References: <20201216225648.48037-1-v@nametag.social>
 <5869aae1-400c-94a4-523e-e015f386f986@kernel.dk>
 <CAM1kxwiwCsMig+1AJQv0nTDOKjjfBS5eW5rK9xUGmVCWdbQu3A@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2b120310-4c7f-3e60-e333-8236d72faf8d@kernel.dk>
Date:   Thu, 17 Dec 2020 11:45:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAM1kxwiwCsMig+1AJQv0nTDOKjjfBS5eW5rK9xUGmVCWdbQu3A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/17/20 11:30 AM, Victor Stewart wrote:
> might this still make it into 5.11?

Doesn't meet the criteria to go in at this point. I sometimes
make exceptions, but generally speaking, something going into
5.11 should have been completed at least a week ago.

So I'd feel more comfortable pushing this to 5.12.

-- 
Jens Axboe


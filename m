Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D7625E546
	for <lists+io-uring@lfdr.de>; Sat,  5 Sep 2020 05:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgIEDxz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Sep 2020 23:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgIEDxy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Sep 2020 23:53:54 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F7EC061244
        for <io-uring@vger.kernel.org>; Fri,  4 Sep 2020 20:53:54 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id z15so2024988plo.7
        for <io-uring@vger.kernel.org>; Fri, 04 Sep 2020 20:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=NsBIlNV76dFbPFIoCKgyU7YxKZ6iD/EhSLuNHRUTV4s=;
        b=pGTzfkimJgbv3Q4vKy+BDWa01Okq2Wb9UymV0zoxVSbWdrGyY8wwkFHHnaeO017EUK
         qzWtaEWedormITgAPPYIamMdobJ5GiBmkfZUNflMalSjtjUW7XHVgotOXoSFRq/xX0Di
         HsUsYdbvsx8yG3YPOTCXMa7bYqrvj7eCBimsVIcdcvRBYhRapfM4fgZwzlVL3uxM5kwQ
         hCVCW/O06zc4JoTdF36p/KTkLNIl22+3cJgJrVOWt0myFGo5TUYJilR0zGIyNP+rX+i9
         0dWgQP9CsNNGb+mCsUl23z12ESKUSQHuPd63wYJnxr8OejI5eh60BpgeaqJMi06HPrUK
         INwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NsBIlNV76dFbPFIoCKgyU7YxKZ6iD/EhSLuNHRUTV4s=;
        b=jhPr49FpvMvJvvcWT3fSri2eElP03J61Ky68JHbmlvgpklROk+P5Rnp/5A37dJrwuy
         8P5rWXWYfeGakvQ0A3LEf4917TTZznNv1SIp2fmsXWGQP416SdGm8e7twY/EOwsKS7g4
         I3MHLdYYo6v8POgg9ZImFWGfaTqSG2ixWP5zlCbIAvWZURPgUr7XtlbkbB+sPuAqocx4
         jZiueTChmo8nyLuRJsSz3jhYrhZiH5VcCnKTE2A3GBMr3ljRJl5Aom3HtAutzg5A+0mj
         HZ97RjdHnwbguDTIRtIo6Dn6SC7pwXERzIE/BrMuDLVnBnP+uemwSfvjSXDZZz2Hf00O
         ZndQ==
X-Gm-Message-State: AOAM533xEFhDC8Df1HtY8CXYbxqTktltI/QSskLB0cOmKeqTjkKp649u
        eAuYThjLA3MMNkxkoZjBjgYgxE/Jundj0ExI
X-Google-Smtp-Source: ABdhPJyb/cD7Z33rZZHczfLqQ3bb9mIXB96NoBzmi40EAlITvliiu2n9wmF9BsTWa/mCm2fS9MAEeg==
X-Received: by 2002:a17:902:fe13:b029:d0:89f4:6226 with SMTP id g19-20020a170902fe13b02900d089f46226mr9735354plj.14.1599278030407;
        Fri, 04 Sep 2020 20:53:50 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y16sm6376082pjr.40.2020.09.04.20.53.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2020 20:53:49 -0700 (PDT)
Subject: Re: WRITEV with IOSQE_ASYNC broken?
To:     nick@nickhill.org, io-uring@vger.kernel.org
References: <382946a1d3513fbb1354c8e2c875e036@nickhill.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bfd153eb-0ab9-5864-ca5d-1bc8298f7a21@kernel.dk>
Date:   Fri, 4 Sep 2020 21:53:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <382946a1d3513fbb1354c8e2c875e036@nickhill.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/4/20 9:22 PM, nick@nickhill.org wrote:
> Hi,
> 
> I am helping out with the netty io_uring integration, and came across 
> some strange behaviour which seems like it might be a bug related to 
> async offload of read/write iovecs.
> 
> Basically a WRITEV SQE seems to fail reliably with -BADADDRESS when the 
> IOSQE_ASYNC flag is set but works fine otherwise (everything else the 
> same). This is with 5.9.0-rc3.

Do you see it just on 5.9-rc3, or also 5.8? Just curious... But that is
very odd in any case, ASYNC writev is even part of the regular tests.
Any sort of deferral, be it explicit via ASYNC or implicit through
needing to retry, saves all the needed details to retry without
needing any of the original context.

Can you narrow down what exactly is being written - like file type,
buffered/O_DIRECT, etc. What file system, what device is hosting it.
The more details the better, will help me narrow down what is going on.
 
> Sorry if I've made a mistake somehow, and thanks for all the great work 
> on this game-changing feature!

Thanks! Let's get to the bottom of this.

-- 
Jens Axboe


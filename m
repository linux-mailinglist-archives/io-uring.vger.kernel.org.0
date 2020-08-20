Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13A724B9B4
	for <lists+io-uring@lfdr.de>; Thu, 20 Aug 2020 13:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbgHTLxl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Aug 2020 07:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730995AbgHTLuU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Aug 2020 07:50:20 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCD9C061386
        for <io-uring@vger.kernel.org>; Thu, 20 Aug 2020 04:50:20 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id c10so2472461pjn.1
        for <io-uring@vger.kernel.org>; Thu, 20 Aug 2020 04:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=fRyRUfyt4jBR/vQZ+VkFMq+6M3uOfKvqCQHZxtt1Nb8=;
        b=NJcvhiOjTTM/Kixd7gArjrIMyQjPxxJlT/m4BN03hsc2PDTwECkJAbFqej5IWz8Kaf
         kf9+tcudmljxT856w8Jz0DrZUAkfTPCPWobg2boNIWf6MoBROgKim/aXsx4XLmAtRJIv
         chypgp3fNNueUWWRFSEk5irjWWdeUKQYtlaS5ZoL0GBKMWKuWditUrf9ubrxq14dLEFE
         zgs6ZXpzpDJhzJl2jZiMt5z7nGHoQOp81hBBsca+P/riqnGr11c4XH1DG+pRKAKclwMS
         9Bb/TatMTgOAAQ88O8Cr0SvDDSOLgxcvLIrfowpVMVP4FWJ02xZzAMum0Wy8ytriFuLe
         /vbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fRyRUfyt4jBR/vQZ+VkFMq+6M3uOfKvqCQHZxtt1Nb8=;
        b=Mh6Fve+2Ywp4mqHtavnCyItH0qPiVe9+JCfyJiVU9h8rzusjFk+A/ORoMbijx0j3l3
         13g3MpfozpoJFXTHiExvk3WoOgc1RDu0baWUnv4ye3QgK9/7sOkG1AnTRfAxSs4dfS74
         rEKpw/X3JAvm8FpUn1lJZc3Z+krlrartHqmOyiNUStFDTyNuohdkjgvGQtbXDkH7ims5
         Irn56JBs8MPDf9Asd+LBGxe5An+zIzHfuUlrA8xzmiN0/kZ4aLBYkDov0YAtEd4x7w7s
         4uRWXF2oUCrP6p19lqVu04in8UaaCAE2jVeT+m1BbUSCU/qYNyOqQC4iqvp+uKuvOucj
         SiSg==
X-Gm-Message-State: AOAM531q2Jrw8XGb3aup1xl/nD3Oy9eD6t+U1xTjvasnN4xFm7lq3Q0k
        D+/hzin3BOAPB3qF7ZPB2uW/c0v/7mcJYrA2Gxk=
X-Google-Smtp-Source: ABdhPJxM563WQOcGUvm4dzEbUbdENuQYKOkoOnIm1YzVmaTZQm3ZbTyl1FGfHeHjToPGbbiQnWyobQ==
X-Received: by 2002:a17:90a:d317:: with SMTP id p23mr2235634pju.217.1597924219482;
        Thu, 20 Aug 2020 04:50:19 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id p9sm2196655pge.39.2020.08.20.04.50.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 04:50:18 -0700 (PDT)
Subject: Re: [PATCH] io_uring: comment on kfree(iovec) checks
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <7dd37adcb8a6fabd700205e2bcf62ccdc30681f3.1597912327.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <80ca429c-b72f-ce60-f7b7-77d11225c168@kernel.dk>
Date:   Thu, 20 Aug 2020 05:50:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7dd37adcb8a6fabd700205e2bcf62ccdc30681f3.1597912327.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/20/20 1:34 AM, Pavel Begunkov wrote:
> kfree() handles NULL pointers well, but io_{read,write}() checks it
> because of performance reasons. Leave a comment there for those who are
> tempted to patch it.

Applied, thanks.

-- 
Jens Axboe


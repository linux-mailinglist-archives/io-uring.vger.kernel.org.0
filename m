Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2EF925E585
	for <lists+io-uring@lfdr.de>; Sat,  5 Sep 2020 06:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbgIEEfX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Sep 2020 00:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgIEEfW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Sep 2020 00:35:22 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313DAC061244
        for <io-uring@vger.kernel.org>; Fri,  4 Sep 2020 21:35:22 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id x18so2053800pll.6
        for <io-uring@vger.kernel.org>; Fri, 04 Sep 2020 21:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xSaQPEx9XxdpBk298f7z4H1dGd0smACoIjp7p7MG98w=;
        b=bQBWN9Wx86fNSjTL2Fbc+a9mKyB5qW79vl9JfumaMdU1tL8DQKo4VPgzfQ9box6LgD
         ZsERRcCMnLlGVDGPYwAj9U3SvuUX5wXEWeL875ci2YllZXRHdcb4DbzAL619GYMIAeac
         Vzk0fGYVYm/LmcVbKpX/WD+8ykTbXMzGO0otCWocl45cJUbMSp2C21ad0NxoY4p0Mu5n
         Gh5ic2x1IF3b3MGS5aC8U1I2WJAsMMW0j3mDtaZBIqRL9YYJKSxUDoDQFoMqr0R2k8Ly
         mGDjbSHTIBc2CJwRTOUeSu86P87ulu+99LhVwqu8p03qns3cQ716Oj98iZ/nkHbh8fuU
         kXiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xSaQPEx9XxdpBk298f7z4H1dGd0smACoIjp7p7MG98w=;
        b=MHFEQdHe5PVkLnK+N+yWQkRnQm4iik+26mg2V79W4VOv52pP1gvkKG55SjL7ff0gGw
         YOqVl1XrNtSLtbqnjOKZu23ih5xVNUf5m+lTYvfNzf9hOU6yA0nycT/ESEwOsTVcIy8p
         Dm5jyGcHitSO9kruMP4YOvetpSSBTC/YqzlRlGR4SXH0OX5IkYXLh89rX0C3PiUs6Vwc
         2a/aX9pTfpzx+1cjw5NsHkWMSwv9loDJ/vPVrRBTUN1+V8kDsJ3CuqvTj9+vJxkNxTBK
         8I8jU7IePKD+4ce0Q6TVeyKy8BqksQJYJeqlQVtJazAZQVFywfKCIM4rQsUrHvQro3HD
         GLdw==
X-Gm-Message-State: AOAM531ABhRBDMljeepSLCSt49LfDrDeM26MDd5cnqVj+OXGHmMbY4nl
        S+7nn6qVA/0p5n+MsxMHvP0Cd7dclVemm+Aq
X-Google-Smtp-Source: ABdhPJyIWlINf/89pBolCRp6l6B87iSDfhCAXpfkUdTbPnJ+XPpLiM7n2dmG3nFttP+FeWZx+AVMow==
X-Received: by 2002:a17:902:aa0a:b029:d0:89f4:6224 with SMTP id be10-20020a170902aa0ab02900d089f46224mr9823203plb.12.1599280520958;
        Fri, 04 Sep 2020 21:35:20 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y195sm8183805pfc.137.2020.09.04.21.35.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2020 21:35:20 -0700 (PDT)
Subject: Re: WRITEV with IOSQE_ASYNC broken?
From:   Jens Axboe <axboe@kernel.dk>
To:     nick@nickhill.org, io-uring@vger.kernel.org
References: <382946a1d3513fbb1354c8e2c875e036@nickhill.org>
 <bfd153eb-0ab9-5864-ca5d-1bc8298f7a21@kernel.dk>
 <fe3784cf-3389-6096-9dfd-f3aa8cd3a769@kernel.dk>
Message-ID: <d8404079-fe7e-3f42-4460-22328b12b0fa@kernel.dk>
Date:   Fri, 4 Sep 2020 22:35:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <fe3784cf-3389-6096-9dfd-f3aa8cd3a769@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/4/20 9:57 PM, Jens Axboe wrote:
> On 9/4/20 9:53 PM, Jens Axboe wrote:
>> On 9/4/20 9:22 PM, nick@nickhill.org wrote:
>>> Hi,
>>>
>>> I am helping out with the netty io_uring integration, and came across 
>>> some strange behaviour which seems like it might be a bug related to 
>>> async offload of read/write iovecs.
>>>
>>> Basically a WRITEV SQE seems to fail reliably with -BADADDRESS when the 
>>> IOSQE_ASYNC flag is set but works fine otherwise (everything else the 
>>> same). This is with 5.9.0-rc3.
>>
>> Do you see it just on 5.9-rc3, or also 5.8? Just curious... But that is
>> very odd in any case, ASYNC writev is even part of the regular tests.
>> Any sort of deferral, be it explicit via ASYNC or implicit through
>> needing to retry, saves all the needed details to retry without
>> needing any of the original context.
>>
>> Can you narrow down what exactly is being written - like file type,
>> buffered/O_DIRECT, etc. What file system, what device is hosting it.
>> The more details the better, will help me narrow down what is going on.
> 
> Forgot, also size of the IO (both total, but also number of iovecs in
> that particular request.
> 
> Essentially all the details that I would need to recreate what you're
> seeing.

Turns out there was a bug in the explicit handling, new in the current
-rc series. Can you try and add the below?

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0d7be2e9d005..000ae2acfd58 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2980,14 +2980,15 @@ static inline int io_rw_prep_async(struct io_kiocb *req, int rw,
 				   bool force_nonblock)
 {
 	struct io_async_rw *iorw = &req->io->rw;
+	struct iovec *iov;
 	ssize_t ret;
 
-	iorw->iter.iov = iorw->fast_iov;
-	ret = __io_import_iovec(rw, req, (struct iovec **) &iorw->iter.iov,
-				&iorw->iter, !force_nonblock);
+	iorw->iter.iov = iov = iorw->fast_iov;
+	ret = __io_import_iovec(rw, req, &iov, &iorw->iter, !force_nonblock);
 	if (unlikely(ret < 0))
 		return ret;
 
+	iorw->iter.iov = iov;
 	io_req_map_rw(req, iorw->iter.iov, iorw->fast_iov, &iorw->iter);
 	return 0;
 }

-- 
Jens Axboe


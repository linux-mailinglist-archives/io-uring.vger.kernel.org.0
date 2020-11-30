Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B94E2C91B9
	for <lists+io-uring@lfdr.de>; Mon, 30 Nov 2020 23:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbgK3W5D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Nov 2020 17:57:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbgK3W5D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Nov 2020 17:57:03 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C13BC0613CF
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 14:56:23 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id x15so7354705pll.2
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 14:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/ZON7mOKOTd/BqujN87DcbGAIOZ/NQnsoE5UNdjvN6E=;
        b=OJ0LGVWkgqXaZLpfclz/GUJo1XvUiLw7GtrYPFk7Fsxc7YDS7qYO5/2u6A695tynHN
         hsgGPovFeCXaHIEe1FgHM6J3faIxT/Cjn26ntdVH+4Vh3JibZ314ijz2e2otBHGiImF3
         jxZ6n/Yn30t+p5EwOv6iGUthAx5pGjyVQwfwfF3GaGtQiqAjqZQ8l2zgr361xXrJturH
         ErT87tzxA83KANTu76qAOvXh1SGiqu4p7eZYlFT3oMOKdzb2uRhtFcQHtB2Y9IdWNIZv
         9di5klJWOvoRel4XRAneMMpTRtHLRgzRKPD4Mowj12BCyEJPd3EOe/tkH8LWBDk/Vqft
         ApbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/ZON7mOKOTd/BqujN87DcbGAIOZ/NQnsoE5UNdjvN6E=;
        b=Ax0ZQ1cPhmZ878me9A6y6BfnzF08nZs1SXjXl60IGZH9g61RFtFYPrFo5E4nyeFTNp
         0hLcD/5Vn4myqZHPyE9VA3WlBx0BQwUyzGOXsBaBCbd3l/AJDgxcFl396oXc2nEtyZB3
         9c9JCnyhOck899pyFfbstZ9YFeNRPxdZAepBlQuskAxM0EAcBhpatrg0pazAxiFfrjCz
         SROavkJI5en5eRhc2gTKCyg5R2TtS4bfTpZoai0HHOzGNBEFeHSwEFbXHm7+E+GyOWZt
         AScadfS1XlY6AFILUZObZ5fq4k3TzVVndPKGoiR+QcERTv7LbRaED1nKH+gmRIcqC9R2
         uy/w==
X-Gm-Message-State: AOAM531z9O+2tovOn3WDDqJVJtEKwmHHt+iR5CKHbbwp1/dkj5H5XJtj
        O5Dmnj06yo05CB2NtPFatM3Wq/pSRGQtBQ==
X-Google-Smtp-Source: ABdhPJxcq8eNc7o01PDPKzCk3K/xzxu2GpNiSKDJUtYzgNGwX8iZFJmgSVb1iPmsaXuR7K31Gg8G4g==
X-Received: by 2002:a17:902:a415:b029:d8:f55b:5e9b with SMTP id p21-20020a170902a415b02900d8f55b5e9bmr20805059plq.6.1606776982634;
        Mon, 30 Nov 2020 14:56:22 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b14sm44081pgj.9.2020.11.30.14.56.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 14:56:22 -0800 (PST)
Subject: Re: [PATCH 5.11] io_uring: refactor send/recv msg and iov managing
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <136e474beffa8c70e1fc67b10a0c76db3096c67d.1606700781.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <52211090-ec7c-e0c5-8100-8df4f9778913@kernel.dk>
Date:   Mon, 30 Nov 2020 15:56:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <136e474beffa8c70e1fc67b10a0c76db3096c67d.1606700781.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/29/20 6:47 PM, Pavel Begunkov wrote:
> After copying a send/recv msg header, fix up all the fields right away
> instead of delaying it. Keeping it in one place makes it easier. Also
> replace msg->iov with free_iov, that either keeps NULL or an iov to be
> freed, and kmsg->msg.msg_iter holding the right iov. That's more aligned
> with how rw handles it and easier to follow.

Looks good to me, but doesn't apply to the 5.11 branch. A quick guess
would be that we're conflicting with the compat fix from 5.10...

-- 
Jens Axboe


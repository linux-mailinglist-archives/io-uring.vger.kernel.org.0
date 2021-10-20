Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C60434768
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 10:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhJTI4x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Oct 2021 04:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhJTI4w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Oct 2021 04:56:52 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717AAC06161C;
        Wed, 20 Oct 2021 01:54:38 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id g2so17262523wme.4;
        Wed, 20 Oct 2021 01:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3fuDONNec5tzGOX4KZHqWYkiAlQVkLWHCfrESSvMT1U=;
        b=pnvp40nJGE4k1c4gSk1hHMKi8n+i5c7jXGm4npxFcu+It53+T35DTUJ4Wj2ghIkrC0
         8ZGF4qlkwfbqk1a71cfkXHTrb8OEavmS3WQ7NClJ9Ogn1vQ36xNrD4oc1KluKGH30evM
         9C/EHDalyyHM5ZPmGb/3ZWy4ftHstQE5WveqsednZXZ3Yf8MmXe2uLzWuwK1DqshuZ5z
         mm4ZKBOGpB99spbxGc7HzClG32eY2nE10RInUkru//qrLK8T+MTQWs1lhYnMzevtSYJU
         RxkJp/sJeZrhVMuNlgbJ3uhOwd297Tb775ZK0kys7cT8yHeJwjG5zBMHrslkmuTIg00C
         7rhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3fuDONNec5tzGOX4KZHqWYkiAlQVkLWHCfrESSvMT1U=;
        b=jrCDI4i+tBvUba0Kahsbzd2DWgnxB0bmmWkOV3UBeLI0eW0Qvy6XFVMT9Et63ivUcg
         aoD7QYAE2fjYb1ax3TWPiCZb+PrdDHydGe7kFT0/IG9MdNJZfZxP/cbqpxjia32FANZy
         /0bns2LD8qlhlRXIU5RO0FOJ+WWDcrxTlMYlG4xzerio63YkECQo58dT90dSB1l/cqBP
         bkM9CeIBM6WodsMhkRkAsOPvqyK/XBwm0WgNdtwefABoMT9mae7XhSHyp/CmYmTXBjmk
         xoQa07YPhlbBaWeW1+3v0c/+X7lJQyiXsj6hNmKO8ZJSiHqQ2z8+E3u6gVwqGHnKvmJy
         P71w==
X-Gm-Message-State: AOAM533r1YD2ZJu52AgQ1DP4jdx8UdmAyZr8x1540seYsaxyyI9B6TzM
        Hk+AKPFvWxwhTkrRYJcbTjg=
X-Google-Smtp-Source: ABdhPJw86Di5diB+8BJpzuzyrlThes+1wBn4Cyq3xXuhYHLRSASc8kdhvUTd/rpwp4/IFZu1PSM5bg==
X-Received: by 2002:a05:6000:552:: with SMTP id b18mr14057253wrf.112.1634720077103;
        Wed, 20 Oct 2021 01:54:37 -0700 (PDT)
Received: from [192.168.8.198] ([185.69.145.194])
        by smtp.gmail.com with ESMTPSA id z6sm1492084wro.25.2021.10.20.01.54.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 01:54:36 -0700 (PDT)
Message-ID: <3681f427-b661-b032-8e48-e598f208a15a@gmail.com>
Date:   Wed, 20 Oct 2021 09:54:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] io_uring: Use ERR_CAST() instead of ERR_PTR(PTR_ERR())
Content-Language: en-US
To:     cgel.zte@gmail.com, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
References: <20211020084948.1038420-1-deng.changcheng@zte.com.cn>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211020084948.1038420-1-deng.changcheng@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/20/21 09:49, cgel.zte@gmail.com wrote:
> From: Changcheng Deng <deng.changcheng@zte.com.cn>
> 
> Use ERR_CAST() instead of ERR_PTR(PTR_ERR()).

Makes more sense, looks good

> This makes it more readable and also fix this warning detected by
> err_cast.cocci:
> ./fs/io_uring.c: WARNING: 3208: 11-18: ERR_CAST can be used with buf
> 

-- 
Pavel Begunkov

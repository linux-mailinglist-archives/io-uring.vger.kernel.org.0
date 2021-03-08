Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3253310D4
	for <lists+io-uring@lfdr.de>; Mon,  8 Mar 2021 15:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbhCHOdv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Mar 2021 09:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhCHOd0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Mar 2021 09:33:26 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053EAC06174A
        for <io-uring@vger.kernel.org>; Mon,  8 Mar 2021 06:33:26 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id i8so10106090iog.7
        for <io-uring@vger.kernel.org>; Mon, 08 Mar 2021 06:33:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=9JAkapU55LGJf6ZFSDsFUyPVSl2cPE4AzEKwFnJ2reI=;
        b=kiyPkiLprD95Ok0RS9ckoOSzQqA0S4AxzvTxZ5e3Dbau50yTVQgonrJVCMr5vVWT5F
         Lptqq0DYykaQbTL8EljI04WWwSvBBmY8b8MBG23GGZQyJ+C7RnlyIgKjRZqtUCTCZYLI
         o0bfiiDs1+WemRyehgXh7/UsyIjCcEf74HszQ1lwyj+9dqPofICrHTbAh3GCRHT30IGB
         m5d0Ijx4PwRxwDOpTlQZtFnMC29OCNzmip81fqRUy+eojlaPlpsZo/P+xNNBfzxD6yvg
         j444EteqNZkTIjEdg7yfG2BPh9F15DeJYcNwAnOPEQ2klaYSY8Tj/0INpnGdyBcc4dmO
         DXgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9JAkapU55LGJf6ZFSDsFUyPVSl2cPE4AzEKwFnJ2reI=;
        b=Jkjsm0SQQGILnfMFUzRD9w7uugl7cmb4bzDBmN2M3vMM8qJ/eoflieP+hCCFJYkRqc
         ErTauOhNaO4Vz4W0nTZ1QG/y1qW8Vi+JvmVNCkjIWOhYaf2LxGKMK1Q1JmMTRVZdDNV7
         hhX5J+NJo3oXO9nZZkbuFxfMG8PQIk7y+fQCVYLhv1UJyykCDkXw6K2sChjSpoThWSFw
         NECG50uALRb8XQvjVIgqZEAebmrfuzRevpgJPOxi4gITi9zPr7UuXMzonyrFxqtiVBEM
         aCNrUxMUCeuUwH7cnchH1O7IUnXrP0F0CYsgqmqUgQA7fGkf5aeqWF6KE13qFbddtrVy
         pSgQ==
X-Gm-Message-State: AOAM533pIYjsut0/44WYnT8PwwX+ke+HqusgNR3zfw/1O4AbuWBnC+FW
        auevCnQyJyh0ON/hE9YHBpA2Coft1O7QFg==
X-Google-Smtp-Source: ABdhPJwmjUDsHVscl+P1tICypFySdE5I3gpnU0DXRkA+8d+8nZWChiAWDLfUs2Pnz1mn0QhapltFLQ==
X-Received: by 2002:a5d:8052:: with SMTP id b18mr19150660ior.188.1615214005208;
        Mon, 08 Mar 2021 06:33:25 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a5sm6324101ilh.23.2021.03.08.06.33.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 06:33:24 -0800 (PST)
Subject: Re: [PATCH 5.12] io_uring: clean R_DISABLED startup mess
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <057d200d7cc938d10b2f648a4a143a17e99b295f.1615209636.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3ede514c-6ce8-efcc-991f-2adc57e44bcf@kernel.dk>
Date:   Mon, 8 Mar 2021 07:33:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <057d200d7cc938d10b2f648a4a143a17e99b295f.1615209636.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/8/21 6:20 AM, Pavel Begunkov wrote:
> There are enough of problems with IORING_SETUP_R_DISABLED, including the
> burden of checking and kicking off the SQO task all over the codebase --
> for exit/cancel/etc.
> 
> Rework it, always start the thread but don't do submit unless the flag
> is gone, that's much easier.

This is a good simplification, much better than having the weird
state that is not started.

-- 
Jens Axboe


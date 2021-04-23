Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B30369493
	for <lists+io-uring@lfdr.de>; Fri, 23 Apr 2021 16:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhDWOZo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Apr 2021 10:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbhDWOZn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Apr 2021 10:25:43 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23D4C061574
        for <io-uring@vger.kernel.org>; Fri, 23 Apr 2021 07:25:06 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id h11so3148916pfn.0
        for <io-uring@vger.kernel.org>; Fri, 23 Apr 2021 07:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=kcZYCZqfaRqhkJZ1KvSPpnHoADu9CzXh0YdkyoKUSYU=;
        b=a2c19P2YDtf6QotflU75LUcz8BcZctAlZ+Q8tVvvEP0kR+iJ/ABD2dtymnoPhqqlTv
         qnWcxH05dqFibkJgafiK28jSnDaf4uth9CbseCXHlbJf0ZuGsm8HH7BmDcni82JJHI8b
         o1xc1dvvvICzJXh+Qlmt4HIEwzKxZXaALUYOWfJPHAJHFq8MsEjrlbvQPoqb9vpnh76p
         DYTPUV7xoQsKYGKywY4w/X2Z1gn2iP+hDUBdvtr6QHRIBZOh5K8z1OyyMieaJ91bQnfp
         7JmWd5ZHD/q20PfX/iCRmELmLdOL9pFor9vJ0/Wo2QrL5nSQRo+uzM1cs24YoYUgCGxt
         vtgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kcZYCZqfaRqhkJZ1KvSPpnHoADu9CzXh0YdkyoKUSYU=;
        b=HXcfEv2cHrmr1DO1QIT4dlTMkADck2VaTaafEZgrt2ZOuxGYmgntk+eL4127F42s4C
         YIXxKS/3tzHaNnRJuQ9naAJT2SfsKUPcksMG3Czt9d+fdoiFHzhURG8gydjNm8LNMyiC
         bdR+raURkZTc6CZ2nOTp2BcdB+OIJFfhlj8H6emMVMHNDMYs5pGqubWCtPKoiIwtQToP
         mODA5Tfi4I6t2enqqxUWMFROLWw80aoX3YWA0z8A6Ir3O/bn+XDJ301IJprEdQuVTnBw
         ZmdC4O8MmNniQOKVxF8+mtrYQZHT6A5LhSMdmTsGIUfQXYBhVsBBfXN5ixSRoaqu5+LL
         IgTA==
X-Gm-Message-State: AOAM530K0l+EbDNNgSXphfgdtBPRDqkKu3ueV+hnpM1SykViChW8apU4
        ZXQXrjPcWQvYcS5JmCSD5nDbl5L5EVwJRiDD
X-Google-Smtp-Source: ABdhPJxbK26+bnR9bYaI2pZfQUR2MiBsK2NEy8rwVkKARCnTPi0fvZoY8d68BW3rUQhNjqkjTL6jIQ==
X-Received: by 2002:a05:6a00:8a:b029:260:e095:8581 with SMTP id c10-20020a056a00008ab0290260e0958581mr4286132pfj.43.1619187905926;
        Fri, 23 Apr 2021 07:25:05 -0700 (PDT)
Received: from ?IPv6:2600:380:497c:70df:6bb6:caf7:996c:9229? ([2600:380:497c:70df:6bb6:caf7:996c:9229])
        by smtp.gmail.com with ESMTPSA id 22sm8130373pjl.31.2021.04.23.07.25.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 07:25:05 -0700 (PDT)
Subject: Re: [PATCH 09/11] io_uring: prepare fixed rw for dynanic buffers
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1619128798.git.asml.silence@gmail.com>
 <16e90af9d67f0f4b3c7c326974b8dbcc1c874797.1619128798.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <dbb50fe2-e538-1e5c-be1f-9323c4f48590@kernel.dk>
Date:   Fri, 23 Apr 2021 08:25:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <16e90af9d67f0f4b3c7c326974b8dbcc1c874797.1619128798.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/22/21 6:19 PM, Pavel Begunkov wrote:
> With dynamic buffer updates, registered buffers in the table may change
> at any moment. First of all we want to prevent future races between
> updating and importing (i.e. io_import_fixed()), where the latter one
> may happen without uring_lock held, e.g. from io-wq.
> 
> A second problem is that currently we may do importing several times for
> IORING_OP_{READ,WRITE}_FIXED, e.g. getting -EAGAIN on an inline attempt
> and then redoing import after apoll/from iowq. In this case it can see
> two completely different buffers, that's not good, especially since we
> often hide short reads from the userspace.

I don't think this is necessarily a problem. If you unregister a buffer
before IO completion of that IO, then you are putting yourself solidly
in grey zone areas anyway. You could still allow the short retry, just
double check that it's the same buffer at that point as a sanity
check.

-- 
Jens Axboe


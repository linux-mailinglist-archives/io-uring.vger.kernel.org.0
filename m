Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762042FC88C
	for <lists+io-uring@lfdr.de>; Wed, 20 Jan 2021 04:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731012AbhATDNt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 22:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730790AbhATDNq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 22:13:46 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC88C061757
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 19:13:06 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id m6so13638703pfk.1
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 19:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=dC1DtbWQxAc1Od6ES9ySL7nn2zxr4gaai95fsXX4yNw=;
        b=PJtdKdhGqdnuQCMH93nfXRqeoPIBobOeBgeYVqUf1QJApiKP/pim74qwQ7SwZHwdXr
         uOwfBDc3I31xY6x5lm65nns9DKguL6ExRRrXluEls9JyLw/D4oek9K0HCL11ikJF+VGN
         QwVbwfMlI82blfkZh9kLNLcpoVFazVgwRK8eV+1BRxQcIZQs+wwUNSwWtJEM0xpa0UXn
         EEFFJtV7/ZKm8wIhlKrb7mmKrd2ewSCJyzC7McH+OmtGfb7gUuMUxNXjjWtmtcFahtPB
         /n5gbZ4hMYGw3RTfzERtgasnIuG1PY82G6taj+izLABzEsdM+Ufz2lfXM7bHZRR/Vka7
         Sc5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dC1DtbWQxAc1Od6ES9ySL7nn2zxr4gaai95fsXX4yNw=;
        b=RpMgnnmJx6/V0R6aTiV+sxSNWd48ToWdtwQOkQNXqMKyz3B9vZfw2ck5uiFi804tS1
         t40Pv3r11fHgHMN7bYtPJfpJJraOnQjGPbot+sLOnEHxNklYF2mmCC8NXkCMufZqWQu9
         uATJ/6Ewog6oXTFtGyzb8KUd9XcUntM1QW8ZWalLfJ58ubsVzvfLIWTpqmJy8anLysAq
         g9faX1uPftnRGSPvwMJULSoVvIzMSLNbirBpPkAyHz+xvI/QEUXGFFrQb0MBgQUd55bg
         PpcbSRvkaiPGye87H5+/8sD/O6A2lCRD7W02tFcAfDBydfC6AY3D9csSMvJS7dQ3tGL6
         DXcw==
X-Gm-Message-State: AOAM530K45zYJD58og/jjQHmmw8Aj0Ez04Z5ahERduKMIapdxkNLBfdp
        p4NUhlgICR6sxaLqyLkUit8CzfnPYwNiIQ==
X-Google-Smtp-Source: ABdhPJyBS3SUDc/O/T4jZPYfG2QORiF+HO8MQhWlh8Dz6g9wo5ClaLODT70o0AhY81s95hneSliBMA==
X-Received: by 2002:aa7:86cc:0:b029:1b8:c490:13e6 with SMTP id h12-20020aa786cc0000b02901b8c49013e6mr7143689pfo.78.1611112385553;
        Tue, 19 Jan 2021 19:13:05 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id mv17sm337467pjb.17.2021.01.19.19.13.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 19:13:04 -0800 (PST)
Subject: Re: [PATCH 0/3] files cancellation cleanup
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1611109718.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <403f676f-552f-5c54-c6b4-68a114691bbb@kernel.dk>
Date:   Tue, 19 Jan 2021 20:13:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1611109718.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/19/21 7:32 PM, Pavel Begunkov wrote:
> Carefully remove leftovers from removing cancellations by files
> 
> Pavel Begunkov (3):
>   io_uring: remove cancel_files and inflight tracking
>   io_uring: cleanup iowq cancellation files matching
>   io_uring: don't pass files for cancellation

This is exactly what I was thinking as the 5.12 cleanup on top of the
5.11 changes! Looks good to me, thanks.

-- 
Jens Axboe


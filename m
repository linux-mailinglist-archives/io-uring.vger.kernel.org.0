Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829593F7C8B
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 21:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240176AbhHYTFw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Aug 2021 15:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbhHYTFw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Aug 2021 15:05:52 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1955DC061757
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 12:05:06 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id g9so326088ioq.11
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 12:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YOk+LKU2O/KCUV1kulXR70Qv3h0BkmPp/r50GQgNVAM=;
        b=QQ5sVsym2DvzXXJs7DUnZ6uKYT1MjJYmiLvyxuODFUHsJJ/wiv3AenUSwH+NG0Lanb
         AEka9bZ/CcyQrfZaaf3cSrbDPo+JaT2mtqhhPqO4v8D+ibItGkvNdljMPTaNl1Zz8xfM
         AoeBHrtJTKGqqgLY51ijbmnuQPePuyOp7OtwZQ6vHtJxVyEZkPn/NMf0kAhgYCmfMxfz
         h+U3E0NSvtb7+Fqaoaomu7VAamjP966IAW4LO2U/D+96Mv2u3o02gE2HKIZzzSF1VQlj
         9GxL4/hjAKeiTFHzoTVRgX4+KSWJ9sGjEOGM/kM73Gfda2sUUsFEnzZGxQdAD/TDQV+A
         1THw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YOk+LKU2O/KCUV1kulXR70Qv3h0BkmPp/r50GQgNVAM=;
        b=nFLBKeOwwAOgQWtptM7Q2b9AeuExkrLvIVxMRL1h0EpBodoaRaMAWivkhWZOhBUVuR
         1iQOS1m6lwAQcQIIwl2cp+fPMwJfcyuBKBy1Ci4ze+C86YVZrbRzlcT+hXGZ5o2oeZc4
         U7pEABoLqPWJHaW+uYgPBVFsG3sMPMLGM8Oc+jxF6/0zliklkBcJtLgDWLQc7BpvCJCg
         v1oDhKTSiBByeTiEN1rPq/pdrhJOUfLJLhVCf6iW3VGepAMe1+ggcapBfi8O2IbswjET
         SD8hLnhE+uKzEBqyCmKKnMNrUzdsH5oiwCCYreQo2cMKYfPeH9pl0fJGYi3sX76mz2UU
         QdKA==
X-Gm-Message-State: AOAM533sZQ9ya0W7k2gs264Hai+xoA9tEJAfD+ViyjRHMd8rdYu1hnOf
        /9tXVPYCB6bShvf4yQovZZqDqA==
X-Google-Smtp-Source: ABdhPJyNg+wEtmkdIlX29wuidvisY29Owfo9sWBoCj8FhSmGdERt6hivZe/4xWW2ypF2mTPDxu+ptA==
X-Received: by 2002:a02:a1c3:: with SMTP id o3mr954887jah.59.1629918305438;
        Wed, 25 Aug 2021 12:05:05 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z15sm308290ioh.28.2021.08.25.12.05.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 12:05:05 -0700 (PDT)
Subject: Re: [PATCH for-5.15 v2] io_uring: don't free request to slab
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210825175856.194299-1-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d9e5bbaf-ed88-8f17-a0d2-4b00dd18a40f@kernel.dk>
Date:   Wed, 25 Aug 2021 13:05:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210825175856.194299-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/25/21 11:58 AM, Hao Xu wrote:
> It's not necessary to free the request back to slab when we fail to
> get sqe, just move it to state->free_list.

Thanks, applied.

-- 
Jens Axboe


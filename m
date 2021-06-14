Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E12D3A68ED
	for <lists+io-uring@lfdr.de>; Mon, 14 Jun 2021 16:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234504AbhFNO1X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Jun 2021 10:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234440AbhFNO1W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Jun 2021 10:27:22 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF99FC061574
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 07:25:06 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id j11-20020a9d738b0000b02903ea3c02ded8so10981051otk.5
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 07:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=PHG7jQrzu29pRx3seYxeoSOpsqFbB7y6QPyUfOzVL1k=;
        b=CcVJ25zaLfWk5VLonMJOt2dF1dJMtzoJW9MFC4bxnCGJrGQgv/wZiw3aKK//e9WLfw
         PtklG02KYKICdE24NX33PAUqS3loNF5O4zbCmzXFIWsZ20S5ewT0ug8Jx0U2Nzl7Tx8B
         tABkHT0vEQYwEWOg4Yn2gzvt74WcBXhMzXZCzoeM7Yf0KQ3RhEh8jnbKxpK/eE026nAc
         C+YDrQA2JkU16KO/xKYw7GBF0LrauGSgdkE/kXVH7aIfoLuW4Kvur5kVmibgP8wTNjCZ
         ckRh6GuIP7MoldNq/mKfi9eYEQOFlsxASLxvFlGAQw4VX86/UIOyfzMf5G3WxmF8Ol2p
         Js5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PHG7jQrzu29pRx3seYxeoSOpsqFbB7y6QPyUfOzVL1k=;
        b=Od4s/lV0Hfdlno/Uc3piEQNjpiIiL7FuOKvpOS3+LUpC2dImzp4H1FLJ8pPcfSq6oi
         i0FNi/Ogl9mPkZNEryTXeL9mXCVxXjfmazecbkAKbOSHbXLSu6kg+vdqy/cMLiujC4Gk
         a2xQpg6Wx71Y73qQEbXDzaMPwmuEz4bp3iBU3orQ5H7EK9nz0nxRmBwP6iVh2k3ARQs+
         eRHLCXvJgIsIaBsToyQpr/+3som+/OQxLO59qceawOYZJzIuTyZlaEjbWIjXBl7mYuQZ
         ucM3T0Xm9h0DnAorniYlXRqIIF8ZnZVx8+okInZmh23k7EVrQDTtm7de2M9r636QnlzJ
         PQOg==
X-Gm-Message-State: AOAM530a9k2TUIH9ehL+ijmI1LsBLGI3e3gdxZaJxgTG3NdXC5PPjIfF
        nJs7OGh3iPHS273Vlkg1W/3EzGlHGl5KAA==
X-Google-Smtp-Source: ABdhPJxx4OVSMazBZECnLphhBPL1lDLbOFka51RCpY98cRIl2sVdOVM1MZE7rJSfM0reRaZtzlBixQ==
X-Received: by 2002:a05:6830:33ef:: with SMTP id i15mr13743505otu.311.1623680705938;
        Mon, 14 Jun 2021 07:25:05 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id j3sm2959178oii.46.2021.06.14.07.25.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 07:25:05 -0700 (PDT)
Subject: Re: [PATCH v2 for-next 00/13] resend of for-next cleanups
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1623634181.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d0798c89-3dbb-35e9-323e-d55c422bfc0c@kernel.dk>
Date:   Mon, 14 Jun 2021 08:25:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1623634181.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/13/21 7:36 PM, Pavel Begunkov wrote:
> The series is based on the 5.14 branch with fixes from 5.13 that are
> missing applied on top:
> 
> 216e5835966a io_uring: fix misaccounting fix buf pinned pages
> b16ef427adf3 io_uring: fix data race to avoid potential NULL-deref
> 3743c1723bfc io-wq: Fix UAF when wakeup wqe in hash waitqueue
> 17a91051fe63 io_uring/io-wq: close io-wq full-stop gap

With the API change, I rebased the 5.14 branch and applied this on
top.

-- 
Jens Axboe


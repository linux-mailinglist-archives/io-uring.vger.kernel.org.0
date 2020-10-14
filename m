Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FAA28E7A5
	for <lists+io-uring@lfdr.de>; Wed, 14 Oct 2020 22:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbgJNUDb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Oct 2020 16:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbgJNUDb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Oct 2020 16:03:31 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD92EC061755
        for <io-uring@vger.kernel.org>; Wed, 14 Oct 2020 13:03:30 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id b127so813298wmb.3
        for <io-uring@vger.kernel.org>; Wed, 14 Oct 2020 13:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UNDeWoVbQCH+0QPl1wWUzgnyYvrIenl37pDjL7xIyiI=;
        b=llUD33Tm5isV4J4UKpohnUYtC8uI61OdS9H1bxYpprKz6MdLY6tuO128mwIVAeaxUm
         YO/O6p9+MQZ1G28kC4n17pW6VkpKAfIXrOWgYFyOv3aktjsxsl6fb21JFyeOMVPtqxGj
         nsalC7eqE4IZ9HbL5rJjNtmdvL3YxTHg0KwCUT43urdL9jd3iNH8FYiEGVS9C5P2LTF8
         UO/mX2YraiU1ZPN7W8h1qxppCVlYMRAnMbB5JRKVg90/pg8Ocv+Y0Kaka6MazFrb6z4f
         K5HfY4tTLEBnbOinm5gFSc+nuMOrt7MUkq2k6kJ/b0JzAj44gHSJCW5d7X3f+4WPybH2
         Dmgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UNDeWoVbQCH+0QPl1wWUzgnyYvrIenl37pDjL7xIyiI=;
        b=ek4JVS1nGQY/6KluJpQDoQ7hnYVHLDNl0mLcCV/1D6B8BszbTS16NO4SJczQnnBQor
         6FXQ3/iFxmrGFeUvmFDqUfrqcE2ZAUPkJ1KBy2o5Cp8uqrtvcQKzrUMGC8mlMT2VIFrU
         RLx/N2/Qfp+yVqBb7/8KSWhyZ0RY27j30kU2yN9S28Srg9E6NJXqorCvlsPD3Kkq+8vU
         ij0tPU2etT7OVBzz7Y9PCYYlDCAs+CjoqjXWg/NjisFoEhHgZ/hWDwlTXIRXB5foOQO/
         y0t73yM2LwBjmKcAlrZ4FaBZxkSVpao1J9yGISRuN8riM8bkMAsUeaszAprE0xVIhEJY
         YHiQ==
X-Gm-Message-State: AOAM533EinkB6hHmDo7gjFCJbVuPEX0mLw9RNNkg9Htsh7fhgqkH0+R4
        qAaz23guNeIQofhV2BpHB50tanEqftr+uA==
X-Google-Smtp-Source: ABdhPJyo7fZjQxMaWc7IW7h7/l4Gwmm0yBBo7D89QQ3Gkcz7EINHnTIDUfzCN/MfrLpPePnb5gNCjg==
X-Received: by 2002:a1c:20d0:: with SMTP id g199mr539163wmg.38.1602705809126;
        Wed, 14 Oct 2020 13:03:29 -0700 (PDT)
Received: from [192.168.1.82] (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id n9sm584359wrq.72.2020.10.14.13.03.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2020 13:03:28 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1602703669.git.asml.silence@gmail.com>
 <ec396af4-d2ec-81d9-3ddd-4d66f22bbf91@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 0/2] post F_COMP_LOCKED optimisations
Message-ID: <4003979c-f467-316f-cf6f-299dff23d17c@gmail.com>
Date:   Wed, 14 Oct 2020 21:00:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <ec396af4-d2ec-81d9-3ddd-4d66f22bbf91@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 14/10/2020 20:53, Jens Axboe wrote:
> On 10/14/20 1:44 PM, Pavel Begunkov wrote:
>> A naive test with io_uring-bench with [nops, submit/complete batch=32]
>> shows 5500 vs 8500 KIOPS. Not really representative but might hurt if
>> left without [1/2].
> 
> Part of this is undoubtedly that we only use the task_work for things
> that need signaling, for the deferred put case we should be able to
> get by with using notfy == 0 for task_work.
> 
> That said, it's nice to avoid when possible. At this point, I'd like
> to fold these into the last patch of the original series. What do you
> think?

Yep, was thinking the same. It's better to be in 5.10, and that would
be easier to do by squashing.

-- 
Pavel Begunkov

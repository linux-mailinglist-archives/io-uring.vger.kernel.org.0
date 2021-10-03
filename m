Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB10B4201A3
	for <lists+io-uring@lfdr.de>; Sun,  3 Oct 2021 15:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbhJCNJJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Oct 2021 09:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbhJCNJI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Oct 2021 09:09:08 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320BCC0613EC
        for <io-uring@vger.kernel.org>; Sun,  3 Oct 2021 06:07:21 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id 5so4614500iov.9
        for <io-uring@vger.kernel.org>; Sun, 03 Oct 2021 06:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=IkmzbcuTdn2YA6aq1IykjRjixnnRCScer1r6YmKlZjk=;
        b=UmaiB1bvLBGzI1RHqJsf7KLjtAVSabIwKu2LwPWsm6k8cTD2jmZNZ3V1vwAdT0HGJK
         XbjuFhTGhRViz8u0ib6aZAXa0WaK68RfEtaks2feVM4717OArjevO6pE8kkV2yg3+N1z
         BmBQLirPl6Yi4sydo2PEY5GNc2s1HNlTRqVD8G2e8eqF4KJKtS2UjepOejJSXUs0NyG4
         G2wLpEQPjnsz7Y5IOIf/hEITfHVL+UJN6vP8SRUMv4z7ItkHZS4iBxoXeDIQ71htab4U
         SmbEB+6YDvaFvv7bMEqscMNa5rukZq4qFB+n+TUJEOhs43a94IU36RWVqJFaKToupqiM
         F5FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IkmzbcuTdn2YA6aq1IykjRjixnnRCScer1r6YmKlZjk=;
        b=P9Nv1AHuKTX6mfYufPd+qYVq3fCxZpYnepDSiYih05pWb3ltLq6n2CQZkBg/x9zD3k
         Xkxjumn0izIq/UPgjkYDwbc5DV1I/ohDW9dI30WjwxTghMb7LWb9uGSgZpf9W2fxUMZi
         bkn/CHxB7dTJnG0Yt7XO8c0f9RQzW8jiyilKYRBsLDFRZ0jP8jpdsXGPeiZIGZSexNCS
         /V/rhe9SC3Zi5+kIyA3RuWIkDKV6IAo+IMiik7HKPR4VG8HWPJ2anQb6xct9/l4wg+3s
         Wvrxy7L+k4LHql8z7TYtxz4DcYaIjuUB8//m35TkdIls4QfaXj2Q40HypzyIal9NMEnQ
         //yQ==
X-Gm-Message-State: AOAM5335GL8wyADVal9KeV0do0e3DctflfIm9dr3LEh8DCBDaNor/AEQ
        RMkPRoLuFCrnDYdOOQ0Di2wL3LXWD8XnFQ==
X-Google-Smtp-Source: ABdhPJxXmBzzm/A5ayvzdEuE025wfGMuuWZ5omZK9JGFzq+/mE5FPPM9hSbq3YKVdwrtboxL/nClkQ==
X-Received: by 2002:a05:6602:3403:: with SMTP id n3mr5702064ioz.35.1633266439670;
        Sun, 03 Oct 2021 06:07:19 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id v19sm3414638ioh.44.2021.10.03.06.07.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Oct 2021 06:07:19 -0700 (PDT)
Subject: Re: [PATCH liburing 0/2] timeout tests
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1633259449.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d05fda77-37c8-3a9a-932d-3913740051fd@kernel.dk>
Date:   Sun, 3 Oct 2021 07:07:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1633259449.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/3/21 5:10 AM, Pavel Begunkov wrote:
> 1/2 tests IORING_TIMEOUT_ETIME_SUCCESS,
> 2/2 works around a pretty rare test timeout false failures

Applied, thanks.

-- 
Jens Axboe


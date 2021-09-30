Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347DA41DE59
	for <lists+io-uring@lfdr.de>; Thu, 30 Sep 2021 18:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347991AbhI3QGl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Sep 2021 12:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346913AbhI3QGl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Sep 2021 12:06:41 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5046C06176A
        for <io-uring@vger.kernel.org>; Thu, 30 Sep 2021 09:04:58 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id t15so5007655ilj.1
        for <io-uring@vger.kernel.org>; Thu, 30 Sep 2021 09:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=mL7PyfBlSExzFN7ULRo5F0OQ3ENeR18OOqR+JJn/Sw0=;
        b=6XbhO5ZoPyEtrpMFP3lRe928a083t1nBtJ5kZVkg9JTGt1A4dTnILhdvkW36jcQtKA
         xvnOE7pl8zu/gKQhiDqR7wEVJ+fVBEIsu0qwbzZ2AvZ/ArWqm4YLPq58tTNncX7Z1wEM
         27FVV5BeqE7Jk9IbzFivCVd09mWiZbMW2Mbt6Tj9crc+ZCjXAhNTp0IV9PvU2I1cY3RP
         +aqvjSItXz/eQJh6ZX9wmdx8IbMDjpMcn/japiKhlLGNoWPJzROlYNAMBEZN95p155e6
         06kzgNNuZWpCIEJAoDMEkWhxXE+kITtjRWopczZSAP5HF1bfGMY1pEKzGLQeNUVpn+jQ
         pppA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mL7PyfBlSExzFN7ULRo5F0OQ3ENeR18OOqR+JJn/Sw0=;
        b=quzHxz6jnSDp1vIld7+w48dsZQt9C4/0DInvRA3a69r6e7dOZrbZD4tIxig83NYjCr
         HRuyM/r0GGZZahX9+gFVA5NAWn8n3FdG38DqvVIX3XSv6wgVxEcaKVhWAa3eCMuDyWEI
         zt7m+i3yWKnEQxECCFPEkxglTCG4V8xxgtdnXJm+ABdjnpgJr8U2+Tqiaitwa0hgQr18
         eXYhSfqdn/iOR9bMGDzEfuoWQ/QrF2wBG0VmJ0YGKMsU4vH43W6k8E1vzmLQuNdFq9+P
         Kxw8eGSM5zjKgRHQhg1oIQ3wWs5okULTE3c/MlVblgVqhgEOCHgqTTQChvGxSFBpJWqc
         AwQw==
X-Gm-Message-State: AOAM533hM+hJInTlqnccihcij7X1gchvJ9JQPJERUwJvgi7cm5NAKVEp
        NbPmP+Gey7PO2ORspBeqsahXW3EHym/fHaKWgiM=
X-Google-Smtp-Source: ABdhPJzVqVTGgwOPwCf0DykwJSRkd+sWk/KGg0K1ITnsEO8ARwIdMz1WS9UexJsEbJzGZke+jzWNzQ==
X-Received: by 2002:a92:ca84:: with SMTP id t4mr4785874ilo.41.1633017893966;
        Thu, 30 Sep 2021 09:04:53 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s8sm1911912ilt.47.2021.09.30.09.04.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 09:04:53 -0700 (PDT)
Subject: Re: [PATCH v2 00/24] rework and optimise submission+completion paths
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1632516769.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e5a5e7f8-f602-ba2d-8077-06dfdf226705@kernel.dk>
Date:   Thu, 30 Sep 2021 10:04:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1632516769.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/24/21 2:59 PM, Pavel Begunkov wrote:
> 24 MIOPS vs 31.5, or ~30% win for fio/t/io_uring nops batching=32
> Jens mentioned that with his standard test against Optane it gave
> yet another +3% to throughput.
> 
> 1-14 are about optimising the completion path:
> - replaces lists with single linked lists
> - kills 64 * 8B of caches in ctx
> - adds some shuffling of iopoll bits
> - list splice instead of per-req list_add in one place
> - inlines io_req_free_batch() and other helpers
> 
> 15-22: inlines __io_queue_sqe() so all the submission path
> up to io_issue_sqe() is inlined + little tweaks

Applied for 5.16, thanks!

-- 
Jens Axboe


Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E776161FB
	for <lists+io-uring@lfdr.de>; Wed,  2 Nov 2022 12:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiKBLpp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Nov 2022 07:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbiKBLpl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 07:45:41 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF5C28716
        for <io-uring@vger.kernel.org>; Wed,  2 Nov 2022 04:45:40 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id a14so24139830wru.5
        for <io-uring@vger.kernel.org>; Wed, 02 Nov 2022 04:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V5cy7CWHGcl1a3XD47Suxb2aiicUXLdkcs8voB8Ro0c=;
        b=PZ/dXfkTejg9R80/Mkt4+/+eLzgD+X1DpYdOdb/AbNJrd6kIOc8UTGTEYYObTDoPg/
         /q1zSbezJjV0i0/lh3g1H0RGyGLEY18whTUM4SIiGv+gaqovAliaGNRX5uyPNHjKHLoT
         N54p+B8oFvoT26frjBzm5tTRp5Kz+xUToy1vn7L1rHziFvEwftgzmTe754HdHpdOlXde
         ZiOqQj60Av95OMVBW00xw/sK74DXSCTvFtvlX0Bp6nG0+DfFsMs0Y7fYd7RGbNJBNAWq
         Ew+HKc8eHvx57PZb0mT0riZ0SMWQoTzl3iOWvivYJfkHa+gRGTD3TMhF3HqV6KOyjDJ2
         emvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V5cy7CWHGcl1a3XD47Suxb2aiicUXLdkcs8voB8Ro0c=;
        b=pvONfbJAGUPtp3+nH063JwVecfYj9JkoVEngJiG77xO96DBXe4mhmEP521ml/yggL/
         9smbIgsTsSbuiatFJ8sipgOmvgx2B9Ey9X70Q/lGVYD1N/iG16rOBq8itpzrURIoYAcN
         VY4ZH/48LmDFSWcP0dAzXVsCzJt+vARiifT/pTDl2GAO295RvXHYRmOM8phr6Eay5zGj
         HIxobYomE6FVLmoixWpCz1QPYgzy5lWjLFVEegpuaMdtgfN30f096Ez8KsYG0vdRrAJg
         oVxohnkzqqKaxDzFyNq49eEVQckDomzHr2HiNKJH0Rr9mieiOBf00FfYTCR/AM43N7az
         qZ8A==
X-Gm-Message-State: ACrzQf1fCDYsjesJ0JEBgLrvSLgskPFxls3JC6acCW0lW5Y6HOTKdBAj
        1H3ef+0+YKOGYDXBMRLQ7BU=
X-Google-Smtp-Source: AMsMyM6iq9j0q9QNloVxp6b7Cg0x0RpeSrxfQqGj6vzbbb/Sf98+e2o4tV2+8LcQlMH69bxW2X4MSw==
X-Received: by 2002:a5d:6d02:0:b0:236:ed2d:b3eb with SMTP id e2-20020a5d6d02000000b00236ed2db3ebmr2594068wrq.456.1667389539111;
        Wed, 02 Nov 2022 04:45:39 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:2739])
        by smtp.gmail.com with ESMTPSA id k5-20020a05600c1c8500b003b47b80cec3sm1978374wms.42.2022.11.02.04.45.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 04:45:38 -0700 (PDT)
Message-ID: <4f198467-e017-1ec8-ea3c-d6a67c48dd6e@gmail.com>
Date:   Wed, 2 Nov 2022 11:44:40 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH for-next 00/12] io_uring: retarget rsrc nodes periodically
To:     Dylan Yudaken <dylany@meta.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
References: <20221031134126.82928-1-dylany@meta.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20221031134126.82928-1-dylany@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/31/22 13:41, Dylan Yudaken wrote:
> There is a problem with long running io_uring requests and rsrc node
> cleanup, where a single long running request can block cleanup of all
> subsequent nodes. For example a network server may have both long running
> accepts and also use registered files for connections. When sockets are
> closed and returned (either through close_direct, or through
> register_files_update) the underlying file will not be freed until that
> original accept completes. For the case of multishot this may be the
> lifetime of the application, which will cause file numbers to grow
> unbounded - resulting in either OOMs or ENFILE errors.
> 
> To fix this I propose retargeting the rsrc nodes from ongoing requests to
> the current main request of the io_uring. This only needs to happen for
> long running requests types, and specifically those that happen as a
> result of some external event. For this reason I exclude write/send style
> ops for the time being as even though these can cause this issue in
> reality it would be unexpected to have a write block for hours. This
> support can obviously be added later if needed.

Is there a particular reason why it tries to retarget instead of
downgrading? Taking a file ref / etc. sounds more robust, e.g.
what if we send a lingering request and then remove the file
from the table? It also doesn't need caching the file index.


> In order to retarget nodes all the outstanding requests (in both poll
> tables and io-wq) need to be iterated and the request needs to be checked
> to make sure the retargeting is valid. For example for FIXED_FILE requests
> this involves ensuring the file is still referenced in the current node.
> This O(N) operation seems to take ~1ms locally for 30k outstanding
> requests. Note it locks the io_uring while it happens and so no other work
> can occur. In order to amortize this cost slightly, I propose running this
> operation at most every 60 seconds. It is hard coded currently, but would
> be happy to take suggestions if this should be customizable (and how to do
> such a thing).
> 
> Without customizable retargeting period, it's a bit difficult to submit
> tests for this. I have a test but it obviously takes a many minutes to run
> which is not going to be acceptable for liburing.

We may also want to trigger it if there are too many rsrc nodes queued

> Patches 1-5 are the basic io_uring infrastructure
> Patch 6 is a helper function used in the per op customisations
> Patch 7 splits out the zerocopy specific field in io_sr_msg
> Patches 8-12 are opcode implementations for retargeting
> 
> Dylan Yudaken (12):
>    io_uring: infrastructure for retargeting rsrc nodes
>    io_uring: io-wq helper to iterate all work
>    io_uring: support retargeting rsrc on requests in the io-wq
>    io_uring: reschedule retargeting at shutdown of ring
>    io_uring: add tracing for io_uring_rsrc_retarget
>    io_uring: add fixed file peeking function
>    io_uring: split send_zc specific struct out of io_sr_msg
>    io_uring: recv/recvmsg retarget_rsrc support
>    io_uring: accept retarget_rsrc support
>    io_uring: read retarget_rsrc support
>    io_uring: read_fixed retarget_rsrc support
>    io_uring: poll_add retarget_rsrc support
> 
>   include/linux/io_uring_types.h  |   2 +
>   include/trace/events/io_uring.h |  30 +++++++
>   io_uring/io-wq.c                |  49 +++++++++++
>   io_uring/io-wq.h                |   3 +
>   io_uring/io_uring.c             |  28 ++++--
>   io_uring/io_uring.h             |   1 +
>   io_uring/net.c                  | 114 ++++++++++++++++--------
>   io_uring/net.h                  |   2 +
>   io_uring/opdef.c                |   7 ++
>   io_uring/opdef.h                |   1 +
>   io_uring/poll.c                 |  12 +++
>   io_uring/poll.h                 |   2 +
>   io_uring/rsrc.c                 | 148 ++++++++++++++++++++++++++++++++
>   io_uring/rsrc.h                 |   2 +
>   io_uring/rw.c                   |  29 +++++++
>   io_uring/rw.h                   |   2 +
>   16 files changed, 390 insertions(+), 42 deletions(-)
> 
> 
> base-commit: 30209debe98b6f66b13591e59e5272cb65b3945e

-- 
Pavel Begunkov

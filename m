Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16A4757FF0C
	for <lists+io-uring@lfdr.de>; Mon, 25 Jul 2022 14:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiGYMfo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 08:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232450AbiGYMfm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 08:35:42 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B01FDEFD
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 05:35:41 -0700 (PDT)
Received: from [192.168.88.254] (unknown [125.160.106.238])
        by gnuweeb.org (Postfix) with ESMTPSA id 1FB047E257;
        Mon, 25 Jul 2022 12:35:39 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1658752541;
        bh=bu5GJXcXdXRLDXkXTNfT79BaAAA3a8RLcvV1AlCRxf0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=bGhurSgjMvBCzrDYtrKzQi4eUAOI3TcMdsd9LM/okIFzwdZS78jQ8Hs74YBkDeg1P
         YCKxN3oJJlThZUdJilQ9Aeci2gPGH9VOBtT94F8ezV2gLZdMYZD/eRWCp1Lrso/EBX
         VXe7euLsEK3pg0mKUzByJnVv7yqFU2pFHGvnki9zgTDAHv8WQpSGFBIRQ5sUeOqrBN
         c/sTWkIUljQhKRa16QTZBkVS2tvOKoyG+6EpKFjT5+9voYhxr4vttLa18y1xXfDILS
         jMZxWMHx1QFKTIyL0qSyZToT1u2O240lcw1mfOl618j91CAT39W2gkr3LoXM0r7o3J
         MoP9ToYOM1Grw==
Message-ID: <7efb353d-46ab-47ce-e85e-43ccfb6c8fc0@gnuweeb.org>
Date:   Mon, 25 Jul 2022 19:35:37 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing v2 2/5] liburing: add zc send and notif helpers
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1658748623.git.asml.silence@gmail.com>
 <b17478e75fc676260acf618b60cf31a85d8c3b06.1658748624.git.asml.silence@gmail.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <b17478e75fc676260acf618b60cf31a85d8c3b06.1658748624.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/25/22 6:33 PM, Pavel Begunkov wrote:
> Add helpers for notification registration and preparing zerocopy send
> requests.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   src/include/liburing.h | 42 ++++++++++++++++++++++++++++++++++++++++++
>   src/liburing.map       |  2 ++
>   src/register.c         | 20 ++++++++++++++++++++
>   3 files changed, 64 insertions(+)
[...]
> +static inline void io_uring_prep_notif_update(struct io_uring_sqe *sqe,
> +					      __u64 new_tag, /* 0 to ignore */
> +					      unsigned offset, unsigned nr)
> +{
> +	io_uring_prep_rw(IORING_OP_FILES_UPDATE, sqe, -1, 0, nr,
> +			 (__u64)offset);
> +	sqe->addr = new_tag;
> +	sqe->ioprio = IORING_RSRC_UPDATE_NOTIF;
> +}

The same nit on there. But overall it looks good.

Reviewed-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

-- 
Ammar Faizi

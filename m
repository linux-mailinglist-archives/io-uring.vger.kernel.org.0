Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E67C57158B
	for <lists+io-uring@lfdr.de>; Tue, 12 Jul 2022 11:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbiGLJSu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jul 2022 05:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232641AbiGLJSt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jul 2022 05:18:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50EE11F2DE
        for <io-uring@vger.kernel.org>; Tue, 12 Jul 2022 02:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657617524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nqE/jzjwP7jwk2FmoVCVvujtcooqMUAch43GDeT3Y2M=;
        b=c+Xgx63sG/OobnuvF5IvR7WNTwygkajbsqtGpInckKSOrcAofgji2oG9JL00j/Oa94BH92
        RJ8kM4NOLy4DBm5T6ww8rPbgNoKfaGRXYMJxPduJP8TYoGPhWNM2++g1jPFfk8Gymzt5V0
        aWBM4Bp26KVtQ1EV2TPLdhvQdBpXvLk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-66-UGpFfXb4M3u87bqmQC1ghA-1; Tue, 12 Jul 2022 05:18:36 -0400
X-MC-Unique: UGpFfXb4M3u87bqmQC1ghA-1
Received: by mail-wm1-f72.google.com with SMTP id g22-20020a7bc4d6000000b003a2e0951432so3518684wmk.9
        for <io-uring@vger.kernel.org>; Tue, 12 Jul 2022 02:18:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=nqE/jzjwP7jwk2FmoVCVvujtcooqMUAch43GDeT3Y2M=;
        b=uE9iVK5Snv0pYgfL0BsE3MB4d89FvfDlwQUmRJRH384Rvdyv6TCihfhXDFsBMUrDhl
         CUHv/fAKDVd99Dr30JM7fqm9E+Ky7P+WkD20/ctR3NVfoJZ8CrxYKbvcGX+8VQRRd947
         F5+ieTwqvlF05xU3bHJXEjPoBG69WbMVJ6l1NxsGa2VqPMoEz2oOiTxE2l6YetzE2DiF
         87zN7j4kJywrYdTqzJJ6W0Pjp/ceTFaD/AzrriScQylePD2II4PBy7bmErVIa+23T32i
         4EF1xnD1OeD5GZUe5nypVkkDm4qclGA1J0NrpSWiLvtUy6kEX8rSNyOcY5YVtDuTOZzd
         Aemg==
X-Gm-Message-State: AJIora+iyz9JbDEJXhXPFFyQA3mr+8BcuinvH1fyY3GCeTawiaeSKL4n
        qOPLynIHZolIaQt0C+gaQ10r1T8F+3iFf/ghTZHzpgyAEwAB1dxFh6DgxIsLasX2hpxNY1alrPl
        DhB0VVxIDVl4rMBf11I0=
X-Received: by 2002:a05:600c:1906:b0:3a0:d983:cc2b with SMTP id j6-20020a05600c190600b003a0d983cc2bmr2788745wmq.81.1657617515503;
        Tue, 12 Jul 2022 02:18:35 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sz3uW2QDGN5byP2NMgZglyEfzIAOr/VYaEK5vUKbK9DZJUDKq8PvoHa62nVWhM6Z1dZyOfCw==
X-Received: by 2002:a05:600c:1906:b0:3a0:d983:cc2b with SMTP id j6-20020a05600c190600b003a0d983cc2bmr2788721wmq.81.1657617515297;
        Tue, 12 Jul 2022 02:18:35 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-238.dyn.eolo.it. [146.241.97.238])
        by smtp.gmail.com with ESMTPSA id n35-20020a05600c502300b003a2d0f0ccaesm12906153wmr.34.2022.07.12.02.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 02:18:34 -0700 (PDT)
Message-ID: <88f9133542d0a4bf2100e0a521f6e6a19eb2feb1.camel@redhat.com>
Subject: Re: [PATCH for-next 0/3] io_uring: multishot recvmsg
From:   Paolo Abeni <pabeni@redhat.com>
To:     Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, io-uring@vger.kernel.org
Cc:     netdev@vger.kernel.org, Kernel-team@fb.com
Date:   Tue, 12 Jul 2022 11:18:33 +0200
In-Reply-To: <20220708184358.1624275-1-dylany@fb.com>
References: <20220708184358.1624275-1-dylany@fb.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 2022-07-08 at 11:43 -0700, Dylan Yudaken wrote:
> This series adds multishot support to recvmsg in io_uring.
> 
> The idea is that you submit a single multishot recvmsg and then receive
> completions as and when data arrives. For recvmsg each completion also has
> control data, and this is necessarily included in the same buffer as the
> payload.
> 
> In order to do this a new structure is used: io_uring_recvmsg_out. This
> specifies the length written of the name, control and payload. As well as
> including the flags.
> The layout of the buffer is <header><name><control><payload> where the
> lengths are those specified in the original msghdr used to issue the recvmsg.
> 
> I suspect this API will be the most contentious part of this series and would
> appreciate any comments on it.
> 
> For completeness I considered having the original struct msghdr as the header,
> but size wise it is much bigger (72 bytes including an iovec vs 16 bytes here).
> Testing also showed a 1% slowdown in terms of QPS.
> 
> Using a mini network tester [1] shows 14% QPS improvment using this API, however
> this is likely to go down to ~8% with the latest allocation cache added by Jens.
> 
> I have based this on this other patch series [2].
> 
> [1]: https://github.com/DylanZA/netbench/tree/main
> [2]: https://lore.kernel.org/io-uring/20220708181838.1495428-1-dylany@fb.com/
> 
> Dylan Yudaken (3):
>   net: copy from user before calling __copy_msghdr
>   net: copy from user before calling __get_compat_msghdr
>   io_uring: support multishot in recvmsg
> 
>  include/linux/socket.h        |   7 +-
>  include/net/compat.h          |   5 +-
>  include/uapi/linux/io_uring.h |   7 ++
>  io_uring/net.c                | 195 ++++++++++++++++++++++++++++------
>  io_uring/net.h                |   5 +
>  net/compat.c                  |  39 +++----
>  net/socket.c                  |  37 +++----
>  7 files changed, 215 insertions(+), 80 deletions(-)
> 
> 
> base-commit: 9802dee74e7f30ab52dc5f346373185cd860afab

I read the above as this series is targeting Jens's tree. It looks like
it should be conflicts-free vs net-next.

For the network bits:

Acked-by: Paolo Abeni <pabeni@redhat.com>

Cheers,

Paolo


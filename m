Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE3B776083
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 15:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbjHINVH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 09:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbjHINVH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 09:21:07 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06CFC1;
        Wed,  9 Aug 2023 06:21:05 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id 6a1803df08f44-63cf9eddbc6so4436416d6.0;
        Wed, 09 Aug 2023 06:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691587265; x=1692192065;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nwP+8GKyNioN79R+S+05Z2xZJ2OZ1LBS9/Chf0Y6fAM=;
        b=GtXH2AScZ1vnntGc8QW099qNICz3/SL4CXv3xEIkA5oW2CORdoskzs3bZuOc04DSWJ
         xfy3HYvm/P1fs4bZejallLe43rqHI3v0ikB76NlnOGL0gcjY63jnkm54zHUkeH0srGEK
         LUbkMYqdlYMpYUaQ+WIyGIZRZ47KNwFwHNdmMRxRq20vEtYjfgoQh8kLwThGLbCQ1Swo
         ywKbYDBt5vYQJ0Oq4t5ZlXsBNMS2QAZcIzmvhl7Avqbr2T3oV3UVS6B7BBo2ztJdf9u0
         miMR35zYD8mD7UIrjveJZU1gl/m/TkAq3JyclGhBKh5FRUYC8MQn+gTRHWRAgFSoyQ/J
         IPnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691587265; x=1692192065;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nwP+8GKyNioN79R+S+05Z2xZJ2OZ1LBS9/Chf0Y6fAM=;
        b=JKWdyP8R2+b80SFrewM3+dG2MmlhJNaFxLg29bmzJ4WosPvvhTHx2yJqlzeaX+D12/
         E0FU0+gq1h4gVDCNTqv4ROxTYI8aigAGd3csDuMOJwXWQBPnVjsbGTnXN2GwIrKjbA+j
         QwRb23FBfqUrl/gpIF0gU1EYmZuqi7g4O1W5836Sx8SVykgRz4bU1UWN9rdiE3gtl9xq
         CGGyi3FZvNDC05v7UcYmohiu48IGmWK9kedTuZvtRrpc5Z9kRWUsqhL1BG3Af8iYCZ2C
         AXHYx8OwSzMUUxiLAlztnVkV9g/yKy1aFLOM2ui0js9vNN8CN9pwLlklPbibeHJ+A66n
         v/5w==
X-Gm-Message-State: AOJu0Ywoz0Krj+DyDFLNVPo8Mfbm4JexU4dRkjULR54+/Yd3U7lqoBEv
        2vZJwJuY+wh198S9sAK2UXQ=
X-Google-Smtp-Source: AGHT+IE76Gz4WoA4fl0/rX5W9f2fz7iLHIa+eBlWcELNDdj4Cj2sYlmkPv/tJs02yGsLSjVIs+uKwQ==
X-Received: by 2002:a0c:aa96:0:b0:630:14e0:982e with SMTP id f22-20020a0caa96000000b0063014e0982emr3663849qvb.22.1691587264812;
        Wed, 09 Aug 2023 06:21:04 -0700 (PDT)
Received: from localhost (172.174.245.35.bc.googleusercontent.com. [35.245.174.172])
        by smtp.gmail.com with ESMTPSA id p14-20020ae9f30e000000b0076ca401d8c7sm3981609qkg.111.2023.08.09.06.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 06:21:04 -0700 (PDT)
Date:   Wed, 09 Aug 2023 09:21:04 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Breno Leitao <leitao@debian.org>, sdf@google.com, axboe@kernel.dk,
        asml.silence@gmail.com, willemdebruijn.kernel@gmail.com
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Message-ID: <64d392c0235c6_267bde294c3@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230808134049.1407498-3-leitao@debian.org>
References: <20230808134049.1407498-1-leitao@debian.org>
 <20230808134049.1407498-3-leitao@debian.org>
Subject: RE: [PATCH v2 2/8] io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Breno Leitao wrote:
> Add support for getsockopt command (SOCKET_URING_OP_GETSOCKOPT), where
> level is SOL_SOCKET. This is leveraging the sockptr_t infrastructure,
> where a sockptr_t is either userspace or kernel space, and handled as
> such.
> 
> Function io_uring_cmd_getsockopt() is inspired by __sys_getsockopt().
> 
> Differently from the getsockopt(2), the optlen field is not a userspace
> pointers. In getsockopt(2), userspace provides optlen pointer, which is
> overwritten by the kernel.  In this implementation, userspace passes a
> u32, and the new value is returned in cqe->res. I.e., optlen is not a
> pointer.
> 
> Important to say that userspace needs to keep the pointer alive until
> the CQE is completed.

What bad things can happen otherwise?

The kernel is not depending on a well behaved process for its
correctness here, is it? Any user pages have to be pinned while
kernel might refer to them, for instance.
 
> Signed-off-by: Breno Leitao <leitao@debian.org>

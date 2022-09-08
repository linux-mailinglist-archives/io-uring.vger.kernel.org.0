Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0D65B1CB9
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 14:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbiIHMWq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 08:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbiIHMWo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 08:22:44 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCDCDFF66
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 05:22:36 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id gb36so37569539ejc.10
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 05:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=AWa2br41jcY7Hi0wUnp3de3ghKOghNx/3zCBVro5RqM=;
        b=SrW8EqbjuGaluajyM5kmjNltOmJllkHlB3qo4U/17AOkrQjJt4BNOrUxfs5DWv7HE5
         ieDkUlspfMr80bXm4anOGW68iK8CIlIhKu1UivmBHombzjqLlIaQ+EXHh5XmQhIyc9hL
         RxYxe/6ElGD+1FcFe3pFYZaAgdQoX+X1bQYEhRNrwlwFufGuAVJqDQEtwamEAx3gORgX
         zoJ9+952BsWLIjPevmfA3Q9d4mL4o4RqMsbrKzh7swYmTqr/2JPRjS+X6ft2Elo/sWoF
         wtucTe/0O5YJZ/LdjgVgobjgoWt/I19g6D2V9m4M3Nvg9Z54abklS0nNDKG4Ao0WtAIv
         e5Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=AWa2br41jcY7Hi0wUnp3de3ghKOghNx/3zCBVro5RqM=;
        b=v5eKzu1AIto85kUPY16HZKNe4eIPTHYZNnkg4ZsauBsN3E2ahFsKE0QE1l4PdPINUP
         Fu/xFZ4aJ0ojCPX2sk9/BPBJ/diEMYFUNvOBjD68IwENcpSf0ygZrWttUZIF8Jw0dFww
         MTFu5fihF0537mWILnCegYl4K0aiwAHnGX8cR/VgArTQ75j6RXAf9cL2FRB/Y9HE2ao4
         PT9G73Jh+HUtS/WRevObfFu5u/8ki2nY84db4v8Lz4HXImkxoEZ1bG0lnuTLPzHbgPdO
         qqFQNvJKsGwtleH07ydTmjA/UUC5NdR5nb5lZMi0gtSCYvOFiAblJxrbAhL7EDKnvPV5
         /O3A==
X-Gm-Message-State: ACgBeo1MaRzzxdGNvPOLHTUgXqOl4mR7KUZa/u5JW8zfm0uLf5TjMVGl
        2yhHU7J1s5gteIqirBGmNGohBXqO3Io=
X-Google-Smtp-Source: AA6agR6/hRYBHJWhndOysdNevHgj6j0BOv/DC1B/+FVsxs41axOQJHepfGbpWCwCjQmkkVsie/wXQg==
X-Received: by 2002:a17:907:b03:b0:770:872d:d7e9 with SMTP id h3-20020a1709070b0300b00770872dd7e9mr4688080ejl.272.1662639754169;
        Thu, 08 Sep 2022 05:22:34 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:cfb9])
        by smtp.gmail.com with ESMTPSA id p9-20020a17090653c900b0074a82932e3bsm1191791ejo.77.2022.09.08.05.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 05:22:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/8] random io_uring 6.1 changes
Date:   Thu,  8 Sep 2022 13:20:26 +0100
Message-Id: <cover.1662639236.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The highligth here is expanding use of io_sr_msg caches, but nothing
noteworthy in general, just prep cleanups before some other upcoming
work.

Pavel Begunkov (8):
  io_uring: kill an outdated comment
  io_uring: use io_cq_lock consistently
  io_uring/net: reshuffle error handling
  io_uring/net: use async caches for async prep
  io_uring/net: io_async_msghdr caches for sendzc
  io_uring/net: add non-bvec sg chunking callback
  io_uring/net: refactor io_sr_msg types
  io_uring/net: use io_sr_msg for sendzc

 io_uring/io_uring.c |  6 +---
 io_uring/net.c      | 84 ++++++++++++++++++++++++---------------------
 io_uring/opdef.c    |  2 ++
 3 files changed, 48 insertions(+), 44 deletions(-)

-- 
2.37.2


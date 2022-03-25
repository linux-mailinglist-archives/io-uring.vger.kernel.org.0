Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467EC4E73A3
	for <lists+io-uring@lfdr.de>; Fri, 25 Mar 2022 13:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344135AbiCYMkZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Mar 2022 08:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346367AbiCYMkY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Mar 2022 08:40:24 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C072126E
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 05:38:50 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id q11so7856328pln.11
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 05:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=d0TnPH7nmOmdYxCv+E2L8uspUv/NMOoUy2yxml7SxPc=;
        b=vvte8e4VtD88tP0xQgO/pYKNdowv6Opr5Y8he1mRc9a75Av2Mdn/yBTdSr1UMMYWXV
         lDz30g+gtHfVjdU4Sm2M4724z7Taxbbn5r9Jz5EaM4xfunA0gYl8RztDeACggkphKrM3
         MWlVdd1UTJVtTmOZg4i66lz8cDEraoo22XewL+ldoFu5c6+RNTJki9XIein0QLYhH2qD
         VLjP/ta9sL9zKWXf3dJU4xwruleKh8FVjhOB9U3wANFoRH/ok8TiW9Td3J7WFGjwlQt4
         2GNWFUKY/46rnpb6oursw4iSs0462jUn3mtvVyH0Li0vQvwkfYPTWSsLLKB/gQLDfyii
         lEkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=d0TnPH7nmOmdYxCv+E2L8uspUv/NMOoUy2yxml7SxPc=;
        b=eKlweb+k6+qagccsWw07w9xCiwWkIaoLSQHQoasEDi/kyE2YbjE1kQNV6GUQPtVmSR
         JjphpGSckfKAGhYY17UIf79n9LfWTaUH26Lo8ewXhuzwg0pHhu8ZRUM/ie5RQxFnzSod
         nRWPqU+LG4d8uDNRFqB21lOHdTx52oIM8TfC6625QkF8RKk5JfeXn+rWc/ygPiXps2uT
         Jal0XGROrtgn6aP8fOeZukLuftLSRzlh9hkVwWMbqe8+36K1DoIh9DSqHDkMSQd80pOz
         S5kV9ur/0oDE/8eBkLr2UJ+JBj28TtHKRtIjcM8r1IFgrLITYTHZDV9nuwhYTfxigqQk
         I0iQ==
X-Gm-Message-State: AOAM530is5SHvMbtjhucteq/KAFFoM7cKf1VA6aCxLZaueWLFergD7nS
        MxjgdXbmwMG2dZd96YQOZ4qJzUixpxVOW3NR
X-Google-Smtp-Source: ABdhPJwXLdOiMd6V4iQlEb3U8t4dfNLwiiUrclVB8e7N0vuTnD4hfTyubquJtDqv47UHeTy2HHGJYw==
X-Received: by 2002:a17:903:244b:b0:154:2cb2:86d with SMTP id l11-20020a170903244b00b001542cb2086dmr11348162pls.123.1648211929711;
        Fri, 25 Mar 2022 05:38:49 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f21-20020a056a00239500b004fb02a7a45bsm3595600pfc.214.2022.03.25.05.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 05:38:49 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1648209006.git.asml.silence@gmail.com>
References: <cover.1648209006.git.asml.silence@gmail.com>
Subject: Re: (subset) [PATCH 0/5] small for-next cleanups
Message-Id: <164821192899.10020.10892141500545962650.b4-ty@kernel.dk>
Date:   Fri, 25 Mar 2022 06:38:48 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 25 Mar 2022 11:52:13 +0000, Pavel Begunkov wrote:
> Minor cleanups around the code w/o any particular theme.
> 
> Pavel Begunkov (5):
>   io_uring: cleanup conditional submit locking
>   io_uring: partially uninline io_put_task()
>   io_uring: silence io_for_each_link() warning
>   io_uring: refactor io_req_add_compl_list()
>   io_uring: improve req fields comments
> 
> [...]

Applied, thanks!

[1/5] io_uring: cleanup conditional submit locking
      commit: 81c39c8099a617f7603a108862216abd23e2b7de
[2/5] io_uring: partially uninline io_put_task()
      commit: 72a1ccb0b1db12d8b4de100fbc668fc7addb6723
[3/5] io_uring: silence io_for_each_link() warning
      commit: 4ab65ca65797a7777721c21d3bd37cf21d2c2774
[4/5] io_uring: refactor io_req_add_compl_list()
      commit: 45c468c636f1ecb6dde1619aca5b716e6fbd5a9c

Best regards,
-- 
Jens Axboe



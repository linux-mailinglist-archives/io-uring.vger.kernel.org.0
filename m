Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C9552C2D4
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 21:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241684AbiERSxf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 14:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241646AbiERSxd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 14:53:33 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDA42218C4
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 11:53:31 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id e3so3313932ios.6
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 11:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=bmcYIg4E2BJ8U24K+2VdJes9fkIWWo8fNSWhIW3OfTs=;
        b=V4XfyyWPgFCm+Tt90MXVRetUQ9vw5kwgwFyY0YvIBDcr/xdEUf17pszVLtrO+9a8Fl
         FHyU4RDfyFbsPTIPcA/dRDgaQAnH7UzlYifx88Qf+K2BmuAKNlAqgiOUyOFEOmJeJxiN
         0iX4q1l3I6DPqjqN0U8Yn2lZC0+ALx/jBlCbWFot1Kzok8DEcO8Gr+WBx2LQTCAWCKk1
         1/51Kp6QHOhQPF6qkAAFO1Zw9trnCLELZ8tBJzENDQKv3i8KYj0sfYCbfwG3sAoBTsM/
         9sIfgRno7oaQJfYvDxpm2MbPon1r98u47gRlGlA2KXrxGkHXBthXpFXIdo0u5yRdnKsi
         1rcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=bmcYIg4E2BJ8U24K+2VdJes9fkIWWo8fNSWhIW3OfTs=;
        b=4Td8qp4/L+o1xtk8R9iyAdGo0E9MEXgwZQ0nQFVuZv4b5OTP9Wzn7VvHbk+gJt11qZ
         y3c7Kv2z0Cur9Bwq/qA9ZV6hsV8okUMhgH3X/3u+jjwfO22mtHoBp4a5VwN/pm7sTB/+
         GgSLZb/sAPlBjYrvKnK8rwBut9Afn539V9IODORcdMAU4e+M/sMT+fRqK/5l8Vd2GOXO
         Vu/ei+dYrvp+qbN2/WI0sg74FCr4TcQfrc2eqE5EooCTGBj3Rt/40dZ8OgNbvqe1YTb8
         U9/lWTbDV/41TtCV5h77QqBVupE5lhKfzH4lzT7LiKVG8EBKA+9cC9MGzlzss1931Nh2
         FU+g==
X-Gm-Message-State: AOAM530J4GiL+rf7+ewBzuSfADM9P2xzBsu3ZxT7dyZw2U8XyqURbMIw
        L18FM+DXbPncTVvGffjH7JFae8aUJIthBA==
X-Google-Smtp-Source: ABdhPJwEM5uSH8H3I+K6b1YWK/Big1+b1XhT8MQo+Te1jDSbfWMlaXFWMAj+mVukp1Z1Wi77OkRF5A==
X-Received: by 2002:a05:6602:3d3:b0:65d:f99a:2ed1 with SMTP id g19-20020a05660203d300b0065df99a2ed1mr519439iov.109.1652900010673;
        Wed, 18 May 2022 11:53:30 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a90-20020a029463000000b0032b3a78179csm75521jai.96.2022.05.18.11.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 11:53:28 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <66f429e4912fe39fb3318217ff33a2853d4544be.1652879898.git.asml.silence@gmail.com>
References: <66f429e4912fe39fb3318217ff33a2853d4544be.1652879898.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next] io_uring: add fully sparse buffer registration
Message-Id: <165290000852.131202.8407757757430633727.b4-ty@kernel.dk>
Date:   Wed, 18 May 2022 12:53:28 -0600
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

On Wed, 18 May 2022 19:13:49 +0100, Pavel Begunkov wrote:
> Honour IORING_RSRC_REGISTER_SPARSE not only for direct files but fixed
> buffers as well. It makes the rsrc API more consistent.
> 
> 

Applied, thanks!

[1/1] io_uring: add fully sparse buffer registration
      commit: 0184f08e65348f39aa4e8a71927e4538515f4ac0

Best regards,
-- 
Jens Axboe



Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A427C616519
	for <lists+io-uring@lfdr.de>; Wed,  2 Nov 2022 15:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiKBO1o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Nov 2022 10:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiKBO1m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 10:27:42 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6432A27B
        for <io-uring@vger.kernel.org>; Wed,  2 Nov 2022 07:27:42 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id m15so7367268ilq.2
        for <io-uring@vger.kernel.org>; Wed, 02 Nov 2022 07:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DyCEBOfZPnkS+ni3XpkveRhUx8NC3VW0BC86cAj/jbw=;
        b=4EwPYSIvRgviPVfhjYcwUgL1YvQinDij+CA/wyGJa6RIREcibjWa0XVWI9jr28ptLb
         G1B0/XtJLlXgMFkDNrJbsnNg9X3D3J7COXOyQqdNbljVS91PnYXgtF+d4+6FLxGYgS48
         21u8hjR36WW3aeo9aDj0XRAQrg7M/BQmvV1hJUh3BALQ0EnD9SRLJTbuHSdcfa7YUsdZ
         2QWMG+AgK7JBFRigEnH10iKZX0BwHBQoqWiXgNdoTHt7aZ2uGxxol1iZitf559YQ/ci/
         JNVxOTOa3L6A9sJy3FtYQITvZ+lmn4Q6pKfME7GgB6mhaorAnucVZUBUWoIJkJhCwzjz
         d8Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DyCEBOfZPnkS+ni3XpkveRhUx8NC3VW0BC86cAj/jbw=;
        b=ypBl50vrRef4V1ACa05UBNIfjQItN7xOkZRF4LWqzFuNqfLCgFtz9B7Y0N5nPxS3dA
         mRlHr1tQBlXr5g+wVnv55G9JAAmXzvqctOjBs1toErLu0WaQpTVkwT6EsekQLHQf6YrF
         JkbGEX/+BavuVNI+cMWjQYjPrYvEWWJw+4W6amtf/3zPa2zW5pBiy3AoCQmElsmSKUI5
         qk7eG5KhgEl1FuxgIgyHJVvNbaNfwpyR09ilWRoOHdlITIkaptzbzH11SyxNldOq2chb
         hCtNJX+7+TNTq2VLTqpZ2nn6EDeoYmLOt6UliI09lwcVQ80+hUXsQxu1hZgEM80gyCci
         EE1Q==
X-Gm-Message-State: ACrzQf3OGu2AGSQDRQdUY5gIS/XKXWy/AliY5x9X7951nWkdBvTF/VSv
        H2sdVPLW+XLJQKbZWjT22zwNBQ==
X-Google-Smtp-Source: AMsMyM7/fJkCOH0mSYzXtnuVlRXhS8xiseeHg2Q4wWBkvBEyohVWAX0eBXM7uKbUUz9vhwhbHZ79kA==
X-Received: by 2002:a05:6e02:10c1:b0:300:c37c:92de with SMTP id s1-20020a056e0210c100b00300c37c92demr6637149ilj.275.1667399261501;
        Wed, 02 Nov 2022 07:27:41 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id m2-20020a02a142000000b0036cc14af7adsm4925642jah.149.2022.11.02.07.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 07:27:40 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b547698d5938b1b1a898af1c260188d8546ded9a.1666700897.git.asml.silence@gmail.com>
References: <b547698d5938b1b1a898af1c260188d8546ded9a.1666700897.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-6.1 1/1] selftests/net: don't tests batched TCP io_uring zc
Message-Id: <166739926035.43399.16356106314058165168.b4-ty@kernel.dk>
Date:   Wed, 02 Nov 2022 08:27:40 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 27 Oct 2022 00:11:53 +0100, Pavel Begunkov wrote:
> It doesn't make sense batch submitting io_uring requests to a single TCP
> socket without linking or some other kind of ordering. Moreover, it
> causes spurious -EINTR fails due to interaction with task_work. Disable
> it for now and keep queue depth=1.
> 
> 

Applied, thanks!

[1/1] selftests/net: don't tests batched TCP io_uring zc
      commit: 9921d5013a6e51892623bf2f1c5b49eaecda55ac

Best regards,
-- 
Jens Axboe



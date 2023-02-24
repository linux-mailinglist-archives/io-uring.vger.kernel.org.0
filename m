Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 313AF6A201F
	for <lists+io-uring@lfdr.de>; Fri, 24 Feb 2023 17:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjBXQ5z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Feb 2023 11:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjBXQ5y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Feb 2023 11:57:54 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2E7F96F
        for <io-uring@vger.kernel.org>; Fri, 24 Feb 2023 08:57:53 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id t129so3588620iof.12
        for <io-uring@vger.kernel.org>; Fri, 24 Feb 2023 08:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1677257873;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=slueeSYiZdgbjCUPnuYo5q4gpjFzE5kriR0L1eHw7eM=;
        b=kyi+NPLShO9LBrifcnFc+ngpsT+Z2JfKILH5OgXbQV1b9xHYfuQgLFMJvChuJ1O2al
         WU9fNRRd8M/rxN2M8y0isn+WXOshwcmhQREvvTptOkkJwoHwNAoNP0e4pguuzw9MmGTj
         N9qyzD8yOuD318d+cZtoW7gno2m6yX4Kgy8D/octJvbVO3fHInLyX3osiQj6ORDEO9Iv
         nXFQmmW8wsH+JDYiDjXNfsm0qPyVrLW0+WrBKWMrZ4jO+RFdAXY2a9KsZ2NOuzqGW7At
         MAs+oA6RB/65FrVJpBRUwvfzFcpyIqBa5Asim9md8jQb5NJzw6iM6LbXuIBrVntZFXoZ
         jKBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677257873;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=slueeSYiZdgbjCUPnuYo5q4gpjFzE5kriR0L1eHw7eM=;
        b=ocSkx9iaG0A/WQG2fQPqJ7mgbOtmPcn6OGm5M+FUSADqx0CHfI77j1QqTbDQ664nIB
         /MlcXN8lkISqhuDODOAXiHzW6y5SjYOjgubgte4z3V4Vz8MKBe4Jg9injU9foV5YlwgE
         QFcsNKwvw60+dtFj9JFF/Fans21T/Z0bthD3Q85inZcCu8TyFIS4ucqmyOTMj6h9vZS4
         G4kE61u+zYuA13eyLpN8OXXvKYj1+gWcHBHgJ6mvb7nMGUP72oHaO+5Mq/Y1psPpsb2n
         ojQ0VDTh2vZ87Hxumj1/W6mjZoqpnMB3WCCi1KqEZ0Bgl1Kf69a6i4/ykPYIoTijo0CE
         TJug==
X-Gm-Message-State: AO0yUKXDAIeU/RuAW6bnAa6QB5yK4IVa4CaZ6v14BLm0q5fVztwfpeeG
        ZLdwzUgpEc19bEoo1RXhwZDC0FxnFQfVQUYm
X-Google-Smtp-Source: AK7set+yJXLS2ub9sLmbZNlND14wd/5VdkWW27rt0wqcT/+/6Il7BOfk/8Eil/hEs2pLGG4DcmGOFg==
X-Received: by 2002:a6b:8d45:0:b0:746:190a:138f with SMTP id p66-20020a6b8d45000000b00746190a138fmr8815603iod.2.1677257872594;
        Fri, 24 Feb 2023 08:57:52 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t18-20020a92d152000000b003170014ee5bsm1422805ilg.21.2023.02.24.08.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 08:57:51 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, David Lamparter <equinox@diac24.net>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>
In-Reply-To: <20230224150123.128346-1-equinox@diac24.net>
References: <CANn89iJE6SpB2bfXEc=73km6B2xtBSWHj==WsYFnH089WPKtSA@mail.gmail.com>
 <20230224150123.128346-1-equinox@diac24.net>
Subject: Re: [PATCH] io_uring: remove MSG_NOSIGNAL from recvmsg
Message-Id: <167725787156.174023.16695847419277127749.b4-ty@kernel.dk>
Date:   Fri, 24 Feb 2023 09:57:51 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-ada30
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Fri, 24 Feb 2023 16:01:24 +0100, David Lamparter wrote:
> MSG_NOSIGNAL is not applicable for the receiving side, SIGPIPE is
> generated when trying to write to a "broken pipe".  AF_PACKET's
> packet_recvmsg() does enforce this, giving back EINVAL when MSG_NOSIGNAL
> is set - making it unuseable in io_uring's recvmsg.
> 
> Remove MSG_NOSIGNAL from io_recvmsg_prep().
> 
> [...]

Applied, thanks!

[1/1] io_uring: remove MSG_NOSIGNAL from recvmsg
      commit: 4492575406d8592b623987cb36b8234d285cfa17

Best regards,
-- 
Jens Axboe




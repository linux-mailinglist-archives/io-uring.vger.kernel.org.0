Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC6A55AA1B
	for <lists+io-uring@lfdr.de>; Sat, 25 Jun 2022 14:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbiFYMsz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jun 2022 08:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232620AbiFYMsy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jun 2022 08:48:54 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A387C17A88
        for <io-uring@vger.kernel.org>; Sat, 25 Jun 2022 05:48:53 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id l6so4334677plg.11
        for <io-uring@vger.kernel.org>; Sat, 25 Jun 2022 05:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=wTOak6Alko2REFnUdiF2NGlZ9l3/gs6S/wYG8L/sIMI=;
        b=mqfqTuKzoG2Y7Ujnp+oElRlExmUC6hTjIP9gv8RhV6ftv8niUdXQ3YI83IoS1QppuY
         pYqRBUqRCtFdj5jcubuJruVuHIs0wB6OYXQPx/gX37mO2eC2FlG/fHRY2tZmpw9KaLb1
         YytGscN5Gh86w0Crx8636rMI/x7y+Qp6Rb6Nwuy/e44AcfYZc0zi5pV3QmtDD/IpNmyQ
         /4zujURG0CaSN/fv0QG0flmHkTE3AHMVC8Kirym54SJZmuTOk3aCEVZWEd/cI22WZHSY
         GrxkqzT/2ANkhUmyRowjDE/DQx5Cso11RtiOLernUXw7QfydA85Ex1bIVRlTrju/YJnQ
         2r5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=wTOak6Alko2REFnUdiF2NGlZ9l3/gs6S/wYG8L/sIMI=;
        b=VYlnEWfXoVlck6Bs7f6M+IiCbmHkAJqsJi5g2qP9UV+0aYaU6rT88MhnuizIJXp8Of
         cIJ+64SBLAtH5cP5SZBFV5la7g/U82ydGrYQRUlLkNjV7mwL2QZknvb6SFqM5RmjgcN1
         +cbjw/i409/cGsmjd4O+bfvKOP6QCIhDrYKPAa6WWUfAh2CyxcZI3B85uFG762Uvl8w2
         4jvrYHHvvbYJ584CAnbZXF+KbgHhTwDgkH+N46fs0u8ZG+0n4uOadSIxAtbi62w7vvkH
         0DfzZGXjPwiGh5psIP4qf5RBzS2ZVahxDGi3mO1uhHswA8ZdQGoDEIK4kfZrYtA3htO9
         LZTg==
X-Gm-Message-State: AJIora/ym6lfSuTcCgkm2e6188kSkciZH8+ppFBsBlYqcdMYA5Ps8IO7
        JN8nwNygG6pEk+TOMimMw+N+KA==
X-Google-Smtp-Source: AGRyM1tmWZcNkIMxAWK0WjcEjLx0GH6In0sstL/8ff22ozL/3cGzTmfl/OYd9H9umyAPHCofEYLqCQ==
X-Received: by 2002:a17:902:b597:b0:168:d8ce:4a63 with SMTP id a23-20020a170902b59700b00168d8ce4a63mr4434642pls.57.1656161333089;
        Sat, 25 Jun 2022 05:48:53 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id w4-20020a17090a780400b001ec732eb801sm5719820pjk.9.2022.06.25.05.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jun 2022 05:48:52 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     dylany@fb.com, io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <20220623083743.2648321-1-dylany@fb.com>
References: <20220623083743.2648321-1-dylany@fb.com>
Subject: Re: [PATCH 5.19] io_uring: move io_uring_get_opcode out of TP_printk
Message-Id: <165616133228.53712.7999095570148197511.b4-ty@kernel.dk>
Date:   Sat, 25 Jun 2022 06:48:52 -0600
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

On Thu, 23 Jun 2022 01:37:43 -0700, Dylan Yudaken wrote:
> The TP_printk macro's are not supposed to use custom code ([1]) or else
> tools such as perf cannot use these events.
> 
> Convert the opcode string representation to use the __string wiring that
> the event framework provides ([2]).
> 
> [1]: https://lwn.net/Articles/379903/
> [2]: https://lwn.net/Articles/381064/
> 
> [...]

Applied, thanks!

[1/1] io_uring: move io_uring_get_opcode out of TP_printk
      commit: e70b64a3f28b9f54602ae3e706b1dc1338de3df7

Best regards,
-- 
Jens Axboe



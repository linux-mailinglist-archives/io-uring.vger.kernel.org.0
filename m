Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 604C8621ACC
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 18:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234136AbiKHRfw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Nov 2022 12:35:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233828AbiKHRfu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 12:35:50 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC1A1F636
        for <io-uring@vger.kernel.org>; Tue,  8 Nov 2022 09:35:50 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id d3so5794921ils.1
        for <io-uring@vger.kernel.org>; Tue, 08 Nov 2022 09:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7LIKEGRIPj94fhr6Tfu2MxSwcmHWKhLdbks4fF/00cw=;
        b=DEzAolEV6BEUstNziJLFdvZe1ndBopz2i8JF4r1Spdv1zfMluL+h2YkILKEyae9W13
         N/kn6UXQ8sRGQz4rLxdsl9I0pDwVNG4qITYYA7wHACvegxTdxFVdW8pCa7XYiQdfUMuF
         uwYgkj0er8QBlwusOkVC90nzJZAgvyTw0AA1kHafBuAVQechFS4eCBnaX32K38X7Ri8i
         BgU8bXiwy6o1yAvps6wFLDbwhZM2FFOkM1rwtikAdlla5a96mOTz3qBJ6DxGA/y7fpJT
         Hil/WOT2E/8DiDT3P75vs9HYGkrQeqwWgicks+oMad8PhPtI8/1tLT/7WWsW7k1BpwAc
         KqSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7LIKEGRIPj94fhr6Tfu2MxSwcmHWKhLdbks4fF/00cw=;
        b=sAtPOcbm/BgtURm+kdQ9X5jUEGhlwbv+0Yj27rMBetlZkJQzyQ6Sq+8qmNBX1B++Wm
         d++btsaOGQw9ud9v51i94K2S/0U0/q14WqGAqhdI6TgoAkIdT6UdyTiZVYfT+L9ymrJJ
         1V5F2EN+rPDGu8gnQZXv6FRdeLqF+183nYrM4YVG1BZk0wbM0dpMwtdbvmOIiirAiT/s
         nrBm/mCQNTLyJdf3Fdvy/PhH7G2GORQ/ShG8cWIFb3U8s/kA2VrmrWg69BmMgJ2Ohzty
         c3joMnINDjleedjoVQf6Z421l3LdGyfDkuezEc9zycYlPKxYvG9oUZzPhD9a/T/7aVWa
         7dlQ==
X-Gm-Message-State: ACrzQf1dYdK6G94OGw5ORJ1S1umakLhv8dvogfrVgvfo2gi0lDW5StQX
        p9L7SI0UdxZLCVoS6ksDHgq1jkF+dyvhT9GI
X-Google-Smtp-Source: AMsMyM7RPNBNaViRCmYG3gfY7NniX9WigMlu2VZWL7d2uZd1KJVTaNGV7HX08Zke8qRs0VxVW0zC+w==
X-Received: by 2002:a92:7611:0:b0:300:ccfd:9363 with SMTP id r17-20020a927611000000b00300ccfd9363mr20232325ilc.23.1667928949345;
        Tue, 08 Nov 2022 09:35:49 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id j8-20020a056e02124800b00300c06714dasm4041789ilq.11.2022.11.08.09.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 09:35:48 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@meta.com>
Cc:     io-uring@vger.kernel.org
In-Reply-To: <20221108172137.2528931-1-dylany@meta.com>
References: <20221108172137.2528931-1-dylany@meta.com>
Subject: Re: [PATCH liburing] Alphabetise the test list
Message-Id: <166792894849.7506.724549427185723805.b4-ty@kernel.dk>
Date:   Tue, 08 Nov 2022 10:35:48 -0700
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

On Tue, 8 Nov 2022 09:21:37 -0800, Dylan Yudaken wrote:
> Alphabetical order is commanded by the comment at the top of the list, and
> also would have helped notice that skip-cqe.c is repeated.
> 
> 

Applied, thanks!

[1/1] Alphabetise the test list
      commit: 750d34274ae6966fd9ae18f03fc9ffb7b32e1c18

Best regards,
-- 
Jens Axboe



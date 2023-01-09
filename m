Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95EC6634E4
	for <lists+io-uring@lfdr.de>; Tue, 10 Jan 2023 00:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237625AbjAIXPE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 18:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237661AbjAIXOu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 18:14:50 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5383BEA7
        for <io-uring@vger.kernel.org>; Mon,  9 Jan 2023 15:14:50 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 20so1996432pfu.13
        for <io-uring@vger.kernel.org>; Mon, 09 Jan 2023 15:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g/cvNab0UVqQrwLLdidvTsUqTZD9TEA9knBaZUuG2Gg=;
        b=GT7StzQARo45EtczBA++lJVu3K7Qqudxsxj/D07FBbT6r8GFWnZqVTHSCrcUPxhn4W
         pdmcIFoQrhDYJC7b5nVkq4FHQZ1iaKvc7ivP4DcWQUqz62KEmqTd/EkjS2djjtqIE1kM
         6QcB7AxEvhaHsPwWxClW340BPwS+odIOHmyC0FEAwVNC+fz4XG9ELHLSTqU8qmw0imV4
         0F/4xDcRwMEBcOoUywl/7NASq+Wz6qZEZQVStNMeE+n878QenlZmBgY29Vj1lKhi31Q0
         IS+spdo82p1ZmHnm1xKtd0Q4KgzHCYttRE3oGRiZ++qiax+lcP9HbEV3aVZnEx3ibfCO
         zp1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g/cvNab0UVqQrwLLdidvTsUqTZD9TEA9knBaZUuG2Gg=;
        b=p2zVpPjzQ1wYBhYKwRE5WSdMmdnmgygow5IyyilzXXQYdr69wyig6Ap8e5h+l2f6rd
         CI19nI0MrgLSgiXT8vNIVVIJsftB3vL6aa9DB2KhujWsKow1ALRo4NxOcDke0cVyS1Bm
         tVfDA9frmMMZTw1zRfI7QeJpLUNTKxnV2Iasgyl/QPPmiOKFBR//BvgWOg1062LiYr+x
         O4vUvEsjZnerXbeFVHRGtTb1HN6zb9eqS9exw2IzO3UL9kcifPs6RZXxoqD/0chdavUb
         HYecp11ZiTJhmPrkth53aZGXb1C82AzjPj5BxrOgaQJTYObryPoCBit9NvfV9lii/cRN
         AxEQ==
X-Gm-Message-State: AFqh2kpqThU1myfkQ7IeQxpc/9xmzvxaWDXnanYysnn8xdrDI5hnFo8x
        s+iOoLGvWTEe0+Yrq3Qzk8TEE1ae50R6/hbj
X-Google-Smtp-Source: AMrXdXui3UGGFzw1SFPz9BNe+kAM6XV183XXKHnwsHI3TA392TPOGt8NooPW8BKVkbLjR58EKhbV4Q==
X-Received: by 2002:a62:1484:0:b0:587:9e50:3af9 with SMTP id 126-20020a621484000000b005879e503af9mr1437822pfu.0.1673306089205;
        Mon, 09 Jan 2023 15:14:49 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i131-20020a628789000000b00573eb4a775esm6803982pfe.17.2023.01.09.15.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 15:14:48 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, Dmitrii Bundin <dmitrii.bundin.a@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20230109185854.25698-1-dmitrii.bundin.a@gmail.com>
References: <20230109185854.25698-1-dmitrii.bundin.a@gmail.com>
Subject: Re: [PATCH] io_uring: remove excessive unlikely on IS_ERR
Message-Id: <167330608847.5627.8808533650294290115.b4-ty@kernel.dk>
Date:   Mon, 09 Jan 2023 16:14:48 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-cc11a
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Mon, 09 Jan 2023 21:58:54 +0300, Dmitrii Bundin wrote:
> The IS_ERR function uses the IS_ERR_VALUE macro under the hood which
> already wraps the condition into unlikely.
> 
> 

Applied, thanks!

[1/1] io_uring: remove excessive unlikely on IS_ERR
      commit: 119fda37c54736ea65a669273d0b3c394c99a75c

Best regards,
-- 
Jens Axboe



Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3885741BA9
	for <lists+io-uring@lfdr.de>; Thu, 29 Jun 2023 00:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbjF1WNS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Jun 2023 18:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbjF1WNR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Jun 2023 18:13:17 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85602110
        for <io-uring@vger.kernel.org>; Wed, 28 Jun 2023 15:13:15 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1b3ecb17721so100435ad.0
        for <io-uring@vger.kernel.org>; Wed, 28 Jun 2023 15:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687990395; x=1690582395;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IJY+GqcezBlL+xi5ObEwKu7LQjgnACic+SnpzDRi3ls=;
        b=Bi6Dt05+MROdVg1CZIMxtAh3dNSQKtQtRZuiynlR82bus1SAnyCL8l8t0Iw3hT+vm4
         BxLZVyZCjNPDATS+TUyvQz+0cE8H5JEfIE0Lumk4Bn9PJA2TwQ0sdEJo63mdNBZJjpfO
         WPe7Vb+jCDjxiy/fLHymQjy7GhslWmf2wsK0kw9KELgRzGyvwACXqI+0AQCdExRDVVdQ
         JLeQqtCw3F/3mCswHjZGlzBXK68DU1KNAyq9Y3QDXHTtpvXr61En/fyUWcyPFc7d3nTC
         0J6TKV0obQW/I2ZgCN6ayTGmTQJstz08OpgfYQ2N8Z9zSzmfaz0GBIXfMttTq5lQyWO3
         s52g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687990395; x=1690582395;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IJY+GqcezBlL+xi5ObEwKu7LQjgnACic+SnpzDRi3ls=;
        b=UvGPUuehqp7rSvSDXZ8zuaYcOV3UONsebQPtqePVu+ExfpKqCmLdOh7S8CNsIa+8NF
         BINs1NdbtK8nJ5+sKSS+cQBXTqIJHBcWRT7C3zRRlENzIlSboaZiT5BNuLB/KQ4VBnOZ
         CCn7cWWDcuvflKMzrYyk4RXA+Fee4mNDGhwliNS+MKRsQknksohEdXen0i1nXFQ5KEvs
         R1uRPMvnSQu+UYpGhfiylHsmYaGjMvbfyq2lzLIwHIbqNMxV3vItLqH6s2hjfW+s5EPd
         hVN2r1/Iy9FEsSp8ynFIDKHySXBD8lcC66byx1rWiBhab0NbN18Y92ADZgSf6SJo7sgy
         zJqQ==
X-Gm-Message-State: AC+VfDyQmZragwCzZnySSOkwG9eQPsf7sj7hMGIA4bAdJfpyMUS6nrrY
        SXsnweyNFrDGnjy39sFZtUdq1A==
X-Google-Smtp-Source: ACHHUZ7NDR0qNVF1yJ9FJ8h+ENri3Td2Iilzp/MG2qHL5P2KnxsfotwxKccN6VVV7K6RlCazgm8WBA==
X-Received: by 2002:a17:90b:3583:b0:263:2312:60c2 with SMTP id mm3-20020a17090b358300b00263231260c2mr5381891pjb.3.1687990395183;
        Wed, 28 Jun 2023 15:13:15 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q14-20020a17090a1b0e00b0025e9519f9e7sm9036351pjq.15.2023.06.28.15.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jun 2023 15:13:14 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, hch@lst.de,
        Keith Busch <kbusch@meta.com>
Cc:     sagi@grimberg.me, joshi.k@samsung.com,
        Keith Busch <kbusch@kernel.org>
In-Reply-To: <20230612190343.2087040-1-kbusch@meta.com>
References: <20230612190343.2087040-1-kbusch@meta.com>
Subject: Re: [PATCHv3 0/2] enhanced nvme uring command polling
Message-Id: <168799039388.1023490.11718140494575260778.b4-ty@kernel.dk>
Date:   Wed, 28 Jun 2023 16:13:13 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-099c9
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Mon, 12 Jun 2023 12:03:41 -0700, Keith Busch wrote:
> Changes from previous version:
> 
>   Fixex botched merge compiler bug (kernel test robot)
> 
>   Added reviews
> 
> Keith Busch (2):
>   block: add request polling helper
>   nvme: improved uring polling
> 
> [...]

Applied, thanks!

[1/2] block: add request polling helper
      commit: f6c80cffcd47a2d41943e3a41fbe9034d9f6d7b0
[2/2] nvme: improved uring polling
      commit: 9408d8a37e6cce8803681ab816383450a056c3a9

Best regards,
-- 
Jens Axboe




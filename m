Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905DD4D38DD
	for <lists+io-uring@lfdr.de>; Wed,  9 Mar 2022 19:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbiCISeG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Mar 2022 13:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbiCISeF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Mar 2022 13:34:05 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE13580C5
        for <io-uring@vger.kernel.org>; Wed,  9 Mar 2022 10:33:06 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id k25so3738477iok.8
        for <io-uring@vger.kernel.org>; Wed, 09 Mar 2022 10:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H/NsfwRAt4SoZ92GOxKoW3oaQf0MXYZtyeggreOEtIU=;
        b=Ad4EAG6eYf63mJGJulx7Z4/j1HSLZzwOeqyNaVtjCtJQZamGuzQIIjqiEshDJ7ggAj
         2zvA65+NQoE+QQUi39Op4JN/z3hVy11iiAlAw19NJFjwfGIzuuvGR8oVtX2AWOljeGkB
         fQLArfbH9kx99aNpYn/TkkWYzAjQAATCKe6r/atfXIyUoTMoMGqEK4PXT1b7IDCaIott
         rd1sYmisNiwd2S6Kb5Vy5HRLKRKD8ByJ3mtERGayjSDW7tyhWiIqulS/63L+3h5Ygvwz
         hkJIfGA+3rwiQGkRtzKwwJ2AJ3xhIZY4hA9Jf0Dcgo4NENdkzmIovCM0IL4CGT82Kh3E
         vivA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H/NsfwRAt4SoZ92GOxKoW3oaQf0MXYZtyeggreOEtIU=;
        b=pYkr7sD9QKD0tOWdX5IpTcciFOW1cJ7JRgPxadH2SQbB9g12cZDvr/t/Zp17IFpEA5
         0GzrO/Pyj6aw37xZ0bR3JG0QMOEFc0vXVAzgAHZ4ku3+KQIMKaWZ7VVjyH3spm7qynjA
         aS+dCZWvaMq/78RshJASyquYUT5G7FrKH4tazp+2n1DPhEKuiIAyt1ARnFN8IQ5Uyc5v
         2lN79NWoXxC3PLWV1RssfR65VkPE5MtEYc4QkftTqdT6P/XUR5p3ARha9SCVU2C6iA7e
         X8F1v3/Y4oElsjSIB3flnQSBdRqFYDkbzcinSUhLwlLCrmOL86ZYQj0N89Hht0xr4yBr
         xByA==
X-Gm-Message-State: AOAM531X38updM/6bawv1kkm7HJMP2qXP1+7tsJpaXFMlycfIBYHeVeJ
        5gjuEHSNvq5AOKBMj7nfhOgHN5x45P17+1OK
X-Google-Smtp-Source: ABdhPJxcXwGBTqB47MmfT0JKV42O8ozGoeMIY4zV4ewvrYYUGfCWqVW5Rw+TLIo+HDM4LXYnqSkMhw==
X-Received: by 2002:a05:6602:1355:b0:63d:a9ab:7e30 with SMTP id i21-20020a056602135500b0063da9ab7e30mr736738iov.119.1646850785171;
        Wed, 09 Mar 2022 10:33:05 -0800 (PST)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id j9-20020a056e02154900b002c5f02e6eddsm1524094ilu.76.2022.03.09.10.33.04
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 10:33:04 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/2] Provided buffer improvements
Date:   Wed,  9 Mar 2022 11:32:57 -0700
Message-Id: <20220309183259.135541-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

One functional improvement for recycling provided buffers when we don't
know when the readiness trigger comes in, and one optimization for how
we index them.

-- 
Jens Axboe



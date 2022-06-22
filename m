Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74473556E61
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 00:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357211AbiFVW1H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jun 2022 18:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236938AbiFVW1G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jun 2022 18:27:06 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D645D3D1ED
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 15:27:05 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id c4so377462plc.8
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 15:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=OmaQJne48wtfEp3jFW5H+ICJ9/E3QGMLz4uxshaA0O4=;
        b=WovY2bspOYWH4xPqeaGqZygmRflUNXXQbcLeUPHnrvr8yr8ULlzm5jP6c/Ft7WQ3Uy
         +1ohwpAL5NiclcNGCmjsz9a3QVffrM7IfEI43Qs+gT7aDx20UCmd1wbpGXBbyUwZw6l5
         silPsLNR55yQEYmKga/vHfrP6vElwpUfBzJ+WwIK9oHFRGi+JgJ+JCGBG/V9PHZgqXak
         oW1iqiNo1OsRvrZSyTc4Nrgc8g2W8a2oEAY/Pay+NAbRU6Xv1pz5HMqaW9UVyp2Upktn
         ncct0J7IXGZ9HlcPDmrYTq5BjXwe9nNr+ZDuIg90gwR/iLtb1r2r9WHzgKEkHMmol5nM
         m/2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=OmaQJne48wtfEp3jFW5H+ICJ9/E3QGMLz4uxshaA0O4=;
        b=3rRM+7ApkRFOsdLt+BqNMBplxrOFhNSCxupCO+o9L5QFn5JGn2nl6PAtZo312sU9Lv
         75pt7PbAu+o6rsjMq9M6f4Sy0tMHF2/8MOsY0uqTAaszjX42Mm/pteWhQVMAgTPZb3Y5
         T+170vuVRkEcLPcPHSp1TT1FGabcZ3TRmj3FIN6oI9D4do3XfKo+9eWziSmB3jBTuiog
         0b4eyif0GwEwMjqsFp+4dMQr0rp2l2rT9NNcC2WhZqe6DeSuHxUC+ZOpM63I2911D9DU
         K3hLK5TucbZkUbppkEF75JbCHBqKk0COw274oHS1+2HWUfMoMLdQge7c0LuSteMUWB9M
         /CfA==
X-Gm-Message-State: AJIora9UqquYyK3cYaMqpCTEgha8+EG72WwvlHh3SfKhvxbWwkRXKkuO
        nhORVU/btlv3V8GxINX6xkwnlnhZwkvk3A==
X-Google-Smtp-Source: AGRyM1u6O8RpiKL2A6C1OqSpqfRp2xA/QyCMXf8eiHs3XpGypT0b/orENMxjGJE4eQT/Zco7jifEZQ==
X-Received: by 2002:a17:90a:d0c5:b0:1ec:747b:7c3 with SMTP id y5-20020a17090ad0c500b001ec747b07c3mr641294pjw.68.1655936825358;
        Wed, 22 Jun 2022 15:27:05 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m20-20020a62a214000000b0051be7ecd733sm14436450pff.16.2022.06.22.15.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 15:27:04 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     hao.xu@linux.dev, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
In-Reply-To: <20220622055551.642370-1-hao.xu@linux.dev>
References: <20220622055551.642370-1-hao.xu@linux.dev>
Subject: Re: [PATCH] io_uring: kbuf: kill __io_kbuf_recycle()
Message-Id: <165593682437.160697.14178699823616041645.b4-ty@kernel.dk>
Date:   Wed, 22 Jun 2022 16:27:04 -0600
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

On Wed, 22 Jun 2022 13:55:51 +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> __io_kbuf_recycle() is only called in io_kbuf_recycle(). Kill it and
> tweak the code so that the legacy pbuf and ring pbuf code become clear
> 
> 

Applied, thanks!

[1/1] io_uring: kbuf: kill __io_kbuf_recycle()
      commit: b4ef7c36b5ca6a0b96c8b493c495b17a0884fd11

Best regards,
-- 
Jens Axboe



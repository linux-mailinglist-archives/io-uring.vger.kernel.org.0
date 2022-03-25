Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9DC24E7387
	for <lists+io-uring@lfdr.de>; Fri, 25 Mar 2022 13:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355069AbiCYMdx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Mar 2022 08:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359049AbiCYMdv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Mar 2022 08:33:51 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17817D0838
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 05:32:17 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id p8so6335772pfh.8
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 05:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=NZoAlzzFEb5CaAalB2j3BTClFadk7iEYjAPWowva89k=;
        b=DA24wueLt/VXAoBJt+loMWuXUTyRlkJ6QXy+fmluqtNsYjUiWWn22XYg6CSvBwx89G
         dOPqqa2eVX+GgXFX8qjprOjqB7OV3Ugl2nZDh9wqESyzy2k6d9ff2V1x6MDfZDRb+sVM
         DzpKEB4bqMM0Fq3JW7ENE0zuUovtPn+sZYwmEZcwUOh5N79/gCPMbC72D3YEnMAwwuKU
         /lq7L6nPIagQi5PiXs+aQ8vpm7VyWAWTIkN06oXbmVUL6zr1H7wB4uCVjyYPK6Q4HQbY
         CiV3Z9QMBPYAhTvCCGKNmJC0pLtxa0xtAnTXRCaZnuKM9UQ9JUofu8dnN1MyTUMFJrA5
         aG6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=NZoAlzzFEb5CaAalB2j3BTClFadk7iEYjAPWowva89k=;
        b=V4aBxN6IgPAbC7xc4T4tQxRVyKwCX3+7ilRO6bjbofXRyZcp3M/4PS2GqVE7Ec1nTw
         6bz9fy4Ja/LvI7Lv58jqzckN5cH6kxsPCEF8RCpdnodNG+jIj9wsb5XxOcMDxGiCJSRN
         GWtKTDOTtWJYU4eXZkd80/4Ck4plOcFwqBvsf2o+mDw4Qv4D39zgvOwDClcwxvAowdqq
         U9ux16Cf+h2kwLw9bOAtrNDQdveGmHU7SK4wzfgNWH1NyfZ+eHJAFYBp+dY4i7CM4v4C
         peeziehMF5UXY2AJBrGTPulSZiWjBmLOlTjVU9AFnFpurdT6qxj2U12GFP3TokxYsNez
         zXxw==
X-Gm-Message-State: AOAM531jtl62R0VL59THFIZoVSND+orbRhc4wKBlBZpMt04PUsM1sfOd
        iSvtuUaehhkXdr38TS0OfIraoQ==
X-Google-Smtp-Source: ABdhPJxz0j6yQTlfmg7KLm9+IAFU6zzR3YTqkiBhsxee6EkQyyHkaX1AiGv8p2fqBOT0vADho8EAiA==
X-Received: by 2002:a63:101:0:b0:36c:6d40:5688 with SMTP id 1-20020a630101000000b0036c6d405688mr7809879pgb.554.1648211536365;
        Fri, 25 Mar 2022 05:32:16 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k6-20020a17090a7f0600b001c63352cadbsm5979409pjl.29.2022.03.25.05.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 05:32:15 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Dylan Yudaken <dylany@fb.com>, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     kernel-team@fb.com
In-Reply-To: <20220325094013.4132496-1-dylany@fb.com>
References: <20220325094013.4132496-1-dylany@fb.com>
Subject: Re: [PATCH liburing] Add test for multiple concurrent accepts
Message-Id: <164821153537.5984.16482063295761850336.b4-ty@kernel.dk>
Date:   Fri, 25 Mar 2022 06:32:15 -0600
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

On Fri, 25 Mar 2022 02:40:13 -0700, Dylan Yudaken wrote:
> Add tests for accept that queues multiple accepts and then ensures the
> correct things happen.
> 
> Check that when connections arrive one at a time that only one CQE is
> posted (in blocking and nonblocking sockets), as well as make sure that
> closing the accept socket & cancellation all work as expected.
> 
> [...]

Applied, thanks!

[1/1] Add test for multiple concurrent accepts
      commit: cbdf65e0484af93d3966f0f04eeeb7a5a518d673

Best regards,
-- 
Jens Axboe



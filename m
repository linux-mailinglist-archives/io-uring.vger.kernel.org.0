Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA625C009A
	for <lists+io-uring@lfdr.de>; Wed, 21 Sep 2022 17:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiIUPBC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Sep 2022 11:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbiIUPAr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Sep 2022 11:00:47 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E101DFB2
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 08:00:46 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id z191so5212890iof.10
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 08:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date;
        bh=qzdos1L9RfLnIxC9fXGzpLSS3/oeppJJZueq6+N7C/o=;
        b=JE8J5vep6sb74rs7w29IH0Ag503ju0t8zdxBYd9lF9AWhDLLpIUns0Nc4BLfk+JREV
         8n7ZyUvFL4lzpo2rZ+QGWXLhyWA+IL1QGV9cSdajnZeyZe+U/ZQLOTcnVKSDzhMtSh3i
         8XeXAyQevXsuQ9x9tGOHDXF711hiO70/WW1STuULP35aFAoZ7Av7vDBz0UqR21C+5HLh
         whywcEDwELImfDLX4KAKU4eIaX4vDBV5V+VO5KMuEzH6xu8lHGY+UteRW1XpJ6tGFZw4
         z/GVQE+SZr8qRwcm4US9MjWwMEkS92imX4XB/vZdhMqqXg2I4Cr4uzxE11TVioiUg5ao
         qdpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=qzdos1L9RfLnIxC9fXGzpLSS3/oeppJJZueq6+N7C/o=;
        b=qM1FHpyvivjIyAYDpfVi42/mQVWMVqZgcujI4Iop3Mqy+t+mXscYRhXVlctrCfCYms
         fCTb7x1qWALm0WKoNHH/WJQxH+p5kuOSNjhzL63SiQndEZsXwWjKDayrJAUWygZxoOD+
         2WHYXHmdK3SwWFP1PKIGcB206zVzphXjkyr+/xdUHcRcuABWP5I+WYaewGgguyW7wVHD
         shSRC7zHvkntGCzwWzWQDUKYI95boBh2PWtjOjWHibue/evsSROxTpozvvgJm28nqUN+
         hT3czzxRzUGYUow5oM9Fg/EixgwG8jp42ODeI/DW2KMfKR3vB/E0LBa1aeyztKCsB9if
         QVTw==
X-Gm-Message-State: ACrzQf2NmJDwzqhaYfNUXVDdOgHCMlFgQyAtoskOqvQav2zAGGOzsIVj
        2/oMjjChbrYzSdp6VqzK4Apu6qMdjf8n4A==
X-Google-Smtp-Source: AMsMyM6W5vYNYEHdaU/x3SWJ8xQ9dYvkqO6VXyhcjjeaYfdi2KFkfIJ5CXV49qY9T2Tuk9R88sy/Kw==
X-Received: by 2002:a6b:e00d:0:b0:6a1:8ab9:9666 with SMTP id z13-20020a6be00d000000b006a18ab99666mr11576781iog.159.1663772445427;
        Wed, 21 Sep 2022 08:00:45 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id n25-20020a02a199000000b0035aa9bf9d3dsm1146213jah.12.2022.09.21.08.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 08:00:45 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1663759148.git.asml.silence@gmail.com>
References: <cover.1663759148.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 0/4] zc changes
Message-Id: <166377244488.46089.8371000228952906777.b4-ty@kernel.dk>
Date:   Wed, 21 Sep 2022 09:00:44 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-355bd
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 21 Sep 2022 12:21:54 +0100, Pavel Begunkov wrote:
> We're decoupling notifications generation from whether the request
> failed or not. Adjust the tests, so nobody is confused reading it,
> and put a note in man.
> 
> Also, 4/4 adds a test for just sent zc sendmsg.
> 
> Pavel Begunkov (4):
>   examples: fix sendzc notif handling
>   test: fix zc tests
>   man: note about notification generation
>   tests: add sendmsg_zc tests
> 
> [...]

Applied, thanks!

[1/4] examples: fix sendzc notif handling
      commit: a3a35cf05c6ed670f0f14c3181c10683d22d98da
[2/4] test: fix zc tests
      commit: 5127b05e5acf530020518d198401f09c32e09f9c
[3/4] man: note about notification generation
      commit: ccde465295cd07d0a4b25ae892de957d50424b50
[4/4] tests: add sendmsg_zc tests
      commit: dec0b1db70e8fadf9666289fa00c1ef508a1e8a2

Best regards,
-- 
Jens Axboe



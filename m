Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E6E5F47CD
	for <lists+io-uring@lfdr.de>; Tue,  4 Oct 2022 18:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbiJDQmE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Oct 2022 12:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiJDQmB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Oct 2022 12:42:01 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52D75EDE3
        for <io-uring@vger.kernel.org>; Tue,  4 Oct 2022 09:41:59 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id l127so8451033iof.12
        for <io-uring@vger.kernel.org>; Tue, 04 Oct 2022 09:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date;
        bh=lt3R8izx9EnX89I3uY2yDhaSLHndLcmUEL/LtZodjaY=;
        b=4whC8w21HxpHbBgXcbkK+k9Dme0ceJdK8HQgGSiK1NrT+tiSOV/WovVFQVtTt/HWsH
         PxDSm9IMoMN56VIypuQlxPir7yKTu3416OSfvxdz8wjrQPdKsuB5aLzIV2tMXVjsZnxx
         Zf2AxvfhM6NjRd4iy50dYj+5WYz7sXolHOtKjF2wcddvnYdA+2TiTsyZqm2hKWuOGUA1
         bW+BXMfOhKohux5uY5//0UM4H8Xe8yZMttoZXGr1P3qh8usqy3zq7ZUsGAF+hYY6tvz9
         KWcZGkXaLU9IbqgJkdQV+Ot4xTMx3/NEgTSGQ/PrL53v95l8n4h64mB4vO6f1VgvD9yx
         htkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=lt3R8izx9EnX89I3uY2yDhaSLHndLcmUEL/LtZodjaY=;
        b=6GyvlvRxqhLv+qR5eydWNYuUSvgC5rxPnPbjPqoLhKSYURJnjCZ7dtcAlsx3go6qQa
         P15iTx/72ZJlNv+VMEklCFp874PEpi7tWUMBn+6yyCVoRPgZuoAMHKRUbySvKxGa6hgv
         TPl0j7xHn3LSLueob9ClWO0D9+/0h2CDGG4x2QiQkyOZojJYeXsE2Cg3M05gi1Ap/BoD
         EL9kPoIM5vw8m16nWNg2M4RPekiyHoKfiHJ5pVCdvuvLeC+O2YLNxf4xTLYdyXhJC9fY
         NbQmIABLXYZ/WjWs60Erm76wb7kaesFo6W9qm0eYOuHwC/H7pWS0jNH99scdsEFUvIA+
         0Ytw==
X-Gm-Message-State: ACrzQf301OckdKSVVFLbXMintOPRpQdwDJFsz+DC4szebRstou/K82cL
        lfjahd3Y2LBNZuk2f7vjl8EWHQ==
X-Google-Smtp-Source: AMsMyM66XfQoGK2nj7BD85MJUj1tCABZ27DOBIP9gg+iCQnkjMCaxKGu+fuKGHRY23gOP5qYfUMukw==
X-Received: by 2002:a02:9687:0:b0:363:50b6:6ec7 with SMTP id w7-20020a029687000000b0036350b66ec7mr1464489jai.39.1664901719184;
        Tue, 04 Oct 2022 09:41:59 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c72-20020a02964e000000b003633ef39bd3sm1638823jai.92.2022.10.04.09.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 09:41:58 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <7404b4a696f64e33e5ef3c5bd3754d4f26d13e50.1664887093.git.geert+renesas@glider.be>
References: <7404b4a696f64e33e5ef3c5bd3754d4f26d13e50.1664887093.git.geert+renesas@glider.be>
Subject: Re: [PATCH -next] io_uring: Add missing inline to io_uring_cmd_import_fixed() dummy
Message-Id: <166490171822.91699.6395333922745034798.b4-ty@kernel.dk>
Date:   Tue, 04 Oct 2022 10:41:58 -0600
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

On Tue, 4 Oct 2022 14:39:10 +0200, Geert Uytterhoeven wrote:
> If CONFIG_IO_URING is not set:
> 
>     include/linux/io_uring.h:65:12: error: ‘io_uring_cmd_import_fixed’ defined but not used [-Werror=unused-function]
>        65 | static int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> 	  |            ^~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Fix this by adding the missing "inline" keyword.
> 
> [...]

Applied, thanks!

[1/1] io_uring: Add missing inline to io_uring_cmd_import_fixed() dummy
      (no commit info)

Best regards,
-- 
Jens Axboe



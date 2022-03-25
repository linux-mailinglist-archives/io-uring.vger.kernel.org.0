Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 854DB4E753A
	for <lists+io-uring@lfdr.de>; Fri, 25 Mar 2022 15:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238759AbiCYOlB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Mar 2022 10:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359356AbiCYOk7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Mar 2022 10:40:59 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D905297B9A
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 07:39:23 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id e22so9093170ioe.11
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 07:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=ltO3L7XwgXSXJ4g+uZh+uDOMFTwz4GozYMP2wtHrgc8=;
        b=EQcd7xKScIlK50cDdtRHH1LYWTagQ6J0ZdpIlF0Ynw1ZTMtBHOgYbOXfXU998UtImB
         azkqdRCq92tYzcQesw6bl6ngTFHFwfSvPQX+T4Wyxa8fofOK/bPz1aytn+YDpgid2ECM
         HBxrg/rwVj1zuJj4oEGwwbovvy1wHGRn5s0gQ8tolnskLWo2OHwm1XncMxdUvOpwg+KY
         EH0dXfWiimUDetFH/HM78WEiRxQXOfXxRf508wLmcIc/+Ur9HfkKyIrL0QNaIceZHRek
         9870mfepXmnvIDi25m+GUYpK4c+MLV6ffWaew4yAGzzkjVTd//ZgRwqexpPB0YaWVYfo
         iRyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=ltO3L7XwgXSXJ4g+uZh+uDOMFTwz4GozYMP2wtHrgc8=;
        b=k+T4J1khuHKeGJuR1ErGbSb/w1mDBP159Ji6OEDO8tE5LDY68bOLBQSBsORILiSDoB
         dlgonRJEpcnNvLFYTyFOx4e905CUQ9V8Rp4oWzytF9pGQBhO/H+IS8QGu8eu8sc8kcGd
         SgfYZeMD2p6RRsBIsJACk3zS8gzFmXmoa3gmUi9lNm0x3VeZuGl9MQqPkywFBwLAjDDO
         1QXqWPKuYYgE1KOgLG16P/v8tZhJWQ93uOGDFUn5qEizUiuCCRMDOBqvTytZm2EHQ2v0
         6FXFsA0TDdw9Rz3PenI+7eMzQEWZoBex77QcDVFzfRWb+MS3qoyJU7iVHjDtqY6qMhr7
         sE2A==
X-Gm-Message-State: AOAM532fxFU7BxO1VIhiTWJ2CcpxYPcpWQ/l+9NXhuDx0rq96ORArrec
        etU+lKVa9xHpr/zk2j2OpChZgA==
X-Google-Smtp-Source: ABdhPJynA0xkocgYiUnsZHC1CH0DgWf/QOFlXpMU7Y+T7hN7Hz6VOS0NwUmK+CCEKrMV/77Oy+prnQ==
X-Received: by 2002:a05:6638:2587:b0:31d:5878:6e96 with SMTP id s7-20020a056638258700b0031d58786e96mr6147282jat.6.1648219162982;
        Fri, 25 Mar 2022 07:39:22 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id j4-20020a056e02218400b002c82f195e80sm3148134ila.83.2022.03.25.07.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 07:39:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <cover.1648212967.git.asml.silence@gmail.com>
References: <cover.1648212967.git.asml.silence@gmail.com>
Subject: Re: [PATCH 5.18 0/2] selected buffers recycling fixes
Message-Id: <164821916243.75786.2523289843458432475.b4-ty@kernel.dk>
Date:   Fri, 25 Mar 2022 08:39:22 -0600
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

On Fri, 25 Mar 2022 13:00:41 +0000, Pavel Begunkov wrote:
> Fix two locking problems with new buffer recycling.
> 
> Jens, could you help to test it properly and with lockdep enabled?
> 
> Pavel Begunkov (2):
>   io_uring: fix invalid flags for io_put_kbuf()
>   io_uring: fix put_kbuf without proper locking
> 
> [...]

Applied, thanks!

[1/2] io_uring: fix invalid flags for io_put_kbuf()
      commit: ab0ac0959b028779ea43002db81daa12203cb57d
[2/2] io_uring: fix put_kbuf without proper locking
      commit: 8197b053a83335dd1b7eb7581a933924e25c1025

Best regards,
-- 
Jens Axboe



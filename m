Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37FA45A9C4A
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 17:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbiIAPy7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 11:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233588AbiIAPy6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 11:54:58 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4DCF38A4
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 08:54:57 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id y17so4218230ilb.4
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 08:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date;
        bh=AvECbxP3igaMTATgf15swYmOKH/Vm8MOe9B7Ztw1bW0=;
        b=xhj24fySESa6gyDIq7cO1dL6nt0IdjA4RcV0/1s1UwqIo2EmPjEr8RPYb1hm9YO67O
         XKf7cyPl2SbNW6liNHfRxIiFkabMpgzqmZatfuPDoSax574M7ZgTWl8DTMg7HSpebJ4+
         o9hYcEAbdX0n2pb11vq2p73JuUMBtsko39rhxMApYX1HJV4Ew+qJ6JOOP9HyOS8pcquJ
         lMpL4d7cCXjsQdZqIOkIVExzLRXsTIM6RDNG/TzdV7/a94pZNyRBaxDTxE/BMeTsduAe
         szyi+R+EmEymPW6DSWnHMxOruoMY5p/WSDz6I0P3jqoalx15WrixlaupQbKJts/oNDID
         o+GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=AvECbxP3igaMTATgf15swYmOKH/Vm8MOe9B7Ztw1bW0=;
        b=ZrentQqlTxkFyOs+FzJGTfZ1G66UVljbNd0IqTs56q+5xZYgeMJfjYl6qP7FC/zscg
         H8CAXFr8wShdgPxTxo6/04qRbLa03CbA3Qv+PsqgS8egUHdh2MaGLQJqhVy8bYt0bcXd
         ABaF4h1vTTaW4dDgqRsDHi1aiU//uzf6vX3dRCab1g690DaHN2pYfq7ARGU4btcZAbAR
         Wi3NrtmldPyhBcB/mft+tT5f5jyXZFZZGiD4+llSvkn9YNd+iVZIIhHe+XR5U3MudXeN
         hlP75srLayHSD8Q1eQhvn7d2srgex08gHEOUhFEpLriXv4jPOAb2bycQ50LCiGZ6jSjQ
         kOlg==
X-Gm-Message-State: ACgBeo23x38R1Abool+N8WL4JZ3KN4Do1mII8teYOVR1rXW+h7HcJmkC
        Xj8je8LJ8F48b80FL4p6n1YtbPd18h47/w==
X-Google-Smtp-Source: AA6agR7b8zl31btAuhH3Zbq89IV7OdK/X5A+I5ZcwgLF+1KyqHLYz+sxFAzsvPaWpu3/D12B3aw1zg==
X-Received: by 2002:a92:1941:0:b0:2e9:6c43:17b1 with SMTP id e1-20020a921941000000b002e96c4317b1mr17220134ilm.139.1662047696911;
        Thu, 01 Sep 2022 08:54:56 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c19-20020a056e020bd300b002e67267b4bfsm7652653ilu.70.2022.09.01.08.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 08:54:56 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1662027856.git.asml.silence@gmail.com>
References: <cover.1662027856.git.asml.silence@gmail.com>
Subject: Re: [RFC 0/6] io_uring simplify zerocopy send API
Message-Id: <166204769608.43304.1207494014468248143.b4-ty@kernel.dk>
Date:   Thu, 01 Sep 2022 09:54:56 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-65ba7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 1 Sep 2022 11:53:59 +0100, Pavel Begunkov wrote:
> We're changing zerocopy send API making it a bit less flexible but
> much simpler based on the feedback we've got from people trying it
> out. We replace slots and flushing with a per request notifications.
> The API change is described in 5/6 in more details.
> more in 5/6.
> 
> The only real functional change is in 5/6, 2-4 are reverts, and patches
> 1 and 6 are fixing selftests.
> 
> [...]

Applied, thanks!

[1/6] selftests/net: temporarily disable io_uring zc test
      (no commit info)
[2/6] Revert "io_uring: add zc notification flush requests"
      (no commit info)
[3/6] Revert "io_uring: rename IORING_OP_FILES_UPDATE"
      (no commit info)
[4/6] io_uring/notif: remove notif registration
      (no commit info)
[5/6] io_uring/net: simplify zerocopy send user API
      (no commit info)
[6/6] selftests/net: return back io_uring zc send tests
      (no commit info)

Best regards,
-- 
Jens Axboe



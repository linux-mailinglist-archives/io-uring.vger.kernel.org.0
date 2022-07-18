Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA085783EF
	for <lists+io-uring@lfdr.de>; Mon, 18 Jul 2022 15:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbiGRNlS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Jul 2022 09:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234387AbiGRNlS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Jul 2022 09:41:18 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CEF1C100
        for <io-uring@vger.kernel.org>; Mon, 18 Jul 2022 06:41:17 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id a15so11834663pjs.0
        for <io-uring@vger.kernel.org>; Mon, 18 Jul 2022 06:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=zJDk2Ph0+FtMqenuPf0bRdXlnKpHvlRTbA2oax9MpNs=;
        b=SqmiBTfcx2ji+1+E0e/HrWkVY/BxyH8g5rVBf4QUrK+xbdwERNDexptf8xymY4pQG+
         Se1GiangCDcUg8vCbNJVkFPB1mqOoTtd1EY8axcryhyynGah4E2z6zwrglbXBRrhPyBc
         xIoKjfuqKlONxhbKPNX2fm+a1zGZnDZh8f1DGRVsRE0+V5DDFdoE7FxGPJkWL7A+xU85
         TbAfbeqlBLR6U2xdWXy3CH+1qN22Af2vCJAnEh1V6k80+aBgM5qNOMGGEzizeMCJYYem
         fBNdTdB0jDsyscQWVWyUo+eI1612DVr5Rr/8bN08rCFpELdvRFnzbYNCbs/0FqHPHXMW
         Kipw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=zJDk2Ph0+FtMqenuPf0bRdXlnKpHvlRTbA2oax9MpNs=;
        b=cxnAI1OJJR5nEI+Irj8/mHk1PFfdDLlr30NxOFyFr9oEVbpIeh2omNpkBH2beGi5it
         vePwfo8gCfgre+/1wk9F4iUgo/gvGMg6bY7HrNs3djkMhJK8V+gPgRZf4Xu3E8MdYcGb
         kyXFxmux66JPXRE2Na85yTQWw22EhCLJjqfNgRLCKS52uAi0GAjgeZMf6ofhb3jBgurg
         ndifZTKEz/M0dKkmzpbBXneXQXocPiBz0gSg16s7P4lX+DM57uo9zbgm98c4Dz2uv09T
         Bg5GASmETjNRx2Xq59OtvHpDx/hzDYKKowmDY2DdXCN5TA2puxXCB0m8hqvwar/mPP1h
         SENw==
X-Gm-Message-State: AJIora/c0nsMORiQPGajkIyePZo1ks3t0ngfxdOArx/2BOZ9yejCcGz+
        FQY/jJwWW477ZGQ7P+eZLUNwxg==
X-Google-Smtp-Source: AGRyM1svStgYeX70sDYDuTu0o1JSlfhqD48SqbPfqvnuAb/kAIB2nIC+w7+ZzxK6InbrsWEYln7Tyw==
X-Received: by 2002:a17:902:f691:b0:16c:4043:f6a2 with SMTP id l17-20020a170902f69100b0016c4043f6a2mr27617884plg.72.1658151677174;
        Mon, 18 Jul 2022 06:41:17 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v1-20020a17090a0c8100b001efc46f7eaesm11630473pja.5.2022.07.18.06.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 06:41:16 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     dylany@fb.com, asml.silence@gmail.com
Cc:     Kernel-team@fb.com, io-uring@vger.kernel.org
In-Reply-To: <20220718133429.726628-1-dylany@fb.com>
References: <20220718133429.726628-1-dylany@fb.com>
Subject: Re: [PATCH liburing] fix io_uring_recvmsg_cmsg_nexthdr logic
Message-Id: <165815167652.7985.13810648472432800447.b4-ty@kernel.dk>
Date:   Mon, 18 Jul 2022 07:41:16 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 18 Jul 2022 06:34:29 -0700, Dylan Yudaken wrote:
> io_uring_recvmsg_cmsg_nexthdr was using the payload to delineate the end
> of the cmsg list, but really it needs to use whatever was returned by the
> kernel.
> 
> 

Applied, thanks!

[1/1] fix io_uring_recvmsg_cmsg_nexthdr logic
      commit: 4e6eec8bdea906fe5341c97aef96986d605004e9

Best regards,
-- 
Jens Axboe



Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 558C7662CD0
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 18:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236755AbjAIRdO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 12:33:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbjAIRdH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 12:33:07 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB5C8101DA
        for <io-uring@vger.kernel.org>; Mon,  9 Jan 2023 09:33:06 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id v65so584238ioe.4
        for <io-uring@vger.kernel.org>; Mon, 09 Jan 2023 09:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y8Q4p6rU6c9OzIFkWL6sttPdUQErnGdh25KcBQEV6iI=;
        b=wNvFjbZS1nt+1ZM7X8pFem3DvwRiLl5vWnMQCwPnnxy51uW5npnxPEaVrxnJwFQlms
         6UAEPFW3hh57gM986lrDtXMy3bQWXH9XIY01DXaqsyervjuB9IwpH7+5f9CtsmIWFbP8
         RcgkzooRmJ8vKNtN+Ptk9D2oGnsKHeserw115LQqa66KmNyFlcLz63F1FFLm5HcUMNub
         JzRadtTBEqMFmORufgJuMAg+sOXdZKba7e9OacLN8nOISJKc1OnesWewslsnSzlq3z9q
         KWg9R+CwEFGm/GNCU7AbMjcU1Jtt8ShEGDBwbnf0N9a1AUgB5wrLTQ/HBnSmH0dQUmnB
         +QSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y8Q4p6rU6c9OzIFkWL6sttPdUQErnGdh25KcBQEV6iI=;
        b=FHKgXLqL5RzXC7Aoro/dNO3xxN6uP7bu5k0Yyny6C2m32nO5CqP9Aj+pxYr3yT14zs
         aRHuYwe0YHSaBSe/5v4EBSwTEyW2l7Yko+gsAGVDACn0/6zcmNQRRcFxaZwH9DJJd2op
         FlbTeHjYRQ8PSKPWAbymK+j38TGMU8PlNy1MbcCzG22SGkLu0ooEOwqmBr3ZQEnc/pNe
         xmi/ncRjwLSTcyNTek6FsoBwnjVYTLDX7Glw059mPB3Vn7aKXjhnrmF46zMfAOcuyCJL
         AwdDlhrrNVdScdn4XSPkw9eyNGGbwRVR+gtzokLnGW2dXWPro24u9nSWkddhUCxZJJxT
         aW6w==
X-Gm-Message-State: AFqh2kqCIwD6/FRfh/Ws497ZZDZDSjqp5xAui0jy0sptLNanFnGPOSap
        LuKNTXSq26XY0Xs8hd1qWvZ7Bg==
X-Google-Smtp-Source: AMrXdXuYjtXYmdSGzzEoRku3xVohwQEtb/gUr9N8/3GLMbfbWh6Pcn0pcEoG/OBrLhTxadkqeV8o7w==
X-Received: by 2002:a05:6602:2439:b0:6dd:7096:d9bc with SMTP id g25-20020a056602243900b006dd7096d9bcmr9162113iob.2.1673285586023;
        Mon, 09 Jan 2023 09:33:06 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y15-20020a056602178f00b006dfbe8b14cdsm3495452iox.8.2023.01.09.09.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 09:33:05 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     dylany@meta.com, asml.silence@gmail.com, io-uring@vger.kernel.org,
        leitao@debian.org
Cc:     leit@meta.com, linux-kernel@vger.kernel.org
In-Reply-To: <20230103160507.617416-1-leitao@debian.org>
References: <20230103160507.617416-1-leitao@debian.org>
Subject: Re: [PATCH] io_uring/msg_ring: Pass custom flags to the cqe
Message-Id: <167328558540.13786.2667566038802749611.b4-ty@kernel.dk>
Date:   Mon, 09 Jan 2023 10:33:05 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-cc11a
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Tue, 03 Jan 2023 08:05:07 -0800, leitao@debian.org wrote:
> This patch adds a new flag (IORING_MSG_RING_FLAGS_PASS) in the message
> ring operations (IORING_OP_MSG_RING). This new flag enables the sender
> to specify custom flags, which will be copied over to cqe->flags in the
> receiving ring.  These custom flags should be specified using the
> sqe->file_index field.
> 
> This mechanism provides additional flexibility when sending messages
> between rings.
> 
> [...]

Applied, thanks!

[1/1] io_uring/msg_ring: Pass custom flags to the cqe
      commit: 5ab697ff917844acbd898009261fb0c2f0faec54

Best regards,
-- 
Jens Axboe



Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51806561E7E
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 16:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235010AbiF3O4o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 10:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235493AbiF3O4n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 10:56:43 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3961D32C
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:56:42 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id y18so19388110iof.2
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=j8i0CmQFu4oh9izqSE0cuzTurgmheFgs9TAW3kZ1cds=;
        b=cJV2xRxJ5+NPFoK84lFxnTGQlBNuoTNHa39T+LFztHGGFUFWZPXK7yGpk88CksSghL
         e8EXK0xp74gfxl7nSTYDEiU9yOJ4751l1VH93WhL7Yx6LV23ZrNjC4QDAP7f0FNOLh1p
         cdcAn/VDWRdjaM1i/BXHxzeq0O6U2eRLR5fcbnkkE4jMdSJzNURcBxKLGkP/XLVmKDPa
         ZZsAozV0SMlMXVYAaW/aM0coHh7KUqLZvuf87yVsssTzf397Q7lUAIF0lqvgR6ojl/27
         WgRqaJ7CPZ8KRdqrICb13Ydwt3GJQy0ftu9n+6sEFD4q3lqX5/bk17ElFdqp3ifL5h6n
         2v7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=j8i0CmQFu4oh9izqSE0cuzTurgmheFgs9TAW3kZ1cds=;
        b=wbJvTtKQ/PHaT9031k9ZlyRyDVwQ2KfDaJ4QCzzTO7gQymmjlEVWIkpnCycyBBtQZd
         YDUZbA9k4b+gpAi39tKTSyczItlvloRG9zh+z38S8rDUvyp9XGLUN5Bm2zdWzQXsk1xG
         gk51zF/v8y15c9ozCbe8aSEllyQtQj8IOq52FCg9Whoe8LyyFvbHLsY2CKmpPGMTybf3
         YGFcI71L88aV571wuQLpk85+gfjv15kSrpB1LfcpNrc0iOggMHQo+mHeiPHEt70dbnGi
         ci0J1nRN/9vXD9L6yyARdPf8cssgzYo3ZcJoQwRpZLf2ydFiX9xNfkvzhXb1kpiAJZCb
         gj1g==
X-Gm-Message-State: AJIora8s4Z3qSdU0qBdn6xcSI8L1vr+IBDeLxGk6csU5Ylih+QeIhswc
        M4b4jVSxhFfBzJ842z0ce5Xdug==
X-Google-Smtp-Source: AGRyM1u+Zs15UVbpI+1bsaHbTe/K7iQVPpQZZpvYDP8DlD/XYlH2HvwvmAhk2fMreBtHJj426gbm7A==
X-Received: by 2002:a02:ccd3:0:b0:33c:8da4:b147 with SMTP id k19-20020a02ccd3000000b0033c8da4b147mr5578119jaq.21.1656601001756;
        Thu, 30 Jun 2022 07:56:41 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a11-20020a92d58b000000b002d8f2385d56sm8114297iln.63.2022.06.30.07.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 07:56:41 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     dylany@fb.com, asml.silence@gmail.com, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Kernel-team@fb.com
In-Reply-To: <20220630132006.2825668-1-dylany@fb.com>
References: <20220630132006.2825668-1-dylany@fb.com>
Subject: Re: [PATCH 5.19] io_uring: fix provided buffer import
Message-Id: <165660100106.535585.6996984430706147142.b4-ty@kernel.dk>
Date:   Thu, 30 Jun 2022 08:56:41 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 30 Jun 2022 06:20:06 -0700, Dylan Yudaken wrote:
> io_import_iovec uses the s pointer, but this was changed immediately
> after the iovec was re-imported and so it was imported into the wrong
> place.
> 
> Change the ordering.
> 
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix provided buffer import
      commit: ee10e6851a687c58f516dc924034cb62c7a01e14

Best regards,
-- 
Jens Axboe


